"use strict";

var React = require('react');

var AppHeader = require('../components/AppHeader');
var SidePanel = require('../components/SidePanel');

var CalendarHeader = require('../promcalendar/CalendarHeader');
var PromotionCalendarGrid = require('../promCalendar/PromotionCalendarGrid');
var CalendarFilter = require('../promCalendar/CalendarFilter');
var InitCalendar = require('../promCalendar/InitCalendar');

var PromCalendarActions = require('../../actions/PromCalendarActions').PromCalendarActions;

module.exports = React.createClass({
    displayName: 'PromotionCalendar',

    getInitialState: function () {
        return {
            calendar: null,
            promotionDetailData: null,
            showFilter: false
        }
    },

    componentDidMount: function () {
        this.busHandlerID = UI_EVENT_BUS.subscribe(EVENTS.UI_BINDING, this.onUIBinding);
        window.addEventListener('resize', this.handleResize);
    },

    componentWillUnmount: function () {
        UI_EVENT_BUS.unsubscribe(this.busHandlerID);
        window.removeEventListener('resize', this.handleResize);
    },

    handleResize: function () {
        this.forceUpdate();
    },

    onUIBinding: function (payload) {
        this.setState(payload)
    },

    toggleFilter: function () {
        var me = this;
        PromCalendarActions.cancelChangeCalendarFilter();
        this.setState({showFilter: !this.state.showFilter}, ()=> {
                me.refs.CalendarGrid.forceUpdate();
            }
        );
    },

    saveFilter: function (filterData) {
        var me = this;
        PromCalendarActions.changeCalendarFilter(this.state.calendar.FilterCriteria);
        this.setState({showFilter: !this.state.showFilter}, ()=> {
                me.refs.CalendarGrid.forceUpdate();
            }
        );
    },

    addPromotion: function (promotion) {
        console.log('addPromotion...');
        PromCalendarActions.addPromotion(promotion);
    },

    saveSettingsHandler: function (filterData) {
        this.state.calendar.showInitialSettings = false;
        this.setState({calendar: this.state.calendar});
        PromCalendarActions.changeCalendarFilter(this.state.calendar.FilterCriteria);
    },

    cancelSettingsHandler: function () {
        this.state.calendar.showInitialSettings = false;
        this.setState({calendar: this.state.calendar});
        PromCalendarActions.changeCalendarFilter(null);
    },

    render: function () {

        return (
            <div className="mainSection promotionCalendar">
                {(this.state.calendar && this.state.calendar.showInitialSettings) ?
                    <InitCalendar calendar={this.state.calendar} saveHandler={this.saveSettingsHandler}
                                  cancelHandler={this.cancelSettingsHandler}/> : null}
                <CalendarHeader showFilter={this.state.showFilter} toggleFilter={this.toggleFilter}
                                addPromotion={this.addPromotion} calendar={this.state.calendar}/>
                <div className="vertical-flex">
                    <div className="slds-col slds-grid slds-grid--vertical-stretch">
                        <PromotionCalendarGrid ref="CalendarGrid" calendar={this.state.calendar}
                                               promotionDetailData={this.state.promotionDetailData}/>

                        {(this.state.showFilter) ? <CalendarFilter
                            calendar={this.state.calendar} closeHandler={this.toggleFilter}
                            saveHandler={()=>this.saveFilter()}/> : null}
                    </div>
                </div>
            </div>
        )
    }
});
