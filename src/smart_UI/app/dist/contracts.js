webpackJsonp([0],[
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	__webpack_require__(13);
	module.exports = __webpack_require__(178);


/***/ },
/* 1 */,
/* 2 */,
/* 3 */,
/* 4 */,
/* 5 */,
/* 6 */,
/* 7 */,
/* 8 */,
/* 9 */,
/* 10 */,
/* 11 */,
/* 12 */,
/* 13 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {"use strict";

	global.bopromotion = __webpack_require__(14);
	global.lofund = __webpack_require__(15);
	global.lofilteredfunds = __webpack_require__(16);
	global.loextprdfilters = __webpack_require__(17);
	global.loaccount = __webpack_require__(18);
	global.lofilteredproducts = __webpack_require__(19);
	global.loextproduct = __webpack_require__(20);
	global.loextproductfilter = __webpack_require__(21);
	global.loextchartvalues = __webpack_require__(22);
	global.lofiltervalue = __webpack_require__(23);
	global.lopromotion_template = __webpack_require__(24);
	global.lotactic = __webpack_require__(25);
	global.lotactic_template = __webpack_require__(26);
	global.lotacticproductfilter = __webpack_require__(27);
	global.loextpromotiongrid = __webpack_require__(28);

	global.dsextprdfilters = __webpack_require__(29);
	global.dsfund = __webpack_require__(30);
	global.dsfilteredfunds = __webpack_require__(31);
	global.dsaccount = __webpack_require__(32);
	global.dsfilteredproducts = __webpack_require__(33);
	global.dsextproduct = __webpack_require__(34);
	global.dsextproductfilter = __webpack_require__(35);
	global.dsextchartvalues = __webpack_require__(36);
	global.dsextpromotiongrid = __webpack_require__(37);

	global.dspromotion = __webpack_require__(38);
	global.dspromotion_template = __webpack_require__(39);
	global.dstactic = __webpack_require__(40);
	global.dstactic_template = __webpack_require__(41);
	global.promotion = __webpack_require__(42);
	global.tactic = __webpack_require__(43);
	global.dstacticproductfilter = __webpack_require__(44);
	global.extproduct = __webpack_require__(45);

	/**********************/
	global.bocalendarpromotion = __webpack_require__(46);
	global.dscalendarpromotion = __webpack_require__(47);
	global.Localization = __webpack_require__(48);

	global.extpromotioncalendar = __webpack_require__(49);
	global.dsextpromotioncalendar = __webpack_require__(161);
	global.localendarview = __webpack_require__(162);
	global.dscalendarview = __webpack_require__(163);
	global.dscalpromotions = __webpack_require__(164);
	global.localpromotions = __webpack_require__(165);
	global.dsextcallegend = __webpack_require__(166);
	global.loextcallegend = __webpack_require__(167);
	global.dsextfiscalyear = __webpack_require__(168);
	global.loextfiscalyear = __webpack_require__(169);
	global.boextpromotioncalendar = __webpack_require__(170);
	global.loaccountset = __webpack_require__(171);
	global.dsaccountset = __webpack_require__(172);
	global.loexthovercontent = __webpack_require__(173);
	global.dsexthovercontent = __webpack_require__(174);

	global.dsmetadata = __webpack_require__(175);
	global.dscustomlabels = __webpack_require__(176);
	global.dslocale = __webpack_require__(177);
	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },
/* 14 */
/***/ function(module, exports) {

	'use strict';

	var BO_Promotion = {
	    'Type': 'BusinessObject',
	    'Name': 'BOPromotion',
	    'SFObject': 'Promotion__c',
	    'DataSource': 'DSPromotion',
	    'BaseClass': 'Promotion',
	    'IdAttribute': 'Id',
	    'Properties': [], // Properties are not explitely defined in release 3
	    'ListObjects': [{ 'Name': 'LOTactic' }, { 'Name': 'LOExtProduct' }, { 'Name': 'LOFilteredProducts' }, { 'Name': 'LOTactic_Template' }, { 'Name': 'LOExtProductFilter' }, { 'Name': 'LOPromotion_Template' }, { 'Name': 'LOAccount' }, { 'Name': 'LOAccountSet' }, { 'Name': 'LOExtChartValues' }, { 'Name': 'LOFund' }, { 'Name': 'LOFilteredFunds' }, { 'Name': 'LOExtPrdFilters' }, { 'Name': 'LOTacticProductFilter' }, { 'Name': 'LOExtPromotionGrid' }],
	    'Methods': [{ 'Name': 'onInstantiate' }, { 'Name': 'afterInstantiate' }, { 'Name': 'getDurationInWeeks' }, { 'Name': 'save' }, { 'Name': 'onUIError' }, { 'Name': 'onDispatcher' }, { 'Name': 'serializeTree' }, { 'Name': 'serializeProductFilters' }, { 'Name': 'serializeSelectedTactic' }, { 'Name': 'getProductsForTacticID' }, { 'Name': 'applyProductFilter' }, { 'Name': 'addProductsFilter' }, { 'Name': 'searchForProducts' }, { 'Name': 'addTactic', 'Customize': ['beforeAPEX', 'afterAPEX', 'post'] }, { 'Name': 'deleteTactic' }, { 'Name': 'duplicateTactic' }, { 'Name': 'resetAllFilters' }, { 'Name': 'setFilter' }, { 'Name': 'getProductGroupsForTacticID' }, { 'Name': 'getFundsForTacticID' }, { 'Name': 'addFunds' }, { 'Name': 'deleteFunds' }, { 'Name': 'getMergedProductFilters' }, { 'Name': 'serializePromotion' }, { 'Name': 'getMergedProductFilterForTactic' }, { 'Name': 'toggleTacticProductFilter' }, { 'Name': 'updateTacticProductFilter' }, { 'Name': 'preLoad' }, { 'Name': 'postLoad' }, { 'Name': 'refreshPromotion' }, { 'Name': 'saveAndRefresh' }, { 'Name': 'loadGrid' }, { 'Name': 'serializeToAPEX' }, { 'Name': 'serializeToUI' }, { 'Name': 'serializeSelectedTacticToUI' }]
	};

		module.exports = BO_Promotion;

/***/ },
/* 15 */
/***/ function(module, exports) {

	'use strict';

	var LOFund = {
	    'Type': 'ListObject',
	    'Name': 'LOFund',
	    'SFObject': 'Fund__c',
	    'DataSource': 'DSFund',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOFund;

/***/ },
/* 16 */
/***/ function(module, exports) {

	'use strict';

	var LOFilteredFunds = {
	    'Type': 'ListObject',
	    'Name': 'LOFilteredFunds',
	    'SFObject': 'Fund__c',
	    'DataSource': 'DSFilteredFunds',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOFilteredFunds;

/***/ },
/* 17 */
/***/ function(module, exports) {

	'use strict';

	var LOExtPrdFilters = {
	    'Type': 'ListObject',
	    'Name': 'LOExtPrdFilters',
	    'SFObject': null,
	    'DataSource': 'DSExtPrdFilters',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOExtPrdFilters;

/***/ },
/* 18 */
/***/ function(module, exports) {

	'use strict';

	var LOAccount = {
	    'Type': 'ListObject',
	    'Name': 'LOAccount',
	    'SFObject': 'Account',
	    'DataSource': 'DSAccount',
	    'Properties': [] // Properties are not explitly defined in release 3   
	};

		module.exports = LOAccount;

/***/ },
/* 19 */
/***/ function(module, exports) {

	'use strict';

	var LOFilteredProducts = {
	    'Type': 'ListObject',
	    'Name': 'LOFilteredProducts',
	    'SFObject': 'Product__c',
	    'DataSource': 'DSFilteredProducts',
	    'Properties': [] // Properties are not explitly defined in release 3
	};

		module.exports = LOFilteredProducts;

/***/ },
/* 20 */
/***/ function(module, exports) {

	'use strict';

	var LOExtProduct = {
	    'Type': 'ListObject',
	    'Name': 'LOExtProduct',
	    'SFObject': 'Product__c',
	    'DataSource': 'DSExtProduct',
	    'BaseClass': 'ExtProduct',
	    'Properties': [], // Properties are not explitly defined in release 3
	    'Methods': [{ 'Name': 'getLabel' }, { 'Name': 'onLoad' }, { 'Name': 'addLabels' }]
	};

		module.exports = LOExtProduct;

/***/ },
/* 21 */
/***/ function(module, exports) {

	'use strict';

	var LOExtProductFilter = {
	    'Type': 'ListObject',
	    'Name': 'LOExtProductFilter',
	    'SFObject': null,
	    'DataSource': 'DSExtProductFilter',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOExtProductFilter;

/***/ },
/* 22 */
/***/ function(module, exports) {

	'use strict';

	var LOExtChartValues = {
	    'Type': 'ListObject',
	    'Name': 'LOExtChartValues',
	    'SFObject': null,
	    'DataSource': 'DSExtChartValues',
	    'Properties': [] // Properties are not explitly defined in release 3
	};

		module.exports = LOExtChartValues;

/***/ },
/* 23 */
/***/ function(module, exports) {

	'use strict';

	var LOFilterValue = {
	    'Type': 'ListObject',
	    'Name': 'LOFilterValue',
	    'SFObject': null,
	    'DataSource': 'DSFilterValue',
	    'BaseClass': 'FilterValue.js',
	    'Properties': [], // Properties are not explitly defined in release 3
	    'Methods': []
	};

		module.exports = LOFilterValue;

/***/ },
/* 24 */
/***/ function(module, exports) {

	'use strict';

	var LOPromotion_Template = {
	    'Type': 'ListObject',
	    'Name': 'LOPromotion_Template',
	    'SFObject': 'Promotion_Template__c',
	    'DataSource': 'DSPromotion_Template',
	    'Properties': [] // Properties are not explitly defined in release 3
	};

		module.exports = LOPromotion_Template;

/***/ },
/* 25 */
/***/ function(module, exports) {

	'use strict';

	var LOTactic = {
	    'Type': 'ListObject',
	    'Name': 'LOTactic',
	    'SFObject': 'Tactic__c',
	    'DataSource': 'DSTactic',
	    'BaseClass': 'Tactic',
	    'Properties': [], // Properties are not explitly defined in release 3
	    'Methods': [{ 'Name': 'getProducts' }, { 'Name': 'getProductGroups' }, { 'Name': 'onLoad' }]
	};

		module.exports = LOTactic;

/***/ },
/* 26 */
/***/ function(module, exports) {

	'use strict';

	var LOTactic_Template = {
	    'Type': 'ListObject',
	    'Name': 'LOTactic_Template',
	    'SFObject': 'Promotion_Template_Tactic_Template__c',
	    'DataSource': 'DSTactic_Template',
	    'Properties': [] // Properties are not explitly defined in release 3
	};

		module.exports = LOTactic_Template;

/***/ },
/* 27 */
/***/ function(module, exports) {

	'use strict';

	var LOTacticProductFilter = {
	    'Type': 'ListObject',
	    'Name': 'LOTacticProductFilter',
	    'SFObject': null,
	    'DataSource': 'DSTacticProductFilter',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOTacticProductFilter;

/***/ },
/* 28 */
/***/ function(module, exports) {

	'use strict';

	var LOExtPromotionGrid = {
	    'Type': 'ListObject',
	    'Name': 'LOExtPromotionGrid',
	    'SFObject': null,
	    'DataSource': 'DSExtPromotionGrid',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOExtPromotionGrid;

/***/ },
/* 29 */
/***/ function(module, exports) {

	'use strict';

	var DSExtPrdFilters = {
	    'Type': 'DataSource',
	    'Name': 'DSExtPrdFilters',
	    'IsExternal': true,
	    'SFObject': null,
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }]
	};

		module.exports = DSExtPrdFilters;

/***/ },
/* 30 */
/***/ function(module, exports) {

	'use strict';

	var DSFund = {
	    'Type': 'DataSource',
	    'Name': 'DSFund',
	    'IsExternal': false,
	    'SFObject': 'Fund__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }]
	};

		module.exports = DSFund;

/***/ },
/* 31 */
/***/ function(module, exports) {

	'use strict';

	var DSFilteredFunds = {
	    'Type': 'DataSource',
	    'Name': 'DSFilteredFunds',
	    'IsExternal': true,
	    'SFObject': 'Fund__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }]
	};

		module.exports = DSFilteredFunds;

/***/ },
/* 32 */
/***/ function(module, exports) {

	'use strict';

	var DSAccount = {
	    'Type': 'DataSource',
	    'Name': 'DSAccount',
	    'IsExternal': false,
	    'IsManaged': true,
	    'SFObject': 'Account',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'AccountRemoteActionExtension', 'Buffer': false }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }, { 'Type': 'copy', 'Available': false }]
	};

		module.exports = DSAccount;

/***/ },
/* 33 */
/***/ function(module, exports) {

	'use strict';

	var DSFilteredProducts = {
	    'Type': 'DataSource',
	    'Name': 'DSFilteredProducts',
	    'IsExternal': false,
	    'SFObject': 'Product__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }]
	};

		module.exports = DSFilteredProducts;

/***/ },
/* 34 */
/***/ function(module, exports) {

	'use strict';

	var DSExtProduct = {
	    'Type': 'DataSource',
	    'Name': 'DSExtProduct',
	    'IsExternal': true,
	    'SFObject': null,
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }]
	};

		module.exports = DSExtProduct;

/***/ },
/* 35 */
/***/ function(module, exports) {

	'use strict';

	var DSExtProductFilter = {
	    'Type': 'DataSource',
	    'Name': 'DSExtProductFilter',
	    'IsExternal': true,
	    'SFObject': null,
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }]
	};

		module.exports = DSExtProductFilter;

/***/ },
/* 36 */
/***/ function(module, exports) {

	'use strict';

	var DSExtChartValues = {
	    'Type': 'DataSource',
	    'Name': 'DSExtChartValues',
	    'IsExternal': true,
	    'SFObject': null,
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }]
	};

		module.exports = DSExtChartValues;

/***/ },
/* 37 */
/***/ function(module, exports) {

	'use strict';

	var DSExtPromotionGrid = {
	    'Type': 'DataSource',
	    'Name': 'DSExtPromotionGrid',
	    'IsExternal': true,
	    'SFObject': null,
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{
	        'Type': 'getMeta',
	        'Extension': 'PromotionPlanningController'
	    }, {
	        'Type': 'getData',
	        'Extension': 'PromotionPlanningController',
	        'Managed': true,
	        'Compressed': true,
	        'Buffer': false
	    }]
	};

		module.exports = DSExtPromotionGrid;

/***/ },
/* 38 */
/***/ function(module, exports) {

	'use strict';

	var DSPromotion = {
	    'Type': 'DataSource',
	    'Name': 'DSPromotion',
	    'IsExternal': false,
	    'SFObject': 'Promotion__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Available': true, 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Available': true, 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false, 'Extension': 'PromotionRemoteActionExtension' }]
	};

		module.exports = DSPromotion;

/***/ },
/* 39 */
/***/ function(module, exports) {

	'use strict';

	var DSPromotion_Template = {
	    'Type': 'DataSource',
	    'Name': 'DSPromotion_Template',
	    'IsExternal': false,
	    'SFObject': 'Promotion_Template__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionTemplateRemoteActionExtension' }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }]
	};

		module.exports = DSPromotion_Template;

