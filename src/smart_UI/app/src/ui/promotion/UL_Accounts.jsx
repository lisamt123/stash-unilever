"use strict";

var React = require('react');
var Checkbox = require('react-lightning-design-system').Checkbox;
var Button = require('react-lightning-design-system').Button;
var FundLookup = require('./FundLookup');
var ConfirmPopup = require('../components/ConfirmPopup');

module.exports = React.createClass({
    displayName: 'ChildAccounts',

    getInitialState: function () {
        return {
            addingFund: false,
            confirmMessage: null,
            selectedFunds: []
        }
    },

    openAddFunds: function () {
        PromotionActions.searchForFunds();
        this.setState({addingFund: true})
    },

    cancelAddFunds: function () {
        this.setState({addingFund: false})
    },

    addFunds: function (funds) {
        this.setState({addingFund: false});
        PromotionActions.addFunds(funds, this.props.item.Id);
    },

    deleteFunds: function () {
        var me = this;
        var noFundSelectedMessage = {
            title: (AppManager.getLabel('PP_TIT_INFORMATION') || 'Information'),
            message: (AppManager.getLabel('PP_LBL_INFORMATION_FUNDS') || 'There are no funds selected.'),
            cancelHandler: function () {
                me.setState({confirmMessage: null});
            },
            okHandler: function () {
                me.setState({confirmMessage: null});

            }
        };
        var confirmMessage = {
            title: (AppManager.getLabel('PP_TIT_CONFIRMATION') || 'Confirmation'),
            message: (AppManager.getLabel('PP_LBL_CONFIRMATION_DELETE_FUNDS') || 'Do you want to delete selected funds?'),
            cancelHandler: function () {
                me.setState({confirmMessage: null});
            },
            okHandler: function () {
                me.setState({confirmMessage: null});
                PromotionActions.deleteFunds(me.state.selectedFunds, me.props.item.Id);
                me.setState({selectedFunds: []});
            }
        };
        (this.state.selectedFunds.length > 0 ) ? this.setState({confirmMessage: confirmMessage}) : this.setState({confirmMessage: noFundSelectedMessage});
    },

    toggleSelection: function (fundId) {
        var fundIndex = _.indexOf(this.state.selectedFunds, fundId);
        if (fundIndex == -1) {
            this.state.selectedFunds.push(fundId);
        } else {
            this.state.selectedFunds.splice(fundIndex, 1);
        }
        this.forceUpdate();
    },

    isEditable(attribute){
        var acl = this.props.item._acl;
        return this.props.editMode && acl.isEditable(0, "Tactic__c") && acl.isEditable(1, attribute);
    },

    render: function () {
        var me = this;
        if (this.props.item == null) return null;
        return (
            <div>
                {me.state.addingFund ? <FundLookup addHandler={this.addFunds} cancelHandler={this.cancelAddFunds}
                                                   AvailableFunds={this.props.item.AvailableFunds}/> : null}
                <div className="tactic-tile">
                    {/*<div className="subtile funds">*/}
                    <div className="title slds-grid">
                        <label>Funds</label>
                        {(this.props.editMode) ? <Button className="slds-container--right" type='neutral'
                                                         disabled={!this.isEditable("ADD_FUND_BUTTON")}
                                                         onClick={() =>this.openAddFunds()}>{AppManager.getLabel('PP_BTN_ADD') || 'Add'}</Button> : null}
                        {(this.props.editMode) ? <Button className="slds-container--right" type='neutral'
                                                         disabled={!this.isEditable("DELETE_FUND_BUTTON")}
                                                         onClick={() =>this.deleteFunds()}>{AppManager.getLabel('PP_BTN_DELETE') || 'Delete'}</Button> : null}
                    </div>
                    {(this.state.confirmMessage) ?
                        <ConfirmPopup title={this.state.confirmMessage.title}
                                      message={this.state.confirmMessage.message}
                                      cancelHandler={this.state.confirmMessage.cancelHandler}
                                      okHandler={this.state.confirmMessage.okHandler}/> : null}
                    {this.props.item.funds.length === 0 ? <div className="slds-m-vertical--medium">
                        <span>{AppManager.getLabel('PP_LBL_NO_FUNDS') || 'No Funds associated to this tactic'}</span>
                    </div> : null}
                    <div className="funds-grid slds-scrollable--y">
                        {this.props.item.ChildAccounts.map((fund, i) =>
                            <div className="funds-props" key={i}>
                                {(this.props.editMode) ?
                                    <div className="tactic-checkbox">
                                        <Checkbox className="slds-text-align--center"
                                                  onChange={()=>this.toggleSelection(fund.Id)}
                                                  checked={_.indexOf(this.state.selectedFunds, fund.Id) != -1}/>
                                    </div> : null}
                                <div className="tactic-item">
                                    <label>ID</label>
                                    <span>{fund.ID}</span>
                                </div>
                            </div>)}
                    </div>
                </div>
            </div>
        )
    }
});
