"use strict";

var React = require('react');

module.exports = React.createClass({
    getInitialState: function () {
        return {
            messages: [],
            updateToggleFlag: false
        };
    },

    componentDidMount: function () {
        UI_EVENT_BUS.subscribe(EVENTS.UI_ERROR, this.onUIError);
    },

    onUIError: function (error) {
        this.state.messages.push(error);
        this.setState({updateToggleFlag: !this.state.updateToggleFlag});
    },

    onClick: function() {
        this.state.messages.shift();
        this.setState({updateToggleFlag: !this.state.updateToggleFlag});
    },

    render: function () {
        if (this.state.messages.length == 0) {
            return null;
        } else {
            var message = this.state.messages[0];
            var msgLines = message.message.split('\n');

            var headerCls = (message.type == 'E') ? 'error' : 'warning';

            return (
                <div >
                    <div aria-hidden="false" aria-labelledby="prompt-heading-id"
                         aria-describedby="prompt-message-wrapper"
                         role="alertdialog" className="slds-modal slds-modal--prompt slds-fade-in-open"
                         style={{zIndex: 9003}}>
                        <div className="slds-modal__container slds-modal--prompt" role="document"
                             id="prompt-message-wrapper" tabIndex="0" style={{width: '30rem', textAlign: 'center'}}>
                            <div
                                className={'slds-modal__header slds-theme--' + headerCls + ' slds-theme--alert-texture'}>
                                <h2 className="slds-text-heading--medium" id="prompt-heading-id">{message.title}</h2>
                            </div>
                            <div className="slds-modal__content slds-p-around--medium">
                                <div>
                                    {msgLines.map((msg)=>
                                        <p>{msg}</p>
                                    )}
                                </div>
                            </div>
                            <div className="slds-modal__footer slds-theme--default">
                                <button className="slds-button slds-button--neutral"
                                        onClick={this.onClick}> Ok
                                </button>
                            </div>
                        </div>
                    </div>
                    <div className="slds-backdrop slds-backdrop--open"></div>
                </div>
            )
        }
    }
});
