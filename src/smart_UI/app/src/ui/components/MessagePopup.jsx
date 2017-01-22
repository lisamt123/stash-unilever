"use strict";

var React = require('react');

module.exports = React.createClass({
    displayName: 'MessagePopup',

    componentDidMount: function () {
    },

    render: function () {
        var message = this.props.message;

        if(this.props.messagejson != ''){
            var jsonTable = '';
            var jsonVar = [];
            var jsonParsed = JSON.parse(this.props.messagejson);
            for(var x in jsonParsed){ jsonVar.push(jsonParsed[x]); }
            
            jsonTable += '<div class="bPageBlock brandSecondaryBrd apexDefaultPageBlock secondaryPalette">';
            jsonTable += '<div class="pbBody">';
            jsonTable += '<table border="0" cellpadding="0" cellspacing="0" class="list">';
            jsonTable += '<colgroup span="'+(jsonVar.length)+'"></colgroup>';
            jsonTable += '<thead class="">';
            jsonTable += '<tr class="headerRow">';
            for (var key in jsonVar[0]) {
                jsonTable += '<th class="headerRow" style="text-transform: capitalize;" scope="col" colspan="1">'+key+'</th>';
            }
            jsonTable += '<tr></thead>';

            jsonTable += '<tbody>';
            for (var i = 0; i < jsonVar.length-1; i++){
                jsonTable += '<tr class=" dataRow odd " onmouseover="if (window.hiOn){hiOn(this);} " onmouseout="if (window.hiOff){hiOff(this);} " onblur="if (window.hiOff){hiOff(this);}" onfocus="if (window.hiOn){hiOn(this);}">';
                for (var key in jsonVar[i]) {
                    jsonTable += '<td class="dataCell" colspan="1">'+jsonVar[i][key]+'</td>';
                }
                jsonTable += '<tr>';
            }
            jsonTable += '</tbody>';
            jsonTable += '</table>';
            jsonTable += '</div>';
            jsonTable += '</div>';
            message += jsonTable;
        }

        return (
            <div>
                <div aria-hidden="false" aria-labelledby="prompt-heading-id" aria-describedby="prompt-message-wrapper"
                     role="alertdialog" className="slds-modal slds-modal--prompt slds-fade-in-open">
                    <div className="slds-modal__container slds-modal--prompt" role="document"
                         id="prompt-message-wrapper" tabIndex="0">
                        <div className="slds-modal__header slds-theme--warning slds-theme--alert-texture">
                            <h2 className="slds-text-heading--medium" id="prompt-heading-id">{this.props.title}</h2>
                        </div>
                        <div className="slds-modal__content slds-p-around--medium">
                            <div dangerouslySetInnerHTML={{__html: message}} />
                        </div>
                        <div className="slds-modal__footer slds-theme--default">
                            <button className="slds-button slds-button--neutral"
                                    onClick={()=>this.props.cancelHandler()}>{AppManager.getLabel("PP_BTN_CANCEL") || 'Cancel'}</button>
                        </div>
                    </div>
                </div>
                <div className="slds-backdrop slds-backdrop--open"></div>
            </div>
        )
    }
});
