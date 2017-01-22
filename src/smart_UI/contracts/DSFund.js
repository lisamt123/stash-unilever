var DSFund = {
    'Type': 'DataSource',
    'Name': 'DSFund',
    'IsExternal': false,
    'SFObject': 'Fund__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'write', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false}
    ]
};

module.exports = DSFund;
