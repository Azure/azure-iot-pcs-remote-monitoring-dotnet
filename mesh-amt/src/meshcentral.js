
// Return the server configuration
function getConfig() {
    // Figure out the datapath location
    var fs = require('fs');
    var path = require('path');
    var datapath = null;
    var args = require('minimist')(process.argv.slice(2));
    if ((__dirname.endsWith('/node_modules/meshcentral')) || (__dirname.endsWith('\\node_modules\\meshcentral')) || (__dirname.endsWith('/node_modules/meshcentral/')) || (__dirname.endsWith('\\node_modules\\meshcentral\\'))) {
        datapath = path.join(__dirname, '../../meshcentral-data');
    } else {
        datapath = path.join(__dirname, '../meshcentral-data');
    }
    if (args.datapath) { datapath = args.datapath; }
    try { fs.mkdirSync(datapath); } catch (e) { }

    // Read configuration file if present and change arguments.
    var config = {}, configFilePath = path.join(datapath, 'config.json');
    if (fs.existsSync(configFilePath)) {
        // Load and validate the configuration file
        try { config = require(configFilePath); } catch (e) { console.log('ERROR: Unable to parse ' + configFilePath + '.'); return null; }
        if (config.domains == null) { config.domains = {}; }
        for (var i in config.domains) { if ((i.split('/').length > 1) || (i.split(' ').length > 1)) { console.log("ERROR: Error in config.json, domain names can't have spaces or /."); return null; } }
    } else {
        // Copy the "sample-config.json" to give users a starting point
        var sampleConfigPath = path.join(__dirname, 'sample-config.json');
        if (fs.existsSync(sampleConfigPath)) { fs.createReadStream(sampleConfigPath).pipe(fs.createWriteStream(configFilePath)); }
    }

    // Set the command line arguments to the config file if they are not present
    if (!config.settings) { config.settings = {}; }
    for (var i in args) { config.settings[i] = args[i]; }

    // Lower case all keys in the config file
    require('./common.js').objKeysToLower(config);
    return config;
}


// Detect CTRL-C on Linux and stop nicely
process.on('SIGINT', function () { if (meshserver != null) { meshserver.Stop(); meshserver = null; } console.log('Server Ctrl-C exit...'); process.exit(); });

// Load the really basic modules
var meshserver = null;
function mainStart(args) {
    InstallModules(['minimist'], function () {
        // Get the server configuration
        var config = getConfig();
        if (config == null) { process.exit(); }

        // Build the list of required modules
        var modules = ['ws', 'nedb', 'https', 'yauzl', 'xmldom', 'express', 'archiver', 'multiparty', 'node-forge', 'express-ws', 'compression', 'body-parser', 'connect-redis', 'express-session', 'express-handlebars'];
        if (require('os').platform() == 'win32') { modules.push('node-sspi'); modules.push('node-windows'); } // Add Windows modules
        if (config.letsencrypt != null) { modules.push('greenlock'); modules.push('le-store-certbot'); modules.push('le-challenge-fs'); modules.push('le-acme-core'); } // Add Greenlock Modules
        if (config.settings.mongodb != null) { modules.push('mongojs'); } // Add MongoDB
        if (config.smtp != null) { modules.push('nodemailer'); } // Add SMTP support

        // Install any missing modules and launch the server
        InstallModules(modules, function () { meshserver = CreateMeshCentralServer(config, args); meshserver.Start(); });
    });
}

if (require.main === module) {
    mainStart(require('minimist')(process.argv.slice(2))); // Called directly, launch normally.
} else {
    module.exports.mainStart = mainStart; // Required as a module, useful for winservice.js
}