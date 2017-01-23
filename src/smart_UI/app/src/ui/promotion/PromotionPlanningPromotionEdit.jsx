"use strict";

var React = require('react');

var Variant = require('../components/Variant.jsx');
var Button = require('react-lightning-design-system').Button;

module.exports = React.createClass({
    getInitialState: function () {
        return {
            promotion: this.props.promotion,
        };
    },

    componentWillReceiveProps: function (nextProps) {
        if (nextProps.promotion != null) this.setState({promotion: nextProps.promotion});
    },

    onFieldChange: function (name, e, value) {
        var obj = this.state.promotion;

        this.props.update(obj.Id, name, value);

        //Unilver changes for copy lift factor
        if (name == "UL_Lift__c")
            PromotionActions.copyLiftToTactics(value);

        //PMA - START CODE - 2017-01-12 - Copy date from Promotion to Tactic
        if (name == "Date_From__c") PromotionActions.copyDateFromToTactics(value);
        if (name == "Date_Thru__c") PromotionActions.copyDateThruToTactics(value);
        if (name == "Delivery_Date_From__c") PromotionActions.copyDeliveryDateFromToTactics(value);
        if (name == "Delivery_Date_Thru__c") PromotionActions.copyDeliveryDateThruToTactics(value);
        if (name == "Placement_Date_From__c") PromotionActions.copyInstoreDateFromToTactics(value);
        if (name == "Placement_Date_Thru__c") PromotionActions.copyInstoreDateThruToTactics(value);
        //PMA - END CODE - 2017-01-12 - Copy date from Promotion to Tactic
    },

    getContent: function () {
        return this.state.promotion;
    },

    render: function () {
        if (this.state.promotion == null) {
            return (
                <div style={{flex: '1 0 0'}}
                     className="slds-grid slds-grid--vertical-align-center slds-grid--align-center">
                    <div>{AppManager.getLabel('PP_TIT_NOCONTENT') || 'NO CONTENT'}</div>
                </div>)
        }
        else {
            return (
                <div className="tile">
                    <div className="slds-grid title">{AppManager.getLabel('PP_LBL_MAIN_INFO') || 'Main Information'}</div>
                    <div className="slds-m-top--medium"/>
                    <div className="slds-grid slds-wrap">
                        <div className="slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3">
                            {/* <div className="slds-form-element__label slds-form-element__label--title">{AppManager.getLabel('PP_LBL_MAIN_INFO') || 'Main Information'}</div> */}
                            <div className="slds-m-top--medium"/>
                            <Variant object={this.state.promotion} field="Slogan__c" onValueChange={this.onFieldChange}
                                     editable={this.props.editMode }/>

                            {this.state.promotion.Anchor_Account__c ?
                                <div>
                                    <div className="slds-m-top--medium"/>
                                    <Variant object={this.state.promotion} field="Anchor_Account__c" editable={false }/>
                                </div>
                                : <div>
                                    <div className="slds-m-top--medium"/>
                                    <Variant object={this.state.promotion} field="Anchor_Account_Set__c"
                                             editable={false }/>
                                </div> }

                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.promotion} field="Promotion_Template__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                                <div className="slds-col">
                                    <Variant object={this.state.promotion} field="UL_Lift__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>
                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.promotion} field="UL_Volume_Type__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                                <div className="slds-col">
                                    <Variant object={this.state.promotion} field="UL_Front_Margin__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>
                        </div>

                        <div className="slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left">
                            <div className="slds-form-element__label slds-form-element__label--title">{AppManager.getLabel('PP_LBL_DATES') || 'Dates'}</div>
                            
                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.promotion} field="Date_From__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                                <div className="slds-col">
                                    <Variant object={this.state.promotion} field="Date_Thru__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>

                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.promotion} field="Placement_Date_From__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                                <div className="slds-col">
                                    <Variant object={this.state.promotion} field="Placement_Date_Thru__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>

                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.promotion} field="Delivery_Date_From__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                                <div className="slds-col">
                                    <Variant object={this.state.promotion} field="Delivery_Date_Thru__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>
                        </div>

                        <div
                            className="slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs  slds-col--padded-left">

                            {AppManager.getLabel('PP_LBL_STATUS') || 'Status'}

                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col">
                                    <Variant object={this.state.promotion} field="UL_Current_Status__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>
                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col">
                                    <Variant object={this.state.promotion} field="Phase__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>
                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col">
                                    <Variant object={this.state.promotion} field="UL_ThresholdViolated__c"
                                        onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                                <div className="slds-col">
                                    <Variant object={this.state.promotion} field="Active__c"
                                        onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>
                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col">
                                    <Variant object={this.state.promotion} field="Parent_Promotion__c"
                                        onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="slds-m-top--large">
                        <Variant object={this.state.promotion} field="UL_Free_Text__c"
                                 onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                        <div className="slds-m-top--large">
                            <Variant object={this.state.promotion} field="UL_Delivery_Profile__c"
                                     onValueChange={this.onFieldChange}
                                     editable={this.props.editMode }/>
                        </div>
                    </div>

                    {/* UKI fields start */}
                    <div className="slds-grid">
                        <div className="slds-m-top--large">
                        </div>
                        <div
                            className="slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs ">
                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.promotion} field="UL_Mechanic__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>
                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.promotion} field="UL_Cannibalisation_Override__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>
                            <div className="slds-m-top--medium"/>
                            <div className="slds-grid ">
                                <div className="slds-col--padded-right">
                                    <Variant object={this.state.promotion} field="UL_Promotion_Type__c"
                                             onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                                </div>
                            </div>
                        </div>
                        <div
                            className="slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs slds-col--padded-right ">
                            <div className="slds-m-top--medium"/>
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.promotion} field="UL_Sub_Mechanic__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                            <div className="slds-m-top--medium"/>
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.promotion} field="UL_Feature__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                            <div className="slds-m-top--medium"/>
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.promotion} field="UL_Account__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                        </div>
                        <div className="slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 ">
                            <div className="slds-m-top--medium"/>
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.promotion} field="UL_Primary_Objective__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                            <div className="slds-m-top--medium"/>
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.promotion} field="UL_Post_Dip_End_Date__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>
                            <div className="slds-m-top--medium"/>
                            <div className="slds-col--padded-right">
                                <Variant object={this.state.promotion} field="UL_Pre_Evaluation_Comment__c"
                                         onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            </div>

                        </div>
                        <div
                            className="slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs">
                            <div className="slds-m-top--medium"/>
                            <Variant object={this.state.promotion} field="UL_Secondary_Objective__c"
                                     onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            {/* PMA - START CODE - 2017-01-12 - New custom field */}
                            <div className="slds-m-top--medium"/>
                            <Variant object={this.state.promotion} field="UL_Cannibalisation_Rate__c"
                                     onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            <div className="slds-m-top--medium"/>
                            <Variant object={this.state.promotion} field="UL_Market__c"
                                     onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            {/* PMA - END CODE - 2017-01-12 - New custom field */}
                            <div className="slds-m-top--medium"/>
                            <Variant object={this.state.promotion} field="UL_Category__c"
                                     onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                            <div className="slds-m-top--medium"/>
                            <Variant object={this.state.promotion} field="UL_Brand__c"
                                     onValueChange={this.onFieldChange} editable={this.props.editMode }/>
                        </div>
                    </div>
                    {/* UKI fields end */}
                </div>
            )
        }
    }
});

