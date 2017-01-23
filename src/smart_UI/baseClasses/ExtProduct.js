var ExtProduct = {
    addLabels: function (gridLabels) {
        _.merge(this._hidden.idToLabelMapping, gridLabels);
    },

    getLabel: function (labelId) {
        return this._hidden.idToLabelMapping[labelId];
    },

    onLoad: function () {
        var labels = {
            /* "BaselineVolume":"Baseline",
             "PhasedBaseVolume":"Phased Base Volume",
             "incrVolume":"Incremental Volume",
             "incrVolumeOverride":"Incremental Volume  Override",
             "incrVolumeEffective":"Incremental Volume  Effective",
             "TotalVolume":"Total Plan Volume",
             "TacticBaseline":"Tactic Baseline needed for Lift Calculation",
             "TotalTacticCosts":"Total Cost",
             "GSV":"GSV",
             "Start or end week":"Start or end week",
             "Tax":"Tax",
             "Revenue":"Revenue",
             "IncRevenue":"Incremental Revenue",
             "ROI":"ROI",
             "ActualizedVSPlannedCost":"Actualized VS Planned Costs",
             "ShipmentCY":"Actual ShipmentsCurrent Year",
             "FixedActualizedCost":"Fixed Actualized Cost",
             "AcutalizedCost":"Actualized Cost"*/
        };

        _.each(this.getAllItems(), function (item) {
            if (item.Short_Description != undefined)
                labels[item.Id] = item.Short_Description;
            else
                labels[item.Id] = item.description;

            if (item.ProductGroupDescription != null && item.ProductGroupDescription.trim().length > 0)
                labels[item.ProductGroupId] = item.ProductGroupDescription;
            else
                labels[item.ProductGroupId] = "Default";
        });

        var me = this;
        _.each(this._parent.LOTactic.getAllItems(), function (item) {
            var tacticTemplate = _.find(me._parent.LOTactic_Template.getAllItems(), {Id: item.Tactic_Template__c});
            var name = (tacticTemplate != undefined) ? tacticTemplate.Name : "";
            labels[item.Id] = name;
        });

        this._hidden.idToLabelMapping = labels;
    }
};

module.exports = ExtProduct;
