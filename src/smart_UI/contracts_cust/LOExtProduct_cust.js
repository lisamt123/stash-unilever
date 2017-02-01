var LOExtProduct = {
    'Type': 'ListObject',
    'Name': 'LOExtProduct',
    'SFObject': 'Product__c',
    'DataSource': 'DSExtProduct',
    'BaseClass': 'ExtProduct',
    'Properties': [], // Properties are not explitly defined in release 3
    'Methods': [
        {'Name': 'getLabel'},
        {'Name': 'onLoad'},
        {'Name': 'addLabels'}
    ]
};

module.exports = LOExtProduct;
