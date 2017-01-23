"use strict";

var React = require('react');
var Tile = require('../components/Tile');
var ReactCSSTransitionGroup = require('react-addons-css-transition-group');

var HorizontalChart = require('../components/HorizontalChart');
var TacticFunds = require('./TacticFunds');
var TacticTiers = require('./TacticTiers');
var PromotionPlanningTacticEdit = require('./PromotionPlanningTacticEdit');

module.exports = new React.createClass({
    displayName: 'TacticOverview',

    propTypes: {
        item: React.PropTypes.object, //Promotion details
        editMode: React.PropTypes.bool //Flag for showing Edit window
    },

    render: function () {
        return (<div className="slds-grid slds-wrap tile-area">
            <ReactCSSTransitionGroup component="div"
                                     className="slds-size--1-of-1"
                                     transitionName={{enter: "animated", enterActive: "flipInX", leave: "animated",leaveActive: "flipOutX"}}
                                     transitionEnterTimeout={500} transitionLeaveTimeout={500}>

                <PromotionPlanningTacticEdit ref='editPanel' tactic={this.props.item}
                                             update={this.props.update} {...this.props}/>
            </ReactCSSTransitionGroup>

            <div className="slds-size--1-of-1 slds-col--padded-top">
                <ReactCSSTransitionGroup transitionName={{appear: "zoomIn"}} transitionAppear={true}
                                         transitionAppearTimeout={1500} transitionEnterTimeout={1500}
                                         transitionLeaveTimeout={1500}>

                    <Tile key='tile21' animated={true}>
                        <TacticTiers item={this.props.item} editMode={this.props.editMode}/>
                    </Tile>
                </ReactCSSTransitionGroup>
            </div>

            <div className="slds-size--1-of-1 slds-col--padded-top">
                <ReactCSSTransitionGroup transitionName={{appear: "zoomIn"}} transitionAppear={true}
                                         transitionAppearTimeout={1500} transitionEnterTimeout={1500}
                                         transitionLeaveTimeout={1500}>

                    <Tile key='tile21' animated={true}>
                        <TacticFunds {...this.props}/>
                    </Tile>
                </ReactCSSTransitionGroup>
            </div>

            <div className="slds-size--1-of-2 slds-col--padded-top">
                <ReactCSSTransitionGroup transitionName={{appear: "zoomIn"}} transitionAppear={true}
                                         transitionAppearTimeout={1500} transitionEnterTimeout={1500}
                                         transitionLeaveTimeout={1500}>
                    <Tile key='tile21' animated={true}>
                        <HorizontalChart title={AppManager.getLabel('PP_TIT_CHART_ROI')||'ROI'}
                                         formatter={Utils.Formatters.formatPct}
                                         positiveKPI={true}
                                         mainvalue={this.props.item.AggregatedKPIs.LROI}
                                         planned={this.props.item.AggregatedKPIs.PROI}/>
                    </Tile>
                </ReactCSSTransitionGroup>
            </div>

            <div className="slds-size--1-of-2 slds-col--padded-left slds-col--padded-top">
                <ReactCSSTransitionGroup transitionName={{appear: "zoomIn"}} transitionAppear={true}
                                         transitionAppearTimeout={1500} transitionEnterTimeout={1500}
                                         transitionLeaveTimeout={1500}>
                    <Tile key='tile31' animated={true}>
                        <HorizontalChart title={AppManager.getLabel('PP_TIT_CHART_COSTS')||'COSTS'}
                                         formatter={Utils.Formatters.formatCurrency}
                                         positiveKPI={false}
                                         mainvalue={this.props.item.AggregatedKPIs.LETP}
                                         planned={this.props.item.AggregatedKPIs.PTPC}/>
                    </Tile>
                </ReactCSSTransitionGroup>
            </div>
        </div>)
    }
});
