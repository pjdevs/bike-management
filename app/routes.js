// Modules
const express = require('express');
const database = require('./database');

// Router
const router = express.Router();

function errorHandler(res) {
    err => res.status(500).json(err);
}

// Define the routes
router.get('/', (req, res) => {
    res.render('index');
})
.get('/bikes/allBikes', (req, res) => {
    const db = database.get();
    db.getAllBikes()
    .then(bikes => {
        res.render('bikesAllBikes', {bikes: bikes});
    })
    .catch(errorHandler(res));
})
.get('/bikes/availableBikes', (req, res) => {
    database.get().getAvailableBikes()
    .then(bikes => {
        res.render('bikesAvailableBikes', {bikes: bikes});
    })
    .catch(errorHandler(res));
})
.get('/bikes/unavailableBikes', (req, res) => {
    database.get().getUnavailableBikes()
    .then(bikes => {
        res.render('bikesUnavailableBikes', {bikes: bikes});
    })
    .catch(errorHandler(res));
})
.get('/subscribers', (req, res) => {
    res.render('subscribers');
})
.get('/stats/subsCountDay', (req, res) => {
    res.render('statsSubscribersCountDay', {subscribers: []});
})
.post('/stats/subsCountDay', (req, res) => {
    const day = req.body.day;
    const nbOfTimes = req.body.nbOfTimes;

    if (nbOfTimes != undefined && day != undefined) {
        database.get().getSubscribersBorrowedMoreThanAtDay(req.body.nbOfTimes, req.body.day)
        .then(subscribers => {
            res.render('statsSubscribersCountDay', {subscribers: subscribers, day: day, nbOfTimes: nbOfTimes});
        })
        .catch(errorHandler(res));
    } else {
        res.render('statsSubscribersCountDay', {subscribers: []});
    }
})
.get('/subscribers/allSubs', (req, res) => {
    const db = database.get();
    db.getAllSubs()
    .then(subscribers => {
        db.getAllCommunes()
        .then(communes => {
            res.render('subscribersAllSubs', {subscribers: subscribers, communes: communes});
        })
        .catch(errorHandler(res));
    })
    .catch(errorHandler(res));
})
.get('/station/:stationID', (req, res) => {
    const db = database.get();
    const stationID = req.params.stationID;

    db.getStation(stationID)
    .then(station => {
        db.getBikes(stationID)
        .then(bikes => {
            res.render('station', {station: station, bikes: bikes});
        })
        .catch(errorHandler(res));
    })
    .catch(errorHandler(res));
})
.get('/borrow', (req, res) => {
    const db = database.get();

    db.getSubscribersCanBorrow()
    .then(subscribers => {
        db.getStoredBikes()
        .then(bikes => {
            res.render('borrow',  {subscribers: subscribers, bikes: bikes});
        })
        .catch(errorHandler(res));
    })
    .catch(errorHandler(res));
})
.post('/borrow', (req, res) => {
    database.get().borrowBike(req.body.bikeID, req.body.subscriberID)
    .then(_ => {
        res.redirect('/borrows/list');
    })
    .catch(errorHandler(res));
})
.get('/borrows/allBorrows', (req, res) => {
    database.get().getAllBorrows()
    .then(borrows => {
        res.render('borrowsAllBorrows', {borrows: borrows});
    })
    .catch(errorHandler(res));
})
.get('/borrows/endedBorrows', (req, res) => {
    database.get().getEndedBorrows()
    .then(borrows => {
        res.render('borrowsEndedBorrows', {borrows: borrows});
    })
    .catch(errorHandler(res));
})
.get('/borrows/list', (req, res) => {
    database.get().getCurrentBorrowList()
    .then(borrows => {
        res.render('borrowsList', {borrows: borrows});
    })
    .catch(errorHandler(res));

})
.get('/return/:borrowID', (req, res) => {
    const db = database.get();

    db.getBorrow(req.params.borrowID)
    .then(borrow => {
        db.getBike(borrow.ID_VELO)
        .then(bike => {
            db.getStationListWhereCanReturn()
            .then(stations => {
                res.render('return', {borrow: borrow, bike: bike, stations: stations});
            })
            .catch(errorHandler(res));
        })
        .catch(errorHandler(res));
    })
    .catch(errorHandler(res));

})
.post('/return/:borrowID', (req, res) => {
    const db = database.get();

    db.returnBike(req.params.borrowID, req.body.endKm, req.body.stationID)
    .then(_ => {
        res.redirect('/borrows/list');
    })
    .catch(errorHandler(res));
})
.get('/subscribers/addSub', (req, res) => {
    database.get().getAllCommunes()
    .then(communes => {
        res.render('addSub', {communes: communes});
    })
    .catch(errorHandler(res));
})
.post('/subscribers/addSub', (req, res) => {
    database.get().addSub(req.body.subSurname, req.body.subFirstName, req.body.subAddr, req.body.subCommuneId)
    .then(_ => {
        res.redirect('/subscribers/allSubs');
    })
    .catch(errorHandler(res));
})
.post('/subscribers/delete/:id', (req, res) => {
    database.get().deleteSub(req.params.id)
    .then(_ => {
        res.redirect('/subscribers/allSubs');
    })
    .catch(errorHandler(res));
})
.post('/subscribers/update/:id', (req, res) => {
    database.get().updateSub(req.params.id, req.body.subSurname, req.body.subFirstName, req.body.subAddr, req.body.subCommuneId)
    .then(_ => {
        res.redirect('/subscribers/allSubs');
    })
    .catch(errorHandler(res));
})
.get('/bikes/addBike', (req, res) => {
    database.get().getStationListWhereCanReturn()
    .then(stations => {
        res.render('addBike', {stations: stations})
    })
    .catch(errorHandler(res));
})
.post('/bikes/addBike', (req, res) => {
    database.get().addBike(req.body.bikeRef, req.body.bikeBrand, req.body.bikeKm, req.body.bikeStationId)
    .then(_ => {
        res.redirect('/bikes/allBikes');
    })
    .catch(errorHandler(res));
})
.post('/bikes/delete/:id', (req, res) => {
    database.get().deleteBike(req.params.id)
    .then(_ => {
        res.redirect('/bikes/allBikes');
    })
    .catch(errorHandler(res));
})
.get('/stats', (req, res) => {
    res.render('stats', {stats: {}});
})
.get('/stats/avg/nbSubs', (req, res) => {
    database.get().getAverageNumberofSubs()
    .then(avgNbSubs => {
        res.render('statsAvgNbSubs', {avgNbSubs: avgNbSubs});
    })
    .catch(errorHandler(res));
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
        .catch(errorHandler(res));
    } else {
        res.render('statsAvgBetweenDates', {stats: []});
    }
})
.get('/stats/rankingStations', (req, res) => {
    database.get().getRankingStations()
    .then(stats => {
        res.render('statsRankingStations', {stats: stats});
    })
    .catch(errorHandler(res));
})
.get('/stats/rankingBikes', (req, res) => {
    res.render('statsRankingBikes', {stats: []});
})
.post('/stats/rankingBikes', (req, res) => {
    const stationid = req.body.stationid;

    if (stationid != undefined) {
        database.get().getRankingBikes(req.body.stationid)
        .then(stats => {
            res.render('statsRankingBikes', {stats: stats, stationid: stationid});
        })
        .catch(errorHandler(res));
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
    .catch(errorHandler(res));
})
.use((req, res) => {
    res.redirect('/');
});

// Exports
module.exports = router;