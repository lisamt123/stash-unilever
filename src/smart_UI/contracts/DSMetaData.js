var DSMetaData = {
    'Type': 'DataSource',
    'Name': 'DSMetaData',
    'APEX': [
        //Define metadata remote extension here
        {
            'Type': 'getMetaData',
            'Extension': 'MetaDataRemoteActionExtension',
            'Managed': true,
            'Compressed': false,
            'Buffer': false,
            'Aggregation': true,
            'CheckLayout': false
        },
        {
            'Type': 'getMetaDataList',
            'Extension': 'MetaDataRemoteActionExtension',
            'Managed': true,
            'Compressed': false,
            'Buffer': false
        }
    ]
};

module.exports = DSMetaData;
