"use strict";

var React = require('react');
var Chartist = require('chartist');

module.exports = React.createClass({
    componentDidMount: function () {
        this.updateChart(this.props.data);
    },

    updateChart: function (data) {
        var options = {
            axisX: {
                showLabel: true,
                showGrid: false
            },
            showPoint: false,
            lineSmooth: false,
            fullWidth: true,
            stackBars: true,
            height: '245px',
            chartPadding: {
                top: 15,
                right: 15,
                bottom: 5,
                left: 10
            }
        };
        var chart = new Chartist.Bar('.stackedchart', data, options);

        chart.on('draw', function (data) {
            if (data.type === 'bar') {
                data.element.animate({
                    y2: {
                        begin: 200 * data.index,
                        dur: 1000,
                        from: data.y1,
                        to: data.y2,
                        easing: Chartist.Svg.Easing.easeOutQuint
                    }
                });
            }
        });
        return chart;
    },

    render: function () {
        return (
            <div className="chart-tile">
                <div className="title">{this.props.title}</div>
                <div className="stackedchart"></div>
                <div className="legend">
                    <div className="legendItem">
                        <div className="ct-series-a legend-box"></div>
                        {this.props.data.legends[0]}</div>
                    <div className="legendItem">
                        <div className="ct-series-b legend-box"></div>
                        {this.props.data.legends[1]}</div>
                    <div className="legendItem">
                        <div className="ct-series-c legend-box"></div>
                        {this.props.data.legends[2]}</div>
                </div>
            </div>
        )
    }
});
