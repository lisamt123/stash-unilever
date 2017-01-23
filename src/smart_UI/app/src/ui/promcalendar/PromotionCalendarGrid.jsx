"use strict";

var React = require('react');
var PromotionDetail = require('./PromotionDetail');
var classNames = require('classnames');
var Button = require('react-lightning-design-system').Button;

var PromCalendarActions = require('../../actions/PromCalendarActions').PromCalendarActions;

var Popover = require('../components/Popover');
var Truncate = require('../components/Truncate');

var PromotionCalendarLabel = React.createClass({
    displayName: 'PromotionCalendarLabel',

    getInitialState: function () {
        return {
            isTruncated: false,
            hover: false
        }
    },

    render: function () {
        return (
            <statelessWrapper>
                <div className='label-column slds-text-heading--small'
                     onMouseEnter={(e)=>this.setState({hover: true})}
                     onMouseLeave={(e)=>this.setState({hover: false})}>
                    <div className="slds-truncate slogan-text">
                        <Truncate lines={2}
                                  onTruncate={(isTruncated) => {
                            isTruncated !== this.state.isTruncated && this.setState({isTruncated})
                        }}
                                  children={this.props.slogan}>
                        </Truncate>
                    </div>
                </div>
              {
              (this.state.hover && this.state.isTruncated) ?
                        <Popover direction="horizontal" className="slogan-tooltip">{this.props.slogan}</Popover> : null
              }
            </statelessWrapper>
        );

    }

});

