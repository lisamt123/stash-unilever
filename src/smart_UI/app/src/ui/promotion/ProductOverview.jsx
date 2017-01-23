"use strict";

var React = require('react');
var Tile = require('../components/Tile');
var ReactCSSTransitionGroup = require('react-addons-css-transition-group');

var LineChart = require('../components/LineChart');
var HorizontalChart = require('../components/HorizontalChart');
var KPI = require('./KPI');

module.exports = new React.createClass({
    displayName: 'ProductOverview',

    getInitialState: function () {
        return {
            categoryVolData: {
                legends: ['Baseline', 'Planned Promoted Volume Tactic'],
                labels: ['CW 21', 'CW 22', 'CW 23', 'CW 24'],
                series: [
                    [20000, 24000, 21000, 22000],
                    [12000, 16000, 15000, 16000]
                ]
            },

            aggregatedData: {
                inc_costs_actual: 0,
                inc_costs_planned: 0,
                inc_sales_actual: 0,
                inc_sales_planned: 0
            }
        }
    },

    componentWillReceiveProps: function (nextProps) {
        var me = this;
        PromotionService.getAggregatedKPIforItem(nextProps.item.id, 'product', ['inc_costs_actual', 'inc_costs_planned', 'inc_sales_actual', 'inc_sales_planned'], function (data) {
            me.setState({aggregatedData: data})
        });
    },

    componentDidMount: function (nextProps) {
        var me = this;
        PromotionService.getAggregatedKPIforItem(this.props.item.id, 'product', ['inc_costs_actual', 'inc_costs_planned', 'inc_sales_actual', 'inc_sales_planned'], function (data) {
            me.setState({aggregatedData: data})
        });
    },

    render: function () {
        return (<div className="slds-grid slds-wrap slds-size--2-of-3 graphSection">
            <div className="slds-col--padded-left slds-size--1-of-2">
                <ReactCSSTransitionGroup transitionName={{appear: "zoomIn"}} transitionAppear={true}
                                         transitionAppearTimeout={1500} transitionEnterTimeout={1500}
                                         transitionLeaveTimeout={1500}>
                    <Tile key='tile21' animated={false}>
                        <LineChart
                            title={AppManager.getLabel('PP_TIT_CHART_VOLUME_VS_BASELINE')||'Planned Tactic Volume vs. Baseline'}
                            data={this.state.categoryVolData}/>
                    </Tile>
                    <Tile key='tile22' animated={true}>
                        <KPI/>
                    </Tile>
                </ReactCSSTransitionGroup>
            </div>
            <div className="slds-col--padded-left slds-size--1-of-2">
                <ReactCSSTransitionGroup transitionName={{appear: "zoomIn"}} transitionAppear={true}
                                         transitionAppearTimeout={1500} transitionEnterTimeout={1500}
                                         transitionLeaveTimeout={1500}>

                    <Tile key='tile31' animated={true}>
                        <HorizontalChart
                            title={AppManager.getLabel('PP_TIT_CHART_INCREMENTAL_COSTS')||'Incremental Costs (Tactic)'}
                            formatter={Utils.Formatters.formatCurrency}
                            mainvalue={this.state.aggregatedData.inc_costs_actual}
                            planned={this.state.aggregatedData.inc_costs_planned}/>
                    </Tile>
                    <Tile key='tile32' animated={true}>
                        <HorizontalChart
                            title={AppManager.getLabel('PP_TIT_CHART_INCREMENTAL_SALES')||'Incremental Sales (Tactic)'}
                            formatter={Utils.Formatters.formatCurrency}
                            mainvalue={this.state.aggregatedData.inc_sales_actual}
                            planned={this.state.aggregatedData.inc_sales_planned}/>
                    </Tile>
                </ReactCSSTransitionGroup>
            </div>
        </div>)
    }
});
