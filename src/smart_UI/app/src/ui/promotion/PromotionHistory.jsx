"use strict";

var React = require('react');
var Icon = require('react-lightning-design-system').Icon;

//PMA - START CODE - TPM-1498 - Audit Trail
module.exports = React.createClass({
    displayName: 'PromotionHistory',

    getInitialState: function () {
        return {
            promotionHistories: this.getPromotionHistory(this.props.promotionHistories)
        }
    },

    getPromotionHistory: function (promotionHistories) {
        var collection = [];
        _.forEach(promotionHistories, (promotionHistory) => {
            collection.push({
                Name: promotionHistory.Name,
                CreatedDate: promotionHistory.CreatedDate,
                NewValue: promotionHistory.NewValue,
                OldValue: promotionHistory.OldValue
            });
        });
        return collection;
    },

    cancelPromotionHistory: function () {
        this.props.closePromotionHistory();
    },

    scrollTable: function (e) {
        var offset = 8 - e.target.scrollLeft;
        var headers = e.target.querySelectorAll('table thead th');

        for (var i = 0; i < headers.length; i++) {
            headers[i].querySelector('div').style.left = offset + 'px';
            offset += headers[i].offsetWidth;
        }
    },

    renderPromotionHistoryRow: function (promotionHistory, ix) {
        return (
            <tr key={"promotionHistory_" + ix}>
                <td>
                    <div className="slds-text-align--left slds-truncate">{promotionHistory.Name}</div>
                </td>
                <td>
                    <div className="slds-text-align--left">{promotionHistory.CreatedDate}</div>
                </td>
                <td>
                    <div className="slds-text-align--left">{promotionHistory.NewValue}</div>
                </td>
                <td>
                    <div className="slds-text-align--left">{promotionHistory.OldValue}</div>
                </td>
            </tr>
        )
    },

    renderPromotionHistoryGrid: function () {
        var titleCols = [
            AppManager.getLabel('PP_LBL_PROMOTIONHISTORY_NAME') || 'Name',
            AppManager.getLabel('PP_LBL_PROMOTIONHISTORY_CREATEDDATE') || 'Created Date',
            AppManager.getLabel('PP_LBL_PROMOTIONHISTORY_NEWVALUE') || 'New Value',
            AppManager.getLabel('PP_LBL_PROMOTIONHISTORY_OLDVALUE') || 'Old Value'
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
                            { this.state.promotionHistories.map((promotionHistory, ix) => this.renderPromotionHistoryRow(promotionHistory, ix)) }
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
                        <div className="slds-modal__header slds-theme--warning slds-theme--alert-texture">
                            <h2 className="slds-text-heading--medium">{AppManager.getLabel('PP_LBL_PROMOTIONHISTORY_TITLE') || 'Audit Trail'}</h2>
                        </div>
                        <div className="slds-modal__content">
                            {this.renderPromotionHistoryGrid()}
                        </div>
                        <div className="slds-modal__footer">
                            <button className="slds-button slds-button--neutral"
                                    onClick={() => this.cancelPromotionHistory()}>{AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'}</button>
                        </div>
                    </div>
                </div>
                <div className="slds-backdrop slds-backdrop--open"></div>
            </div>
        )
    }
});
//PMA - END CODE - TPM-1498 - Audit Trail */