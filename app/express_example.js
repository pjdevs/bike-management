//// Modules
const express = require('express');

//// Create app
const host = '0.0.0.0'; // any address
const port = 8080; // usual HTTP port is 80 but it need root rights so 8080 is good for tests
const staticDir = __dirname + '/public';
const viewsDir = __dirname + '/views';
const app = express();

//// Define middlewares (aka addons/config)
app.use(express.static(staticDir));

//// Define all the routes (i.e. my-site.com/the-route-here)

// What to do when someone make a GET request a my-site.com/ ?? (GET request is default request made when a browser access a URL)
app.get('/', (req, res) => { // req is the HTTP request received, res is the response to send
    // Redirect to route /text when accessing /
    res.redirect('/text');
})
.get('/text', (req, res) => {
    // To send text :
    res.send('Welcome on the page !');
})
.get('/page', (req, res) => {
    // To send a web page (what we will do) :
    res.sendFile(viewsDir + '/page.html');
})
.get('/json', (req, res) => {
    // To send JSON for an API (what we will do) :
    res.json({
        bikes: [ /*Get bike list from the database*/
            {
                id: 1,
                reference: 'RCF473',
                /* ... */
            }
        ]
    });
})
.use(() => (req, res) => { // any other route for any method (GET, POST, etc)
    res.status(404).send('Sorry, can\'t find that :('); // 404 status is not found, 200 is OK etc...
});

//// Create HTTP server and listen for requests
const server = app.listen(port, host, () => {
    console.log(`Server is listenning on ${server.address().address}:${server.address().port}`);
});

/**
 * Now you can type localhost:8080 in a browser and access
 * localhost:8080/
 * localhost:8080/text
 * localhost:8080/page
 * localhost:8080/json
 */