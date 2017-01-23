"use strict";
/* globals CasException */

var _ = require("lodash");
var benchmark = require('../benchmark');

/**
 *
 * @type {CalcHelper}
 */
var calculationHelper = undefined;
var meta = undefined;
var dataMeta = undefined;
var log = undefined;

/**
 *
 * @type {{UNKNOWN: number, ROOT: number, GROUPING: number, LEAF: number}}
 * @readonly
 * @enum {number}
 * @private
 */
var _NodeTypes = {
    UNKNOWN: 0,
    ROOT: 1,
    GROUPING: 2,
    LEAF: 3
};

/**
 * Gets the Data of all given leafs
 * @param {TreeNode[]} leafs Array of leafs to get
 * @returns {number[][]}
 * @Todo Check if this method could be reused (modified) for calculation + distribution
 */
function getLeafDataRows(leafs) {
    var leafData = [];

    for (var i = 0; i < leafs.length; i++) {
        var leaf = leafs[i];
        if (leaf !== undefined) {
            leafData[i] = leaf.getData();
        }
    }

    return leafData;
}

/**
 * Sums up the the data in the specified column of all given Rows
 * @param {number[][]} dataRows Rows to be summed up
 * @param {number} columnIndex Index of the column to be summed up
 * @returns {number}
 * @Todo Check if this is needed / could be reused
 */
function sumColumn(dataRows, columnIndex) {
    var sum = 0;

    for (var i = 0; i < dataRows.length; i++) {
        var dataRow = dataRows[i];
        if (dataRow !== undefined) {
            if (dataRow[columnIndex] !== undefined && dataRow[columnIndex] !== null) {
                sum += dataRow[columnIndex];
            }
        }
    }

    return sum;
}

/**
 * Calculates the TotalColumn
 * Considers if the totalColumn shall be displayed.
 */
function calculateTotal(row, measureDefinition) {
    if (measureDefinition !== null) {
        // if the total calculation uses a formula, the correct value is already calculated in executeCalculationFormula()
        if (!measureDefinition.isTotalCalculationBasedOnFormula()) {
            row[0] = row.slice(1).reduce(measureDefinition.totalCalculation);
        }
    } else {
        row[0] = null;
    }
}


/**
 * Gets a single column out of a 2D-Array a single row
 * @param {number[][]} rows
 * @param {number} columnId
 */
function getColumnInRows(rows, columnId) {
    var column = [];

    for (var rowId = 0; rowId < rows.length; rowId++) {
        if (rows[rowId] !== undefined) {
            column.push(rows[rowId][columnId]);
        }
    }

    return column;
}

/**
 * Breaks down a value over a column based on on a reference column
 * @param {TreeNode} originNode The source node where the distribution started to happen
 * @param {number} columnIndex The column within the DataRow where the value needs to be distributed across
 * @param {number|null} value The Value to be distributed
 * @param {number} measureIndex The Index of the KPI to be used as reference for the proportional distribution
 */
var breakDownProportionalTo = function (originNode, columnIndex, value, measureIndex) {
    log.trace("breakDownProportionalTo() - Start");
    // Get all leafs
    var leafs = originNode.getLeafs();
    log.debug("breakDownProportionalTo() - Found " + leafs.length + "Leafs");

    // Get the reference KPI
    var nodePosition = originNode.getPositionInTree();
    var levelOfMeasures = meta.getLevelOfMeasures();
    nodePosition[levelOfMeasures] = measureIndex;

    // Todo: Check what would happen if the requested node does not exist! E.g. Tactic-Agnostic!
    var proportionalNode = originNode.getNode(nodePosition);
    var proportionalLeafs = proportionalNode.getLeafs();

    var sumOfReferenceColumn = sumColumn(getLeafDataRows(proportionalLeafs), columnIndex);

    distributeProportional(leafs, columnIndex, measureIndex, sumOfReferenceColumn, value, originNode);

    log.trace("breakDownProportionalTo() - End");
};

/**
 * Distributes a value over a column proportional to a reference column
 * @param {TreeNode[]} leafs Nodes which will be affected by the distribution
 * @param {number} columnIndex Identifier of the column where the distribution shall occur
 * @param {number} measureIndex Reference KPI
 * @param {number} sumOfReferenceColumn Sum of the reference column
 * @param {number|null} value The value which shall be distributed over all given leafs
 * @param {TreeNode} originNode The node where the Distribution started
 */
