var DSPromotion_Template = {
    'Type': 'DataSource',
    'Name': 'DSPromotion_Template',
    'IsExternal': false,
    'SFObject': 'Promotion_Template__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'PromotionTemplateRemoteActionExtension'},
        {'Type': 'write', 'Available': false},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false}
    ]
};

module.exports = DSPromotion_Template;