/***/ },
/* 40 */
/***/ function(module, exports) {

	'use strict';

	var DSTactic = {
	    'Type': 'DataSource',
	    'Name': 'DSTactic',
	    'IsExternal': false,
	    'SFObject': 'Tactic__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'create', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false, 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'copy', 'Extension': 'PromotionRemoteActionExtension' }]
	};

		module.exports = DSTactic;

/***/ },
/* 41 */
/***/ function(module, exports) {

	'use strict';

	var DSTactic_Template = {
	    'Type': 'DataSource',
	    'Name': 'DSTactic_Template',
	    'IsExternal': false,
	    'SFObject': 'Promotion_Template_Tactic_Template__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'TacticTemplateRemoteActionExtension' }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }]
	};

		module.exports = DSTactic_Template;

/***/ },
/* 42 */
/***/ function(module, exports) {

	'use strict';

	var Promotion = {
	    /**
	     * The onInstantiate function is call once when the BO is ready for user
	     * 
	     * @param data - Empty in most circumstances
	     * @returns {Promise[]} Array of promises created by asynchronous load of data
	     */
	    // Core functionality - DO NOT CHANGE THE CONTENT OF THIS FUNCTION DURING CUSTOMIZING!
	    onInstantiate: function onInstantiate(data) {
	        var me = this;
	        var instantiatePromises = []; // when.defer();
	        this.fluxHandler = UI_EVENT_BUS.subscribe(EVENTS.FLUX, this.onDispatcher.bind(this));
	        UI_EVENT_BUS.subscribe(EVENTS.UI_ERROR, this.onUIError.bind(this));
	        this.Id = promotionId;

	        instantiatePromises = this.preLoad();
	        this.isEditable = false;
	        this.editMode = false;

	        return instantiatePromises;
	    },
	    /**
	         * Load all data which must be available before the UI is rendered. 
	         * The promises as returned by this function are handled in a synchronous way. Only once all of them are resolved the system continues.
	         * @returns {Promise[]} Array of promises created by asynchronous load of data
	         */
	    preLoad: function preLoad() {
	        var me = this;
	        var instantiatePromises = [];

	        this.loadPhase = 'preload';
	        instantiatePromises.push(this.load(promotionId, false));
	        instantiatePromises.push(this.LOTactic.load(null));
	        instantiatePromises.push(this.LOTactic_Template.load());
	        instantiatePromises.push(this.LOPromotion_Template.load());
	        instantiatePromises.push(this.LOAccount.load());
	        //instantiatePromises.push(this.LOAccountSet.load());
	        instantiatePromises.push(this.LOTacticProductFilter.load());

	        // Reset the availability of the Chart controls after each load
	        this.isKPIInvalid = false;

	        return Utils.callCustomFunction(this, 'preLoad', null, instantiatePromises);
	    },
	    /**
	        * Load all data which must be available before the UI is rendered. 
	        * The promises as returned by this function are handled in a synchronous way. Only once all of them are resolved the system continues.
	        * @returns {Promise[]} Array of promises created by asynchronous load of data
	        */
	    postLoad: function postLoad() {
	        var _this = this;

	        var me = this;

	        // Build JSON object of promotion content needed as parameter for APEX calls
	        var promoObject = this.serializePromotion();

	        // Remove all deleted tactics from the serialized LOTactic as they are not needed for these calls
	        var tacticIdMap = this.LOTactic._hidden.idMapping;
	        _.remove(promoObject.LOTactic, function (item) {
	            return item.__ObjectStatus & STATE.DELETED;
	        });

	        var template = _.find(this.LOPromotion_Template.getAllItems(), { Id: this.Promotion_Template__c });
	        var chartPromise = template && template.Calculation_Mode__c === 'Writeback' ? this.LOExtChartValues.load(null, promoObject) : true;

	        // Callback executed once all tasks are done
	        var onceDone = function onceDone() {
	            _this.loadPhase = 'postload';
	            _this.changeHandler();
	            Utils.callCustomFunction(_this, 'postLoad', null);
	        };

	        when.all([chartPromise, this.LOFund.load(null, promoObject), when.all([this.LOExtPrdFilters.load(function (data) {
	            me.LOExtProductFilter.addItems(me.getMergedProductFilters(me.LOTacticProductFilter, data));
	        })]).then(function () {
	            return _this.LOExtProduct.apex_read(JSON.stringify(_this.serializePromotion()));
	        }).then(function (prods) {

	            _this.LOExtProduct.removeAllItems();

	            if (prods.data) {
	                //temporary handling of 15 digit tactic id from product resolution
	                _.each(prods.data, function (p) {
	                    if (p.Tactics != undefined) {
	                        _.each(p.Tactics, function (t) {
	                            t.tacticId = tacticIdMap[t.tacticId];
	                        });
	                    }
	                });

	                me.LOExtProduct.addItems(prods.data);
	                me.LOExtProduct.onLoad();
	            }
	        })]).then(onceDone, onceDone);

	        // Define event handler 
	        // TODO: This should be obsolete and be done through the event bus
	        this.setChangeHandler(function () {
	            UI_EVENT_BUS.put(EVENTS.UI_BINDING, {
	                promotion: this.serializeTree(),
	                productFilters: this.serializeProductFilters(),
	                selectedTactic: this.serializeSelectedTactic()
	            });
	        });

	        setTimeout(function () {
	            return _this.changeHandler();
	        }, 0);
	    },

	    /**
	      * Anchor for the postLoad function
	      * Content is moved to postLoad since it may be called several times which would not match the purpose of this function
	      */

	    afterInstantiate: function afterInstantiate() {
	        this.postLoad();
	    },

	    /**
	     * Serialize the content of the promotion to be sent as parameter to an APEX method
	     */
	    serializeToAPEX: function serializeToAPEX() {
	        return this.serializePromotion();
	    },

	    /**
	     * Serialize the content of the promotion to be sent as state to the React UI
	     */
	    serializeToUI: function serializeToUI() {
	        return this.serializeTree();
	    },
	    /**
	     * Serialize the content of the selected tactic to be sent as state to the React UI
	     */
	    serializeSelectedTacticToUI: function serializeSelectedTacticToUI() {
	        return this.serializeSelectedTactic();
	    },
	    updateTacticProductFilter: function updateTacticProductFilter(tacticID, extProductFilter) {
	        var productfilter = {};

	        var productFilter = this.LOTacticProductFilter.getAllItems().filter(function (item) {
	            return item.tacticId == tacticID;
	        });
	        if (productFilter.length > 0) {
	            productfilter = productFilter[0].productfilter;
	        }

	        var criteria = {};
	        productfilter.criteria = criteria;
	        _.each(extProductFilter, function (filter) {
	            if (filter.selected) {
	                if (criteria[filter.filterId] === undefined) criteria[filter.filterId] = [];
	                criteria[filter.filterId].push(filter.filterValueId);
	            }
	        });

	        _.find(this.LOTacticProductFilter.getAllItems(), { tacticId: tacticID }).productfilter = productfilter;
	        _.find(this.LOTactic.getItems(), { Id: tacticID }).objectStatus |= STATE.DIRTY;
	        return productfilter;
	    },

	    getDurationInWeeks: function getDurationInWeeks() {
	        var duration = Utils.Converters.Date2TS(this.Date_Thru__c) - Utils.Converters.Date2TS(this.Date_From__c);
	        var weekDuration = 7 * 24 * 60 * 60000;
	        return Math.floor(duration / weekDuration) + ' weeks';
	    },
	    /**
	       * Internal implementation of the serialization to APEX. Is called and customized through serializeToAPEX
	       * @returns {JSON} Serialized version for the BO as required by the APEX layer
	       */

	    serializePromotion: function serializePromotion() {
	        var me = this;
	        var saveObject = this.serialize();
	        saveObject.Slogan_Language_1__c = saveObject.Slogan__c;
	        saveObject.LOTactic = this.LOTactic.serialize();
	        if (saveObject.LOTactic) saveObject.LOTactic.forEach(function (tactic) {
	            var productFilter = me.LOTacticProductFilter.getAllItems().filter(function (item) {
	                return item.tacticId == tactic.Id;
	            });
	            if (productFilter.length > 0) {

	                tactic.productfilter = productFilter[0].productfilter;
	                if (productFilter[0].productfilter != undefined && productFilter[0].productfilter.manualproducts != undefined) tactic.productfilter.manualproducts = productFilter[0].productfilter.manualproducts;
	            }
	            //added to handle the case when filter is undefined return empty filter.
	            if (tactic.productfilter === undefined) {
	                tactic.productfilter = {};
	                tactic.productfilter.criteria = {};
	                tactic.productfilter.manualproducts = null;
	            }
	            tactic.Pct_of_Stores__c = parseFloat(tactic.Pct_of_Stores__c);
	            tactic.Amount__c = parseFloat(tactic.Amount__c);
	            tactic.Lift__c = parseFloat(tactic.Lift__c);
	            // tactic.__ObjectStatus = me.LOTactic.getAllItems().find(item => item.Id == tactic.Id).getObjectStatus();
	            tactic.__ObjectStatus = _.find(me.LOTactic.getAllItems(), { Id: tactic.Id }).getObjectStatus();
	        });
	        saveObject.LOExtPromotionAttachment = SerializationHelper.serializeWithStatus(this.LOExtPromotionAttachment);
	        // We do not get a state for the tactic relation of a fund. This is because of the LO structure (tactic
	        // is array in LI). The APEX controller needs to take care of that.
	        saveObject.LOFund = this.LOFund.serialize() || {};
	        if (saveObject.LOFund) saveObject.LOFund.forEach(function (fund) {
	            var tactics;
	            me.LOFund.getAllItems().forEach(function (f) {
	                if (f.Id === fund.Id) tactics = f.Tactics;
	            });
	            if (tactics != undefined) {
	                fund.tactics = tactics;
	            }
	            if (fund.tactics === undefined) {
	                fund.tactics = [];
	            }
	        });
	        return { "BOPromotion": Utils.callCustomFunction(this, 'serializeToAPEX', null, saveObject) };
	    },
	    /**
	         * getMergedProductFilters
	         * @param {model} loTactic - Representation of the tactic LO
	         * @param {JSON} extPrdFilters - Product filters
	         */
	    getMergedProductFilters: function getMergedProductFilters(loTactic, extPrdFilters) {
	        var extProductFilters = [];
	        var me = this;
	        if (loTactic) {
	            var dictIncludedTactics = {};
	            _.each(loTactic.getAllItems(), function (tactic) {
	                extProductFilters = me.getMergedProductFilterForTactic(tactic, extPrdFilters, extProductFilters);
	                dictIncludedTactics[tactic.tacticId] = "";
	            });

	            //below code won't be necessary if all tactics get atleast null productfilter defined.
	            _.each(this.LOTactic.getAllItems(), function (tactic) {
	                if (dictIncludedTactics[tactic.Id] == undefined) extProductFilters = me.getMergedProductFilterForTactic(tactic, extPrdFilters, extProductFilters);
	            });
	        }
	        return extProductFilters;
	    },

	    getMergedProductFilterForTactic: function getMergedProductFilterForTactic(tactic, extPrdFilters, currentFilters) {
	        var map = {};
	        if (tactic.productfilter) {
	            var criteria = tactic.productfilter.criteria;
	            for (var key in criteria) {
	                map[key] = {};
	                _.each(criteria[key], function (selected) {
	                    map[key][selected] = "True";
	                });
	            }
	        }
	        _.each(extPrdFilters.getAllItems(), function (f) {
	            var extPrdFilter = _.clone(f);
	            extPrdFilter["tacticId"] = tactic.Id != undefined ? tactic.Id : tactic.tacticId;
	            if (map[extPrdFilter.filterId] && map[extPrdFilter.filterId][extPrdFilter.filterValueId]) extPrdFilter["selected"] = true;else extPrdFilter["selected"] = false;
	            currentFilters.push(extPrdFilter);
	        });
	        return currentFilters;
	    },
	    /**
	         * Saves the BO to the SF backend. Does not leave the edit mode!
	         */
	    save: function save() {
	        console.log('PERFORMED ACTION SAVE PROMOTION');
	        var saveObject = this.serializePromotion();
	        this.apex_write(this.getIdValue(), JSON.stringify(saveObject)).then(function (saveResult) {
	            // TODO: Use correct event bus here! This is just dummy code
	            if (saveResult.__Status) {
	                // Send event to UI that save has succeeded and appropriate action can be done
	                console.log('Save of data succeeded!');
	                UI_EVENT_BUS.put(EVENTS.BO_SAVE_SUCCEEDED);
	            } else {
	                // Error during saving. Edit mode should not be closed and user needs to be informed!
	                console.log('Save of data failed!', saveResult.ExceptionType, saveResult.ExceptionMessage, saveResult.ExceptionWhere);
	                UI_EVENT_BUS.put(EVENTS.BO_SAVE_FAILED, saveResult);
	            }
	        });
	    },
	    /**
	    * Save the promotion to SF calling writeBOPromotion. The BO will then be reloaded and the UI newly rendered with the loaded content.
	    * The edit mode is NOT left by this function
	    */
	    saveAndRefresh: function saveAndRefresh() {
	        var _this2 = this;

	        console.log('PERFORMED ACTION SAVE PROMOTION');
	        var saveObject = this.serializePromotion();
	        var promoId = this.getId();
	        saveObject.target = "Salesforce";
	        this.apex_write(this.getIdValue(), JSON.stringify(saveObject)).then(function (saveResult) {
	            // TODO: Use correct event bus here! This is just dummy code
	            if (saveResult.__Status) {
	                // Send event to UI that save has succeeded and appropriate action can be done
	                console.log('Save of data succeeded!');
	                //trigger save to heroku
	                saveObject.target = "WebService";
	                _this2.apex_write(_this2.getIdValue(), JSON.stringify(saveObject));
	                _this2.refreshPromotion();

	                UI_EVENT_BUS.put(EVENTS.BO_SAVE_SUCCEEDED);
	            } else {
	                // Error during saving. Edit mode should not be closed and user needs to be informed!
	                console.log('Save of data failed!', saveResult.ExceptionType, saveResult.ExceptionMessage, saveResult.ExceptionWhere);
	                // this.refreshPromotion(); //refresh anyway
	                //don't refresh promotion stay in edit mode'
	                UI_EVENT_BUS.put(EVENTS.UI_BINDING, { enableToolbar: true, editMode: true });
	                UI_EVENT_BUS.put(EVENTS.BO_SAVE_FAILED, saveResult);
	            }
	        });
	    },
	    /**
	      * Returns all products for a given tactic 
	      */
	    getProductsForTacticID: function getProductsForTacticID(tacticID, relation) {
	        return _.filter(this.LOExtProduct.getAllItems(), function (product) {
	            if (relation != null) {
	                return _.find(product.Tactics, { tacticId: tacticID, relationship: relation });
	            } else return _.find(product.Tactics, { tacticId: tacticID });
	        });
	    },

	    addTactic: function addTactic(tacticTemplate) {
	        var _this3 = this;

	        this.logger.info('PERFORMED ADD TACTIC WITH TACTIC TEMPLATE ' + tacticTemplate);

	        var saveObject = { 'BOPromotion': this.serialize(), 'Tactic_Template_Id__c': tacticTemplate.Id };
	        saveObject = Utils.callCustomFunction(this, 'addTactic', 'beforeAPEX', saveObject);

	        var me = this;
	        this.LOTactic.apex_create(JSON.stringify(saveObject)).then(function (createResult) {
	            if (createResult.__Status) {
	                createResult.data = Utils.callCustomFunction(_this3, 'addTactic', 'afterAPEX', createResult.data);
	                createResult.data.objectStatus = STATE.NEW;
	                me.LOTactic.addItem(createResult.data);
	                //addtactic to LOTacticProductFilter
	                var tacticFilter = {
	                    tacticId: createResult.data.Id,
	                    productfilter: { criteria: {}, manualproducts: null }
	                };
	                me.LOTacticProductFilter.addItem(tacticFilter);
	                me.LOTactic.onLoad(); //added for tacticId handling
	                // this.LOTacticProductFilter.addItem({tacticId:createResult.data.Id, productfilter={}});
	                var loExtProductFilters = [];
	                //load filters again
	                loExtProductFilters = _this3.getMergedProductFilterForTactic(createResult.data, _this3.LOExtPrdFilters, loExtProductFilters);

	                _this3.LOExtProductFilter.addItems(loExtProductFilters);

	                _this3.setFilter(tacticFilter.tacticId);
	                var tacticItem = _this3.serializeSelectedTactic();
	                UI_EVENT_BUS.put(EVENTS.UI_BINDING, { selectedItem: tacticItem });
	                UI_EVENT_BUS.put(EVENTS.UI_BINDING, { selectedNode: tacticItem });
	                Utils.callCustomFunction(_this3, 'addTactic', 'post', saveObject);
	                _this3.changeHandler();
	            } else {
	                // Error during tactic creation. The user needs to be informed!
	                console.log('Create of a new tactic failed!', saveResult.ExceptionType, saveResult.ExceptionMessage, saveResult.ExceptionWhere);
	                UI_EVENT_BUS.put(EVENTS.BO_TACTIC_CREATE_FAILED, saveResult);
	            }
	        });
	    },
	    /**
	        * Logically deletes a selected tactic from LOTactic. The actual deletion only happens when the BO is saved
	        * @param {string} tacticID - Id of the tactic to be deleted
	        */
	    deleteTactic: function deleteTactic(tacticID) {
	        console.log("PERFORMED ACTION DELETE TACTIC FOR TACTIC ID:" + tacticID);
	        // Current tactic is selected. GetItems() only returns one record!
	        this.LOTactic.getItems()[0].setObjectStatus(STATE.DELETED);

	        this.resetAllFilters();
	        this.changeHandler();
	    },

	    duplicateTactic: function duplicateTactic(tacticID) {
	        var _this4 = this;

	        var promoObject = this.serializePromotion();
	        var me = this;
	        promoObject.Tactic__c = tacticID;
	        this.LOTactic.apex_copy(JSON.stringify(promoObject)).then(function (copyResult) {
	            if (copyResult.__Status) {
	                copyResult.data.objectStatus = STATE.NEW;

	                //addtactic to LOTacticProductFilter
	                var tacticFilter = {
	                    tacticId: copyResult.data.Id,
	                    productfilter: _.clone(_this4.LOTacticProductFilter.getItems()[0].productfilter)

	                };
	                copyResult.data.productfilter = tacticFilter.productfilter;
	                _this4.LOTactic.addItem(copyResult.data);
	                _this4.LOTacticProductFilter.addItem(tacticFilter);

	                _this4.LOTactic.onLoad(); //added for tacticId handling
	                // this.LOTacticProductFilter.addItem({tacticId:createResult.data.Id, productfilter={}});
	                var loExtProductFilters = [];
	                //load filters again
	                loExtProductFilters = _this4.getMergedProductFilterForTactic(copyResult.data, _this4.LOExtPrdFilters, loExtProductFilters);

	                _this4.LOExtProductFilter.addItems(loExtProductFilters);

	                _this4.setFilter(tacticFilter.tacticId);
	                var tacticItem = _this4.serializeSelectedTactic();
	                UI_EVENT_BUS.put(EVENTS.UI_BINDING, { selectedItem: tacticItem });
	                UI_EVENT_BUS.put(EVENTS.UI_BINDING, { selectedNode: tacticItem });
	                _this4.changeHandler();

	                console.log('PERFORMED ACTION DUPLICATE TACTIC FOR TACTIC ID:', tacticID);
	            } else {
	                console.log('Duplicate tactic', tacticID, 'failed. APEX RemoteAction returned no data.');
	            }
	        });
	    },
	    /**
	       * Helper function to reset the LO filters possibly set by user actions
	       */
	    resetAllFilters: function resetAllFilters() {
	        this.LOTactic.resetAllFilters();
	        this.LOExtProductFilter.resetAllFilters();
	        this.LOExtProduct.resetAllFilters();
	        this.LOFund.resetAllFilters();
	        this.LOTacticProductFilter.resetAllFilters();
	    },
	    /**
	        * Helper function called when the user selects a tactic in the drilldown control.
	        * The system sets filters on all relevant LOs to ensure that the right data is displayed
	        *  @param {string} id - Id of the tactic to be filtered on
	        */
	    setFilter: function setFilter(id) {
	        this.LOTactic.setFilter('Id', id, 'EQ');
	        this.LOExtProductFilter.setFilter('tacticId', id, 'EQ');
	        this.LOExtProduct.setFilter('Tactics', '{"Field": "tacticId", "Value":"' + id + '"}', 'CONTAINS');
	        this.LOFund.setFilter('Tactics', '{"Field": "tacticId", "Value":"' + id + '"}', 'CONTAINS');
	        this.LOTacticProductFilter.setFilter('tacticId', id, 'EQ');
	    },
	    /**
	       * Helper function called when the user applies a product filter in the manage products dialog.
	       * The system makes a callout to SF to get the corresponding list of products from the backend
	       * @param {string} tacticID - Id of the active tactic
	       * @param {string} productFilter - Product filter selected by the user
	       */
	    applyProductFilter: function applyProductFilter(tacticID, productFilter) {
	        var _this5 = this;

	        this.updateTacticProductFilter(tacticID, productFilter);
	        var promoObject = this.serializePromotion();
	        _.remove(promoObject.LOTactic, function (item) {
	            return item.__ObjectStatus & STATE.DELETED;
	        });
	        var tacticIdMap = this.LOTactic._hidden.idMapping;
	        this.LOExtProduct.apex_read(JSON.stringify(promoObject)).then(function (prods) {
	            _this5.LOExtProduct.removeAllItems();
	            if (prods.data) {
	                _.each(prods.data, function (p) {
	                    if (p.Tactics != undefined) {
	                        _.each(p.Tactics, function (t) {
	                            t.tacticId = tacticIdMap[t.tacticId];
	                        });
	                    }
	                });
	                _this5.LOExtProduct.addItems(prods.data);
	                _this5.LOExtProduct.onLoad();
	                UI_EVENT_BUS.put(EVENTS.UI_BINDING, { productFilters: _this5.serializeProductFilters() });
	                console.log('PERFORMED ACTION APPLY FILTER TACTIC FOR TACTIC ID:', tacticID);
	            }
	        });
	    },

	    toggleTacticProductFilter: function toggleTacticProductFilter(filterID, filterValueID, tactic, selected) {
	        console.log("PERFORMED ACTION Toggle FILTER TACTIC FOR TACTIC ID:" + tactic.Id);
	        _.find(this.LOExtProductFilter.getItems(), {
	            tacticId: tactic.Id,
	            filterId: filterID,
	            filterValueId: filterValueID
	        }).selected = selected;
	    },
	    /**
	       * Refreshes the content of the bo WITHOUT saving any possibly changed content
	       * @param {any} context - Decision on which context the UI recides on
	       */
	    refreshPromotion: function refreshPromotion(context) {
	        var refreshGrid = false;
	        if (context && context === "tree") refreshGrid = true;
	        var me = this;
	        this._hidden.lists.forEach(function (id) {
	            me[id].removeAllItems();
	        });
	        var promises = this.preLoad();
	        when.all(promises).then(function (dataArray) {
	            if (me.onLoad) me.onLoad(); // Internal callback
	            me.postLoad(); //post laod
	            me.loadGrid(JSON.parse(me.getManual_Calculation_Input__c()));
	            //reset all filters and get back to promotion
	            me.resetAllFilters();
	            //enable toolbar.
	            UI_EVENT_BUS.put(EVENTS.UI_BINDING, { enableToolbar: true });
	        });
	    },

	    addProductsFilter: function addProductsFilter(tacticID, products) {
	        var _this6 = this;

	        console.log('ADD_PRODUCTS');

	        //Let's update the tactic productFilter
	        if (tacticID == this.LOTacticProductFilter.getItems()[0].tacticId) {
	            //Let's update the tactic productFilter
	            _.find(this.LOTactic.getItems(), { Id: tacticID }).objectStatus |= STATE.DIRTY;
	            var productfilter = this.LOTacticProductFilter.getItems()[0].productfilter;
	            if (!productfilter.manualproducts) productfilter.manualproducts = [];
	            products.map(function (prod) {
	                var manualProd = _.find(productfilter.manualproducts, { productid: prod.Id });
	                if (manualProd) {
	                    manualProd.included = true;
	                } else {
	                    productfilter.manualproducts.push({ productid: prod.Id, included: true });
	                }
	            });
	        }

	        //Now let's update the LOExtProduct
	        products.map(function (prod) {
	            var existingProduct = _this6.LOExtProduct.getItemById(prod.Id);
	            if (existingProduct) {
	                //Update relationship
	                var tacticRelation = _.find(existingProduct.Tactics, { tacticId: tacticID });
	                if (tacticRelation) {
	                    tacticRelation.relationship = 'INCLUDED';
	                } else {
	                    existingProduct.Tactics.push({
	                        tacticId: tacticID,
	                        relationship: 'INCLUDED'
	                    });
	                }
	            } else {
	                //Add new LOExtProduct
	                var prodData = {
	                    Category: prod.Category__c,
	                    Container_Size_Unit: prod.Container_Size_Unit__c,
	                    Container_Size: prod.Container_Size__c,
	                    Container_Type: prod.Container_Type__c,
	                    Criterion_3_Product_Code: prod.Criterion_3_Product_Code__c,
	                    Criterion_3_Product_Description: prod.Criterion_3_Product_Description__c,
	                    Description_1: prod.Description_1__c,
	                    Id: prod.Id,
	                    Name: prod.Name,
	                    Pack_Size_Unit: prod.Pack_Size_Unit__c,
	                    Pack_Size: prod.Pack_Size__c,
	                    Short_Description: prod.Short_Description__c,
	                    ProductGroupId: 'TO BE DONE',
	                    ProductGroupDescription: 'TO BE DONE',
	                    Tactics: [{
	                        tacticId: tacticID,
	                        relationship: 'INCLUDED'
	                    }]
	                };
	                _this6.LOExtProduct.addItems([prodData]);
	            }
	        });
	        this.changeHandler();
	    },

	    searchForProducts: function searchForProducts(productSample) {
	        var _this7 = this;

	        console.log('searchForProducts'); //TODO Call APEX Controller

	        if (productSample === null) productSample = {};
	        var promoContent = this.serializePromotion();
	        promoContent.filterExpressions = productSample;

	        this.LOFilteredProducts.apex_read(JSON.stringify(promoContent)).then(function (productList) {
	            UI_EVENT_BUS.put(EVENTS.UI_BINDING, { productSearch: productList.data });
	            _this7.LOFilteredProducts.removeAllItems();
	            _this7.LOFilteredProducts.addItems(productList.data);
	        });
	    },
	    /**
	        * Add a fund to the LO. The system checks if there is already a relation to this fund.
	        * If yes, then it will be added, otherwise it is updated
	        * @param {Array} funds - List of fund to be added
	        * @param {string} tacticId - Id of the tactic to which the funds should be added
	        */
	    addFunds: function addFunds(funds, tacticId) {
	        var _this8 = this;

	        funds.map(function (fund) {
	            var existingFund = _this8.LOFund.getItemById(fund.Id);
	            if (existingFund) {
	                if (existingFund.objectStatus === STATE.DELETED) {
	                    existingFund.objectStatus = STATE.PERSISTED;
	                    existingFund.Tactics = [{
	                        'tacticId': tacticId
	                    }];
	                } else {
	                    existingFund.Tactics.push({ 'tacticId': tacticId });
	                }
	                _this8.LOFund.applyFilters();
	            } else {
	                fund.Tactics = [{
	                    'tacticId': tacticId
	                }];
	                _this8.LOFund.addItem(fund);
	            }
	        });
	    },

	    deleteFunds: function deleteFunds(fundsId, tacticId) {
	        var _this9 = this;

	        fundsId.forEach(function (fundId) {
	            var loFund = _.filter(_this9.LOFund.getItems(), function (fund) {
	                return fund.Id === fundId;
	            })[0]; //  this.LOFund.getItemById(fundId);
	            _.remove(loFund.Tactics, { 'tacticId': tacticId });
	            if (loFund.Tactics.length > 0) {
	                _this9.LOFund.applyFilters();
	            } else {
	                loFund.setObjectStatus(STATE.DELETED);
	            }
	        });
	    },

	    getProductGroupsForTacticID: function getProductGroupsForTacticID(tacticID) {
	        var productsForTactic = this.getProductsForTacticID(tacticID);
	        return _.uniqBy(productsForTactic, 'ProductGroupDescription');
	    },

	    serializeTree: function serializeTree() {
	        var _this10 = this;

	        var me = this;
	        var promotionJSON = {
	            _meta: this.getSfMeta(),
	            _acl: this.getACL(),
	            type: 'PROMOTION',
	            desc: AppManager.getLabel('PP_TIT_PROMO_SUMMARY') || 'Promotion Summary', //TODO:TRANSLATE
	            Date_From__c: new Date(this.Date_From__c),
	            Date_Thru__c: new Date(this.Date_Thru__c),
	            Placement_Date_From__c: new Date(this.Placement_Date_From__c),
	            Placement_Date_Thru__c: new Date(this.Placement_Date_Thru__c),
	            Order_Date_From__c: new Date(this.Order_Date_From__c),
	            Order_Date_Thru__c: new Date(this.Order_Date_Thru__c),
	            Delivery_Date_From__c: new Date(this.Delivery_Date_From__c),
	            Delivery_Date_Thru__c: new Date(this.Delivery_Date_Thru__c),
	            Commit_Date__c: new Date(this.Commit_Date__c),
	            duration: this.getDurationInWeeks(),
	            Active__c: this.Active__c,
	            tacticTemplates: this.LOTactic_Template.getAllItems(),
	            Id: this.Id,
	            Phase__c: this.Phase__c,
	            Slogan__c: this.Slogan__c,
	            Manual_Calculation_Input__c: JSON.parse(this.Manual_Calculation_Input__c),
	            AggregatedKPIs: {
	                roi_actual: 0,
	                roi_planned: 0,
	                costs_actual: 0,
	                costs_planned: 0
	            },
	            isKPIInvalid: this.isKPIInvalid, //How to map it??
	            children: []
	        };
	        //Editable function
	        promotionJSON.isEditable = this.getACL().isEditable(0, "Promotion__c");
	        //promotionJSON.isEditable = this.isEditable;
	        //Adding the promotion Template
	        var template = _.find(this.LOPromotion_Template.getAllItems(), { Id: this.Promotion_Template__c });
	        promotionJSON.Promotion_Template__c = template ? template.Description__c : '';
	        //Adding the promotion Account
	        var account = _.find(this.LOAccount.getAllItems(), { Id: this.Anchor_Account__c });
	        promotionJSON.Anchor_Account__c = account ? account.Name : '';
	        var accountSet = _.find(this.LOAccountSet.getAllItems(), { Id: this.Anchor_Account_Set__c });
	        promotionJSON.Anchor_Account_Set__c = accountSet ? accountSet.Description__c : '';
	        //Adding the KPIs
	        _.filter(this.LOExtChartValues.getAllItems(), { 'id': promotionJSON.Id, 'level': 'measures' }).map(function (KPI) {
	            promotionJSON.AggregatedKPIs[KPI.kpiId] = KPI.value;
	        });
	        this.LOTactic.getAllItems().map(function (tactic) {
	            if (tactic.getObjectStatus() !== STATE.DELETED) {
	                var tacticJSON = {
	                    _meta: tactic.getSfMeta(),
	                    type: 'TACTIC',
	                    Amount__c: tactic.getAmount__c(),
	                    Date_From__c: tactic.getDate_From__c(),
	                    Date_Thru__c: tactic.getDate_Thru__c(),
	                    Shipment_Date_From__c: tactic.getShipment_Date_From__c(),
	                    Shipment_Date_Thru__c: tactic.getShipment_Date_Thru__c(),
	                    Compensation_Model__c: tactic.getCompensation_Model__c(),
	                    Tactic_Template__r: '',
	                    Id: tactic.getId(),
	                    Lift__c: tactic.getLift__c(),
	                    Name: tactic.getName(),
	                    Pct_of_Stores__c: tactic.getPct_of_Stores__c(),
	                    Payment_Method__c: tactic.getPayment_Method__c(),
	                    children: []
	                };
	                var ttemplate = _.find(_this10.LOTactic_Template.getAllItems(), { Id: tactic.Tactic_Template__c });
	                tacticJSON.Tactic_Template = ttemplate ? ttemplate.Description__c : '';

	                var products = me.getProductsForTacticID(tactic.Id, 'MATCH').concat(me.getProductsForTacticID(tactic.Id, 'INCLUDED'));

	                var productGroups = _.uniqBy(products, 'ProductGroupDescription');
	                productGroups.map(function (pg) {
	                    var productGroup = {
	                        Name: pg.ProductGroupDescription,
	                        Id: pg.ProductGroupId,
	                        type: 'CATEGORY',
	                        children: []
	                    };
	                    var productsPerPG = _.filter(products, { ProductGroupDescription: pg.ProductGroupDescription });
	                    productsPerPG.map(function (prod) {
	                        var product = {
	                            Id: prod.Id,
	                            Name: prod.Description_1,
	                            type: 'PRODUCT'
	                        };
	                        productGroup.children.push(product);
	                    });
	                    tacticJSON.children.push(productGroup);
	                });
	                promotionJSON.children.push(tacticJSON);
	            }
	        });
	        return Utils.callCustomFunction(this, 'serializeToUI', null, promotionJSON);
	    },

	    serializeSelectedTactic: function serializeSelectedTactic() {
	        if (this.LOTactic._filters.length > 0 && this.LOTactic.getItems().length > 0) {
	            var tactic = this.LOTactic.getItems()[0];
	            var tacticJSON = {
	                _meta: tactic.getSfMeta(),
	                type: 'TACTIC',
	                Amount__c: tactic.getAmount__c(),
	                Date_From__c: tactic.getDate_From__c(),
	                Date_Thru__c: tactic.getDate_Thru__c(),
	                Shipment_Date_From__c: tactic.getShipment_Date_From__c(),
	                Shipment_Date_Thru__c: tactic.getShipment_Date_Thru__c(),
	                Instore_Date_From__c: tactic.getInstore_Date_From__c(),
	                Instore_Date_Thru__c: tactic.getInstore_Date_Thru__c(),
	                Compensation_Model__c: tactic.getCompensation_Model__c(),
	                Payment_Method__c: tactic.getPayment_Method__c(),
	                Tactic_Template__r: '',
	                Id: tactic.getId(),
	                Lift__c: tactic.getLift__c(),
	                Name: tactic.getName(),
	                Pct_of_Stores__c: tactic.getPct_of_Stores__c(),
	                AggregatedKPIs: {
	                    roi_actual: 0,
	                    roi_planned: 0,
	                    costs_actual: 0,
	                    costs_planned: 0
	                },
	                //isKPIInvalid: promotionJSON.isKPIInvalid,//How to map it??
	                children: []
	            };
	            var ttemplate = _.find(this.LOTactic_Template.getAllItems(), { Id: tactic.Tactic_Template__c });
	            tacticJSON.Tactic_Template__c = ttemplate ? ttemplate.Description__c : '';

	            tacticJSON.funds = this.LOFund.getItems();
	            tacticJSON.availableFunds = _.differenceBy(this.LOFilteredFunds.getAllItems(), this.LOFund.getItems(), 'Id');
	            tacticJSON._acl = this.LOTactic.getACL();
	            //Adding the KPIs
	            _.filter(this.LOExtChartValues.getAllItems(), { 'id': tacticJSON.Id, 'level': 'Tactic' }).map(function (KPI) {
	                tacticJSON.AggregatedKPIs[KPI.kpiId] = KPI.value;
	            });
	            return Utils.callCustomFunction(this, 'serializeSelectedTacticToUI', null, tacticJSON);
	        } else {
	            return null;
	        }
	    },
	    loadGrid: function loadGrid(Manual_Calculation_Input) {
	        var _this11 = this;

	        var me = this;
	        me.LOExtPromotionGrid.apex_getMeta(JSON.stringify(this.serializePromotion())).then(function (metaData) {

	            if (metaData.data) {
	                APEXAbstraction.readCustomLabels(metaData.data.measures.reduce(function (result, v) {

	                    if (v.display && v.display.enabled) {
	                        var prefix = '';
	                        //   if (ACSFNamespace) prefix = ACSFNamespace+'.';
	                        // if (v.customized) prefix = '';

	                        result.push(prefix + v.name);
	                    }
	                    return result;
	                }, [])).then(function (readCustomLabelsResult) {
	                    if (readCustomLabelsResult.__Status && readCustomLabelsResult.data) {
	                        var kpiLabels = readCustomLabelsResult.data;
	                        me.LOExtProduct.addLabels(kpiLabels);
	                    }
	                });
	            }

	            var errorHappened = false;
	            try {
	                if (metaData.__Status) {
	                    metaData = metaData.data;
	                    me.LOExtPromotionGrid.apex_getData(JSON.stringify(me.serializePromotion())).then(function (data) {
	                        if (data.__Status) {
	                            data = data.data;
	                            /**CAUTION: We are sending a functional object instead of only data. In a multithread environment this won't work*/
	                            var tree = Tree.instantiate("string" == typeof data ? JSON.parse(data) : data, metaData, metaData.variables, Manual_Calculation_Input);
	                            UI_EVENT_BUS.put(EVENTS.UI_BINDING, { tree: tree, idToLabelMapping: _this11.LOExtProduct._hidden.idToLabelMapping });
	                        }
	                    });
	                } else {
	                    errorHappened = true;
	                    LogManager.getLogger('PromotionPlanning').error('Status of the metaData JSON is false');
	                }
	            } catch (e) {
	                errorHappened = true;
	                LogManager.getLogger('PromotionPlanning').error(e.message);
	            }
	            if (errorHappened) {
	                UI_EVENT_BUS.put(EVENTS.UI_ERROR, { title: 'Error loading grid',
	                    message: 'Error occurred, please contact the administrator.',
	                    type: 'E' });
	            }
	        });
	    },
	    serializeProductFilters: function serializeProductFilters() {
	        //Hardcoded for the moment
	        var tacticID = null;
	        if (this.LOTactic._filters.length > 0 && this.LOTactic.getItems().length > 0) {
	            tacticID = this.LOTactic.getItems()[0].Id;
	        } else {
	            return null;
	        }
	        var productFilters = [];
	        this.LOExtProductFilter.getItems().map(function (prodFilter) {
	            productFilters.push({
	                filterId: prodFilter.filterId,
	                filterLabel: prodFilter.filterLabel,
	                filterValueId: prodFilter.filterValueId,
	                filterValueLabel: prodFilter.filterValueLabel,
	                selected: prodFilter.selected,
	                tacticId: prodFilter.tacticId
	            });
	        });

	        var products = this.LOExtProduct.getItems();
	        products.map(function (pd) {
	            pd.relationship = _.find(pd.Tactics, { tacticId: tacticID }).relationship;
	        });
	        products = _.orderBy(products, 'relationship', 'desc');
	        return {
	            productMetadata: this.LOFilteredProducts.itemType.prototype.getSfMeta(),
	            filters: productFilters,
	            products: products
	        };
	    },
	    onUIError: function onUIError(message) {
	        var _this12 = this;

	        this.modalMessages.push(message);
	        AppManager.init().then(function () {
	            return UI_EVENT_BUS.put(EVENTS.UI_BINDING, { modalMessages: _this12.modalMessages });
	        });
	    },
	    onDispatcher: function onDispatcher(payload) {
	        var _this13 = this;

	        var action = payload;
	        var me = this;
	        switch (action.actionType) {
	            case PromotionActionConstants.PROMOTION_LOAD:
	                this.load(this.Id);
	                break;
	            case PromotionActionConstants.PROMOTION_LOAD_GRID:
	                this.loadGrid(action.payload.Manual_Calculation_Input);
	                break;
	            case PromotionActionConstants.PROMOTION_SAVE:
	                this.editMode = false;
	                this.saveAndRefresh();
	                break;

	            case PromotionActionConstants.PROMOTION_SAVE_AND_REFRESH:
	                this.saveAndRefresh();
	                break;
	            case PromotionActionConstants.PROMOTION_EDIT:
	                this.editMode = true;
	                break;
	            case PromotionActionConstants.PROMOTION_CANCEL:
	                this.editMode = false;
	                this.refreshPromotion(payload.Context);
	                break;

	            case PromotionActionConstants.PROMOTION_SET_FIELD:
	                if (action.payload.Id == this.Id) {
	                    var setter = this['set' + action.payload.fieldName];
	                    if (setter) {
	                        setter.call(this, action.payload.fieldValue);
	                        if (this.editMode) this.isKPIInvalid = true;
	                        this.changeHandler();
	                    } else {
	                        Log.error('No setter for field ' + action.payload.fieldName);
	                    }
	                }
	                break;

	            case PromotionActionConstants.TACTIC_SELECTED:
	                if (action.payload == null) {
	                    //PROMOTION SELECTED. Clear all filters
	                    this.resetAllFilters();
	                } else {
	                    //TACTIC SELECTED. Filter related collections
	                    this.setFilter(action.payload.Id);
	                }
	                this.changeHandler();
	                break;

	            case PromotionActionConstants.TACTIC_SET_FIELD:
	                if (action.payload.Id == this.LOTactic.getItems()[0].Id) {
	                    var tactic = this.LOTactic.getItems()[0];
	                    var setter = tactic['set' + action.payload.fieldName];
	                    if (setter) {
	                        setter.call(tactic, action.payload.fieldValue);
	                        this.changeHandler();
	                    } else {
	                        Log.error('No setter for tactic field ' + action.payload.fieldName);
	                    }
	                }
	                break;

	            case PromotionActionConstants.TACTIC_ADD:
	                this.addTactic(action.payload);
	                break;

	            case PromotionActionConstants.TACTIC_DUPLICATE:
	                this.duplicateTactic(action.payload);
	                break;

	            case PromotionActionConstants.TACTIC_DELETE:
	                this.deleteTactic(action.payload);
	                break;

	            case PromotionActionConstants.APPLY_PRODUCT_FILTER:
	                this.applyProductFilter(action.payload.tacticId, action.payload.productFilter);

	                break;

	            case PromotionActionConstants.SEARCH_FOR_PRODUCTS:
	                this.searchForProducts(action.payload);
	                break;

	            case PromotionActionConstants.CLEAR_SEARCH_FOR_PRODUCTS:
	                this.LOFilteredProducts.removeAllItems();
	                UI_EVENT_BUS.put(EVENTS.UI_BINDING, { productSearch: [] });
	                break;

	            case PromotionActionConstants.ADD_PRODUCTS:
	                this.addProductsFilter(action.payload.tacticId, action.payload.products);
	                break;

	            case PromotionActionConstants.SEARCH_FOR_FUNDS:
	                if (this.LOFilteredFunds.getCount() == 0) {
	                    //Just load funds once
	                    //this.LOFilteredFunds.load(this.serializePromotion());
	                    this.LOFilteredFunds.apex_read(JSON.stringify(this.serializePromotion())).then(function (fundList) {
	                        // UI_EVENT_BUS.put(EVENTS.UI_BINDING, {productSearch: productList.data});
	                        _this13.LOFilteredFunds.removeAllItems();
	                        _this13.LOFilteredFunds.addItems(fundList.data);
	                        UI_EVENT_BUS.put(EVENTS.UI_BINDING, { selectedTactic: _this13.serializeSelectedTactic() });
	                    });
	                }
	                UI_EVENT_BUS.put(EVENTS.UI_BINDING, { selectedTactic: this.serializeSelectedTactic() });

	                break;

	            case PromotionActionConstants.ADD_FUNDS:
	                this.addFunds(action.payload.funds, action.payload.tacticId);
	                this.changeHandler();
	                break;

	            case PromotionActionConstants.DELETE_FUNDS:
	                this.deleteFunds(action.payload.fundsId, action.payload.tacticId);
	                this.changeHandler();
	                break;

	            case PromotionActionConstants.TOGGLE_TACTIC_PRODUCT_FILTER:
	                this.toggleTacticProductFilter(action.payload.filterId, action.payload.filterValueId, action.payload.tactic, action.payload.selected);
	                UI_EVENT_BUS.put(EVENTS.UI_BINDING, { productFilters: this.serializeProductFilters() });
	                break;

	            case PromotionActionConstants.CHANGE_TACTIC_PRODUCT_RELATIONSHIP:
	                if (action.payload.tacticId == this.LOTacticProductFilter.getItems()[0].tacticId) {
	                    //Let's update the tactic productFilter
	                    _.find(this.LOTactic.getItems(), { Id: action.payload.tacticId }).objectStatus |= STATE.DIRTY;
	                    var productfilter = this.LOTacticProductFilter.getItems()[0].productfilter;
	                    if (!productfilter['manualproducts']) productfilter.manualproducts = [];
	                    if (action.payload.relationship == 'MATCH') {
	                        productfilter.manualproducts.push({ productid: action.payload.productId, included: false });
	                    } else if (action.payload.relationship == 'EXCLUDED' || action.payload.relationship == 'INCLUDED') {
	                        //Remove from collection
	                        _.remove(productfilter.manualproducts, { productid: action.payload.productId });
	                    }

	                    //Now let's update the LOExtProduct
	                    var product = _.find(this.LOExtProduct.getItems(), { Id: action.payload.productId });
	                    var tactic_relationship = _.find(product.Tactics, { tacticId: action.payload.tacticId });
	                    if (action.payload.relationship == 'MATCH') {
	                        tactic_relationship.relationship = 'EXCLUDED';
	                    } else if (action.payload.relationship == 'EXCLUDED') {
	                        tactic_relationship.relationship = 'MATCH';
	                    } else if (action.payload.relationship == 'INCLUDED') {
	                        tactic_relationship.relationship = 'DELETED';
	                    }
	                }
	                console.log('CHANGE_TACTIC_PRODUCT_RELATIONSHIP');
	                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {
	                    promotion: this.serializeTree(),
	                    selectedTactic: this.serializeSelectedTactic(),
	                    productFilters: this.serializeProductFilters()
	                });
	                break;
	            default:
	                Utils.callCustomFunction(this, 'onDispatcher', null, action);
	                break;
	        }
	    }
	};

		module.exports = Promotion;

