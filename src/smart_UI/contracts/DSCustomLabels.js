var DSCustomLabels = {
    'Type': 'DataSource',
    'Name': 'DSCustomLabels',
    'APEX': [
        //Define custom labels remote extension here
        {
            'Type': 'readCustomLabelsById',
            'Extension': 'ContractRemoteActionExtension',
            'Managed': true,
            'Compressed': false,
            'Buffer': true
        }
    ]
};

module.exports = DSCustomLabels;
