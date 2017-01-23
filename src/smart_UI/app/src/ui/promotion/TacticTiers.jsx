"use strict";

var React = require('react');
var Input = require('react-lightning-design-system').Input;
var Icon = require('react-lightning-design-system').Icon;
var Button = require('react-lightning-design-system').Button;

var PromotionActions = require('../../actions/PromotionActions').PromotionActions;

module.exports = React.createClass({
    displayName: 'TacticTiers',

    getInitialState: function () {
        return {
            tacticTiers: this.getTacticTiers(this.props.item.TacticTiers),
            managingTiers: false,
            selectedTiers: [],
            invalidFields: [],
            focusIn: ''
        };
    },

    componentWillReceiveProps: function (nextProps) {
        if (nextProps.item.InvalidTacticTiers) this.setState({managingTiers: true});
        else this.setState({managingTiers: false, selectedTiers: [], focusIn: ''});
    },

    componentDidUpdate: function () {
        if (this.state.managingTiers && !this.state.tacticTiers.length > 0)
            this.newTier();
        else if (this.state.managingTiers && typeof(this.state.focusIn) != 'undefined' && this.state.focusIn !== '')
            document.getElementsByClassName(this.state.focusIn)[0].focus();
        else if (this.state.managingTiers && this.state.tacticTiers.length > 0 && this.state.invalidFields.length > 0)
            document.getElementsByClassName(this.state.invalidFields[0])[0].focus();
        this.state.focusIn = '';
    },

    getTacticTiers: function (tacticTiers) {
        var collection = [];
        _.forEach(tacticTiers, function (tacticTier) {
            collection.push({
                fromValue: tacticTier.fromValue,
                toValue: tacticTier.toValue,
                amount: tacticTier.amount
            });
        });
        return collection;
    },

    manageTiers: function () {
        this.setState({managingTiers: true});
    },

    fieldChange: function (tacticTier, name, value, ix) {
        tacticTier[name] = value ? ((name == "amount") ? parseFloat(value) : parseInt(value)) : null;
        this.hasInvalidFields(name + '_' + ix);
    },

    toggleSelection: function (ix) {
        let tacticTierIndex = this.state.selectedTiers.indexOf(ix);
        if (tacticTierIndex == -1)
            this.state.selectedTiers.push(ix);
        else
            this.state.selectedTiers.splice(tacticTierIndex, 1);
        this.forceUpdate();
    },

    deleteTiers: function () {
        let me = this,
            selectedTiers = _.sortBy(this.state.selectedTiers);
        for (var i = this.state.tacticTiers.length; i--;) {
            if (selectedTiers.indexOf(i) != -1) {
                me.state.tacticTiers.splice(i, 1);
            }
        }
        this.forceUpdate();
        this.setState({selectedTiers: [], focusIn: ''});
        if (this.state.tacticTiers.length == 0) {
            this.newTier();
        }
        this.hasInvalidFields(false);
    },

    cancelTiers: function () {
        this.setState({
            tacticTiers: this.getTacticTiers(this.props.item.TacticTiers),
            managingTiers: false,
            selectedTiers: [],
            invalidFields: [],
            focusIn: ''
        });
    },

    newTier: function () {
        if (!this.hasInvalidFields(false)) {
            let tacticTiers = this.state.tacticTiers,
                lastToValue = tacticTiers.length > 0 ? _.last(tacticTiers).toValue : 0;
            this.state.tacticTiers.push({
                fromValue: lastToValue + 1,
                toValue: null,
                amount: null
            });
            this.forceUpdate();
            this.setState({focusIn: 'toValue_' + (tacticTiers.length - 1)});
        }
    },

    applyTiers: function () {
        if (!this.hasInvalidFields(false)) {
            PromotionActions.validateTacticTiers(this.state.tacticTiers, this.props.item.Id);
        }
    },

    isNumber: function (n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    },

    hasInvalidFields: function (focusIn) {
        var fields = [];
        for (var i = 0; i < this.state.tacticTiers.length; i++) {
            var tacticTier = this.state.tacticTiers[i];
            if (!this.isNumber(tacticTier.fromValue))
                fields.push('fromValue_' + i);
            if (!this.isNumber(tacticTier.toValue))
                fields.push('toValue_' + i);
            if (!this.isNumber(tacticTier.amount))
                fields.push('amount_' + i);
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
    renderRow: function (tacticTier, ix) {
        return (
            <tr key={Utils.guid()} onClick={() => this.toggleSelection(ix)}
                className={this.state.selectedTiers.indexOf(ix) != -1 ? 'selectedTacticTier' : ''}>
                <td>
                    <div className="slds-form-element">
                        <Input type='number' defaultValue={tacticTier.fromValue} className={"fromValue_" + ix}
                               onChange={(e, value) => this.fieldChange(tacticTier, 'fromValue', value, ix)}
                               error={this.state.invalidFields.indexOf("fromValue_" + ix) != -1}
                               onClick={() => this.state.focusIn = "fromValue_" + ix}
                               ref={i => i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null}/>
                        <Icon icon='edit' size="x-small" className="slds-icon--left"/>
                    </div>
                </td>
                <td>
                    <div className="slds-form-element">
                        <Input type='number' defaultValue={tacticTier.toValue} className={"toValue_" + ix}
                               onChange={(e, value) => this.fieldChange(tacticTier, 'toValue', value, ix)}
                               error={this.state.invalidFields.indexOf("toValue_" + ix) != -1}
                               onClick={() => this.state.focusIn = "toValue_" + ix}
                               ref={i => i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null}/>
                        <Icon icon='edit' size="x-small" className="slds-icon--left"/>
                    </div>
                </td>
                <td>
                    <div className="slds-form-element">
                        <Input type='number' defaultValue={tacticTier.amount} className={"amount_" + ix}
                               onChange={(e, value) => this.fieldChange(tacticTier, 'amount', value, ix)}
                               error={this.state.invalidFields.indexOf("amount_" + ix) != -1}
                               onClick={() => this.state.focusIn = "amount_" + ix}
                               ref={i => i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null}/>
                        <Icon icon='edit' size="x-small" className="slds-icon--left"/>
                    </div>
                </td>
            </tr>
        );
    },

    renderEditDialog: function () {
        var titleCols = [
            AppManager.getLabel('PP_TIT_VOLUME_MIN') || 'Volume Min',
            AppManager.getLabel('PP_TIT_VOLUME_MAX') || 'Volume Max',
            AppManager.getLabel('PP_TIT_AMOUNT') || 'Amount'
        ];

        return (
            <div ref="TacticTiersEditDialog">
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
                                <div className="slds-grid slds-grid--vertical-align-center slds-grid--align-center">
                                    <div className="table--fixed-header slds-m-vertical--medium slds-m-top--medium">
                                        <section className="editMode" onScroll={(event) => this.scrollTable(event)}>
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
                                                {this.state.tacticTiers.map((tacticTier, ix) => this.renderRow(tacticTier, ix))}
                                                </tbody>
                                            </table>
                                        </section>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="slds-modal__footer">
                            <button className="slds-button slds-button--neutral"
                                    onClick={() => this.cancelTiers()}>
                                {AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'}
                            </button>
                            <button className="slds-button slds-button--neutral slds-button--brand"
                                    disabled={this.state.invalidFields.length > 0} onClick={() => this.applyTiers()}>
                                {AppManager.getLabel('PP_BTN_APPLY_TIERS') || 'Apply Tiers'}
                            </button>
                        </div>
                    </div>
                </div>
                <div className="slds-backdrop slds-backdrop--open"></div>
            </div>
        );
    },

    isVisible(attribute){
        var acl = this.props.item._acl;
        return acl.isVisible(1, attribute);
    },

    render: function () {
        var titleCols = [
            AppManager.getLabel('PP_TIT_VOLUME_MIN') || 'Volume Min',
            AppManager.getLabel('PP_TIT_VOLUME_MAX') || 'Volume Max',
            AppManager.getLabel('PP_TIT_AMOUNT') || 'Amount'
        ];

        return (
            <div className="ui-tactic-tiers">
                <div className="title slds-grid">
                    <label>{AppManager.getLabel("PP_TIT_TIERED_INFORMATION") || 'Tiered Information'}</label>
                    {(this.props.editMode && this.isVisible("TACTIC_BTN_MANAGE_TIERS")) ?
                        <div className="slds-container--right">
                            <Button type='neutral' icon='custom_apps' iconAlign='left'
                                    onClick={() => this.manageTiers()}>
                                {AppManager.getLabel('PP_BTN_MANAGE_TIERS') || 'Manage Tiers'}
                            </Button>
                        </div>
                        : null }
                </div>
                {this.props.item.TacticTiers.length > 0 ?
                    <div className="slds-grid slds-grid--vertical-align-center slds-grid--align-center">
                        <div className="table--fixed-header slds-m-vertical--medium slds-m-top--medium">
                            <section className="viewMode" onScroll={(event) => this.scrollTable(event)}>
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
                                    {this.props.item.TacticTiers.map((tacticTier, ix) => {
                                        return (
                                            <tr key={"TacticTier_" + ix}>
                                                <td>
                                                    <div className="slds-truncate">{tacticTier.fromValue}</div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">{tacticTier.toValue}</div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">{tacticTier.amount}</div>
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
                        <span>{AppManager.getLabel('PP_LBL_NO_TIERS') || 'No Tiers associated to this tactic'}</span>
                    </div>
                }
                {(this.state.managingTiers) ? this.renderEditDialog() : null}
            </div>
        )
    },
});
