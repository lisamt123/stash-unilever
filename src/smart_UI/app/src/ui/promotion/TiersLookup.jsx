"use strict";

var React = require('react');
var Input = require('react-lightning-design-system').Input;
var Icon = require('react-lightning-design-system').Icon;

module.exports = React.createClass({
    displayName: 'TierLookup',

    getInitialState: function () {
        return {
            tiers: this.getTiers(this.props.item.TacticTiers),
            invalidFields: [],
            selectedTiers: [],
            focusIn: ''
        }
    },

    componentWillUnmount: function () {
        this.setState({invalidFields: [], selectedTiers: [], focusIn: ''});
    },

    componentDidUpdate: function () {
        if (!this.state.tiers.length > 0)
            this.newTier();
        else if (typeof(this.state.focusIn) != 'undefined' && this.state.focusIn !== '')
            document.getElementsByClassName(this.state.focusIn)[0].focus();
        else if (this.state.tiers.length > 0 && this.state.invalidFields.length > 0)
            document.getElementsByClassName(this.state.invalidFields[0])[0].focus();
        this.state.focusIn = '';
    },

    getTiers: function (tiers) {
        var collection = [];
        _.forEach(tiers, (tier) => {
            collection.push({
                fromValue: tier.fromValue,
                toValue: tier.toValue,
                amount: tier.amount
            });
        });
        return collection;
    },

    newTier: function () {
        if (!this.hasInvalidFields(false)) {
            this.state.tiers.push({
                fromValue: this.state.tiers.length > 0 ? _.last(this.state.tiers).toValue : 0,
                toValue: null,
                amount: null
            });
            this.forceUpdate();
            this.setState({focusIn: 'toValue_' + (this.state.tiers.length - 1)});
        }
    },

    deleteTiers: function () {
        let selectedTiers = _.sortBy(this.state.selectedTiers);
        for (var i = this.state.tiers.length; i--;) {
            if (selectedTiers.indexOf(i) != -1) {
                this.state.tiers.splice(i, 1);
            }
        }
        this.forceUpdate();
        this.setState({selectedTiers: [], focusIn: ''});
        this.hasInvalidFields(false);
    },

    fieldChange: function (tier, name, value, ix) {
        if (parseFloat(tier[name]).toFixed(2) != parseFloat(value).toFixed(2)) {
            tier[name] = parseFloat(value);
            this.hasInvalidFields(name + '_' + ix);
        }
    },

    toggleSelection: function (ix) {
        let tierIndex = this.state.selectedTiers.indexOf(ix);
        if (tierIndex == -1)
            this.state.selectedTiers.push(ix);
        else
            this.state.selectedTiers.splice(tierIndex, 1);
        this.forceUpdate();
    },

    isNumber: function (n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    },

    hasInvalidFields: function (focusIn) {
        var fields = [];
        for (var i = 0; i < this.state.tiers.length; i++) {
            var tier = this.state.tiers[i];
            if (!this.isNumber(tier.fromValue))
                fields.push('fromValue_' + i);
            if (!this.isNumber(tier.toValue))
                fields.push('toValue_' + i);
            if (!this.isNumber(tier.amount))
                fields.push('amount_' + i);
        }
        this.setState({invalidFields: fields, focusIn: focusIn ? focusIn : ((fields.length > 0) ? fields[0] : '')});
        return fields.length > 0;
    },

    applyTiersLookup: function () {
        if (!this.hasInvalidFields(false)) this.props.applyHandler(this.state.tiers);
    },

    cancelTiersLookup: function () {
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

    renderTierRow: function (tier, ix) {
        return (
            <tr key={Utils.guid()} onClick={() => this.toggleSelection(ix)}
                className={this.state.selectedTiers.indexOf(ix) != -1 ? 'selected-tier' : ''}>
                <td>
                    <div className="slds-form-element">
                        <Input type="number" defaultValue={tier.fromValue} className={"fromValue_" + ix}
                               onChange={(e, value) => this.fieldChange(tier, 'fromValue', value, ix)}
                               error={this.state.invalidFields.indexOf("fromValue_" + ix) != -1}
                               onClick={() => this.state.focusIn = "fromValue_" + ix}
                               ref={i => i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null}/>
                        <Icon icon="edit" size="x-small" className="slds-icon--left"/>
                    </div>
                </td>
                <td>
                    <div className="slds-form-element">
                        <Input type="number" defaultValue={tier.toValue} className={"toValue_" + ix}
                               onChange={(e, value) => this.fieldChange(tier, 'toValue', value, ix)}
                               error={this.state.invalidFields.indexOf("toValue_" + ix) != -1}
                               onClick={() => this.state.focusIn = "toValue_" + ix}
                               ref={i => i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null}/>
                        <Icon icon="edit" size="x-small" className="slds-icon--left"/>
                    </div>
                </td>
                <td>
                    <div className="slds-form-element">
                        <Input type="number" defaultValue={tier.amount} className={"amount_" + ix}
                               onChange={(e, value) => this.fieldChange(tier, 'amount', value, ix)}
                               error={this.state.invalidFields.indexOf("amount_" + ix) != -1}
                               onClick={() => this.state.focusIn = "amount_" + ix} step="0.01"
                               ref={i => i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null}/>
                        <Icon icon="edit" size="x-small" className="slds-icon--left"/>
                    </div>
                </td>
            </tr>
        );
    },

    render: function () {
        var titleCols = [
            AppManager.getLabel('PP_TIT_VOLUME_MIN') || 'Volume Min',
            AppManager.getLabel('PP_TIT_VOLUME_MAX') || 'Volume Max',
            AppManager.getLabel('PP_TIT_AMOUNT') || 'Amount'
        ];

        return (
            <div>
                <div className="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">
                    <div className="slds-modal__container" style={{minWidth: '50rem'}}>
                        <div className="slds-modal__header">
                            <h2 className="slds-text-heading--medium">{AppManager.getLabel('PP_TIT_TIERED_INFORMATION') || 'Tiered Information'}</h2>
                        </div>
                        <div className="slds-modal__content slds-p-around--medium">
                            <div>
                                <div className="slds-grid slds-grid--vertical-align-center">
                                    <div className='slds-col--bump-right'/>
                                    <button className="slds-button slds-float--right slds-button--neutral"
                                            disabled={this.state.invalidFields.length > 0}
                                            onClick={() => this.newTier()}>
                                        {AppManager.getLabel('PP_BTN_NEW') || 'New'}
                                    </button>
                                    <button className="slds-button slds-float--right slds-button--neutral"
                                            onClick={() => this.deleteTiers()}>
                                        {AppManager.getLabel('PP_BTN_DELETE') || 'Delete'}
                                    </button>
                                </div>
                                <div className="slds-grid slds-grid--vertical-align-center slds-grid--align-center tiers-lookup">
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
                                                { this.state.tiers.map((tier, ix) => this.renderTierRow(tier, ix)) }
                                                </tbody>
                                            </table>
                                        </section>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="slds-modal__footer">
                            <button className="slds-button slds-button--neutral"
                                    onClick={() => this.cancelTiersLookup()}>
                                {AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'}
                            </button>
                            <button className="slds-button slds-button--neutral slds-button--brand"
                                    onClick={() => this.applyTiersLookup()}>
                                {AppManager.getLabel('PP_BTN_APPLY_TIERS') || 'Apply Tiers'}
                            </button>
                        </div>
                    </div>
                </div>
                <div className="slds-backdrop slds-backdrop--open"></div>
            </div>
        )
    }
});