var distributeProportional = function (leafs, columnIndex, measureIndex, sumOfReferenceColumn, value, originNode) {
    // FixMe: Will most likely need rework due to new concept
    var levelOfMeasures = meta.getLevelOfMeasures();
    for (var i = 0; i < leafs.length; i++) {
        var leaf = leafs[i];
        if (leaf !== undefined) {
            var nodePosition = leaf.getPositionInTree();

            if (value === null) {
                leaf.setData(columnIndex, null);
            }
            else if (sumOfReferenceColumn !== 0 && value !== 0) {

                nodePosition[levelOfMeasures] = measureIndex;
                // Todo: Check what would happen if the requested node does not exist!
                var referenceNode = originNode.getNode(nodePosition);

                leaf.setData(columnIndex, referenceNode.getRawData()[columnIndex] / sumOfReferenceColumn * value);
            }
            else {
                leaf.setData(columnIndex, 0);
            }
        }
    }
};

/**
 *
 * @param {TreeNode} sourceNode
 * @param {number|null} value
 */
var distributeViaCopy = function(sourceNode, value) {
    var leafNodes = sourceNode.getLeafs();
    
    for(var leafIndex = 0; leafIndex < leafNodes.length; leafIndex++) {
        var leafNode = leafNodes[leafIndex];
        
        if(leafNode !== undefined) {
            for (var columnIndex = 1; columnIndex < dataMeta.noOfDataColumns; columnIndex++) {
                leafNode.setData(columnIndex, value);
            }
        }
    }
};

/**
 * Class TreeNode
 * Used to store all information as part of a tree
 * @class
 * @param {number} globalId Unique Id of the node within the whole tree
 * @param {number} nodeId Id of the Node within the subtree
 * @param {number} dimensionId
 * @param {number} hierarchyLevel
 * @param {number} nodeLevel Level of the Node (Root is 0)
 * @param {_NodeTypes} nodeType
 * @param {TreeNode} parentNode Reference to the parent of this Node
 * @param {TreeNode} rootNode Reference to the root
 * @param {Object} measureDefinition
 * @constructor
 */
var TreeNode = function TreeNode(globalId, nodeId, dimensionId, hierarchyLevel, nodeLevel, nodeType, parentNode, rootNode, measureDefinition) {
    this.id = globalId;
    this.nodeId = nodeId;
    this._dimensionId = dimensionId;
    this._hierarchyLevel = hierarchyLevel;
    this.parentNode = parentNode;
    this.rootNode = rootNode;
    this.nodeLevel = nodeLevel;
    this.nodeType = nodeType;
    this._children = [];
    this._measureDefinition = measureDefinition;
    this._manualChanges = [];

    /**
     * Sets a value in the specified column on this node
     * Will be distributed down if this column is editable and this node a grouping-node
     * @public
     * @memberOf TreeNode
     * @param {number} columnIndex
     * @param {number|null} value
     */
    this.set = function (columnIndex, value) {
        log.trace("set() - Start");
        benchmark.startMeasurement('Set');

        if (value === undefined || value === _.trim(value)) {
            value = null;
        }

        if (this.isEditable(columnIndex)) {
    
            this.addManualChange(columnIndex, value);
    
            if(columnIndex === 0) {
                distributeViaCopy(this, value);
            } else {
                var measureDefinition = this.getMeasureDefinition();
                var measureIndex = measureDefinition.distributionInformation.measureIndex;
                // distribute the value proportional
                breakDownProportionalTo(this, columnIndex, value, measureIndex);
            }
    
            this.setDependingNodesDirty();
        }
        else {
            throw new CasException.CasException("Trying to change content of non-editable KPI ");
        }

        log.trace("set() - End");
        benchmark.endMeasurement('Set');
    };
};


/**
 * Id of the TreeNode. Must be globally unique!
 * @public
 * @memberOf TreeNode
 * @type {number}
 */
TreeNode.prototype.id = -1;

/**
 * Id of this node relative to the parentNode
 * @public
 * @memberOf TreeNode
 * @type {number}
 */
TreeNode.prototype.nodeId = -1;

/**
 * Reference to the parent of this node
 * @memberOf TreeNode
 * @public
 * @type {TreeNode}
 */
TreeNode.prototype.parentNode = null;

/**
 * Reference to the root of this tree
 * @public
 * @memberOf TreeNode
 * @type {TreeNode}
 */
TreeNode.prototype.rootNode = null;

/**
 * Level inside of the Tree
 * The RootNode has -1. The next 0 and so on
 * @public
 * @memberOf TreeNode
 * @type {number}
 */
TreeNode.prototype.nodeLevel = -1;

/**
 * NodeType of the TreeNode
 * @memberOf TreeNode
 * @type {_NodeTypes}
 */
TreeNode.prototype.nodeType = _NodeTypes.UNKNOWN;

/**
 * Indicates if the children of the TreeNode are LeafNodes
 * @memberOf TreeNode
 * @type {boolean}
 */
TreeNode.prototype.childAreLeafs = false;

/**
 * Collection of all direct children of this node
 * @private
 * @memberOf TreeNode
 * @type {TreeNode[]}
 */
TreeNode.prototype._children = undefined;

/**
 * Storage for the data in this node
 * @private
 * @memberOf TreeNode
 * @type {number[]|null}
 */
TreeNode.prototype._data = null;

