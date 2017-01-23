"use strict";

var React = require('react');
var Input = require('react-lightning-design-system').Input;
var Icon = require('react-lightning-design-system').Icon;

var PromotionActions = require('../../actions/PromotionActions').PromotionActions;

var ImagePopup = require('../components/ImagePopup.jsx');
var UploadPopup = require('../components/UploadPopup.jsx');
var ConfirmPopup = require('../components/ConfirmPopup');

module.exports = React.createClass({
    displayName: 'PromotionAttachments',

    getInitialState: function () {
        return {
            selectedAttachment: null,
            selectedAttachmentIndex: null,
            onFileHoverClass: false,
            newAttachment: this.getEmptyAttachment(),
            modalOpen: false,
            uploading: false,
            confirmMessage: false,
            attachments: this.getAttachments(this.props.promotion.attachments)
        };
    },

    componentDidMount: function () {
        this.deactivateAttachments();
    },

    componentWillMount: function () {
        this.selectAttachment(this.state.attachments[0]);
    },

    componentWillReceiveProps: function (props) {
        var state = {
            attachments: this.getAttachments(props.promotion.attachments)
        };
        this.setState(state);
        if (this.state.newAttachment.file) {
            let i = _.findIndex(state.attachments, att =>
                att.Name == this.state.newAttachment.file.name /* && ... */
            );
            if (i != -1) {
                this.selectAttachment(state.attachments[i]);
                this.setState({
                    newAttachment: this.getEmptyAttachment()
                });
            } else this.selectAttachment(state.attachments[0]);
        } else this.selectAttachment(state.attachments[0]);
    },

    getEmptyAttachment: function () {
        return {
            previewUrl: null,
            attachmentUrl: null,
            Description_Language_1__c: '',
            Type__c: '',
            Size__c: 0,
            Name: null,
            CreatedDate: new Date(),
            LastModifiedDate: new Date()
        };
    },

    getAttachments: function (attachments) {
        return attachments.map(att => {
            att = Object.create(att, {_model: {value: att}});
            if (typeof localVF !== 'undefined') {
                if (att.attachmentUrl) att.attachmentUrl = `https://${VF_REMOTING_HOST}${att.attachmentUrl}`;
                if (att.previewUrl) att.previewUrl = `https://${VF_REMOTING_HOST}${att.previewUrl}`;
            }
            return att;
        });
    },

    isReadable: function (attachment) {
        var isReadable = true;
        try {
            new FileReader().readAsBinaryString(attachment.slice(0, 5));
        } catch (e) {
            isReadable = false;
        }
        return isReadable;
    },

    onFileSelection: function (event) {
        event.stopPropagation();
        event.preventDefault();
        var files = event.target.files || event.dataTransfer.files;

        if (files.length < 2 && this.isReadable(files[0])) {
            if (files[0].name.length <= 80) {
                if (files[0].size > 0 && files[0].size < 26214400) {

                    this.setState({
                        newAttachment: _.assign(this.state.newAttachment, {
                            file: files[0],
                            Type__c: files[0].type,
                            Name: files[0].name,
                            Size__c: files[0].size,
                            Description_Language_1__c: files[0].name,
                            Description_Language_2__c: files[0].name,
                            Description_Language_3__c: files[0].name,
                            Description_Language_4__c: files[0].name
                        }),
                        onFileHoverClass: false
                    });

                    this.openUploadModal();

                } else {
                    UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
                        title: (AppManager.getLabel("PP_TIT_UPLOAD_ATTACHMENT_ERROR") || 'Upload Error'),
                        message: (AppManager.getLabel("PP_LBL_UPLOAD_ATTACHMENT_SIZE_ERROR") || 'File incorrect size. The attachment has to be less than 25MB.'),
                        type: 'E'
                    });
                }
            } else {
                UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
                    title: (AppManager.getLabel("PP_TIT_UPLOAD_ATTACHMENT_ERROR") || 'Upload Error'),
                    message: (AppManager.getLabel("PP_LBL_UPLOAD_ATTACHMENT_FILENAME_SIZE_ERROR") || 'The filename is too long (max. 80 chars)'),
                    type: 'E'
                });
            }
        } else {
            UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
                title: (AppManager.getLabel("PP_TIT_UPLOAD_ATTACHMENT_ERROR") || 'Upload Error'),
                message: (AppManager.getLabel("PP_LBL_UPLOAD_ATTACHMENT_NUMBER_OF_FILES_ERROR") || 'Only one file allowed per upload'),
                type: 'E'
            });
        }

        if (event.target.files) event.target.value = '';

    },

    onFileLeave: function () {
        this.setState({onFileHoverClass: false});
    },

    onFileHover: function (event) {
        event.stopPropagation();
        event.preventDefault();
        var itemKind = event.dataTransfer.items[0].kind;
        if (itemKind == 'file') {
            this.setState({onFileHoverClass: true});
        }
    },

    deactivateAttachments: function () {
        for (var i = 0; i < this.state.attachments.length; ++i) {
            this.state.attachments[i].active = false;
        }
    },

    selectAttachment: function (attachment) {
        this.deactivateAttachments();
        if (attachment) attachment.active = true;
        this.setState({selectedAttachment: attachment});
    },

    openAttachment: function (attachment) {
        window.open(attachment.attachmentUrl);
    },

    renderOpenAttachment: function (attachment, index) {
        if (attachment.Type__c.indexOf('image') != -1) {
            this.setState({
                modalOpen: true,
                selectedAttachment: attachment,
                selectedAttachmentIndex: index
            });
        } else {
            this.setState({modalOpen: false});
            window.open(attachment.attachmentUrl);
        }
    },

    closeImagesModal: function () {
        this.setState({modalOpen: false});
    },

    getFileIcon: function (file) {
        let icon = "unknown",
            mimeType = file.Type__c,
            fileExt = file.Name.split('.').pop(),
            type = (mimeType.split('/'))[0],
            subtype = (mimeType.split('/')[1]);
        if (fileExt && _.indexOf(['exe', 'csv', 'zip', 'ai', 'eps'], fileExt) != -1) {
            icon = fileExt;
        } else if (subtype && _.indexOf(['pdf', 'xml', 'rtf', 'html'], subtype) != -1) {
            icon = subtype;
        } else if (subtype && (subtype.indexOf('psd') != -1 || subtype.indexOf('photoshop') != -1)) {
            icon = "psd";
        } else if (subtype && (subtype.indexOf('ms-msword') != -1 || subtype.indexOf('wordprocessingml') != -1)) {
            icon = "word";
        } else if (subtype && (subtype.indexOf('ms-powerpoint') != -1 || subtype.indexOf('presentationml') != -1)) {
            icon = "ppt";
        } else if (subtype && (subtype.indexOf('ms-excel') != -1 || subtype.indexOf('spreadsheetml') != -1)) {
            icon = "excel";
        } else if (type && _.indexOf(['image', 'video', 'audio'], type) != -1) {
            icon = type;
        } else if (type == "text") {
            icon = "txt";
        }
        return icon;
    },

    deleteAttachment: function (attachmentID) {
        var me = this;
        var confirmMessage = {
            title: (AppManager.getLabel("PP_TIT_CONFIRMATION") || 'Confirmation'),
            message: (AppManager.getLabel("PP_LBL_CONFIRMATION_DELETE_ATTACHMENT") || 'Do you want to delete selected attachment?'),
            cancelHandler: function () {
                me.setState({confirmMessage: null});
            },
            okHandler: function () {
                me.setState({confirmMessage: null});
                PromotionActions.deleteAttachment(attachmentID);
            }
        };
        this.setState({confirmMessage: confirmMessage});
    },

    openUploadModal: function () {
        this.setState({uploading: true});
    },

    closeUploadModal: function () {
        this.setState({uploading: false});
    },

    renderPreview: function () {
        var attachment = this.state.selectedAttachment ? this.state.selectedAttachment : this.state.attachments[0];
        var previewThumbnail = null;
        if (attachment) {
            if (attachment.previewUrl && (attachment.Type__c.indexOf('image') == 0 || attachment.Type__c.indexOf('video') == 0)) {
                previewThumbnail = <a onClick={(event) => {event.preventDefault()}}
                                      href={attachment.attachmentUrl}
                                      className="ui-previewThumbnail"
                                      style={{backgroundImage: `url('${attachment.previewUrl}')`}}/>
            } else {
                previewThumbnail =
                    <Icon style={{width: '150px', height: '150px'}} icon={this.getFileIcon(attachment)}
                          category="doctype"/>
            }

            return (
                <div className="tile tile--responsive">
                    <div className="slds-grid slds-wrap">
                        <div className="slds-size--1-of-1 slds-medium-size--1-of-1 slds-large-size--1-of-3 tile-item__borderBottom">
                            {this.renderEditList()}
                        </div>
                        <div className="slds-grid slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs slds-col--no-padded slds-grid--vertical-align-center slds-grid--align-center">
                            {previewThumbnail}
                        </div>
                        <div className="ui-attachment-edit__description slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs">
                            <div className="slds-grid slds-p-bottom--medium">
                                <div className="slds-col--padded-right--small slds-size--1-of-2">
                                    <Input label={AppManager.getLabel("PP_LBL_NAME_ATTACHMENT") || 'Name'}
                                           disabled='true'
                                           type='text'
                                           placeholder={AppManager.getLabel("PP_LBL_NAME_ATTACHMENT") || 'Name'}
                                           onClick={(e) => e.currentTarget.setSelectionRange(0, e.currentTarget.value.length)}
                                           value={attachment.Name}
                                           readOnly="true"/>
                                </div>
                                <div className="slds-col--padded-left--small slds-size--1-of-2">
                                    <Input label={AppManager.getLabel("PP_LBL_SIZE_ATTACHMENT") || 'Size'}
                                           disabled='true'
                                           type='text'
                                           placeholder={AppManager.getLabel("PP_LBL_SIZE_ATTACHMENT") || 'Size'}
                                           onClick={(e) => e.currentTarget.setSelectionRange(0, e.currentTarget.value.length)}
                                           value={attachment.Size__c}/>
                                </div>
                            </div>
                            <div className="slds-p-bottom--medium">
                                <Input label={AppManager.getLabel("PP_LBL_DESCRIPTION_ATTACHMENT") || 'Description'}
                                       type='text'
                                       placeholder={AppManager.getLabel("PP_LBL_DESCRIPTION_ATTACHMENT") || 'Description'}
                                       onClick={(e) => e.currentTarget.setSelectionRange(0, e.currentTarget.value.length)}
                                       onChange={ (e, value) => {
                                           attachment._model.setDescription_Language_1__c(value);
                                           this.setState({});
                                       } }
                                       value={attachment.Description_Language_1__c}/>
                            </div>
                            <div className="slds-grid">
                                <div className="slds-col--padded-right--small slds-size--1-of-2">
                                    <Input
                                        label={AppManager.getLabel("PP_LBL_CREATION_DATE_ATTACHMENT") || 'Creation Date'}
                                        type='text' disabled='true'
                                        value={Utils.Converters.TS2Date(attachment.CreatedDate, 'YYYY-MM-DD')}/>
                                </div>
                                <div className="slds-col--padded-left--small slds-size--1-of-2">
                                    <Input
                                        label={AppManager.getLabel("PP_LBL_LAST_UPDATE_DATE_ATTACHMENT") || 'Last Update Date'}
                                        type='text' disabled='true'
                                        value={Utils.Converters.TS2Date(attachment.LastModifiedDate, 'YYYY-MM-DD')}/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            )
        } else {
            return null;
        }
    },

    renderEditList: function () {
        return (
            <ul className="ui-attachment-edit__fileList slds-has-dividers--bottom slds-scrollable--y">
                {this.state.attachments.map(file =>
                    <li ref={li => li && file.active && li.scrollIntoViewIfNeeded ? li.scrollIntoViewIfNeeded() : null}
                        onClick={() => this.selectAttachment(file)}
                        className={`ui-attachment-edit__fileItems slds-item ${file.active ? "is-Selected" : ""}`}>
                        <div className="slds-grid slds-p-around--x-small slds-grid--vertical-align-center">
                            <div className="slds-col slds-truncate">
                                <Icon icon={this.getFileIcon(file)} className="ui-icon__attachment"
                                      category="doctype"/>
                                <span className="slds-m-left--small"> {file.Name} </span>
                            </div>
                            <div className="slds-col--bump-left">
                                <Icon icon='delete' className="ui-icon__attachment ui-icon__attachment--deleted"
                                      category="utility"
                                      onClick={() => this.deleteAttachment(file.Id)}/>
                            </div>
                        </div>
                    </li>
                )}
            </ul>
        )
    },

    renderEdit: function () {
        return (
            <div className="ui-attachments__edit">
                <div className={`ui-attachments__add-box slds-align--absolute-center ${this.state.onFileHoverClass ? "is-Hover" : ""}`}
                    onDragOver={this.onFileHover} onDragLeave={this.onFileLeave} onDrop={this.onFileSelection}>
                    {AppManager.getLabel("PP_LBL_DRAG_ATTACHMENTS") || 'Drag attachments here or'}
                    <a className="slds-m-left--x-small">
                        <div className="slds-file-selector slds-file-selector--files">
                            <input className="slds-file-selector__input slds-assistive-text" accept="*/*" type="file"
                                   id="file-upload-input-01" aria-describedby="file-selector-id"
                                   onChange={this.onFileSelection}/>
                            <label className="ui-file-selector__text slds-text-link" htmlFor="file-upload-input-01">
                                {AppManager.getLabel("PP_LBL_UPLOAD_ATTACHMENTS") || 'Upload Files'}
                            </label>
                        </div>
                    </a>
                </div>
                {this.renderPreview()}
                {(this.state.uploading) ?
                    <UploadPopup title={AppManager.getLabel("PP_LBL_UPLOADING_ATTACHMENTS") || 'Uploading...'}
                                 onClose={() => this.closeUploadModal()}
                                 file={this.state.newAttachment} fileIcon={this.getFileIcon(this.state.newAttachment)}/>
                    :
                    null}
            </div>
        )
    },

    renderView: function () {
        var images = _.filter(this.state.attachments, (item) => item.Type__c.indexOf('image') != -1);
        var videos = _.filter(this.state.attachments, (item) => item.Type__c.indexOf('video') != -1);
        var files = _.difference(this.state.attachments, _.concat(images, videos));

        return (
            <div className="ui-attachments__view">
                { this.state.attachments.length ?
                    <div className="slds-grid slds-wrap">
                        <div className="slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3">
                            <div className="ui-attachment__title slds-text-heading--small slds-m-bottom--small">
                                <Icon icon="image"
                                      category="utility"/> {AppManager.getLabel("PP_LBL_IMAGES_ATTACHMENTS") || 'Images'}
                            </div>
                            <div className="ui-attachment__list slds-grid slds-wrap">
                                {images.map((image, i) => {
                                        return <a onClick={(event) => {
                                            event.preventDefault()
                                        }}
                                                  href={image.attachmentUrl}
                                                  className="ui-attachment__listItem slds-grid--vertical-align-center">
                                            {(image.previewUrl && image.previewUrl.length > 1) ?
                                                <div onClick={() => this.renderOpenAttachment(image, i)}
                                                     style={{backgroundImage: `url('${image.previewUrl}')`}}
                                                     className="ui-attachment__listThumbnail">
                                                    <span className="ui-overlay">
                                                        <Icon icon='search' category='utility'/>
                                                    </span>
                                                </div>
                                                :
                                                //Show Icon as we don't have a thumbnail.
                                                <div className="ui-attachment__listThumbnail"
                                                     onClick={() => this.renderOpenAttachment(image, i)}>
                                                    <span>
                                                      <Icon icon='photo' category='utility'/>
                                                    </span>
                                                    <span className="ui-overlay">
                                                        <Icon icon='search' category='utility'/>
                                                    </span>
                                                </div>
                                            }
                                        </a>
                                    }
                                )}
                                { (images.length % 3 == 1 || images.length % 3 == 2) ?
                                    <div className="slds-col--padded-right slds-size--1-of-3"></div> : null }
                                { (images.length % 3 == 1) ?
                                    <div className="slds-col--padded-right slds-size--1-of-3"></div> : null }
                            </div>
                        </div>
                        <div className="slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs">
                            <div className="ui-attachment__title slds-text-heading--small slds-m-bottom--small">
                                <Icon icon="video"
                                      category="utility"/> {AppManager.getLabel("PP_LBL_VIDEOS_ATTACHMENTS") || 'Videos'}
                            </div>
                            <ul className="slds-has-dividers--bottom">
                                {videos.map((video) =>
                                    <li onClick={() => this.openAttachment(video)}
                                        className="slds-grid slds-grid--vertical-align-center slds-m-bottom--small slds-p-bottom--x-small slds-item">
                                        <div className="ui-previewThumbnail-wrapper">
                                            {(video.previewUrl && video.previewUrl.length > 1) ?
                                                <div className="ui-previewThumbnail ui-previewThumbnail--video"
                                                     style={{backgroundImage: `url('${video.previewUrl}')`}}/>
                                                :
                                                <Icon icon="video" category="doctype"
                                                      className="slds-icon slds-icon-text-default ui-icon__attachment"/>
                                            }
                                        </div>
                                        <span className="slds-link slds-truncate"> {video.Name} </span>
                                    </li>
                                )}
                            </ul>
                        </div>
                        <div
                            className="ui-attachment-file slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs slds-col--no-padded">
                            <div className="ui-attachment__title slds-text-heading--small slds-m-bottom--small">
                                <Icon icon="file"
                                      category="utility"/> {AppManager.getLabel("PP_LBL_FILES_ATTACHMENTS") || 'Files'}
                            </div>
                            <ul className="ui-attachment-file__list slds-has-dividers--bottom">
                                {files.map((file) =>
                                    <li onClick={() => this.openAttachment(file)}
                                        className="ui-attachment-file__listItem slds-grid slds-grid--vertical-align-center slds-m-bottom--small slds-p-bottom--x-small slds-item">
                                        <div className="ui-icon__wrapper">
                                            <Icon icon={this.getFileIcon(file)} category="doctype"
                                                  className="ui-icon__attachment"/>
                                        </div>
                                        <span className="ui-attachment-file__listName slds-link slds-truncate"> {file.Name} </span>
                                    </li>
                                )}
                            </ul>
                        </div>
                    </div>
                    :
                    <div className="slds-grid slds-wrap">
                        <div className="ui-attachments__edit-box slds-align--absolute-center">
                            {AppManager.getLabel("PP_LBL_NO_ATTACHMENTS_UPLOADED_1") || 'No Attachments uploaded, yet. Switch to the'}
                            <label className="ui-file-selector__text slds-p-left--xx-small slds-p-right--xx-small slds-text-link"
                                onClick={() => this.props.editToggle()}>{AppManager.getLabel("PP_LBL_EDIT_MODE_ATTACHMENTS") || 'Edit Mode'}</label>{AppManager.getLabel("PP_LBL_NO_ATTACHMENTS_UPLOADED_2") || 'to Upload some Files.'}
                        </div>
                    </div>
                }
            </div>
        )
    },

    renderSpinner: function () {
        return (
            <div className="ui-spinner_container">
                <div className="slds-spinner--brand slds-spinner slds-spinner--large" aria-hidden="false" role="alert">
                    <div className="slds-spinner__dot-a"></div>
                    <div className="slds-spinner__dot-b"></div>
                </div>
            </div>
        );
    },

    render: function () {
        var images = _.filter(this.state.attachments, (item) => item.Type__c.indexOf('image') != -1);

        return (
            <div className="tile tile--responsive slds-m-bottom--medium animated">
                <div className="title slds-grid">
                    <label>{AppManager.getLabel("PP_TIT_ATTACHMENTS") || 'Attachments'}</label>
                </div>
                <div className="ui-attachments slds-grid slds-grid--vertical-align-center slds-grid--align-center"
                     key="attachments">
                    {
                        this.props.promotion.loadPhase == 'preload' ? this.renderSpinner()
                            :
                            (this.props.editMode) ? this.renderEdit() : this.renderView()
                    }
                </div>
                {(this.state.confirmMessage) ?
                    <ConfirmPopup title={this.state.confirmMessage.title}
                                  message={this.state.confirmMessage.message}
                                  cancelHandler={this.state.confirmMessage.cancelHandler}
                                  okHandler={this.state.confirmMessage.okHandler}/>
                    : null}
                {(this.state.modalOpen) ?
                    <ImagePopup onClose={() => this.closeImagesModal()}
                                images={images} selectedImage={this.state.selectedAttachment}
                                selectedImageIndex={this.state.selectedAttachmentIndex}/> : null}
            </div>
        );
    }
});
