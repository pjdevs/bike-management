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

    /**
     * Custom query to get the list of bikes in station.
     * @returns A promise for the request.
     */
     getBikes(stationID) {
        return this.query(`select * from VELOS where ID_STATION = ${stationID};`);
    }

    /**
     * Custom query to get a bike by ID.
     * @returns A promise for the request.
     */
         getBike(bikeID) {
            return new Promise((resolve, reject) => {
                this.query(`select * from VELOS where ID_VELO = ${bikeID};`)
                .then(rows => resolve(rows[0]))
                .catch(err => reject(err));
            });
        }

    /**
     * Custom query to get a station by id.
     * @returns A promise for the request.
     */
     getStation(stationID) {
        return new Promise((resolve, reject) => {
            this.query(`select * from STATIONS where ID_STATION = ${stationID};`)
            .then(rows => resolve(rows[0]))
            .catch(err => reject(err));
        });
    }

    getSubscribersBorrowedMoreThanAtDay(numberOfTime, day) {
        return this.query(`
            SELECT 
                * 
            FROM 
                (SELECT 
                    ADHERENTS.*
                FROM 
                    ADHERENTS 
                JOIN 
                    EMPRUNTS 
                USING(ID_ADHERENT) 
                WHERE 
                    DATE_DEBUT_EMPRUNT=date('${day}') 
                GROUP BY 
                ADHERENTS.ID_ADHERENT, EMPRUNTS.ID_VELO) AS TEMP 
            GROUP BY 
                ID_ADHERENT 
            HAVING 
                COUNT(*) >= ${numberOfTime};`
        );
    }

    getAverageNumberofSubs() {
        return this.query(`
            SELECT 
                ID_VELO, NOMBRE_UTILISATIONS / NOMBRE_JOUR AS MOYENNE
            FROM 
                (SELECT 
                    COUNT(*) AS NOMBRE_UTILISATIONS, ID_VELO
                FROM 
                    EMPRUNTS
                GROUP BY 
                    ID_VELO) AS UTILISATIONS_JOUR
            JOIN 
                (SELECT 
                    COUNT(*) AS NOMBRE_JOUR, ID_VELO
                FROM 
                    (SELECT 
                        ID_VELO, DATE_DEBUT_EMPRUNT 
                    FROM 
                        EMPRUNTS
                    GROUP BY 
                        ID_VELO, DATE_DEBUT_EMPRUNT) AS TEMP
                GROUP BY 
                    ID_VELO) AS NOMBRE_JOURS
            USING(ID_VELO)
            GROUP BY 
                ID_VELO
            ;`
        );
    }

    getAverageDistanceBetweenDates(day1, day2) {
        return this.query(`
            SELECT 
                SUM(DISTANCE) / COUNT(DISTINCT ID_VELO) AS MOYENNE_DES_DISTANCES
            FROM
                (SELECT
                        EMPRUNTS.ID_VELO, KM_FIN_EMPRUNT - KM_DEBUT_EMPRUNT AS DISTANCE
                    FROM
                        EMPRUNTS
                    WHERE 
                        ID_STATION_FIN IS NOT NULL AND EMPRUNTS.DATE_DEBUT_EMPRUNT >= DATE("2021-11-07") AND EMPRUNTS.DATE_FIN_EMPRUNT <= DATE("2021-11-15")) AS DISTANCES
            ;`
        );
    }

    getRankingStations() {
        return this.query(`
            SELECT
                COMMUNES.NOM_COMMUNE, ID_STATION, TEMP.ADRESSE_STATION, NB_PLACES_DISPO
            FROM
                COMMUNES
            NATURAL JOIN
                (SELECT 
                    STATIONS.*, STATIONS.NOMBRE_BORNES_STATION-NB_VELOS AS NB_PLACES_DISPO 
                FROM
                    STATIONS 
                JOIN 
                    (SELECT 
                        ID_STATION, COUNT(*) AS NB_VELOS 
                    FROM 
                        VELOS 
                    GROUP BY 
                        ID_STATION 
                    HAVING 
                        ID_STATION IS NOT NULL) AS NB_VELOS_STATIONS
                USING(ID_STATION)) AS TEMP
            ORDER BY COMMUNES.NOM_COMMUNE, NB_PLACES_DISPO DESC
            ;`
        );
    }

    getRankingBikes(stationId) {
        return this.query(`
            SELECT 
                ID_VELO, REFERENCE_VELO, MARQUE_VELO, DATE_SERVICE_VELO, KM_VELO, ETAT_VELO, BATTERIE_VELO 
            FROM 
                VELOS 
            WHERE 
                ID_STATION=1
            ORDER BY 
                BATTERIE_VELO DESC
            ;`
        );
    }
}



const database = new Database(config.database);

// Exports
module.exports = {
    get: () => database
};