// Modules
const express = require('express');
const database = require('./database');

// Router
const router = express.Router();

// Define the routes
router.get('/', (req, res) => {
    res.render('index');
})
.get('/bikes', (req, res) => {
    res.render('bikes', {bikes: []});
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
.get('/subscribers', (req, res) => {
    res.render('subscribers');
})
.get('/subscribers/count/day', (req, res) => {
    res.render('subscribersCountDay', {subscribers: []});
})
.post('/subscribers/count/day', (req, res) => {
    const day = req.body.day;
    const nbOfTimes = req.body.nbOfTimes;

    if (nbOfTimes != undefined && day != undefined) {
        database.get().getSubscribersBorrowedMoreThanAtDay(req.body.nbOfTimes, req.body.day)
        .then(subscribers => {
            res.render('subscribersCountDay', {subscribers: subscribers, day: day, nbOfTimes: nbOfTimes});
        })
        .catch(err => {
            res.status(500).json(err);
        });
    } else {
        res.render('subscribersCountDay', {subscribers: []});
    }
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
.get('/borrows', (req, res) => {
    res.render('borrows', {borrows: {}});
})
.get('/borrow', (req, res) => {
    res.render('borrow');
})
.get('/stats', (req, res) => {
    res.render('stats', {stats: {}});
})
.get('/stats/avg/nbSubs', (req, res) => {
    database.get().getAverageNumberofSubs()
    .then(avgNbSubs => {
        res.render('statsAvgNbSubs', {avgNbSubs: avgNbSubs});
    })
    .catch(err => {
        res.status(500).json(err);
    });
})
.get('/stats/avg/dates', (req, res) => {
    res.render('statsAvgBetweenDates', {stats: []});
})
.post('/stats/avg/dates', (req, res) => {
    const day1 = req.body.day1;
    const day2 = req.body.day2;

    if (day1 != undefined && day2 != undefined) {
        database.get().getAverageDistanceBetweenDates(req.body.day1, req.body.day2)
        .then(stats => {
            res.render('statsAvgBetweenDates', {stats: stats, day1: day1, day2: day2});
        })
        .catch(err => {
            res.status(500).json(err);
        });
    } else {
        res.render('statsAvgBetweenDates', {stats: []});
    }
})
.get('/stats/rankingStations', (req, res) => {
    database.get().getRankingStations()
    .then(stats => {
        res.render('statsRankingStations', {stats: stats});
    })
    .catch(err => {
        res.status(500).json(err);
    });
})
.get('/stats/rankingBikes', (req, res) => {
    res.render('statsRankingBikes', {stats: []});
})
.post('/stats/rankingBikes', (req, res) => {
    const station = req.body.station;

    if (station != undefined) {
        database.get().getRankingBikes(station)
        .then(stats => {
            res.render('statsRankingBikes', {stats: stats, station: station});
        })
        .catch(err => {
            res.status(500).json(err);
        });
    } else {
        res.render('statsRankingBikes', {stats: []});
    }
})
// API
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