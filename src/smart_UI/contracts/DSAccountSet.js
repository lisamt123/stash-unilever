var DSAccount = {
    'Type': 'DataSource',
    'Name': 'DSAccountSet',
    'IsExternal': false,
    'SFObject': 'Account',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'AccountSetRemoteActionExtension'},
        {'Type': 'write', 'Available': false},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false},
        {'Type': 'copy', 'Available': false}
    ]
};

module.exports = DSAccount;