/**
 * Dirty flag which indicates that the node must be recalculated
 * @private
 * @memberOf TreeNode
 * @type {boolean}
 */
TreeNode.prototype._dirty = true;

/**
 * References the definition of the Measure, if available
 * @private
 * @memberOf TreeNode
 * @type {null|Object}
 */
TreeNode.prototype._measureDefinition = null;

/**
 * Id of the Dimension this TreeNode represents
 * @memberOf TreeNode
 * @type {number}
 * @private
 */
TreeNode.prototype._dimensionId = -1;

/**
 * The level in the hierarchy
 *
 * 0 = Dimension
 * 1 = Dimension.Parent
 * 2 = Dimension.Parent.Parent ...
 * @memberOf TreeNode
 * @type {number}
 * @private
 */
TreeNode.prototype._hierarchyLevel = -1;

/**
 * Indicates if this object is the root or not
 * @public
 * @memberOf TreeNode
 * @returns {boolean}
 */
TreeNode.prototype.isRoot = function () {
    return this.nodeType === _NodeTypes.ROOT;
};

/**
 * Indicates if this object is a leaf or not
 * @public
 * @memberOf TreeNode
 * @returns {boolean}
 */
TreeNode.prototype.isLeaf = function () {
    return this.nodeType === _NodeTypes.LEAF;
};

/**
 * Indicates if this object is a grouping level or not
 * @public
 * @memberOf TreeNode
 * @returns {boolean}
 */
TreeNode.prototype.isGrouping = function () {
    return this.nodeType === _NodeTypes.GROUPING;
};

/**
 * Indicates if this node needs to be recalculated
 * @public
 * @memberOf TreeNode
 * @return {boolean}
 */
TreeNode.prototype.isDirty = function () {
    return this._dirty;
};

/**
 * Indicates if this node is a dimension
 * @public
 * @memberOf TreeNode
 * @return {boolean} TRUE this node is a dimension. FALSE this node is a HierarchyNode
 */
TreeNode.prototype.isDimensionNode = function isDimensionNode() {
    return this._hierarchyLevel === 0;
};

/**
 * Indicates if this node is a hierarchy node
 * @public
 * @memberOf TreeNode
 * @return {boolean} TRUE this node is a HierarchyNode. FALSE this node is a dimension
 */
TreeNode.prototype.isHierarchyNode = function isHierarchyNode() {
    return this._hierarchyLevel > 0;
};

/**
 * Gets the Level in the hierarchy
 * @public
 * @memberOf TreeNode
 * @return {number}
 */
TreeNode.prototype.getHierarchyLevel = function getHierarchyLevel() {
    return this._hierarchyLevel;
};

/**
 * Gets the Id of the dimension this node represents
 * @public
 * @memberOf TreeNode
 * @return {number}
 */
TreeNode.prototype.getDimensionId = function getDimensionId() {
    return this._dimensionId;
};

/**
 * Indicates if this node is an imaginary/dummy node because a level/dimension has been skipped
 * @public
 * @memberOf TreeNode
 * @return {boolean}
 */
TreeNode.prototype.isImaginary = function () {
    return this.nodeId === -1;
};

/**
 * Indicates if this node has an imaginary childNode
 * @public
 * @return {boolean}
 */
TreeNode.prototype.hasImaginaryChild = function () {
    return -1 in this._children;
};

/**
 * Gets the Label of the current node
 * @public
 * @memberOf TreeNode
 * @return {string}
 */
TreeNode.prototype.getLabel = function getLabel() {
    // FixMe: Remove this!
    if (this.isRoot()) {
        return "Root";
    }

    var dimensionName = meta.axis.y[this._dimensionId];
    var label = "missing Information";

    if (dimensionName !== "measures") {
        var dimensionInformation = dataMeta.getDimensionByName(dimensionName);

        for (var hierarchyLevelIndex = 0; hierarchyLevelIndex < this._hierarchyLevel; hierarchyLevelIndex++) {
            // go up the hierarchy if necessary
            dimensionInformation = dimensionInformation.hierarchy;
        }

        var lookUps = dimensionInformation.lookups;
        label = lookUps[this.nodeId];
    } else {
        label = meta.measures[this.nodeId].name;
    }

    return label;
};

/**
 * Gets the level of this node within the Tree
 * @public
 * @memberOf TreeNode
 * @return {number}
 */
TreeNode.prototype.getLevel = function () {
    return this.nodeLevel;
};

/**
 * Gets all labels for the current node (row in the grid)
 * @public
 * @memberOf TreeNode
 * @returns {string[]}
 */
TreeNode.prototype.getLabels = function () {
    var labels = [];

    var node = this;
    while (!node.isRoot()) {
        labels.unshift(node.getLabel());
        node = node.parentNode;
    }

    return labels;
};

/**
 * Gets all ChildRows (recursively!)
 * @private
 * @memberOf TreeNode
 * @returns {number[][]}
 */
