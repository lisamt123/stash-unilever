"use strict";
/* globals CasException */

if (typeof require !== "undefined") {
    var _ = require("lodash");
    var bunyan = require('bunyan');
    var benchmark = require('../benchmark');
    var reducers = require('./ArrayReducer').ArrayReducer;
}

var logger = bunyan.createLogger({
    name: "CasAnalytics",
    streams: [{
        level: 'info',
        stream: new MyRawStream(),
        type: 'raw'
    }]
});

// CONSTANTS
var KEYWORD_AGGREGATION = "aggregation";
var KEYWORD_AGGREGATION_RULE = "rule";
var KEYWORD_AGGREGATION_SKIPPED_DIMENSIONS = "skippeddimensions";
var KEYWORD_AXIS = "axis";
var KEYWORD_DATASOURCE = "datasource";
var KEYWORD_DATASOURCE_TABLENAME = "tablename";
var KEYWORD_DATASOURCE_MEASURECODE = "measurecode";
var KEYWORD_DATASOURCE_WEEKOFFSET = "weekoffset";
var KEYWORD_DISPLAY = "display";
var KEYWORD_EDITABLE = "editable";
var KEYWORD_EDITABLE_CODE = "code";
var KEYWORD_EDITABLE_DISTRIBUTION = "distribution";
var KEYWORD_EDITABLE_ENABLEPASTWEEKS = "enablepastweeks";
var KEYWORD_EDITABLE_EDITMODE = "editmode";
var KEYWORD_FORMULA = "formula";
var KEYWORD_TYPE = "type";
var KEYWORD_TYPE_EDITABLE = "editable";
var KEYWORD_TYPE_CALCULATED = "calculated";
var KEYWORD_TYPE_READ = "read";
var KEYWORD_MEASURES = "measures";
var KEYWORD_NAME = "name";
var KEYWORD_STORAGEOPTIONS = "storageoptions";
var KEYWORD_STORAGEOPTIONS_CODE = "code";
var KEYWORD_STORAGEOPTIONS_STORAGELEVELS = "storagelevels";
var KEYWORD_STORAGEOPTIONS_WRITEBACK = "writeback";
var KEYWORD_TOTAL = "total";
var KEYWORD_TOTALCALCULATION = "totalcalculation";
var KEYWORD_TOTALCALCULATION_RULE = "rule";

/**
 *
 * @typedef {Object} MeasureDefinitionCollection
 * @property {MeasureDefinition[]} measures
 * @property {Object} axis
 * @property {Object.<string, number|undefined>} measureIndexMapping
 * @property {Object.<string, number>} editableCodeIndexMapping
 * @property {Object.<string, number>} dimensionIndexMapping
 * @property {Object.<string, number>} levelIndexMapping
 * @property {number} _levelOfMeasures
 */

/**
 * @typedef {{}} MeasureDefinition
 * @property {number} id
 * @property {string} name
 */

/**
 *
 * @type {MeasureDefinitionCollection}
 */
var meta = {};

var log = logger.child({ widget_type: 'MetaParser' });

var parseMeta = function parseMeta(metaInformation) {

    if (typeof metaInformation === "string") {
        throw new CasException.CasException("Could not parse the KPI-Definitions. Use a JSON-Validator and correct all errors before retrying.");
    }

    if (KEYWORD_AXIS in metaInformation) {
        meta.axis = metaInformation[KEYWORD_AXIS];
        computeDimensionIndexMapping(metaInformation[KEYWORD_AXIS].y);
        computeLevelIndexMapping(metaInformation[KEYWORD_AXIS].y);
    } else {
        throw new CasException.CasException("Axis are missing");
    }

    if (KEYWORD_MEASURES in metaInformation) {
        computeMeasureDefinitions(metaInformation[KEYWORD_MEASURES]);
    } else {
        throw new CasException.CasException("Measures are missing!");
    }

    addMetaFunctions();

    return meta;
};

var addMetaFunctions = function () {
    meta.getLevelOfMeasures = getLevelOfMeasures;
    meta.getMeasureIndex = getMeasureIndex;
    meta.getLevelIndex = getLevelIndex;
    meta.getDimensionIndex = getDimensionIndex;
    meta.getDataSourceBasedKPIs = getDataSourceBasedKPIs;
    meta.getWriteBackKPIs = getWriteBackKPIs;
};

