/**
* @description MeshCentral Common Library
* @author Ylian Saint-Hilaire
* @copyright Intel Corporation 2018
* @license Apache-2.0
* @version v0.0.1
*/

const crypto = require('crypto');

// Binary encoding and decoding functions
module.exports.ReadShort = function(v, p) { return (v.charCodeAt(p) << 8) + v.charCodeAt(p + 1); }
module.exports.ReadShortX = function(v, p) { return (v.charCodeAt(p + 1) << 8) + v.charCodeAt(p); }
module.exports.ReadInt = function(v, p) { return (v.charCodeAt(p) * 0x1000000) + (v.charCodeAt(p + 1) << 16) + (v.charCodeAt(p + 2) << 8) + v.charCodeAt(p + 3); } // We use "*0x1000000" instead of "<<24" because the shift converts the number to signed int32.
module.exports.ReadIntX = function(v, p) { return (v.charCodeAt(p + 3) * 0x1000000) + (v.charCodeAt(p + 2) << 16) + (v.charCodeAt(p + 1) << 8) + v.charCodeAt(p); }
module.exports.ShortToStr = function(v) { return String.fromCharCode((v >> 8) & 0xFF, v & 0xFF); }
module.exports.ShortToStrX = function(v) { return String.fromCharCode(v & 0xFF, (v >> 8) & 0xFF); }
module.exports.IntToStr = function(v) { return String.fromCharCode((v >> 24) & 0xFF, (v >> 16) & 0xFF, (v >> 8) & 0xFF, v & 0xFF); }
module.exports.IntToStrX = function(v) { return String.fromCharCode(v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF, (v >> 24) & 0xFF); }
module.exports.MakeToArray = function(v) { if (!v || v == null || typeof v == 'object') return v; return [v]; }
module.exports.SplitArray = function(v) { return v.split(','); }
module.exports.Clone = function(v) { return JSON.parse(JSON.stringify(v)); }
module.exports.IsFilenameValid = (function () { var x1 = /^[^\\/:\*\?"<>\|]+$/, x2 = /^\./, x3 = /^(nul|prn|con|lpt[0-9]|com[0-9])(\.|$)/i; return function isFilenameValid(fname) { return module.exports.validateString(fname, 1, 4096) && x1.test(fname) && !x2.test(fname) && !x3.test(fname) && (fname[0] != '.'); } })();

// Move an element from one position in an array to a new position
module.exports.ArrayElementMove = function(arr, from, to) { arr.splice(to, 0, arr.splice(from, 1)[0]); };

// Print object for HTML
module.exports.ObjectToStringEx = function(x, c) {
    var r = "";
    if (x != 0 && (!x || x == null)) return "(Null)";
    if (x instanceof Array) { for (var i in x) { r += '<br />' + gap(c) + "Item #" + i + ": " + module.exports.ObjectToStringEx(x[i], c + 1); } }
    else if (x instanceof Object) { for (var i in x) { r += '<br />' + gap(c) + i + " = " + module.exports.ObjectToStringEx(x[i], c + 1); } }
    else { r += x; }
    return r;
}

// Print object for console
module.exports.ObjectToStringEx2 = function(x, c) {
    var r = "";
    if (x != 0 && (!x || x == null)) return "(Null)";
    if (x instanceof Array) { for (var i in x) { r += '\r\n' + gap2(c) + "Item #" + i + ": " + module.exports.ObjectToStringEx2(x[i], c + 1); } }
    else if (x instanceof Object) { for (var i in x) { r += '\r\n' + gap2(c) + i + " = " + module.exports.ObjectToStringEx2(x[i], c + 1); } }
    else { r += x; }
    return r;
}

// Create an ident gap
module.exports.gap = function(c) { var x = ''; for (var i = 0; i < (c * 4) ; i++) { x += '&nbsp;'; } return x; }
module.exports.gap2 = function(c) { var x = ''; for (var i = 0; i < (c * 4) ; i++) { x += ' '; } return x; }

// Print an object in html
module.exports.ObjectToString = function(x) { return module.exports.ObjectToStringEx(x, 0); }
module.exports.ObjectToString2 = function(x) { return module.exports.ObjectToStringEx2(x, 0); }

// Convert a hex string to a raw string
module.exports.hex2rstr = function(d) {
    var r = '', m = ('' + d).match(/../g), t;
    while (t = m.shift()) r += String.fromCharCode('0x' + t);
    return r
}

// Convert decimal to hex
module.exports.char2hex = function(i) { return (i + 0x100).toString(16).substr(-2).toUpperCase(); }

// Convert a raw string to a hex string
module.exports.rstr2hex = function(input) {
    var r = '', i;
    for (i = 0; i < input.length; i++) { r += module.exports.char2hex(input.charCodeAt(i)); }
    return r;
}

// UTF-8 encoding & decoding functions
module.exports.encode_utf8 = function(s) { return unescape(encodeURIComponent(s)); }
module.exports.decode_utf8 = function(s) { return decodeURIComponent(escape(s)); }

// Convert a string into a blob
module.exports.data2blob = function(data) {
    var bytes = new Array(data.length);
    for (var i = 0; i < data.length; i++) bytes[i] = data.charCodeAt(i);
    var blob = new Blob([new Uint8Array(bytes)]);
    return blob;
}

// Generate random numbers
module.exports.random = function (max) { return Math.floor(Math.random() * max); }

// Split a comma seperated string, ignoring commas in quotes.
module.exports.quoteSplit = function (str) {
    var tmp = '', quote = 0, result = [];
    for (var i in str) { if (str[i] == '"') { quote = (quote + 1) % 2; } if ((str[i] == ',') && (quote == 0)) { tmp = tmp.trim(); result.push(tmp); tmp = ''; } else { tmp += str[i]; } }
    if (tmp.length > 0) result.push(tmp.trim());
    return result;
}

// Convert list of "name = value" into object
module.exports.parseNameValueList = function (list) {
    var result = [];
    for (var i in list) {
        var j = list[i].indexOf('=');
        if (j > 0) {
            var v = list[i].substring(j + 1).trim();
            if ((v[0] == '"') && (v[v.length - 1] == '"')) { v = v.substring(1, v.length - 1); }
            result[list[i].substring(0, j).trim()] = v;
        }
    }
    return result;
}

// Compute the MD5 digest hash for a set of values
module.exports.ComputeDigesthash = function (username, password, realm, method, path, qop, nonce, nc, cnonce) {
    var ha1 = crypto.createHash('md5').update(username + ":" + realm + ":" + password).digest("hex");
    var ha2 = crypto.createHash('md5').update(method + ":" + path).digest("hex");
    return crypto.createHash('md5').update(ha1 + ":" + nonce + ":" + nc + ":" + cnonce + ":" + qop + ":" + ha2).digest("hex");
}

module.exports.toNumber = function (str) { var x = parseInt(str); if (x == str) return x; return str; }
module.exports.escapeHtml = function (string) { return String(string).replace(/[&<>"'`=\/]/g, function (s) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;', '/': '&#x2F;', '`': '&#x60;', '=': '&#x3D;' }[s]; }); }
module.exports.escapeHtmlBreaks = function (string) { return String(string).replace(/[&<>"'`=\/]/g, function (s) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;', '/': '&#x2F;', '`': '&#x60;', '=': '&#x3D;', '\r': '<br />', '\n': '' }[s]; }); }

// Lowercase all the names in a object recursively
module.exports.objKeysToLower = function (obj) {
    for (var i in obj) {
        if (i.toLowerCase() !== i) { obj[i.toLowerCase()] = obj[i]; delete obj[i]; } // LowerCase all key names
        if (typeof obj[i] == 'object') { module.exports.objKeysToLower(obj[i]); } // LowerCase all key names in the child object
    } 
    return obj;
}

// Validation methods
module.exports.validateString = function(str, minlen, maxlen) { return ((str != null) && (typeof str == 'string') && ((minlen == null) || (str.length >= minlen)) && ((maxlen == null) || (str.length <= maxlen))); }
module.exports.validateInt = function(int, minval, maxval) { return ((int != null) && (typeof int == 'number') && ((minval == null) || (int >= minval)) && ((maxval == null) || (int <= maxval))); }
module.exports.validateArray = function (array, minlen, maxlen) { return ((array != null) && Array.isArray(array) && ((minlen == null) || (array.length >= minlen)) && ((maxlen == null) || (array.length <= maxlen))); }
module.exports.validateStrArray = function (array, minlen, maxlen) { if (((array != null) && Array.isArray(array)) == false) return false; for (var i in array) { if ((typeof array[i] != 'string') && ((minlen == null) || (array[i].length >= minlen)) && ((maxlen == null) || (array[i].length <= maxlen))) return false; } return true; }
module.exports.validateObject = function (obj) { return ((obj != null) && (typeof obj == 'object')); }
module.exports.validateEmail = function (email, minlen, maxlen) { if (module.exports.validateString(email, minlen, maxlen) == false) return false; var emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/; return emailReg.test(email); } 
module.exports.validateUsername = function (username, minlen, maxlen) { return (module.exports.validateString(username, minlen, maxlen) && (username.indexOf(' ') == -1)); }