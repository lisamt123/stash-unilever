"use strict";
/* globals CasException */

if (typeof require !== "undefined") {
    var _ = require("lodash");
    var bunyan = require('bunyan');
    var benchmark = require('../benchmark');
    var metaParser = require('./MetaParser');
    var calcHelper = require('./CalcHelper');
    var TreeBuilder = require('./TreeBuilder');
    var TreeNode = require('./TreeNode');
    var ManualChangesSerializer = require('./ManualChangesSerializer').ManualChangesSerializer;
    var CalculationVariableParser = require('./CalculationVariableParser').CalculationVariableParser;
}

var TOTAL_COLUMN_NAME = "Total";

var logger = bunyan.createLogger({
    name: "CasAnalytics",
    streams: [{
        level: 'info',
        stream: new MyRawStream(),
        type: 'raw'
    }]
});

/**
 *
 * @constructor
 */
var Tree = function () {
    var log = logger.child({widget_type: 'Tree'});

    var dataMeta = {};
    var rootNode = null;
    var helper = null;
    var variables = null;
    var manualChangesSerializer = null;

    var meta = {};
    var nodeCounter = 0;

    /**
     * Gets an instance of the serializer for manual changes
     * @return {ManualChangesSerializer}
     */
    this.getManualChangesSerializer = function () {
        if (manualChangesSerializer === null) {
            manualChangesSerializer = new ManualChangesSerializer(dataMeta, meta, logger, benchmark);
        }

        return manualChangesSerializer;
    };

    /**
     * Gets the MetaInformation of this Tree
     * @returns {*}
     */
    this.getMeta = function () {
        return meta;
    };

    /**
     * gets the DataMeta Information of this Tree
     * @returns {{}}
     */
    this.getDataMeta = function () {
        return dataMeta;
    };

    this.getVariables = function () {
        return variables;
    };

    /**
     * Gets all lookup values of the specified column
     * @param {string} dimensionName
     * @returns {string[]}
     */
    function getLookupValues(dimensionName) {
        //FixMe: Will only work on dimensions!
        var values = [];
        var dimension = _.find(dataMeta.dimensions, ["name", dimensionName]);
        if (dimension !== undefined) {
            if (dimension.type === "time") {
                values = dimension.details;
            }
            else {
                values = dimension.lookups;
            }
        }
        else {
            log.warn("Missing dimension named: " + dimensionName + "!");
        }

        return values;
    }

    function processDimensionInformation() {
        var measureDimension = _.find(dataMeta.dimensions, ["type", "measure"]);
        if (measureDimension !== undefined) {
            dataMeta.measureDimensionName = measureDimension.name;
            dataMeta.isMeasureDimensionName = isMeasureDimensionName;
        }
        else {
            throw new CasException.CasException("The Data does not contain a dimension of type 'measure'.");
        }

        processTimeDimensionInformation();
    }

    function processTimeDimensionInformation() {
        var timeDimension = _.find(dataMeta.dimensions, ["type", "time"]);

        if (timeDimension !== undefined) {
            dataMeta.today = (new Date()).setHours(0, 0, 0, 0);
            dataMeta.timeDimensionName = timeDimension.name;
            dataMeta.timeDetails = timeDimension.details;
            dataMeta.noOfDataColumns = timeDimension.details.length + 1;

            dataMeta.currentWeekIndex = -1;
            for (var detailsIndex = 0; detailsIndex < timeDimension.details.length; detailsIndex++) {
                var timeDetails = timeDimension.details[detailsIndex];
                var dateFrom = new Date(timeDetails.datefrom);
                var dateThru = new Date(timeDetails.datethru);

                if (dateFrom <= dataMeta.today && dataMeta.today <= dateThru) {
                    // correct week found (current week is today)
                    dataMeta.currentWeekIndex = detailsIndex;
                    break;
                } else if (dateThru < dataMeta.today) {
                    // current week lies in the past
                    dataMeta.currentWeekIndex = detailsIndex + 1;
                }
            }
        }
        else {
            throw new CasException.CasException("The Data does not contain a dimension of type 'time'.");
        }
    }

    /**
     * Indicates if the given dimensionName is equal to the name of the measure dimension
     * @param {string} dimensionName
     * @return {boolean}
     */
    function isMeasureDimensionName(dimensionName) {
        return (dataMeta.measureDimensionName === dimensionName);
    }

    function computeAllLevels(yAxis, dimensionsInformation) {
        dataMeta.allLevels = [];
        dataMeta.levelNameDimensionIndexMapping = {};
        dataMeta.levelNameDimensionNameMapping = {};
        dataMeta.dimensionByName = {};

        for (var dimensionIndex = 0; dimensionIndex < yAxis.length; dimensionIndex++) {
            var hierarchicalMapping = [];

            var dimensionName = yAxis[dimensionIndex];
            if (dimensionName === "measures") {
                dimensionName = dataMeta.measureDimensionName;
            }

            var dimensionInfo = _.find(dimensionsInformation, ["name", dimensionName]);
            if (dimensionInfo !== undefined) {
                dataMeta.dimensionByName[dimensionName] = dimensionInfo;

                do {
                    dataMeta.levelNameDimensionIndexMapping[dimensionInfo.name] = dimensionIndex;
                    dataMeta.levelNameDimensionNameMapping[dimensionInfo.name] = dimensionName;

                    hierarchicalMapping.unshift(dimensionInfo.name);
                    dimensionInfo = dimensionInfo.hierarchy;
                } while (dimensionInfo !== undefined);

                dataMeta.allLevels = _.concat(dataMeta.allLevels, hierarchicalMapping);
            }
            else {
                throw new CasException.CasException("The dimension with the name " + dimensionName + " is not part of the data.");
            }
        }

        dataMeta.getLevelIndex = getLevelIndex;
        dataMeta.getDimensionIndex = getDimensionIndex;
        dataMeta.getDimensionName = getDimensionName;
        dataMeta.getDimensionByName = getDimensionByName;
    }

    function getDimensionByName(dimensionName) {
        if(dataMeta.dimensionByName[dimensionName] !== undefined) {
            return dataMeta.dimensionByName[dimensionName];
        } else {
            throw new CasException.CasException("Cannot find the dimension with the name " + dimensionName);
        }
    }

    function getLevelIndex(levelName) {
        var adjustedLevelName = levelName;
        if(levelName === "measures") {
            adjustedLevelName = dataMeta.measureDimensionName;
        }
        var levelIndex = _.indexOf(dataMeta.allLevels, adjustedLevelName);

        if (levelIndex >= 0) {
            return levelIndex;
        }
        else {
            throw new CasException.CasException("Cannot find the level with the name " + levelName);
        }
    }

    function getDimensionIndex(levelName) {
        if (levelName in dataMeta.levelNameDimensionIndexMapping) {
            return dataMeta.levelNameDimensionIndexMapping[levelName];
        }
        else {
            throw new CasException.CasException("Cannot identify the dimension of the level with the name " + levelName);
        }
    }

    function getDimensionName(levelName) {
        if (levelName in dataMeta.levelNameDimensionNameMapping) {
            return dataMeta.levelNameDimensionNameMapping[levelName];
        }
        else {
            throw new CasException.CasException("Cannot identify the dimension of the level with the name " + levelName);
        }
    }

    /**
     * Creates and stores allHeaders
     * Includes the TotalColumn if necessary
     * @param {string} xAxis
     * @param {string[]} yAxis
     */
    function computeAllHeaders(xAxis, yAxis) {
        var xAxisValues = getLookupValues(xAxis);

        meta.allHeaders = _.concat(yAxis, TOTAL_COLUMN_NAME, xAxisValues);
        meta.dataColumnHeaders = _.concat(TOTAL_COLUMN_NAME, xAxisValues);
    }

    /**
     * Loads all Data, Meta and Variables into the Tree
     * @param {Object} data The data itself and information about the structure of the Data
     * @param {number[][]} data.data The Data itself and the MetaData about the given Data
     * @param {*} data.relations The Data itself and the MetaData about the given Data
     * @param {Object[]} data.dimensions Collection of all dimensions information of the tableData
     * @param {String} data.dimensions[].name Name of the Column
     * @param {String[]} data.dimensions[].lookups 0-Indexed lookUp-Values for the tableData
     * @param {Object} metaInfo Information about the resulting structure (ColumnOrder, CalculationFormulas,...)
     * @param {Object} metaInfo.axis Information about the axis of the grid
     * @param {string} metaInfo.axis.x Reference to the dimensions in data.dimensions
     * @param {string[]} metaInfo.axis.y Reference to the dimensions in data.dimensions. Must include "measures" as KeyWord
     * @param {Object[]} metaInfo.measures Collection of all measures of the grid
     * @param {string} metaInfo.measures[].name Name of the measures (for displaying and as reference to columns if provided in data.data)
     * @param {boolean} metaInfo.measures[].display Indicates if the measure shall be displayed or is only necessary for calculation
     * @param {boolean} metaInfo.measures[].editable Indicates if this measure can be edited
     * @param {boolean} metaInfo.measures[].writeBack Indicates if the edited values of this measure shall be persisted (only in use with editable=true)
     * @param {boolean} metaInfo.measures[].computed Indicates if this measure must be calculated
     * @param {string} metaInfo.measures[].formula Formula used for the calculation of this measure (only in use with computed=true), must be a valid JS-Function. Can reference measures and VARS
     * @param {string} metaInfo.measures[].aggregation Instruction how to aggregate this measure (null|sum|min|max...)
     * @param {string} metaInfo.measures[].totalCalculation Instruction how to aggregate the TotalColumn (null|sum|min|max...) (see meta.total.display)
     * @param {Object} metaInfo.total Information if the TotalColumn should be calculated/displayed
     * @param {boolean} metaInfo.total.display Indicates if the TotalColumn shall be calculated and displayed (see data.dimensions[].totalCalculation)
     * @param {string} metaInfo.total.label Label to be displayed/returned for the TotalColumn
     * @param {Array} vars Additional Variables as Key-Value-Pairs (used for calculation)
     * @param {Object} manualChanges
     */
    this.loadData = function (data, metaInfo, vars, manualChanges) {
        benchmark.startMeasurement('loadData');
        log.trace("loadData() - Start");
    
        log.trace("Parsing Variables");
        var startDate = Date.now();
        var variableParser = new CalculationVariableParser();
        variableParser.setBenchmark(benchmark);
        variableParser.setLogger(log);
    
        variableParser.parse(vars);
        variables = vars;
        log.trace("Parsing Variables done: " + (Date.now() - startDate));
    
        log.trace("Parsing Meta:");
        startDate = Date.now();
        meta = metaParser.parseMeta(metaInfo);
        log.trace("Parsing Meta done: " + (Date.now() - startDate));
    
        dataMeta.dimensions = data.dimensions;
        dataMeta.relations = data.relations;
        
        log.trace("processDimensionInformation:");
        startDate = Date.now();
        processDimensionInformation();
        log.trace("processDimensionInformation done: " + (Date.now() - startDate));
    
        log.trace("computeAllLevels:");
        startDate = Date.now();
        computeAllLevels(meta.axis.y, data.dimensions);
        log.trace("computeAllLevels done: " + (Date.now() - startDate));
    
        log.trace("computeAllHeaders:");
        startDate = Date.now();
        computeAllHeaders(meta.axis.x, meta.axis.y);
        log.trace("computeAllHeaders done: " + (Date.now() - startDate));
    
        helper = new calcHelper.CalcHelper(meta, dataMeta, vars, log);
    
        TreeNode.setCalcHelper(helper);
        TreeNode.setLogger(log);
        TreeNode.setDataMeta(dataMeta);
        TreeNode.setMeta(meta);
    
        log.trace("getTreeBuilder:");
        startDate = Date.now();
        var treeBuilder = this.getTreeBuilder(data);
        log.trace("getTreeBuilder done: " + (Date.now() - startDate));
        
        log.trace("buildTree:");
        startDate = Date.now();
        this.buildTree(treeBuilder);
        log.trace("buildTree done: " + (Date.now() - startDate));
    
        log.trace("fillTree:");
        startDate = Date.now();
        this.fillTree(data.data);
        log.trace("fillTree done: " + (Date.now() - startDate));
    
        log.trace("applyManualChanges:");
        startDate = Date.now();
        this.applyManualChanges(manualChanges);
        log.trace("applyManualChanges done: " + (Date.now() - startDate));
    
        log.trace("loadData() - End");
        benchmark.endMeasurement('loadData');
    };

    /**
     * @private
     * @memberOf Tree
     */
    this.applyManualChanges = function applyManualChanges(manualChanges) {
        log.debug("Applying manual changes");
        benchmark.startMeasurement("applyManualChanges");
        var deserializedChanges = {};

        var serializer = this.getManualChangesSerializer();

        if (serializer.isValid(manualChanges)) {
            deserializedChanges = serializer.deserialize(manualChanges);
        }
        else {
            log.debug("No valid manual changes found");
        }

        if (deserializedChanges.length > 0) {
            var rootNode = this.getRootNode();

            for (var changeIndex = 0; changeIndex < deserializedChanges.length; changeIndex++) {
                var change = deserializedChanges[changeIndex];
                var currentNode = rootNode.getNode(change.path);

                if (currentNode !== undefined) {
                    currentNode.set(change.columnIndex, change.value);
                }
                else {
                    log.info("Could not apply a change. As the path could not be resolved");
                }
            }

            log.debug("Applied " + deserializedChanges.length + " manual changes");
        }
        else {
            log.debug("No changes to be applied");
        }

        benchmark.endMeasurement("applyManualChanges");
    };

    /**
     * @private
     * @memberOf Tree
     * @param {[][]}data
     */
    this.fillTree = function fillTree(data) {
        log.debug("Filling the Tree");
        benchmark.startMeasurement("fillTree");
        this.fillTreeNode(this.getRootNode(), data, 0);
        benchmark.endMeasurement("fillTree");
    };

    /**
     *
     * @private
     * @memberOf Tree
     * @param {TreeNode} parentNode
     * @param {[][]} data
     * @param {number} dimensionIndex
     */
    this.fillTreeNode = function fillTreeNode(parentNode, data, dimensionIndex) {
        // getName of the dimension (Tactic/measures/Prd,...)
        var dimensionName = meta.axis.y[dimensionIndex];
        var correctedDimensionName = dimensionName;
        if (dimensionName === "measures") {
            correctedDimensionName = dataMeta.measureDimensionName;
        }

        // get Dimension via its name from dataMeta.dimensions.find(
        var dataMetaDimensionIndex = _.findIndex(dataMeta.dimensions, {"name": correctedDimensionName});
        var dataMetaDimension = dataMeta.dimensions[dataMetaDimensionIndex];

        for (var nodeId = -1; nodeId < dataMetaDimension.lookups.length; nodeId++) {
            var correctedNodeId = nodeId;
            if (dimensionName === "measures") {
                correctedNodeId = _.findIndex(meta.measures, ["name", dataMetaDimension.lookups[nodeId]]);
            }

            // get only this part of the data where the value {nodeId} on the index {dataMetaDimensionIndex} matches
            var partitionedData = _.partition(data, [dataMetaDimensionIndex, nodeId]);
            var dimensionData = partitionedData[0];
            data = partitionedData[1];

            if (dimensionData.length > 0) {

                var node = this.getDimensionNode(parentNode, correctedNodeId, dataMetaDimension.hierarchy);

                if (node.isLeaf()) {
                    var dataIndex = _.findIndex(dataMeta.dimensions, ["name", meta.axis.x]);
                    var rawData = dimensionData[0][dataIndex]; // check if here a check is necessary due to missing data

                    node.setRawData(rawData);
                }
                else {
                    this.fillTreeNode(node, dimensionData, dimensionIndex + 1);
                }
            }
        }

        if (data.length > 0) {
            log.warn("fillTreeNode: Could not set all data. Remaining data: " + JSON.stringify(data));
        }
    };

    /**
     *
     * @param {Object} hierarchy
     * @param {string} hierarchy.name
     * @param {Object|undefined} hierarchy.hierarchy
     * @param {string[]} hierarchy.lookups
     * @param {string} oldLevel
     * @param {SimpleTree} filters
     * @param {Object[]} allLevels
     * @param {number} dimensionIndex
     * @param {number} hierarchyIndex
     * @return {string}
     */
    this.getLevelsForTreeBuilder = function (hierarchy, oldLevel, filters, allLevels, dimensionIndex, hierarchyIndex) {
        var newLevel = hierarchy.name;
        if (hierarchy.hierarchy !== undefined && hierarchy.hierarchy.lookups !== undefined) {
            oldLevel = this.getLevelsForTreeBuilder(hierarchy.hierarchy, oldLevel, filters, allLevels, dimensionIndex, hierarchyIndex + 1);
            var levels = [oldLevel, newLevel];
            var mapping = [1, 0];
            var filter = TreeBuilder.addIndex(hierarchy.hierarchy.mapping);
            filters.push(TreeBuilder.createFilterTree(filter, mapping, levels));
        }
        var lookups = hierarchy.lookups;
        var level = {};
        level.startIndex = newLevel === dataMeta.measureDimensionName || hierarchyIndex > 0 ? 0 : -1;
        level.endIndex = lookups.length - 1;
        level.dimensionIndex = dimensionIndex;
        level.hierarchyIndex = hierarchyIndex;
        level.name = newLevel;
        allLevels.push(level);
        return newLevel;
    };

    /**
     * gets all filters to build up the tree
     * @param data response from the web service with the data
     */
    this.getTreeBuilder = function (data) {
        // dimension info
        var measureDimensionName = dataMeta.measureDimensionName;
        var filters = [];
        var allLevels = [];
        var oldLevel = "ROOT";
        //for (var dimIndex in dimensions) {
        for (var i = 0; i < meta.axis.y.length; i++) {
            var dimName = meta.axis.y[i];
            if (dimName === "measures") {
                dimName = measureDimensionName;
            }
            var dimension = dataMeta.getDimensionByName(dimName);
            oldLevel = this.getLevelsForTreeBuilder(dimension, oldLevel, filters, allLevels, i, 0);
        }

        // relations:
        var relations = data.relations;
        for (var relIndex = 0; relIndex < relations.length; relIndex++) {
            var relation = relations[relIndex];
            if (relation === undefined) {
                continue;
            } else {
                var levels = relation.dimensions;
                var filter = relation.mapping;
                var mapping = levels.map(
                    function (name, index) {
                        return index;
                    });
                filters.push(TreeBuilder.createFilterTree(filter, mapping, levels));
            }
        }

        // fix number of measures
        // Do not delete. Still in use: Needs to be optimized!
        var measures = meta.measures;
        var measureLevel = _.find(allLevels, {"name": measureDimensionName});
        measureLevel.endIndex = measures.length - 1;

        // implicite relations
        for (var i = 0; i < meta.axis.y.length; i++) {
            var dimName = meta.axis.y[i];
            if (dimName === "measures") {
                continue;
            } else {
                var dimension = dataMeta.getDimensionByName(dimName);
                var levels = [measureDimensionName, dimension.name];
                var mapping = [0, 1];
                var filter = [];
                for(var measureIndex = 0; measureIndex < measures.length; measureIndex++) {
                    var measure = measures[measureIndex];
                    if(measure.isDimensionSkipped(i)) {
                        filter.push([measureIndex, -1]);  // only the imaginary item
                    }
                    else {
                        for(var itemIndex = 0; itemIndex < dimension.lookups.length; itemIndex++) {  // all real items
                            filter.push([measureIndex, itemIndex]);
                        }
                    }
                }
                filters.push(TreeBuilder.createFilterTree(filter, mapping, levels));
            }
        }
        return new TreeBuilder.TreeBuilder(0, allLevels, filters);
    };

    /**
     * Builds up the entire tree
     * @private
     * @memberOf Tree
     */
    this.buildTree = function buildTree(treeBuilder) {
        log.debug("Building the tree");
        benchmark.startMeasurement("buildTree");

        var globalId = nodeCounter++;
        rootNode = new TreeNode.TreeNode(globalId, 0, -1, 0, -1, TreeNode._NodeTypes.ROOT, null, null, null);

        this.createTreeNode(rootNode, 0, -1, null, treeBuilder);
        benchmark.endMeasurement("buildTree");
        log.debug("Total number of Nodes: " + nodeCounter);
    };

    var getHierarchyHeight = function (hierarchyInformation) {
        if (hierarchyInformation === undefined) {
            return -1;
        }
        else {
            var parent = hierarchyInformation.hierarchy;
            return getHierarchyHeight(parent) + 1;
        }
    };

    /**
     * Creates new TreeNodes recursively below the given parent including the hierarchy of the dimensions
     * @private
     * @memberOf Tree
     * @param {TreeNode} parentNode
     * @param {number} dimensionIndex
     * @param {Object} hierarchyHeight
     * @param {Object} measureDefinition
     * @param {Object} treeBuilder
     */
    this.createTreeNode = function createTreeNode(parentNode, dimensionIndex, hierarchyHeight, measureDefinition, treeBuilder) {
        var maxDimensionIndex = meta.axis.y.length - 1;
        if (dimensionIndex > maxDimensionIndex) {
            return;
        }

        // getName of the dimension (Tactic/measures/Prd,...)
        var measureDimensionName = dataMeta.measureDimensionName;
        var dimensionName = meta.axis.y[dimensionIndex];
        if (dimensionName === "measures") {
            dimensionName = measureDimensionName;
        }
        if (hierarchyHeight === -1) {
            var dataMetaDimension = dataMeta.getDimensionByName(dimensionName);
            hierarchyHeight = getHierarchyHeight(dataMetaDimension);
        }
        var isLeafLevel = (dimensionIndex === maxDimensionIndex && hierarchyHeight === 0);
        var nodeType = (isLeafLevel) ? TreeNode._NodeTypes.LEAF : TreeNode._NodeTypes.GROUPING;

        var measures;
        if (dimensionName === measureDimensionName) {
            measures = meta.measures;
        }
        var children = treeBuilder.getChildren();
        var startIndex = hierarchyHeight > 0 ? 0 : -1;
        for (var childId = startIndex; childId < children.length; childId++) {
            var childTreeBuilder = children[childId];
            if (childTreeBuilder) {
                if (dimensionName === measureDimensionName) {
                    measureDefinition = measures[childId];
                }
                var root = this.getRootNode();
                var node = new TreeNode.TreeNode(nodeCounter++, childId, dimensionIndex, hierarchyHeight, parentNode.getLevel() + 1, nodeType, parentNode, root, measureDefinition);
                node._data = new Array(dataMeta.noOfDataColumns);
                _.fill(node._data, null);
                if (nodeType === TreeNode._NodeTypes.LEAF) {
                    parentNode.childAreLeafs = true;
                }
                if (isLeafLevel) {
                    parentNode.addChild(node);
                } else {
                    if (hierarchyHeight === 0) {
                        this.createTreeNode(node, dimensionIndex + 1, -1, measureDefinition, childTreeBuilder);
                    } else {
                        this.createTreeNode(node, dimensionIndex, hierarchyHeight - 1, measureDefinition, childTreeBuilder);
                    }

                    if (node._children[-1] || node._children.length > 0) {
                        parentNode.addChild(node);
                    }
                }
            }
        }
    };

    /**
     * Gets a specific dimensionNode (steps through the hierarchy if necessary)
     * @private
     * @memberOf Tree
     * @param {TreeNode} parentDimensionNode
     * @param {number} childId
     * @param {Object} hierarchyInformation
     * @return {TreeNode|undefined}
     */
    this.getDimensionNode = function getDimensionNode(parentDimensionNode, childId, hierarchyInformation) {
        var parentNode;

        if (hierarchyInformation === undefined) {
            parentNode = parentDimensionNode;
        } else {
            var hierarchyParentId = hierarchyInformation.mapping[childId];
            parentNode = this.getDimensionNode(parentDimensionNode, hierarchyParentId, hierarchyInformation.hierarchy);
        }

        return parentNode.getChildNode(childId);
    };

    /**
     * Gets the RootNode
     * @public
     * @returns {TreeNode}
     */
    this.getRootNode = function () {
        return rootNode;
    };

    /**
     * Gets a ChildNode via its global unique Id
     * @param {number} globalId Id of the node to be searched
     * @returns {TreeNode|null}
     */
    this.getChild = function (globalId) {
        log.trace("getChild() - Start");

        var childNode = null;

        if (globalId === 0) {
            childNode = rootNode;
        }
        else {
            childNode = getChildRecursive(rootNode, globalId);
        }

        log.trace("getChild() - End");
        return childNode;
    };

    /**
     * Gets a ChildNode below its parentNode via its global unique Id
     * @param {TreeNode} parentNode Starting Node
     * @param {number} globalId Global unique Id of the node to be searched
     * @returns {TreeNode|null} Node to be found or undefined
     */
    function getChildRecursive(parentNode, globalId) {
        var childNode = null;
        parentNode._children.forEach(function (child) {
            if (child.id === globalId) {
                childNode = child;
            }
            else if (!childNode) {
                childNode = getChildRecursive(child, globalId);
            }
        });

        return childNode;
    };

    /**
     * Collection all WriteBack relevant rows and wor-Identifier
     * @param {[]} result Collection of rows which shall be written back to the DB
     * @param {Object} identifiers
     * @param {TreeNode[]} nodes Collection of nodes which must be check if they are relevant for the writeBack
     */
    this.getWriteBackDataRecursive = function (result, identifiers, nodes) {
        benchmark.startMeasurement('getWriteBackDataRecursive');

        for (var i = -1; i < nodes.length; i++) {
            var currentNode = nodes[i];

            if (currentNode !== undefined) {
                var measureDefinition = currentNode.getMeasureDefinition();
                var dimensionId = currentNode.getDimensionId();
                var dimensionName = meta.axis.y[dimensionId];
                var currentIdentifiers = _.clone(identifiers);
                if (dimensionName === "measures") {
                    currentIdentifiers[dataMeta.measureDimensionName] = measureDefinition.storageOptions.code;
                }
                else {
                    currentIdentifiers[dimensionName] = currentNode.getLabel();
                }

                if (measureDefinition !== null) {
                    if (measureDefinition.storageOptions.writeBack === true) {
                        if (_.find(measureDefinition.storageOptions.levels, ["levelIndex", currentNode.getLevel()])) {
                            var resultRow = _.clone(currentIdentifiers);
                            resultRow.data = currentNode.getData();

                            result.push(resultRow);
                        }
                    }
                    else {
                        // nothing to write back => continue!
                        continue;
                    }
                }

                this.getWriteBackDataRecursive(result, currentIdentifiers, currentNode.getChildren());
            }
        }

        benchmark.endMeasurement('getWriteBackDataRecursive');
    };

    /**
     * Corrects and enhances the writeBack-Information of all relevant KPIs
     * @param {Object} meta
     * @param {Object} dataMeta
     */
    this.updateWriteBackLevelInformation = function (meta, dataMeta) {
        benchmark.startMeasurement('updateWriteBackLevelInformation');
        var writeBackMeasures = meta.getWriteBackKPIs();

        for (var measureIndex = 0; measureIndex < writeBackMeasures.length; measureIndex++) {
            var measure = writeBackMeasures[measureIndex];

            if (measure !== undefined) {
                var levelsInformation = [];
                for (var levelIndex = 0; levelIndex < measure.storageOptions.levels.length; levelIndex++) {
                    var levelName = measure.storageOptions.levels[levelIndex];

                    if(levelName === "measures") {
                        levelName = dataMeta.measureDimensionName;
                    }

                    if (levelName in dataMeta.levelNameDimensionIndexMapping) {
                        var levelInfo = {
                            levelName: levelName,
                            levelIndex: dataMeta.getLevelIndex(levelName),
                            dimensionName: dataMeta.getDimensionName(levelName),
                            dimensionIndex: dataMeta.getDimensionIndex(levelName)
                        };

                        levelsInformation.push(levelInfo);
                    }
                    else {
                        log.error("The level with the name '" + levelName + "' cannot be found and will be ignored for the writeback!");
                    }
                }

                measure.storageOptions.levels = levelsInformation;
            }
        }

        benchmark.endMeasurement('updateWriteBackLevelInformation');
    }
};

