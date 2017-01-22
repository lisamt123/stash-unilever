"use strict";

var React = require('react');

var Modal = require('react-lightning-design-system').Modal;
var Icon = require('react-lightning-design-system').Icon;

const {Header, Content, Footer} = Modal;

module.exports = React.createClass({
    displayName: 'ImagePopup',

    getInitialState: function () {
        return {
            selectedImage: this.props.selectedImage,
            selectedImageIndex: this.props.selectedImageIndex,
            images: this.props.images
        }
    },

    componentDidMount: function () {
        var images = this.state.images;
        for (var i = 0, len = images.length; i < len; ++i) {
            images[i].active = false;
        }
        images[this.state.selectedImageIndex].active = true;
        this.setState({images: images});
        document.body.classList.add('no-scroll');
    },

    componentWillReceiveProps: function (props) {
        this.setState({selectedImage: props.selectedImage})
    },

    changeImage: function (image, index, event) {
        var images = this.state.images;
        event.preventDefault();
        for (var i = 0, len = images.length; i < len; ++i) {
            images[i].active = false;
        }
        images[index].active = true;
        this.setState({selectedImage: image, images: images});
    },

    getWidthCarouselList: function () {
        if (this.refs.carouselList) {
            var carouselListItem = this.refs.carouselList,
                nodes = carouselListItem.querySelectorAll('.ui-modal-carousel__listItem'),
                carouselListWidth = 0;
            for (var i = 0; nodes[i]; i++) {
                carouselListWidth += nodes[i].clientWidth + 6;
            }
        }
        return carouselListWidth;
    },

    closeModal: function () {
        this.props.onClose();
        document.body.classList.remove('no-scroll');
    },

    render() {
        return (
            <div>
                <Modal opened={true} onHide={() => this.closeModal()} className="ui-modal-carousel">
                    <Header title={this.state.selectedImage.Name} closeButton />
                    <Content className="ui-modal-carousel__container">
                        <a onClick={(event) => {
                                        event.preventDefault();
                                }}
                           href={this.state.selectedImage.attachmentUrl}
                           className="ui-modal-carousel__picture slds-grid slds-grid--vertical-align-center"
                           style={{backgroundImage: `url('${this.state.selectedImage.attachmentUrl}')`}}>
                        </a>
                        <div className="ui-modal-carousel__content slds-scrollable--x">
                            <ul className="ui-modal-carousel__list" ref="carouselList"
                                style={{'width': this.getWidthCarouselList()}}>
                                {this.props.images.map((image, i) =>
                                    <li ref={li => li && image.active && li.scrollIntoViewIfNeeded ? li.scrollIntoViewIfNeeded() : null}
                                        className="ui-modal-carousel__listItem">
                                        <a onClick={(event) => this.changeImage(image, i, event)}
                                             href={image.attachmentUrl}
                                             style={(image.previewUrl && image.previewUrl.length > 1) ?
                                                 {backgroundImage: `url('${image.previewUrl}')`} : {}
                                             }
                                             className={`ui-modal-carousel__thumbnail ${image.active ? "is-Selected" : ""}`}>
                                            {(image.previewUrl && image.previewUrl.length > 1) ? null :
                                                <Icon icon='photo' category='utility' />}
                                        </a>
                                    </li>
                                )}
                            </ul>
                        </div>
                    </Content>
                    <Footer className="slds-modal__footer--white">
                        <div className="slds-grid slds-wrap ui-modal-carousel__info">
                            <div className="slds-size--1-of-1 slds-p-bottom--x-small">
                                <p className="ui-modal-carousel__infoLabel slds-form-element__label">{AppManager.getLabel('PP_LBL_IMAGE_DESCRIPTION') || 'Description'}</p>
                                <div className="ui-modal-carousel__infoInput slds-truncate">{this.state.selectedImage.Description_Language_1__c}</div>
                            </div>
                            <div className="slds-size--1-of-2 slds-col--padded-right--small">
                                <p className="ui-modal-carousel__infoLabel slds-form-element__label">{AppManager.getLabel('PP_LBL_IMAGE_CREATION_DATE') || 'Creation Date'}</p>
                                <div className="ui-modal-carousel__infoInput">{Utils.Formatters.formatDate(this.state.selectedImage.CreatedDate)}</div>
                            </div>
                            <div className="slds-size--1-of-2 slds-col--padded-left--small">
                                <p className="ui-modal-carousel__infoLabel slds-form-element__label">{AppManager.getLabel('PP_LBL_IMAGE_LAST_UPDATE') || 'Last Update'}</p>
                                <div className="ui-modal-carousel__infoInput">{Utils.Formatters.formatDate(this.state.selectedImage.LastModifiedDate)}</div>
                            </div>
                        </div>
                    </Footer>
                </Modal>
            </div>
        );
    }
});