/***/ },
/* 43 */
/***/ function(module, exports) {

	"use strict";

	var Tactic = {
	    getProducts: function getProducts() {},

	    getProductGroups: function getProductGroups() {},

	    onLoad: function onLoad() {
	        var tacticmap = {};

	        _.each(this.getAllItems(), function (item) {
	            tacticmap[item.Id] = item.Id;
	            tacticmap[item.Id.substring(0, 15)] = item.Id;
	        });

	        this._hidden.idMapping = tacticmap;
	    }
	};

		module.exports = Tactic;

/***/ },
/* 44 */
/***/ function(module, exports) {

	'use strict';

	var DSTacticProductFilter = {
	    'Type': 'DataSource',
	    'Name': 'DSTacticProductFilter',
	    'IsExternal': true,
	    'SFObject': null,
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }]
	};

		module.exports = DSTacticProductFilter;

/***/ },
/* 45 */
/***/ function(module, exports) {

	"use strict";

	var ExtProduct = {
	    addLabels: function addLabels(gridLabels) {
	        _.merge(this._hidden.idToLabelMapping, gridLabels);
	    },

	    getLabel: function getLabel(labelId) {
	        return this._hidden.idToLabelMapping[labelId];
	    },

	    onLoad: function onLoad() {
	        var labels = {
	            /* "BaselineVolume":"Baseline",
	             "PhasedBaseVolume":"Phased Base Volume",
	             "incrVolume":"Incremental Volume",
	             "incrVolumeOverride":"Incremental Volume  Override",
	             "incrVolumeEffective":"Incremental Volume  Effective",
	             "TotalVolume":"Total Plan Volume",
	             "TacticBaseline":"Tactic Baseline needed for Lift Calculation",
	             "TotalTacticCosts":"Total Cost",
	             "GSV":"GSV",
	             "Start or end week":"Start or end week",
	             "Tax":"Tax",
	             "Revenue":"Revenue",
	             "IncRevenue":"Incremental Revenue",
	             "ROI":"ROI",
	             "ActualizedVSPlannedCost":"Actualized VS Planned Costs",
	             "ShipmentCY":"Actual ShipmentsCurrent Year",
	             "FixedActualizedCost":"Fixed Actualized Cost",
	             "AcutalizedCost":"Actualized Cost"*/
	        };

	        _.each(this.getAllItems(), function (item) {
	            if (item.Short_Description != undefined) labels[item.Id] = item.Short_Description;else labels[item.Id] = item.description;

	            if (item.ProductGroupDescription != null && item.ProductGroupDescription.trim().length > 0) labels[item.ProductGroupId] = item.ProductGroupDescription;else labels[item.ProductGroupId] = "Default";
	        });

	        var me = this;
	        _.each(this._parent.LOTactic.getAllItems(), function (item) {
	            var tacticTemplate = _.find(me._parent.LOTactic_Template.getAllItems(), { Id: item.Tactic_Template__c });
	            var name = tacticTemplate != undefined ? tacticTemplate.Name : "";
	            labels[item.Id] = name;
	        });

	        this._hidden.idToLabelMapping = labels;
	    }
	};

		module.exports = ExtProduct;

/***/ },
/* 46 */
/***/ function(module, exports) {

	'use strict';

	module.exports = {
	    'Type': 'BusinessObject',
	    'Name': 'BOCalendarPromotion',
	    'SFObject': null,
	    'DataSource': 'DSCalendarPromotion',
	    'BaseClass': 'CalendarPromotion',
	    'IdAttribute': 'Id',
	    'Properties': [], // Properties are not explitely defined in release 3
	    'ListObjects': [{ 'Name': 'LOAccount' }],
	    'Methods': [{ 'Name': 'onInstantiate' }, { 'Name': 'afterInstantiate' }, { 'Name': 'onDispatcher' }, { 'Name': 'preLoad' }, { 'Name': 'postLoad' }, { 'Name': 'serializeCalendar' }]
		};

/***/ },
/* 47 */
/***/ function(module, exports) {

	'use strict';

	module.exports = {
	    'Type': 'DataSource',
	    'Name': 'DSCalendarPromotion',
	    'IsExternal': true,
	    'SFObject': null,
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Available': true }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }]
		};

/***/ },
/* 48 */
/***/ function(module, exports) {

	"use strict";

	var Localization = {
	    'labels': {
	        "PP_BTN_SEARCH": "Search",
	        "PP_BTN_EDIT": "Edit",
	        "PP_LBL_TACTIC": "Tactic",
	        "PP_BTN_DUPLICATE": "Duplicate",
	        "PP_BTN_DELETE": "Delete",
	        "PP_BTN_SAVE_REFRESH": "Save & Refresh",
	        "PP_BTN_DONE": "Done",
	        "PP_BTN_CANCEL": "Cancel",
	        "PP_BTN_OK": "Ok",
	        "PP_BTN_ADD": "Add",
	        "PP_TIT_PROD_LOOKUP": "Product Lookup",
	        //"PP_LBL_TACTIC_NAME": "Tactic Name",
	        //"PP_LBL_PCT_STORES": "% Stores",
	        //"PP_LBL_LIFT": "Lift %",
	        //"PP_LBL_AMOUNT": "Amount",
	        //"PP_LBL_COST_METHOD": "Costing Method",
	        "PP_LBL_NODATA": "No data",
	        "PP_TIT_KPI": "KPIs",
	        "PP_TIT_MEASURE": "Measure",
	        "PP_LBL_PLANNED": "Planned",
	        "PP_TIT_CHART_VOLUME_VS_BASELINE": "Planned Tactic Volume vs. Baseline",
	        "PP_TIT_CHART_INCREMENTAL_COSTS": "Incremental Costs (Tactic)",
	        "PP_TIT_CHART_INCREMENTAL_SALES": "Incremental Sales (Tactic)",
	        "PP_TIT_CHART_ROI": "ROI",
	        "PP_TIT_CHART_COSTS": "COSTS",
	        "PP_TIT_NOCONTENT": "NO CONTENT",
	        "PP_LBL_MAIN_INFO": "Main Information",
	        "PP_LBL_DATES": "Dates",
	        "PP_LBL_DURATION": "Duration",
	        "PP_LBL_STATUS": "Status",
	        "PP_BTN_APPLY_FILTER": "Apply Filter",
	        "PP_TIT_TACTIC_INFO": "Tactic Information",
	        "PP_BTN_MANAGE_PRODS": "Manage Products",
	        "PP_TIT_PROMO_SUMMARY": "Promotion Summary",
	        "PP_LBL_NO_FUNDS": "No Funds associated to this tactic",
	        "PP_TIT_FUND_LOOKUP": "Fund Lookup",
	        //"PP_LBL_TACTICS": "Tactics", //Missing
	        "PP_LBL_PRODUCT_GROUPS": "Product Groups",
	        "PP_LBL_PRODUCTS": "Products",
	        "PP_LBL_SELECT": "Select",
	        "PP_LBL_INCLUDED": "Included"
	        /*,
	        "PP_LBL_MODAL_MSG": "Sit nulla est ex deserunt exercitation anim occaecat. Nostrud ullamco deserunt aute id consequat veniam incididunt duis in sint irure nisi.",
	        "PC_TIT_EDIT_SETTINGS": "Edit your Settings",
	        "PC_BTN_CONTINUE": "Continue anyways",
	        "PC_BTN_SAVE": "Save",
	        "PC_TIT_TRADE_CALENDAR": "Trade calendar",
	        "PC_LBL_INIT_CALENDAR_MSG_1": "Hi, your user settings haven\"t completed yet. ",
	        "PC_LBL_INIT_CALENDAR_MSG_2": " To avoid longer loading times, please fill them in before you continue.",
	        "PC_LBL_CUSTOMER": "Customer",
	        "PC_LBL_CUSTOMER_NAME": "Customer name",
	        "PC_LBL_ANCHOR_CUSTOMER": "Anchor Customer",
	        "PC_LBL_ANCHOR_CUSTOMER_SET": "Anchor Customer Set",
	        "PC_LBL_PROMOTION_TYPE": "Promotion type",
	        "PC_LBL_PROMOTION_TEMPLATE": "Promotion Template",
	        "PC_LBL_PRODUCT_CATEGORY": "Product category",
	        "PC_LBL_TACTIC_TYPE": "Tactic type",
	        "PC_LBL_NEW": "New ",
	        "PC_LBL_LOADING_CONTENT": "Loading content...",
	        "PC_LBL_FROM_THRU": "FROM/THRU",
	        "PC_LBL_STATUS": "STATUS",
	        "PC_LBL_ANCHOR": "ANCHOR",
	        "PC_LBL_TACTICS_FROM_THRU": "TACTICS FROM/THRU",
	        "PC_BTN_OPEN": "Open",
	        "PC_BTN_DERIVE": "Derive",
	        "PC_BTN_DELETE": "Delete",
	        "PC_LBL_JANUARY": "January",
	        "PC_LBL_FEBRUARY": "February",
	        "PC_LBL_MARCH": "March",
	        "PC_LBL_APRIL": "April",
	        "PC_LBL_MAY": "May",
	        "PC_LBL_JUNE": "June",
	        "PC_LBL_JULY": "July",
	        "PC_LBL_AUGUST": "August",
	        "PC_LBL_SEPTEMBER": "September",
	        "PC_LBL_OCTOBER": "October",
	        "PC_LBL_NOVEMBER": "November",
	        "PC_LBL_DECEMBER": "December",
	        "PC_TIT_ACCOUNTS": "Accounts",
	        "PC_TIT_PROMOTIONS": "Promotions",
	        "PC_TIT_PRODUCTS": "Products",
	        "PC_BTN_ADD_FILTER": "Add Filter",
	        "PC_LBL_FIELD": "Field",
	        "PC_LBL_VALUE": "Value",
	        "PC_LBL_VALUES_SELECTED": "values selected",
	        "PC_LBL_FILTERS": "Filters",
	        "PC_LBL_DAYS": "Days",
	        "PC_LBL_WEEKS": "Weeks",
	        "PC_LBL_MONTHS": "Months",
	        "PC_LBL_SLOGAN": "Slogan",
	        "PC_LBL_START": "Start",
	        "PC_LBL_TEMPLATE": "Template",
	        "PC_LBL_SELECT": "Select"*/
	    },
	    'dateformats': {
	        "ar-SA": "DD/MM/yy",
	        "bg-BG": "DD.M.YYYY",
	        "ca-ES": "DD/MM/YYYY",
	        "zh-TW": "YYYY/M/d",
	        "cs-CZ": "DD.M.YYYY",
	        "da-DK": "DD-MM-YYYY",
	        "de-DE": "DD.MM.YYYY",
	        "el-GR": "DD/M/YYYY",
	        "en-US": "MM/DD/YYYY",
	        "fi-FI": "DD.M.YYYY",
	        "fr-FR": "DD/MM/YYYY",
	        "he-IL": "DD/MM/YYYY",
	        "hu-HU": "YYYY. MM. DD.",
	        "is-IS": "DD.M.YYYY",
	        "it-IT": "DD/MM/YYYY",
	        "ja-JP": "YYYY/MM/DD",
	        "ko-KR": "YYYY-MM-DD",
	        "nl-NL": "d-M-YYYY",
	        "nb-NO": "DD.MM.YYYY",
	        "pl-PL": "YYYY-MM-DD",
	        "pt-BR": "DD/M/YYYY",
	        "ro-RO": "DD.MM.YYYY",
	        "ru-RU": "DD.MM.YYYY",
	        "hr-HR": "DD.M.YYYY",
	        "sk-SK": "DD. M. YYYY",
	        "sq-AL": "YYYY-MM-DD",
	        "sv-SE": "YYYY-MM-DD",
	        "th-TH": "DD/M/YYYY",
	        "tr-TR": "DD.MM.YYYY",
	        "ur-PK": "DD/MM/YYYY",
	        "id-ID": "DD/MM/YYYY",
	        "uk-UA": "DD.MM.YYYY",
	        "be-BY": "DD.MM.YYYY",
	        "sl-SI": "DD.M.YYYY",
	        "et-EE": "DD.MM.YYYY",
	        "lv-LV": "YYYY.MM.DD.",
	        "lt-LT": "YYYY.MM.DD",
	        "fa-IR": "MM/DD/YYYY",
	        "vi-VN": "DD/MM/YYYY",
	        "hy-AM": "DD.MM.YYYY",
	        "az-Latn-AZ": "DD.MM.YYYY",
	        "eu-ES": "YYYY/MM/DD",
	        "mk-MK": "DD.MM.YYYY",
	        "af-ZA": "YYYY/MM/DD",
	        "ka-GE": "DD.MM.YYYY",
	        "fo-FO": "DD-MM-YYYY",
	        "hi-IN": "DD-MM-YYYY",
	        "ms-MY": "DD/MM/YYYY",
	        "kk-KZ": "DD.MM.YYYY",
	        "ky-KG": "DD.MM.yy",
	        "sw-KE": "MM/DD/YYYY",
	        "uz-Latn-UZ": "DD/MM YYYY",
	        "tt-RU": "DD.MM.YYYY",
	        "pa-IN": "DD-MM-yy",
	        "gu-IN": "DD-MM-yy",
	        "ta-IN": "DD-MM-YYYY",
	        "te-IN": "DD-MM-yy",
	        "kn-IN": "DD-MM-yy",
	        "mr-IN": "DD-MM-YYYY",
	        "sa-IN": "DD-MM-YYYY",
	        "mn-MN": "yy.MM.DD",
	        "gl-ES": "DD/MM/yy",
	        "kok-IN": "DD-MM-YYYY",
	        "syr-SY": "DD/MM/YYYY",
	        "dv-MV": "DD/MM/yy",
	        "ar-IQ": "DD/MM/YYYY",
	        "zh-CN": "YYYY/M/d",
	        "de-CH": "DD.MM.YYYY",
	        "en-GB": "DD/MM/YYYY",
	        "es-MX": "DD/MM/YYYY",
	        "fr-BE": "DD/MM/YYYY",
	        "it-CH": "DD.MM.YYYY",
	        "nl-BE": "DD/MM/YYYY",
	        "nn-NO": "DD.MM.YYYY",
	        "pt-PT": "DD-MM-YYYY",
	        "sr-Latn-CS": "DD.M.YYYY",
	        "sv-FI": "DD.M.YYYY",
	        "az-Cyrl-AZ": "DD.MM.YYYY",
	        "ms-BN": "DD/MM/YYYY",
	        "uz-Cyrl-UZ": "DD.MM.YYYY",
	        "ar-EG": "DD/MM/YYYY",
	        "zh-HK": "DD/M/YYYY",
	        "de-AT": "DD.MM.YYYY",
	        "en-AU": "DD/MM/YYYY",
	        "es-ES": "DD/MM/YYYY",
	        "fr-CA": "YYYY-MM-DD",
	        "sr-Cyrl-CS": "DD.M.YYYY",
	        "ar-LY": "DD/MM/YYYY",
	        "zh-SG": "DD/M/YYYY",
	        "de-LU": "DD.MM.YYYY",
	        "en-CA": "DD/MM/YYYY",
	        "es-GT": "DD/MM/YYYY",
	        "fr-CH": "DD.MM.YYYY",
	        "ar-DZ": "DD-MM-YYYY",
	        "zh-MO": "DD/M/YYYY",
	        "de-LI": "DD.MM.YYYY",
	        "en-NZ": "DD/MM/YYYY",
	        "es-CR": "DD/MM/YYYY",
	        "fr-LU": "DD/MM/YYYY",
	        "ar-MA": "DD-MM-YYYY",
	        "en-IE": "DD/MM/YYYY",
	        "es-PA": "MM/DD/YYYY",
	        "fr-MC": "DD/MM/YYYY",
	        "ar-TN": "DD-MM-YYYY",
	        "en-ZA": "YYYY/MM/DD",
	        "es-DO": "DD/MM/YYYY",
	        "ar-OM": "DD/MM/YYYY",
	        "en-JM": "DD/MM/YYYY",
	        "es-VE": "DD/MM/YYYY",
	        "ar-YE": "DD/MM/YYYY",
	        "en-029": "MM/DD/YYYY",
	        "es-CO": "DD/MM/YYYY",
	        "ar-SY": "DD/MM/YYYY",
	        "en-BZ": "DD/MM/YYYY",
	        "es-PE": "DD/MM/YYYY",
	        "ar-JO": "DD/MM/YYYY",
	        "en-TT": "DD/MM/YYYY",
	        "es-AR": "DD/MM/YYYY",
	        "ar-LB": "DD/MM/YYYY",
	        "en-ZW": "MM/DD/YYYY",
	        "es-EC": "DD/MM/YYYY",
	        "ar-KW": "DD/MM/YYYY",
	        "en-PH": "MM/DD/YYYY",
	        "es-CL": "DD-MM-YYYY",
	        "ar-AE": "DD/MM/YYYY",
	        "es-UY": "DD/MM/YYYY",
	        "ar-BH": "DD/MM/YYYY",
	        "es-PY": "DD/MM/YYYY",
	        "ar-QA": "DD/MM/YYYY",
	        "es-BO": "DD/MM/YYYY",
	        "es-SV": "DD/MM/YYYY",
	        "es-HN": "DD/MM/YYYY",
	        "es-NI": "DD/MM/YYYY",
	        "es-PR": "DD/MM/YYYY",
	        "am-ET": "DD/M/YYYY",
	        "tzm-Latn-DZ": "DD-MM-YYYY",
	        "iu-Latn-CA": "DD/MM/YYYY",
	        "sma-NO": "DD.MM.YYYY",
	        "mn-Mong-CN": "YYYY/M/d",
	        "gd-GB": "DD/MM/YYYY",
	        "en-MY": "DD/M/YYYY",
	        "prs-AF": "DD/MM/yy",
	        "bn-BD": "DD-MM-yy",
	        "wo-SN": "DD/MM/YYYY",
	        "rw-RW": "MM/DD/YYYY",
	        "qut-GT": "DD/MM/YYYY",
	        "sah-RU": "MM.DD.YYYY",
	        "gsw-FR": "DD/MM/YYYY",
	        "co-FR": "DD/MM/YYYY",
	        "oc-FR": "DD/MM/YYYY",
	        "mi-NZ": "DD/MM/YYYY",
	        "ga-IE": "DD/MM/YYYY",
	        "se-SE": "YYYY-MM-DD",
	        "br-FR": "DD/MM/YYYY",
	        "smn-FI": "DD.M.YYYY",
	        "moh-CA": "MM/DD/YYYY",
	        "arn-CL": "DD-MM-YYYY",
	        "ii-CN": "YYYY/M/d",
	        "dsb-DE": "DD. M. YYYY",
	        "ig-NG": "DD/M/YYYY",
	        "kl-GL": "DD-MM-YYYY",
	        "lb-LU": "DD/MM/YYYY",
	        "ba-RU": "DD.MM.yy",
	        "nso-ZA": "YYYY/MM/DD",
	        "quz-BO": "DD/MM/YYYY",
	        "yo-NG": "DD/M/YYYY",
	        "ha-Latn-NG": "DD/M/YYYY",
	        "fil-PH": "MM/DD/YYYY",
	        "ps-AF": "DD/MM/yy",
	        "fy-NL": "d-M-YYYY",
	        "ne-NP": "MM/DD/YYYY",
	        "se-NO": "DD.MM.YYYY",
	        "iu-Cans-CA": "DD/M/YYYY",
	        "sr-Latn-RS": "DD.M.YYYY",
	        "si-LK": "YYYY-MM-DD",
	        "sr-Cyrl-RS": "DD.M.YYYY",
	        "lo-LA": "DD/MM/YYYY",
	        "km-KH": "YYYY-MM-DD",
	        "cy-GB": "DD/MM/YYYY",
	        "bo-CN": "YYYY/M/d",
	        "sms-FI": "DD.M.YYYY",
	        "as-IN": "DD-MM-YYYY",
	        "ml-IN": "DD-MM-yy",
	        "en-IN": "DD-MM-YYYY",
	        "or-IN": "DD-MM-yy",
	        "bn-IN": "DD-MM-yy",
	        "tk-TM": "DD.MM.yy",
	        "bs-Latn-BA": "DD.M.YYYY",
	        "mt-MT": "DD/MM/YYYY",
	        "sr-Cyrl-ME": "DD.M.YYYY",
	        "se-FI": "DD.M.YYYY",
	        "zu-ZA": "YYYY/MM/DD",
	        "xh-ZA": "YYYY/MM/DD",
	        "tn-ZA": "YYYY/MM/DD",
	        "hsb-DE": "DD. M. YYYY",
	        "bs-Cyrl-BA": "DD.M.YYYY",
	        "tg-Cyrl-TJ": "DD.MM.yy",
	        "sr-Latn-BA": "DD.M.YYYY",
	        "smj-NO": "DD.MM.YYYY",
	        "rm-CH": "DD/MM/YYYY",
	        "smj-SE": "YYYY-MM-DD",
	        "quz-EC": "DD/MM/YYYY",
	        "quz-PE": "DD/MM/YYYY",
	        "hr-BA": "DD.M.YYYY.",
	        "sr-Latn-ME": "DD.M.YYYY",
	        "sma-SE": "YYYY-MM-DD",
	        "en-SG": "DD/M/YYYY",
	        "ug-CN": "YYYY-M-d",
	        "sr-Cyrl-BA": "DD.M.YYYY",
	        "es-US": "MM/DD/YYYY"
	    }
	};

		module.exports = Localization;

/***/ },
/* 49 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var moment = __webpack_require__(50);
	var ExtPromotionCalendar = {
	    /**
	     * The onInstantiate function is call once when the BO is ready for user
	     * @returns {Promise[]} Array of promises created by asynchronous load of data
	     */
	    // Core functionality - DO NOT CHANGE THE CONTENT OF THIS FUNCTION DURING CUSTOMIZING!
	    onInstantiate: function onInstantiate() {
	        var me = this;
	        var instantiatePromises = []; // when.defer();
	        this.fluxHandler = UI_EVENT_BUS.subscribe(EVENTS.FLUX, this.onDispatcher.bind(this));
	        UI_EVENT_BUS.subscribe(EVENTS.UI_ERROR, this.onUIError.bind(this));

	        instantiatePromises = this.preLoad();

	        return instantiatePromises;
	    },
	    /**
	     * Load all data which must be available before the UI is rendered. 
	     * The promises as returned by this function are handled in a synchronous way. Only once all of them are resolved the system continues.
	     * Customization points:
	     *  - Before the array of promises is returned. The project can use that to add additonal LOs
	     * @returns {Promise[]} Array of promises created by asynchronous load of data
	     */
	    preLoad: function preLoad() {
	        var me = this;
	        var instantiatePromises = []; // when.defer();
	        var loadParams = { 'readAll': true };

	        this.modalMessages = [];

	        instantiatePromises.push(this.LOTactic_Template.load(null, loadParams));
	        instantiatePromises.push(this.LOPromotion_Template.load(null, loadParams));
	        instantiatePromises.push(this.LOAccount.load(null, loadParams));
	        instantiatePromises.push(this.LOExtPrdFilters.load());
	        instantiatePromises.push(this.LOCalendarView.load());

	        var fiscalYearLoadParams = { "Reference_Date": new Date().getTime() };

	        instantiatePromises.push(this.LOExtFiscalYear.load(null, fiscalYearLoadParams));

	        return Utils.callCustomFunction(this, 'preLoad', null, instantiatePromises);
	    },
	    /**
	     * Loads all data which is not needed immediately for rendering the UI.
	     * The returned promises will be resolved asynchronously while the UI is already usable.
	     * Customization points:
	     *  - Before the processing is done. The project can use that to make adaptions based on the loaded data or to load additional LOs
	     * @returns {Promise[]} Array of promises created by asynchronous load of data
	     */
	    postLoad: function postLoad() {
	        var me = this;
	        var instantiatePromises = [];
	        //apply active filter and Creation_Platform__c<>Mobility 
	        this.LOPromotion_Template.setFilterArray([{ "Active__c": true, "op": "EQ" }, { "Creation_Platform__c": "Mobility", "op": "NE" }]);
	        this.initDate = new Date(this.LOExtFiscalYear.getItems()[0].Date_From);
	        this.endDate = new Date(this.LOExtFiscalYear.getItems()[0].Date_Thru);
	        var loadParams = { 'readAll': true };
	        this.LOAccountSet.load(null, loadParams);
	        me.refreshCalendarView();
	        /*var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
	         var loadParams = {"Date_From": this.initDate.getTime(), "Date_Thru": this.endDate.getTime()};
	         loadParams.CalendarView = (calendarView!=null)?calendarView.serialize():'';
	         instantiatePromises.push(this.LOCalPromotions.load(null, loadParams));
	         instantiatePromises.push(this.LOAccountSet.load(null, {'readAll': true}));
	           when.all(instantiatePromises).then(x=> {
	         me.refreshCalLegend();
	         me.serializeCalendar();
	         });*/

	        Utils.callCustomFunction(this, 'postLoad', null);
	    },
	    /**
	     * Anchor for the postLoad function
	     * Content is moved to postLoad since it may be called several times which would not match the purpose of this function
	     */
	    afterInstantiate: function afterInstantiate() {
	        this.postLoad();
	    },

	    refreshCalLegend: function refreshCalLegend() {
	        var _this = this;

	        this.LOExtCalLegend.removeAllItems();
	        var uniqueTemplates = _.uniq(this.LOCalPromotions.getAllItems().map(function (item) {
	            return item.Promotion_Template;
	        }));
	        var legendItems = [];
	        uniqueTemplates.forEach(function (promoTemplateId) {
	            var promoTemplate = _.find(_this.LOPromotion_Template.getAllItems(), { Id: promoTemplateId });
	            var promoSample = _.find(_this.LOCalPromotions.getAllItems(), { Promotion_Template: promoTemplateId });
	            var liCallLegend = {
	                'Id': promoTemplate.getId(),
	                'Name': promoTemplate.Description__c,
	                'Commit_Color': promoSample.Commit_Color
	            };

	            legendItems.push(liCallLegend);

	            //  this.LOExtCalLegend.addItem(liCallLegend);
	        });
	        legendItems = _.sortBy(legendItems, 'Name');
	        this.LOExtCalLegend.addItems(legendItems);
	    },

	    refreshCalendarView: function refreshCalendarView() {
	        var _this2 = this;

	        var me = this;
	        // var calendarView = this.LOCalendarView.getItems()[0];
	        var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
	        if (calendarView != null) {

	            var loadParams = { "Date_From": this.initDate.getTime(), "Date_Thru": this.endDate.getTime() };
	            loadParams.CalendarView = calendarView != null ? calendarView.serialize() : '';
	            this.LOCalPromotions.removeAllItems();

	            this.LOCalPromotions.load(null, loadParams).then(function (x) {
	                _this2.refreshCalLegend();
	                _this2.serializeCalendar();
	            });
	        } else this.serializeCalendar();
	    },

	    updateCalendarView: function updateCalendarView(uiView) {
	        var _this3 = this;

	        var me = this;
	        //var calendarView = this.LOCalendarView.getItems()[0];
	        var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
	        if (!calendarView) {
	            //There is no calendar view so we have to create an empty one
	            var LICalendarView = {
	                'Id': '',
	                'Name': 'Default View',
	                'Description': 'Default View',
	                'IsDefault': true,
	                'FilterCriteria': {
	                    "accountfilter": {
	                        "criteria": {
	                            "account_id__c": []
	                        }
	                    },
	                    "promotionfilter": {
	                        "criteria": {
	                            "promotion_template__c": [],
	                            "tactic_template__c": []

	                        }
	                    },
	                    "productfilter": {
	                        "criteria": {
	                            "category__c": []
	                        }
	                    }

	                }
	            };

	            this.LOCalendarView.addItem(LICalendarView);
	            calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
	        }

	        calendarView.objectStatus |= STATE.DIRTY;
	        var filterCriteria = calendarView.FilterCriteria;
	        if (uiView != null) {
	            //If it is null we maintain an empty initial view (user clicked the Continue Anyways button)
	            Object.keys(filterCriteria).forEach(function (c) {
	                var uiCriteria = uiView[c];
	                var viewCriteria = filterCriteria[c].criteria;
	                uiCriteria.forEach(function (field) {
	                    viewCriteria[field.fieldId] = _.filter(field.values, { Selected: true }).reduce(function (r, v) {
	                        r.push(v.Id);
	                        return r;
	                    }, []);
	                });
	            });
	        }

	        this.refreshCalendarView();
	        this.LOCalendarView.apex_write(calendarView.Id, JSON.stringify(calendarView.serialize())).then(function (result) {
	            if (result.__Status) {
	                var viewId = result.data.Id;
	                var calendarView = _.find(_this3.LOCalendarView.getAllItems(), 'IsDefault');
	                calendarView.Id = viewId;
	            }
	        });
	    },

	    /**
	     * This method is called after the user creates a new promotion through the UI wizard.
	     * It creates a valid promotion object by calling the APEX backend. The result will be added to LOCalPromotions.
	     * Customization points:
	     *  - beforeAPEX - Parameter for APEX call is assembled and can be adapted
	     *  - afterAPEX - Data for new promotion was received from APEX. Can be adapted before it is applied
	     * @param {JSON} promotion - Promotion content as created by the UI through the wizard
	     */
	    addPromotion: function addPromotion(promotion) {
	        var _this4 = this;

	        this.logger.info('Adding Promotion');
	        var Date_Thru__c = new Date(promotion.Date_From__c);
	        var Date_From__c = new Date(promotion.Date_From__c);
	        switch (promotion.period) {
	            case "day":
	                Date_Thru__c = moment.utc(Date_From__c.getTime()).add(promotion.duration, 'Day').add(-1, 'Day').toDate();
	                break;
	            case "week":
	                Date_Thru__c = moment.utc(Date_From__c.getTime()).add(promotion.duration, 'Week').add(-1, 'Day').toDate();
	                break;

	            case "month":
	                Date_Thru__c = moment.utc(Date_From__c.getTime()).add(promotion.duration, 'Month').add(-1, 'Day').toDate();
	                break;
	        }
	        var promoObject = {
	            "Phase__c": "Planning",
	            "Anchor_Account__c": promotion.account,
	            "Anchor_Account_Set__c": promotion.accountSet,
	            "Promotion_Template__c": promotion.promotion_template.Id,
	            "Slogan_Language_1__c": promotion.Slogan__c,
	            "Date_From__c": Date_From__c.getTime(),
	            "Date_Thru__c": Date_Thru__c.getTime()
	        };

	        promoObject = Utils.callCustomFunction(this, 'addPromotion', 'beforeAPEX', promoObject);
	        var win = self.open('');
	        this.LOCalPromotions.apex_create(JSON.stringify(promoObject)).then(function (result) {
	            if (result.__Status) {
	                //     this.LOCalPromotions.addItem(result.data);
	                result.data = Utils.callCustomFunction(_this4, 'addPromotion', 'afterAPEX', result.data);
	                _this4.refreshCalendarView();
	                Utils.HTTP.navigateTo(_this4.getPromotionPlanningPageReference(), { id: result.data }, { newTab: true }, win);
	                //self.open(promotionPath + '?id=' + result.data);
	            }
	        });
	    },

	    /**
	     * Serialize the BO content into a JSON object and send it through the event bus to the UI.
	     * The UI will then refresh the components depending on this data.
	     * Customization points:
	     *  - before the UI is refreshed, the serialized object can be adapted
	     */
	    serializeCalendar: function serializeCalendar() {
	        var me = this;
	        var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');

	        var serialzeProductFilter = function serialzeProductFilter(fieldId) {
	            return {
	                fieldId: fieldId,
	                label: _.find(me.LOExtPrdFilters.getAllItems(), { filterId: fieldId }).filterLabel,
	                values: _.filter(me.LOExtPrdFilters.getAllItems(), { filterId: fieldId }).reduce(function (result, item) {
	                    result.push({
	                        Label: item.filterValueLabel,
	                        Id: item.filterValueId,
	                        Selected: calendarView != null && calendarView.FilterCriteria.productfilter.criteria[fieldId] && calendarView.FilterCriteria.productfilter.criteria[fieldId].indexOf(item.filterValueId) != -1
	                    });
	                    return result;
	                }, [])
	            };
	        };

	        var calendar = {
	            initDate: this.initDate,
	            endDate: this.endDate,
	            showInitialSettings: calendarView == null,
	            isFilterSet: true, //TODO
	            FilterCriteria: {
	                accountfilter: [{
	                    fieldId: 'account_id__c',
	                    label: AppManager.getLabel("PC_LBL_CUSTOMER_NAME") || 'Customer name',
	                    values: this.LOAccount.getAllItems().reduce(function (result, acc) {
	                        result.push({
	                            Label: acc.Name,
	                            Id: acc.Id,
	                            Selected: calendarView != null && calendarView.FilterCriteria.accountfilter.criteria.account_id__c.indexOf(acc.Id) != -1
	                        });
	                        return result;
	                    }, [])
	                }],
	                promotionfilter: [{
	                    fieldId: 'promotion_template__c',
	                    label: AppManager.getLabel("PC_LBL_PROMOTION_TYPE") || 'Promotion type',
	                    values: this.LOPromotion_Template.getAllItems().reduce(function (result, promo) {
	                        result.push({
	                            Label: promo.Description__c,
	                            Id: promo.Id,
	                            Selected: calendarView != null && calendarView.FilterCriteria.promotionfilter.criteria.promotion_template__c.indexOf(promo.Id) != -1
	                        });
	                        return result;
	                    }, [])
	                }, {
	                    fieldId: 'tactic_template__c',
	                    label: AppManager.getLabel("PC_LBL_TACTIC_TYPE") || 'Tactic type',
	                    values: this.LOTactic_Template.getAllItems().reduce(function (result, tactic) {
	                        result.push({
	                            Label: tactic.Description__c,
	                            Id: tactic.Id,
	                            Selected: calendarView != null && calendarView.FilterCriteria.promotionfilter.criteria.tactic_template__c.indexOf(tactic.Id) != -1
	                        });
	                        return result;
	                    }, [])
	                }],
	                productfilter: []
	            },

	            accounts: this.LOAccount.getAllItems().reduce(function (result, acc) {
	                result.push({
	                    Label: acc.Name,
	                    Id: acc.Id
	                });
	                return result;
	            }, []),

	            accountSet: this.LOAccountSet.getAllItems().reduce(function (result, acc) {
	                result.push({
	                    Label: acc.Description__c,
	                    Id: acc.Id
	                });
	                return result;
	            }, []),

	            promotion_templates: this.LOPromotion_Template.getAllItems().reduce(function (result, promo) {
	                result.push({
	                    Label: promo.Description__c,
	                    Id: promo.Id,
	                    Anchor_Type: promo.Anchor_Type__c
	                });
	                return result;
	            }, []),

	            active_promotion_templates: this.LOPromotion_Template.getItems().reduce(function (result, promo) {
	                result.push({
	                    Label: promo.Description__c,
	                    Id: promo.Id,
	                    Anchor_Type: promo.Anchor_Type__c
	                });
	                return result;
	            }, []),

	            legend: this.LOExtCalLegend.getAllItems().reduce(function (result, legend) {
	                result.push({ Name: legend.Name, Commit_Color: legend.Commit_Color });
	                return result;
	            }, []),

	            periods: this.LOExtFiscalYear.getAllItems()[0].Periods, // TODO

	            promotions: this.LOCalPromotions.getAllItems().reduce(function (result, promo) {
	                result.push({
	                    'slogan': promo.Slogan,
	                    'Account_Name': promo.Account_Name || promo.Account_Set_Description,
	                    'Commit_Color': promo.Commit_Color,
	                    'Promotion_Template_Id': promo.Promotion_Template,
	                    'dates': promo.Promotions.reduce(function (r, v) {
	                        r.push({
	                            'Id': v.Id,
	                            'from': new Date(v.Date_From),
	                            'to': new Date(v.Date_Thru),
	                            'phase': v.Phase,
	                            'isReady': v.Phase == 'Committed'
	                        });

	                        return r;
	                    }, [])
	                });
	                return result;
	            }, [])
	        };

	        calendar.FilterCriteria.productfilter.push(serialzeProductFilter('category__c'));

	        calendar.isFilterSet = _.some(calendar.FilterCriteria.accountfilter[0].values, { Selected: true }) || _.some(calendar.FilterCriteria.promotionfilter[0].values, { Selected: true }) || _.some(calendar.FilterCriteria.promotionfilter[0].values, { Selected: true }) || _.some(calendar.FilterCriteria.productfilter[0].values, { Selected: true });

	        calendar = Utils.callCustomFunction(this, 'serializeToUI', null, calendar);

	        UI_EVENT_BUS.put(EVENTS.UI_BINDING, { calendar: calendar });
	    },

	    /**
	     * Get the visual force page reference to PromotionPlanning page. 
	     */
	    getPromotionPlanningPageReference: function getPromotionPlanningPageReference() {
	        return 'PromotionPlanning';
	    },
	    /**
	     * Serialize the content of the calendar to be sent as state to the React UI
	     */
	    serializeToUI: function serializeToUI() {
	        return this.serializeCalendar();
	    },

	    onUIError: function onUIError(message) {
	        var _this5 = this;

	        this.modalMessages.push(message);
	        AppManager.init().then(function () {
	            return UI_EVENT_BUS.put(EVENTS.UI_BINDING, { modalMessages: _this5.modalMessages });
	        });
	    },
	    onDispatcher: function onDispatcher(payload) {
	        var _this6 = this;

	        var action = payload;
	        var self = this;

	        switch (action.actionType) {
	            case PromCalendarActionConstants.CALENDAR_LOAD:
	                this.load();
	                break;

	            case PromCalendarActionConstants.ADD_PROMOTION:
	                console.log('Add Promotion');
	                this.addPromotion(action.payload);
	                break;

	            case PromCalendarActionConstants.PREVIOUS_PERIOD:
	                console.log('PREVIOUS_PERIOD Promotion');
	                var date_from = new Date(this.initDate);

	                date_from.setFullYear(this.initDate.getFullYear() - 1);

	                var loadParams = { "Reference_Date": date_from.getTime() };
	                this.LOExtFiscalYear.apex_read(loadParams).then(function (fiscalYear) {
	                    if (fiscalYear.__Status) {
	                        _this6.LOExtFiscalYear.removeAllItems();
	                        _this6.LOExtFiscalYear.addItem(fiscalYear.data[0]);
	                        _this6.initDate = new Date(fiscalYear.data[0].Date_From);
	                        _this6.endDate = new Date(fiscalYear.data[0].Date_Thru);
	                        _this6.refreshCalendarView();
	                    } else {
	                        alert('error moving to next period');
	                        _this6.refreshCalendarView();
	                    }
	                });
	                break;

	            case PromCalendarActionConstants.NEXT_PERIOD:
	                console.log('NEXT_PERIOD Promotion');

	                var date_from = new Date(this.initDate);

	                date_from.setFullYear(this.initDate.getFullYear() + 1);

	                var loadParams = { "Reference_Date": date_from.getTime() };
	                this.LOExtFiscalYear.apex_read(loadParams).then(function (fiscalYear) {
	                    if (fiscalYear.__Status) {
	                        _this6.LOExtFiscalYear.removeAllItems();
	                        _this6.LOExtFiscalYear.addItem(fiscalYear.data[0]);
	                        _this6.initDate = new Date(fiscalYear.data[0].Date_From);
	                        _this6.endDate = new Date(fiscalYear.data[0].Date_Thru);
	                        _this6.refreshCalendarView();
	                    } else {
	                        alert('error moving to next period');
	                        _this6.refreshCalendarView();
	                    }
	                });
	                break;

	            case PromCalendarActionConstants.CHANGE_FILTER:
	                console.log('CHANGE_FILTER Promotion');
	                this.updateCalendarView(action.payload);
	                _.assign(this, action.payload);

	                this.serializeCalendar();
	                break;
	            case PromCalendarActionConstants.CANCEL_CHANGE_FILTER:
	                console.log('Cancel CHANGE_FILTER Promotion');
	                this.serializeCalendar();
	                break;

	            case PromCalendarActionConstants.GET_PROMOTION_DETAIL:
	                console.log('GET_PROMOTION_DETAIL Promotion for promotion : ' + action.payload);
	                var promoDetail = _.find(this.LOExtHoverContent.getAllItems(), { promotionId: action.payload });
	                if (promoDetail) {

	                    var promotionDetail = {
	                        Id: promoDetail.promotionId,
	                        Tactics: promoDetail.content.Tactics.reduce(function (result, tactic) {
	                            result.push({
	                                'Id': tactic.Id,
	                                'Date_From': new Date(tactic.Date_From),
	                                'Date_Thru': new Date(tactic.Date_Thru),
	                                'Description': tactic.Description
	                            });
	                            return result;
	                        }, [])
	                    };

	                    UI_EVENT_BUS.put(EVENTS.UI_BINDING, { promotionDetailData: promotionDetail });
	                } else {
	                    this.LOExtHoverContent.apex_read({ "promotionId": action.payload }).then(function (detail) {
	                        _this6.LOExtHoverContent.addItem(detail.data[0]);
	                        var promotionDetail = {
	                            Id: detail.data[0].promotionId,
	                            Tactics: detail.data[0].content.Tactics.reduce(function (result, tactic) {
	                                result.push({
	                                    'Id': tactic.Id,
	                                    'Date_From': new Date(tactic.Date_From),
	                                    'Date_Thru': new Date(tactic.Date_Thru),
	                                    'Description': tactic.Description
	                                });
	                                return result;
	                            }, [])
	                        };

	                        UI_EVENT_BUS.put(EVENTS.UI_BINDING, { promotionDetailData: promotionDetail });
	                    });
	                }
	                break;

	            case PromCalendarActionConstants.OPEN_PROMOTION_DETAIL:
	                console.log('OPEN_PROMOTION_DETAIL Promotion for promotion : ' + action.payload);
	                //window.open(promotionPath + '?id=' + action.payload);
	                Utils.HTTP.navigateTo(this.getPromotionPlanningPageReference(), { id: action.payload });
	                break;

	            case PromCalendarActionConstants.DERIVE_PROMOTION_DETAIL:

	                console.log('DERIVE_PROMOTION_DETAIL Promotion for promotion : ' + action.payload);

	                this.LOCalPromotions.apex_derive(action.payload).then(function (result) {
	                    if (result.__Status) {
	                        Utils.HTTP.navigateTo(_this6.getPromotionPlanningPageReference(), { id: result.data.Promotions[0].Id }, { newTab: true });
	                        // self.open(promotionPath + '?id=' + result.data.Promotions[0].Id);
	                    }
	                });
	                /*UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
	                 title: 'Unavailable Functionality',
	                 message: 'Sorry, derive promotion functionality is not available yet.',
	                 type: 'E'
	                 });*/
	                break;

	            case PromCalendarActionConstants.COPY_PROMOTION_DETAIL:
	                this.LOCalPromotions.apex_copy(action.payload).then(function (result) {
	                    if (result.__Status) {
	                        Utils.HTTP.navigateTo(_this6.getPromotionPlanningPageReference(), { id: result.data.Promotions[0].Id });
	                        // self.open(promotionPath + '?id=' + result.data.Promotions[0].Id);
	                    }
	                });
	                console.log('COPY_PROMOTION_DETAIL Promotion for promotion : ' + action.payload);
	                break;

	            case PromCalendarActionConstants.DELETE_PROMOTION_DETAIL:
	                this.LOCalPromotions.apex_delete(action.payload).then(function (result) {
	                    if (result) {
	                        var promotionGroup = _.find(self.LOCalPromotions.getAllItems(), function (item) {
	                            return _.find(item.Promotions, { Id: action.payload });
	                        });
	                        if (promotionGroup.Promotions.length == 1) {
	                            //remove whole promotion
	                            _.remove(self.LOCalPromotions.getAllItems(), promotionGroup);
	                        } else {
	                            //delete promotion
	                            _.remove(promotionGroup.Promotions, { Id: action.payload });
	                        }
	                        self.serializeCalendar();

	                        //self.refreshCalendarView();
	                    }
	                });
	                console.log('DELETE_PROMOTION_DETAIL Promotion for promotion : ' + action.payload);
	                break;
	            default:
	                Utils.callCustomFunction(this, 'onDispatcher', null, action);
	                break;
	        }
	    }
	};

		module.exports = ExtPromotionCalendar;

