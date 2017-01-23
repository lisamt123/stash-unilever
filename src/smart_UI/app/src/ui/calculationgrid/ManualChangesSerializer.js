"use strict";
/* globals CasException */

var _ = require("lodash");
var _logWidgetName = "ManualChangesSerializer";

/**
 *
 * @param dataMeta
 * @param {MeasureDefinitionCollection} meta
 * @param logger
 * @param {benchmark} benchmark
 * @constructor
 */
var ManualChangesSerializer = function (dataMeta, meta, logger, benchmark) {
    if (logger === undefined) {
        var bunyan = require('bunyan');
        logger = bunyan.createLogger();
    }
    
    /**
     * @type {XMLList}
     */
    this.log = logger.child({widget_type: _logWidgetName});
    
    if (benchmark === undefined) {
        benchmark = require('../benchmark');
        benchmark.enable(false);
    }
    
    /**
     * @type {benchmark}
     */
    this.benchmark = benchmark;
    
    this.getDataMeta = function () {
        return dataMeta;
    };
    
    /**
     * Gets the MetaInformation
     * @return {MeasureDefinitionCollection}
     */
    this.getMeta = function () {
        return meta;
    };
};

/**
 * Serializes the manual changes into a minimized storable format
 * @param {Object[]} manualChanges
 * @return {{dimensions: *[], data: *[]}}
 */
ManualChangesSerializer.prototype.serialize = function (manualChanges) {
    this.benchmark.startMeasurement("serialize");
    
    var result = compressManualChanges(manualChanges, this.getDataMeta(), this.getMeta());
    
    this.benchmark.startMeasurement("serialize");
    
    return result;
};

/**
 * Deserializes the minimized format of the manual changes for applying them in the tree
 * @param manualChanges
 * @return {{dimensions: Object[], data: Array}}
 */
ManualChangesSerializer.prototype.deserialize = function (manualChanges) {
    this.benchmark.startMeasurement("serialize");
    
    var deserializedDimension = translateDimensions(manualChanges.dimensions, this.getDataMeta(), this.getMeta(), this.log, this.benchmark);
    
    var translatedData = translateData(deserializedDimension, manualChanges.data, this.getDataMeta(), this.getMeta(), this.log, this.benchmark);
    
    this.benchmark.endMeasurement("serialize");
    
    return translatedData;
};

/**
 * Indicates if the given manualChanges Object could be valid
 * @param {Object} manualChanges
 * @return {boolean}
 */
ManualChangesSerializer.prototype.isValid = function (manualChanges) {
    this.benchmark.startMeasurement("isValid");
    
    var isObject = false;
    var hasArrayData = false;
    var hasArrayDimensions = false;
    
    if (manualChanges !== undefined && manualChanges !== null && manualChanges !== "") {
        if (typeof manualChanges === 'object') {
            isObject = true;
        }
    }
    
    if (isObject && "dimensions" in manualChanges) {
        hasArrayDimensions = Array.isArray(manualChanges.dimensions);
    }
    
    if (isObject && "data" in manualChanges) {
        hasArrayData = Array.isArray(manualChanges.data);
    }
    
    this.benchmark.endMeasurement("isValid");
    
    return (isObject && hasArrayData && hasArrayDimensions);
};


var translateData = function (dimensions, data, dataMeta, meta, log, benchmark) {
    benchmark.startMeasurement("translateData");
    
    var translatedData = [];
    
    for (var dataIndex = 0; dataIndex < data.length; dataIndex++) {
        var manualChange = {path: [], columnIndex: -1, value: undefined};
        var rawPath = data[dataIndex][0];
        var value = data[dataIndex][1];
        var errorOccurred = false;
        
        for (var dimensionIndex = 0; dimensionIndex < rawPath.length; dimensionIndex++) {
            var oldValue = rawPath[dimensionIndex];
            var dimension = dimensions[dimensionIndex];
            var translatedValue;
            if (oldValue > -1) {
                translatedValue = dimension.translatedValues[oldValue];
            }
            else {
                translatedValue = -1;
            }
            
            if (translatedValue !== undefined) {
                if (dimension.axis === "x") {
                    if (translatedValue.length == 1) {
                        manualChange.columnIndex = translatedValue[0] + 1;
                    }
                    else {
                        errorOccurred = true;
                        log.error("Not implemented: The values on the x-axis cannot be hierarchical!");
                    }
                }
                else {
                    manualChange.path = manualChange.path.concat(translatedValue);
                }
            }
            else {
                errorOccurred = true;
                log.debug("Could not find value for manual change with index " + dataIndex + " for dimension " + dimension.name + ". Ignoring this change!");
            }
        }
        
        manualChange.value = value;
        
        if (!errorOccurred) {
            translatedData.push(manualChange);
        }
    }
    
    benchmark.endMeasurement("translateData");
    
    return translatedData;
};

