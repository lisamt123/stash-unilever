var DSExtPromotionGrid = {
    'Type': 'DataSource',
    'Name': 'DSExtPromotionGrid',
    'IsExternal': true,
    'SFObject': null,
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {
            'Type': 'getMeta',
            'Extension': 'PromotionPlanningController'
        },
        {
            'Type': 'getData',
            'Extension': 'PromotionPlanningController',
            'Managed': true,
            'Compressed': true,
            'Buffer': false
        }
    ]
};

module.exports = DSExtPromotionGrid;
