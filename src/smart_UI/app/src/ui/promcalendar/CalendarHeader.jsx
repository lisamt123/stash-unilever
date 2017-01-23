"use strict";

var React = require('react');

var ButtonGroup = require('react-lightning-design-system').ButtonGroup;
var Button = require('react-lightning-design-system').Button;
var DropdownButton = require('react-lightning-design-system').DropdownButton;
var MenuItem = require('react-lightning-design-system').MenuItem;
var Icon = require('react-lightning-design-system').Icon;

var PromCalendarActions = require('../../actions/PromCalendarActions').PromCalendarActions;
var Popover = require('../components/Popover');

var NewPromotion = require('./NewPromotion');

module.exports = React.createClass({
    displayName: 'CalendarHeader',

    getInitialState: function () {
        return {showNewPromotion: false}
    },

    showNewPromotion: function () {
        this.setState({showNewPromotion: true})
    },

    cancelNewPromotion: function () {
        this.setState({showNewPromotion: false})
    },

    saveNewPromotion: function (promotion) {
        this.setState({showNewPromotion: false});
        this.props.addPromotion(promotion);
    },


    render: function () {
        var filterIcon = 'Filter' + ((this.props.calendar && this.props.calendar.isFilterSet) ? '-set' : '') + ((this.props.showFilter) ? '_active' : '') + '.png';
        return (
            <div className="slds-grid slds-page-header">
                <div className="slds-col">
                    <div className="slds-media slds-media--center">
                        <div className="slds-media__figure">

                            <img src={Utils.HTTP.getImgUrl('Icon_Calendar.png')}/>
                        </div>

                        <div className="slds-media__body">
                            <p className="slds-text-heading--medium ">Trade Calendar</p>
                        </div>
                    </div>
                </div>

                <div className="slds-col"></div>

                <div className="slds-col header-buttons">
                    <Button type={this.props.showFilter?'brand':'neutral'}
                            onClick={()=>this.props.toggleFilter()}><img
                        src={Utils.HTTP.getImgUrl(filterIcon)}/></Button>

                    <Button type={this.state.showNewPromotion?'brand':'neutral'} ref="new-promotion" icon='add'
                            iconAlign='left' iconMore='' label='New '
                            onClick={()=>this.showNewPromotion()} className="new-button"/>
                    {(!this.state.showNewPromotion) ? null :
                        <Popover parent={this.refs["new-promotion"]} direction="vertical" nubbinMargin={12}
                                 onClickOutside={this.cancelNewPromotion}>
                            <NewPromotion
                                cancelHandler={this.cancelNewPromotion} saveHandler={this.saveNewPromotion}
                                calendar={this.props.calendar}/>
                        </Popover>}
                </div>
            </div>
        )
    }
});
