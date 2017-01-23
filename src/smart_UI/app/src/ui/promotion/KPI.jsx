"use strict";

var React = require('react');

module.exports = React.createClass({
    renderRow: function (title) {
        return (
            <tr>
                <td className="mainTitle">{title}</td>
                <td>75,248.00</td>
                <td>18,245.00</td>
                <td>15,425.11</td>
                <td>44,145.22</td>
                <td>7,021.11</td>
            </tr>
        )
    },

    renderHeader: function () {
        return (
            <thead>
            <tr className="header">
                <td className="text-left">{AppManager.getLabel('PP_TIT_MEASURE') || 'Measure'}Measure</td>
                <td>Total</td>
                <td>CW 21</td>
                <td>CW 22</td>
                <td>CW 23</td>
                <td>CW 24</td>
            </tr>
            </thead>
        )
    },

    render: function () {
        return (
            <div className="kpi-tile">
                <div className="title">{AppManager.getLabel('PP_TIT_KPI') || 'KPIs'}</div>
                <table>
                    {this.renderHeader()}
                    <tbody>
                    {this.renderRow('Baseline Volume')}
                    {this.renderRow('Incr.Lift Predicted')}
                    {this.renderRow('Incr.Lift Override')}
                    {this.renderRow('Incr.Lift Effective')}
                    {this.renderRow('Forw.Buy Predicted')}
                    {this.renderRow('Forw.Buy Override')}
                    {this.renderRow('Forw.Lift Effective')}
                    {this.renderRow('Total.Lift Effective')}
                    </tbody>
                </table>
            </div>
        )
    }
});
