var apexAbstractionCoreClass = require('./apex-abstraction_core');

var apexAbstractionBL = new apexAbstractionCoreClass();

apexAbstractionBL.copy = function (objectId, className, extension) {
    return this.create(objectId, className, extension);
};

apexAbstractionBL.getData = function (objectId, className, extension) {
    var result = when.defer();

    var objectContent = self[className + 'Mock'].getData(objectId);

    // Nothing to do in mock scenario
    setTimeout(function () {
        console.log('getData called for ', className, 'with Id', objectId, 'on extension', extension, 'called');

        result.resolve(objectContent);
    }, 100);

    return result.promise;
};

apexAbstractionBL.getMeta = function (objectId, className, extension) {
    var result = when.defer();
    var objectContent = self[className + 'Mock'].getMeta(objectId);
    // Nothing to do in mock scenario
    setTimeout(function () {
        console.log('getMeta method for object', className, 'with Id', objectId, 'on extension', extension, 'called');

        result.resolve(objectContent);
    }, 100);

    return result.promise;
};

//PMA - START CODE - 2017-01-13 - Threshold button
apexAbstractionBL.invokePromotionThresholdCheck = function (objectId, wfState, className, extension) {
    var result = when.defer();
    setTimeout(function () {
        console.log('invokePromotionThresholdCheck method for object', className, 'with Id', objectId, 'on extension', extension, 'called');

        result.resolve(true);
    }, 100);

    return result.promise;
};
apexAbstractionBL.invokeAuditTrail = function (objectId, wfState, className, extension) {
    var result = when.defer();
    setTimeout(function () {
        console.log('invokeAuditTrail method for object', className, 'with Id', objectId, 'on extension', extension, 'called');

        result.resolve(true);
    }, 100);

    return result.promise;
};
//PMA - START CODE - 2017-01-13 - Threshold button

apexAbstractionBL.validate = function (objectId, wfState, className, extension) {
    var result = when.defer();
    setTimeout(function () {
        console.log('validate method for object', className, 'with Id', objectId, 'on extension', extension, 'called');

        result.resolve({
            __Status: true
        });
    }, 100);

    return result.promise;
};

module.exports = apexAbstractionBL;