/**
 *
 * @param {Object[]} dimensions
 * @param {String} dimensions[].name
 * @param {String} dimensions[].type
 * @param {Object} dataMeta
 * @param {MeasureDefinitionCollection} meta
 * @param log
 * @param benchmark
 */
var translateDimensions = function (dimensions, dataMeta, meta, log, benchmark) {
    var result = [];
    
    for (var dimensionIndex = 0; dimensionIndex < dimensions.length; dimensionIndex++) {
        var translatedDimension;
        var dimension = dimensions[dimensionIndex];
        
        switch (dimension.type) {
            case "measure":
                translatedDimension = translateMeasureDimension(dimension, dimensionIndex, dataMeta, meta, log, benchmark);
                break;
            case "time":
                translatedDimension = translateTimeDimension(dimension, dimensionIndex, dataMeta, meta, log, benchmark);
                break;
            case "regular":
                translatedDimension = translateRegularDimension(dimension, dimensionIndex, dataMeta, meta, log, benchmark);
                break;
            default:
                throw new CasException("Unknown dimension-type: " + dimension.type);
        }
        
        result[dimensionIndex] = translatedDimension;
    }
    //var dimension = {name: "", originalValues: [], translatedValues: []};
    // 1) refactor dimensions
    // 1.1 keep original values for backtracking/logging
    
    
    return result;
};

/**
 *
 * @param {Object} oldDimension
 * @param {String} oldDimension.name
 * @param {String} oldDimension.type
 * @param {Object[]} oldDimension.details
 * @param {number} oldDimension.details.calendaryear
 * @param {number} oldDimension.details.week
 * @param {number} oldDimensionIndex
 * @param dataMeta
 * @param {MeasureDefinitionCollection} meta
 * @param log
 * @param benchmark
 * @return {{name: String, type: String, originalValues: Object[], originalIndex: number, translatedValues: number[], translatedIndex: number}}
 */
var translateTimeDimension = function (oldDimension, oldDimensionIndex, dataMeta, meta, log, benchmark) {
    benchmark.startMeasurement("translateTimeDimension");
    var translatedDimension = {
        name: oldDimension.name,
        type: oldDimension.type,
        originalValues: oldDimension.details,
        originalIndex: oldDimensionIndex,
        translatedValues: [],
        translatedIndex: -1,
        axis: "",
        axisIndex: -1
    };
    
    /**
     * Transforms a timeDetailObject to a string-comparable-value
     * @param {Object} timeDetail
     * @param {number} timeDetail.calendaryear
     * @param {number} timeDetail.week
     * @return {string}
     */
    var timeDetailsToString = function (timeDetail) {
        return timeDetail.calendaryear + " - " + timeDetail.week;
    };
    
    var currentTimeDimensionIndex = _.findIndex(dataMeta.dimensions, {"name": oldDimension.name, "type": "time"});
    if (currentTimeDimensionIndex > -1) {
        var currentTimeDimension = dataMeta.dimensions[currentTimeDimensionIndex];
        
        translatedDimension.translatedIndex = currentTimeDimensionIndex;
        
        var translatedValueKeys = toValueKeyCollection(currentTimeDimension.details, timeDetailsToString);
        
        var translatedValues = [];
        for (var oldDetailsIndex = 0; oldDetailsIndex < oldDimension.details.length; oldDetailsIndex++) {
            var oldTimeDetails = oldDimension.details[oldDetailsIndex];
            if(oldTimeDetails === -1) {
                translatedValues[oldDetailsIndex] = [-1];    // TOTAL value
            } else {
                var comparableString = timeDetailsToString(oldTimeDetails);
                var currentIndex = translatedValueKeys[comparableString];
                
                if (currentIndex !== undefined) {
                    translatedValues[oldDetailsIndex] = [currentIndex];
                }
                else {
                    log.info("The entry '" + comparableString + "' in dimension '" + oldDimension.name + "' is no longer valid and will be ignored.");
                }
            }
        }
        
        translatedDimension.translatedValues = translatedValues;
        translatedDimension.axis = getAxisOfDimension(oldDimension.name, meta, log, benchmark);
        
    } else {
        throw new CasException("Could not find the oldDimension with the name " + oldDimension.name + " of type 'time'");
    }
    
    //  1b) time => match week + year -> to new []internalNodeId (remember totalValue +1), if not present null) -> timeframe no longer valid -> will be ignoring these changes
    
    benchmark.endMeasurement("translateTimeDimension");
    
    return translatedDimension;
};

