var DSPromotion = {
    'Type': 'DataSource',
    'Name': 'DSPromotion',
    'IsExternal': false,
    'SFObject': 'Promotion__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Available': true, 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'write', 'Available': true, 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false, 'Extension': 'PromotionRemoteActionExtension'}
    ]
};

module.exports = DSPromotion;
