"use strict";

require('animate.css');
require('chartist.css');
require('../../styles/style.less');

//Import 3rd party libraries
global.React = require('react');
global.ReactDOM = require('react-dom');
global.PromotionCalendar = require('./controller/PromotionCalendar');
global.PromotionPlanning = require('./controller/PromotionPlanning');
global.Modal = require('./components/Modal');
global.Top = require('./components/Top');
global.PromotionActions = require('../actions/PromotionActions').PromotionActions;
global.UI = { moment: require('moment') };//[US] 366271 
var _reactLightningDesignSystem = require('react-lightning-design-system');

//SF resources
if (typeof sfldsURL !== 'undefined') {
    _reactLightningDesignSystem.util.setAssetRoot(sfldsURL);
}

//Common things
var preventDefault = e => e.preventDefault();

addEventListener('dragover', preventDefault);
addEventListener('drop', preventDefault);

AppManager.init().then(() => {
    require('moment').locale(AppSettings.get('locale'));
});
