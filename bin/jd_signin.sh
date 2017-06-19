#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const Nightmare = require('nightmare');
const colors = require('colors');

const logger = require('../utils/logger.js').logger('autosignin');

const config  = require('../config/config.json');

const nightmare = Nightmare(config.nightmare);
const account = config.accounts.jingdong;

// First check whether set the site
if(!account) {
	console.log(colors.red('Please set the site first, examples: autosignin jingdong'));
	process.exit();
}
if(!account.username) {
	console.log(colors.red('Please set the username of jingdong. Example: autosignin -u xxx'));
	process.exit();
}
if(!account.password) {
	console.log(colors.red('Please set the password of jingdong. Example: autosignin -p xxx'));
	process.exit();
}

logger.info('京东自动签到开始...');
nightmare
	.goto('https://vip.jd.com')
	.click('a.link-login')
	.wait('.login-tab.login-tab-r')
	.click('.login-tab.login-tab-r')
	.type('#loginname', account.username)
	.type('#nloginpwd', account.password)
	.click('#loginsubmit')
	.wait('.page-container .side-shortcut #checkinBtn')
	.click('.page-container .side-shortcut #checkinBtn')
	.wait('body > div.ui-dialog.checkin-dialog.checkin.zoomIn.animated > div.ui-dialog-content > h2')
	.evaluate(selector => document.querySelector(selector).innerText, '#userJdNum')
	.end()
	.then(result => {
		logger.info('京东自动签到结束。签到结果：成功！当前京豆数目：' + result);
	})
	.catch(error => {
		logger.error('京东自动签到结束。签到结果：失败！');
	});
