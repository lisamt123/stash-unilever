"use strict";

var React = require('react');


module.exports = React.createClass({
    render: function () {
        var acl = this.props.object._acl;
        var isVisible = true;
        if (acl)
            isVisible= acl.isVisible(1, this.props.field);
        return (
           (isVisible)?this.props.children:null
               
        )
    }
});