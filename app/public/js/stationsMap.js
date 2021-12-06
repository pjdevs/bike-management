// initialize Leaflet
const map = L.map('map', {
    center: [44.792864, -0.623373],
    zoom: 12
});

// add the OpenStreetMap tiles
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="https://openstreetmap.org/copyright">OpenStreetMap contributors</a>'
}).addTo(map);

// show the scale bar on the lower left corner
L.control.scale({ imperial: false, metric: true }).addTo(map);

map.invalidateSize();

function errorHandler(err) {
    alert(err.toString());
}

function getStationsList() {
    return fetch('/api/stations', {method: 'GET'});
}

function setStationsOnMap() {
    getStationsList()
    .then(res => {
        res.json()
        .then(stations => {
            for (const station of stations) {
                L.marker([station.LATTITUDE_STATION, station.LONGITUDE_STATION])
                    .bindPopup(`<a href='/station/${station.ID_STATION}'>${station.ADRESSE_STATION}</a>`)
                    .addTo(map);
            }                    
        })
        .catch(errorHandler)
    })
    .catch(errorHandler);
}

setStationsOnMap();