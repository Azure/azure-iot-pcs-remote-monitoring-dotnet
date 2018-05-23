/**
 * @description Database backend for credentials
 * @author Joko Banu Sastriawan
 * @copyright Intel Corporation 2018
 * @license Apache-2.0
 * @version 0.0.1
 */

 module.exports.CreateDb = function(args, datapath) {
    var obj = {};
    obj.args = args;
    obj.datapath = datapath;
    var fs = require('fs');

    // Mock up code, real deployment must use proper data providers
    function getAllGUIDS() {
        var guids = [];
        try {
            guids = JSON.parse(fs.readFileSync("private/guids.json"));
        } catch (e) {}
        return guids;
    }

    function getAllOrgs() {
        var guids = [];
        try {
            guids = JSON.parse(fs.readFileSync("private/orgs.json"));
        } catch (e) {}
        return guids;
    }

    function getCredentialsForGuid(guid) {
        var credentials = {};
        try {
            credentials = JSON.parse(fs.readFileSync("private/credentials.json"));
        } catch (e) {
            credentials = {};
        }
        return credentials.guid;
    }

    // check if a GUID is allowed to connect
    obj.IsGUIDApproved = function(guid, func) {
        var result = false;
        if (obj.args && obj.args.usewhitelist) {
            var guids = getAllGUIDS();
            if (guids.indexOf(guid)>=0) { 
                result = true; 
            }
        } else {
            result = true;
        }
        if (func) { func(result)}
    }

    // check if a Organization is allowed to connect
    obj.IsOrgApproved = function(org, func) {
        var result = false;
        if (obj.args && obj.args.usewhitelist) {
            var orgs = getAllorgs();
            if (orgs.indexOf(org)>=0) { 
                result = true; 
            }
        } else {
            result = true;
        }
        if (func) { func(result)}
    }

    // CIRA auth
    obj.CIRAAuth = function(guid, username, password, func) {
        var result = false;
        var cred = getCredentialsForGuid(guid);
        if (cred && (cred.mpsuser == username)&&(cred.mpspass==password)) {
            result = true;
        } else if ((obj.args.mpsusername == username) && (obj.args.mpspass == password)) {
            result = true;
        }
        if (func) func(result);
    };

    return obj;
}