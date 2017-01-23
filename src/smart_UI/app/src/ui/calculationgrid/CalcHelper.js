"use strict";
var _ = require("lodash");

Date.prototype.ACSF_dayDiff = function (date) {
    var timestamp = this.getTime();
    var dateTimestamp = date.getTime();
    return (timestamp - dateTimestamp) / 86400000;  // milliseconds per day
};

/**
 * Provides helper methods for a calculation formula
 * @param {Object} meta Information about the resulting structure (ColumnOrder, CalculationFormulas,...)
 * @param {Object} meta.axis Information about the axis of the grid
 * @param {string} meta.axis.x Reference to the columns in data.columns
 * @param {string[]} meta.axis.y Reference to the columns in data.columns. Must include "measures" as KeyWord
 * @param {Object[]} meta.measures Collection of all measures of the grid
 * @param {string} meta.measures[].name Name of the measures (for displaying and as reference to columns if provided in data.data)
 * @param {boolean} meta.measures[].display Indicates if the measure shall be displayed or is only necessary for calculation
 * @param {boolean} meta.measures[].editable Indicates if this measure can be edited
 * @param {boolean} meta.measures[].writeBack Indicates if the edited values of this measure shall be persisted (only in use with editable=true)
 * @param {boolean} meta.measures[].computed Indicates if this measure must be calculated
 * @param {string} meta.measures[].formula Formula used for the calculation of this measure (only in use with computed=true), must be a valid JS-Function. Can reference measures and VARS
 * @param {string} meta.measures[].aggregation Instruction how to aggregate this measure (null|+|min|max...)
 * @param {string} meta.measures[].totalColumnCalc Instruction how to aggregate the TotalColumn (null|+|min|max...) (see meta.total.display)
 * @param {Object} meta.total Information if the TotalColumn should be calculated/displayed
 * @param {boolean} meta.total.display Indicates if the TotalColumn shall be calculated and displayed (see data.columns[].totalColumnCalc)
 * @param {string} meta.total.label Label to be displayed/returned for the TotalColumn
 * @param {Object} metaData The data itself and information about the structure of the Data
 * @param {number[][]} metaData.data The Data itself and the MetaData about the given Data
 * @param {Object[]} metaData.dimensions Collection of all columns information of the tableData
 * @param {String} metaData.dimensions[].name Name of the Column
 * @param {String[]} metaData.dimensions[].lookups 0-Indexed lookUp-Values for the tableData
 * @param {Object} variables promotion variables of the current promotion
 * @param {Object} logger object
 */
