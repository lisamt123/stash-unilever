"use strict";

var React = require('react');

module.exports = React.createClass({
    renderEmpty: function () {
        return (
            <div className="chart-tile empty-chart">
                <div className="title">{this.props.title}</div>
                <div className="main-value">{this.props.formatter(0)}</div>
                <div className="sub-value">{this.props.formatter(0)}</div>
                <div className="horizontal-chart">
                    <div className="back-chart">Sorry, no data available yet</div>
                </div>
            </div>
        )
    },
    render: function () {
        if (this.props.mainvalue == null) return this.renderEmpty();

        var classChart = "chart-tile";
        var sign = (this.props.positiveKPI) ? '+' : '-';
        var diff = Math.floor(Math.abs(this.props.mainvalue - this.props.planned) * 100) / 100;

        var pctWidth = Math.abs((1 - diff / this.props.mainvalue) * 100);
        var labelStyle = {left: pctWidth + '%', textAlign: 'right'};

        if (pctWidth > 80) {
            labelStyle = {left: 'auto', right: 0};
        }

        if (pctWidth < 10) {
            labelStyle = {left: '10%', textAlign: 'right'};
        }

        if (this.props.positiveKPI) {//ROI
            if (this.props.mainvalue < this.props.planned) {//negative.aligning to the right
                classChart += ' negative';
                sign = (this.props.positiveKPI) ? '-' : '+';
                labelStyle = {left: 'auto', right: 0};
            }
        } else {//COST
            if (this.props.mainvalue > this.props.planned) {//negative.aligning to the right
                classChart += ' negative';
                sign = (this.props.positiveKPI) ? '-' : '+';
            } else {//positive.align to the left side of the ROI bar
                labelStyle = {left: 'auto', right: 0};
            }
        }

        return (
            <div className={classChart}>
                <div className="title">{this.props.title}</div>
                <div className="main-value">{this.props.formatter(this.props.mainvalue)}</div>
                <div className="sub-value">{sign}{this.props.formatter(diff)}</div>
                <div className="horizontal-chart">
                    <div className="back-chart"></div>
                    <div className="front-chart" style={{width: pctWidth + '%'}}></div>
                    <div className="legend">
                        <span className="val initial">{this.props.formatter(0)}</span>
                        <span className="val final"
                              style={labelStyle}>{AppManager.getLabel('PP_LBL_PLANNED') || 'Planned'} {this.props.formatter(this.props.planned)}</span>
                    </div>
                </div>
            </div>
        )
    }
});