/**
 *
 * @return {Object[]}
 */
Tree.prototype.getTimeDetails = function () {
    return this.getDataMeta().timeDetails;
};

/**
 * Gets the number of all data columns (including the total column)
 * @return {number}
 */
Tree.prototype.getNumberOfDataColumns = function () {
    return this.getDataMeta().noOfDataColumns;
};

/**
 * Collects all writeBackData of the tree via the measureDefinition of the KPIs
 * @memberOf Tree
 * @return {Object} Collection of all writeBack-Information
 */
Tree.prototype.getWriteBackData = function () {
    benchmark.startMeasurement('getWriteBackData');
    var meta = this.getMeta();
    var dataMeta = this.getDataMeta();
    var variables = this.getVariables();

    for (var promotionId in variables.promotions) {
        break;
    }

    this.updateWriteBackLevelInformation(meta, dataMeta);

    var timeDimension = _.find(dataMeta.dimensions, {"type": "time"});
    var startRecord = timeDimension.details[0];
    var endRecord = timeDimension.details[timeDimension.details.length - 1];

    // prepare the Result
    var writeBackResult = {
        id: promotionId,
        startweek: startRecord.week,
        endweek: endRecord.week,
        startyear: startRecord.calendaryear,
        endyear: endRecord.calendaryear,
        firstdayofweek: timeDimension.firstdayofweek,
        firstweekofyear: timeDimension.firstweekofyear,
        data: []
    };

    // get all writeBack-Rows
    var writeBackRows = [];
    var currentRowIdentifiers = {};
    var startNode = this.getRootNode();

    this.getWriteBackDataRecursive(writeBackRows, currentRowIdentifiers, startNode.getChildren());
    writeBackResult.data = writeBackRows;

    benchmark.endMeasurement('getWriteBackData');
    return writeBackResult;
};

