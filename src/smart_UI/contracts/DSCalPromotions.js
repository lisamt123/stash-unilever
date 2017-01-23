var DSCalPromotions = {
    'Type': 'DataSource',
    'Name': 'DSCalPromotions',
    'IsExternal': true,
    'SFObject': 'Promotion__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'write', 'Available': false},
        {'Type': 'create', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'delete', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'derive', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'copy', 'Extension': 'PromotionRemoteActionExtension'}
    ]
};

module.exports = DSCalPromotions;