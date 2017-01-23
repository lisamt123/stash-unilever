"use strict";

var React = require('react');
var Input = require('react-lightning-design-system').Input;
var FieldSet = require('react-lightning-design-system').FieldSet;
var Row = require('react-lightning-design-system').Row;
var DateInput = require('react-lightning-design-system').DateInput;
var Picklist = require('react-lightning-design-system').Picklist;
var PicklistItem = require('react-lightning-design-system').PicklistItem;
var Button = require('react-lightning-design-system').Button;
var Checkbox = require('react-lightning-design-system').Checkbox;

var ProductGrid = require('./ProductGrid');
var ProductFilter = require('./ProductFilter');
var ProductLookup = require('./ProductLookup');
var ConfirmPopup = require('../components/ConfirmPopup');

var Variant = require('../components/Variant.jsx');

var PromotionActions = require('../../actions/PromotionActions').PromotionActions;

module.exports = React.createClass({
    getInitialState: function () {
        return {
            tactic: this.props.tactic,
            confirmMessage: null,
            showManageProducts: false
        };
    },

    componentWillReceiveProps: function (nextProps) {
        if (nextProps.tactic != null) this.setState({tactic: nextProps.tactic});
    },

    onFieldChange: function (name, e, value) {
        var obj = this.state.tactic;
        this.props.update(obj.Id, name, value);
    },

    getContent: function () {
        return this.state.tactic;
    },

    manageProducts: function () {
        this.setState({showManageProducts: !this.state.showManageProducts});
    },

    openAddProducts: function () {
        this.setState({addingProduct: true});
    },

    searchForProducts: function (productSample) {
        PromotionActions.searchForProducts(productSample);
    },

    cancelAddProducts: function () {
        this.setState({addingProduct: false});
    },

    addProducts: function (products) {
        this.setState({addingProduct: false});
        PromotionActions.addProducts(products, this.props.tactic.Id);
    },

    applyFilterProducts: function () {
        PromotionActions.applyProductFilter(this.props.tactic.Id, this.refs.prodFilter.getFilterState());
    },

    toggleProduct: function (product) {
        var me = this;
        var confirmMessage = {
            title: (AppManager.getLabel('PP_TIT_CONFIRMATION') || 'Confirmation'),
            message: (AppManager.getLabel('PP_LBL_CONFIRMATION_EXCLUDE_PRODUCT') || 'Do you want to exclude the product?'),
            cancelHandler: function () {
                me.setState({confirmMessage: null});
            },
            okHandler: function () {
                //TODO
                me.setState({confirmMessage: null});
                PromotionActions.changeTacticProductRelationship(product.Id, me.props.tactic.Id, product.relationship)
            }
        };

        if (product.relationship == 'MATCH') {
            //confirmMessage.message='Do you want to exclude the product?'
            PromotionActions.changeTacticProductRelationship(product.Id, me.props.tactic.Id, product.relationship)
        }
        else if (product.relationship == 'EXCLUDED') {
            confirmMessage.message = 'Do you want to remove the exclusion for the product?';
            PromotionActions.changeTacticProductRelationship(product.Id, me.props.tactic.Id, product.relationship)
        }
        else if (product.relationship == 'INCLUDED') {
            confirmMessage.message = 'Do you want to remove the manually included product?';
            this.setState({confirmMessage: confirmMessage})
        }
    },

    renderManageProducts: function () {
        return (
            <div>
                <ProductFilter ref="prodFilter" tactic={this.state.tactic} {...this.props}/>

                <section className="slds-clearfix slds-m-top--small">
                    <div className="slds-float--right">
                        <Button type='neutral'
                                onClick={() =>this.openAddProducts()}>{AppManager.getLabel('PP_BTN_ADD') || 'Add'}</Button>
                        <Button type='neutral'
                                onClick={() =>this.applyFilterProducts()}>{AppManager.getLabel('PP_BTN_APPLY_FILTER') || 'Apply Filter'}</Button>
                    </div>
                </section>
                {(this.state.confirmMessage) ?
                    <ConfirmPopup title={this.state.confirmMessage.title} message={this.state.confirmMessage.message}
                                  cancelHandler={this.state.confirmMessage.cancelHandler}
                                  okHandler={this.state.confirmMessage.okHandler}/> : null}
                <ProductGrid tactic={this.state.tactic} {...this.props} toggleHandler={this.toggleProduct}/>
                {(this.state.addingProduct) ?
                    <ProductLookup addHandler={this.addProducts} cancelHandler={this.cancelAddProducts}
                                   searchHandler={this.searchForProducts} {...this.props}/> : null}
            </div>
        );
    },

    isEditable(attribute){
        var acl = this.state.tactic._acl;
        return this.props.editMode && acl.isEditable(0, "Tactic__c") && acl.isEditable(1, attribute);
    },

    isVisible(attribute){
        var acl = this.state.tactic._acl;
        return acl.isVisible(1, attribute);
    },

    render: function () {
        var tacticData = this.state.tactic;
        var metadata = tacticData._meta;
        var acl = this.state.tactic._acl;

        return (
            <div className="tile">
                <div className=" title slds-grid">{AppManager.getLabel('PP_TIT_TACTIC_INFO') || 'Tactic Information'}</div>
                <div className="slds-m-top--medium"/>
                <div className="slds-grid ">
                    <div className="slds-col--padded-right slds-size--1-of-3">
                        <Variant object={this.state.tactic} field="Tactic_Template__c" editable={false}/>
                        <div className="slds-m-top--medium"/>
                        <Variant object={this.state.tactic} field="Amount__c" onValueChange={this.onFieldChange}
                                 editable={this.props.editMode }/>

                        <div className="slds-grid slds-m-top--medium">
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.tactic} field="UL_Off_On_Invoice__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                            <div className="slds-col">
                                <Variant object={this.state.tactic} field="UL_Take_Up_Rate__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                        </div>
                        <div className="slds-grid slds-m-top--medium">
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.tactic} field="UL_Redemption__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                        </div>
                    </div>

                    <div className="slds-col--padded slds-size--1-of-3">
                        <div className="slds-grid ">
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.tactic} field="Lift__c" onValueChange={this.onFieldChange}
                                         editable={this.props.editMode }/>
                            </div>
                            <div className="slds-col">
                                <Variant object={this.state.tactic} field="Pct_of_Stores__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                        </div>
                        <div className="slds-grid slds-m-top--medium">
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.tactic} field="Date_From__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                            <div className="slds-col">
                                <Variant object={this.state.tactic} field="Date_Thru__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                        </div>

                        {/* soco start */}
                        <div className="slds-grid slds-m-top--medium">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.tactic} field="Instore_Date_From__c"   onValueChange={this.onFieldChange}  editable={this.props.editMode }/>
                                </div>
                                <div className="slds-col">
                                    <Variant object={this.state.tactic} field="Instore_Date_Thru__c"   onValueChange={this.onFieldChange}  editable={this.props.editMode }/>
                            </div>
                        </div>
                        <div className="slds-grid slds-m-top--medium">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.tactic} field="Shipment_Date_From__c"   onValueChange={this.onFieldChange}  editable={this.props.editMode }/>
                                </div>
                                <div className="slds-col">
                                    <Variant object={this.state.tactic} field="Shipment_Date_Thru__c"   onValueChange={this.onFieldChange}  editable={this.props.editMode }/>
                            </div>
                        </div>        
                        {/*}
                        <div className="slds-grid slds-m-top--medium">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.tactic} field="UL_Order_Date_From__c"   onValueChange={this.onFieldChange}  editable={this.props.editMode }/>
                                </div>


                                <div className="slds-col">
                                    <Variant object={this.state.tactic} field="UL_Order_Date_Thru__c"   onValueChange={this.onFieldChange}  editable={this.props.editMode }/>
                            </div>
                            
                        </div>
                        */}
                        {/* soco end */}

                    </div>
                    <div className="slds-col--padded slds-size--1-of-3">
                        <Variant object={this.state.tactic} field="Compensation_Model__c"
                                 onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                        <div className="slds-m-top--medium"/>
                        {/* PMA - START CODE - 2017-01-12 - New custom field */}
                        <Variant object={this.state.tactic} field="Payment_Method__c" onValueChange={this.onFieldChange}
                                 editable={this.props.editMode }/>
                        {/* PMA - END CODE - 2017-01-12 - New custom field */}

                        <div className="slds-grid slds-m-top--medium">
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.tactic} field="UL_Condition_Type__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                            <div className="slds-col">
                                <Variant object={this.state.tactic} field="UL_Investment_Method__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="slds-m-top--medium"></div>
                {(this.props.editMode && this.isVisible("TACTIC_BTN_MANAGE_PRODS")) ?
                <div className="slds-grid">
                        <Button type='neutral' icon='custom_apps' iconAlign='left'
                                onClick={() => this.manageProducts()}>{AppManager.getLabel('PP_BTN_MANAGE_PRODS') || 'Manage Products'}</Button>
                </div>
                : null}

                {this.props.editMode && this.state.showManageProducts ?
                    <div className="slds-m-top--medium">{this.renderManageProducts()}</div> : null}
            </div>
        )
    }
});

