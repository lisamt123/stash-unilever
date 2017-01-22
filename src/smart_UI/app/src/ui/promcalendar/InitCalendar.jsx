"use strict";

var React = require('react');

var Input = require('react-lightning-design-system').Input;
var Button = require('react-lightning-design-system').Button;
var Icon = require('react-lightning-design-system').Icon;

var Multiselection = require('../components/Multiselection');

module.exports = React.createClass({
    displayName: 'InitCalendar',

    getInitialState: function () {
        return {}
    },

    onSave: function () {
        this.props.saveHandler(this.state);
    },

    onCancel: function () {
        this.props.cancelHandler();
    },

    toggleSelection: function (arrayItems, itemId) {
        var opt = _.find(arrayItems, {Id: itemId});
        opt.Selected = !opt.Selected;
        this.forceUpdate();
    },

    toggleAccount: function (itemId) {
        //TODO: MOVE TO STATE!!!
        this.toggleSelection(this.props.calendar.FilterCriteria.accountfilter[0].values, itemId);
    },

    togglePromotionTemplate: function (itemId) {
        this.toggleSelection(this.props.calendar.FilterCriteria.promotionfilter[0].values, itemId);
    },

    toggleTacticTemplate: function (itemId) {
        this.toggleSelection(this.props.calendar.FilterCriteria.promotionfilter[1].values, itemId);
    },

    toggleProductCategory: function (itemId) {
        this.toggleSelection(this.props.calendar.FilterCriteria.productfilter[0].values, itemId);
    },

    renderContent: function () {
        var message = AppManager.getLabel('PC_LBL_INIT_CALENDAR_MSG_1') || 'Hi, your user settings haven\'t completed yet. ';
        var message2 = AppManager.getLabel('PC_LBL_INIT_CALENDAR_MSG_2') || ' To avoid longer loading times, please fill them in before you continue.';

        return (
            <div>
                <div className="slds-notify slds-p-around--x-small slds-theme--warning" role="alert">
                    <div className="slds-notify__content slds-grid">
                        <div className="slds-col--padded">
                            <Icon icon="warning"/>
                        </div>
                        <div className="slds-col slds-align-left">
                            <h2 className="slds-text-heading--small">{message}</h2>

                            <h2 className="slds-text-heading--small">{message2}</h2>
                        </div>
                    </div>
                </div>

                <div className="slds-grid">
                    <div className="slds-col slds-p-around--x-small slds-size--1-of-2">
                        <Multiselection label={AppManager.getLabel('PC_LBL_CUSTOMER') || 'Customer'} required="true"
                                        values={this.props.calendar.FilterCriteria.accountfilter[0].values}
                                        toggleHandler={this.toggleAccount}/>
                    </div>
                    <div className="slds-col slds-p-around--x-small slds-size--1-of-2">
                        <Multiselection label={AppManager.getLabel('PC_LBL_PROMOTION_TYPE') || 'Promotion Type'}
                                        required="false"
                                        values={this.props.calendar.FilterCriteria.promotionfilter[0].values}
                                        toggleHandler={this.togglePromotionTemplate}/>
                    </div>
                </div>
                <div className="slds-grid ">
                    <div className="slds-col slds-p-around--x-small slds-size--1-of-2">
                        <Multiselection label={AppManager.getLabel('PC_LBL_PRODUCT_CATEGORY') || 'Product Category'}
                                        required="true"
                                        values={this.props.calendar.FilterCriteria.productfilter[0].values}
                                        toggleHandler={this.toggleProductCategory}/>
                    </div>
                    <div className="slds-col slds-p-around--x-small slds-size--1-of-2">
                        <Multiselection label={AppManager.getLabel('PC_LBL_TACTIC_TYPE') || 'Tactic Type'}
                                        required="false"
                                        values={this.props.calendar.FilterCriteria.promotionfilter[1].values}
                                        toggleHandler={this.toggleTacticTemplate}/>
                    </div>
                </div>
            </div>
        )
    },

    render: function () {
        if (this.props.calendar == null) return null;
        return (
            <div>
                <div className="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">
                    <div className="slds-modal__container">
                        <div className="slds-modal__header">
                            <h2 className="slds-text-heading--medium">{AppManager.getLabel('PC_TIT_EDIT_SETTINGS') || 'Edit your Settings'}</h2>
                        </div>
                        <div className="slds-modal__content overflow-visible">
                            {this.renderContent()}
                        </div>
                        <div className="slds-modal__footer">
                            <button className="slds-button slds-button--neutral"
                                    onClick={() =>this.onCancel()}>{AppManager.getLabel('PC_BTN_CONTINUE') || 'Continue anyways'}</button>
                            <button className="slds-button slds-button--neutral slds-button--brand"
                                    onClick={() =>this.onSave()}>{AppManager.getLabel('PC_BTN_SAVE') || 'Save'}</button>
                        </div>
                    </div>
                </div>
                <div className="slds-backdrop slds-backdrop--open"></div>
            </div>
        )
    }
});
