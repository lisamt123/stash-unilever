module.exports = {
    'Type': 'BusinessObject',
    'Name': 'BOExtPromotionCalendar',
    'SFObject': null,
    'DataSource': 'DSExtPromotionCalendar',
    'BaseClass': 'ExtPromotionCalendar',
    'IdAttribute': 'Id',
    'Properties': [], // Properties are not explitely defined in release 3
    'ListObjects': [
        {'Name': 'LOAccount'},
        {'Name': 'LOTactic_Template'},
        {'Name': 'LOExtPrdFilters'},
        {'Name': 'LOPromotion_Template'},
        {'Name': 'LOAccountSet'},
        {'Name': 'LOCalendarView'},
        {'Name': 'LOExtCalLegend'},
        {'Name': 'LOExtFiscalYear'},
        {'Name': 'LOCalPromotions'},
        {'Name': 'LOExtHoverContent'}
    ],
    'Methods': [
        {'Name': 'onInstantiate'},
        {'Name': 'afterInstantiate'},
        {'Name': 'onDispatcher'},
 {'Name': 'onUIError'},
        {'Name': 'preLoad'},
        {'Name': 'postLoad'},
        {'Name': 'refreshCalLegend'},
        {'Name': 'serializeCalendar'},
        {'Name': 'refreshCalendarView'},
 {'Name': 'addPromotion', 'Customize': ['beforeAPEX', 'afterAPEX']},
        
        {'Name': 'updateCalendarView'},
{'Name': 'serializeToUI'},
        {'Name': 'getPromotionPlanningPageReference'}
    ]
};

