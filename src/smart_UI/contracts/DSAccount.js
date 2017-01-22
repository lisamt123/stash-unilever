var DSAccount = {
    'Type': 'DataSource',
    'Name': 'DSAccount',
    'IsExternal': false,
    'IsManaged': true,
    'SFObject': 'Account',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'AccountRemoteActionExtension', 'Buffer': false},
        {'Type': 'write', 'Available': false},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false},
        {'Type': 'copy', 'Available': false}
    ]
};

module.exports = DSAccount;
