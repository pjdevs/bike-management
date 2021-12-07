/**
 * Database connection related informations. 
 */
exports.database = {
    host: 'localhost',
    user: 'cascadeirb',
    password: 'velo',
    database: 'velo'
};

/**
 * Web App related informations.
 */
exports.app = {
    staticDir: __dirname + '/public',
    viewsDir: __dirname + '/views'
};

/**
 * Server related informations
 */
exports.server = {
	host: '0.0.0.0',
	port: 8888	
};
