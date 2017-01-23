"use strict";

/**
 *
 * @constructor
 * @public
 */
var CalculationVariableParser = function () {
    
};

/**
 *
 * @type {null|Object}
 * @memberOf CalculationVariableParser
 * @private
 */
CalculationVariableParser.prototype._logger = null;

/**
 *
 * @type {benchmark}
 * @memberOf CalculationVariableParser
 * @private
 */
CalculationVariableParser.prototype.benchmark = null;

/**
 *
 * @type {null|Object}
 * @memberOf CalculationVariableParser
 * @private
 */
CalculationVariableParser.prototype.log = null;


/**
 *
 * @param logger
 * @memberOf CalculationVariableParser
 * @public
 */
CalculationVariableParser.prototype.setLogger = function(logger) {
    this._logger = logger;
    this.log = logger.child({widget_type: 'CalculationVariableParser'});
};

/**
 *
 * @param {benchmark} benchmark
 * @memberOf CalculationVariableParser
 * @public
 */
CalculationVariableParser.prototype.setBenchmark = function(benchmark) {
    this.benchmark = benchmark;
};


/**
 * Parses all variables
 *
 * @param {Object} calculationVariables
 * @memberOf CalculationVariableParser
 * @public
 */
CalculationVariableParser.prototype.parse = function(calculationVariables) {
    this.benchmark.startMeasurement("CalculationVariableParser.parse()");
    
    for(var dimensionName in calculationVariables) {
        if(calculationVariables.hasOwnProperty(dimensionName)) {
            var dimension = calculationVariables[dimensionName];
            
            this.parseDimension(dimension);
        }
    }
    
    this.benchmark.endMeasurement("CalculationVariableParser.parse()");
};

/**
 * Parses each member of the given dimension
 *
 * @param {Object} dimension
 * @memberOf CalculationVariableParser
 * @private
 */
CalculationVariableParser.prototype.parseDimension = function(dimension) {
    for(var dimensionMemberName in dimension) {
        if(dimension.hasOwnProperty(dimensionMemberName)) {
            var dimensionMember = dimension[dimensionMemberName];
            
            this.parseDimensionItem(dimensionMember);
        }
    }
};

/**
 * Parses each attribute of the given dimension member
 *
 * @param {Object} dimensionMember
 * @memberOf CalculationVariableParser
 * @private
 */
CalculationVariableParser.prototype.parseDimensionItem = function(dimensionMember) {
    for(var attributeName in dimensionMember) {
        if(dimensionMember.hasOwnProperty(attributeName)) {
            
            if(typeof dimensionMember[attributeName] === "string") {
                this.parseAttributeTypeString(dimensionMember, attributeName);
            }
        }
    }
};

/**
 * Parses an attribute of type String
 *
 * If the string starts with '{' and ends with '}', the value is assumed to be of type Object and will be parsed as such
 *
 * @param {Object} dimensionItem
 * @param {String} attributeName
 * @memberOf CalculationVariableParser
 * @private
 */
CalculationVariableParser.prototype.parseAttributeTypeString = function(dimensionItem, attributeName) {
    var attribute = dimensionItem[attributeName];
    
    if(attribute.length >= 2) {
        if(attribute[0] === "{" && attribute[attribute.length - 1] === "}") {
            try {
                attribute = JSON.parse(attribute);
            } catch(ex) {
                attribute = {};
                this.log.warn("Could not parse the attribute '" + attributeName + "'. Using fallback empty Object.");
                this.log.debug("Parsing the attribute '" + attributeName + "' caused the following exception: " + ex);
            }
            
            dimensionItem[attributeName] = attribute;
        }
    }
};

module.exports.CalculationVariableParser = CalculationVariableParser;
