var DSCustomLabels = {
    'Type': 'DataSource',
    'Name': 'DSCustomLabels',
    'APEX': [
        //Define custom labels remote extension here
        {
            'Type': 'readCustomLabelsById',
            'Extension': 'MyContractRemoteActionExtension',
            'Managed': false,
            'Compressed': false,
            'Buffer': true
        }
    ]
};

module.exports = DSCustomLabels;
