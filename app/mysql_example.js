// Modules
const mysql = require('mysql');
const config = require('./config');

// Database connection
const connection = mysql.createConnection({
    host: config.database.host,
    user: config.database.user,
    password: config.database.password,
    database: config.database.database
});

// Make a query
connection.query('select * from VELOS;', (err, rows, fields) => {
    if (err)
        throw err;
    else {
        console.log('Result :');
        for (const row of rows) // For each row of the result
            for (const field of fields) // Get fields name
                console.log(`${field.name}: ${row[field.name]}`); // Print field value for this row
    }
});