/***/ },
/* 50 */,
/* 51 */,
/* 52 */,
/* 53 */,
/* 54 */,
/* 55 */,
/* 56 */,
/* 57 */,
/* 58 */,
/* 59 */,
/* 60 */,
/* 61 */,
/* 62 */,
/* 63 */,
/* 64 */,
/* 65 */,
/* 66 */,
/* 67 */,
/* 68 */,
/* 69 */,
/* 70 */,
/* 71 */,
/* 72 */,
/* 73 */,
/* 74 */,
/* 75 */,
/* 76 */,
/* 77 */,
/* 78 */,
/* 79 */,
/* 80 */,
/* 81 */,
/* 82 */,
/* 83 */,
/* 84 */,
/* 85 */,
/* 86 */,
/* 87 */,
/* 88 */,
/* 89 */,
/* 90 */,
/* 91 */,
/* 92 */,
/* 93 */,
/* 94 */,
/* 95 */,
/* 96 */,
/* 97 */,
/* 98 */,
/* 99 */,
/* 100 */,
/* 101 */,
/* 102 */,
/* 103 */,
/* 104 */,
/* 105 */,
/* 106 */,
/* 107 */,
/* 108 */,
/* 109 */,
/* 110 */,
/* 111 */,
/* 112 */,
/* 113 */,
/* 114 */,
/* 115 */,
/* 116 */,
/* 117 */,
/* 118 */,
/* 119 */,
/* 120 */,
/* 121 */,
/* 122 */,
/* 123 */,
/* 124 */,
/* 125 */,
/* 126 */,
/* 127 */,
/* 128 */,
/* 129 */,
/* 130 */,
/* 131 */,
/* 132 */,
/* 133 */,
/* 134 */,
/* 135 */,
/* 136 */,
/* 137 */,
/* 138 */,
/* 139 */,
/* 140 */,
/* 141 */,
/* 142 */,
/* 143 */,
/* 144 */,
/* 145 */,
/* 146 */,
/* 147 */,
/* 148 */,
/* 149 */,
/* 150 */,
/* 151 */,
/* 152 */,
/* 153 */,
/* 154 */,
/* 155 */,
/* 156 */,
/* 157 */,
/* 158 */,
/* 159 */,
/* 160 */,
/* 161 */
/***/ function(module, exports) {

	'use strict';

	var DSExtPromotionCalendar = {
	    'Type': 'DataSource',
	    'Name': 'DSExtPromotionCalendar',
	    'IsExternal': true,
	    'SFObject': null,
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionPlanningController' }]
	};

		module.exports = DSExtPromotionCalendar;

/***/ },
/* 162 */
/***/ function(module, exports) {

	'use strict';

	var LOCalendarView = {
	    'Type': 'ListObject',
	    'Name': 'LOCalendarView',
	    'SFObject': null,
	    'DataSource': 'DSCalendarView',
	    'Properties': [] // Properties are not explitly defined in release 3
	};

		module.exports = LOCalendarView;

/***/ },
/* 163 */
/***/ function(module, exports) {

	'use strict';

	var DSCalendarView = {
	    'Type': 'DataSource',
	    'Name': 'DSCalendarView',
	    'IsExternal': true,
	    'SFObject': null,
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }]
	};

		module.exports = DSCalendarView;