TreeNode.prototype.getChildRows = function () {
    var childRows = [];

    if (this.childAreLeafs) {
        childRows = this._children.map(function (row) {
            return row.calculate();
        });

        if (this.hasImaginaryChild()) {
            childRows.push(this._children[-1].calculate());
        }

    } else {
        childRows = this._children.map(function (child) {
            return child.aggregate();
        });

        if (this.hasImaginaryChild()) {
            childRows.push(this._children[-1].aggregate());
        }
    }
    return childRows;
};

/**
 * Indicates if the given column is editable
 * @param {number} columnIndex id of the column
 * @public
 * @memberOf TreeNode
 * @returns {boolean}
 */
TreeNode.prototype.isEditable = function (columnIndex) {
    var isEditable = false;
    
    var measureDefinition = this.getMeasureDefinition();
    
    if (measureDefinition) {
        
        if (measureDefinition.isEditable) {
            if (columnIndex > 0) {
                if (columnIndex < dataMeta.noOfDataColumns) {
                    isEditable = true;
                } else {
                    log.warn("Out of upper bounds!");
                }
            } else if (columnIndex === 0) {
                isEditable = true;
            } else {
                log.warn("Out of lower bounds!");
            }
        }
    }
    else {
        log.warn("Cannot edit above KPI-Level!");
    }
    
    return isEditable;
};

/**
 * Indicates if the given column is editable and if it is allowed
 *
 * Additionally checks if the cell is editable in the past or not.
 * @param {number} columnIndex id of the column
 * @public
 * @memberOf TreeNode
 * @returns {boolean}
 */
TreeNode.prototype.isEditAllowed = function (columnIndex) {
    var isEditAllowed = false;
    var isEditableColumn = this.isEditable(columnIndex);
    
    if (isEditableColumn) {
        var measureDefinition = this.getMeasureDefinition();
        
        if(measureDefinition.distributionInformation.mode === "week") {
            // Edits in edit-mode week are only allowed in weekly columns, not in the total column.
            if(columnIndex > 0) {
                if (measureDefinition.distributionInformation.enablePastWeeks) {
                    isEditAllowed = true;
                } else {
                    isEditAllowed = dataMeta.currentWeekIndex <= columnIndex;
                }
            }
        } else {
            // Edits in edit-mode total are only allowed in the total column.
            isEditAllowed = columnIndex === 0;
        }
    }
    
    return isEditAllowed;
};

/**
 * Gets the current position in the tree.
 * Can be used to identify the GroupingNames
 * @example root = [], root.child[3].child[5] = [3,5]...
 * @public
 * @memberOf TreeNode
 * @returns {number[]}
 */
TreeNode.prototype.getPositionInTree = function () {
    var position = [];
    if (!this.isRoot()) {
        position = this.parentNode.getPositionInTree();
        position.push(this.nodeId);
    }

    return position;
};

/**
 * Adds a childNode to the current Node
 * Uses the nodeId (not the global unique!) as index
 * @public
 * @memberOf TreeNode
 * @param {TreeNode} child Node to be added as child to the current Node
 * @param {number} child.nodeId Id of the node (IndexReference in the dataTable
 */
TreeNode.prototype.addChild = function (child) {
    this._children[child.nodeId] = child;
};

/**
 * Gets a childNode based on its relative Id
 *
 * To use the globalId use Tree.getChild(id)
 * @public
 * @memberOf TreeNode
 * @see Tree.getChild(id) Use Tree.getChild(id)
 * @param {number} nodeId
 * @returns {TreeNode|undefined}
 */
TreeNode.prototype.getChildNode = function (nodeId) {
    return this._children[nodeId];
};

/**
 * Indicates if this object has child objects or not (includes Imaginary children)
 * @public
 * @memberOf TreeNode
 * @returns {boolean}
 */
TreeNode.prototype.hasChildren = function () {
    return this._children.length > 0 || this.hasImaginaryChild();
};

/**
 * Gets all children of this TreeNode
 * @public
 * @memberOf TreeNode
 * @return {TreeNode[]}
 */
TreeNode.prototype.getChildren = function () {
    var children;

    if (this.hasImaginaryChild() && this._children.length > 0) {
        log.error("Not Implemented: Imaginary and non-Imaginary Children found!");
        children = [];
    }
    else if (this.hasImaginaryChild()) {
        log.debug("getChildren: Skipping Imaginary Child.");
        children = this._children[-1].getChildren();
    }
    else {
        children = this._children;
    }

    return children;
};

/**
 * Indicates if the Children of this node should be shown in the UI
 * @public
 * @memberOf TreeNode
 * @return {boolean}
 */
TreeNode.prototype.showChildren = function () {
    return !this.isLeaf();
};

/**
 * Gets the number of digits for correct rounding in the UI
 * @public
 * @memberOf TreeNode
 * @returns {number} The number of digits if specified else 2 digits as fallback
 */
