module.exports = {
    'Type': 'BusinessObject',
    'Name': 'BOAccountPlan',
    'SFObject': null,
    'DataSource': 'DSAccountPlan',
    'BaseClass': 'AccountPlan',
    'IdAttribute': 'Id',
    'Properties': [], // Properties are not explitely defined in release 3
    'ListObjects': [
        {'Name': 'LOAccount'},
        {'Name': 'LOExtPrdFilters'},
        {'Name': 'LOExtMeasure'},
        {'Name': 'LOView'}
    ],
    'Methods': [
        {'Name': 'onInstantiate'},
        {'Name': 'afterInstantiate'},
        {'Name': 'onDispatcher'},
        {'Name': 'onUIError'},
        {'Name': 'preLoad'},
        {'Name': 'postLoad'},

        {'Name': 'loadGrid'},

        {'Name': 'setViewFilterOptions'},
        {'Name': 'updateFilterView'},


        {'Name': 'getFilterCriteria'},
        {'Name': 'serializeUI'},
        {'Name': 'serializeGrid'}
    ]
};
