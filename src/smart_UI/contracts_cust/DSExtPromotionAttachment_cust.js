var DSExtPromotionAttachment = {
    'Type': 'DataSource',
    'Name': 'DSExtPromotionAttachment',
    'IsExternal': true,
    'IsManaged': false,
    'SFObject': 'Promotion_Attachment__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'MyPromotionRemoteActionExtension2', 'Managed': false},
        {'Type': 'create', 'Extension': 'MyPromotionRemoteActionExtension2', 'Managed': false},
        {'Type': 'write', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false},
        {'Type': 'copy', 'Available': false}
    ]
};

module.exports = DSExtPromotionAttachment;
