"use strict";

var React = require('react');
var Button = require('react-lightning-design-system').Button;
var TiersLookup = require('./TiersLookup');

var PromotionActions = require('../../actions/PromotionActions').PromotionActions;

module.exports = React.createClass({
    displayName: 'TacticTiers',

    getInitialState: function () {
        return {
            managingTiers: false
        }
    },

    componentWillReceiveProps: function (nextProps) {
        if (nextProps.item.InvalidTiers) this.setState({managingTiers: true});
        else this.setState({managingTiers: false});
    },

    manageTiers: function () {
        this.setState({managingTiers: true});
    },

    onCancelTiersLookup: function () {
        this.setState({managingTiers: false});
    },

    onApplyTiersLookup: function (tacticTiers) {
        PromotionActions.validateTacticTiers(tacticTiers, this.props.item.Id);
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
                        </div> : null}
                </div>
                {this.props.item.TacticTiers != null && this.props.item.TacticTiers.length > 0 ?
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
                                    {this.props.item.TacticTiers.map((tacticTier, ix) => {
                                        return (
                                            <tr key={"TacticTier_" + ix}>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {Utils.Formatters.formatNumber(tacticTier.fromValue)}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {Utils.Formatters.formatNumber(tacticTier.toValue)}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div className="slds-truncate">
                                                        {Utils.Formatters.formatNumber(tacticTier.amount)}
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
                        <span>{AppManager.getLabel('PP_LBL_NO_TIERS') || 'No Tiers associated to this tactic'}</span>
                    </div>
                }
                {this.state.managingTiers ?
                    <TiersLookup applyHandler={this.onApplyTiersLookup} cancelHandler={this.onCancelTiersLookup}
                                 item={this.props.item}/> : null}
            </div>
        )
    },
});
