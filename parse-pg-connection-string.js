var argv = require('node:process').argv;
var parse = require('pg-connection-string').parse;

var args = argv.slice(2);

var pgConnectionString = args[0];
var key = args[1];

var config = parse(argv.slice(2)[0]);

console.log(config[key]);