var lofundmock = {
    read: function (promotionId) {
        var result = {
            '__Model': 'LOFund',
            '__Status': true,
            'data': [{
                'Id': 'a0a58000001QYEwAAQ',
                'OwnerId': '00558000000GwR2AAK',
                'IsDeleted': false,
                'Name': 'F-0003001',
                'CreatedDate': '2016-07-15 07:53:39',
                'CreatedById': '00558000000GwR2AAK',
                'LastModifiedDate': '2016-07-15 07:53:53',
                'LastModifiedById': '00558000000GwR2AAK',
                'SystemModstamp': '2016-07-15 07:53:53',
                'LastViewedDate': '2016-07-15 07:53:53',
                'LastReferencedDate': '2016-07-15 07:53:53',
                'Amount__c': 2000.00,
                'Anchor_Customer__c': '00158000006UnmTAAS',
                'Anchor_Product__c': '123456789012345abc',
                'Description__c': 'Kroger Atlanta Beverages TMC Fund 2017',
                'Description_Language_1__c': 'Kroger Atlanta Beverages TMC Fund 2017 ger Atlanta Beverages TMC Fund 2017',
                'Fund_Template__c': 'a0Z58000000CXXNEA5',
                'Fund_Template_Description__c': 'Trade Marketing Product Fund',
                'Status__c': 'Active',
                'Valid_From__c': '2017-01-01 00:00:00',
                'Valid_Thru__c': '2017-12-31 00:00:00',
                'Tactics': [
                    {
                        'tacticId': 'a1W36000000qHpkEAE',
                        'Allocation__c': 75,
                        'Amount_Allocated__c': 1500.00
                    }
                ]
            }, {
                'Id': 'a0a58000001QYEwAAR',
                'OwnerId': '00558000000GwR2AAK',
                'IsDeleted': false,
                'Name': 'F-0003002',
                'CreatedDate': '2016-07-15 07:53:39',
                'CreatedById': '00558000000GwR2AAK',
                'LastModifiedDate': '2016-07-15 07:53:53',
                'LastModifiedById': '00558000000GwR2AAK',
                'SystemModstamp': '2016-07-15 07:53:53',
                'LastViewedDate': '2016-07-15 07:53:53',
                'LastReferencedDate': '2016-07-15 07:53:53',
                'Amount__c': 1000.00,
                'Anchor_Customer__c': '00158000006UnmTAAS',
                'Anchor_Product__c': '123456789012346abc',
                'Description__c': 'Kroger Atlanta Cookies TMC Fund 2016',
                'Description_Language_1__c': 'Kroger Atlanta Cookies TMC Fund 2016',
                'Fund_Template__c': 'a0Z58000000CXXNEA5',
                'Fund_Template_Description__c': 'Trade Marketing Product Fund',
                'Status__c': 'OnHold',
                'Valid_From__c': '2017-01-01 00:00:00',
                'Valid_Thru__c': '2017-12-31 00:00:00',
                'Tactics': [
                    {
                        'tacticId': 'a1W36000000qHpkEAE',
                        'Allocation__c': 25,
                        'Amount_Allocated__c': 250.00
                    }
                ]
            }]
        };

        return result;
    }
};

module.exports = lofundmock;