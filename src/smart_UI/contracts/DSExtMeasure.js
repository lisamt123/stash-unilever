var DSExtMeasure = {
    'Type': 'DataSource',
    'Name': 'DSExtMeasure',
    'IsExternal': true,
    'SFObject': null,
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {
            'Type': 'getMeta',
            'Extension': 'AccountRemoteActionExtension'
        },
        {
            'Type': 'getData',
            'Extension': 'AccountRemoteActionExtension',
            'Managed': true,
            'Compressed': true,
            'Buffer': false
        }
    ]
};

module.exports = DSExtMeasure;
