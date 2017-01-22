"use strict";

var React = require('react');

module.exports = React.createClass({
    displayName: 'ConfirmPopup',

    componentDidMount: function () {
    },

    render: function () {
        return (
            <div>
                <div aria-hidden="false" aria-labelledby="prompt-heading-id" aria-describedby="prompt-message-wrapper"
                     role="alertdialog" className="slds-modal slds-modal--prompt slds-fade-in-open">
                    <div className="slds-modal__container slds-modal--prompt" role="document"
                         id="prompt-message-wrapper" tabIndex="0">
                        <div className="slds-modal__header slds-theme--warning slds-theme--alert-texture">
                            <h2 className="slds-text-heading--medium" id="prompt-heading-id">{this.props.title}</h2>
                        </div>
                        <div className="slds-modal__content slds-p-around--medium">
                            <div>
                                <p>{this.props.message}</p>
                            </div>
                        </div>
                        <div className="slds-modal__footer slds-theme--default">
                            <button className="slds-button slds-button--neutral"
                                    onClick={()=>this.props.cancelHandler()}>{AppManager.getLabel("PP_BTN_CANCEL") || 'Cancel'}</button>
                            <button className="slds-button slds-button--neutral"
                                    onClick={()=>this.props.okHandler()}>{AppManager.getLabel("PP_BTN_OK") || 'Ok'}</button>
                        </div>
                    </div>
                </div>
                <div className="slds-backdrop slds-backdrop--open"></div>
            </div>
        )
    }
});
