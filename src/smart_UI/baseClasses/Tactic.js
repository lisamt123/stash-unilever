var Tactic = {
    getProducts: function () {},

    getProductGroups: function () {},

    onLoad: function () {
        var tacticmap = {};

        _.each(this.getAllItems(), function (item) {
            tacticmap[item.Id] = item.Id;
            tacticmap[item.Id.substring(0, 15)] = item.Id;
        });

        this._hidden.idMapping = tacticmap;
    }
};

module.exports = Tactic;
