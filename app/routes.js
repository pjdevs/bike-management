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
.get('/subscribers', (req, res) => {
    res.render('subscribers');
})
.get('/bikes', (req, res) => {
    res.render('bikes');
})
.get('/bike/:bikeID', (req, res) => {
    database.get().getBike(req.params.bikeID)
    .then(bike => {
        res.render('bike', {bike: bike});
    })
    .catch(err => {
        res.status(500).json(err);
    });
})
.get('/station/:stationID', (req, res) => {
    const db = database.get();
    const stationID = req.params.stationID;

    db.getStation(stationID)
    .then(station => {
        db.getBikes(stationID)
        .then(bikes => {
            res.render('station', {station: station, bikes: bikes});
        });
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