/**
 *
 * @param dimensionName
 * @param meta
 * @param log
 * @param benchmark
 * @return {string}
 */
var getAxisOfDimension = function (dimensionName, meta, log, benchmark) {
    benchmark.startMeasurement("getAxisOfDimension");
    
    var axis = "";
    
    if (meta.axis.x === dimensionName) {
        axis = "x";
    }
    else {
        var dimensionIndex = _.findIndex(meta.axis.y, function (dimName) {
            return (dimensionName === dimName);
        });
        
        if (dimensionIndex > -1) {
            axis = "y";
        } else {
            log.warn("The dimension with the name '" + dimensionName + "' is no longer used and will be ignored!");
        }
    }
    
    benchmark.endMeasurement("getAxisOfDimension");
    
    return axis;
};

/**
 *
 * @param {Object} oldDimension
 * @param {String} oldDimension.name
 * @param {String} oldDimension.type
 * @param {String[]} oldDimension.lookups
 * @param {number} dimensionIndex
 * @param dataMeta
 * @param {MeasureDefinitionCollection} meta
 * @param log
 * @param benchmark
 * @return {{name: String, type: String, originalValues: String[], originalIndex: number, translatedValues: number[], translatedIndex: number}}
 */
var translateMeasureDimension = function (oldDimension, dimensionIndex, dataMeta, meta, log, benchmark) {
    benchmark.startMeasurement("translateMeasureDimension");
    var translatedDimension = {
        name: oldDimension.name,
        type: oldDimension.type,
        originalValues: oldDimension.lookups,
        originalIndex: dimensionIndex,
        translatedValues: [],
        translatedIndex: -1,
        axis: "",
        axisIndex: -1
    };
    
    var currentMeasureDimensionIndex = _.findIndex(dataMeta.dimensions, {"type": "measure"});
    if (currentMeasureDimensionIndex > -1) {
        var currentMeasureDimension = dataMeta.dimensions[currentMeasureDimensionIndex];
        
        translatedDimension.translatedIndex = currentMeasureDimensionIndex;
        
        var translatedValueKeys = meta.editableCodeIndexMapping;
        
        var translatedValues = [];
        for (var oldLookUpIndex = 0; oldLookUpIndex < oldDimension.lookups.length; oldLookUpIndex++) {
            var oldEditableCode = oldDimension.lookups[oldLookUpIndex];
            var currentIndex = translatedValueKeys[oldEditableCode];
            
            if (currentIndex !== undefined) {
                translatedValues[oldLookUpIndex] = [currentIndex];
            }
            else {
                log.info("The measure with the editable code '" + oldEditableCode + "' in dimension '" + currentMeasureDimension.name + "' is no longer valid and will be ignored.");
            }
        }
        
        translatedDimension.translatedValues = translatedValues;
        translatedDimension.axis = getAxisOfDimension("measures", meta, log, benchmark);
        
    } else {
        throw new CasException("Could not find the the dimension of type 'measure'");
    }
    
    benchmark.endMeasurement("translateMeasureDimension");
    
    return translatedDimension;
};

/**
 * This callback type is called when a conversion of any type to a string should be done
 *
 * @callback toStringCallback
 * @param {*} input
 * @return {string}
 */

/**
 *
 * @param {Array} keyValueCollection
 * @param {toStringCallback} [toString]
 * @return {{}}
 */
var toValueKeyCollection = function (keyValueCollection, toString) {
    if (!isFunction(toString)) {
        toString = defaultToStringFunction;
    }
    
    var result = {};
    
    for (var index = 0; index < keyValueCollection.length; index++) {
        result[toString(keyValueCollection[index])] = index;
    }
    
    return result;
};

/**
 * Returns the same value as result
 * @param {string} input
 * @return {string}
 */
var defaultToStringFunction = function (input) {
    return input;
};

/**
 * Checks if the given argument is a function.
 * @function
 * @private
 */
var isFunction = function (func) {
    return (typeof func) === 'function';
};

/**
 *
 * @param {Object} oldDimension
 * @param {String} oldDimension.name
 * @param {String} oldDimension.type
 * @param {String[]} oldDimension.lookups
 * @param {number} dimensionIndex
 * @param dataMeta
 * @param {MeasureDefinitionCollection} meta
 * @param log
 * @param benchmark
 * @return {{name: String, type: String, originalValues: String[], originalIndex: number, translatedValues: number[], translatedIndex: number}}
 */
