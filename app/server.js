//// Modules
const express = require('express');
const config = require('./config');
const routes = require('./routes');

const app = express();

//// Define middlewares (aka addons/config)
app.set('views', config.app.viewsDir);
app.set('view engine', 'ejs');
app.use(express.static(config.app.staticDir));
//// Define all the routes
app.use(routes);

//// Create HTTP server and listen for requests
const server = app.listen(config.server.port, config.server.host, () => {
    console.log(`Server is listenning on ${server.address().address}:${server.address().port}`);
});
