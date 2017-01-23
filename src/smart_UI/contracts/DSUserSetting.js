var DSUserSetting = {
    'Type': 'DataSource',
    'Name': 'DSUserSetting',
    'IsExternal': false,
    'SFObject': 'User_Setting__c',
    'Attributes': [], // Attributes are not explictly listed in release 3
    'APEX': [
        {'Type': 'read', 'Available': true, 'Extension': 'UserSettingRemoteActionExtension', 'Buffer': false},
        {'Type': 'write', 'Available': true, 'Extension': 'UserSettingRemoteActionExtension'},
        {'Type': 'create', 'Available': false},
        {'Type': 'delete', 'Available': false},
        {'Type': 'getEARights', 'Available': false, 'Extension': 'UserSettingRemoteActionExtension'}
    ]
};

module.exports = DSUserSetting;
