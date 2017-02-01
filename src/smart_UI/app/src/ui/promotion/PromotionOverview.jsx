"use strict";

var React = require('react');
var Tile = require('../components/Tile');
var ReactCSSTransitionGroup = require('react-addons-css-transition-group');
var LineChart = require('../components/LineChart');
var StackedChart = require('../components/StackedChart');
var HorizontalChart = require('../components/HorizontalChart');
var HorizontalBarChart = require('../components/HorizontalBarChart');
var ACLCheck = require('../components/ACLCheck');
var PromotionAttachments = require('./PromotionAttachments');

var PromotionPlanningPromotionEdit = require('./PromotionPlanningPromotionEdit');
var PromotionChildAccounts = require('./PromotionChildAccounts.jsx');
var PromotionHistory = require('./PromotionHistory.jsx');

module.exports = new React.createClass({
    displayName: 'PromotionOverview',

    propTypes: {
        promotion: React.PropTypes.object,      //Promotion details
        editMode: React.PropTypes.bool,         //Flag for showing Edit window
        showAttachments: React.PropTypes.bool,   //Flag for showing Attachments
    },

    render: function () {
        return (<div className="slds-grid slds-wrap tile-area">
                {/* PMA - START CODE - TPM-1498 - Audit Trail */}
                {(this.props.showPromotionHistory) ?
                    <PromotionHistory promotionHistories={this.props.promotion.PromotionHistory}
                                        closePromotionHistory={this.props.closePromotionHistory}
                    /> 
                : null}
                {/* PMA - END CODE - TPM-1498 - Audit Trail */}
                {(this.props.showAttachments) ?
                    <ReactCSSTransitionGroup component="div"
                                             className="slds-size--1-of-1"
                                             transitionName={{appear: "zoomIn"}} transitionAppear={true}
                                             transitionAppearTimeout={1500} transitionEnterTimeout={1500}
                                             transitionLeaveTimeout={1500}>
                        <PromotionAttachments promotion={this.props.promotion} editMode={this.props.editMode}
                                              editToggle={this.props.editToggle}/>
                    </ReactCSSTransitionGroup> : null}

                <ReactCSSTransitionGroup component="div"
                                         className="slds-size--1-of-1"
                                         transitionName={{
                                             enter: "animated",
                                             enterActive: "flipInX",
                                             leave: "animated",
                                             leaveActive: "flipOutX"
                                         }}
                                         transitionEnterTimeout={500} transitionLeaveTimeout={500}>
                    <PromotionPlanningPromotionEdit ref='editPanel' promotion={this.props.promotion}
                                                    update={this.props.update} editMode={this.props.editMode}/>
                </ReactCSSTransitionGroup>

                {(this.props.promotion && this.props.promotion.ChildAccounts && this.props.promotion.ChildAccounts.length > 0) ?
                    <ReactCSSTransitionGroup component="div"
                                             className="slds-size--1-of-1"
                                             transitionName={{appear: "zoomIn"}} transitionAppear={true}
                                             transitionAppearTimeout={1500} transitionEnterTimeout={1500}
                                             transitionLeaveTimeout={1500}>
                        <PromotionChildAccounts promotion={this.props.promotion} editMode={this.props.editMode}
                                                pushMode={this.props.pushMode} pushModeEnd={this.props.pushModeEnd}/>
                    </ReactCSSTransitionGroup>: null}

                <ACLCheck object={this.props.promotion} field="AggregatedKPI">
                    <div className="slds-col--padded-right slds-col--padded-top slds-size--1-of-2">
                        <ReactCSSTransitionGroup transitionName={{appear: "zoomIn"}} transitionAppear={true}
                                                 transitionAppearTimeout={1500} transitionEnterTimeout={1500}
                                                 transitionLeaveTimeout={1500}>
                            <Tile key='tile21' animated={true} invalid={this.props.promotion.isKPIInvalid}>
                                <HorizontalChart title={AppManager.getLabel('PP_TIT_CHART_ROI') || 'ROI'}
                                                 formatter={Utils.Formatters.formatPct}
                                                 positiveKPI={true}
                                                 mainvalue={this.props.promotion.AggregatedKPIs.LROI}
                                                 planned={this.props.promotion.AggregatedKPIs.PROI}/>
                            </Tile>
                        </ReactCSSTransitionGroup>
                    </div>
                </ACLCheck>

                <ACLCheck object={this.props.promotion} field="AggregatedKPI">
                    <div className="slds-col--padded-top slds-size--1-of-2">
                        <ReactCSSTransitionGroup transitionName={{appear: "zoomIn"}} transitionAppear={true}
                                                 transitionAppearTimeout={1500} transitionEnterTimeout={1500}
                                                 transitionLeaveTimeout={1500}>
                            <Tile key='tile31' animated={true} invalid={this.props.promotion.isKPIInvalid}>
                                <HorizontalChart title={AppManager.getLabel('PP_TIT_CHART_COSTS') || 'COSTS'}
                                                 formatter={Utils.Formatters.formatCurrency}
                                                 positiveKPI={false}
                                                 mainvalue={this.props.promotion.AggregatedKPIs.LETP}
                                                 planned={this.props.promotion.AggregatedKPIs.PTPC}/>
                            </Tile>
                        </ReactCSSTransitionGroup>
                    </div>
                </ACLCheck>

            </div>
        )
    }
});

