"use strict";
if (typeof require !== "undefined") {
    var _ = require("lodash");
}

var measurements = [];
var enabled = false;
var lastParent = null;

// Globals for output of measurements
var logDuration = 0.003;
var defaultDigits = 4;

var enable = function (state) {
    enabled = state;
};

var clearMeasurements = function () {
    measurements = [];
};

var startMeasurement = function (name) {
    if (!enabled) {
        return;
    }

    var existingMeasure = _.findIndex(measurements, function (measure) {
        return measure.name === name;
    });

    if (existingMeasure < 0) {
        var newMeasure = {
            state: 0,
            startTime: Date.now(),
            firstStartTime: Date.now(),
            overallDuration: -1,
            occurrences: 0,
            lastRecursionOccurrences: 0,
            lowerLevelOccurrences: 0,
            name: name,
            recursionLevel: 1,
            maxRecursion: 1,
            parent: lastParent,
            childOccurrences: 0,
            minDuration: 9999999999,
            maxDuration: 0
        };

        lastParent = newMeasure;

        measurements.push(newMeasure);
    }
    else {
        if (measurements[existingMeasure].recursionLevel > 0) {
            measurements[existingMeasure].recursionLevel++;
            measurements[existingMeasure].occurrences++;
            measurements[existingMeasure].lastRecursionOccurrences++;
            if (measurements[existingMeasure].recursionLevel > measurements[existingMeasure].maxRecursion) {
                measurements[existingMeasure].maxRecursion = measurements[existingMeasure].recursionLevel;
            }
            if (measurements[existingMeasure].recursionLevel > 1) {
                measurements[existingMeasure].lowerLevelOccurrences++;
            }
        }
        else {
            measurements[existingMeasure].startTime = Date.now();
            measurements[existingMeasure].state = 0;
            measurements[existingMeasure].recursionLevel = 1;
            measurements[existingMeasure].parent = lastParent;
            measurements[existingMeasure].lastRecursionOccurrences = 0;
            lastParent = measurements[existingMeasure];
        }
    }
};

var endMeasurement = function (name) {
    if (!enabled) {
        return;
    }

    var measureIdx = _.findIndex(measurements, function (measure) {
        return measure.name === name;
    });

    if (measureIdx < 0) {
        throw new Error('ERROR: Tried to stop a benchmark which does not exists: ' + name);
    }

    var measure = measurements[measureIdx];

    measure.recursionLevel--;

    if (measure.recursionLevel < 0) {
        throw new Error('ERROR: Tried to close measurement with negative recursion level: ' + name);
    }
    else if (measure.recursionLevel === 0) {
        var duration = Date.now() - measure.startTime;
        measure.occurrences++;
        measure.lastRecursionOccurrences++;
        measure.overallDuration += duration;
        measure.lastStopTime = Date.now();
        measure.state = 1;
        if (measure.parent) {
            measure.parent.childOccurrences += measure.lastRecursionOccurrences;
        }
        lastParent = measure.parent;
        measure.minDuration = _.min([measure.minDuration, duration]);
        measure.maxDuration = _.max([measure.maxDuration, duration]);
    }
};

var printMeasurements = function (digits, all) {
    if (!digits) {
        digits = defaultDigits;
    }

    var printJSONArray = [];

    measurements.forEach(function (element) {
        var clearedDuration = round(element.overallDuration - (element.childOccurrences + element.lowerLevelOccurrences) * logDuration, digits);

        if (all) {
            printJSONArray.push({
                name: element.name,
                overallDuration: round(element.overallDuration, digits),
                minDuration: element.minDuration,
                maxDuration: element.maxDuration,
                clearedDuration: clearedDuration,
                averageDuration: round(element.overallDuration / element.occurrences, digits),
                averageClearedDuration: round(clearedDuration / element.occurrences, digits),
                measureLifeTime: element.lastStopTime - element.firstStartTime,
                occurrences: element.occurrences,
                maxRecursion: element.maxRecursion,
                childOccurrences: element.childOccurrences
            });
        }
        else {
            printJSONArray.push({
                name: element.name,
                clearedDuration: clearedDuration,
                averageClearedDuration: round(clearedDuration / element.occurrences, digits),
                measureLifeTime: element.lastStopTime - element.firstStartTime,
                occurrences: element.occurrences,
                maxRecursion: element.maxRecursion
            });
        }
    });

    return JSON.stringify(printJSONArray);
};

function round(value, digits) {
    return Math.round(value * Math.pow(10, digits)) / Math.pow(10, digits);
}

if (typeof module !== 'undefined' && typeof module.exports !== 'undefined') {
    module.exports.enable = enable;
    module.exports.startMeasurement = startMeasurement;
    module.exports.endMeasurement = endMeasurement;
    module.exports.printMeasurements = printMeasurements;
    module.exports.clearMeasurements = clearMeasurements;
}
else {
    window.enable = enable;
    window.startMeasurement = startMeasurement;
    window.endMeasurement = endMeasurement;
    window.printMeasurements = printMeasurements;
    window.clearMeasurements = clearMeasurements;
}
