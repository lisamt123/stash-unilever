var DSExtPromotionCalendar = {
    'Type': 'DataSource',
    'Name': 'DSExtPromotionCalendar',
    'IsExternal': true,
    'SFObject': null,
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'PromotionPlanningController'}
    ]
};

module.exports = DSExtPromotionCalendar;
