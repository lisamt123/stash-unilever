//PMA - START CODE - TPM-1498 - Audit Trail
var DSPromotionHistory = {
    'Type': 'DataSource',
    'Name': 'DSPromotionHistory',
    'IsExternal': false,
    'SFObject': 'ACCL__Promotion__History',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Available': true, 'Managed': false, 'Extension': 'MyPromotionRemoteActionExtension'},
    ]
};

module.exports = DSPromotionHistory;
//PMA - END CODE - TPM-1498 - Audit Trail */