/**
 * Gets the information which grouping level the "measures"-level is
 * @function
 * @returns {number}
 */
var getLevelOfMeasures = function () {
    return meta._levelOfMeasures;
};

function parseSkippedDimensions(measureDefinition, aggregationInformation) {

    measureDefinition.hasSkippedDimensions = false;
    measureDefinition.skippedDimensions = [];
    measureDefinition.isDimensionSkipped = function (dimensionId) {
        return (measureDefinition.skippedDimensions[dimensionId] !== undefined);
    };

    if (KEYWORD_AGGREGATION_SKIPPED_DIMENSIONS in aggregationInformation) {
        var skippedDimensions = aggregationInformation[KEYWORD_AGGREGATION_SKIPPED_DIMENSIONS];

        // Validate the Dimensions (Throws an error if a Dimension is not specified)
        for (var i = 0; i < skippedDimensions.length; i++) {
            var skippedDimensionName = skippedDimensions[i];
            measureDefinition.skippedDimensions[getDimensionIndex(skippedDimensionName)] = true;

            measureDefinition.hasSkippedDimensions = true;
        }
    } else {
        log.debug("No skipped Dimensions specified");
    }
}


/**
 * Parses all KPI-Type related information of the measure
 * @param measureDefinition
 * @param {Object} measure
 * @param {string} measure.type
 * @param {string} measure.formula
 * @param {Object} measure.datasource
 * @param {Object} measure.editable
 */
function parseKPITypeInstruction(measureDefinition, measure) {

    measureDefinition.computed = false;
    measureDefinition.isDataSourceBased = false;
    measureDefinition.isEditable = false;

    if (KEYWORD_TYPE in measure) {
        var KPIType = measure[KEYWORD_TYPE];

        switch (KPIType) {
            case KEYWORD_TYPE_CALCULATED:
                parseKpiAsFormula(measureDefinition, measure);
                break;
            case KEYWORD_TYPE_READ:
                parseKpiAsDataSource(measureDefinition, measure);
                break;
            case KEYWORD_TYPE_EDITABLE:
                parseKpiAsEditable(measureDefinition, measure);
                break;
            default:
                log.warn("Unknown KPITYPE. Implementation incomplete");
                throw new CasException.CasException("Error while parsing the KPI '" + measureDefinition.name + "'. Unknown KpiType '" + KPIType + "'");
        }
    } else {
        throw new CasException.CasException("Error while parsing the KPI '" + measureDefinition.name + "'. " + KEYWORD_TYPE + " not specified");
    }
}

/**
 * Parses a KPI as a TableBased KPI (Baseline, Shipment,...)
 * @param measureDefinition
 * @param {Object} measure
 * @param {Object} measure.datasource
 * @param {string} measure.datasource.tablename
 * @param {string} measure.datasource.measurecode
 * @param {number} measure.datasource.weekoffset
 * @throws {CasException}
 */
function parseKpiAsDataSource(measureDefinition, measure) {
    measureDefinition.isDataSourceBased = true;
    measureDefinition.dataSource = {
        tableName: "",
        measureCode: "",
        weekOffset: 0
    };

    if (KEYWORD_DATASOURCE in measure) {
        var dataSource = measure[KEYWORD_DATASOURCE];

        if (KEYWORD_DATASOURCE_TABLENAME in dataSource) {
            measureDefinition.dataSource.tableName = dataSource[KEYWORD_DATASOURCE_TABLENAME];
        } else {
            log.error("The TableName for the KPI " + measureDefinition.name + " is missing!");
        }

        if (KEYWORD_DATASOURCE_MEASURECODE in dataSource) {
            measureDefinition.dataSource.measureCode = dataSource[KEYWORD_DATASOURCE_MEASURECODE];
        } else {
            log.error("The MeasureCode for the KPI " + measureDefinition.name + " is missing!");
        }

        if (KEYWORD_DATASOURCE_WEEKOFFSET in dataSource) {
            measureDefinition.dataSource.weekOffset = dataSource[KEYWORD_DATASOURCE_WEEKOFFSET];
        } else {
            log.warn("The WeekOffset for the KPI " + measureDefinition.name + " is missing!");
        }

    } else {
        throw new CasException.CasException("The Data-Source-Information for the KPI " + measureDefinition.name + " is missing!");
    }
}