/**
 * Gets all manual changes
 * returns {Object}
 */
Tree.prototype.getManualChanges = function () {
    benchmark.startMeasurement("getManualChanges");

    var rootNode = this.getRootNode();
    var meta = this.getMeta();
    var initialIdentifiers = {};
    initialIdentifiers[meta.axis.x] = undefined;
    var internalChanges = rootNode.getManualChanges(initialIdentifiers);
    var serializer = this.getManualChangesSerializer();

    var manualChanges = serializer.serialize(internalChanges);

    benchmark.endMeasurement("getManualChanges");
    return manualChanges;
};

/**
 * Creates a new instance of the Tree
 * @param data Data of the Tree
 * @param meta MetaData of the Tree
 * @param variables Additional Variables
 * @param {Object} manualChanges
 * @returns {Tree}
 */
var instantiate = function (data, meta, variables, manualChanges) {
    var tree = new Tree();
    tree.loadData(data, meta, variables, manualChanges);

    return tree;
};

if (typeof module !== "undefined") {
    module.exports.instantiate = instantiate;
    module.exports.Tree = Tree;
}

function MyRawStream() {
}

MyRawStream.prototype.write = function (rec) {
    console.log('[%s] %s: %s',
        rec.time.toISOString(),
        bunyan.nameFromLevel[rec.level],
        rec.msg);
};
