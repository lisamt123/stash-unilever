"use strict";

var React = require('react');
var Icon = require('react-lightning-design-system').Icon;

var Truncate = require('../components/Truncate');

module.exports = React.createClass({
    render: function () {
        var icon = null;

        if (this.props.icon && this.props.icon.indexOf('.') == -1) {
            icon = <Icon category="standard" icon={this.props.icon} size="large" />
        }
        else {
            icon = <span className="slds-avatar">
                   <img src={Utils.HTTP.getImgUrl(this.props.icon)} alt="promo" />
            </span>
        }

        return (
            <div className="slds-page-header" role="banner">
                <div className="slds-media slds-media--center">
                    <div className="slds-media__figure">{icon}
                    </div>
                    <div className="slds-media__body">
                        <div className="slds-page-header__title slds-truncate slds-align-middle">
                            <Truncate lines={1}
                                      children={this.props.title}>
                            </Truncate>
                        </div>

                        <p className="slds-text-body--small slds-page-header__info">{this.props.subtitle} </p>
                    </div>
                </div>
            </div>
        );
    }
});
