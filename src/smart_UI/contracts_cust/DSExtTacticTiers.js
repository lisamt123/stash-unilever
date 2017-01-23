var DSExtTacticTiers = {
    'Type': 'DataSource',
    'Name': 'DSExtTacticTiers',
    'IsExternal': true,
    'SFObject': 'tactic__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false},
        {'Type': 'write', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'validate', 'Extension': 'MyPromotionRemoteActionExtension', 'Managed': false}
    ]
};

module.exports = DSExtTacticTiers;