/***/ },
/* 164 */
/***/ function(module, exports) {

	'use strict';

	var DSCalPromotions = {
	    'Type': 'DataSource',
	    'Name': 'DSCalPromotions',
	    'IsExternal': true,
	    'SFObject': 'Promotion__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'delete', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'derive', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'copy', 'Extension': 'PromotionRemoteActionExtension' }]
	};

		module.exports = DSCalPromotions;

/***/ },
/* 165 */
/***/ function(module, exports) {

	'use strict';

	var LOCalPromotions = {
	    'Type': 'ListObject',
	    'Name': 'LOCalPromotions',
	    'SFObject': 'Promotion__c',
	    'DataSource': 'DSCalPromotions',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOCalPromotions;

/***/ },
/* 166 */
/***/ function(module, exports) {

	'use strict';

	var DSExtCalLegend = {
	    'Type': 'DataSource',
	    'Name': 'DSExtCalLegend',
	    'IsExternal': true,
	    'SFObject': null,
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': []
	};

		module.exports = DSExtCalLegend;

/***/ },
/* 167 */
/***/ function(module, exports) {

	'use strict';

	var LOExtCalLegend = {
	    'Type': 'ListObject',
	    'Name': 'LOExtCalLegend',
	    'SFObject': null,
	    'DataSource': 'DSExtCalLegend',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOExtCalLegend;

/***/ },
/* 168 */
/***/ function(module, exports) {

	'use strict';

	var DSExtFiscalYear = {
	    'Type': 'DataSource',
	    'Name': 'DSExtFiscalYear',
	    'IsExternal': true,
	    'SFObject': '',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }]
	};

		module.exports = DSExtFiscalYear;

/***/ },
/* 169 */
/***/ function(module, exports) {

	'use strict';

	var LOExtFiscalYear = {
	    'Type': 'ListObject',
	    'Name': 'LOExtFiscalYear',
	    'SFObject': null,
	    'DataSource': 'DSExtFiscalYear',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOExtFiscalYear;

/***/ },
/* 170 */
/***/ function(module, exports) {

	'use strict';

	module.exports = {
	    'Type': 'BusinessObject',
	    'Name': 'BOExtPromotionCalendar',
	    'SFObject': null,
	    'DataSource': 'DSExtPromotionCalendar',
	    'BaseClass': 'ExtPromotionCalendar',
	    'IdAttribute': 'Id',
	    'Properties': [], // Properties are not explitely defined in release 3
	    'ListObjects': [{ 'Name': 'LOAccount' }, { 'Name': 'LOTactic_Template' }, { 'Name': 'LOExtPrdFilters' }, { 'Name': 'LOPromotion_Template' }, { 'Name': 'LOAccountSet' }, { 'Name': 'LOCalendarView' }, { 'Name': 'LOExtCalLegend' }, { 'Name': 'LOExtFiscalYear' }, { 'Name': 'LOCalPromotions' }, { 'Name': 'LOExtHoverContent' }],
	    'Methods': [{ 'Name': 'onInstantiate' }, { 'Name': 'afterInstantiate' }, { 'Name': 'onDispatcher' }, { 'Name': 'onUIError' }, { 'Name': 'preLoad' }, { 'Name': 'postLoad' }, { 'Name': 'refreshCalLegend' }, { 'Name': 'serializeCalendar' }, { 'Name': 'refreshCalendarView' }, { 'Name': 'addPromotion', 'Customize': ['beforeAPEX', 'afterAPEX'] }, { 'Name': 'updateCalendarView' }, { 'Name': 'serializeToUI' }, { 'Name': 'getPromotionPlanningPageReference' }]
		};

/***/ },
/* 171 */
/***/ function(module, exports) {

	'use strict';

	var LOAccount = {
	    'Type': 'ListObject',
	    'Name': 'LOAccountSet',
	    'SFObject': 'Account',
	    'DataSource': 'DSAccountSet',
	    'Properties': [] // Properties are not explitly defined in release 3   
	};

		module.exports = LOAccount;

/***/ },
/* 172 */
/***/ function(module, exports) {

	'use strict';

	var DSAccount = {
	    'Type': 'DataSource',
	    'Name': 'DSAccountSet',
	    'IsExternal': false,
	    'SFObject': 'Account',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'AccountSetRemoteActionExtension' }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }, { 'Type': 'copy', 'Available': false }]
	};

		module.exports = DSAccount;

