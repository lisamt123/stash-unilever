"use strict";

var React = require('react');
var Input = require('react-lightning-design-system').Input;
var Icon = require('react-lightning-design-system').Icon;
var Checkbox = require('react-lightning-design-system').Checkbox;

module.exports = React.createClass({
    displayName: 'FundsLookup',

    getInitialState: function () {
        return {
            funds: this.getFunds(this.props.item.AvailableFunds),
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
            collection.push({
                UL_Allocation__c: fund.UL_Allocation__c,
                UL_Amount_Allocated__c: fund.UL_Amount_Allocated__c,
                Amount__c: fund.Amount__c,
                Anchor_Account__c: fund.Anchor_Account__c,
                Anchor_Customer__c: fund.Anchor_Customer__c,
                Anchor_Product__c: fund.Anchor_Product__c,
                CreatedById: fund.CreatedById,
                CreatedDate: fund.CreatedDate,
                Currency__c: fund.Currency__c,
                Description_Language_1__c: fund.Description_Language_1__c,
                Description_Language_2__c: fund.Description_Language_2__c,
                Description_Language_3__c: fund.Description_Language_3__c,
                Description_Language_4__c: fund.Description_Language_4__c,
                Description__c: fund.Description__c,
                Fund_Template_Description__c: fund.Fund_Template_Description__c,
                Fund_Template__c: fund.Fund_Template__c,
                Id: fund.Id,
                IsDeleted: fund.IsDeleted,
                LastModifiedById: fund.LastModifiedById,
                LastModifiedDate: fund.LastModifiedDate,
                LastReferencedDate: fund.LastReferencedDate,
                LastViewedDate: fund.LastViewedDate,
                Name: fund.Name,
                OwnerId: fund.OwnerId,
                Sales_Org__c: fund.Sales_Org__c,
                Status__c: fund.Status__c,
                SystemModstamp: fund.SystemModstamp,
                UL_Available_to_Spend__c: fund.UL_Available_to_Spend__c,
                UL_Committed__c: fund.UL_Committed__c,
                UL_Total_Paid__c: fund.UL_Total_Paid__c,
                UL_Uncommitted__c: fund.UL_Uncommitted__c,
                Valid_From__c: fund.Valid_From__c,
                Valid_Thru__c: fund.Valid_Thru__c,
                objectStatus: fund.objectStatus,
                selected: _.filter(fund.Tactics, (item) => item.tacticId == this.props.item.Id).length > 0,
                tacticId: fund.tacticId
            });
        });
        return collection;
    },

    fieldChange: function (fund, val) {
        if (parseFloat(fund['UL_Allocation__c']).toFixed(2) != parseFloat(val).toFixed(2)) {
            let calc = (parseFloat(val) * parseFloat(fund.Amount__c)) / 100;
            fund['UL_Allocation__c'] = parseFloat(val);
            fund['UL_Amount_Allocated__c'] = calc < 0 || !this.isNumber(calc) ? 0 : calc;
            this.hasInvalidFields(fund.Id);
        }
    },

    toggleSelection: function (fund) {
        fund.UL_Allocation__c = _.filter(this.state.funds, 'selected').length > 0 ? 0 : 100;
        this.fieldChange(fund, fund.UL_Allocation__c);
        fund.selected = !fund.selected;
        this.forceUpdate();
    },

    isNumber: function (n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    },

    isValidPercentage: function (n) {
        return this.isNumber(n) && n > 0 && n <= 100;
    },

    hasInvalidFields: function (focusIn) {
        var fields = [];
        for (var i = 0; i < this.state.funds.length; i++) {
            var fund = this.state.funds[i];
            if (fund.selected && !this.isValidPercentage(fund.UL_Allocation__c))
                fields.push(fund.Id);
        }
        this.setState({invalidFields: fields, focusIn: focusIn ? focusIn : ((fields.length > 0) ? fields[0] : '')});
        return fields.length > 0;
    },

    applyFundsLookup: function () {
        if (!this.hasInvalidFields(false)) this.props.applyHandler(this.state.funds);
    },

    cancelFundsLookup: function () {
        this.props.cancelHandler();
    },

    scrollTable: function (e) {
        var offset = 8 - e.target.scrollLeft;
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
                    <div className="slds-m-horizontal--small">{Utils.Formatters.formatNumber(fund.Amount__c)}</div>
                </td>
                <td>
                    {!fund.selected ?
                        <div className="slds-m-horizontal--small"></div>
                        :
                        <div className="slds-form-element">
                            <Input type="number" defaultValue={fund.UL_Allocation__c} className={fund.Id}
                                   onChange={(e, value) => this.fieldChange(fund, value)}
                                   error={this.state.invalidFields.indexOf(fund.Id) != -1}
                                   onClick={() => this.state.focusIn = fund.Id} step="0.01"
                                   ref={i => i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null}/>
                            <Icon icon="edit" size="x-small" className="slds-icon--left"/>
                        </div>
                    }
                </td>
                <td>
                    <div className="slds-m-horizontal--small">
                        {fund.selected ? Utils.Formatters.formatNumber(fund.UL_Amount_Allocated__c) : null}
                    </div>
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

    render: function () {
        var titleCols = [
            AppManager.getLabel('PP_LBL_SELECT') || 'Select',
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
            <div>
                <div className="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">
                    <div className="slds-modal__container" style={{minWidth: '70rem'}}>
                        <div className="slds-modal__header">
                            <h2 className="slds-text-heading--medium">{AppManager.getLabel('PP_TIT_FUND_LOOKUP') || 'Fund Lookup'}</h2>
                        </div>
                        <div className="slds-modal__content">
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
