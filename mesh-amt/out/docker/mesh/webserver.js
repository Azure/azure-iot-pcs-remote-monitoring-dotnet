﻿/**
* @description MeshCommander web server
* @author Ylian Saint-Hilaire
* @copyright Intel Corporation 2018
* @license Apache-2.0
* @version v0.0.3
*/

module.exports.CreateWebServer = function (parent, args) {
    var obj = {};
    
    obj.fs = require('fs');
    obj.net = require('net');
    obj.tls = require('tls');
    obj.path = require('path');
    obj.args = args;
    obj.express = require('express');
    obj.app = obj.express();
    obj.expressWs = require('express-ws')(obj.app);
    obj.interceptor = require('./interceptor.js');
    obj.common = require('./common.js');
    obj.constants = require('constants');
    obj.parent = parent;
    obj.users = {};

    obj.notifyUsers = function (msg) {
        for (var i in obj.users) {
            try {                
                obj.users[i].send(JSON.stringify(msg));
            } catch (e) { console.log(e);}
        }
    }
    obj.debug = function (msg) { if (args.debug) { console.log(msg); } }
    
    
    // Indicates to ExpressJS that the public folder should be used to serve static files. Mesh Commander will be at "default.htm".
    obj.app.use(obj.express.static(obj.path.join(__dirname, 'public')));
    
    // Indicates that any request to "/" should be redirected to "/default.htm" which is the Mesh Commander web application.
    obj.app.get('/', function (req, res) {
        res.set({ 'Cache-Control': 'no-cache, no-store, must-revalidate', 'Pragma': 'no-cache', 'Expires': '0' });
        res.redirect('/index.htm');
    });
        
    obj.app.get('/MPSRootCertificate.cer', function (req, res) {
        res.set({ 'Cache-Control': 'no-cache, no-store, must-revalidate', 'Pragma': 'no-cache', 'Expires': '0', 'Content-Type': 'application/octet-stream', 'Content-Disposition': 'attachment; filename=MPSRootCertificate.cer' });
        res.send(obj.fs.readFileSync("private/root.cer"));        
    });
    
    // For the server version of Mesh Commander, we send the computer list without credential and insertion credentials in the stream.
    obj.app.get('/webrelay.ashx', function (req, res) {        
        res.set({ 'Cache-Control': 'no-cache, no-store, must-revalidate', 'Pragma': 'no-cache', 'Expires': '0' });
        if (req.query.action == 'getcomputerlist') {
            var amtcreds = {};            
            try {
                amtcreds = JSON.parse(obj.fs.readFileSync("private/credentials.json"));
            } catch (e) { console.log(e); }
            var list = [];            
            for (var i in obj.parent.mpsComputerList) {                
                obj.parent.mpsComputerList[i].user = amtcreds[i] ? amtcreds[i].amtuser : "admin";
                var entry = obj.common.Clone(obj.parent.mpsComputerList[i]);
                delete entry.pass; 
                list.push(entry);
            } 
            res.set({ 'Content-Type': 'application/json' });
            res.send(JSON.stringify(list));
        }  else if (req.query.action == 'getallcomputer') {
            var amtcreds = {};            
            try {
                amtcreds = JSON.parse(obj.fs.readFileSync("private/credentials.json"));
            } catch (e) { console.log(e); }
            var list = [];            
            for (var i in obj.parent.mpsComputerList) {                
                obj.parent.mpsComputerList[i].user = amtcreds[i] ? amtcreds[i].amtuser : "admin";
                var entry = obj.common.Clone(obj.parent.mpsComputerList[i]);                
                delete entry.pass; 
                //add icon and conn                
                entry.icon = 1;
                entry.conn = 1;
                list.push(entry);
                // remove from credential list all that is online
                if (amtcreds[i]) { delete amtcreds[i] };
            } 
            for (var i in amtcreds) {
                var entry = obj.common.Clone(amtcreds[i]);                
                delete entry.pass;
                if (!entry.name) entry.name = i;
                entry.host = i;
                //add icon and conn
                entry.icon = 1;
                entry.conn = 0;
                list.push(entry);
            }
            res.set({ 'Content-Type': 'application/json' });
            res.send(JSON.stringify(list));
        }

        try { res.close(); } catch (e) { }
    });

    obj.app.ws('/control.ashx', function (ws, req) {
        obj.users[ws] = ws;
        console.log("New control websocket.");
        ws.on('message', function (msg) {
            obj.debug("Incoming control message from browser: "+ msg);
        });

        ws.on('close', function (req) {            
            obj.debug("Closing control websocket.");
            delete obj.users[ws];
        });
    });
    // Indicates to ExpressJS what we want to handle websocket requests on "/webrelay.ashx". This is the same URL as IIS making things simple, we can use the same web application for both IIS and Node.
    obj.app.ws('/webrelay.ashx', function (ws, req) {
        ws.pause();

        // When data is received from the web socket, forward the data into the associated TCP connection.
        // If the TCP connection is pending, buffer up the data until it connects.
        ws.on('message', function (msg) {
            // Convert a buffer into a string, "msg = msg.toString('ascii');" does not work
            //var msg2 = "";
            //for (var i = 0; i < msg.length; i++) { msg2 += String.fromCharCode(msg[i]); }
            //msg = msg2;
            msg=msg.toString("binary");
            
            if (ws.interceptor) {
                msg = ws.interceptor.processBrowserData(msg); 
            } // Run data thru interceptor
            ws.forwardclient.write(msg); // Forward data to the associated TCP connection.
        });
        
        // If the web socket is closed, close the associated TCP connection.
        ws.on('close', function (req) {
            obj.debug('Closing web socket connection to ' + ws.upgradeReq.query.host + ':' + ws.upgradeReq.query.port + '.');
            if (ws.forwardclient) { 
                if (ws.forwardclient.close) { ws.forwardclient.close(); } 
                try { ws.forwardclient.destroy(); } catch (e) { } 
            }
        });
        
        // We got a new web socket connection, initiate a TCP connection to the target Intel AMT host/port.
        obj.debug('Opening web socket connection to ' + req.query.host + ':' + req.query.port + '.');
        // Fetch Intel AMT credentials & Setup interceptor
        var credentials = obj.getAmtPassword(req.query.host);
        if (credentials != null) {
            obj.debug("Creating credential");
            if (req.query.p == 1) { ws.interceptor = obj.interceptor.CreateHttpInterceptor({ host: req.query.host, port: req.query.port, user: credentials[0], pass: credentials[1] }); }
            else if (req.query.p == 2) { ws.interceptor = obj.interceptor.CreateRedirInterceptor({ user: credentials[0], pass: credentials[1] }); }
        }
        
        if (req.query.tls == 0) {
            // If this is TCP (without TLS) set a normal TCP socket
            // check if this is MPS connection
            var uuid = obj.getAmtCIRAUUID(req.query.host);
            if (uuid) {
                var ciraconn = obj.parent.mpsserver.ciraConnections[uuid];
                ws.forwardclient = obj.parent.mpsserver.SetupCiraChannel(ciraconn,req.query.port);
                ws.forwardclient.xtls = 0;
                ws.forwardclient.onData = function (ciraconn, data) {
                    // Run data thru interceptor
                    if (ws.interceptor) {
                        data = ws.interceptor.processAmtData(data);
                    } 
                    try {
                        ws.send(data);
                    } catch (e) { }
                }

                ws.forwardclient.onStateChange = function (ciraconn, state) {
                    //console.log('Relay CIRA state change:'+state);
                    if (state == 0) { try { 
                        //console.log("Closing websocket.");
                        ws.close(); 
                    } catch (e) { } }
                }
                ws.resume();
            } else {
                ws.forwardclient = new obj.net.Socket();
                ws.forwardclient.setEncoding('binary');
                ws.forwardclient.forwardwsocket = ws;
            }
        } else {
            // If TLS is going to be used, setup a TLS socket
            var tlsoptions = { secureProtocol: ((req.query.tls1only == 1) ? 'TLSv1_method' : 'SSLv23_method'), ciphers: 'RSA+AES:!aNULL:!MD5:!DSS', secureOptions: obj.constants.SSL_OP_NO_SSLv2 | obj.constants.SSL_OP_NO_SSLv3 | obj.constants.SSL_OP_NO_COMPRESSION | obj.constants.SSL_OP_CIPHER_SERVER_PREFERENCE, rejectUnauthorized: false };
            ws.forwardclient = obj.tls.connect(req.query.port, req.query.host, tlsoptions, function () {
                // The TLS connection method is the same as TCP, but located a bit differently.
                obj.debug('TLS connected to ' + req.query.host + ':' + req.query.port + '.');
                ws.resume();
            });
            ws.forwardclient.setEncoding('binary');
            ws.forwardclient.forwardwsocket = ws;
        }
        
        // When we receive data on the TCP connection, forward it back into the web socket connection.
        ws.forwardclient.on('data', function (data) {
            if (ws.interceptor) { data = ws.interceptor.processAmtData(data); } // Run data thru interceptor
            try { 
                ws.send(data); 
            } catch (e) { }
        });

        // If the TCP connection closes, disconnect the associated web socket.
        ws.forwardclient.on('close', function () {
            obj.debug('TCP disconnected from ' + req.query.host + ':' + req.query.port + '.');
            try { ws.close(); } catch (e) { }
        });
        
        // If the TCP connection causes an error, disconnect the associated web socket.
        ws.forwardclient.on('error', function (err) {
            obj.debug('TCP disconnected with error from ' + req.query.host + ':' + req.query.port + ': ' + err.code + ', ' + req.url);
            try { ws.close(); } catch (e) { }
        });
        
        
        if (req.query.tls == 0) {
            if (!obj.parent.mpsComputerList[req.query.host]) {
                // A TCP connection to Intel AMT just connected, send any pending data and start forwarding.
                ws.forwardclient.connect(req.query.port, req.query.host, function () {
                    obj.debug('TCP connected to ' + req.query.host + ':' + req.query.port + '.');
                    ws.resume();
                });
            }
        }
    });

    obj.getRootCertBase64 = function(path) {
        var rootcert = obj.fs.readFileSync(path,'utf8');
        var i = rootcert.indexOf("-----BEGIN CERTIFICATE-----\r\n");
        if (i >= 0) { rootcert = rootcert.substring(i + 29); }
        i = rootcert.indexOf("-----END CERTIFICATE-----");
        if (i >= 0) { rootcert = rootcert.substring(i, 0); }
        return new Buffer(rootcert, 'base64').toString('base64');
    }

    // Start the ExpressJS web server
    if (args.port != null) { port = parseInt(args.port); }
    if (isNaN(port) || (port == null) || (typeof port != 'number') || (port < 0) || (port > 65536)) { port = 3000; }
    if (args.any != null) {
        obj.app.listen(port, function () { console.log('MeshCommander running on http://*:' + port + '.'); });
    } else {
        obj.app.listen(port, '0.0.0.0', function () { console.log('MeshCommander running on http://127.0.0.1:' + port + '.'); });
    }

    return obj;
}