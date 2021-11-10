function makeSatationElement(stationObject) {
    const stationElement = document.createElement('div');
    stationElement.innerHTML = `
        <h5>Station ${stationObject.ID_STATION}</h5>    
        <div>
            <label>Adresse :</label>
            <p>${stationObject.ADRESSE_STATION}</p>
        </div>
        <div>
            <label>Nombre de bornes :</label>
            <p>${stationObject.NOMBRE_BORNES_STATION}</p>
        </div>
    `;

    return stationElement;
}

function errorHandler(err) {
    const errorMsg = document.getElementById('errorMsg');
    errorMsg.innerText = err.toString();
}

function getStationsList() {
    return fetch('/api/stations', {method: 'GET'});
}

function updateStationsList() {
    const stationsList = document.getElementById('stationsList');
    
    while (stationsList.firstChild) {
        stationsList.removeChild(stationsList.lastChild);
    }

    getStationsList()
    .then(res => {
        res.json()
        .then(stations => {
            for (const station of stations) {
                stationsList.appendChild(makeSatationElement(station));
            }                    
        })
        .catch(errorHandler)
    })
    .catch(errorHandler);
}

updateStationsList();