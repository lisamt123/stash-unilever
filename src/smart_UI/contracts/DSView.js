var DSView = {
    'Type': 'DataSource',
    'Name': 'DSView',
    'IsExternal': false,
    'SFObject': 'View__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        { 'Type': 'read', 'Available': true, 'Extension': 'ViewRemoteActionExtension' },
        { 'Type': 'write', 'Available': true, 'Extension': 'ViewRemoteActionExtension' },
        { 'Type': 'create', 'Available': true },
        { 'Type': 'delete', 'Available': true },
        { 'Type': 'getEARights', 'Available': false }
    ]
};

module.exports = DSView;
