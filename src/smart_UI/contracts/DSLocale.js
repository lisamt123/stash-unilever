var DSCustomLabels = {
    'Type': 'DataSource',
    'Name': 'DSLocale',
    'APEX': [
        //Define locale remote extension here
        {
            'Type': 'getUserSettings',
            'Extension': 'MetaDataRemoteActionExtension',
            'Managed': true,
            'Compressed': false,
            'Buffer': true
        }
    ]
};

module.exports = DSCustomLabels;
