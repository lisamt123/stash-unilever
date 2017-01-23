var loaccountsetmock = {
    read: function (promotionId) {
        var result = {
            '__Model': 'LOAccount',
            '__Status': true,
            'data': [{
                'Id': '0013600000KGy48AAD',
                'IsDeleted': false,
                'Name': 'Kroger Kansas and a very very long name that should not fit into the component',
                'RecordTypeId': '01236000000G21UAAS',
                'BillingAddress': null,
                'ShippingAddress': null,
                'Phone': '+49 (451) 6417 - 132',
                'Fax': '+49 (451) 6417 - 122',
                'OwnerId': '00536000001kEaAAAU',
                'CreatedDate': '2016-05-11T16:05:10.000+0000',
                'CreatedById': '00536000001kEaAAAU',
                'LastModifiedDate': '2016-05-12T07:35:30.000+0000',
                'LastModifiedById': '00536000001kEaAAAU',
                'SystemModstamp': '2016-05-12T07:35:30.000+0000',
                'CustomerPriority__c': 'High',
                'Account_Number__c': '501010200',
                'Account_Template_Description__c': 'Customer',
                'Account_Template__c': 'a0F36000001fDnfEAE',
                'Geolocation__c': null,
                'Name_2__c': 'Kroger Kansas',
                'Description__c': 'Kroger Account Set',
                'Number_Of_Extensions__c': 0,
                'Pkey__c': '0010000000390dam'
            }]
        };

        return result;
    },

    readAll: function () {
        var result = {
            '__Model': 'LOAccountSet',
            '__Status': true,
            'data': [{
                'Id': '0013600000KGy48AAD',
                'IsDeleted': false,
                'Name': 'Kroger Kansas',
                'RecordTypeId': '01236000000G21UAAS',
                'BillingAddress': null,
                'ShippingAddress': null,
                'Phone': '+49 (451) 6417 - 132',
                'Fax': '+49 (451) 6417 - 122',
                'OwnerId': '00536000001kEaAAAU',
                'CreatedDate': '2016-05-11T16:05:10.000+0000',
                'CreatedById': '00536000001kEaAAAU',
                'LastModifiedDate': '2016-05-12T07:35:30.000+0000',
                'LastModifiedById': '00536000001kEaAAAU',
                'SystemModstamp': '2016-05-12T07:35:30.000+0000',
                'CustomerPriority__c': 'High',
                'Account_Number__c': '501010200',
                'Account_Template_Description__c': 'Customer',
                'Account_Template__c': 'a0F36000001fDnfEAE',
                'Geolocation__c': null,
                'Name_2__c': 'Kroger Kansas',
                'Number_Of_Extensions__c': 0,
                'Pkey__c': '0010000000390dam',
                 'Description__c': 'Kroger Account Set'
            }]
        };

        return result;
    }
};

module.exports = loaccountsetmock;