TreeNode.prototype.getRounding = function () {
    var roundingDigits = 2;
    var measureDefinition = this.getMeasureDefinition();

    if (measureDefinition !== null) {
        roundingDigits = measureDefinition.display.round;
    }

    return roundingDigits;
};

/**
 * Sets the data for the specified column
 * Assumes that the totalColumn is at index 0!
 *
 * @memberOf TreeNode
 * @param {number} index Position in the Data
 * @param {number|null} value Value to be set
 * @throws {Error} Throws an error if the index is out of bounds.
 * @throws {Error} Throws an error if initData(size) is not called before setting the data.
 */
TreeNode.prototype.setData = function (index, value) {
    if (index >= 0 && index <= dataMeta.noOfDataColumns) {
        this._data[index] = value;
    } else if (index < 0) {
        throw new CasException.CasException("Out of Lower-Bounds!");
    } else {
        throw new CasException.CasException("Out of Upper-Bounds!");
    }
};

/**
 * Sets the raw Data
 * @memberOf TreeNode
 * @param {(number|null)[]} rawData
 */
TreeNode.prototype.setRawData = function setRawData(rawData) {
    if (rawData === undefined) {
        log.warn("inserting undefined data");
    }

    if (this.isLeaf()) {
        rawData.unshift(null); // add total column
        this._data = rawData;
    } else {
        throw new CasException.CasException("Not implemented: Cannot set data on a none-leaf TreeNode!");
    }
};

/**
 * Gets the raw Data of a leaf
 *
 * Should only be called on Leaf-Level!
 * Should not be called on calculated nodes!
 * @memberOf TreeNode
 * @returns (number[])
 */
TreeNode.prototype.getRawData = function () {
    //benchmark.startMeasurement('getRawData');
    log.trace("getRawData() - Start");
    var computedRowData;

    if (this.isLeaf()) {
        computedRowData = this._data;
    }
    else {
        log.warn("getRawData() - Unexpected Call on level: " + this.nodeType.toString() + " in KPI: " + this.getMeasureDefinition().name);
        computedRowData = createAndFillArray(dataMeta.noOfDataColumns, null);
    }

    log.trace("getRawData() - End");
    //benchmark.endMeasurement('getRawData');
    return computedRowData;
};

/**
 * Gets the MeasureDefinition of this Node
 * Returns null if the measure is below the current level
 * @public
 * @memberOf TreeNode
 * @returns {Object|null}
 */
TreeNode.prototype.getMeasureDefinition = function () {
    return this._measureDefinition;
};

/**
 * Gets all (calculated) rows which are referenced by the current Node on the current level
 * @private
 * @memberOf TreeNode
 * @param {Object} measureDefinition
 * @return {number[][]}
 */
TreeNode.prototype.getReferencedRowsForCalculation = function (measureDefinition) {
    var posInTree = this.getPositionInTree();
    var measureLevel = meta.getLevelOfMeasures();

    // get all referenced Rows
    var argRowList = [];
    for (var i = 0; i < measureDefinition.args.length; i++) {
        var functionArgument = measureDefinition.args[i];
        // Copy the nodePosition as it could be truncated later on for KPIs on a higher level
        var nodePosition = posInTree.slice();
        nodePosition[measureLevel] = functionArgument.measureIndex;

        if (functionArgument.isComplexArgument) {
            // manipulate the nodePosition the get values on a higher level if needed
            //nodePosition = nodePosition.slice(0, functionArgument.levelIndex + 1);
            var levelIndex = dataMeta.getLevelIndex(functionArgument.levelName);
            nodePosition = nodePosition.slice(0, levelIndex + 1);
        }

        var node = this.getNode(nodePosition);

        if (node !== undefined) {
            var data = node.getData();

            if (functionArgument.isComplexArgument && functionArgument.useTotal) {
                // Use the TotalValue for all weeks
                data = createAndFillArray(dataMeta.noOfDataColumns, data[0]);
            }

            argRowList[i] = data;
        }
        else {
            // Use a fallback as no node could be found
            argRowList[i] = createAndFillArray(dataMeta.noOfDataColumns, null);
        }
    }
    return argRowList;
};

/**
 * Executes the specified calculation formula
 * @private
 * @memberOf TreeNode
 * @param {Object} measureDefinition
 * @param {number[][]} argRowList
 * @return {number[]}
 */
