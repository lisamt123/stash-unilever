var DSPromotion = {
    'Type': 'DataSource',
    'Name': 'DSPromotion',
    'IsExternal': false,
    'SFObject': 'Promotion__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Available': true, 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'write', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension'},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension'},
        {'Type': 'invokeWF', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension'},
        {'Type': 'CreatePush', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension'},
        {'Type': 'cleanUpPush', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension'},
        {'Type': 'finalizePush', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension'},
        //PMA - START CODE - 2017-01-13 - Threshold button
        {'Type': 'invokePromotionThresholdCheck', 'Available': true, 'Managed':false, 'Extension': 'MyPromotionRemoteActionExtension'},
        {'Type': 'invokeAuditTrail', 'Available': true, 'Managed':false, 'Extension': 'MyPromotionRemoteActionExtension'},
        //PMA - END CODE - 2017-01-13 - Threshold button
        {'Type': 'UpdateEnablePush', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension'}
    ]
};

module.exports = DSPromotion;
