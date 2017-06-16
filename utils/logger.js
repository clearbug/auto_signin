const log4js = require('log4js');

const config = require('../config/config.json');

log4js.configure(config.log4js);

module.exports.logger = name => {
	var logger = log4js.getLogger(name);
	logger.setLevel('INFO');
	return logger;
};
