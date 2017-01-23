var LOTactic = {
    'Type': 'ListObject',
    'Name': 'LOTactic',
    'SFObject': 'Tactic__c',
    'DataSource': 'DSTactic',
    'BaseClass': 'Tactic',
    'Properties': [], // Properties are not explitly defined in release 3
    'Methods': [
        {'Name': 'getProducts'},
        {'Name': 'getProductGroups'},
        {'Name': 'onLoad'}
    ]
};

module.exports = LOTactic;

