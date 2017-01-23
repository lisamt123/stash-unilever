var DSExtProduct = {
    'Type': 'DataSource',
    'Name': 'DSExtProduct',
    'IsExternal': true,
    'SFObject': null,
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'write', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false}
    ]
};

module.exports = DSExtProduct;