TreeNode.prototype.executeCalculationFormula = function (measureDefinition, argRowList) {
    var resultRow = [];
    var funcArguments = [];

    calculationHelper.setNode(this);

    var startIndex = 1;
    var weekIterator;
    if (measureDefinition.isTotalCalculationBasedOnFormula()) {
        // calculate the total the same way as the weekly values
        startIndex = 0;
    }

    var numberOfArguments = measureDefinition.args.length;
    benchmark.startMeasurement('executeCalculation.' + measureDefinition.name);

    switch(numberOfArguments) {
        case 0:
            benchmark.startMeasurement('executeCalculationWith0Arguments');
            for (weekIterator = startIndex; weekIterator < dataMeta.noOfDataColumns; weekIterator++) {
                calculationHelper.setWeekIndex(weekIterator);
                resultRow[weekIterator] = measureDefinition.func(calculationHelper);
            }
            benchmark.endMeasurement('executeCalculationWith0Arguments');
            break;

        case 1:
            benchmark.startMeasurement('executeCalculationWith1Arguments');
            for (weekIterator = startIndex; weekIterator < dataMeta.noOfDataColumns; weekIterator++) {
                calculationHelper.setWeekIndex(weekIterator);
                resultRow[weekIterator] = measureDefinition.func(calculationHelper, undefinedToNull(argRowList[0][weekIterator]));
            }
            benchmark.endMeasurement('executeCalculationWith1Arguments');
            break;

        case 2:
            benchmark.startMeasurement('executeCalculationWith2Arguments');
            for (weekIterator = startIndex; weekIterator < dataMeta.noOfDataColumns; weekIterator++) {
                calculationHelper.setWeekIndex(weekIterator);
                resultRow[weekIterator] = measureDefinition.func(calculationHelper, undefinedToNull(argRowList[0][weekIterator]), undefinedToNull(argRowList[1][weekIterator]));
            }
            benchmark.endMeasurement('executeCalculationWith2Arguments');
            break;

        case 3:
            benchmark.startMeasurement('executeCalculationWith3Arguments');
            for (weekIterator = startIndex; weekIterator < dataMeta.noOfDataColumns; weekIterator++) {
                calculationHelper.setWeekIndex(weekIterator);
                resultRow[weekIterator] = measureDefinition.func(calculationHelper, undefinedToNull(argRowList[0][weekIterator]), undefinedToNull(argRowList[1][weekIterator]), undefinedToNull(argRowList[2][weekIterator]));
            }
            benchmark.endMeasurement('executeCalculationWith3Arguments');
            break;

        default:
            funcArguments.push(calculationHelper);
            for (weekIterator = startIndex; weekIterator < dataMeta.noOfDataColumns; weekIterator++) {
                calculationHelper.setWeekIndex(weekIterator);
                for (var j = 0; j < numberOfArguments; j++) {
                    funcArguments[j + 1] = undefinedToNull(argRowList[j][weekIterator]);
                }
                benchmark.startMeasurement('applyFunction.' + measureDefinition.name);
                resultRow[weekIterator] = measureDefinition.func.apply(this, funcArguments);

                benchmark.endMeasurement('applyFunction.' + measureDefinition.name);
            }
    }

    benchmark.endMeasurement('executeCalculation.' + measureDefinition.name);

    return resultRow;
};

/**
 * Converts a value to null if it is undefined
 * @param value
 * @returns {*}
 */
function undefinedToNull(value) {
    if(value === undefined) {
        return null;
    } else {
        return value;
    }
}

/**
 * Create an array and fills it with the specified value
 * @param {number} size
 * @param {number|null} value
 * @returns {Array}
 */
function createAndFillArray(size, value) {
    var result = new Array(size);
    _.fill(result, value);
    return result;
}

/**
 * Gets the values of the row and calculates computed fields if necessary
 * If this method is called on a non-leaf node, the result will be undefined
 * @private
 * @memberOf TreeNode
 */
TreeNode.prototype.calculate = function () {
    log.debug("calculate() - Start");
    var row;

    var measureDefinition = this.getMeasureDefinition();

    if (!this.isDirty()) {
        benchmark.startMeasurement('calculate.' + measureDefinition.name + '.Cached');
        row = this._data;
        benchmark.endMeasurement('calculate.' + measureDefinition.name + '.Cached');
    } else {
        benchmark.startMeasurement('calculate.' + measureDefinition.name + '.NotCached');

        if (measureDefinition && measureDefinition.computed) {
            // Calculates the current row if it depends on other measures.
            var argRowList = this.getReferencedRowsForCalculation(measureDefinition);
            row = this.executeCalculationFormula(measureDefinition, argRowList);
        }
        else {
            // Gets the basic data in the row without any calculation
            row = this.getRawData();
        }

        calculateTotal(row, measureDefinition);

        this._data = row;
        this.setDirty(false);
        benchmark.endMeasurement('calculate.' + measureDefinition.name + '.NotCached');
    }

    log.debug("calculate() - End");
    return row;
};

/**
 * Sets the node to dirty dependent on the flag
 * @private
 * @memberOf TreeNode
 * @param {Boolean} flag
 */
TreeNode.prototype.setDirty = function (flag) {
    this._dirty = flag;
};

/**
 * Aggregates all rows below to a single row based on the measureDefinition
 * @private
 * @memberOf TreeNode
 * @returns {number[]}
 */
