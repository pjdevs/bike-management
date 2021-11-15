// Modules
const express = require('express');
const config = require('./config');
const database = require('./database');

// Router
const router = express.Router();

// Define the routes
router.get('/', (req, res) => {
    res.render('index');
})
.get('/station/:stationID', (req, res) => {
    database.get().getStation(req.params.stationID)
    .then(station => {
        res.render('station', {station: station});
    })
    .catch(err => {
        res.status(500).send(err);
    });
})
.get('/api/stations', (req, res) => {
    database.get().getStations()
    .then(stations => {
        res.send(stations);
    })
    .catch(err => {
        res.status(500).json(err);
    });
})
.use((req, res) => {
    res.redirect('/');
});

// Exports
module.exports = router;