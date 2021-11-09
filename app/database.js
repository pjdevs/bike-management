// Modules
const mysql = require('mysql');
const config = require('./config');

// Setup database class

/**
 * MySQL database connection wrapper with promeses
 */
class Database {
    /**
     * Create a new Database connection.
     * @param {mysql.PoolConfig} config 
     */
    constructor(config) {
        this.connection = mysql.createPool(config);
    }

    /**
     * 
     * @param {string | mysql.QueryOptions} sql 
     * @returns A promise for the query containing resulting rows as JS object.
     */
    query(sql) {
        return new Promise((resolve, reject) => {
            this.connection.query(sql, (err, rows) => {
                if (err) reject(err);
                else resolve(JSON.parse(JSON.stringify(rows)));
            });
        });
    }

    /**
     * Custom query to get the list of station.
     * @returns A promise for the request.
     */
    getStations() {
        return this.query('select * from STATIONS;');
    }
}

const database = new Database(config.database);

// Exports
module.exports = {
    get: () => database
};