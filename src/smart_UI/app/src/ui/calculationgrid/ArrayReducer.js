/**
 * Created by carl.r.rieger on 08-Jul-16.
 */

/**
 * Calculates the sum of all values in the array
 * @param {number} previousValue
 * @param {number} currentValue
 * @return {number}
 */
function sum(previousValue, currentValue) {
    if (previousValue === null || previousValue === undefined || isNaN(previousValue)) {
        return currentValue;
    }
    else if (currentValue === null || currentValue === undefined || isNaN(currentValue)) {
        return previousValue;
    }
    else {
        return previousValue + currentValue;
    }
}

/**
 * Calculates the minimum of all values in the array
 * @param {number} previousValue
 * @param {number} currentValue
 * @return {number}
 */
function min(previousValue, currentValue) {
    if (previousValue === null || previousValue === undefined || isNaN(previousValue)) {
        return currentValue;
    }
    else if (currentValue === null || currentValue === undefined || isNaN(currentValue)) {
        return previousValue;
    }
    else {
        return Math.min(previousValue, currentValue);
    }
}

/**
 * Calculates the maximum of all values in the array
 * @param {number} previousValue
 * @param {number} currentValue
 * @return {number}
 */
function max(previousValue, currentValue) {
    if (previousValue === null || previousValue === undefined || isNaN(previousValue)) {
        return currentValue;
    }
    else if (currentValue === null || currentValue === undefined || isNaN(currentValue)) {
        return previousValue;
    }
    else {
        return Math.max(previousValue, currentValue);
    }
}

/**
 * Calculates the average of all values in the array excluding null values
 * @param {number} previousValue
 * @param {number} currentValue
 * @param {number} currentIndex
 * @param {number[]} array
 * @return {number}
 */
function average(previousValue, currentValue, currentIndex, array) {
    var returnValue;

    // set the values to 0 if they are null, undefined or NaN
    previousValue = previousValue || 0;
    currentValue = currentValue || 0;

    returnValue = previousValue + currentValue;

    // at the and of the reduce-function count the number of notNullValues to calculate the average
    if (currentIndex === array.length - 1) {
        var countIsNotNull = 0;
        for (var i = 0; i < array.length; i++) {
            if (array[i] !== null && array[i] !== undefined && !isNaN(array[i])) {
                countIsNotNull++;
            }
        }

        if (countIsNotNull > 0) {
            returnValue = returnValue / countIsNotNull;
        }
        else {
            returnValue = null;
        }
    }

    return returnValue;
}

/**
 * Returns null as aggregated value
 * @return {null}
 */
function none() {
    return null;
}

var reducers = {
    "sum": sum,
    "min": min,
    "max": max,
    "avg": average,
    "null": none,
    "none": none
};

module.exports.ArrayReducer = reducers;