/**
 * Parses a KPI as a formula based one
 * @param measureDefinition
 * @param {Object} measure
 * @param {string} measure.formula
 */
function parseKpiAsFormula(measureDefinition, measure) {
    measureDefinition.computed = true;

    if (!(KEYWORD_FORMULA in measure)) {
        log.error(measureDefinition.name + ": Specified a computed measure but no formula! Using fallback (null-Value).");
        measure.formula = "() => null";
    }

    try {
        var formula = parseFormula(measure[KEYWORD_FORMULA]);
        measureDefinition.func = formula.func;
        measureDefinition.args = formula.args;
    } catch (e) {
        throw new CasException.CasException("Error while parsing the formula for KPI: '" + measureDefinition.name + "'.", e);
    }
}

/**
 * Parses the information of editable KPIs
 * @param measureDefinition
 * @param {Object} measure
 * @param {Object} measure.editable
 * @param {string} measure.editable.distribution
 */
function parseKpiAsEditable(measureDefinition, measure) {
    measureDefinition.isEditable = true;
    measureDefinition.distributionInformation = {
        code: "",
        enablePastWeeks: false,
        measureName: "",
        measureIndex: -1,
        mode: "week"
    };

    if (KEYWORD_EDITABLE in measure) {
        var editableInformation = measure[KEYWORD_EDITABLE];
    
        if (KEYWORD_EDITABLE_CODE in editableInformation) {
            var editCode = editableInformation[KEYWORD_EDITABLE_CODE];
        
            measureDefinition.distributionInformation.code = editCode;
            meta.editableCodeIndexMapping[editCode] = measureDefinition.id;
        } else {
            throw new CasException.CasException("The measure on index " + measureDefinition.id + " with the name " + measureDefinition.name + " is defined as editable but has no code assigned!");
        }
    
        if(KEYWORD_EDITABLE_EDITMODE in editableInformation) {
            var mode = editableInformation[KEYWORD_EDITABLE_EDITMODE];
            if(mode === "total") {
                measureDefinition.distributionInformation.mode = "total";
            } else if(mode === "week") {
                measureDefinition.distributionInformation.mode = "week";
            } else {
                measureDefinition.distributionInformation.mode = "week";
                log.warn("The measure on index " + measureDefinition.id + " with the name " + measureDefinition.name + " has an unknown or missing editmode '" + mode + "'!. Using fallback 'week'");
            }
        }
    
        if(measureDefinition.distributionInformation.mode === "week") {
            if (KEYWORD_EDITABLE_ENABLEPASTWEEKS in editableInformation) {
                measureDefinition.distributionInformation.enablePastWeeks = (editableInformation[KEYWORD_EDITABLE_ENABLEPASTWEEKS] === true);
            }
        
            if (KEYWORD_EDITABLE_DISTRIBUTION in editableInformation) {
                var referencedMeasureName = editableInformation[KEYWORD_EDITABLE_DISTRIBUTION];
            
                measureDefinition.distributionInformation.measureName = referencedMeasureName;
                measureDefinition.distributionInformation.measureIndex = getMeasureIndex(referencedMeasureName);
            } else {
                throw new CasException.CasException("The KPI " + measureDefinition.name + " is specified as editable but the distribution information is missing.");
            }
        }
    } else {
        throw new CasException.CasException("The KPI " + measureDefinition.name + " is specified as editable but the information is incomplete.");
    }
}

/**
 * Parses all information for the aggregation
 * @param measureDefinition
 * @param {Object} measure
 * @param {Object} measure.aggregation
 * @param {string} measure.aggregation.rule
 * @param {string[]} measure.aggregation.skippeddimensions
 */
function parseAggregationInstruction(measureDefinition, measure) {
    measureDefinition.aggregation = reducers.none;
    measureDefinition.aggregationIsFormulaBased = false;

    if (KEYWORD_AGGREGATION in measure) {
        var aggregationInformation = measure[KEYWORD_AGGREGATION];

        if (aggregationInformation[KEYWORD_AGGREGATION_RULE] !== undefined) {
            if (aggregationInformation[KEYWORD_AGGREGATION_RULE] === "formula") {
                measureDefinition.aggregationIsFormulaBased = true;
            } else if (aggregationInformation[KEYWORD_AGGREGATION_RULE] in reducers) {
                measureDefinition.aggregation = reducers[aggregationInformation[KEYWORD_AGGREGATION_RULE]];
            } else {
                log.warn("The Aggregation rule of the KPI " + measureDefinition.name + " is not available");
            }
        } else {
            log.warn("The KPI " + measureDefinition.name + " has no Aggregation rule specified.");
        }

        parseSkippedDimensions(measureDefinition, aggregationInformation);

    } else {
        log.warn("The KPI " + measureDefinition.name + " has no Aggregation information specified.");
    }
}

