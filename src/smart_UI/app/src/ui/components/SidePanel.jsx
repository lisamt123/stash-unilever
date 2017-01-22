"use strict";

var React = require('react');
var Button = require('react-lightning-design-system').Button;

module.exports = React.createClass({
    render: function () {
        var klass = 'slds-col side-panel ' + (this.props.animated ? 'animated ' : '') + (this.props.invalid ? 'invalid' : '' );

        return (
            <div className={klass}>
                <div className="side-panel-header slds-clearfix slds-p-around--small slds-text-heading--medium">
                    <div className="slds-float--left ">
                        <p>{AppManager.getLabel("PC_LBL_FILTERS") || 'Filters'}</p>
                    </div>
                    <div className="slds-float--right">
                        <Button className="close-button" icon="forward" size="small" onClick={this.props.closeHandler}/>
                    </div>
                </div>
                <div className="side-panel-body">
                    {this.props.children}
                </div>
            </div>
        )
    }
});
