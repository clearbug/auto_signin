#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const Nightmare = require('nightmare');
const colors = require('colors');

const logger = require('../utils/logger.js').logger('autosignin');

const config  = require('../config/config.json');

const nightmare = Nightmare(config.nightmare);
const account = config.accounts.jingdongjinrong;

// First check whether set the site
if(!account) {
	console.log(colors.red('Please set the site first, examples: autosignin jingdongjinrong'));
	process.exit();
}
if(!account.username) {
	console.log(colors.red('Please set the username of jingdongjinrong. Example: autosignin -u xxx'));
	process.exit();
}
if(!account.password) {
	console.log(colors.red('Please set the password of jingdongjinrong. Example: autosignin -p xxx'));
	process.exit();
}

logger.info('京东金融自动签到开始...');
nightmare
	.goto('https://vip.jr.jd.com')
	.click('a.link-login')
	.wait('.login-tab.login-tab-r')
	.click('.login-tab.login-tab-r')
	.type('#loginname', account.username)
	.type('#nloginpwd', account.password) 
	.click('#loginsubmit')
	.wait('#index-qian-btn')
	.click('#index-qian-btn')
	.wait('body > div.mem-sign.bag-popup > div.member-sign > div.sign-center > div.sign-cotainer > p')
	.evaluate(selector => document.querySelector(selector).innerText, 'body > div.mem-sign.bag-popup > div.member-sign > div.sign-center > div.sign-cotainer > p')
	.end()
	.then(result => {
		logger.info('京东金融自动签到结束。签到结果：成功！');
	})
	.catch(error => {
		logger.error('京东金融自动签到结束。签到结果：失败！');
	});
