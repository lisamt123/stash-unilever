"use strict";

var React = require('react');
var Input = require('react-lightning-design-system').Input;
var Icon = require('react-lightning-design-system').Icon;
var Checkbox = require('react-lightning-design-system').Checkbox;

module.exports = React.createClass({
    displayName: 'FundLookup',

    getInitialState: function () {
        return {
            funds: this.getFunds(this.props.item.availableFunds),
            invalidFields: [],
            focusIn: ''
        }
    },

    componentWillUnmount: function () {
        this.setState({invalidFields: [], focusIn: ''});
    },

    componentDidUpdate: function () {
        if (typeof(this.state.focusIn) != 'undefined' && this.state.focusIn !== '')
            document.getElementsByClassName(this.state.focusIn)[0].focus();
        else if (this.state.funds.length > 0 && this.state.invalidFields.length > 0)
            document.getElementsByClassName(this.state.invalidFields[0])[0].focus();
        this.state.focusIn = '';
    },

    getFunds: function (funds) {
        var collection = [];
        _.forEach(funds, (fund) => {
            let selected = _.filter(fund.Tactics, (item) => item.tacticId == this.props.item.Id).length > 0;
            collection.push({
                Id: fund.Id,
                Name: fund.Name,
                Description__c: fund.Description__c,
                Fund_Template_Description__c: fund.Fund_Template_Description__c,
                Amount__c: fund.Amount__c,
                Allocation__c: fund.Allocation__c,
                Amount_Allocated__c: fund.Amount_Allocated__c,
                Anchor_Customer__c: fund.Anchor_Customer__c,
                Anchor_Product__c: fund.Anchor_Product__c,
                selected: selected
            });
        });
        return collection;
    },

    applyFundsLookup: function () {
        if (!this.hasInvalidFields(false)) {
            this.props.applyHandler(_.filter(this.state.funds, 'selected'));
        }
    },

    cancelFundsLookup: function () {
        this.props.cancelHandler();
    },

    toggleSelection: function (fund) {
        fund.selected = !fund.selected;
        fund.Allocation__c = fund.Allocation__c || 0;
        fund.Amount_Allocated__c = fund.Amount_Allocated__c || 0.00;
        this.forceUpdate();
    },

    fieldChange: function (fund, val) {
        let calc = (parseInt(val) * parseFloat(fund.Amount__c)) / 100;
        fund['Allocation__c'] = parseInt(val);
        fund['Amount_Allocated__c'] = calc < 0 ? 0 : parseFloat(calc).toFixed(2);
        this.hasInvalidFields(fund.Id);
    },

    isValidPercentage: function (n) {
        return !isNaN(parseFloat(n)) && isFinite(n) && n > 0 && n <= 100;
    },

    hasInvalidFields: function (focusIn) {
        var fields = [];
        for (var i = 0; i < this.state.funds.length; i++) {
            var fund = this.state.funds[i];
            if (fund.selected && !this.isValidPercentage(fund.Allocation__c))
                fields.push(fund.Id);
        }
        this.setState({invalidFields: fields, focusIn: focusIn ? focusIn : ((fields.length > 0) ? fields[0] : '')});
        return fields.length > 0;
    },

    scrollTable: function (e) {
        var offset = -e.target.scrollLeft;
        var headers = e.target.querySelectorAll('table thead th');

        for (var i = 0; i < headers.length; i++) {
            headers[i].querySelector('div').style.left = offset + 'px';
            offset += headers[i].offsetWidth;
        }
    },

    renderFundRow: function (fund, ix) {
        return (
            <tr key={"fund_" + ix}>
                <td>
                    <Checkbox className="slds-text-align--lef" onChange={() => this.toggleSelection(fund)}
                              checked={fund.selected}/>
                </td>
                <td>
                    <div className="slds-text-align--left">{fund.Name}</div>
                </td>
                <td>
                    <div className="slds-text-align--left slds-truncate">{fund.Description__c}</div>
                </td>
                <td>
                    <div className="slds-text-align--left slds-truncate">{fund.Fund_Template_Description__c}</div>
                </td>
                <td>
                    <div className="slds-m-horizontal--small">{fund.Amount__c}</div>
                </td>
                <td>
                    {!fund.selected ?
                        <div className="slds-m-horizontal--small"></div>
                        :
                        <div className="slds-form-element">
                            <Input type='number' defaultValue={fund.Allocation__c} className={fund.Id}
                                   onChange={(e, value) => this.fieldChange(fund, value)}
                                   error={this.state.invalidFields.indexOf(fund.Id) != -1}
                                   onClick={() => this.state.focusIn = fund.Id}
                                   ref={i => i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null}/>
                            <Icon icon='edit' size="x-small" className="slds-icon--left"/>
                        </div>
                    }
                </td>
                <td>
                    <div className="slds-m-horizontal--small">{fund.selected ? fund.Amount_Allocated__c : null}</div>
                </td>
                <td>
                    <div className="slds-text-align--left">{fund.Anchor_Customer__c}</div>
                </td>
                <td>
                    <div className="slds-text-align--left">{fund.Anchor_Product__c}</div>
                </td>
            </tr>
        )
    },

    renderFundSearchGrid: function () {
        var titleCols = [
            AppManager.getLabel('PP_LBL_SELECT') || 'Select',
            'Fund Name',
            'Description',
            'Fund Type',
            'Available to Spend',
            '% Allocated',
            'Amount Allocated',
            'Anchor Customer',
            'Anchor Product'
        ];

        return (
            <div className="slds-grid slds-grid--vertical-align-center slds-grid--align-center funds-lookup">
                <div className="table--fixed-header slds-m-vertical--medium slds-m-top--medium">
                    <section onScroll={(event) => this.scrollTable(event)}>
                        <table className="slds-table--bordered slds-table--cell-buffer">
                            <thead>
                            <tr className="slds-text-heading--label">
                                {titleCols.map((title, ix) => <th key={ix} scope="col" title={title}>
                                    {title}
                                    <div className="slds-truncate">{title}</div>
                                </th>)}
                            </tr>
                            </thead>
                            <tbody >
                            { this.state.funds.map((fund, ix) => this.renderFundRow(fund, ix)) }
                            </tbody>
                        </table>
                    </section>
                </div>
            </div>
        )
    },

    render: function () {
        return (
            <div>
                <div className="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">
                    <div className="slds-modal__container" style={{minWidth: '70rem'}}>
                        <div className="slds-modal__header">
                            <h2 className="slds-text-heading--medium">{AppManager.getLabel('PP_TIT_FUND_LOOKUP') || 'Fund Lookup'}</h2>
                        </div>
                        <div className="slds-modal__content">
                            {this.renderFundSearchGrid()}
                        </div>
                        <div className="slds-modal__footer">
                            <button className="slds-button slds-button--neutral"
                                    onClick={() => this.cancelFundsLookup()}>{AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'}</button>
                            <button className="slds-button slds-button--neutral slds-button--brand"
                                    onClick={() => this.applyFundsLookup()}>{AppManager.getLabel('PP_BTN_APPLY_FUND') || 'Apply Fund'}</button>
                        </div>
                    </div>
                </div>
                <div className="slds-backdrop slds-backdrop--open"></div>
            </div>
        )
    }
});
