"use strict";

var React = require('react');
var Icon = require('react-lightning-design-system').Icon;

module.exports = React.createClass({
    render: function () {
        var klass = 'tile ' + (this.props.animated ? 'animated ' : '') + (this.props.invalid ? 'invalid' : '' );

        return (
            <div key='tile' className={klass}>
                {(this.props.invalid) ?
                    <div className='mask'>
                        <Icon category='utility' icon='undo' size='x-medium' className='slds-align--absolute-center'/>
                    </div> : null}
                {this.props.children}
            </div>
        )
    }
});