/**
 * Parses all information for the calculation of the total
 * @param measureDefinition
 * @param {Object} measure
 * @param {Object} measure.totalcalculation
 * @param {string} measure.totalcalculation.rule
 */
function parseTotalCalculationInstruction(measureDefinition, measure) {
    measureDefinition.totalCalculation = reducers.none;
    measureDefinition.totalCalculationIsFormulaBased = false;

    if (KEYWORD_TOTALCALCULATION in measure) {
        var totalCalculationInformation = measure[KEYWORD_TOTALCALCULATION];

        if (totalCalculationInformation[KEYWORD_TOTALCALCULATION_RULE] !== undefined) {
            if (totalCalculationInformation[KEYWORD_TOTALCALCULATION_RULE] === "formula") {
                measureDefinition.totalCalculationIsFormulaBased = true;
            } else if (totalCalculationInformation[KEYWORD_TOTALCALCULATION_RULE] in reducers) {
                measureDefinition.totalCalculation = reducers[totalCalculationInformation[KEYWORD_TOTALCALCULATION_RULE]];
            } else {
                log.warn("The TotalCalculation rule of the KPI " + measureDefinition.name + " is not available");
            }
        } else {
            log.warn("The KPI " + measureDefinition.name + " has no TotalCalculation rule specified.");
        }
    } else {
        log.warn("The KPI " + measureDefinition.name + " has no TotalCalculation information specified.");
    }
}

/**
 * Parses all information for the displaying
 * @param measureDefinition
 * @param {Object} measure
 * @param {Object} measure.display
 * @param {boolean} [measure.display.enabled = true]
 * @param {number} [measure.display.round = 2]
 */
function parseDisplayInstruction(measureDefinition, measure) {
    var displayInformation = {
        enabled: true,
        round: 2
    };

    if (KEYWORD_DISPLAY in measure) {
        var display = measure[KEYWORD_DISPLAY];

        if (display.enabled !== undefined) {
            displayInformation.enabled = display.enabled;
        }

        if (display.round !== undefined) {
            displayInformation.round = display.round;
        }
    } else {

        log.info("The measure " + measureDefinition.name + "on index " + measureDefinition.id + " has no display property defined. Using fallback.");
    }

    measureDefinition.display = displayInformation;
}

/**
 *
 * @param measureDefinition
 * @param measure
 */
function parseStorageInstructions(measureDefinition, measure) {
    measureDefinition.storageOptions = {
        code: "",
        writeBack: false,
        levels: []
    };

    if (KEYWORD_STORAGEOPTIONS in measure) {
        var storageOptions = measure[KEYWORD_STORAGEOPTIONS];

        measureDefinition.storageOptions.writeBack = (storageOptions[KEYWORD_STORAGEOPTIONS_WRITEBACK] === true);

        if (measureDefinition.storageOptions.writeBack) {

            if (KEYWORD_STORAGEOPTIONS_CODE in storageOptions) {
                measureDefinition.storageOptions.code = storageOptions[KEYWORD_STORAGEOPTIONS_CODE];
            } else {
                throw new CasException.CasException("The measure on index " + measureDefinition.id + " with the name " + measureDefinition.name + " is defined as writeBack but has no code assigned!");
            }

            if (KEYWORD_STORAGEOPTIONS_STORAGELEVELS in storageOptions) {
                var levels = storageOptions[KEYWORD_STORAGEOPTIONS_STORAGELEVELS];
                if (_.isArray(levels)) {
                    levels.forEach(function (levelName) {
                        measureDefinition.storageOptions.levels.push(levelName);
                    });
                } else {
                    log.error("The measure " + measureDefinition.name + "on index " + measureDefinition.id + " has malformed storageOptions-Information.");
                }
                measureDefinition.storageOptions.levels = storageOptions[KEYWORD_STORAGEOPTIONS_STORAGELEVELS];
            }

            if (measureDefinition.storageOptions.levels.length === 0) {
                measureDefinition.storageOptions.writeBack = false;
                log.warn(measureDefinition.name + ": Writeback activated but no StorageLevel defined. Deactivating writeback for this measure temporary.");
            }
        }
    }
}

