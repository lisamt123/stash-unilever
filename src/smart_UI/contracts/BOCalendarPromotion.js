module.exports = {
    'Type': 'BusinessObject',
    'Name': 'BOCalendarPromotion',
    'SFObject': null,
    'DataSource': 'DSCalendarPromotion',
    'BaseClass': 'CalendarPromotion',
    'IdAttribute': 'Id',
    'Properties': [], // Properties are not explitely defined in release 3
    'ListObjects': [{'Name': 'LOAccount'}],
    'Methods': [
        {'Name': 'onInstantiate'},
        {'Name': 'afterInstantiate'},
        {'Name': 'onDispatcher'},
        {'Name': 'preLoad'},
        {'Name': 'postLoad'},
        {'Name': 'serializeCalendar'}
    ]
};

