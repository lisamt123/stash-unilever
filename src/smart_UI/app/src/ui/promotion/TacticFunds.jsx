"use strict";

var React = require('react');
var Button = require('react-lightning-design-system').Button;
var FundLookup = require('./FundLookup');

var PromotionActions = require('../../actions/PromotionActions').PromotionActions;

module.exports = React.createClass({
    displayName: 'TacticFunds',

    getInitialState: function () {
        return {
            editingFunds: false
        }
    },

    componentWillReceiveProps: function (nextProps) {
        if (nextProps.item.InvalidFunds) this.setState({editingFunds: true});
        else this.setState({editingFunds: false});
    },

    componentWillMount: function () {
        PromotionActions.searchForFunds();
    },

    openFundsLookup: function () {
        this.setState({editingFunds: true});
    },

    onCancelFundsLookup: function () {
        this.setState({editingFunds: false});
    },

    onApplyFundsLookup: function (funds) {
        PromotionActions.validateFunds(funds, this.props.item.Id);
    },

    isVisible(attribute){
        var acl = this.props.item._acl;
        return acl.isVisible(1, attribute);
    },

    render: function () {
        if (this.props.item == null) return null;

        return (
            <div>
                {this.state.editingFunds ?
                    <FundLookup applyHandler={this.onApplyFundsLookup} cancelHandler={this.onCancelFundsLookup}
                                item={this.props.item}/> : null}
                <div className="tactic-tile">
                    <div className="title slds-grid">
                        <label>Funds</label>
                        {(this.props.editMode && this.isVisible("TACTIC_BTN_MANAGE_TIERS")) ?
                            <Button className="slds-container--right" type='neutral' icon='custom_apps' iconAlign='left'
                                    onClick={() => this.openFundsLookup()}>
                                {AppManager.getLabel('PP_BTN_MANAGE_FUND') || 'Manage Funds'}
                            </Button> : null}

                    </div>
                    {this.props.item.funds.length > 0 ?
                        <div className="funds-grid slds-scrollable slds-m-vertical--medium">
                            {this.props.item.funds.map((fund, i) =>
                                <div className="funds-props" key={i}>
                                    <div className="tactic-item">
                                        <label>Fund Name</label>
                                        <span>{fund.Name}</span>
                                    </div>
                                    <div className="tactic-item">
                                        <label>Description</label>
                                        <span>{fund.Description__c}</span>
                                    </div>
                                    <div className="tactic-item">
                                        <label>Fund Type</label>
                                        <span>{fund.Fund_Template_Description__c}</span>
                                    </div>
                                    <div className="tactic-item">
                                        <label>Available to Spend</label>
                                        <span>{fund.Amount__c}</span>
                                    </div>
                                    <div className="tactic-item">
                                        <label>% Allocated</label>
                                        <span>{fund.Allocation__c}</span>
                                    </div>
                                    <div className="tactic-item">
                                        <label>Amount Allocated</label>
                                        <span>{fund.Amount_Allocated__c}</span>
                                    </div>
                                    <div className="tactic-item">
                                        <label>Anchor Customer</label>
                                        <span>{fund.Anchor_Customer__c}</span>
                                    </div>
                                    <div className="tactic-item">
                                        <label>Anchor Product</label>
                                        <span>{fund.Anchor_Product__c}</span>
                                    </div>
                                </div>)}
                        </div>
                        :
                        <div className="slds-m-vertical--medium">
                            <span>{AppManager.getLabel('PP_LBL_NO_FUNDS') || 'No Funds associated to this tactic'}</span>
                        </div>
                    }
                </div>
            </div>
        )
    }
});