var CalcHelper = function CalcHelper(meta, metaData, variables, logger) {
    /**
     * Current TreeNode
     * @type {TreeNode}
     * @private
     */
    var _node = null;

    /**
     * Currently calculated Week
     * @type number|null
     * @private
     */
    var _weekIndex = null;

    /**
     * Current position within the Tree
     * @type {number[]|null}
     * @private
     */
    var _position = null;

    var _contextVariables = {};

    var self = this;
    var _externalLogger = logger.child({widget_type: "formula"});  // logger for formulas
    var _internalLogger = logger.child({widget_type: 'calcHelper'});
    var _weekVariables = _.find(metaData.dimensions, function (dim) {
        return dim.type === "time";
    });

    /**
     * sets the node into the context
     * @param {TreeNode} node The node that defines the new context
     */
    this.setNode = function (node) {
        _node = node;
        _position = null;
        _weekIndex = null;
        _contextVariables = {};
    };

    this.setWeekIndex = function (weekIndex) {
        _weekIndex = weekIndex;
    };

    /**
     * Gets the position of the current node in the tree (path)
     * @return {number[]}
     */
    this.getPosition = function () {
        if (_position === null) {
            _position = _node.getPositionInTree();
        }
        return _position;
    };

    /**
     * Returns the level of the current node as text
     * return {string|null}
     */
    this.getLevelName = function () {
        if (_node === null) {
            _internalLogger.fatal(this.formatLogMessage('getLevelName: No node defined.'));
            return null;
        }
        // todo: hierarchy levels
        var level = _node.getDimensionId();

        return meta.axis.y[level];
    };

    /**
     * Gets a set of variables based on the current context and the defined dimension
     * @param {String} dimensionName
     * @returns {null|Object}
     */
    var getContextVariables = function(dimensionName) {
        if(_contextVariables[dimensionName] !== undefined) {
            // get cached variables
            return _contextVariables[dimensionName];
        } else {
            var levelVariables;
            var id;

            if (dimensionName === "Promotion") {
                levelVariables = variables["promotions"];
                for (id in levelVariables) {
                    break;
                }  // get the 'first' promotion id
            }
            else {
                var dimension = metaData.getDimensionByName(dimensionName);
                var levelIdx = metaData.getLevelIndex(dimensionName);
                var lookupIndex = self.getPosition()[levelIdx];
                id = dimension.lookups[lookupIndex];
                var levelNamePlural = dimensionName.toLowerCase() + 's';

                levelVariables = variables[levelNamePlural];
                if (levelVariables === undefined) {
                    _internalLogger.error(self.formatLogMessage('getVariable: ' + dimensionName + " variables are not supported"));
                    _contextVariables[dimensionName] = null;
                    return null;
                }
            }

            var levelObjectVariables = levelVariables[id];
            if (levelObjectVariables !== undefined) {
                _contextVariables[dimensionName] = levelObjectVariables;
            } else {
                _contextVariables[dimensionName] = null;
                _internalLogger.error(self.formatLogMessage('getVariable: ' + dimensionName + ' with id ' + id + ' does not exist'));
            }

            return levelObjectVariables;
        }
    };

    /**
     * gets a value of a promotion variable
     * @param levelName "Promotion"|"Tactic"
     * @param variableName name of the variable
     */
    var getPromotionVariable = function (levelName, variableName) {
        var levelObjectVariables = getContextVariables(levelName);

        if (levelObjectVariables !== null) {
            var result = levelObjectVariables[variableName];
            if (result !== undefined) {
                return result;
            } else {
                _internalLogger.error(self.formatLogMessage('getVariable: variable ' + variableName + ' is not available for ' + levelName + ' with Id: ' + _node.getLabel()));
            }
        }

        return null;
    };


    /**
     * Gets a value from the details of the Week dimension
     * @param variableName name of the week variable
     */
    var getWeekVariable = function (variableName) {
        if (_weekIndex > 0) {
            if (_weekVariables != null) {
                var week = _weekIndex - 1;  // skip the total
                if (week in _weekVariables.details) {
                    var weekVariablesCurrentWeek = _weekVariables.details[week];
                    if (variableName in weekVariablesCurrentWeek) {
                        return weekVariablesCurrentWeek[variableName];
                    }
                    else {
                        _internalLogger.error(self.formatLogMessage('getVariable: variable ' + variableName + ' is not supported for week ' + week));
                    }
                }
                else {
                    _internalLogger.error(self.formatLogMessage('getVariable: no variables given for week ' + week));
                }
            }
            else {
                _internalLogger.error(self.formatLogMessage("getVariable: week variables are not supported"));
            }
        }
        else {
            return null;
        }
    };

    /**
     * Determines the value of a variable
     * @param {string} levelName The level on which the variable is defined
     * @param {string} variableName The name of the variable
     * @return {string|number|null|object}
     */
    this.getVariable = function (levelName, variableName) {
        var result;

        if (levelName === "Week") {
            result = getWeekVariable(variableName);
        }
        else {
            result = getPromotionVariable(levelName, variableName);
        }

        return result;
    };

    /**
     * calculates the fixed costs
     * @param {number} Volume The volume of the current node
     * @param {number} Volume$Tactic$Total The volume of the whole tactic
     * @return {number|null}
     */
    this.calculateFixedCosts = function (Volume, Volume$Tactic$Total) {
        var compensationModel = this.getVariable('Tactic', 'compensationmodel');
        var calculatedCosts = null;

        switch (compensationModel) {
            case "LumpSum":
                var amount = this.getVariable('Tactic', 'amount');
                calculatedCosts = amount * Volume / Volume$Tactic$Total;
                break;
            case "PerCase":
            case "Percentage":
                _internalLogger.trace(this.formatLogMessage('calculateFixedCosts: Compensation model ' + compensationModel + ' is not supported'));
                break;
            default:
                _internalLogger.warn(this.formatLogMessage('calculateFixedCosts: Compensation model ' + compensationModel + ' is not supported'));
        }

        return calculatedCosts;
    };

    /**
     * calculates the variable costs
     * @param {number} Volume The volume of the current node
     * @param {number} Price The price of one item
     * @return {number|null}
     */
    this.calculateVariableCosts = function (Volume, Price) {
        var compensationModel = this.getVariable('Tactic', 'compensationmodel');
        var amount = this.getVariable('Tactic', 'amount');
        var calculatedCosts = null;

        switch (compensationModel) {
            case "PerCase":
                calculatedCosts = Volume * amount;
                break;
            case "Percentage":
                calculatedCosts = Volume * Price * amount / 100;
                break;
            case "LumpSum":
                _internalLogger.trace(this.formatLogMessage('calculateVariableCosts: Compensation model ' + compensationModel + ' is not supported'));
                break;
            default:
                _internalLogger.warn(this.formatLogMessage('calculateVariableCosts: Compensation model ' + compensationModel + ' is not supported'));
        }

        return calculatedCosts;
    };

    /**
     * Gets the name of the current measure
     * @return {string}
     */
    this.getMeasureName = function () {
        var measureName = "";
        var measureDefinition = _node.getMeasureDefinition();

        if (measureDefinition !== null) {
            measureName = measureDefinition.name;
        }

        return measureName;
    };

    /**
     * length of the intersection of two given timeframes (in weeks)
     * @param {Date} weekStart start date of the first period
     * @param {Date} weekEnd end date of the first period
     * @param {Date} timeframeStart start date of the second period
     * @param {Date} timeframeEnd end date of the second period
     * @return {number|null}
     */
    var weekShareAux = function (weekStart, weekEnd, timeframeStart, timeframeEnd) {
        var result = null;
        var start = weekStart > timeframeStart ? weekStart : timeframeStart;
        var end = weekEnd < timeframeEnd ? weekEnd : timeframeEnd;
        if (start <= end) {
            result = (1 + end.ACSF_dayDiff(start)) / 7;
        }

        return result;
    };

    /**
     * fraction of the currently calculate calender week which belong to the timeframe of the current tactic or promotion
     * @return {number}
     */
    this.weekShare = function () {
        var level = this.getLevelName();
        var weekValidFrom = new Date(this.getVariable('Week', 'datefrom'));
        var weekValidThru = new Date(this.getVariable('Week', 'datethru'));
        var levelName = level === 'measures' ? "Promotion" : "Tactic";
        var validFrom = new Date(this.getVariable(levelName, 'datefrom'));
        var validThru = new Date(this.getVariable(levelName, 'datethru'));

        return weekShareAux(weekValidFrom, weekValidThru, validFrom, validThru);
    };

    /**
     * Number of days from today to the currently calculated week
     * @return {number}
     */
    this.daysUntilStart = function () {
        return new Date(this.getVariable('Week', 'datefrom')).ACSF_dayDiff(new Date());
    };

    /**
     * Is the currently calculated week the start week of the promotion/tactic?
     * @return {Boolean}
     */
    this.isStartWeek = function () {
        var weekStart = new Date(this.getVariable('Week', 'datefrom'));
        var levelName = this.getLevelName() === 'measures' ? 'Promotion' : 'Tactic';
        var timeframeStart = new Date(this.getVariable(levelName, 'datefrom'));
        return weekStart <= timeframeStart && timeframeStart.ACSF_dayDiff(weekStart) <= 6;
    };

    /**
     * Is the currently calculated week the end week of the promotion/tactic?
     * @return {Boolean}
     */
    this.isEndWeek = function () {
        var weekEnd = new Date(this.getVariable('Week', 'datethru'));
        var levelName = this.getLevelName() === 'measures' ? 'Promotion' : 'Tactic';
        var timeframeEnd = new Date(this.getVariable(levelName, 'datethru'));
        return weekEnd >= timeframeEnd && timeframeEnd.ACSF_dayDiff(weekEnd) >= -6;
    };
    
    /**
     * @typedef {{}} TierDefinition
     * @property {TierItem[]} tier
     */
    
    /**
     * @typedef {{}} TierItem
     * @property {number} fromValue
     * @property {number} toValue
     * @property {number} amount
     */
    
    /**
     * Get the tiered rate of the tactic based on the given amount
     * @param {string} variableName Name of the attribute in the tactic containing the tiered rates
     * @param {number} amount
     * @returns {number}
     */
    this.getTieredRate = function(variableName, amount) {
        var tieredRate = 0;
        
        if(amount >= 0) {
    
            /**
             * @type TierDefinition|null
             */
            var tierDefinition = this.getVariable('Tactic', variableName);
    
            if(tierDefinition !== null && typeof tierDefinition === "object") {
                
                var tiers = tierDefinition.tier;
                if(tiers !== undefined && Array.isArray(tiers) && tiers.length > 0) {
                    var matchingTierRateFound = false;
                    
                    for(var tierIndex = 0; tierIndex < tiers.length; tierIndex++) {
                        var tier = tiers[tierIndex];
                        
                        if(tier.fromValue <= amount && amount < tier.toValue) {
                            tieredRate = tier.amount;
                            matchingTierRateFound = true;
                            break;
                        }
                    }
                    
                    if(!matchingTierRateFound) {
                        var highestTier = tiers[tiers.length - 1];
                        if(amount >= highestTier.toValue) {
                            tieredRate = highestTier.amount;
                        }
                    }
                } else {
                    _internalLogger.warn(this.formatLogMessage('Expected tiered rates!'));
                }
            }
        }
        
        return tieredRate;
    };
    
    /**
     * Formats the message (prepends the measureName if available)
     * @param {string} msg
     * @return {string}
     */
    this.formatLogMessage = function (msg) {
        var measureName = this.getMeasureName();

        if (measureName !== "") {
            msg = measureName + ": " + msg;
        }

        return msg;
    };

    /**
     * Logs a message with priority 'trace'
     * @param {string} msg
     */
    this.trace = function (msg) {
        _externalLogger.trace(this.formatLogMessage(msg));
    };

    /**
     * Logs a message with priority 'trace'
     * @param {string} msg
     */
    this.debug = function (msg) {
        _externalLogger.debug(this.formatLogMessage(msg));
    };

    /**
     * Logs a message with priority 'info'
     * @param {string} msg
     */
    this.info = function (msg) {
        _externalLogger.info(this.formatLogMessage(msg));
    };

    /**
     * Logs a message with priority 'warn'
     * @param {string} msg
     */
    this.warn = function (msg) {
        _externalLogger.warn(this.formatLogMessage(msg));
    };

    /**
     * Logs a message with priority 'error'
     * @param {string} msg
     */
    this.error = function (msg) {
        _externalLogger.error(this.formatLogMessage(msg));
    };

    /**
     * Logs a message with priority 'fatal'
     * @param {string} msg
     */
    this.fatal = function (msg) {
        _externalLogger.fatal(this.formatLogMessage(msg));
    };

};

module.exports.CalcHelper = CalcHelper;
