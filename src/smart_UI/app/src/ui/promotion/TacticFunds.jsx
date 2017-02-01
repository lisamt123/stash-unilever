"use strict";

var React = require('react');
var Button = require('react-lightning-design-system').Button;
var FundsLookup = require('./FundsLookup');

var PromotionActions = require('../../actions/PromotionActions').PromotionActions;

module.exports = React.createClass({
    displayName: 'TacticFunds',

    getInitialState: function () {
        return {
            managingFunds: false
        }
    },

    componentWillReceiveProps: function (nextProps) {
        if (nextProps.item.InvalidFunds) this.setState({managingFunds: true});
        else this.setState({managingFunds: false});
    },

    componentWillMount: function () {
        PromotionActions.searchForFunds();
    },

    manageFunds: function () {
        this.setState({managingFunds: true});
    },

    onCancelFundsLookup: function () {
        this.setState({managingFunds: false});
    },

    onApplyFundsLookup: function (funds) {
        PromotionActions.validateFunds(funds, this.props.item.Id);
    },

    scrollTable: function (e) {
        var offset = 8 - e.target.scrollLeft;
        var headers = e.target.querySelectorAll('table thead th');

        for (var i = 0; i < headers.length; i++) {
            headers[i].querySelector('div').style.left = offset + 'px';
            offset += headers[i].offsetWidth;
        }
    },

    isVisible(attribute){
        var acl = this.props.item._acl;
        return acl.isVisible(1, attribute);
    },

    render: function () {
        var titleCols = [
            AppManager.getLabel('PP_LBL_FUND_NAME') || 'Fund Name',
            AppManager.getLabel('PP_LBL_FUND_DESCRIPTION') || 'Description',
            AppManager.getLabel('PP_LBL_FUND_TYPE') || 'Fund Type',
            AppManager.getLabel('PP_LBL_AVAILABLE_TO_SPEND') || 'Available to Spend',
            AppManager.getLabel('PP_LBL_PERCENTAGE_ALLOCATED') || '% Allocated',
            AppManager.getLabel('PP_LBL_AMOUNT_ALLOCATED') || 'Amount Allocated',
            AppManager.getLabel('PP_LBL_FUND_ANCHOR_CUSTOMER') || 'Anchor Customer',
            AppManager.getLabel('PP_LBL_FUND_ANCHOR_PRODUCT') || 'Anchor Product'
        ];

        return (
            <div className="ui-tactic-funds">
                <div className="title slds-grid">
                    <label>{AppManager.getLabel("PP_TIT_FUNDS") || 'Tiered Funds'}</label>
                    {(this.props.editMode && this.isVisible("TACTIC_BTN_MANAGE_FUNDS")) ?
                        <div className="slds-container--right">
                            <Button type='neutral' icon='custom_apps' iconAlign='left'
                                    onClick={() => this.manageFunds()}>
                                {AppManager.getLabel('PP_BTN_MANAGE_FUND') || 'Manage Funds'}
                            </Button>
                        </div> : null}
                </div>
                {this.props.item.funds != null && this.props.item.funds.length > 0 ?
                    <div className="slds-grid slds-grid--vertical-align-center slds-grid--align-center">
                        <div className="table--fixed-header slds-m-vertical--medium slds-m-top--medium">
                            <section onScroll={(event) => this.scrollTable(event)}>
                                <table className="slds-table--bordered slds-table--cell-buffer">
                                    <thead>
                                    <tr className="slds-text-heading--label">
                                        {titleCols.map((title, ix) =>
                                            <th key={ix} scope="col" title={title}>
                                                {title}
                                                <div className="slds-truncate">{title}</div>
                                            </th>)}
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {this.props.item.funds.map((fund, ix) => {
                                        return (
                                            <tr key={'Fund_' + ix}>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {fund.Name}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {fund.Description__c}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {fund.Fund_Template_Description__c}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {Utils.Formatters.formatNumber(fund.Amount__c)}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {Utils.Formatters.formatNumber(fund.UL_Allocation__c)}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {Utils.Formatters.formatNumber(fund.UL_Amount_Allocated__c)}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {fund.Anchor_Customer__c}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {fund.Anchor_Product__c}
                                                    </div>
                                                </td>
                                            </tr>
                                        );
                                    })}
                                    </tbody>
                                </table>
                            </section>
                        </div>
                    </div>
                    :
                    <div className="slds-m-vertical--medium">
                        <span>{AppManager.getLabel('PP_LBL_NO_FUNDS') || 'No Funds associated to this tactic'}</span>
                    </div>
                }
                {this.state.managingFunds ?
                    <FundsLookup applyHandler={this.onApplyFundsLookup} cancelHandler={this.onCancelFundsLookup}
                                 item={this.props.item}/> : null}
            </div>
        )
    }
});
