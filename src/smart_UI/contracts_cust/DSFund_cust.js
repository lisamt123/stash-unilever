var DSFund = {
    'Type': 'DataSource',
    'Name': 'DSFund',
    'IsExternal': false,
    'SFObject': 'Fund__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false},
        {'Type': 'write', 'Extension': 'MyPromotionRemoteActionExtension'},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false},
        {'Type': 'validate', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false}
    ]
};

module.exports = DSFund;
