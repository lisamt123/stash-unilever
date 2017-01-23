var DSMetaData = {
    'Type': 'DataSource',
    'Name': 'DSMetaData',
    'APEX': [
        //Define metadata remote extension here
        {
            'Type': 'getMetaData',
            'Extension': 'MyMetaDataRemoteActionExtension',
            'Managed': false,
            'Compressed': false,
            'Buffer': false,
            'Aggregation': false,
            'CheckLayout': false
        },
        {
            'Type': 'getMetaDataList',
            'Extension': 'MyMetaDataRemoteActionExtension',
            'Managed': false,
            'Compressed': false,
            'Buffer': false
        }
    ]
};

module.exports = DSMetaData;
