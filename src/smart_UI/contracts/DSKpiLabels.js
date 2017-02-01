var DSKpiLabels = {
    'Type': 'DataSource',
    'Name': 'DSKpiLabels',
    'APEX': [
        //Define KPI labels remote extension here
        {
            'Type': 'readLabelsforKpis',
            'Extension': 'KpiDefinitionRemoteActionExtension',
            'Managed': true,
            'Compressed': false,
            'Buffer': true
        }
    ]
};

module.exports = DSKpiLabels;