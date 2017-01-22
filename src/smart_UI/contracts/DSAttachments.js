module.exports = {
    'Type': 'DataSource',
    'Name': 'DSAttachments',
    'IsExternal': false,
    'SFObject': 'Attachment',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Available': true,'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'write', 'Available': true, 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false}
    ]
};
