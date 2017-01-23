"use strict";

var React = require('react');
var Button = require('react-lightning-design-system').Button;

module.exports = React.createClass({

    render: function () {
        var klass = 'pill-panel slds-p-around--small ' + this.props.className;

        return (
            <div>
                {this.props.children}
                <div className={klass}>

                    <Button className="close-button slds-float--right" icon="close" iconSize="small"
                            onClick={()=> this.props.closeHandler()}/>

                    <div className="pill-body" onClick={()=> this.props.openHandler()}>
                        <div className="slds-text-body--small filter-label">{this.props.label}</div>
                        <div className=" filter-value">{this.props.value}</div>

                    </div>
                </div>
            </div>
        )
    }
});
