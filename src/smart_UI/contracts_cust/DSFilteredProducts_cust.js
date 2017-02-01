var DSFilteredProducts = {
    'Type': 'DataSource',
    'Name': 'DSFilteredProducts',
    'IsExternal': false,
    'SFObject': 'Product__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension'},
        {'Type': 'write', 'Available': false},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false}
    ]
};

module.exports = DSFilteredProducts;
