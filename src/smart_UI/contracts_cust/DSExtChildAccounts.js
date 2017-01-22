var DSExtChildAccounts = {
    'Type': 'DataSource',
    'Name': 'DSExtChildAccounts',
    'IsExternal': true,
    'IsManaged': false,
    'SFObject': 'Promotion_Acc_Rel__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false},
        {'Type': 'write', 'Available': false},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false}
    ]
};

module.exports = DSExtChildAccounts;