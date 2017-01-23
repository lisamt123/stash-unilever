var DSAccount_Extension = {
    'Type': 'DataSource',
    'Name': 'DSAccount_Extension',
    'IsExternal': false,
    'SFObject': 'Account_Extension__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        { 'Type': 'read', 'Available': true, 'Extension': 'AccountRemoteActionExtension' }
    ]
};

module.exports = DSAccount_Extension;