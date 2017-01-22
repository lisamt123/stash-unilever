"use strict";

var React = require('react');

var classNames = require('classnames');

module.exports = React.createClass({
    displayName: 'Popover',

    getInitialState: function () {
        return {
            top: 0,
            left: 0,
            parent: {
                top: 0,
                left: 0,
                width: 0,
                height: 0
            },
            container: {
                width: 0,
                height: 0
            }
        }
    },

    componentDidMount: function () {
        if (this.props.onClickOutside) {
            document.addEventListener("click", this.outsideClickHandler);
        }

        this.setPopoverPosition();
    },

    componentDidUpdate: function () {
        this.setPopoverPosition();
    },

    setPopoverPosition: function () {
        var parentElement = (this.props.parent) ? ReactDOM.findDOMNode(this.props.parent) : ReactDOM.findDOMNode(this).parentNode;
        var parent = parentElement.getBoundingClientRect();
        var container = this.refs.container.getBoundingClientRect();
        var backgroundColor = this.props.backgroundColor || {};
        var nubbinSize = this.props.nubbinMargin || 0;

        const nubbinCornerTop = 37;
        const nubbinCornerBottom = 40;
        const nubbinCornerHorizontal = 33;
        const exceedsTop = parent.top + parent.height / 2 < container.height / 2;
        const exceedsBottom = parent.top + parent.height / 2 + container.height / 2 > window.innerHeight;
        const exceedsLeft = parent.left + parent.width / 2 < container.width / 2;
        const exceedsRight = parent.left + parent.width / 2 + container.width / 2 > window.innerWidth;

        if (this.shouldPopoverUpdate(parent, container)) {
            var position = null;
            if (this.props.direction === 'horizontal') {
                // if popover exceeds bottom side of the screen, change position to top
                if (exceedsBottom) {
                    if (exceedsLeft) {
                        position = "right-top";
                    }
                    else if (exceedsRight) {
                        position = "left-top";
                    }
                    else {
                        position = "top";
                    }
                }
                // if popover exceeds top side of the screen, change position to bottom
                else if (exceedsTop) {
                    if (exceedsLeft) {
                        position = "right-bottom";
                    }
                    else if (exceedsRight) {
                        position = "left-bottom";
                    }
                    else {
                        position = "bottom";
                    }
                }
                else if (parent.left > window.innerWidth / 2) {
                    position = "left";
                }
                else {
                    position = "right";
                }
            }
            else if (this.props.direction === 'vertical') {
                // if popover exceeds right side of the screen, change position to left
                if (exceedsRight) {
                    if (exceedsTop) {
                        position = "bottom-left";
                    }
                    else if (exceedsBottom) {
                        position = "top-left";
                    }
                    else {
                        position = "left";
                    }
                }
                // if popover exceeds left side of the screen, change position to left
                else if (exceedsLeft) {
                    if (exceedsTop) {
                        position = "bottom-right";
                    }
                    else if (exceedsBottom) {
                        position = "top-right";
                    }
                    else {
                        position = "right";
                    }
                }
                else if (parent.top > window.innerHeight / 2) {
                    position = "top";
                }
                else {
                    position = "bottom";
                }
            }

            switch (position) {
                case "top":
                    this.setState({
                        position: "top",
                        top: parent.top - (container.height + nubbinSize),
                        left: (parent.left + parent.width / 2) - (container.width / 2),
                        color: backgroundColor.top
                    });
                    break;
                case "top-left":
                    this.setState({
                        position: "top-left",
                        top: parent.top - (container.height + nubbinSize),
                        left: (parent.left + parent.width / 2 + nubbinCornerHorizontal) - container.width,
                        color: backgroundColor.top
                    });
                    break;
                case "top-right":
                    this.setState({
                        position: "top-right",
                        top: parent.top - (container.height + nubbinSize),
                        left: parent.left + parent.width / 2 - nubbinCornerHorizontal,
                        color: backgroundColor.top
                    });
                    break;
                case "bottom":
                    this.setState({
                        position: "bottom",
                        top: parent.top + parent.height + nubbinSize,
                        left: (parent.left + parent.width / 2) - (container.width / 2),
                        color: backgroundColor.bottom
                    });
                    break;
                case "bottom-left":
                    this.setState({
                        position: "bottom-left",
                        top: parent.top + parent.height + nubbinSize,
                        left: (parent.left + parent.width / 2 + nubbinCornerHorizontal) - container.width,
                        color: backgroundColor.bottom
                    });
                    break;
                case "bottom-right":
                    this.setState({
                        position: "bottom-right",
                        top: parent.top + parent.height + nubbinSize,
                        left: parent.left + parent.width / 2 - nubbinCornerHorizontal,
                        color: backgroundColor.bottom
                    });
                    break;
                case "left":
                    this.setState({
                        position: "left",
                        top: (parent.top + parent.height / 2) - (container.height / 2),
                        left: (parent.left) - (container.width + nubbinSize),
                        color: backgroundColor.left
                    });
                    break;
                case "left-bottom":
                    this.setState({
                        position: "left-bottom",
                        top: parent.top + parent.height / 2 - nubbinCornerTop,
                        left: (parent.left) - (container.width + nubbinSize),
                        color: backgroundColor.left
                    });
                    break;
                case "left-top":
                    this.setState({
                        position: "left-top",
                        top: (parent.top + parent.height / 2 + nubbinCornerBottom) - container.height,
                        left: (parent.left) - (container.width + nubbinSize),
                        color: backgroundColor.left
                    });
                    break;
                case "right":
                    this.setState({
                        position: "right",
                        top: (parent.top + parent.height / 2) - (container.height / 2),
                        left: parent.left + parent.width + nubbinSize,
                        color: backgroundColor.right
                    });
                    break;
                case "right-bottom":
                    this.setState({
                        position: "right-bottom",
                        top: parent.top + parent.height / 2 - nubbinCornerTop,
                        left: parent.left + parent.width + nubbinSize,
                        color: backgroundColor.right
                    });
                    break;
                case "right-top":
                    this.setState({
                        position: "right-top",
                        top: (parent.top + parent.height / 2 + nubbinCornerBottom) - container.height,
                        left: parent.left + parent.width + nubbinSize,
                        color: backgroundColor.right
                    });
                    break;
            }
        }
    },

    shouldPopoverUpdate: function (nextParent, nextContainer) {
        var parent = this.state.parent;
        var container = this.state.container;
        var update = false;

        if (parent.top !== nextParent.top ||
            parent.left !== nextParent.left ||
            parent.height !== nextParent.height ||
            parent.width !== nextParent.width) {
            this.setState({
                parent: {
                    top: nextParent.top,
                    left: nextParent.left,
                    width: nextParent.width,
                    height: nextParent.height
                }
            });
            update = true;
        }

        if (container.height !== nextContainer.height ||
            container.width !== nextContainer.width) {
            this.setState({
                container: {
                    width: nextContainer.width,
                    height: nextContainer.height
                }
            });
            update = true;
        }

        return update;
    },

    componentWillUnmount: function () {
        if (this.props.onClickOutside) {
            document.removeEventListener("click", this.outsideClickHandler);
        }
    },

    outsideClickHandler: function (event) {
        const container = ReactDOM.findDOMNode(this.refs.container);

        if (!container.contains(event.target)) {
            this.props.onClickOutside();
        }
    },

    render: function () {
        var stylePopover = {
            position: 'fixed',
            top: this.state.top,
            left: this.state.left,
            background: this.state.color
        };

        var style = _.assign(stylePopover, this.props.style);

        var popoverClass = classNames({
            'slds-popover': true,
            'slds-popover--panel': true,
            'slds-nubbin--top': this.state.position === 'bottom',
            'slds-nubbin--top-right': this.state.position === 'bottom-left',
            'slds-nubbin--top-left': this.state.position === 'bottom-right',
            'slds-nubbin--right': this.state.position === 'left',
            'slds-nubbin--right-top': this.state.position === 'left-bottom',
            'slds-nubbin--right-bottom': this.state.position === 'left-top',
            'slds-nubbin--bottom': this.state.position === 'top',
            'slds-nubbin--bottom-right': this.state.position === 'top-left',
            'slds-nubbin--bottom-left': this.state.position === 'top-right',
            'slds-nubbin--left': this.state.position === 'right',
            'slds-nubbin--left-top': this.state.position === 'right-bottom',
            'slds-nubbin--left-bottom': this.state.position === 'right-top'
        }, this.props.className);

        return (<div className={popoverClass} role="dialog" ref="container" style={style}>
                {this.props.children}
            </div>
        )
    }
});

