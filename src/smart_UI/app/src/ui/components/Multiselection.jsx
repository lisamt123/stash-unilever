"use strict";

var React = require('react');
var DropdownButton = require('react-lightning-design-system').DropdownButton;
var MenuItem = require('react-lightning-design-system').MenuItem;
var Icon = require('react-lightning-design-system').Icon;


DropdownButton.prototype.onMenuItemClick=function(...args) {
   
    if (this.props.onMenuItemClick) {
      this.props.onMenuItemClick(...args);
    }
}
module.exports = React.createClass({
    displayName: 'Multiselection',

    toggle: function (id, event) {
        this.props.toggleHandler(id);
        
    },

    componentDidMount: function () {
        var ddDOM = ReactDOM.findDOMNode(this.refs.dropdown.refs.dropdown);
        if (ddDOM.className.indexOf(" slds-scrollable--y") == -1)
            ddDOM.className += " slds-scrollable--y";
    },

    getPlaceholder: function () {
        var selection = (AppManager.getLabel("PC_LBL_SELECT") || 'Select') + '...';
        var selected = _.filter(this.props.values, {Selected: true});
        if (selected.length >= 3) {
            selection = selected.length + " " + (AppManager.getLabel("PC_LBL_VALUES_SELECTED") || 'values selected');
        }
        else if (selected.length > 0) {
            selection = _.map(_.filter(this.props.values, {Selected: true}), 'Label').join(', ');
        }
        return selection;
    },

    render: function () {
        var klass = 'multiselection slds-form-element ' + this.props.className;

        return (
            <div className={klass}>
                <label className="slds-form-element__label">{this.props.label}</label>

                <div className="slds-form-element__control">
                    <DropdownButton type='neutral' menuAlign='left' label={this.getPlaceholder()} ref='dropdown'>
                        {this.props.values.map((item, ix) => {
                                return <MenuItem key={ix}
                                                 onClick={(event) =>this.toggle(item.Id, event)}
                                                  className="slds-has-icon slds-has-icon--left">
                                    {(item.Selected) ? <Icon icon='check' size="x-small" className="slds-icon--left"/> :
                                        <Icon icon='none' size="x-small" className="slds-icon--left"/>}
                                    {item.Label}
                                </MenuItem>
                            }
                        )}
                    </DropdownButton>
                </div>
            </div>
        )
    }
});
