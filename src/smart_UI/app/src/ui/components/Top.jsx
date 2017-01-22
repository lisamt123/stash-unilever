"use strict";

var React = require('react');


module.exports = React.createClass({

    getInitialState:function(){
        return {
            page:null
        }
    },
    componentDidMount: function () {
        ReactDOM.render(React.createElement(Modal), document.getElementById('modal'));
        var me=this;
        window.onhashchange = function () {
             me.processHashUrl(window.location.hash.substring(1))
         }
        
        this.processHashUrl(window.location.hash.substring(1))
    },

    processHashUrl:function(hash){
        var params=hash.split('/');
        hash=params[0];
        params=params.slice(1);

        switch (hash) {
            
            case 'PromotionCalendar':
                this.loadPage('PromotionCalendar','BOExtPromotionCalendar',params); //This could be optimized by naming convention
               break;



            case 'PromotionPlanning':
            default:
                this.loadPage('PromotionPlanning','BOPromotion',params); //This could be optimized by naming convention
                break;


        }

    },

   
    //Generic method for loading pages
     loadPage: function(controllerId, boId, params){
        this.setState({page:controllerId});
        AppManager.load([boId]).then(function (res) {
            BOFactory.instantiate(boId,params)
        });
       
    },


    render: function () {
        if (this.state.page==null)
            return null;
        else
            return React.createElement(window[this.state.page]);
        
    }
});