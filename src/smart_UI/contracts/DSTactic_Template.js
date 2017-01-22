var DSTactic_Template = {
    'Type': 'DataSource',
    'Name': 'DSTactic_Template',
    'IsExternal': false,
    'SFObject': 'Promotion_Template_Tactic_Template__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Extension': 'TacticTemplateRemoteActionExtension'},
        {'Type': 'write', 'Available': false},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false}
    ]
};

module.exports = DSTactic_Template;
