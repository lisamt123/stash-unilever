"use strict";

var React = require('react');

var Input = require('react-lightning-design-system').Input;
var FieldSet = require('react-lightning-design-system').FieldSet;
var Row = require('react-lightning-design-system').Row;
var DateInput = require('react-lightning-design-system').DateInput;
var Picklist = require('react-lightning-design-system').Picklist;
var PicklistItem = require('react-lightning-design-system').PicklistItem;
var Checkbox = require('react-lightning-design-system').Checkbox;

module.exports = React.createClass({
    propTypes: {
        object: React.PropTypes.object, // This must be the BO/LI associated
        field: React.PropTypes.string, // The field associated
        onValueChange: React.PropTypes.func,
        editable: React.PropTypes.bool
    },

    isEditable: function () {
        if (this.props.object._acl) {
            if (this.props['editable'] !== undefined)
                return this.props['editable'] && this.props.object._acl.isEditable(1, this.props.field);
            else
                return this.props.object._acl.isEditable(1, this.props.field);
        }
        else return true;
    },

    isVisible: function () {
        if (this.props.object._acl) {
            var acl = this.props.object._acl;
            return acl.isVisible(1, this.props.field);
        }
        else return true;
    },

    render: function () {
        var metadata = this.props.object._meta[this.props.field];
        if (!this.isVisible())
            return null;
        else {
            if (metadata.type.toLowerCase() == "string" || metadata.type.toLowerCase() == "reference") {
                return (
                    <Input
                        label={metadata.label} disabled={!this.isEditable()}
                        type='text' placeholder={metadata.label}
                        onChange={ (e, value) => this.props.onValueChange(this.props.field, {}, value) }
                        onClick={(e) => e.currentTarget.setSelectionRange(0, e.currentTarget.value.length)}
                        value={this.props.object[this.props.field]}
                        title={this.props.object[this.props.field]}
                    />
                )
            }
            else if (metadata.type.toLowerCase() == "double" || metadata.type.toLowerCase() == "percent") {
                return (
                    <Input
                        label={metadata.label} disabled={!this.isEditable()}
                        type='text' placeholder={metadata.label}
                        onChange={ (e, value) => this.props.onValueChange(this.props.field, {}, value) }
                        onClick={(e) => e.currentTarget.setSelectionRange(0, e.currentTarget.value.length)}
                        onKeyPress={Utils.Validators.onlyKeyEventNumber}
                        value={this.isEditable() ? this.props.object[this.props.field] : Utils.Formatters.formatNumber(this.props.object[this.props.field])}
                    />
                );
            }

            else if (metadata.type.toLowerCase() == "date") {
                if (!this.isEditable()) {
                    return (
                        <Input className="variant-input-placeholder"
                               label={metadata.label}
                               disabled={!this.isEditable()}
                               type='text'
                               placeholder={metadata.label}
                               title={this.props.object[this.props.field]}
                               value={Utils.Converters.TS2Date(this.props.object[this.props.field], AppSettings.get('dateFormat') || 'YYYY-MM-DD')}
                        />
                    )
                } else {
                    return (
                        <DateInput label={metadata.label}
                                   placeholder={AppSettings.get('dateFormat')}
                                   disabled={!this.isEditable()}
                                   onValueChange={ (value) => this.props.onValueChange(this.props.field, {}, value) }
                                   dateFormat={AppSettings.get('dateFormat')}
                                   onClick={(e) => e.currentTarget.setSelectionRange(0, e.currentTarget.value.length)}
                                   value={Utils.Converters.TS2Date(this.props.object[this.props.field], 'YYYY-MM-DD')}
                        />
                    );
                }
            }
            else if (metadata.type.toLowerCase() == "picklist") {
                if (this.isEditable()) {
                    return (
                        <Picklist label={metadata.label}
                                  value={ this.props.object[this.props.field] }
                                  onValueChange={ (value) => this.props.onValueChange(this.props.field, {}, value) }>
                            { metadata.picklistValues.map((a, i) => {
                                return <PicklistItem key={ i + 1 } value={a.value} label={a.label}/>;
                            })}
                        </Picklist>);
                } else {
                    return (
                        <Input label={metadata.label} type='text' disabled="true"
                               value={ this.props.object[this.props.field]}/>

                    );
                }
            }
            else if (metadata.type.toLowerCase() == "boolean") {
                return (
                    <Checkbox disabled={!this.isEditable()}
                              label={metadata.label} checked={this.props.object[this.props.field]}
                              onChange={ () => this.props.onValueChange(this.props.field, {}, !this.props.object[this.props.field]) }/>
                );
            }
            else {
                return (<div> FIELD TYPE {metadata.type} NOT SUPPORTED </div>);
            }
        }
    }
});
