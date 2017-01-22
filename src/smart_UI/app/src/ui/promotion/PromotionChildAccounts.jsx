"use strict";

var React = require('react');
var Modal = require('react-lightning-design-system').Modal;
var Checkbox = require('react-lightning-design-system').Checkbox;
var Icon = require('react-lightning-design-system').Icon;
var Button = require('react-lightning-design-system').Button;

var ConfirmPopup = require('../components/ConfirmPopup');

var PromotionActions = require('../../actions/PromotionActions').PromotionActions;

var {Header, Content} = Modal,
    {UI_EVENT_BUS} = global;

module.exports = React.createClass({
    displayName: 'PromotionChildAccounts',

    getInitialState: function () {
        return {
            confirmMessage: null,
            pushed: 0,
            total: _.filter(this.props.promotion.ChildAccounts, function(childAccount) {
                return childAccount.Included;
            }).length
        };
    },

    componentWillReceiveProps: function (props) {
        if (props.pushMode) {

            var uploadId = Utils.guid();
            if (this._subscription) UI_EVENT_BUS.unsubscribe(this._subscription);
            this._subscription = UI_EVENT_BUS.subscribe(uploadId, ({total, done}) => {
                this.setState({
                    total: total,
                    pushed: done
                });
                if (total == done) {
                    this.cancelPush();
                }
            });
            this._uploadId = uploadId;

            PromotionActions.pushChildAccount(uploadId);
            document.body.classList.add('no-scroll');
        }
    },

    componentWillUnmount: function () {
        if (this.props.pushMode)
            UI_EVENT_BUS.unsubscribe(this._subscription);
    },

    cancelPush: function () {
        PromotionActions.cancelUpload(this._uploadId);
        document.body.classList.remove('no-scroll');
        this.props.pushModeEnd();
        var confirmMessage = {
            title: (AppManager.getLabel("PP_TIT_CONFIRMATION") || 'Confirmation'),
            message: (AppManager.getLabel("PP_LBL_PUSH_FINALIZED") || 'Push child promotion accounts finalized'),
            okHandler: () => {
                this.setState({confirmMessage: null});
                PromotionActions.finalizePushChildAccounts(this.props.promotion.Id);
                PromotionActions.save(this.props.promotion.Id);
            }
        };
        this.setState({confirmMessage: confirmMessage});
    },

    allChildAccountsIncluded: function () {
        return _.every(this.props.promotion.ChildAccounts, {'Included': true});
    },

    toggleChildAccount: function (childAccount) {
        PromotionActions.toggleChildAccount(childAccount.ChildAccountID, childAccount.Included);
    },

    toggleAllChildAccounts: function (Included) {
        PromotionActions.toggleAllChildAccounts(this.props.promotion.ChildAccounts, Included);
    },

    renderProgressModal: function () {
        var progress = (this.state.pushed * 100) / this.state.total;
        return (
            <Modal opened={true} onHide={() => this.cancelPush()} className="ui-pushModal">
                <Header title={AppManager.getLabel("PP_TIT_PUSH_PROMOTION") || 'Push Promotion'} closeButton/>
                <Content className="slds-p-around--none">
                    <div className="ui-pushModal__info slds-grid--vertical-align-center slds-grid--vertical-align-start slds-truncate">
                        {AppManager.getLabel("PP_LBL_PUSH_PROCESS_PROGRESS") || 'Push process progress.'}
                        &nbsp;{this.state.pushed} / {this.state.total}&nbsp;
                        {AppManager.getLabel("PP_LBL_PROMOTIONS_DONE") || 'Promotions done'}
                    </div>
                    <div className="ui-progressBar">
                        <span className="ui-progressMeter" style={{width: progress + '%'}}>
                        </span>
                    </div>
                </Content>
            </Modal>
        );
    },

    renderChildRow: function (childAccount, ix) {
        return (
            <tr key={"ChildAccountRow_" + ix}>
                <td>
                    <div className="slds-truncate">
                        <div className="slds-button-group" role="group">
                            {!(this.props.editMode) ? ((childAccount.Included) ?
                                    <Icon className="slds-m-right--medium" category="standard" fillColor="none"
                                          icon="task2" size="x-medium"/> : null) :
                                <Checkbox checked={(childAccount.Included)}
                                          onChange={(e) => this.toggleChildAccount(childAccount)}/>}
                        </div>
                    </div>
                </td>
                <td>
                    <div className="slds-truncate">{childAccount.ChildAccountName}</div>
                </td>
                <td>
                    <div className="slds-truncate">{childAccount.CustomerUnique}</div>
                </td>
                <td>
                    <div className="slds-truncate">
                        <span className="slds-text-link"
                              onClick={(e) => PromotionActions.openPromotion(childAccount.PushedPromoID)}>
                            {childAccount.PushedPromoID}
                        </span>
                    </div>
                </td>
                <td>
                    <div className="slds-truncate">{childAccount.PromotionSlogan}</div>
                </td>
            </tr>
        );
    },

    scrollTable: function (e) {
        var offset = - e.target.scrollLeft;
        var headers = e.target.querySelectorAll('table thead th');

        for (var i = 0; i < headers.length; i++) {
            headers[i].querySelector('div').style.left = offset + 'px';
            offset += headers[i].offsetWidth;
        }
    },

    render: function () {
        var titleCols = [
            AppManager.getLabel('PP_LBL_INCLUDED'),
            AppManager.getLabel('PP_TIT_ACCOUNT'),
            AppManager.getLabel('PP_LBL_CUSTOMER_UNIQUE'),
            AppManager.getLabel('PP_LBL_PROMOTION_ID'),
            AppManager.getLabel('PP_TIT_PROMOTION_SLOGAN')
        ];

        return (
            <div className="ui-child-accounts tile slds-m-top--medium">
                <div className="title slds-grid">
                    <label>{AppManager.getLabel("PP_TIT_CHILD_PROMOTION_ACCOUNTS") || 'Child Promotion Accounts'}</label>
                </div>
                <div className="slds-grid slds-grid--vertical-align-center slds-grid--align-center">
                    <div className="table--fixed-header slds-m-vertical--large slds-m-top--large">
                        <section className={(this.props.editMode) ? 'editMode' : 'viewMode'}
                                 onScroll={(event) => this.scrollTable(event)}>
                            <table className="slds-table--bordered slds-table--cell-buffer">
                                <thead>
                                <tr className="slds-text-heading--label">
                                    {titleCols.map((title, ix) =>
                                        <th key={ix} scope="col"
                                            title={(this.props.editMode && ix == 0) ? AppManager.getLabel("PP_TIT_INCLUDE_EXCLUDE_ALL") || 'Include/Exclude All': title}>
                                            {title}
                                            <div className="slds-truncate">
                                                {(this.props.editMode && ix == 0) ?
                                                    <Checkbox checked={this.allChildAccountsIncluded()}
                                                              onChange={(e) => this.toggleAllChildAccounts(this.allChildAccountsIncluded())}/> :
                                                    title}
                                            </div>
                                        </th>)}
                                </tr>
                                </thead>
                                <tbody>
                                {this.props.promotion.ChildAccounts.map((childAccount, ix) => this.renderChildRow(childAccount, ix))}
                                </tbody>
                            </table>
                        </section>
                    </div>
                </div>
                {(this.state.confirmMessage) ?
                    <div>
                        <div aria-hidden="false" aria-labelledby="prompt-heading-id"
                             aria-describedby="prompt-message-wrapper"
                             role="alertdialog" className="slds-modal slds-modal--prompt slds-fade-in-open">
                            <div className="slds-modal__container slds-modal--prompt" role="document"
                                 id="prompt-message-wrapper" tabIndex="0">
                                <div className="slds-modal__header slds-theme--warning slds-theme--alert-texture">
                                    <h2 className="slds-text-heading--medium"
                                        id="prompt-heading-id">{this.state.confirmMessage.title}</h2>
                                </div>
                                <div className="slds-modal__content slds-p-around--medium">
                                    <div><p>{this.state.confirmMessage.message}</p></div>
                                </div>
                                <div className="slds-modal__footer slds-theme--default">
                                    <button className="slds-button slds-button--neutral"
                                            onClick={() => this.state.confirmMessage.okHandler()}>
                                        {AppManager.getLabel("PP_BTN_OK") || 'Ok'}
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div className="slds-backdrop slds-backdrop--open"></div>
                    </div>
                    : null}
                {(this.props.pushMode) ? this.renderProgressModal() : null}
            </div>
        )
    },
});
