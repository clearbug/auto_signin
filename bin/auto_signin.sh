#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const colors = require('colors');
const program = require('commander');

const config = require('../config/config.json');

const support_sites = config.support_sites; 

program
	.version(require('../package.json').version)
	.usage('<site-name>')
	.option('-i, --personalinfo', 'Show your detail config')
	.option('-u, --username <your username>', 'Set your username of the site')
	.option('-p, --password <your password>', 'Set your password of the site')
	.option('-s, --show <isShow>', 'Set nightmare show')
	.parse(process.argv);

if(program.personalinfo) {
	console.dir(config);
	process.exit();
}

if(program.show) {
	if(program.show == 'true') {
		config.nightmare.show = true;
	} else if(program.show == 'false') {
		config.nightmare.show = false;
	} else {
		console.log(colors.red('Error: please set the nightmare show to true or false.'));
	}
	console.log(colors.green(`Congratulate, success to set the show to ${config.nightmare.show}.`));
	fs.writeFileSync(path.join(path.parse(__dirname).dir, 'config/config.json'), JSON.stringify(config));
	process.exit();
}

if(program.username || program.password) {
	if(!config.site) {
		console.log(colors.red('Error: Before set the username or password, please to set the site.'));
		process.exit();
	}
	if(program.username) {
		config.accounts[config.site].username = program.username;
	}
	if(program.password) {
		config.accounts[config.site].password = program.password;
	}
	fs.writeFileSync(path.join(path.parse(__dirname).dir, 'config/config.json'), JSON.stringify(config));
	process.exit();
}

var site_name = program.args[0];
if(!site_name) {
	program.help(txt => colors.red(txt));
}
if(!support_sites.includes(site_name)) {
	console.log(colors.red(`Error: site now just support [${support_sites}] .`));
	process.exit();
}
config.site = site_name;
config.accounts[config.site] = config.accounts[config.site] ? config.accounts[config.site] : {};
fs.writeFileSync(path.join(path.parse(__dirname).dir, 'config/config.json'), JSON.stringify(config));
console.log(colors.green(`Congratulate, success to set the site to ${config.site}.`));