TreeNode.prototype.aggregate = function () {
    var measureDefinition = this.getMeasureDefinition();

    var noColumns = dataMeta.noOfDataColumns;
    var aggregationResult;

    if (!this._dirty) {
        aggregationResult = this._data;
    }
    else {
        if (measureDefinition === null) {
            // if measures is not on top level it could be below
            // Example: Tactic,measures,PrdGroup,Prd => Aggregating the measures up to TacticLevel does not make any sense!
            aggregationResult = createAndFillArray(noColumns, null);
        }
        else {
            if (measureDefinition.isAggregationBasedOnFormula()) {
                benchmark.startMeasurement("aggregate.BasedOnFormula");
                aggregationResult = this.calculate();
                benchmark.endMeasurement("aggregate.BasedOnFormula");
            }
            else {
                benchmark.startMeasurement("aggregate.GetChildRows");
                var childRows = this.getChildRows();
                benchmark.endMeasurement("aggregate.GetChildRows");

                benchmark.startMeasurement("aggregate.Standard");
                aggregationResult = [];
                // Aggregate up to the current level
                // Iterate of each column of the 2-dim-Array
                for (var columnIndex = 0; columnIndex < noColumns; columnIndex++) {
                    var calcRow = getColumnInRows(childRows, columnIndex);

                    // Aggregate the column
                    if (calcRow.length > 0) {
                        aggregationResult[columnIndex] = calcRow.reduce(measureDefinition.aggregation);
                    }
                    else {
                        aggregationResult[columnIndex] = null;
                    }
                }
                calculateTotal(aggregationResult, measureDefinition);
                benchmark.endMeasurement("aggregate.Standard");
            }
        }

        this._data = aggregationResult;
        this.setDirty(false);
    }

    return aggregationResult;
};

/**
 * Gets the data of a row
 * @public
 * @memberOf TreeNode
 * @throws CasException If the function is called on another level than Leaf or GroupingLevel
 * @return {number[]}
 */
TreeNode.prototype.getData = function () {
    var result;

    if (this.isRoot()) {
        throw new CasException("Invalid Operations. Use Tree.getHeader() to get the header");
    }
    else if (this.isLeaf()) {
        result = this.calculate();
    }
    else if (this.isGrouping()) {
        result = this.aggregate();
    }
    else {
        throw new CasException("Invalid NodeType: '" + this.nodeType + "'");
    }

    return result;
};

/**
 * Sets this node and all of its children to dirty to trigger a recalculation
 * @private
 * @memberOf TreeNode
 */
TreeNode.prototype.setChildrenDirty = function () {
    this.setDirty(true);
    for (var i = -1; i < this._children.length; i++) {
        var child = this._children[i];

        if (child !== undefined) {
            child.setChildrenDirty();
        }
    }
};

/**
 * Sets all parents (ancestors) dirty to trigger a recalculation
 */
TreeNode.prototype.setParentsDirty = function () {
    var parent = this.parentNode;

    if (!parent.isRoot()) {
        parent.setDirty(true);
        parent.setParentsDirty();
    }
};

/**
 * Gets a Node in the Tree via its relative Ids
 * @public
 * @memberOf TreeNode
 * @param {number[]} positionInTree
 * @returns {TreeNode|undefined}
 */
TreeNode.prototype.getNode = function (positionInTree) {
    var currentNode = this.isRoot() ? this : this.rootNode;

    for (var i = 0; i < positionInTree.length; i++) {
        if (currentNode !== null && currentNode !== undefined) {
            if (currentNode.hasImaginaryChild()) {
                currentNode = currentNode.getChildNode(-1);
            }
            else {
                currentNode = currentNode.getChildNode(positionInTree[i]);
            }
        }
    }

    return currentNode;
};

/**
 * Gets all leaf nodes below this node
 * @memberOf TreeNode
 * @returns {TreeNode[]}
 */
TreeNode.prototype.getLeafs = function () {
    log.debug("getLeafs() - Start");
    var leafs = [];

    if (this.isLeaf()) {
        leafs.push(this);
    }
    else if (this.childAreLeafs) {
        leafs = leafs.concat(this._children);
    }
    else {
        for (var i = -1; i < this._children.length; i++) {
            var leaf = this._children[i];

            if (leaf !== undefined) {
                leafs = leafs.concat(leaf.getLeafs());
            }
        }
    }

    log.debug("getLeafs() - End");
    return leafs;
};

/**
 * Indicates if this node should be displayed.
 * Mainly this depends on the measure.
 * @public
 * @memberOf TreeNode
 * @returns {boolean}
 */
TreeNode.prototype.showInUI = function () {
    var showInUI = true;
    var measureDefinition = this.getMeasureDefinition();

    if (measureDefinition !== null) {
        showInUI = measureDefinition.display.enabled;
    }

    return showInUI;
};