/**
 * Parses the name of the measure
 * @param measureDefinition
 * @param {Object} measure
 * @param {string} measure.name
 */
function parseMeasureName(measureDefinition, measure) {
    if (KEYWORD_NAME in measure) {
        measureDefinition.name = measure[KEYWORD_NAME];
    } else {
        measureDefinition.name = "Undefined";
        throw new CasException.CasException("The measure on index " + measureDefinition.id + " has no name assigned!");
    }
}

function computeMeasureDefinitions(measures) {
    meta.measures = [];
    meta.editableCodeIndexMapping = {};
    computeMeasureIndexMapping(measures);

    for (var i = 0; i < measures.length; i++) {
        var measure = measures[i];
        var measureDefinition = {};

        measureDefinition.id = i;

        parseMeasureName(measureDefinition, measure);

        parseDisplayInstruction(measureDefinition, measure);

        parseAggregationInstruction(measureDefinition, measure);

        parseTotalCalculationInstruction(measureDefinition, measure);

        parseKPITypeInstruction(measureDefinition, measure);

        parseStorageInstructions(measureDefinition, measure);

        meta.measures[i] = measureDefinition;

        measureDefinition.dependingMeasures = [];

        /**
         * Registers a measureDefinition as a dependent measure.
         * @param dependingMeasure
         */
        var addDependency = function (dependingMeasure) {
            if (this.id === dependingMeasure.id) {
                throw new CasException.CasException("The KPI '" + dependingMeasure.name + "' cannot depend on itself!");
            } else if (this.dependingMeasures[dependingMeasure.id] === undefined) {
                this.dependingMeasures[dependingMeasure.id] = dependingMeasure;
            } else {
                log.debug("KPI '" + dependingMeasure.name + "' already added as a dependency");
            }
        };

        measureDefinition.registerDependency = addDependency;

        /**
         * indicates whether the aggregation uses a formula or not
         */
        measureDefinition.isAggregationBasedOnFormula = function () {
            return this.aggregationIsFormulaBased;
        };

        /**
         * indicates whether the total calculation uses a formula or not
         */
        measureDefinition.isTotalCalculationBasedOnFormula = function () {
            return this.totalCalculationIsFormulaBased;
        };
    }

    computeMeasureDependencies(meta.measures);
}

/**
 * Computes all direct dependencies between two KPIs
 * @param {Object[]} measureDefinitions
 */
function computeMeasureDependencies(measureDefinitions) {

    for (var i = 0; i < measureDefinitions.length; i++) {
        var measureDefinition = measureDefinitions[i];

        // only necessary for computed KPIs
        if (measureDefinition.computed) {
            for (var argIndex = 0; argIndex < measureDefinition.args.length; argIndex++) {
                var functionArgument = measureDefinition.args[argIndex];
                measureDefinitions[functionArgument.measureIndex].registerDependency(measureDefinition);
            }
        }
    }
}

function computeMeasureIndexMapping(measures) {
    meta.measureIndexMapping = {};
    for (var i = 0; i < measures.length; i++) {
        var measure = measures[i];

        if (meta.measureIndexMapping[measure.name] === undefined) {
            meta.measureIndexMapping[measure.name] = i;
        } else {
            throw new CasException.CasException("KPI-Names must be unique, but found the KPI '" + measure.name + "' multiple times.");
        }
    }
}

function computeDimensionIndexMapping(dimensions) {
    meta.dimensionIndexMapping = {};
    for (var i = 0; i < dimensions.length; i++) {
        var dimensionName = dimensions[i];
        meta.dimensionIndexMapping[dimensionName] = i;

        if (dimensionName === KEYWORD_MEASURES) {
            meta._levelOfMeasures = i;
        }
    }
}

function getDimensionIndex(dimensionName) {
    if (dimensionName in meta.dimensionIndexMapping) {
        return meta.dimensionIndexMapping[dimensionName];
    } else {
        throw new CasException.CasException("Could not find the dimension with the name: " + dimensionName);
    }
}

