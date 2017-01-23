"use strict";

var React = require('react');

var ButtonGroup = require('react-lightning-design-system').ButtonGroup;
var Button = require('react-lightning-design-system').Button;
var DropdownButton = require('react-lightning-design-system').DropdownButton;
var MenuItem = require('react-lightning-design-system').MenuItem;
var Icon = require('react-lightning-design-system').Icon;
var Picklist = require('react-lightning-design-system').Picklist;
var PicklistItem = require('react-lightning-design-system').PicklistItem;
var Input = require('react-lightning-design-system').Input;
var Multiselection = require('../components/Multiselection');
var Popover = require('../components/Popover');

var PromCalendarActions = require('../../actions/PromCalendarActions').PromCalendarActions;
var RemovablePill = require('../components/RemovablePill');

/*************************************************************/

var CalendarFilterItem = React.createClass({
    displayName: 'CalendarFilterItem',

    toggleValue: function (valueId) {
        var opt = _.find(this.props.filterItem.values, {Id: valueId});
        opt.Selected = !opt.Selected;
        this.forceUpdate();
    },

    render: function () {
        var values = this.props.filterItem.values;
        var disabledFieldCombo = (this.props.availableFields == null);

        return (
            <Popover className="filter-popover" direction="horizontal" nubbinMargin={12} onClickOutside={this.props.closeHandler}>
                <div className="slds-popover__body">
                    <div className="slds-p-around--small">
                        {disabledFieldCombo ?
                            <Input label={AppManager.getLabel("PC_LBL_FIELD") || 'Field'} type='text' disabled="true"
                                   value={ this.props.filterItem.label}/>
                            :
                            <Picklist label={AppManager.getLabel("PC_LBL_FIELD") || 'Field'}
                                      value={ this.props.filterItem.fieldId }
                                      onValueChange={ this.props.changeField }>
                                { this.props.availableFields.map((a, i) => {
                                    return <PicklistItem key={ i + 1 } value={a.fieldId} label={a.label}/>;
                                })}
                            </Picklist>
                        }
                        <Multiselection label={AppManager.getLabel("PC_LBL_VALUE") || 'Value'} required="false"
                                        className="slds-m-top--small"
                                        values={values}
                                        toggleHandler={this.toggleValue}/>
                        <section className="slds-clearfix slds-m-top--small">
                            <div className="slds-float--right">
                                <Button className="close-button slds-float--right" type="neutral"
                                        onClick={()=> this.props.closeHandler()}>{AppManager.getLabel("PP_BTN_DONE") || 'Done'}</Button>
                            </div>
                        </section>
                    </div>
                </div>
            </Popover>
        )
    }
});

/*************************************************************/

