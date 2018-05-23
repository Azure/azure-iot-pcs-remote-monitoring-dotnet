/**
 * @description MPS microservice main module
 * @author Joko Banu Sastriawan
 * @copyright Intel Corporation 2018
 * @license Apache-2.0
 * @version 0.0.1
 */

var CreateMPSMicroservice = function (db, args, certificates) {
    var obj = {};
    obj.db = db;
    obj.args = args;
    obj.debugLevel = 0;
    obj.certificates = certificates;
    obj.mpsComputerList = {};
    obj.webserver = null;
    obj.mpsserver = null;

    obj.Start = function () {
        obj.mpsserver = require('./mpsserver.js').CreateMpsServer(obj,obj.db,obj.args,obj.certificates);
        obj.webserver = require('./webserver.js').CreateWebServer(obj, obj.args);
    }

    obj.CIRAConnected = function(guid) {
        console.log("Main:CIRA connection established for "+guid);
        if (obj.webserver) {
            obj.webserver.notifyUsers({ host: guid, event: "node_connection", status: "connected"});
        }
    }

    obj.CIRADisconnected = function(guid) {
        console.log("Main:CIRA connection closed for "+guid);
        delete obj.mpsComputerList[guid];
        if (obj.webserver) {
            obj.webserver.notifyUsers({ host: guid, event: "node_connection", status: "disconnected"});
        }
    }

    return obj;
};

var fs = require('fs');

// Parsing configuration
var config = {};
try {
    config = JSON.parse(fs.readFileSync('private/config.json'));
} catch (e) {
    console.log("Exception: "+e);
}

// DB initialization
var mps_db = require('./db.js').CreateDb(config, null);

//certificate operations
var certificates = { root: {}, mps: {}};
var certoperation = require('./certoperations.js').CertificateOperations();
var rootCertificate, rootPrivateKey, rootCertAndKey;
if (fs.existsSync('private/root-cert-public.crt') && fs.existsSync('private/root-cert-private.key')) {
    //load certificate
    rootCertificate = fs.readFileSync('private/root-cert-public.crt', 'utf8');
    rootPrivateKey = fs.readFileSync('private/root-cert-private.key', 'utf8');
    rootCertAndKey = { cert: certoperation.pki.certificateFromPem(rootCertificate), key: certoperation.pki.privateKeyFromPem(rootPrivateKey) }
} else {
    console.log('Generating Root certificate...');
    rootCertAndKey = certoperation.GenerateRootCertificate(true, 'MeshCentralRoot', null, null, true);
    rootCertificate = certoperation.pki.certificateToPem(rootCertAndKey.cert);
    rootPrivateKey = certoperation.pki.privateKeyToPem(rootCertAndKey.key);
    fs.writeFileSync('private/root-cert-public.crt', rootCertificate);
    fs.writeFileSync('private/root-cert-private.key', rootPrivateKey);
}
certificates.root.cert = rootCertificate;
certificates.root.key = rootPrivateKey;

var mpsCertAndKey, mpsCertificate, mpsPrivateKey;
if (fs.existsSync('private/mpsserver-cert-public.crt') && fs.existsSync('private/mpsserver-cert-private.key')) {
    // Keep the console certificate we have
    mpsCertificate = fs.readFileSync('private/mpsserver-cert-public.crt', 'utf8');
    mpsPrivateKey = fs.readFileSync('private/mpsserver-cert-private.key', 'utf8');
    mpsCertAndKey = { cert: certoperation.pki.certificateFromPem(mpsCertificate), key: certoperation.pki.privateKeyFromPem(mpsPrivateKey) };
} else {
    console.log('Generating Intel AMT MPS certificate...');
    mpsCertAndKey = certoperation.IssueWebServerCertificate(rootCertAndKey, false, config.commonName, config.country, config.organization, null, false);
    mpsCertificate = certoperation.pki.certificateToPem(mpsCertAndKey.cert);
    mpsPrivateKey = certoperation.pki.privateKeyToPem(mpsCertAndKey.key);
    fs.writeFileSync('private/mpsserver-cert-public.crt', mpsCertificate);
    fs.writeFileSync('private/mpsserver-cert-private.key', mpsPrivateKey);
}
certificates.mps.cert = mpsCertificate;
certificates.mps.key = mpsPrivateKey;
if (!fs.existsSync('private/root.cer')) {
    var rootcert = certificates.root.cert;
    var i = rootcert.indexOf("-----BEGIN CERTIFICATE-----\r\n");
    if (i >= 0) { rootcert = rootcert.substring(i + 29); }
    i = rootcert.indexOf("-----END CERTIFICATE-----");
    if (i >= 0) { rootcert = rootcert.substring(i, 0); }
    fs.writeFileSync('private/root.cer', new Buffer(rootcert, 'base64'));
}
certificates.CommonName = mpsCertAndKey.cert.subject.getField('CN').value;

// Initialize MPS Microservice and start
var mpsusvc = CreateMPSMicroservice(mps_db, config, certificates);
mpsusvc.Start();
