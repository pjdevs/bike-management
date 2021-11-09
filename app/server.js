//// Modules
const express = require('express');
const config = require('./config');
const routes = require('./routes');
const database = require('./database');


//// Create app
const host = '0.0.0.0'; // any address
const port = 8080; // usual HTTP port is 80 but it need root rights so 8080 is good for tests

const app = express();

//// Define middlewares (aka addons/config)
app.use(express.static(config.app.staticDir));
//// Define all the routes
app.use(routes);

//// Create HTTP server and listen for requests
const server = app.listen(port, host, () => {
    console.log(`Server is listenning on ${server.address().address}:${server.address().port}`);
});