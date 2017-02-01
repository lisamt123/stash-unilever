var DSExtPrdFilters = {
    'Type': 'DataSource',
    'Name': 'DSExtPrdFilters',
    'IsExternal': true,
    'SFObject': null,
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension'},
        {'Type': 'write', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false}
    ]
};

module.exports = DSExtPrdFilters;
