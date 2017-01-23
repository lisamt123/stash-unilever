"use strict";

var React = require('react');
var Checkbox = require('react-lightning-design-system').Checkbox;
var PromotionActions = require('../../actions/PromotionActions').PromotionActions;

module.exports = React.createClass({

    displayName: 'ProductFilter',

    getInitialState: function () {
        return {
            productFilters: this.props.productFilters.filters,
        };
    },

    componentWillReceiveProps: function (props) {
        this.setState({productFilters: props.productFilters.filters})
    },

    toggleFilterValue: function (category, value) {
        //TODO SEND EVENT
        //var productFilters = this.state.productFilters;
        var categoryArray = _.groupBy(this.props.productFilters.filters, 'filterId')[category];
        var item = _.find(categoryArray, {filterValueId: value});
        item.selected = (!item.selected);
        PromotionActions.toggleTacticProductFilter(category, value, this.props.item, item.selected);
        //this.setState({productFilters: productFilters});
    },

    getFilterState: function () {
        return this.state.productFilters;
    },

    render: function () {
        var categories = _.toPairs(_.groupBy(this.props.productFilters.filters, 'filterId'));
        return (
            <div className="slds-grid slds-scrollable--x product-filter">
                {
                    categories.map((productFilterPair, ix) => {
                        //var category = productFilterPair[0];
                        var values = productFilterPair[1];
                        return (
                              <div key={'categoryFilter' + ix} className="slds-col--filter">
                                <div className="slds-text-heading--small">{values[0].filterLabel}</div>
                                <div className="slds-m-top--small"></div>
                                <div className="slds-scrollable--y filter-category">
                                  {
                                        _.sortBy(values, 'filterValueLabel').map((filterItem, ix) => {
                                          return <Checkbox key={'FilterItem' + ix} label={filterItem.filterValueLabel}
                                                           checked={(filterItem.selected)}
                                                           onChange={ () => this.toggleFilterValue(filterItem.filterId, filterItem.filterValueId) } />
                                        })
                                  }
                                </div>
                              </div>

                        );
                    })
                }
            </div>
        );
    }

});