var translateRegularDimension = function (oldDimension, dimensionIndex, dataMeta, meta, log, benchmark) {
    benchmark.startMeasurement("translateRegularDimension");
    var translatedDimension = {
        name: oldDimension.name,
        type: oldDimension.type,
        originalValues: oldDimension.lookups,
        originalIndex: dimensionIndex,
        translatedValues: [],
        translatedIndex: -1,
        axis: "",
        axisIndex: -1
    };
    
    var currentDimensionIndex = _.findIndex(dataMeta.dimensions, {"name": oldDimension.name, "type": "regular"});
    if (currentDimensionIndex > -1) {
        var currentDimension = dataMeta.dimensions[currentDimensionIndex];
        
        translatedDimension.translatedIndex = currentDimensionIndex;
        
        var translatedValueKeys = {};
        resolveHierarchicalLookUps(translatedValueKeys, currentDimension);
        
        var translatedValues = [];
        for (var oldLookUpIndex = 0; oldLookUpIndex < oldDimension.lookups.length; oldLookUpIndex++) {
            var compareString = oldDimension.lookups[oldLookUpIndex];
            var currentPath = translatedValueKeys[compareString];
            
            if (currentPath !== undefined) {
                translatedValues[oldLookUpIndex] = currentPath;
            }
            else {
                log.info("The entry '" + compareString + "' in dimension '" + oldDimension.name + "' is no longer valid and will be ignored.");
            }
        }
        
        translatedDimension.translatedValues = translatedValues;
        translatedDimension.axis = getAxisOfDimension(oldDimension.name, meta, log, benchmark);
        
    }
    else {
        log.warn("Could not find the dimension with the name '" + oldDimension.name + "' of type 'regular'. This could lead to invalid results!");
    }
    
    //  1c) regular => match id with id -> to new []internalNodeId + hierarchy if necessary + -1 if currently is -1 (Tactic) -> no validation! + log info
    
    benchmark.endMeasurement("translateRegularDimension");
    
    return translatedDimension;
};

var resolveHierarchicalLookUps = function (translatedValues, hierarchyInformation) {
    
    var hasParentInHierarchy = (hierarchyInformation.hierarchy !== undefined);
    if (hasParentInHierarchy) {
        resolveHierarchicalLookUps(translatedValues, hierarchyInformation.hierarchy);
    }
    
    for (var i = 0; i < hierarchyInformation.lookups.length; i++) {
        var ownId = hierarchyInformation.lookups[i];
        
        if (hasParentInHierarchy) {
            var parentLookUpIndex = hierarchyInformation.hierarchy.mapping[i];
            var parentLookUpValue = hierarchyInformation.hierarchy.lookups[parentLookUpIndex];
            var parentPath = translatedValues[parentLookUpValue].slice();
            parentPath.push(i);
            
            translatedValues[ownId] = parentPath;
        }
        else {
            translatedValues[ownId] = [i];
        }
    }
};

/**
 *
 * @param {Object[]} manualChanges
 * @param dataMeta
 * @param meta
 * @return {{dimensions: [], data: *[]}}
 */
var compressManualChanges = function (manualChanges, dataMeta, meta) {
    var compressedChanges = {dimensions: [], data: []};
    
    var dimensionNameLookupResolution = {dimensionCounter: 0, dimensions: {}};
    
    for (var changeIndex = 0; changeIndex < manualChanges.length; changeIndex++) {
        var manualChange = manualChanges[changeIndex];
        var manualRecord = [[], manualChange.value];
        
        for (var dimensionName in manualChange.dimensions) {
            if (manualChange.dimensions.hasOwnProperty(dimensionName)) {
                var dimensionValue = manualChange.dimensions[dimensionName];
                
                manualRecord[0].push(resolveDimensionLookupIndex(dimensionNameLookupResolution, dimensionName, dimensionValue));
            }
        }
        
        compressedChanges.data.push(manualRecord);
    }
    
    compressedChanges.dimensions = correctDimensionLookup(dimensionNameLookupResolution, dataMeta, meta);
    
    return compressedChanges;
};

/**
 * @param {Object} dimensionInformation
 * @param {Number} dimensionInformation.dimensionCounter
 * @param {Object} dimensionInformation.dimensions
 * @param {string} dimensionName
 * @param {string} itemName
 */
var resolveDimensionLookupIndex = function (dimensionInformation, dimensionName, itemName) {
    if (!(dimensionName in dimensionInformation.dimensions)) {
        dimensionInformation.dimensions[dimensionName] = {
            lookups: [],
            resolution: {},
            dimensionId: dimensionInformation.dimensionCounter++,
            dimensionName: dimensionName
        };
    }
    
    var dimensionInfo = dimensionInformation.dimensions[dimensionName];
    
    if (!(itemName in dimensionInfo.resolution)) {
        dimensionInfo.resolution[itemName] = dimensionInfo.lookups.length;
        dimensionInfo.lookups.push(itemName);
    }
    
    return dimensionInfo.resolution[itemName];
};

