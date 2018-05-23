var assert = require('assert');
describe("Use GUID whitelisting: ", function(){
    var db = require('../db.js').CreateDb({usewhitelist:true},null); 
    it('Test if listed GUID is allowed', function () {   
        db.IsGUIDApproved("12345678-9abc-def1-2345-123456789000", function (ret) { 
            assert.equal(true, ret, "Whitelisted GUID is not allowed");
        });
    });

    it('Test if non listed GUID is not allowed', function () {
        db.IsGUIDApproved("12345678-9abc-def1-2345-123456789001", function (ret) {
            assert.equal(false, ret, "Non Whitelisted GUID allowed");
        });
    });

});

describe("Do not use GUID whitelisting: ", function(){
    var db = require('../db.js').CreateDb(null,null); 
    it('Test if listed GUID is allowed', function () {   
        db.IsGUIDApproved("12345678-9abc-def1-2345-123456789000", function (ret) { 
            assert.equal(true, ret, "Whitelisted GUID is not allowed");
        });
    });

    it('Test if non listed GUID is still allowed', function () {
        db.IsGUIDApproved("12345678-9abc-def1-2345-123456789001", function (ret) {
            assert.equal(true, ret, "Non Whitelisted GUID allowed");
        });
    });

});