/***/ },
/* 173 */
/***/ function(module, exports) {

	'use strict';

	var LOExtHoverContent = {
	    'Type': 'ListObject',
	    'Name': 'LOExtHoverContent',
	    'SFObject': null,
	    'DataSource': 'DSExtHoverContent',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOExtHoverContent;

/***/ },
/* 174 */
/***/ function(module, exports) {

	'use strict';

	var DSExtHoverContent = {
	    'Type': 'DataSource',
	    'Name': 'DSExtHoverContent',
	    'IsExternal': true,
	    'SFObject': '',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }]
	};

		module.exports = DSExtHoverContent;

/***/ },
/* 175 */
/***/ function(module, exports) {

	'use strict';

	var DSMetaData = {
	    'Type': 'DataSource',
	    'Name': 'DSMetaData',
	    'APEX': [
	    //Define metadata remote extension here
	    {
	        'Type': 'getMetaData',
	        'Extension': 'MetaDataRemoteActionExtension',
	        'Managed': true,
	        'Compressed': false,
	        'Buffer': false,
	        'Aggregation': true,
	        'CheckLayout': false
	    }, {
	        'Type': 'getMetaDataList',
	        'Extension': 'MetaDataRemoteActionExtension',
	        'Managed': true,
	        'Compressed': false,
	        'Buffer': false
	    }]
	};

		module.exports = DSMetaData;

/***/ },
/* 176 */
/***/ function(module, exports) {

	'use strict';

	var DSCustomLabels = {
	    'Type': 'DataSource',
	    'Name': 'DSCustomLabels',
	    'APEX': [
	    //Define custom labels remote extension here
	    {
	        'Type': 'readCustomLabelsById',
	        'Extension': 'ContractRemoteActionExtension',
	        'Managed': true,
	        'Compressed': false,
	        'Buffer': true
	    }]
	};

		module.exports = DSCustomLabels;

/***/ },
/* 177 */
/***/ function(module, exports) {

	'use strict';

	var DSCustomLabels = {
	    'Type': 'DataSource',
	    'Name': 'DSLocale',
	    'APEX': [
	    //Define locale remote extension here
	    {
	        'Type': 'getUserSettings',
	        'Extension': 'MetaDataRemoteActionExtension',
	        'Managed': true,
	        'Compressed': false,
	        'Buffer': true
	    }]
	};

		module.exports = DSCustomLabels;

/***/ },
/* 178 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {'use strict';

	//DO NOT REMOVE BELOW LINE
	global.LocalizationCust = __webpack_require__(179);

	global.bopromotion_cust = __webpack_require__(180);
	global.dscustomlabels_cust = __webpack_require__(181);
	global.dsextchildaccounts = __webpack_require__(182);
	global.dspromotion_cust = __webpack_require__(183);
	global.dstactic_cust = __webpack_require__(184);
	global.dsextpromotionattachment = __webpack_require__(185);
	global.loextpromotionattachment_cust = __webpack_require__(186);
	global.dsextpromotionattachment_cust = __webpack_require__(187);
	global.dsmetadata_cust = __webpack_require__(188);
	global.loextchildaccounts = __webpack_require__(189);
	global.loexttactictiers = __webpack_require__(190);
	global.dsexttactictiers = __webpack_require__(191);
	global.lofilteredfunds_cust = __webpack_require__(192);
	global.dsfilteredfunds_cust = __webpack_require__(193);
	global.lofund_cust = __webpack_require__(194);
	global.dsfund_cust = __webpack_require__(195);

	global.boextpromotioncalendar_cust = __webpack_require__(196);
	global.extpromotioncalendar_cust = __webpack_require__(197);
	global.promotion_cust = __webpack_require__(198);
	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },
/* 179 */
/***/ function(module, exports) {

	"use strict";

	var Localization = {

	    'labels': {
	        //'TEST': 'TEST'
	        "PP_TIT_CONFIRMATION": "Confirmation",
	        "PP_LBL_CONFIRMATION_DELETE_ATTACHMENT": "Do you want to delete selected attachment?",
	        "PP_LBL_CONFIRMATION_EXCLUDE_PRODUCT": "Do you want to exclude the product?",
	        "PP_LBL_CONFIRMATION_REMOVE_EXCLUSION_PRODUCT": "Do you want to remove the exclusion for the product?",
	        "PP_LBL_CONFIRMATION_REMOVE_INCLUDED_PRODUCT": "Do you want to remove the manually included product?",
	        "PP_TIT_INFORMATION": "Information",
	        "PP_LBL_INFORMATION_FUNDS": "There are no funds selected.",
	        "PP_LBL_CONFIRMATION_DELETE_FUNDS": "Do you want to delete selected funds?",
	        "PP_LBL_FUND_NAME": "Fund Name",
	        "PP_LBL_FUND_DESCRIPTION": "Description",
	        "PP_LBL_FUND_ANCHOR_CUSTOMER": "Anchor Customer",
	        "PP_LBL_FUND_ANCHOR_PRODUCT": "Anchor Product",
	        "PP_LBL_FUND_TYPE": "Fund Type",
	        "PP_LBL_FUND_AMOUNT": "Amount",
	        "PP_TIT_FUNDS": "Funds",
	        "PP_TIT_CHILD_PROMOTION_ACCOUNTS": "Child Promotion Accounts",
	        "PP_TIT_ACCOUNT": "Account",
	        "PP_LBL_CUSTOMER_UNIQUE": "Costumer Unique",
	        "PP_LBL_PROMOTION_ID": "Promotion Id",
	        "PP_TIT_PUSH_PROMOTION": "Push Promotion",
	        "PP_LBL_PUSH_FINALIZED": "Push child promotion accounts finalized",
	        "PP_LBL_PUSH_PROCESS_PROGRESS": "Push process progress.",
	        "PP_LBL_PROMOTIONS_DONE": "Promotions done",
	        "PP_TIT_PROMOTION_SLOGAN": "Promotion slogan",
	        "PP_TIT_PUSH_ERROR": "Error pushing child promotion",
	        "PP_LBL_PUSH_ERROR": "An error occurred while trying to push the child promotion account",
	        "PP_TIT_CLEAN_PUSH_ERROR": "Error cleaning child promotions",
	        "PP_LBL_CLEAN_PUSH_ERROR": "An error occurred while trying to clean the child promotions account",
	        "PP_TIT_INCLUDE_EXCLUDE_ALL": "Include/Exclude All",
	        "PP_TIT_ATTACHMENTS": "Attachments",
	        "PP_LBL_IMAGE_DESCRIPTION": "Description",
	        "PP_LBL_IMAGE_CREATION_DATE": "Creation Date",
	        "PP_LBL_IMAGE_LAST_UPDATE": "Last Update",
	        "PP_TIT_UPLOAD_ERROR": "Error Uploading",
	        "PP_LBL_UPLOAD_ERROR": "An error occurred while trying to upload the file",
	        "PP_LBL_DESCRIPTION": "Description",
	        "PP_LBL_ANCHOR_CUSTOMER": "Anchor Customer",
	        "PP_LBL_ANCHOR_PRODUCT": "Anchor Product",
	        "PP_LBL_AMOUNT": "Amount",
	        "PP_LBL_NAME_ATTACHMENT": "Name",
	        "PP_LBL_SIZE_ATTACHMENT": "Size",
	        "PP_LBL_DESCRIPTION_ATTACHMENT": "Description",
	        "PP_LBL_CREATION_DATE_ATTACHMENT": "Creation Date",
	        "PP_LBL_LAST_UPDATE_DATE_ATTACHMENT": "Last Update Date",
	        "PP_LBL_DRAG_ATTACHMENTS": "Drag attachments here or",
	        "PP_LBL_UPLOAD_ATTACHMENTS": "Upload Files",
	        "PP_LBL_UPLOADING_ATTACHMENTS": "Uploading...",
	        "PP_LBL_IMAGES_ATTACHMENTS": "Images",
	        "PP_LBL_VIDEOS_ATTACHMENTS": "Videos",
	        "PP_LBL_FILES_ATTACHMENTS": "Files",
	        "PP_LBL_NO_ATTACHMENTS_UPLOADED_1": "No Attachments uploaded, yet. Switch to the",
	        "PP_LBL_NO_ATTACHMENTS_UPLOADED_2": "to Upload some Files. ",
	        "PP_LBL_EDIT_MODE_ATTACHMENTS": "Edit Mode",
	        "PP_TIT_UPLOAD_ATTACHMENT_ERROR": "Upload Error",
	        "PP_LBL_UPLOAD_ATTACHMENT_SIZE_ERROR": "File incorrect size. The attachment has to be less than 25MB.",
	        "PP_LBL_UPLOAD_ATTACHMENT_FILENAME_SIZE_ERROR": "The filename is too long (max. 80 chars)",
	        "PP_LBL_UPLOAD_ATTACHMENT_NUMBER_OF_FILES_ERROR": "Only one file allowed per upload",
	        "PP_BTN_APPROVE": "Approve",
	        "PP_BTN_REJECT": "Reject",
	        "PP_BTN_SUBMIT": "Submit",
	        "PP_BTN_SAVE": "Save",
	        "PP_BTN_PUSH": "Push",
	        //PMA - START CODE - 2017-01-13 - Threshold button
	        "PP_BTN_INVOKETHRESHOLD": "Threshold",
	        //PMA - END CODE - 2017-01-13 - Threshold button
	        "PP_BTN_RELEASE": "Release",
	        "PP_BTN_MANAGE_TIERS": "Manage Tiers",
	        "PP_BTN_APPLY_TIERS": "Apply Tiers",
	        "PP_BTN_NEW": "New",
	        "PP_TIT_RELEASE_ERROR": "Error updating child promotions",
	        "PP_LBL_RELEASE_ERROR": "An error occurred while trying to release the child promotions account",
	        "PP_TIT_TIERED_INFORMATION": "Tiered Information",
	        "PP_TIT_VOLUME_MIN": "Volume Min",
	        "PP_TIT_VOLUME_MAX": "Volume Max",
	        "PP_TIT_AMOUNT": "Amount",
	        "PP_TIT_SELECT": "SELECT",
	        "PP_LBL_NO_TIERS": "No Tiers associated to this tactic",
	        //PMA - START CODE - 2017-01-16 - New UK Button
	        "PP_BTN_SIMULATION": "Simulation",
	        "PP_BTN_MODEL": "Model",
	        "PP_BTN_PLANNED": "Planned",
	        "PP_BTN_SUBMITTEDFORAPPROVAL": "Sumitted for Approval",
	        "PP_BTN_REJECTED": "Rejected",
	        "PP_BTN_FINALISED": "Finalised",
	        "PP_BTN_CANCELLED": "Cancelled",
	        "PP_BTN_STOPPED": "Stopped",
	        //PMA - END CODE - 2017-01-16 - New UK Button
	        "PP_BTN_AUDITTRAIL": "Audit Trail",
	        "PP_LBL_TACTICS": "Tactics", //Missing
	        'PP_BTN_MANAGE_FUND': 'Manage Funds',
	        'PP_BTN_APPLY_FUND': 'Apply Fund',
	        'PP_BTN_ENDDATE': 'End Date'
	    }
	};

		module.exports = Localization;

/***/ },
/* 180 */
/***/ function(module, exports) {

	'use strict';

	var BO_Promotion = {

	    'ListObjects': [{ 'Name': 'LOExtPromotionAttachment' }, { 'Name': 'LOExtChildAccounts' }, { 'Name': 'LOExtTacticTiers' }, { 'Name': 'LOFund' }, { 'Name': 'LOFilteredFunds' }],
	    'Methods': []
	};

		module.exports = BO_Promotion;

/***/ },
/* 181 */
/***/ function(module, exports) {

	'use strict';

	var DSCustomLabels = {
	    'Type': 'DataSource',
	    'Name': 'DSCustomLabels',
	    'APEX': [
	    //Define custom labels remote extension here
	    {
	        'Type': 'readCustomLabelsById',
	        'Extension': 'MyContractRemoteActionExtension',
	        'Managed': false,
	        'Compressed': false,
	        'Buffer': true
	    }]
	};

		module.exports = DSCustomLabels;

/***/ },
/* 182 */
/***/ function(module, exports) {

	'use strict';

	var DSExtChildAccounts = {
	    'Type': 'DataSource',
	    'Name': 'DSExtChildAccounts',
	    'IsExternal': true,
	    'IsManaged': false,
	    'SFObject': 'Promotion_Acc_Rel__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }]
	};

		module.exports = DSExtChildAccounts;

/***/ },
/* 183 */
/***/ function(module, exports) {

	'use strict';

	var DSPromotion = {
	    'Type': 'DataSource',
	    'Name': 'DSPromotion',
	    'IsExternal': false,
	    'SFObject': 'Promotion__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Available': true, 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension' }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension' }, { 'Type': 'invokeWF', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension' }, { 'Type': 'CreatePush', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension' }, { 'Type': 'cleanUpPush', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension' }, { 'Type': 'finalizePush', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension' },
	    //PMA - START CODE - 2017-01-13 - Threshold button
	    { 'Type': 'invokePromotionThresholdCheck', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension' }, { 'Type': 'invokeAuditTrail', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension' },
	    //PMA - END CODE - 2017-01-13 - Threshold button
	    { 'Type': 'UpdateEnablePush', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension' }]
	};

		module.exports = DSPromotion;

/***/ },
/* 184 */
/***/ function(module, exports) {

	'use strict';

	var DSTactic = {
	    'Type': 'DataSource',
	    'Name': 'DSTactic',
	    'IsExternal': false,
	    'SFObject': 'Tactic__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'create', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension' }, { 'Type': 'copy', 'Extension': 'PromotionRemoteActionExtension' }]
	};

		module.exports = DSTactic;