/**
 *
 * @param {Object} dimensionInformation
 * @param {Number} dimensionInformation.dimensionCounter
 * @param {Object} dimensionInformation.dimensions
 * @param dataMeta
 * @param meta
 * @return {Object[]}
 */
var correctDimensionLookup = function (dimensionInformation, dataMeta, meta) {
    var reducedDimensionInformation = [];
    
    for (var dimensionName in dimensionInformation.dimensions) {
        var dimensionObject = dimensionInformation.dimensions[dimensionName];
        var correctedDimensionObject = dimensionObject;
        var dimensionMeta;
        if (dimensionName !== "measures") {
            dimensionMeta = _.find(dataMeta.dimensions, {"name": dimensionName});
        }
        else {
            dimensionMeta = _.find(dataMeta.dimensions, {"type": "measure"});
        }
        
        if (dimensionMeta.type === "time") {
            correctedDimensionObject = correctTimeDimensionInformation(dimensionObject, dimensionMeta, meta);
        }
        else if (dimensionMeta.type === "measure") {
            correctedDimensionObject = correctMeasureDimensionInformation(dimensionObject, dimensionMeta, meta);
        }
        else if (dimensionMeta.type === "regular") {
            correctedDimensionObject = correctRegularDimensionInformation(dimensionObject, dimensionMeta, meta);
        }
        else {
            throw new CasException("Unknown DimensionType: " + dimensionMeta.type);
        }
        
        reducedDimensionInformation[dimensionObject.dimensionId] = correctedDimensionObject;
    }
    
    return reducedDimensionInformation;
};

/**
 *
 * @param {Object} dimensionObject
 * @param {String} dimensionObject.dimensionName
 * @param {number} dimensionObject.dimensionId
 * @param {Object} dimensionObject.resolution
 * @param {String[]} dimensionObject.lookups
 * @param dimensionMeta
 * @param meta
 * @return {{name: string, type: string, details: Array}}
 */
var correctTimeDimensionInformation = function (dimensionObject, dimensionMeta, meta) {
    var correctedDimensionInformation = {name: dimensionMeta.name, type: "time", details: []};
    
    for (var lookUpIndex = 0; lookUpIndex < dimensionObject.lookups.length; lookUpIndex++) {
        var weekIndex = dimensionObject.lookups[lookUpIndex] - 1;   // total correction
        if(weekIndex < 0) {
            correctedDimensionInformation.details[lookUpIndex] = -1;    // TOTAL VALUE!
        } else {
            correctedDimensionInformation.details[lookUpIndex] = dimensionMeta.details[weekIndex];
        }
    }
    
    return correctedDimensionInformation;
};

/**
 *
 * @param {Object} dimensionObject
 * @param {String} dimensionObject.dimensionName
 * @param {number} dimensionObject.dimensionId
 * @param {Object} dimensionObject.resolution
 * @param {String[]} dimensionObject.lookups
 * @param dimensionMeta
 * @param meta
 */
var correctMeasureDimensionInformation = function (dimensionObject, dimensionMeta, meta) {
    var correctedDimensionInformation = {name: dimensionMeta.name, type: "measure", lookups: []};
    
    for (var measureIndex = 0; measureIndex < meta.measures.length; measureIndex++) {
        var measureDefinition = meta.measures[measureIndex];
        if (measureDefinition.name in dimensionObject.resolution) {
            var lookupIndex = dimensionObject.resolution[measureDefinition.name];
            correctedDimensionInformation.lookups[lookupIndex] = measureDefinition.distributionInformation.code;
        }
    }
    
    return correctedDimensionInformation;
};

/**
 *
 * @param {Object} dimensionObject
 * @param {String} dimensionObject.dimensionName
 * @param {number} dimensionObject.dimensionId
 * @param {Object} dimensionObject.resolution
 * @param {String[]} dimensionObject.lookups
 * @param dimensionMeta
 * @param meta
 * @return {{name: (string|*|String), type: string, lookups: *}}
 */
var correctRegularDimensionInformation = function (dimensionObject, dimensionMeta, meta) {
    var correctedDimensionInformation = {
        name: dimensionObject.dimensionName,
        type: "regular",
        lookups: dimensionObject.lookups
    };
    
    return correctedDimensionInformation;
};

module.exports.ManualChangesSerializer = ManualChangesSerializer;
