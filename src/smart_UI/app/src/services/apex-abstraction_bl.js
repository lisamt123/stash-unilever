
var apexAbstractionCoreClass = require('./apex-abstraction_core');

var apexAbstractionBL = new apexAbstractionCoreClass();

//unilever workflow function
apexAbstractionBL.invokeWF = function (objectId, wfState, jsonContent, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('invokeWf' + className, extension, managed, compressed, buffer, isManagedObject, objectId, wfState, jsonContent);
};

apexAbstractionBL.CreatePush = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('CreatePush' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
};

apexAbstractionBL.cleanUpPush = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('cleanUpPush' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
};

apexAbstractionBL.finalizePush = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('finalizePush' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
};

apexAbstractionBL.UpdateEnablePush = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('UpdateEnablePush' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
};

apexAbstractionBL.validate = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('validate' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
};

//PMA - START CODE - 2017-01-13 - Threshold button
apexAbstractionBL.invokePromotionThresholdCheck = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('invokePromotionThresholdCheck' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
};
apexAbstractionBL.invokeAuditTrail = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('invokeAuditTrail' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
};
//PMA - END CODE - 2017-01-13 - Threshold button

module.exports = apexAbstractionBL;