var CalendarFilterSection = React.createClass({
    displayName: 'CalendarFilterSection',

    getInitialState: function () {
        return {
            openedFilterItem: null,
            addingNewFilter: null
        }
    },

    getPlaceholder: function (values) {
        return _.map(_.filter(values, {Selected: true}), 'Label').join(', ');
    },

    emptyFilter: function (array) {
        array.map((item)=> {
            item.Selected = false;
        });
        this.props.modifiedHandler();
        this.forceUpdate();
    },

    addFilter: function (filtersToAdd) {
        this.setState({openedFilterItem: null, addingNewFilter: filtersToAdd[0]});
    },

    addNewFilter: function () {
        this.setState({openedFilterItem: null, addingNewFilter: null});
        this.props.modifiedHandler()
    },

    changeFieldNewFilter: function (fieldItem) {
        this.state.addingNewFilter.values.map(
            (val)=> {
                val.Selected = false;
            });
        this.setState({addingNewFilter: fieldItem});
    },

    openFilter: function (filterItem) {
        this.setState({openedFilterItem: filterItem});
    },

    closeFilter: function () {
        this.setState({openedFilterItem: null});
        this.props.modifiedHandler()
    },

    renderFilterItem: function (filterItem) {
        return <CalendarFilterItem filterItem={filterItem}
                                   closeHandler={this.closeFilter}/>
    },

    render: function () {
        var filtersAdded = _.filter(this.props.filterSection,
            function (item) {
                return _.some(item.values, {Selected: true})
            });

        var filtersToAdd = _.difference(this.props.filterSection, filtersAdded);
        var canAddNewFilter = (this.props.filterSection.length != filtersAdded.length) && !this.state.addingNewFilter;

        return (
            <section>
                <div className="filter-title">{this.props.title}</div>
                {filtersAdded.map((filterItem)=>
                        <RemovablePill
                            className={(filterItem == this.state.openedFilterItem )?"slds-m-top--medium tpm-open-pill":"slds-m-top--medium "}
                            closeHandler={()=>this.emptyFilter(filterItem.values)}
                            openHandler={()=>this.openFilter(filterItem)}
                            label={filterItem.label} value={this.getPlaceholder(filterItem.values)}
                            {...this.props}>
                            {(filterItem == this.state.openedFilterItem ) ? this.renderFilterItem(filterItem) : null}
                        </RemovablePill>
                )}
                {(this.state.addingNewFilter) ?
                    <RemovablePill className="slds-m-top--medium tpm-open-pill"
                                   closeHandler={()=>this.emptyFilter(this.state.addingNewFilter.values)}
                                   openHandler={()=>this.openFilter(this.state.addingNewFilter)}
                                   label='New Filter *' {...this.props}>
                        <CalendarFilterItem filterItem={this.state.addingNewFilter} availableFields={filtersToAdd}
                                            changeField={(fieldId)=> {
                                                this.changeFieldNewFilter(_.find(filtersToAdd, {fieldId: fieldId}))
                                            } }
                                            closeHandler={this.addNewFilter}/>

                    </RemovablePill>
                    : null}

                { (canAddNewFilter) ?
                    <Button icon="add" className="slds-m-top--small add-filter" onClick={()=> {
                        this.addFilter(filtersToAdd)
                    }}> {AppManager.getLabel('PC_BTN_ADD_FILTER') || 'Add filter'}</Button>
                    : null}
            </section>
        )
    }
});

/*************************************************************/

module.exports = React.createClass({
    displayName: 'CalendarFilter',

    getInitialState: function () {
        return ({modified: false})
    },

    render: function () {
        return (
            <div className="slds-col side-panel">
                {(this.state.modified) ?
                    <div className="side-panel-header slds-text-align--right slds-p-around--medium ">
                        <Button icon="close" type="neutral" iconAlign='left' className="icon-button"
                                onClick={this.props.closeHandler}> {AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'}</Button>
                        <Button icon="check" type="brand" iconAlign='left' className="icon-button"
                                onClick={this.props.saveHandler}> {AppManager.getLabel('PC_BTN_SAVE') || 'Save'}</Button>
                    </div>
                    :
                    <div className="side-panel-header slds-clearfix slds-p-around--small">
                        <div className="slds-float--left ">
                            <p>{AppManager.getLabel('PC_LBL_FILTERS') || 'Filters'}</p>
                        </div>
                        <div className="back-arrow">
                            <Button className="close-button" icon="forward" size="small"
                                    onClick={this.props.closeHandler}/>
                        </div>
                    </div>
                }
                <div className="side-panel-body">
                    <div className="slds-m-top--small calendar-filter">
                        <CalendarFilterSection title={AppManager.getLabel('PC_TIT_ACCOUNTS') || 'Accounts'}
                                               filterSection={this.props.calendar.FilterCriteria.accountfilter}
                                               modifiedHandler={()=> {
                                                   this.setState({modified: true})
                                               }}/>
                        <CalendarFilterSection title={AppManager.getLabel('PC_TIT_PROMOTIONS') || 'Promotions'}
                                               filterSection={this.props.calendar.FilterCriteria.promotionfilter}
                                               modifiedHandler={()=> {
                                                   this.setState({modified: true})
                                               }}/>
                        <CalendarFilterSection title={AppManager.getLabel('PC_TIT_PRODUCTS') || 'Products'}
                                               filterSection={this.props.calendar.FilterCriteria.productfilter}
                                               modifiedHandler={()=> {
                                                   this.setState({modified: true})
                                               }}/>
                    </div>
                </div>
            </div>
        )
    }
});
