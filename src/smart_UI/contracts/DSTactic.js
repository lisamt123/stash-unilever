var DSTactic = {
    'Type': 'DataSource',
    'Name': 'DSTactic',
    'IsExternal': false,
    'SFObject': 'Tactic__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'write', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'create', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false, 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'copy', 'Extension': 'PromotionRemoteActionExtension'}
    ]
};

module.exports = DSTactic;
