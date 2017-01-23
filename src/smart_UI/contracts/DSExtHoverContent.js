var DSExtHoverContent = {
    'Type': 'DataSource',
    'Name': 'DSExtHoverContent',
    'IsExternal': true,
    'SFObject': '',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'PromotionRemoteActionExtension'},
        {'Type': 'write', 'Available': false},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false}
    ]
};

module.exports = DSExtHoverContent;
