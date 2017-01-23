"use strict";

var _ = require('lodash');

/**
 * simple tree class to maintain filter
 * @constructor
 */
var SimpleTree = function () {
    this.value = null;
    this.children = [];
    this.level = null;
};

/**
 * simple tree as a string
 * @param tree an instance of simple tree
 * @param indent {number} number of spaces used for indention
 */
var treeToString = function (tree, indent) {
    var spaces = " ".repeat(indent);
    var result = spaces + tree.level + ": " + tree.value + "\n";
    for (var i in tree.children) {
        var child = tree.children[i];
        result += treeToString(child, indent + 1);
    }
    return result;
};

/**
 * overwriting the toString function of simple trees
 */
SimpleTree.prototype.toString = function () {
    return treeToString(this, 0);
};

/**
 * converts a simple array to a filter array
 * @param {number[]} array the array
 * @returns {number[][]} e.g. [4,3,6,2] => [[0,4],[1,3],[2,6],[3,2]]
 */
var addIndex = function (array) {
    var result = [];
    for (var idx = 0; idx < array.length; idx++) {
        result.push([idx, array[idx]]);
    }
    return result;
};

/**
 * helper to build a tree using lookups and filter
 * @param {number} levelIndex name of the root level
 * @param getNextLevelName {function} gives the next level name
 * @param levels {object[]} list of level name, items, startIndex, endIndex, dimensionIndex, hierarchyIndex
 * @param filterTrees {SimpleTree[]} list of filters
 */
var TreeBuilder = function (levelIndex, allLevels, filterTrees) {
    /**
     * get the indices of the children with a tree builder for the sub trees
     * @ returns {Array} maps a index of a node to the tree builder for the sub tree
     */
    this.getChildren = function () {
        var result = [];
        var nextLevel = allLevels[levelIndex];
        if (nextLevel === undefined) {
            return result;
        }
        var nextLevelName = nextLevel.name;
        for (var childIndex = nextLevel.startIndex; childIndex <= nextLevel.endIndex; childIndex++) {
            var add = true;
            var filterTreesRec = [];
            for (var i = 0; i < filterTrees.length; i++) {
                var filterTree = filterTrees[i];
                var filterLevelName = filterTree.level;
                if (nextLevelName == filterLevelName) {
                    if (childIndex === -1 && filterTree.value === null) {
                        // filter ignored
                    } else if (childIndex in filterTree.children) {
                        // filter applied
                        var subtree = filterTree.children[childIndex];
                        filterTreesRec.push(subtree);
                    } else {
                        // filter removed
                        add = false;
                        break;
                    }
                } else {
                    // filter forwarded
                    filterTreesRec.push(filterTrees[i]);
                }
            }
            if (add) {
                // add
                if (nextLevelName == undefined) {
                    result.value = childIndex;
                } else {
                    result[childIndex] = new TreeBuilder(levelIndex + 1, allLevels, filterTreesRec);
                }
            }
        }
        return result;
    }
};

/**
 * helper to split the filters into equivalence classes defined by the relation f1[pos] == f2[pos]
 * @param {number[][]} filters
 * @param {number} pos indicator position
 * @returns {number[][][]}
 */
var partition = function (filters, pos) {
    var subFilters = [];
    for (var i = 0; i < filters.length; i++) {
        var filter = filters[i];
        var key = filter[pos];
        if (key in subFilters) {
            subFilters[key].push(filter);
        }
        else {
            subFilters[key] = [filter];
        }
    }
    return subFilters;
};

/**
 * recursive function to build up a filter as a (sub) tree
 * @param {number[][]} filters list of all allowed combinations
 * @param {[]} map defines in which order the items in filter must be considers
 * @param {string[]} levels name of the levels
 * @param {number} step skip the first items in the map
 * @returns {SimpleTree} tree defining the filter
 */
var createFilterTreeRec = function (filters, map, levels, step) {
    var result = new SimpleTree();

    if (step < levels.length) {
        result.level = levels[step];
    }

    if (step < map.length) {
        var pos = map[step];
        var subFilters = partition(filters, pos);
        for (var i = -1; i < subFilters.length; i++) {
            var filter = subFilters[i];
            if (filter !== undefined) {
                var child = createFilterTreeRec(filter, map, levels, step + 1);
                child.value = filter[0][pos];
                result.children[i] = child;
            }
        }
    }

    return result;
};

/**
 * creates a filter tree based on the list of allowed combinations
 * @param {number[][]} filters list of all allowed combinations
 * @param {[]} map defines in which order the items in filter must be considers
 * @param {string[]} levels name of the levels
 * @return {SimpleTree}
 */
var createFilterTree = function (filters, map, levels) {
    return createFilterTreeRec(filters, map, levels, 0);
};

module.exports.addIndex = addIndex;
module.exports.createFilterTree = createFilterTree;
module.exports.TreeBuilder = TreeBuilder;
