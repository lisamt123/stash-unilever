"use strict";

var React = require('react');

var Input = require('react-lightning-design-system').Input;
var DateInput = require('react-lightning-design-system').DateInput
var Picklist = require('react-lightning-design-system').Picklist;
var PicklistItem = require('react-lightning-design-system').PicklistItem;
var Row = require('react-lightning-design-system').Row;
var Form = require('../components/Form');

module.exports = React.createClass({
    displayName: 'NewPromotion',

    getInitialState: function () {
        var initialPromotionTemplate = null;
        if (this.props.calendar.active_promotion_templates.length > 0) {
            initialPromotionTemplate = this.props.calendar.active_promotion_templates[0];
        }

        var initialAccount = null;
        if (this.props.calendar.accounts.length > 0) {
            initialAccount = this.props.calendar.accounts[0].Id;
        }

        var initialAccountSet = null;
        if (this.props.calendar.accountSet.length > 0) {
            initialAccountSet = this.props.calendar.accountSet[0].Id;
        }

        return {
            promotion: {
                Slogan__c: '',
                Date_From__c: new Date(),
                account: initialAccount,
                accountSet: initialAccountSet,
                promotion_template: initialPromotionTemplate,
                period: 'week',
                duration: 1
            },

            periods: [
                {value: 'day', label: AppManager.getLabel('PC_LBL_DAYS') || 'Days'},
                {value: 'week', label: AppManager.getLabel('PC_LBL_WEEKS') || 'Weeks'},
                {value: 'month', label: AppManager.getLabel('PC_LBL_MONTHS') || 'Months'}
            ]
        }
    },

    onFieldChange: function (field, newValue) {
        var modifiedPromotion = this.state.promotion;
        modifiedPromotion[field] = newValue;
        this.setState({promotion: modifiedPromotion});
    },

    onSave: function () {
        this.props.saveHandler(this.state.promotion);
    },

    onCancel: function () {
        this.props.cancelHandler();
    },

    render: function () {
        var accountDropdown = null;
        var promotion_template = this.state.promotion.promotion_template;

        if (promotion_template !== null) {
            if (promotion_template.Anchor_Type === 'Customer') {
                accountDropdown =
                    <div>
                        <div className="new-promotion-label">
                            <span className="required">*</span><span>{' ' + AppManager.getLabel('PC_LBL_ANCHOR_CUSTOMER') || 'Anchor Customer'}</span>
                        </div>
                        <Picklist value={ this.state.promotion.account }
                                  onValueChange={ (value) => this.onFieldChange('account',  value) }>
                            {this.props.calendar.accounts.map((a, i) => {
                            return <PicklistItem key={ i + 1 } value={a.Id} label={a.Label} />;
                            })}
                        </Picklist>
                    </div>;
            }
            else if (promotion_template.Anchor_Type === 'CustomerSet') {
                accountDropdown =
                    <div>
                        <div className="new-promotion-label">
                            <span className="required">*</span><span>{' ' + AppManager.getLabel('PC_LBL_ANCHOR_CUSTOMER_SET') || 'Anchor Customer Set'}</span>
                        </div>
                        <Picklist value={ this.state.promotion.accountSet }
                                  onValueChange={ (value) => this.onFieldChange('accountSet',  value) }>
                            {this.props.calendar.accountSet.map((a, i) => {
                            return <PicklistItem key={ i + 1 } value={a.Id} label={a.Label} />;
                            })}
                        </Picklist>
                    </div>;
            }
        }

        var fields = [
            {
                component:  <div>
                <div className="new-promotion-label">
                <span className="required">*</span><span>{' ' + AppManager.getLabel('PC_LBL_SLOGAN') || 'Slogan'}</span>
                </div>
                    <Input type='text'
                           className="slds-m-bottom--medium"
                           onChange={ (e,value) => this.onFieldChange('Slogan__c',  value) }
                           onClick={(e)=>e.currentTarget.setSelectionRange(0, e.currentTarget.value.length)}
                           value={this.state.promotion.Slogan__c} />
                </div>,
                required: true,
                value:this.state.promotion.Slogan__c
            },
            {
                component: <div>
                <div className="new-promotion-label">
                <span className="required">*</span><span>{' ' + AppManager.getLabel('PC_LBL_START') || 'Start'}</span>
                </div>
                    <DateInput placeholder={AppSettings.get('dateFormat')}
                               onValueChange={ (value) => this.onFieldChange('Date_From__c', value) }
                               dateFormat={AppSettings.get('dateFormat')}
                               onClick={(e)=>e.currentTarget.setSelectionRange(0, e.currentTarget.value.length)}
                               value={Utils.Converters.TS2Date(this.state.promotion.Date_From__c,'YYYY-MM-DD')} />
                </div>,
                required: true,
                isValid:val=> val!='' && val.toString() !='Invalid date',
                value:Utils.Converters.TS2Date(this.state.promotion.Date_From__c,'YYYY-MM-DD')
            },
            {
                component: <div className="slds-form-element slds-m-top--medium slds-m-bottom--medium">
                        <label className="slds-form-element__label">
                            <span className="required">*</span><span>{' ' + AppManager.getLabel('PP_LBL_DURATION') || 'Duration'}</span>
                        </label>

                        <div className="slds-grid">
                            <div className="slds-m-right--medium">
                                <Input className="new-promotion-duration-input"
                                       type='text'
                                       onChange={ (e,value) => this.onFieldChange('duration',  value) }
                                       onClick={(e)=>e.currentTarget.setSelectionRange(0, e.currentTarget.value.length)}
                                       value={this.state.promotion.duration}
                                       maxLength={3} />
                            </div>

                            <div className="slds-col">
                                <Picklist value={ this.state.promotion.period }
                                          onValueChange={ (value) => this.onFieldChange('period',  value) }>
                                    { this.state.periods.map((a, i) => {
                                    return <PicklistItem key={ i + 1 } value={a.value} label={a.label} />;
                                    })}
                                </Picklist>
                            </div>
                        </div>
                </div>,
                required: true,
                isValid:val=> !isNaN(val) && parseInt(val)>0,
                value:this.state.promotion.duration
            },
            {
                component: <div className="slds-m-bottom--medium">
                        <div className="new-promotion-label">
                        <span className="required">*</span><span>{' ' + AppManager.getLabel('PC_LBL_PROMOTION_TEMPLATE') || 'Promotion Template'}</span>
                        </div>
                        <Picklist value={ this.state.promotion.promotion_template }
                                  onValueChange={ (value) => this.onFieldChange('promotion_template',  value) }>
                            { this.props.calendar.active_promotion_templates.map((a, i) => {
                            return <PicklistItem key={ i + 1 } value={a} label={a.Label} />;
                            })}
                        </Picklist>
                </div>,
                required: true,
                value:'value'
            },
            {
                component:  accountDropdown,
                required: true,
                value:'value'
            }
        ];

        return (
            <div className="slds-popover__body new-promotion">
                <Form class=" slds-p-around--large" fields={fields} onSave={this.onSave} onCancel={this.onCancel} />
            </div>
        )
    }
});
