var DSExtPromotionGrid = {
    'Type': 'DataSource',
    'Name': 'DSExtPromotionGrid',
    'IsExternal': true,
    'SFObject': null,
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {
            'Type': 'getMeta',
            'Managed': false,
            'Extension': 'UL_PromotionPlanningController'
        },
        {
            'Type': 'getData',
            'Extension': 'UL_PromotionPlanningController',
            'Managed': false,
            'Compressed': true,
            'Buffer': false
        }
    ]
};

module.exports = DSExtPromotionGrid;
