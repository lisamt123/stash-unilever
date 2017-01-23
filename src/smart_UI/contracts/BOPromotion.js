var BO_Promotion = {
    'Type': 'BusinessObject',
    'Name': 'BOPromotion',
    'SFObject': 'Promotion__c',
    'DataSource': 'DSPromotion',
    'BaseClass': 'Promotion',
    'IdAttribute': 'Id',
    'Properties': [], // Properties are not explitely defined in release 3
    'ListObjects': [
        {'Name': 'LOTactic'},
        {'Name': 'LOExtProduct'},
        {'Name': 'LOFilteredProducts'},
        {'Name': 'LOTactic_Template'},
        {'Name': 'LOExtProductFilter'},
        {'Name': 'LOPromotion_Template'},
        { 'Name': 'LOAccount' },
        {'Name': 'LOAccountSet'},
        {'Name': 'LOExtChartValues'},
        {'Name': 'LOFund'},
        {'Name': 'LOFilteredFunds'},
        {'Name': 'LOExtPrdFilters'},
        {'Name': 'LOTacticProductFilter'},
        {'Name': 'LOExtPromotionGrid'}
    ],
    'Methods': [
        {'Name': 'onInstantiate'},
        {'Name': 'afterInstantiate'},
        {'Name': 'getDurationInWeeks'},
        {'Name': 'save'},
{ 'Name': 'onUIError' },
        {'Name': 'onDispatcher'},
        {'Name': 'serializeTree'},
        {'Name': 'serializeProductFilters'},
        {'Name': 'serializeSelectedTactic'},
        {'Name': 'getProductsForTacticID'},
        {'Name': 'applyProductFilter'},
        {'Name': 'addProductsFilter'},
        {'Name': 'searchForProducts'},
       { 'Name': 'addTactic', 'Customize': ['beforeAPEX', 'afterAPEX','post'] },

        {'Name': 'deleteTactic'},
        {'Name': 'duplicateTactic'},
        {'Name': 'resetAllFilters'},
        {'Name': 'setFilter'},
        {'Name': 'getProductGroupsForTacticID'},
        {'Name': 'getFundsForTacticID'},
        {'Name': 'addFunds'},
        {'Name': 'deleteFunds'},
        {'Name': 'getMergedProductFilters'},
        {'Name': 'serializePromotion'},
        {'Name': 'getMergedProductFilterForTactic'},
        {'Name': 'toggleTacticProductFilter'},
        {'Name': 'updateTacticProductFilter'},
        {'Name': 'preLoad'},
        {'Name': 'postLoad'},
        {'Name': 'refreshPromotion'},
        {'Name': 'saveAndRefresh'},
        {'Name': 'loadGrid'},
		{ 'Name': 'serializeToAPEX' },
        { 'Name': 'serializeToUI' },
        {'Name': 'serializeSelectedTacticToUI'}
    ]
};

module.exports = BO_Promotion;