/**
 * Sets all dependent Nodes to dirty to trigger a recalculation
 * @private
 * @memberOf TreeNode
 */
TreeNode.prototype.setDependingNodesDirty = function () {

    // set this node and all siblings and children to dirty
    if (!this.isDirty()) {
        this.setChildrenDirty();
        this.setParentsDirty();

        var positionInTree = this.getPositionInTree();
        var levelOfMeasures = meta.getLevelOfMeasures();

        var measurePositionInTree = positionInTree.slice(0, levelOfMeasures + 1);
        var measureDefinition = this.getMeasureDefinition();

        for (var i = 0; i < measureDefinition.dependingMeasures.length; i++) {
            if (measureDefinition.dependingMeasures[i] !== undefined) {
                var dependentMeasure = measureDefinition.dependingMeasures[i];

                measurePositionInTree[levelOfMeasures] = dependentMeasure.id;

                var dependentNode = this.getNode(measurePositionInTree);
                dependentNode.setDependingNodesDirty();
            }
        }
    }
};

/**
 * Adds a manual change to the history
 *
 * Clears all changes below the current level
 * @private
 * @memberOf TreeNode
 * @param {number} index
 * @param {number|null} value
 */
TreeNode.prototype.addManualChange = function (index, value) {
    this._manualChanges[index] = value;
    
    if(index === 0) {
        for(var columnIndex = 0; columnIndex < dataMeta.noOfDataColumns; columnIndex++) {
            this.clearDescendantChanges(columnIndex);
        }
    } else {
        this.clearDescendantChanges(index);
    }
};

/**
 * Gets all manual changes (recursively).
 * @public
 * @memberOf TreeNode
 * @param {Object} parentIdentifiers
 * @return {Array}
 */
TreeNode.prototype.getManualChanges = function (parentIdentifiers) {
    var manualChanges = [];
    var measureDefinition = this.getMeasureDefinition();
    var identifiers = _.clone(parentIdentifiers, false);

    if (measureDefinition === null || measureDefinition.isEditable) {
        if (!this.isRoot()) {
            var dimensionName = meta.axis.y[this._dimensionId];
            var currentLabel = this.getLabel();

            identifiers[dimensionName] = currentLabel;

            for (var dataIndex = 0; dataIndex < this._manualChanges.length; dataIndex++) {
                var value = this._manualChanges[dataIndex];

                if (value !== undefined) {

                    var manualChange = {dimensions: _.clone(identifiers, false), value: value};
                    manualChange.dimensions[meta.axis.x] = dataIndex; // FixMe

                    manualChanges.push(manualChange);
                }
            }
        }

        for (var childIndex = -1; childIndex < this._children.length; childIndex++) {
            var childNode = this._children[childIndex];

            if (childNode !== undefined) {
                manualChanges = manualChanges.concat(childNode.getManualChanges(identifiers));
            }
        }
    }

    return manualChanges;
};

/**
 * Clears the manual changes of all descendants (recursively).
 * @private
 * @memberOf TreeNode
 * @param {number} index Index where the clearing of the change shall happen.
 */
TreeNode.prototype.clearDescendantChanges = function (index) {
    if (this.hasChildren()) {
        for (var childIndex = -1; childIndex < this._children.length; childIndex++) {
            var childNode = this._children[childIndex];

            if (childNode !== undefined) {
                childNode.clearManualChange(index);
                childNode.clearDescendantChanges(index);
            }
        }
    }
};

/**
 * Clears a single manual change
 * @private
 * @memberOf TreeNode
 * @param {number} index Index where the clearing of the change shall happen.
 */
TreeNode.prototype.clearManualChange = function (index) {
    delete this._manualChanges[index];
};

/**
 * Indicates if this node has any manual changes
 * @memberOf TreeNode
 * @return {boolean}
 */
TreeNode.prototype.hasManualChanges = function () {
    return this._manualChanges.length > 0;
};

/**
 * Sets the Logging-Object
 * @param logger
 */
function setLogger(logger) {
    log = logger.child({widget_type: "TreeNode"});
}

/**
 * Sets the CalculationHelper Object
 * @param {CalcHelper} calcHelper
 */
function setCalcHelper(calcHelper) {
    calculationHelper = calcHelper;
}

/**
 * Sets the Meta-Information
 * @param {Object} metaObject
 */
function setMeta(metaObject) {
    meta = metaObject;
}

/**
 * Sets the DataMeta-Information
 * @param {Object} dataMetaObject
 */
function setDataMeta(dataMetaObject) {
    dataMeta = dataMetaObject;
}

module.exports.TreeNode = TreeNode;
module.exports._NodeTypes = _NodeTypes;
module.exports.setLogger = setLogger;
module.exports.setCalcHelper = setCalcHelper;
module.exports.setMeta = setMeta;
module.exports.setDataMeta = setDataMeta;
