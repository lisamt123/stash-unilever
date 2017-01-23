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
            height: '245px',
            chartPadding: {
                top: 15,
                right: 15,
                bottom: 5,
                left: 10
            }
        };

        var chart = new Chartist.Line('.linechart', data, options);
        chart.on('draw', function (data) {
            if (data.type === 'line' || data.type === 'area') {
                data.element.animate({
                    d: {
                        begin: 500 * data.index,
                        dur: 1000,
                        from: data.path.clone().scale(1, 0).translate(0, data.chartRect.height()).stringify(),
                        to: data.path.clone().stringify(),
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
                <div className="linechart"></div>
                <div className="legend">
                    <div className="legendItem">
                        <div className="ct-series-a legend-box"></div>
                        {this.props.data.legends[0]}</div>
                    <div className="legendItem">
                        <div className="ct-series-b legend-box"></div>
                        {this.props.data.legends[1]}</div>
                </div>
            </div>
        )
    }
});
