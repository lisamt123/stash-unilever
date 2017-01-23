var DSAccount = {
    'Type': 'DataSource',
    'Name': 'DSAccountPlan',
    'IsExternal': false,
    'SFObject': null,
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Available': true},
        {'Type': 'write', 'Available': false},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false}
    ]
};

module.exports = DSAccount;