/***/ },
/* 185 */
/***/ function(module, exports) {

	'use strict';

	var DSExtPromotionAttachment = {
	    'Type': 'DataSource',
	    'Name': 'DSExtPromotionAttachment',
	    'IsExternal': true,
	    'IsManaged': false,
	    'SFObject': 'Promotion_Attachment__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'create', 'Extension': 'PromotionRemoteActionExtension' }, { 'Type': 'write', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }, { 'Type': 'copy', 'Available': false }]
	};

		module.exports = DSExtPromotionAttachment;

/***/ },
/* 186 */
/***/ function(module, exports) {

	'use strict';

	var LOExtPromotionAttachment = {
	    'Type': 'ListObject',
	    'Name': 'LOExtPromotionAttachment',
	    'SFObject': 'Promotion_Attachment__c',
	    'DataSource': 'DSExtPromotionAttachment',
	    'Properties': [] // Properties are not explitly defined in release 3
	};

		module.exports = LOExtPromotionAttachment;

/***/ },
/* 187 */
/***/ function(module, exports) {

	'use strict';

	var DSExtPromotionAttachment = {
	    'Type': 'DataSource',
	    'Name': 'DSExtPromotionAttachment',
	    'IsExternal': true,
	    'IsManaged': false,
	    'SFObject': 'Promotion_Attachment__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'MyPromotionRemoteActionExtension2', 'Managed': false }, { 'Type': 'create', 'Extension': 'MyPromotionRemoteActionExtension2', 'Managed': false }, { 'Type': 'write', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }, { 'Type': 'copy', 'Available': false }]
	};

		module.exports = DSExtPromotionAttachment;

/***/ },
/* 188 */
/***/ function(module, exports) {

	'use strict';

	var DSMetaData = {
	    'Type': 'DataSource',
	    'Name': 'DSMetaData',
	    'APEX': [
	    //Define metadata remote extension here
	    {
	        'Type': 'getMetaData',
	        'Extension': 'MyMetaDataRemoteActionExtension',
	        'Managed': false,
	        'Compressed': false,
	        'Buffer': false,
	        'Aggregation': false,
	        'CheckLayout': false
	    }, {
	        'Type': 'getMetaDataList',
	        'Extension': 'MyMetaDataRemoteActionExtension',
	        'Managed': false,
	        'Compressed': false,
	        'Buffer': false
	    }]
	};

		module.exports = DSMetaData;

/***/ },
/* 189 */
/***/ function(module, exports) {

	'use strict';

	var LOExtChildAccounts = {
	    'Type': 'ListObject',
	    'Name': 'LOExtChildAccounts',
	    'SFObject': 'Promotion_Acc_Rel__c',
	    'DataSource': 'DSExtChildAccounts',
	    'Properties': [] // Properties are not explitly defined in release 3    
	};

		module.exports = LOExtChildAccounts;

/***/ },
/* 190 */
/***/ function(module, exports) {

	'use strict';

	var LOExtTacticTiers = {
	    'Type': 'ListObject',
	    'Name': 'LOExtTacticTiers',
	    'SFObject': 'tactic__c',
	    'DataSource': 'DSExtTacticTiers',
	    'Properties': [] // Properties are not explitly defined in release 3
	};

		module.exports = LOExtTacticTiers;

/***/ },
/* 191 */
/***/ function(module, exports) {

	'use strict';

	var DSExtTacticTiers = {
	    'Type': 'DataSource',
	    'Name': 'DSExtTacticTiers',
	    'IsExternal': true,
	    'SFObject': 'tactic__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false }, { 'Type': 'write', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'validate', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false }]
	};

		module.exports = DSExtTacticTiers;

/***/ },
/* 192 */
/***/ function(module, exports) {

	'use strict';

	var LOFilteredFunds = {
	    'Type': 'ListObject',
	    'Name': 'LOFilteredFunds',
	    'SFObject': 'Fund__c',
	    'DataSource': 'DSFilteredFunds',
	    'Properties': [] // Properties are not explitly defined in release 3
	};

		module.exports = LOFilteredFunds;

/***/ },
/* 193 */
/***/ function(module, exports) {

	'use strict';

	var DSFilteredFunds = {
	    'Type': 'DataSource',
	    'Name': 'DSFilteredFunds',
	    'IsExternal': true,
	    'SFObject': 'Fund__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false }, { 'Type': 'write', 'Available': false }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }]
	};

		module.exports = DSFilteredFunds;

/***/ },
/* 194 */
/***/ function(module, exports) {

	'use strict';

	var LOFund = {
	    'Type': 'ListObject',
	    'Name': 'LOFund',
	    'SFObject': 'Fund__c',
	    'DataSource': 'DSFund',
	    'Properties': [] // Properties are not explitly defined in release 3
	};

		module.exports = LOFund;

/***/ },
/* 195 */
/***/ function(module, exports) {

	'use strict';

	var DSFund = {
	    'Type': 'DataSource',
	    'Name': 'DSFund',
	    'IsExternal': false,
	    'SFObject': 'Fund__c',
	    'Attributes': [], // Attributes are not explictly listed in release 3
	    'APEX': [{ 'Type': 'read', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false }, { 'Type': 'write', 'Extension': 'MyPromotionRemoteActionExtension' }, { 'Type': 'create', 'Available': false }, { 'Type': 'delete', 'Available': false }, { 'Type': 'getEARights', 'Available': false }, { 'Type': 'validate', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false }]
	};

		module.exports = DSFund;

/***/ },
/* 196 */
/***/ function(module, exports) {

	'use strict';

	module.exports = {

	    'ListObjects': [{ 'Name': 'LOCalendarView' }],

	    'Methods': [{ 'Name': 'getPromotionPlanningPageReference', 'Replace': true }, { 'Name': 'preLoad', 'Replace': true }, { 'Name': 'serializeCalendar', 'Replace': true }, { 'Name': 'refreshCalendarView', 'Replace': true }, { 'Name': 'updateCalendarView', 'Replace': true }]
		};

/***/ },
/* 197 */
/***/ function(module, exports) {

	'use strict';

	var _ExtPromotionCalendar;

	function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

	var ExtPromotionCalendar_Cust = (_ExtPromotionCalendar = {
	    /**
	     * Customize extension to the core preLoad function. Will be called at the end of the core method.
	     * Input parameter is a list of promises of LOs which should be loaded. Can be extended or manipulated in this place.
	     * @param {promise[]} instantiatePromises - Array of promises created by load actions done in core.
	     * @returns {promise[]} Array of promises adapted in customizing
	     */
	    preLoad: function preLoad(instantiatePromises) {
	        return instantiatePromises;
	    },
	    /**
	     * Customize extension to the core postLoad function. Will be called at the end of the core method.
	     * Input parameter is a list of promises of LOs which should be loaded. Can be extended or manipulated in this place.
	     * @param {promise[]} instantiatePromises - Array of promises created by load actions done in core.
	     * @returns {promise[]} Array of promises adapted in customizing
	     */
	    postLoad: function postLoad(instantiatePromises) {
	        return instantiatePromises;
	    },
	    /**
	     * Customize extension to the core serializeToUI function. Will be called at the end of the core method.
	     * Input parameter is the already serialized BO as core would send it to the UI layer.
	     * The project can manipulate the JSON to match its requirements. The reponse should again be a promotion state JSON.
	     * @param {JSON} serializedObject - Serialized version of the BO to be used as parameter for the UI layer
	     * @returns {JSON} Serialized version of the BO adpated for project requirements
	     */
	    serializeToUI: function serializeToUI(serializedObject) {
	        return serializedObject;
	    },
	    /**
	     * Customize extension to the core addPromotion function. Will be called before the APEX request is sent.
	     * Input parameter is the already serialized BO as core would send it to the UI layer.
	     * The project can manipulate the JSON to match its requirements. The reponse should again be a promotion JSON.
	     * @param {JSON} serializedObject - Serialized version of the BO to be used as parameter for the UI layer
	     * @returns {JSON} Serialized version of the BO adpated for project requirements     
	     */
	    addPromotion_beforeAPEX: function addPromotion_beforeAPEX(serializedObject) {
	        return serializedObject;
	    },
	    /**
	     * Customize extension to the core addPromotion function. Will be called after the APEX call for the new promotion has returned.
	     * Input parameter is the data as received from the APEX method. This means an empty promotion JSON in that case
	     * The project can make adaptions to the data or execute additional action. The reponse should again be the empty tactic JSON.
	     * @param {JSON} payload - Data received from the createLOCalPromotions APEX method
	     * @returns {JSON} Data received from the createLOCalPromotions APEX method
	     */
	    addPromotion_afterAPEX: function addPromotion_afterAPEX(payload) {
	        return payload;
	    },
	    /**
	     * Customize extension to the core onDispatcher function. Will be called if an UI event is not found in core code.
	     * @param {JSON} action - Payload as provided by the UI event bus
	     */
	    onDispatcher: function onDispatcher(action) {
	        switch (action.actionType) {
	            /*
	            case PromCalendarActionConstants.MYACTION:
	                // Do something here
	                break;
	            */
	            default:
	                console.log('Unknown action type ${action.actionType} detected. Cannot call appropriate action.');
	                break;
	        }
	    },
	    /**
	     * Replace of getPromotionPlanningPageReference to point to the custom promotion planning page. 
	     */
	    getPromotionPlanningPageReference: function getPromotionPlanningPageReference() {
	        return 'MyPromotionPlanning';
	    }

	}, _defineProperty(_ExtPromotionCalendar, 'preLoad', function preLoad() {
	    var me = this;
	    var instantiatePromises = []; // when.defer();
	    var loadParams = { 'readAll': true };

	    this.modalMessages = [];

	    instantiatePromises.push(this.LOTactic_Template.load(null, loadParams));
	    instantiatePromises.push(this.LOPromotion_Template.load(null, loadParams));
	    instantiatePromises.push(this.LOAccount.load(null, loadParams));
	    instantiatePromises.push(this.LOExtPrdFilters.load());
	    instantiatePromises.push(this.LOCalendarView.load());

	    var fiscalYearLoadParams = { "Reference_Date": new Date().getTime() };

	    instantiatePromises.push(this.LOExtFiscalYear.load(null, fiscalYearLoadParams));

	    return instantiatePromises;
	}), _defineProperty(_ExtPromotionCalendar, 'refreshCalendarView', function refreshCalendarView() {
	    var _this = this;

	    var me = this;
	    // var calendarView = this.LOCalendarView.getItems()[0];
	    var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
	    if (calendarView != null) {

	        var loadParams = { "Date_From": this.initDate.getTime(), "Date_Thru": this.endDate.getTime() };
	        loadParams.CalendarView = calendarView != null ? calendarView.serialize() : '';
	        this.LOCalPromotions.removeAllItems();

	        this.LOCalPromotions.load(null, loadParams).then(function (x) {
	            _this.refreshCalLegend();
	            _this.serializeCalendar();
	        });
	    } else this.serializeCalendar();
	}), _defineProperty(_ExtPromotionCalendar, 'updateCalendarView', function updateCalendarView(uiView) {
	    var _this2 = this;

	    var me = this;
	    //var calendarView = this.LOCalendarView.getItems()[0];
	    var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
	    if (!calendarView) {
	        //There is no calendar view so we have to create an empty one
	        var LICalendarView = {
	            'Id': '',
	            'Name': 'Default View',
	            'Description': 'Default View',
	            'IsDefault': true,
	            'FilterCriteria': {
	                "accountfilter": {
	                    "criteria": {
	                        "account_id__c": []
	                    }
	                },
	                "promotionfilter": {
	                    "criteria": {
	                        "promotion_template__c": [],
	                        "tactic_template__c": []

	                    }
	                },
	                "productfilter": {
	                    "criteria": {
	                        "category__c": []
	                    }
	                }

	            }
	        };

	        this.LOCalendarView.addItem(LICalendarView);
	        calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
	    }

	    calendarView.objectStatus |= STATE.DIRTY;
	    var filterCriteria = calendarView.FilterCriteria;
	    if (uiView != null) {
	        //If it is null we maintain an empty initial view (user clicked the Continue Anyways button)
	        Object.keys(filterCriteria).forEach(function (c) {
	            var uiCriteria = uiView[c];
	            var viewCriteria = filterCriteria[c].criteria;
	            uiCriteria.forEach(function (field) {
	                viewCriteria[field.fieldId] = _.filter(field.values, { Selected: true }).reduce(function (r, v) {
	                    r.push(v.Id);
	                    return r;
	                }, []);
	            });
	        });
	    }

	    this.refreshCalendarView();
	    this.LOCalendarView.apex_write(calendarView.Id, JSON.stringify(calendarView.serialize())).then(function (result) {
	        if (result.__Status) {
	            var viewId = result.data.Id;
	            var calendarView = _.find(_this2.LOCalendarView.getAllItems(), 'IsDefault');
	            calendarView.Id = viewId;
	        }
	    });
	}), _defineProperty(_ExtPromotionCalendar, 'serializeCalendar', function serializeCalendar() {
	    var me = this;
	    var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');

	    var serialzeProductFilter = function serialzeProductFilter(fieldId) {
	        return {
	            fieldId: fieldId,
	            label: _.find(me.LOExtPrdFilters.getAllItems(), { filterId: fieldId }).filterLabel,
	            values: _.filter(me.LOExtPrdFilters.getAllItems(), { filterId: fieldId }).reduce(function (result, item) {
	                result.push({
	                    Label: item.filterValueLabel,
	                    Id: item.filterValueId,
	                    Selected: calendarView != null && calendarView.FilterCriteria.productfilter.criteria[fieldId] && calendarView.FilterCriteria.productfilter.criteria[fieldId].indexOf(item.filterValueId) != -1
	                });
	                return result;
	            }, [])
	        };
	    };

	    var calendar = {
	        initDate: this.initDate,
	        endDate: this.endDate,
	        showInitialSettings: calendarView == null,
	        isFilterSet: true, //TODO
	        FilterCriteria: {
	            accountfilter: [{
	                fieldId: 'account_id__c',
	                label: AppManager.getLabel("PC_LBL_CUSTOMER_NAME") || 'Customer name',
	                values: this.LOAccount.getAllItems().reduce(function (result, acc) {
	                    result.push({
	                        Label: acc.Name,
	                        Id: acc.Id,
	                        Selected: calendarView != null && calendarView.FilterCriteria.accountfilter.criteria.account_id__c.indexOf(acc.Id) != -1
	                    });
	                    return result;
	                }, [])
	            }],
	            promotionfilter: [{
	                fieldId: 'promotion_template__c',
	                label: AppManager.getLabel("PC_LBL_PROMOTION_TYPE") || 'Promotion type',
	                values: this.LOPromotion_Template.getAllItems().reduce(function (result, promo) {
	                    result.push({
	                        Label: promo.Description__c,
	                        Id: promo.Id,
	                        Selected: calendarView != null && calendarView.FilterCriteria.promotionfilter.criteria.promotion_template__c.indexOf(promo.Id) != -1
	                    });
	                    return result;
	                }, [])
	            }, {
	                fieldId: 'tactic_template__c',
	                label: AppManager.getLabel("PC_LBL_TACTIC_TYPE") || 'Tactic type',
	                values: this.LOTactic_Template.getAllItems().reduce(function (result, tactic) {
	                    result.push({
	                        Label: tactic.Description__c,
	                        Id: tactic.Id,
	                        Selected: calendarView != null && calendarView.FilterCriteria.promotionfilter.criteria.tactic_template__c.indexOf(tactic.Id) != -1
	                    });
	                    return result;
	                }, [])
	            }],
	            productfilter: []
	        },

	        accounts: this.LOAccount.getAllItems().reduce(function (result, acc) {
	            result.push({
	                Label: acc.Name,
	                Id: acc.Id
	            });
	            return result;
	        }, []),

	        accountSet: this.LOAccountSet.getAllItems().reduce(function (result, acc) {
	            result.push({
	                Label: acc.Description__c,
	                Id: acc.Id
	            });
	            return result;
	        }, []),

	        promotion_templates: this.LOPromotion_Template.getAllItems().reduce(function (result, promo) {
	            result.push({
	                Label: promo.Description__c,
	                Id: promo.Id,
	                Anchor_Type: promo.Anchor_Type__c
	            });
	            return result;
	        }, []),

	        active_promotion_templates: this.LOPromotion_Template.getItems().reduce(function (result, promo) {
	            result.push({
	                Label: promo.Description__c,
	                Id: promo.Id,
	                Anchor_Type: promo.Anchor_Type__c
	            });
	            return result;
	        }, []),

	        legend: this.LOExtCalLegend.getAllItems().reduce(function (result, legend) {
	            result.push({ Name: legend.Name, Commit_Color: legend.Commit_Color });
	            return result;
	        }, []),

	        periods: this.LOExtFiscalYear.getAllItems()[0].Periods, // TODO

	        promotions: this.LOCalPromotions.getAllItems().reduce(function (result, promo) {
	            result.push({
	                'slogan': promo.Slogan,
	                'Account_Name': promo.Account_Name || promo.Account_Set_Description,
	                'Commit_Color': promo.Commit_Color,
	                'Promotion_Template_Id': promo.Promotion_Template,
	                'dates': promo.Promotions.reduce(function (r, v) {
	                    r.push({
	                        'Id': v.Id,
	                        'from': new Date(v.Date_From),
	                        'to': new Date(v.Date_Thru),
	                        'phase': v.Phase,
	                        'isReady': v.Phase == 'Committed'
	                    });

	                    return r;
	                }, [])
	            });
	            return result;
	        }, [])
	    };

	    calendar.FilterCriteria.productfilter.push(serialzeProductFilter('category__c'));

	    calendar.isFilterSet = _.some(calendar.FilterCriteria.accountfilter[0].values, { Selected: true }) || _.some(calendar.FilterCriteria.promotionfilter[0].values, { Selected: true }) || _.some(calendar.FilterCriteria.promotionfilter[0].values, { Selected: true }) || _.some(calendar.FilterCriteria.productfilter[0].values, { Selected: true });

	    UI_EVENT_BUS.put(EVENTS.UI_BINDING, { calendar: calendar });
	}), _ExtPromotionCalendar);

		module.exports = ExtPromotionCalendar_Cust;

/***/ },
/* 198 */
/***/ function(module, exports) {

	'use strict';

	var Promotion_Cust = {
	    /**
	     * Customize extension to the core preLoad function. Will be called at the end of the core method.
	     * Input parameter is a list of promises of LOs which should be loaded. Can be extended or manipulated in this place.
	     * @param {promise[]} instantiatePromises - Array of promises created by load actions done in core.
	     * @returns {promise[]} Array of promises adapted in customizing
	     */
	    preLoad: function preLoad(instantiatePromises) {
	        this.uploads = {};
	        this.modalMessages = [];

	        return instantiatePromises;
	    },
	    /**
	     * Customize extension to the core postLoad function. Will be called at the end of the core method.
	     * Input parameter is a list of promises of LOs which should be loaded. Can be extended or manipulated in this place.
	     * @param {promise[]} instantiatePromises - Array of promises created by load actions done in core.
	     * @returns {promise[]} Array of promises adapted in customizing
	     */
	    postLoad: function postLoad(instantiatePromises) {
	        var _this = this;

	        var promoObject = this.serializePromotion();
	        var _iteratorNormalCompletion = true;
	        var _didIteratorError = false;
	        var _iteratorError = undefined;

	        try {
	            for (var _iterator = Object.keys(promoObject.BOPromotion)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                var key = _step.value;
	                if (key.match(/Promotion_ID__c$/)) delete promoObject.BOPromotion[key];
	            }
	        } catch (err) {
	            _didIteratorError = true;
	            _iteratorError = err;
	        } finally {
	            try {
	                if (!_iteratorNormalCompletion && _iterator.return) {
	                    _iterator.return();
	                }
	            } finally {
	                if (_didIteratorError) {
	                    throw _iteratorError;
	                }
	            }
	        }

	        var _iteratorNormalCompletion2 = true;
	        var _didIteratorError2 = false;
	        var _iteratorError2 = undefined;

	        try {
	            for (var _iterator2 = promoObject.BOPromotion.LOTactic[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	                var tactic = _step2.value;
	                var _iteratorNormalCompletion3 = true;
	                var _didIteratorError3 = false;
	                var _iteratorError3 = undefined;

	                try {
	                    for (var _iterator3 = Object.keys(tactic)[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
	                        var _key = _step3.value;
	                        if (_key.match(/Record_Link__c$/)) delete tactic[_key];
	                    }
	                } catch (err) {
	                    _didIteratorError3 = true;
	                    _iteratorError3 = err;
	                } finally {
	                    try {
	                        if (!_iteratorNormalCompletion3 && _iterator3.return) {
	                            _iterator3.return();
	                        }
	                    } finally {
	                        if (_didIteratorError3) {
	                            throw _iteratorError3;
	                        }
	                    }
	                }
	            }
	        } catch (err) {
	            _didIteratorError2 = true;
	            _iteratorError2 = err;
	        } finally {
	            try {
	                if (!_iteratorNormalCompletion2 && _iterator2.return) {
	                    _iterator2.return();
	                }
	            } finally {
	                if (_didIteratorError2) {
	                    throw _iteratorError2;
	                }
	            }
	        }

	        this.LOExtChildAccounts.apex_read(JSON.stringify(AppManager.addACSFNamespace(promoObject))).then(function (children) {
	            _this.LOExtChildAccounts.removeAllItems();
	            _this.LOExtChildAccounts.addItems(children.data || []);
	            _this.changeHandler();
	        });

	        this.LOExtPromotionAttachment.apex_read(this.getId()).then(function (attachments) {
	            _this.LOExtPromotionAttachment.addItems(attachments.data.map(function (att) {
	                var attachment = att.PromotionAttachment;
	                attachment.previewUrl = att.previewUrl;
	                attachment.attachmentUrl = att.attachmentUrl;
	                attachment.Type__c = attachment.Type__c || 'application/octet-stream';
	                return attachment;
	            }));
	            _this.changeHandler();
	        });

	        this.LOExtTacticTiers.load().then(function () {
	            return _this.changeHandler();
	        });

	        this.LOFilteredFunds.load().then(function () {
	            return _this.changeHandler();
	        });

	        return instantiatePromises;
	    },
	    /**
	     * Customize extension to the core serializeToAPEX function. Will be called at the end of the core method.
	     * Input parameter is the already serialized BO as core would send it to the APEX layer.
	     * The project and manipulate the JSON to match its requirements. The reponse should again be a promotion JSON.
	     * @param {JSON} serializedObject - Serialized version of the BO to be used as parameter for the APEX layer
	     * @returns {JSON} Serialized version of the BO adpated for project requirements
	     */
	    serializeToAPEX: function serializeToAPEX(serializedObject) {
	        /**
	         * Don't use below code. Once the metadata for ExtChildAccount is available, below can be replaced by only
	         * serializedObject.LOExtChildAccounts = SerializationHelper.serializeWithStatus(this.LOExtChildAccounts);
	         */
	        serializedObject.LOExtChildAccounts = this.LOExtChildAccounts.getAllItems();
	        if (serializedObject.LOExtChildAccounts) serializedObject.LOExtChildAccounts = serializedObject.LOExtChildAccounts.map(function (account) {
	            account.__ObjectStatus = account.getObjectStatus();
	            return _.pick(account, ['ChildAccountID', 'ChildAccountName', 'Included', 'CustomerUnique', 'PushedPromoID', 'PromotionSlogan', '__ObjectStatus']);
	        });

	        serializedObject.LOExtTacticTiers = this.LOExtTacticTiers.getAllItems();
	        if (serializedObject.LOExtTacticTiers) serializedObject.LOExtTacticTiers = serializedObject.LOExtTacticTiers.map(function (tacticTiers) {
	            return {
	                tacticId: tacticTiers.tacticId,
	                JSONTier: JSON.parse(tacticTiers.JSONTier || '[]'),
	                __ObjectStatus: tacticTiers.getObjectStatus()
	            };
	        });

	        return serializedObject;
	    },
	    /**
	     * Customize extension to the core serializeToUI function. Will be called at the end of the core method.
	     * Input parameter is the already serialized BO as core would send it to the UI layer.
	     * The project and manipulate the JSON to match its requirements. The reponse should again be a promotion state JSON.
	     * @param {JSON} serializedObject - Serialized version of the BO to be used as parameter for the UI layer
	     * @returns {JSON} Serialized version of the BO adpated for project requirements
	     */
	    serializeToUI: function serializeToUI(serializedObject) {
	        var promotionJSON = {
	            //Soco
	            UL_Lift__c: this.getUL_Lift__c(),
	            UL_Front_Margin__c: this.getUL_Front_Margin__c(),
	            UL_IIBB_Tax__c: this.getUL_IIBB_Tax__c(),
	            UL_Volume_Type__c: this.getUL_Volume_Type__c(),
	            UL_Current_Status__c: this.getUL_Current_Status__c(),
	            UL_Free_Text__c: this.getUL_Free_Text__c(),
	            loadPhase: this.loadPhase,
	            //PMA - START CODE - 2017-01-12 - New custom field
	            UL_Cannibalisation_Rate__c: this.getUL_Cannibalisation_Rate__c(),
	            UL_Market__c: this.getUL_Market__c(),
	            //PMA - END CODE - 2017-01-12 - New custom field
	            //uki
	            UL_Delivery_Profile__c: this.getUL_Delivery_Profile__c(),
	            UL_Mechanic__c: this.getUL_Mechanic__c(),
	            UL_Sub_Mechanic__c: this.getUL_Sub_Mechanic__c(),
	            UL_Pre_Evaluation_Comment__c: this.getUL_Pre_Evaluation_Comment__c(),
	            UL_Primary_Objective__c: this.getUL_Primary_Objective__c(),
	            UL_Secondary_Objective__c: this.getUL_Secondary_Objective__c(),
	            UL_Promotion_Type__c: this.getUL_Promotion_Type__c(),
	            UL_Feature__c: this.getUL_Feature__c(),
	            UL_Category__c: this.getUL_Category__c(),
	            UL_Brand__c: this.getUL_Brand__c(),
	            UL_Cannibalisation_Override__c: this.getUL_Cannibalisation_Override__c(),
	            UL_Post_Dip_End_Date__c: this.getUL_Post_Dip_End_Date__c(),
	            UL_Account__c: this.getUL_Account__c()
	        };
	        //Adding child accounts
	        //WARNING: Remove get all items below and use the serialize method once the metadata for ExtChildAccount is implemented.
	        promotionJSON.ChildAccounts = this.LOExtChildAccounts.getAllItems();
	        promotionJSON.attachments = this.LOExtPromotionAttachment.getItems();
	        Object.assign(serializedObject, promotionJSON);

	        return serializedObject;
	    },
	    /**
	     * Customize extension to the core serializeSelectedTacticToUI function. Will be called at the end of the core method.
	     * Input parameter is the already serialized BO as core would send it to the UI layer.
	     * The project and manipulate the JSON to match its requirements. The response should again be a promotion state JSON.
	     * @param {JSON} serializedObject - Serialized version of the BO to be used as parameter for the UI layer
	     * @returns {JSON} Serialized version of the BO adapted for project requirements
	     */
	    serializeSelectedTacticToUI: function serializeSelectedTacticToUI(serializedObject) {
	        var tactic = this.LOTactic.getItems()[0];
	        var tacticJSON = {
	            UL_Off_On_Invoice__c: tactic.getUL_Off_On_Invoice__c(),
	            UL_Take_Up_Rate__c: tactic.getUL_Take_Up_Rate__c(),
	            UL_Order_Date_From__c: tactic.getUL_Order_Date_From__c(),
	            UL_Order_Date_Thru__c: tactic.getUL_Order_Date_Thru__c(),
	            UL_Payment_Method__c: tactic.getUL_Payment_Method__c(),
	            UL_Condition_Type__c: tactic.getUL_Condition_Type__c(),
	            UL_Investment_Method__c: tactic.getUL_Investment_Method__c(),
	            UL_Redemption__c: tactic.getUL_Redemption__c(),
	            RecordTypeId: tactic.getRecordTypeId(),
	            InvalidTacticTiers: tactic.InvalidTacticTiers || false,
	            InvalidFunds: tactic.InvalidFunds || false
	        };
	        var currentTacticTiers = _.find(this.LOExtTacticTiers.getAllItems(), function (tacticTiers) {
	            return tacticTiers.tacticId == tactic.Id;
	        });
	        tacticJSON.TacticTiers = currentTacticTiers ? JSON.parse(currentTacticTiers.JSONTier || '[]') : [];

	        tacticJSON.availableFunds = [];
	        tacticJSON.availableFunds = _.unionBy(this.LOFund.getAllItems().filter(function (fund) {
	            return !!_.find(fund.Tactics, function (item) {
	                return item.tacticId == tactic.Id;
	            });
	        }).map(function (fund) {
	            return Object.assign(fund, _.find(fund.Tactics, function (item) {
	                return item.tacticId == tactic.Id;
	            }));
	        }), this.LOFilteredFunds.getItems(), 'Id');

	        Object.assign(serializedObject, tacticJSON);

	        return serializedObject;
	    },
	    /**
	     *
	     */
	    addTactic_beforeAPEX: function addTactic_beforeAPEX(payload) {
	        return payload;
	    },
	    /**
	     *
	     */
	    addTactic_afterAPEX: function addTactic_afterAPEX(payload) {
	        return payload;
	    },
	    /**
	     *
	     */
	    addTactic_post: function addTactic_post() {
	        //PMA - START CODE - 2017-01-17 - Copy Lift from Promotion to Tactic
	        this.LOTactic.current.Lift__c = this.UL_Lift__c;
	        //PMA - END CODE - 2017-01-17 - Copy Lift from Promotion to Tactic
	        return null;
	    },
	    /**
	     * Customize extension to the core onDispatcher function. Will be called if an UI event is not found in core code.
	     * @param {JSON} payload - Payload as provided by the UI event bus
	     */
	    onDispatcher: function onDispatcher(action) {
	        var _this2 = this;

	        switch (action.actionType) {

	            case PromotionActionConstants.PUSH_CHILD_ACCOUNT:
	                {
	                    var _ret = function () {
	                        var promoContent = _this2.serializePromotion(),
	                            totalChildAccounts = _.filter(promoContent.BOPromotion.LOExtChildAccounts, function (childAccount) {
	                            return childAccount.Included;
	                        }).length,
	                            uploadId = action.payload.uploadId,
	                            cancelled = false,
	                            i = 0;


	                        _this2.uploads[uploadId] = function () {
	                            cancelled = true;
	                            UI_EVENT_BUS.put(uploadId, {
	                                total: totalChildAccounts,
	                                done: totalChildAccounts
	                            });
	                            delete _this2.uploads[uploadId];
	                        };

	                        var push = function push() {
	                            UI_EVENT_BUS.put(uploadId, {
	                                total: totalChildAccounts,
	                                done: i
	                            });

	                            if (i < totalChildAccounts) {
	                                var temp = promoContent.BOPromotion.LOExtChildAccounts;
	                                promoContent.BOPromotion.LOExtChildAccounts = [promoContent.BOPromotion.LOExtChildAccounts[i]];
	                                var json = JSON.stringify(promoContent);
	                                promoContent.BOPromotion.LOExtChildAccounts = temp;

	                                _this2.apex_CreatePush(json).then(function (result) {
	                                    if (result) {
	                                        if (cancelled) return;
	                                        i++;
	                                        push();
	                                    } else {
	                                        var showError = function showError() {
	                                            return UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
	                                                title: AppManager.getLabel('PP_TIT_PUSH_ERROR') || 'Error pushing child promotion',
	                                                message: AppManager.getLabel('PP_LBL_PUSH_ERROR') || 'An error occurred while trying to push the child promotion account',
	                                                type: 'E'
	                                            });
	                                        };
	                                        showError();
	                                    }
	                                });
	                            }
	                        };

	                        _this2.apex_cleanUpPush(JSON.stringify(promoContent)).then(function (result) {
	                            if (result) {
	                                push();
	                            } else {
	                                var showError = function showError() {
	                                    return UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
	                                        title: AppManager.getLabel('PP_TIT_CLEAN_PUSH_ERROR') || 'Error cleaning child promotions',
	                                        message: AppManager.getLabel('PP_LBL_CLEAN_PUSH_ERROR') || 'An error occurred while trying to clean the child promotions account',
	                                        type: 'E'
	                                    });
	                                };
	                                showError();
	                            }
	                        });

	                        //this.refreshPromotion();
	                        return 'break';
	                    }();

	                    if (_ret === 'break') break;
	                }

	            case PromotionActionConstants.FINALIZE_PUSH_CHILD_ACCOUNTS:
	                {
	                    var promoContent = this.serializePromotion();
	                    this.apex_finalizePush(JSON.stringify(promoContent));
	                    console.log('FINALIZE_PUSH for promotion : ' + action.payload);
	                    break;
	                }

	            case PromotionActionConstants.TOGGLE_CHILD_ACCOUNT:
	                {
	                    console.log("PERFORMED ACTION Toggle Child Account for ID:" + action.payload.ChildAccountID);
	                    _.forEach(this.LOExtChildAccounts.getAllItems(), function (childAccount) {
	                        if (childAccount.ChildAccountID == action.payload.ChildAccountID) childAccount.Included = !action.payload.Included;
	                    });
	                    UI_EVENT_BUS.put(EVENTS.UI_BINDING, { promotion: this.serializeTree() });
	                    break;
	                }

	            case PromotionActionConstants.TOGGLE_ALL_CHILD_ACCOUNTS:
	                {
	                    console.log("PERFORMED ACTION Toggle All Child Accounts for Promotion ID:" + this.Id);
	                    _.forEach(this.LOExtChildAccounts.getAllItems(), function (childAccount) {
	                        childAccount.Included = !action.payload.Included;
	                    });
	                    UI_EVENT_BUS.put(EVENTS.UI_BINDING, { promotion: this.serializeTree() });
	                    break;
	                }

	            case PromotionActionConstants.OPEN_PROMOTION:
	                {
	                    var path = location.hostname == 'localhost' ? 'index.html' : 'MyPromotionPlanning';
	                    console.log('OPEN_PROMOTION for promotion : ' + action.payload);
	                    window.open(path + '?id=' + action.payload);
	                    break;
	                }

	            /** Pull Forward attachment */
	            case PromotionActionConstants.CANCEL_UPLOAD:
	                var uploadId = action.payload.uploadId;

	                if (this.uploads[uploadId]) this.uploads[uploadId]();
	                break;

	            case PromotionActionConstants.UPLOAD_ATTACHMENT:
	                {
	                    var me;

	                    var _ret2 = function () {
	                        me = _this2;
	                        var _action$payload = action.payload,
	                            attachment = _action$payload.attachment,
	                            uploadId = _action$payload.uploadId,
	                            promotionAttachment = void 0;


	                        var showError = function showError() {
	                            return _this2.onUIError({
	                                title: AppManager.getLabel('PP_TIT_UPLOAD_ERROR') || 'Error uploading',
	                                message: AppManager.getLabel('PP_LBL_UPLOAD_ERROR') || 'An error occurred while trying to upload the file',
	                                type: 'E'
	                            });
	                        };

	                        _this2.LOExtPromotionAttachment.apex_create(JSON.stringify(_.omit(attachment, ['file', 'previewUrl', 'attachmentUrl', 'LastModifiedDate', 'CreatedDate']))).then(function (att) {

	                            if (!att.__Status) throw new Error();
	                            promotionAttachment = att.data;

	                            return Utils.getThumbnail({
	                                file: attachment.file,
	                                width: 280,
	                                height: 210
	                            });
	                        }).then(function (dataURI) {
	                            return [attachment.file, {
	                                name: attachment.file.name,
	                                description: '#Preview#',
	                                data: dataURI
	                            }];
	                        }, function (error) {
	                            if (promotionAttachment) return [attachment.file];
	                            throw error;
	                        }).then(function (files) {
	                            return Attachment.upload(files, promotionAttachment.Id, function (progress) {
	                                UI_EVENT_BUS.put(uploadId, Math.min(progress, 1 - 1e-7));
	                            }, function (cancel) {
	                                return _this2.uploads[uploadId] = cancel;
	                            });
	                        }).then(function (result) {
	                            delete _this2.uploads[uploadId];
	                            UI_EVENT_BUS.put(uploadId, 1);
	                            if (!result.length) return;
	                            if (result[0].getBoolean("success") && (!result[1] || result[1].getBoolean("success"))) {

	                                promotionAttachment.objectStatus = STATE.NEW;
	                                promotionAttachment.attachmentUrl = '/servlet/servlet.FileDownload?file=' + result[0].get('id');
	                                if (result[1]) {
	                                    promotionAttachment.previewUrl = '/servlet/servlet.FileDownload?file=' + result[1].get('id');
	                                }

	                                me.LOExtPromotionAttachment.addItem(promotionAttachment);
	                                _this2.changeHandler();
	                            } else {
	                                showError();
	                            }
	                        }, function (error) {
	                            delete _this2.uploads[uploadId];
	                            UI_EVENT_BUS.put(uploadId, 1);
	                            showError();
	                        });
	                        return 'break';
	                    }();

	                    if (_ret2 === 'break') break;
	                }

	            case PromotionActionConstants.ATTACHMENT_DELETE:
	                {
	                    var attachmentId = action.payload,
	                        attachment = _.find(me.LOExtPromotionAttachment.getAllItems(), { Id: attachmentId });

	                    attachment.setObjectStatus(STATE.DELETED);
	                    this.changeHandler();
	                    break;
	                }

	            case PromotionActionConstants.CHANGE_WF_STATE:
	                {
	                    var saveObject = this.serializePromotion();
	                    saveObject.target = "Salesforce";
	                    this.apex_invokeWF(this.getId(), action.payload.wfstate, JSON.stringify(saveObject)).then(function (result) {
	                        if (result.__Status) {
	                            _this2.refreshPromotion();
	                            console.log('wfstate changed');
	                        }
	                    });
	                    break;
	                }

	            //PMA - START CODE - 2017-01-12 - Copy date from Promotion to Tactic
	            case PromotionActionConstants.COPY_PROMOTION_DATEFROM_TO_TACTICS:
	                {
	                    this.LOTactic.getAllItems().map(function (tactic) {
	                        if (tactic.getObjectStatus() !== STATE.DELETED) tactic.setDate_From__c(action.payload.date);
	                    });
	                    this.changeHandler();
	                    break;
	                }

	            case PromotionActionConstants.COPY_PROMOTION_DATETHRU_TO_TACTICS:
	                {
	                    this.LOTactic.getAllItems().map(function (tactic) {
	                        if (tactic.getObjectStatus() !== STATE.DELETED) tactic.setDate_Thru__c(action.payload.date);
	                    });
	                    this.changeHandler();
	                    break;
	                }

	            case PromotionActionConstants.COPY_PROMOTION_SHIPMENTDATEFROM_TO_TACTICS:
	                {
	                    this.LOTactic.getAllItems().map(function (tactic) {
	                        if (tactic.getObjectStatus() !== STATE.DELETED) tactic.setShipment_Date_From__c(action.payload.date);
	                    });
	                    this.changeHandler();
	                    break;
	                }

	            case PromotionActionConstants.COPY_PROMOTION_SHIPMENTDATETHRU_TO_TACTICS:
	                {
	                    this.LOTactic.getAllItems().map(function (tactic) {
	                        if (tactic.getObjectStatus() !== STATE.DELETED) tactic.setShipment_Date_Thru__c(action.payload.date);
	                    });
	                    this.changeHandler();
	                    break;
	                }

	            case PromotionActionConstants.COPY_PROMOTION_INSTOREDATEFROM_TO_TACTICS:
	                {
	                    this.LOTactic.getAllItems().map(function (tactic) {
	                        if (tactic.getObjectStatus() !== STATE.DELETED) tactic.setInstore_Date_From__c(action.payload.date);
	                    });
	                    this.changeHandler();
	                    break;
	                }

	            case PromotionActionConstants.COPY_PROMOTION_INSTOREDATETHRU_TO_TACTICS:
	                {
	                    this.LOTactic.getAllItems().map(function (tactic) {
	                        if (tactic.getObjectStatus() !== STATE.DELETED) tactic.setInstore_Date_Thru__c(action.payload.date);
	                    });
	                    this.changeHandler();
	                    break;
	                }
	            //PMA - START CODE - 2017-01-12 - Copy date from Promotion to Tactic

	            //PMA - START CODE - 2017-01-17 - Copy Lift from Promotion to Tactic
	            case PromotionActionConstants.COPY_PROMOTION_LIFT_TO_TACTICS:
	                {
	                    this.LOTactic.getAllItems().map(function (tactic) {
	                        if (tactic.getObjectStatus() !== STATE.DELETED) tactic.setLift__c(action.payload.lift);
	                    });
	                    this.changeHandler();
	                    break;
	                }
	            //PMA - END CODE - 2017-01-17 - Copy Lift from Promotion to Tactic

	            //PMA - START CODE - 2017-01-13 - Threshold button
	            case PromotionActionConstants.BTN_INVOKETHRESHOLD:
	                {
	                    console.log('action.payload', action.payload);
	                    var me = this;
	                    this.apex_invokePromotionThresholdCheck(this.getId()).then(function (result) {
	                        if (result.__Status) {
	                            console.log('BTN_INVOKETHRESHOLD : OK' + result.data);
	                            var prmobj = action.payload.prmobj;
	                            var message = {
	                                title: 'Threshold Check Result',
	                                message: result.data != '' ? '' : 'No thresholds',
	                                messagejson: result.data != '' ? result.data : '',
	                                cancelHandler: function cancelHandler() {
	                                    prmobj.setState({ message: null });
	                                }
	                            };
	                            prmobj.setState({ message: message });
	                        }
	                    });
	                    /* Code for local testing
	                     var prmobj = action.payload.prmobj;
	                     var message = {
	                     title: 'Threshold Check Result',
	                     message: 'No thresholds',
	                     messagejson: '',
	                     cancelHandler: function () {
	                     prmobj.setState({message: null});
	                     }
	                     };
	                     prmobj.setState({message: message});
	                     */
	                    break;
	                }
	            //PMA - START CODE - 2017-01-13 - Threshold button

	            case PromotionActionConstants.BTN_INVOKEAUDITTRAIL:
	                {
	                    console.log('BTN_INVOKEAUDITTRAIL - START');
	                    this.apex_invokeAuditTrail(this.getId()).then(function (result) {
	                        console.log('BTN_INVOKEAUDITTRAIL - RESULT ' + result.__Status);
	                        if (result.__Status) {
	                            console.log('BTN_INVOKEAUDITTRAIL - DATA ' + result.data);
	                            var showError = function showError() {
	                                return UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
	                                    title: 'TEST',
	                                    message: result.data.toString(),
	                                    type: 'W'
	                                });
	                            };
	                            showError();
	                        }
	                    });
	                    break;
	                }

	            case PromotionActionConstants.UPDATE_ENABLE_PUSH:
	                {
	                    var _promoContent = this.serializePromotion();
	                    console.log("PERFORMED ACTION Release Child Accounts for Promotion ID:" + this.Id);
	                    this.apex_UpdateEnablePush(JSON.stringify(_promoContent)).then(function (response) {
	                        if (response.__Status) {
	                            _this2.changeHandler();
	                        } else {
	                            var showError = function showError() {
	                                return UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
	                                    title: AppManager.getLabel('PP_TIT_RELEASE_ERROR') || 'Error updating child promotions',
	                                    message: AppManager.getLabel('PP_LBL_RELEASE_ERROR') || 'An error occurred while trying to release the child promotions account',
	                                    type: 'E'
	                                });
	                            };
	                            showError();
	                        }
	                    });
	                    break;
	                }

	            case PromotionActionConstants.VALIDATE_TACTIC_TIERS:
	                {
	                    var _ret3 = function () {
	                        var newTacticTiers = action.payload.TacticTiers;
	                        console.log("PERFORMED ACTION Validate Tactic Tiers for Tactic ID:" + action.payload.TacticId);
	                        _this2.LOExtTacticTiers.apex_validate(JSON.stringify(newTacticTiers)).then(function (response) {
	                            if (response.__Status) {
	                                (function () {

	                                    var tacticTiers = _.find(_this2.LOExtTacticTiers.getAllItems(), function (item) {
	                                        return item.tacticId == action.payload.TacticId;
	                                    });
	                                    if (tacticTiers) {
	                                        if (!tacticTiers.setJSONTier) tacticTiers.setJSONTier = function (value) {
	                                            tacticTiers.JSONTier = value;
	                                            tacticTiers.objectStatus |= STATE.DIRTY;
	                                        };
	                                        tacticTiers.setJSONTier(JSON.stringify(newTacticTiers));
	                                    } else {
	                                        _this2.LOExtTacticTiers.addItem({
	                                            tacticId: action.payload.TacticId,
	                                            JSONTier: JSON.stringify(newTacticTiers)
	                                        });
	                                    }

	                                    _this2.LOTactic.getAllItems().map(function (tactic) {
	                                        if (tactic.Id === action.payload.TacticId) tactic.InvalidTacticTiers = false;
	                                    });

	                                    _this2.changeHandler();
	                                })();
	                            } else {

	                                _this2.LOTactic.getAllItems().map(function (tactic) {
	                                    if (tactic.Id === action.payload.TacticId) tactic.InvalidTacticTiers = true;
	                                });

	                                _this2.changeHandler();
	                            }
	                        });
	                        return 'break';
	                    }();

	                    if (_ret3 === 'break') break;
	                }

	            case PromotionActionConstants.VALIDATE_FUNDS:
	                {
	                    var newFunds = action.payload.funds;
	                    console.log("PERFORMED ACTION Validate Funds for Tactic ID:" + action.payload.tacticId);
	                    this.LOFund.apex_validate(JSON.stringify(newFunds)).then(function (response) {
	                        if (response.__Status) {

	                            //TODO Prepare data into BOPromotion object (For writeBOPromotion)

	                            _this2.LOTactic.getAllItems().map(function (tactic) {
	                                if (tactic.Id === action.payload.tacticId) tactic.InvalidFunds = false;
	                            });

	                            _this2.changeHandler();
	                        } else {

	                            _this2.LOTactic.getAllItems().map(function (tactic) {
	                                if (tactic.Id === action.payload.tacticId) tactic.InvalidFunds = true;
	                            });

	                            _this2.changeHandler();
	                        }
	                    });
	                    break;
	                }

	            /*
	             case PromotionActionConstants.MYACTION:
	             // Do something here
	             break;
	             */
	            default:
	                console.log('Unknown action type ${payload.actionType} detected. Cannot call appropriate action.');
	                break;
	        }
	    }
	};

		module.exports = Promotion_Cust;

/***/ }
]);
//# sourceMappingURL=contracts.js.map