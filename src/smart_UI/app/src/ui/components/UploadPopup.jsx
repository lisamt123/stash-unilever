"use strict";

var React = require('react');

var Modal = require('react-lightning-design-system').Modal;
var Icon = require('react-lightning-design-system').Icon;

var PromotionActions = require('../../actions/PromotionActions').PromotionActions;

var {Header, Content} = Modal,
    {UI_EVENT_BUS} = global;

module.exports = React.createClass({
    displayName: 'UploadPopup',

    getInitialState: function () {
        return {
            progress: 0
        }
    },

    componentDidMount: function () {
        var uploadId = Utils.guid();

        this._subscription = UI_EVENT_BUS.subscribe(uploadId, progress => {
            this.setState({
                progress: (progress * 100).toFixed(3)
            });
            if (progress == 1) {
                this.props.onClose();
                document.body.classList.remove('no-scroll');
            }
        });

        this._uploadId = uploadId;
        PromotionActions.uploadAttachment(this.props.file, uploadId);
        document.body.classList.add('no-scroll');
    },

    componentWillUnmount: function () {
        UI_EVENT_BUS.unsubscribe(this._subscription);
    },

    cancelUpload: function () {
        PromotionActions.cancelUpload(this._uploadId);
        this.props.onClose();
        document.body.classList.remove('no-scroll');
    },

    render() {
        return (
            <div>
                <Modal opened={true} onHide={() => this.cancelUpload()} className="ui-uploadPopup">
                    <Header title={this.props.title} closeButton />
                    <Content className="ui-uploadPopup__attachment slds-p-around--none">
                        <div className="ui-uploadPopup__attachmentInfo slds-grid--vertical-align-center slds-grid--vertical-align-start slds-truncate">
                            <span>
                                <span className="ui-uploadPopup__attachmentIcon">
                                    <Icon icon={this.props.fileIcon} category="doctype"/>
                                </span>
                                <span className="ui-uploadPopup__attachmentName">{this.props.file.Name}</span>
                            </span>
                        </div>
                        <div className="ui-progressBar">
                            <span className="ui-progressMeter" style={{width: this.state.progress + '%'}}>
                            </span>
                        </div>
                    </Content>
                </Modal>
            </div>
        );
    }
});