var computeLevelIndexMapping = function (levels) {
    meta.levelIndexMapping = {};
    for (var i = 0; i < levels.length; i++) {
        var levelName = levels[i];
        meta.levelIndexMapping[levelName] = i;

        if (levelName === KEYWORD_MEASURES) {
            meta._levelOfMeasures = i;
        }
    }
};

/**
 * Gets the index of a specific level via its name
 * @throws {CasException} Throws an exception if the levelName does not exist.
 * @todo Check if this is helpful after changing to dimensions!
 * @param levelName
 */
function getLevelIndex(levelName) {
    if (levelName in meta.levelIndexMapping) {
        return meta.levelIndexMapping[levelName];
    } else {
        throw new CasException.CasException("Could not find the level with the name: " + levelName);
    }
}

/**
 * Parses all function arguments
 * @param {string} argumentString
 * @return {Object}
 */
function parseFunctionArguments(argumentString) {
    var functionArguments = [];

    if (argumentString.trim() !== "") {
        var argumentStrings = argumentString.split(/,/g);
        for (var i = 0; i < argumentStrings.length; i++) {
            var functionArgument = { "isComplexArgument": false };
            var argumentInformation = argumentStrings[i].split(/\$/g);

            if (argumentInformation.length > 3) {
                throw new CasException.CasException("Invalid number of function-argument-delimiter. There are no more than 2 delimiters allowed, but found " + (argumentInformation.length - 1) + " delimiters.");
            } else {
                functionArgument.measureName = argumentInformation[0].trim();
                functionArgument.measureIndex = getMeasureIndex(functionArgument.measureName);

                if (argumentInformation.length > 1) {
                    functionArgument.isComplexArgument = true;
                    functionArgument.levelName = argumentInformation[1].trim();
                    //FixMe: This cannot be solved without the Data/Hierarchy-Information!
                    functionArgument.levelIndex = getLevelIndex(functionArgument.levelName);
                } else {
                    functionArgument.levelName = undefined;
                    functionArgument.levelIndex = undefined;
                }

                if (argumentInformation.length > 2) {
                    argumentInformation[2] = argumentInformation[2].trim().toLowerCase();
                    functionArgument.useTotal = (argumentInformation[2] === KEYWORD_TOTAL);
                } else {
                    functionArgument.useTotal = false;
                }
            }

            functionArguments.push(functionArgument);
        }
    }

    return functionArguments;
}

function parseFormula(formulaString) {
    var parsingResult = {};

    var formulaParts = formulaString.split("=>");
    var args = formulaParts[0];
    var body = formulaParts[1];

    // replace opening and closing parenthesis
    args = args.replace(/[\(\)]/g, "").trim();

    // Create function with args as parameters (if exists) and VARS as additional Parameter
    parsingResult.func = new Function("calcHelper" + (args.length > 0 ? ", " + args : ""),
        // Add the Body of the function
        (body.indexOf("{") < 0 ? "return " : "") + body);

    // Split the Function Arguments by "," and whitespaces if any exist
    parsingResult.args = parseFunctionArguments(args);

    return parsingResult;
}

/**
 * Gets the index of a measure based on its name.
 * @param measuresName
 * @returns {number} the index of the measure (0...n)
 * @throws {Error} Throws an error if the measureName is not valid/cannot be found.
 */
function getMeasureIndex(measuresName) {
    if (measuresName in meta.measureIndexMapping) {
        return meta.measureIndexMapping[measuresName];
    } else {
        throw new CasException.CasException("Could not find the measure with the name: " + measuresName);
    }
}

/**
 * Gets all MeasureDefinitions which are based on database tables
 * @return {Array}
 */
function getDataSourceBasedKPIs() {
    return _.filter(meta.measures, function (measureDefinition) {
        return measureDefinition.isDataSourceBased;
    });
}

/**
 * Gets all MeasureDefinitions where writeBack is enabled
 * @return {Object[]}
 */
function getWriteBackKPIs() {
    return _.filter(meta.measures, function (measureDefinition) {
        return measureDefinition.storageOptions.writeBack;
    });
}

if (typeof module !== "undefined") {
    module.exports.parseMeta = parseMeta;
}

function MyRawStream() {

}

MyRawStream.prototype.write = function (rec) {
    console.log('[%s] %s: %s',
        rec.time.toISOString(),
        bunyan.nameFromLevel[rec.level],
        rec.msg);
};
