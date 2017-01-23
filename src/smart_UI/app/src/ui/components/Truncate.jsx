"use strict";

var React = require('react');
var Truncate = require('react-truncate');

module.exports = React.createClass({

    getInitialState: function () {
        return {
            truncate: false
        }
    },

    componentDidMount: function () {
        const canvas = document.createElement('canvas');
        this.canvas = canvas.getContext('2d');

        const style = window.getComputedStyle(this.refs.container);

        const font = [
            style['font-weight'],
            style['font-style'],
            style['font-size'],
            style['font-family']
        ].join(' ');

        this.canvas.font = font;

        this.checkWidth(this.props.children);

        window.addEventListener('resize', this.onResize);
    },

    componentWillUnmount: function () {
        window.removeEventListener('resize', this.onResize);
    },

    onResize: function () {
        this.checkWidth(this.props.children);
    },

    checkWidth: function (text) {
        const textWidth = this.canvas.measureText(text).width;

        var parentNode = this.refs.container.parentNode; //span - not truncated
        if (!parentNode) {
            parentNode = this.refs.container.refs.target.parentNode; //truncate component
        }

        const targetWidth = parentNode.getBoundingClientRect().width;

        this.setState({
            truncate: textWidth !== targetWidth
        });
    },

    componentDidUpdate(prevProps) {
        if (this.props.children !== prevProps.children) {
            this.checkWidth(this.props.children);
        }
    },

    render: function () {
        if (this.state.truncate)
            return (
                <Truncate ref="container" lines={this.props.lines}
                          onTruncate={this.props.onTruncate}
                          children={this.props.children}>
                </Truncate>);
        else
            return <span ref='container'>{this.props.children}</span>;

    }
});
