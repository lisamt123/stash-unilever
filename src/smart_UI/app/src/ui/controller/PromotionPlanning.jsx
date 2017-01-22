"use strict";

var React = require('react');
var AppHeader = require('../components/AppHeader');
var ReactCSSTransitionGroup = require('react-addons-css-transition-group');
var DrillDown = require('../promotion/Drilldown');
var PromotionOverview = require('../promotion/PromotionOverview');
var TacticOverview = require('../promotion/TacticOverview');

var PromotionPlanningCalculationGridPage = require('../calculationgrid/PromotionPlanningCalculationGridPage');
var PromotionActions = require('../../actions/PromotionActions').PromotionActions;

var ButtonGroup = require('react-lightning-design-system').ButtonGroup;
var Button = require('react-lightning-design-system').Button;
var DropdownButton = require('react-lightning-design-system').DropdownButton;
var MenuItem = require('react-lightning-design-system').MenuItem;
var MessagePopup = require('../components/MessagePopup.jsx');

var ConfirmPopup = require('../components/ConfirmPopup');

module.exports = React.createClass({
    displayName: 'PromotionPlanning',

    getInitialState: function () {
        return {
            editMode: false,
            pushMode: false,
            viewGrid: false,
            enableToolbar: true,
            selectedItem: null,
            showAttachments: false,
            isPromotionSelected: false,
            productSearch: [],
            confirmMessage: null,
            tree: null,
            type: 'neutral',
            message: null
        };
    },

    componentDidMount: function () {
        this.busHandlerID = UI_EVENT_BUS.subscribe(EVENTS.UI_BINDING, this.onUIBinding);
    },

    componentWillUnmount: function () {
        UI_EVENT_BUS.unsubscribe(this.busHandlerID);
    },

    onUIBinding: function (payload) {
        this.setState(payload)
    },

    promoChanged: function () {
        this.setState({
            promotion: this.props.promotion.serializeTree(),
            productFilters: this.props.promotion.serializeProductFilters(),
            selectedTactic: this.props.promotion.serializeSelectedTactic()
        })
    },

    /**HANDLERS**/
    /*When an item is selected in the drillDown*/
    selectItem: function (item) {
        var isPromotionSelected = true;
        if (item.type == 'PROMOTION') {
            PromotionActions.selectPromotion();
        }
        if (item.type == 'TACTIC') {
            PromotionActions.selectTactic(item.Id);
            isPromotionSelected = false;
        }
        this.setState({selectedItem: item, isPromotionSelected: isPromotionSelected});
    },

    addTactic: function (tacticTemplate) {
        PromotionActions.addTactic({Id: tacticTemplate.Id, Type: tacticTemplate.Type});
    },

    duplicateTactic: function (tactic) {
        PromotionActions.duplicateTactic(tactic.Id);
    },

    deleteTactic: function (tactic) {
        var me = this;
        var confirmMessage = {
            title: 'Confirmation',
            message: 'Do you want to delete the tactic?',
            cancelHandler: function () {
                me.setState({confirmMessage: null});
            },
            okHandler: function () {
                PromotionActions.deleteTactic(tactic.Id);
                me.setState({confirmMessage: null});
            }
        };

        this.setState({confirmMessage: confirmMessage})
    },

    updateTactic: function (id, name, value) {
        PromotionActions.setTacticField(id, name, value);
    },

    updatePromotion: function (id, name, value) {
        PromotionActions.setPromotionField(id, name, value);
    },

    /*When save button is clicked*/
    save: function () {
        if (this.state.tree && this.state.tree != null) {
            PromotionActions.setPromotionField(this.state.promotion.Id, 'Manual_Calculation_Input__c', JSON.stringify(this.state.tree.getManualChanges()));
        }
        PromotionActions.save(this.state.promotion.Id);
        this.setState({editMode: false});
    },

    saveAndRefresh: function () {
        if (this.state.tree && this.state.tree != null) {
            PromotionActions.setPromotionField(this.state.promotion.Id, 'Manual_Calculation_Input__c', JSON.stringify(this.state.tree.getManualChanges()));
        }
        this.setState({enableToolbar: false});
        PromotionActions.saveAndRefresh(this.state.promotion.Id);

    },
    //Unilever Function to call the Workflow change
    changeWf: function (e) {
        console.log(e);
        PromotionActions.changeWfState(e);
    },

    //PMA - START CODE - 2017-01-13 - Threshold button
    invokeThreshold: function () {
        PromotionActions.invokeThreshold(this.state.promotion.Id, this);
    },
    //PMA - END CODE - 2017-01-13 - Threshold button

    //PMA - START CODE - 2017-01-17 - Audit Trail button
    invokeAuditTrail: function () {
        PromotionActions.invokeAuditTrail();
    },
    //PMA - END CODE - 2017-01-17 - Audit Trail button

    /*When edit button is clicked*/
    edit: function () {
        this.setState({editMode: true});
    },

    cancel: function () {
        var me = this;
        this.setState({enableToolbar: false});
        PromotionActions.cancelEdit(this.state.promotion.Id, (this.state.tree && this.state.tree != null) ? "tree" : "ui");

        this.setState({editMode: false});
    },

    pushMode: function () {
        this.setState({pushMode: true});
    },

    pushModeEnd: function () {
        this.setState({pushMode: false});
    },

    updateEnablePush: function () {
        PromotionActions.updateEnablePush();
    },

    loadPlanningData: function () {
        PromotionActions.setPromotionField(this.state.promotion.Id, 'Manual_Calculation_Input__c', JSON.stringify(this.state.tree.getManualChanges()));
        this.setState({viewGrid: false});
    },

    loadGridData: function (showGrid) {
        var me = this;
        if (showGrid) {
            this.setState({viewGrid: true});
            PromotionActions.loadPromotionGrid(this.state.promotion.Id, this.state.promotion.Manual_Calculation_Input__c);
        }
    },

    /**RENDERING*/
    renderModeButtonGroup: function () {
        return (
            <ButtonGroup>
                <Button className="view-switch icon-button" type={(this.state.viewGrid) ? 'neutral' : 'brand'}
                        icon='side_list' disabled={!this.state.enableToolbar}
                        onClick={() => this.loadPlanningData()}/>
                <Button className="view-switch icon-button" type={(!this.state.viewGrid) ? 'neutral' : 'brand'}
                        icon='table'
                        disabled={!this.state.enableToolbar}
                        onClick={() => this.loadGridData(true)}/>
            </ButtonGroup>
        )
    },

    isVisible(attribute){
        var acl = this.state.promotion._acl;
        return acl.isVisible(1, attribute);
    },

    renderToolbarView: function () {
        var editButton, approveButton, cancelButton, kickOffWorkflowButton, pushButton, releaseButton, thresholdButton,
            simulationButton, modelButton, plannedButton, submittedForApprovalButton, rejectedButton, finalisedButton, cancelledButton,
            stoppedButton, auditTrailButton, endDateButton = null;

        if (this.state.promotion != null && this.state.promotion.isEditable && (this.state.viewGrid || (!this.state.viewGrid && this.state.selectedItem != null && (this.state.selectedItem.type == 'PROMOTION' || this.state.selectedItem.type == 'TACTIC')))) {
            editButton = <Button className="margin-large icon-button" type='neutral' icon='edit' iconAlign='left'
                                 onClick={() => this.edit()}>{AppManager.getLabel('PP_BTN_EDIT') || 'Edit'}</Button>;

            //Custom buttons available in the left side of the toolbar
            //PMA - START CODE - 2017-01-12 - Toolbar buttons visibility
            //START SoCo Buttons
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_SUBMIT"))
                kickOffWorkflowButton = <Button className="margin-large icon-button" type='neutral'
                                                onClick={(e) => this.changeWf('SUBMIT')}>{AppManager.getLabel('PP_BTN_SUBMIT') || 'Submit'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_APPROVE"))
                approveButton = <Button className="margin-large icon-button" type='neutral'
                                        onClick={(e) => this.changeWf('APPROVE')}>{AppManager.getLabel('PP_BTN_APPROVE') || 'Approve'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_REJECT"))
                cancelButton = <Button className="margin-large icon-button" type='neutral'
                                       onClick={(e) => this.changeWf('REJECT')}>{AppManager.getLabel('PP_BTN_REJECT') || 'Reject'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_ENDDATE"))
                endDateButton = <Button className="margin-large icon-button" type='neutral'
                                       onClick={(e) => this.changeWf('EndDate')}>{AppManager.getLabel('PP_BTN_ENDDATE') || 'End Date'}</Button>;
            //START UK Buttons
            //PMA - START CODE - 2017-01-16 - New UK Button
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_SIMULATION"))
                simulationButton = <Button className="margin-large icon-button" type='neutral'
                                           onClick={(e) => this.changeWf('Simulation')}>{AppManager.getLabel('PP_BTN_SIMULATION') || 'Simulation'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_MODEL"))
                modelButton = <Button className="margin-large icon-button" type='neutral'
                                      onClick={(e) => this.changeWf('Model')}>{AppManager.getLabel('PP_BTN_MODEL') || 'Model'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_PLANNED"))
                plannedButton = <Button className="margin-large icon-button" type='neutral'
                                        onClick={(e) => this.changeWf('Planned')}>{AppManager.getLabel('PP_BTN_PLANNED') || 'Planned'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_SUBMITTEDFORAPPROVAL"))
                submittedForApprovalButton = <Button className="margin-large icon-button" type='neutral'
                                                     onClick={(e) => this.changeWf('Submitted for Approval')}>{AppManager.getLabel('PP_BTN_SUBMITTEDFORAPPROVAL') || 'Submitted for Approval'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_REJECTED"))
                rejectedButton = <Button className="margin-large icon-button" type='neutral'
                                         onClick={(e) => this.changeWf('Rejected')}>{AppManager.getLabel('PP_BTN_REJECTED') || 'Rejected'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_FINALISED"))
                finalisedButton = <Button className="margin-large icon-button" type='neutral'
                                          onClick={(e) => this.changeWf('Finalised')}>{AppManager.getLabel('PP_BTN_FINALISED') || 'Finalised'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_CANCELLED"))
                cancelledButton = <Button className="margin-large icon-button" type='neutral'
                                          onClick={(e) => this.changeWf('Cancelled')}>{AppManager.getLabel('PP_BTN_CANCELLED') || 'Cancelled'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_STOPPED"))
                stoppedButton = <Button className="margin-large icon-button" type='neutral'
                                        onClick={(e) => this.changeWf('Stopped')}>{AppManager.getLabel('PP_BTN_STOPPED') || 'Stopped'}</Button>;
            //PMA - END CODE - 2017-01-16 - New UK Button
            //PMA - START CODE - 2017-01-13 - Threshold button
            if (this.state.promotion != null)
                thresholdButton = <Button className="margin-large" type='neutral'
                                          onClick={(e) => this.invokeThreshold()}>{AppManager.getLabel('PP_BTN_INVOKETHRESHOLD') || 'Threshold'}</Button>;
            //PMA - END CODE - 2017-01-13 - Threshold button

            //Custom buttons available in the right side of the toolbar
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_AUDITTRAIL"))
                auditTrailButton = <Button className="margin-large icon-button" type='neutral'
                                           onClick={(e) => this.invokeAuditTrail()}>{AppManager.getLabel('PP_BTN_AUDITTRAIL') || 'Audit Trail'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_PUSH"))
                pushButton = <Button className="margin-large icon-button" type='neutral' disabled={this.state.pushMode || !this.state.isPromotionSelected}
                                     onClick={(e) => this.pushMode()}>{AppManager.getLabel('PP_BTN_PUSH') || 'Push'}</Button>;
            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_RELEASE"))
                releaseButton = <Button className="margin-large" type='neutral' disabled={!this.state.isPromotionSelected}
                                        onClick={(e) => this.updateEnablePush()}>{AppManager.getLabel('PP_BTN_RELEASE') || 'Release'}</Button>;
            //PMA - END CODE - 2017-01-12 - Toolbar buttons visibility
        }

        return (
            //add buttons in here
            <div className="slds-grid">
                {this.renderModeButtonGroup()}
                {editButton}
                {kickOffWorkflowButton}
                {approveButton}
                {rejectedButton}
                {cancelButton}
                {endDateButton}
                {simulationButton}
                {modelButton}
                {plannedButton}
                {submittedForApprovalButton}
                {finalisedButton}
                {cancelledButton}
                {stoppedButton}
                {thresholdButton}
                <div className='slds-col--bump-right'/>
                {this.state.promotion && this.state.promotion.ChildAccounts && this.state.promotion.ChildAccounts.length > 0 ?
                    <div className="slds-container--right">
                        {auditTrailButton}
                        {pushButton}
                        {releaseButton}
                    </div>
                    :
                    <div className="slds-container--right">
                        {auditTrailButton}
                    </div>
                }
                {(!this.state.viewGrid) ?
                    <Button className="ui-attachment__button icon-button"
                            type={(this.state.showAttachments) ? 'brand' : 'neutral'}
                            icon='attach'
                            disabled={!this.state.isPromotionSelected}
                            onClick={() => this.setState({showAttachments: !this.state.showAttachments})}/>
                    : null}
            </div>
        )
    },

    // Change Button color onClick
    noFocus: function (option) {
        this.setState({
            type: 'neutral'
        });
    },

    changeButtonTypeOnClick: function () {
        if (this.state.type == 'neutral') {
            this.setState({
                type: 'brand'
            });
        } else {
            this.setState({
                type: 'neutral'
            });
        }
    },

    renderToolbarEdit: function () {
        var menuItems = [];
        var enableToolbar = this.state.enableToolbar;
        return (
            <div className="slds-grid">
                {this.renderModeButtonGroup()}
                {(!this.state.viewGrid && this.state.selectedTactic == null && this.isVisible("TOOLBAR_BTN_ADDTACTIC")) ?
                    <DropdownButton className="margin-large icon-dropdown"
                                    type={this.state.type} onBlur={this.noFocus} onMenuItemClick={this.noFocus}
                                    onClick={this.changeButtonTypeOnClick}
                                    icon='add' iconAlign='left'
                                    iconMore=''
                                    label='Add'
                                    disabled={!enableToolbar}
                                    menuAlign='center' nubbinTop>
                        <label className='menuItemLabel'>{AppManager.getLabel('PP_LBL_TACTIC') || 'TACTIC'}</label>
                        {this.state.promotion.tacticTemplates.map((tacticTemplate, ix) => {
                                return <MenuItem key={ix}
                                                 onClick={() => this.addTactic(tacticTemplate)}>{tacticTemplate.Description__c}</MenuItem>
                            }
                        )}
                    </DropdownButton>
                    : null}

                {(!this.state.viewGrid && this.state.selectedTactic != null) ?
                    <Button className="margin-large icon-button" type='neutral' icon='relate' iconAlign='left'
                            disabled={!enableToolbar}
                            onClick={() => this.duplicateTactic(this.state.selectedTactic)}>{AppManager.getLabel('PP_BTN_DUPLICATE') || 'Duplicate'}</Button>
                    : null}
                {(!this.state.viewGrid && this.state.selectedTactic != null) ?
                    <Button className="margin-small icon-button" type='neutral' icon='delete' iconAlign='left'
                            disabled={!enableToolbar}
                            onClick={() => this.deleteTactic(this.state.selectedTactic)}>{AppManager.getLabel('PP_BTN_DELETE') || 'Delete'}</Button>
                    : null}

                <div className='slds-col--bump-right'/>

                <Button type='neutral' icon='refresh' iconAlign='left' className="icon-button" disabled={!enableToolbar}
                        onClick={() => this.saveAndRefresh()}>{AppManager.getLabel('PP_BTN_SAVE_REFRESH') || 'Save & Refresh'}</Button>
                <Button className="margin-small icon-button" type='neutral' icon='close' iconAlign='left'
                        disabled={!enableToolbar}
                        onClick={() => this.cancel()}>{AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'}</Button>
                <Button className="margin-small icon-button" type='neutral' icon='check' iconAlign='left'
                        disabled={!enableToolbar}
                        onClick={() => this.save()}>{AppManager.getLabel('PP_BTN_DONE') || 'Done'}</Button>

                {(!this.state.viewGrid) ?
                    <Button className="ui-attachment__button icon-button"
                            type={(this.state.showAttachments) ? 'brand' : 'neutral'}
                            icon='attach'
                            disabled={!enableToolbar || !this.state.isPromotionSelected}
                            onClick={() => this.setState({showAttachments: !this.state.showAttachments})}/>
                    : null}

            </div>
        )
    },

    renderMainSectionView: function () {
        var overviewItem = null;
        if (this.state.selectedItem != null) {
            if (this.state.selectedItem.type == 'PROMOTION' || this.state.selectedTactic == null) {
                overviewItem = <PromotionOverview promotion={this.state.promotion}
                                                  editMode={this.state.editMode} update={this.updatePromotion}
                                                  showAttachments={this.state.showAttachments}
                                                  editToggle={this.edit} pushMode={this.state.pushMode}
                                                  pushModeEnd={this.pushModeEnd}/>
            } else {//if (this.state.selectedItem.type == 'TACTIC') {
                overviewItem = <TacticOverview item={this.state.selectedTactic} editMode={this.state.editMode}
                                               update={this.updateTactic } productFilters={this.state.productFilters}
                                               productSearch={this.state.productSearch} onSelect={this.selectItem}/>
            }
            /*else if (this.state.selectedItem.type == 'CATEGORY') {
             overviewItem = <ProductGroupOverview item={this.state.selectedItem}/>
             } else if (this.state.selectedItem.type == 'PRODUCT') {
             overviewItem = <ProductOverview item={this.state.selectedItem}/>
             }*/
        }
        return (
            <div className="mainBodySection slds-grid">
                <div className="slds-grid slds-nowrap slds-grid--vertical-stretch" style={{width: '100%'}}>
                    <DrillDown root={this.state.promotion} onSelect={this.selectItem}
                               selectedTactic={this.state.selectedTactic}/>
                    <div className="flex-grow slds-scrollable--y" style={{maxWidth: 'calc(100% - 360px)'}}>
                        {overviewItem}
                    </div>
                </div>
            </div>
        )
    },

    renderGridSectionView: function () {
        return (
            <div className="slds-scrollable--y mainBodySection slds-grid">
                <div className="slds-size--1-of-1 slds-grid slds-wrap slds-grid--vertical-stretch">
                    <div className="slds-size--1-of-3 tile calc-grid">
                        <PromotionPlanningCalculationGridPage tree={this.state.tree} editMode={this.state.editMode}
                                                              idToLabelMapping={this.state.idToLabelMapping}
                                                              acl={this.state.promotion._acl}/>
                    </div>
                </div>
            </div>

        )
    },

    showLog: function (e) {
        if (e.ctrlKey && e.altKey) {
            console.group('DEBUGGER INFORMATION')
            console.dir(this.state.promotion);
            console.log("State");
            console.dir(this.state);
            console.groupEnd();
        }
    },

    render: function () {
        var toolbar = (this.state.editMode) ? this.renderToolbarEdit() : this.renderToolbarView();
        var mainSection = (this.state.viewGrid) ? this.renderGridSectionView() : this.renderMainSectionView();

        var appHeader = null;
        if (this.state.promotion != null) {
            var fromDate = /*(_.isDate(this.props.promotion.Date_From__c)) ?*/ Utils.Formatters.formatDate(this.state.promotion.Date_From__c)/* : this.props.promotion.Date_From__c*/;
            var toDate = /*(_.isDate(this.props.promotion.Date_Thru__c)) ? */Utils.Formatters.formatDate(this.state.promotion.Date_Thru__c) /*: this.props.promotion.Date_Thru__c*/;
            var account = (this.state.promotion.Anchor_Account__r != null) ? this.state.promotion.Anchor_Account__r.Name : '';
            appHeader =
                <AppHeader title={this.state.promotion.Slogan__c} subtitle={account + ' ' + fromDate + ' - ' + toDate}
                           icon='promo.png'/>
        }

        return (
            <div className="mainSection ">
                {(this.state.message) ?
                    <MessagePopup title={this.state.message.title} message={this.state.message.message}
                                  messagejson={this.state.message.messagejson}
                                  cancelHandler={this.state.message.cancelHandler}/> : null}
                {(this.state.confirmMessage) ?
                    <ConfirmPopup title={this.state.confirmMessage.title} message={this.state.confirmMessage.message}
                                  cancelHandler={this.state.confirmMessage.cancelHandler}
                                  okHandler={this.state.confirmMessage.okHandler}/> : null}
                {appHeader}

                <div className="slds-page-header promotion-toolbar" onClick={this.showLog}>
                    {toolbar}
                </div>
                {(this.state.promotion != null) ? mainSection : null}
            </div>
        )
    }
});