module.exports = React.createClass({
    displayName: 'PromotionCalendarGrid',

    getInitialState: function () {
        return {
            promotionDetailPopOver: null,
            showWeeks: true,
            initialLegendContent: null
        }
    },

    componentDidMount: function () {
        //this.handleResize();
        window.addEventListener('resize', this.handleResize);
        this.handleLegendScroll();
    },

    componentDidUpdate: function () {
        var me = this;
        var weeks = _.flatMap(_.uniqBy(this.props.calendar.periods, 'Child'));
        var weekWidth = this.refs.months.getBoundingClientRect().width / weeks.length;
        if (this.state.showWeeks && weekWidth < 18) {
            this.setState({
                showWeeks: false
            });
        }
        else if (!this.state.showWeeks && weekWidth > 18) {
            this.setState({
                showWeeks: true
            });
        }
        for (var i = 0; i < this.refs.months.children.length; i++) {
            var monthDOM = this.refs.months.children[i];
            if (monthDOM.innerText.length && monthDOM.scrollWidth > monthDOM.clientWidth) {
                //OVERFLOW!
                //Solution 1: clip text
                monthDOM.innerText = monthDOM.innerText.substring(0, Math.floor(monthDOM.clientWidth / 18));
                //Solution 2: apply css class
                //if (monthDOM.className.indexOf('overflowMonth')==-1)
                //    monthDOM.className+=' overflowMonth';

            }
        }
        this.handleLegendScroll();
    },

    componentWillUnmount: function () {
        window.removeEventListener('resize', this.handleResize);
    },

    handleResize: function () {
        this.forceUpdate();
    },

    onPreviousPeriod: function () {
        PromCalendarActions.prevPeriod();
    },

    onNextPeriod: function () {
        PromCalendarActions.nextPeriod();
    },

    renderPastTime: function () {
        var today = new Date();
        var width = this.getLeft(today - this.props.calendar.initDate);
        if (width < 0) return null;
        if (width > this.getTotalWidth()) width = this.getTotalWidth();
        var height = this.getCalendarHeight();
        return (
            <div className="past-time" style={{width: width + 'px', height: '100%'}}></div>
        )
    },

    renderYearLine: function () {
        if (this.props.calendar.endDate.getFullYear() != this.props.calendar.initDate.getFullYear()) {
            var l = this.getLeft(new Date(this.props.calendar.endDate.getFullYear(), 0, 0) - this.props.calendar.initDate);
            l += 154;// Width of the first column
            var height = this.getCalendarHeight();
            return (
                <div className="past-time year-line"
                     style={{left: l + 'px', width: '2px', height: '100%'}}></div>
            )
        }
    },

    getWeeks: function () {
        var today = (new Date()).getTime();
        return _.flatMap(_.uniqBy(this.props.calendar.periods, 'Child'), function (i) {
            var padded = '0' + i.Child;
            return {
                Week: (padded.substring(padded.length - 2)),
                Month: i.Parent,
                Current: ((i.Date_From) < today && (today < i.Date_Thru))
            }
        });
    },

    renderHeader: function () {
        var weeks = this.getWeeks();
        var colHeight = this.getCalendarHeight();
        var lastMonth = '';
        return (
            <div className='slds-grid slds-grid--vertical-stretch calendarGrid-columns'>
                <div className='label-column ' ref="colName"></div>
              {
              weeks.map((w, i)=> {
              var colClass = classNames({
              'slds-col': true,
              'col-odd': i % 2 == 0,
              'col-even': i % 2 != 0,
              'month-week': i > 0 && lastMonth != w.Month
              });
              lastMonth = w.Month;
              return (<div className={colClass} style={{height: '100%'}}></div>)
              })
              }
            </div>
        )
    },

    renderMonths: function () {
        var weeks = this.getWeeks();
        var lastMonth = '';

        return (
            <div className='slds-grid calendarGrid-months'>
                <div className='label-column'>

                </div>
                <div className="calendar-months" ref="months">

                    <div className='prev-period'>
                        <Button icon='chevronleft' onClick={()=>this.onPreviousPeriod()} />
                    </div>
                  {
                  weeks.map((w)=> {
                  var m = (window.innerWidth < 1280) ? w.Month.substring(0, 3) : w.Month;
                  var colSpan = 1;
                  var current = '';
                  var currentWeek = _.find(weeks, {Current: true});
                  var currentMonth = (currentWeek) ? currentWeek.Month : '';
                  if (m != lastMonth) {
                  lastMonth = m;
                  colSpan = _.filter(weeks, {Month: w.Month}).length;
                  current = (currentMonth == w.Month) ? 'month-current' : '';
                  } else {
                  return null;
                  }
                  return <div style={{flex: colSpan}}
                              className={"slds-text-align--center " + current }>{m}</div>
                  })
                  }

                    <div className='next-period'>
                        <Button icon='chevronright' onClick={()=>this.onNextPeriod()} />
                    </div>
                </div>
            </div>
        )
    },

    renderWeeks: function () {
        var weeks = this.getWeeks();

        return (
            <div className="slds-grid slds-grid--vertical-stretch calendar-weeks">
                <div className='label-column'></div>
              {
              weeks.map((w, i)=> {
              return (
                            <div className='slds-col slds-text-align--center'>{w.Week}</div>
              )
              })
              }
            </div>
        )
    },

    toPreviousLegend: function () {
        var legendContent = this.refs.calendarlegendcontent,
            firstChild = legendContent.firstChild.cloneNode(true);
        if (!this.state.initialLegendContent) {
            this.state.initialLegendContent = legendContent.innerHTML;
        }
        legendContent.removeChild(legendContent.firstChild);
        legendContent.appendChild(firstChild);
    },

    toNextLegend: function () {
        var legendContent = this.refs.calendarlegendcontent,
            lastChild = legendContent.lastChild.cloneNode(true);
        if (!this.state.initialLegendContent) {
            this.state.initialLegendContent = legendContent.innerHTML;
        }
        legendContent.removeChild(legendContent.lastChild);
        legendContent.insertBefore(lastChild, legendContent.firstChild);
    },

    handleLegendScroll: function () {
        if (this.refs.calendarlegendcontent) {
            var legend = this.refs.calendarlegend,
                scrollLeft = legend.querySelector('.scroll-left'),
                scrollRight = legend.querySelector('.scroll-right'),
                legendContent = this.refs.calendarlegendcontent,
                legendContentWidth = legendContent.clientWidth,
                legendsWidth = 0,
                nodes = legendContent.querySelectorAll('.calendar-legend-text');
            for (var i = 0; nodes[i]; i++) {
                legendsWidth += nodes[i].clientWidth + 16;
            }
            if (legendContentWidth <= legendsWidth) {
                scrollLeft.style.display = 'flex';
                scrollRight.style.display = 'flex';
            } else if (scrollLeft.style.display != 'none' && scrollRight.style.display != 'none') {
                scrollLeft.style.display = 'none';
                scrollRight.style.display = 'none';
                if (this.state.initialLegendContent)
                 this.restoreLegend();
            }
        }
    },

    restoreLegend: function () {
        this.refs.calendarlegendcontent.innerHTML = this.state.initialLegendContent;
    },

    renderLegend: function () {
        return (
            <div className='slds-grid calendar-legend' ref="calendarlegend">
                <div className='label-column'></div>
                <div className='scroll-left'>
                    <Button icon='chevronleft' onClick={()=>this.toPreviousLegend()} />
                </div>
                <div className='calendar-legend-content' ref="calendarlegendcontent">
                  {
                  this.props.calendar.legend.map((l, i)=> {
                  return (
                                <div className='calendar-legend-text'>
                                    <div className='calendar-legend-circle'
                                         style={{backgroundColor: l.Commit_Color.replace('0x', '#')}}></div>{l.Name}
                                </div>
                  )
                  })
                  }
                </div>
                <div className='scroll-right'>
                    <Button icon='chevronright' onClick={()=>this.toNextLegend()} />
                </div>
            </div>
        );
    },

    getBgColor: function (promotion) {
        return promotion.Commit_Color.replace('0x', '#');
    },

    getOpacity: function (promotion) {
        return (promotion.isReady) ? 1 : 0.3;
    },

    getLeft: function (date) {
        var DAY = (1000 * 60 * 60 * 24);
        var days = date / DAY;
        var totalWidth = this.getTotalWidth();

        var totalDays = Math.floor((this.props.calendar.endDate - this.props.calendar.initDate) / DAY);

        return Math.round(days * totalWidth / totalDays);
    },

    getTotalWidth: function () {
        var calendarGrid = this.refs.calendarscrollarea;
        if (this.refs['colName']) {
            var firstCol = this.refs.colName;
            return calendarGrid.clientWidth - firstCol.clientWidth;
        }
        else {
            calendarGrid = this.refs.calendarcontainer;
            return calendarGrid.clientWidth - 164;
        }
    },

    getCalendarHeight: function () {
        var weekHeaderHeight = 22;
        var calendarRowHeight = 40;
        return weekHeaderHeight + this.props.calendar.promotions.length * calendarRowHeight;
    },

    getPromotionTemplate: function(promotionTemplateId){
        var promotionTemplate= _.filter(this.props.calendar.promotion_templates,(promotionTemplate)=>promotionTemplate.Id==promotionTemplateId);
        return promotionTemplate[0].Label;
    },

    renderPromotion: function (promotion) {
        var me = this,
            bgColor = this.getBgColor(promotion),
            previousWidth = 0;

        var promotion_template = this.getPromotionTemplate(promotion.Promotion_Template_Id);

        return (
            <div className='slds-grid promotion-row'>
                <PromotionCalendarLabel slogan={promotion.slogan} />
              {
              promotion.dates.map((period, i)=> {
              var width = me.getLeft(period.to - period.from),
              left = me.getLeft(period.from - me.props.calendar.initDate);
              if (i > 0) {
              previousWidth += width;
              left -= previousWidth;
              }
              if (left < 0) {
              width += left;
              left = 0;
              }
              if (width < 0) {
              return null;
              }
              if (width > this.getTotalWidth() - left) {
              width = this.getTotalWidth() - left;
              }

              var opacity = this.getOpacity(period);

              var showDetail = ((this.state.promotionDetailPopOver != null)
              && (this.state.promotionDetailPopOver.promotion.slogan == promotion.slogan)
              && (this.state.promotionDetailPopOver.period.from == period.from));
              var detailPanel = null;
              var border = 'none';
              if (showDetail) {
              detailPanel =
                                <PromotionDetail promotionDetail={this.state.promotionDetailPopOver}
                                                 icon="promo.png" {...this.props} />;
              opacity = 1;
              border = '2px solid rgba(0,0,0,0.3)';
              }

              return (
                            <div className='promotion-bar'
                                 style={{
                                     backgroundColor: bgColor,
                                     opacity: opacity,
                                     width: width + 'px',
                                     left: left + 'px',
                                     border: border
                                 }}
                                 onMouseEnter={(e)=>this.showPromotionDetail(e, promotion, period, promotion_template)}
                                 onMouseLeave={(e)=>this.hidePromotionDetail(e, promotion, period)}
                                 onClick={(e)=> {
                                     if (e.target.className == 'promotion-bar')
                                         PromCalendarActions.openPromotionDetail(period.Id);
                                 } }>{detailPanel}
                            </div>
              )
              })
              }
            </div>
        )
    },

    showPromotionDetail: function (event, promotion, period, promotion_template) {
        var self = this;
        var calendarGrid = this.refs.calendarcontainer;
        var promotionDetailPopOver = {
            promotion: promotion,
            period: period,
            promotion_template: promotion_template
        };
        this.timer = window.setTimeout(
            ()=> {
                self.setState({promotionDetailPopOver: promotionDetailPopOver});
            },
            300
        );
        window.clearTimeout(this.timerHide);
    },

    hidePromotionDetail: function (event, promotion, period) {
        var self = this;
        window.clearTimeout(this.timer);
        this.timerHide = window.setTimeout(
            ()=> {
                self.setState({promotionDetailPopOver: null});
            },
            300
        );
    },

    render: function () {
        var me = this;
        return (
            <div className="calendarGrid" ref="calendarcontainer">
              {(this.props.calendar == null) ?
                    <div className="slds-grid slds-grid--vertical-align-center slds-grid--align-center loading-container">
                        <div className="slds-spinner_container">
                            <div className="slds-spinner--brand slds-spinner slds-spinner--large" aria-hidden="false"
                                 role="alert">
                                <div className="slds-spinner__dot-a"></div>
                                <div className="slds-spinner__dot-b"></div>
                            </div>
                        </div>
                        <div className="loading-content">
                          'Loading content...'
                        </div>
                    </div>
              :
                    <div>{this.renderMonths()}
                        <div className="slds-grid calendarGrid-container">{this.renderHeader()}{this.renderPastTime()}
                            <div className="calendarGrid-content">{(this.state.showWeeks) ? this.renderWeeks() : null}
                                <div className="slds-scrollable--y" ref="calendarscrollarea">{this.props.calendar.promotions.map((p)=>me.renderPromotion(p))}
                                </div>
                            </div>{this.renderYearLine()}
                        </div>{this.renderLegend()}
                    </div>
              }
            </div>
        )
    }
});
