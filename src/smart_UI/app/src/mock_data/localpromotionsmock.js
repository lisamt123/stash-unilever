var localpromotionsmock = {
    read: function (promotionId) {
        var result = {
            '__Model': 'LOCalPromotion',
            '__Status': true,
            'data': [
                /*assuming grouping and sorting will be on apex side */
                //no promotiontemplate yet - will be resolved on the fly from LOPromotionTemplate
                {
                    'Slogan': '4th of July',
                    'Promotions': [{
                        'Date_From': '2016-05-22',
                        'Date_Thru': '2016-06-05',
                        'Phase': 'initial',
                        'Id': 'a1I36000001EWDoEAO'
                    }],
                    'Promotion_Template': 'a1H36000000eJtnEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0xE61074'
                },
                {
                    "Account_Set_Description": "Kroger Stores in Georgia",
                    "Account_Set_Id": "a0D3600000AuHW1EAN",
                    "Commit_Color": "0x551155",
                    "Promotion_Template": "a1H36000000eJtnEAE",
                    "Promotions": [{
                        "Date_From": '2016-05-22',
                        'Date_Thru': '2016-06-05',
                        "Id": "a1L36000001WmEmEAK",
                        "Phase": "Committed"
                    }],
                    "Slogan": "Summer Crispy Activity",
                    "sortValue": 0.0
                },
                {
                    'Slogan': 'Christmas',
                    'Promotions': [{
                        'Date_From': '2016-12-02',
                        'Date_Thru': '2017-01-10',
                        'Id': 'a1I36000001EWDaEAO',
                        'Phase': 'commited'
                    }],
                    'Promotion_Template': 'a1H36000000eJtnEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0xE61074'
                },
                {
                    'Slogan': 'Easter',
                    'Promotions': [{
                        'Date_From': '2016-07-22',
                        'Date_Thru': '2017-01-10',
                        'Id': 'a1I36000001EWDcEAO',
                        'Phase': 'commited'
                    }],
                    'Promotion_Template': 'a1H36000000eJtnEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0xE61074'
                },
                {
                    'Slogan': 'SuperBowl',
                    'Promotions': [{
                        'Id': 'a1I36000001EWDbEAO',
                        'Date_From': '2016-08-02',
                        'Date_Thru': '2016-11-30',
                        'Phase': 'commited'
                    }],
                    'Promotion_Template': 'a1H36000000eJtnEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0xE61074'
                },
                {
                    'Slogan': 'All for Superbowl',
                    'Promotions': [{
                        'Id': 'a1I36000001EWDdEAO',
                        'Phase': 'initial',
                        'Date_From': '2016-05-22',
                        'Date_Thru': '2016-12-30'
                    }],
                    'Promotion_Template': 'a1H36000000eJtoEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0xA6B92C'
                },
                {
                    'Slogan': 'Crips TV campaign',
                    'Promotions': [{
                        'Id': 'a1I36000001EWDeEAO',
                        'Phase': 'initial',
                        'Date_From': '2016-06-22',
                        'Date_Thru': '2017-03-30'
                    }],
                    'Promotion_Template': 'a1H36000000eJtoEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0xA6B92C'
                },
                {
                    'Slogan': 'Salted cookies introduction with an extra of cheese',
                    'Promotions': [{
                        'Id': 'a1I36000001EWDfEAO',
                        'Phase': 'initial',
                        'Date_From': '2016-08-22',
                        'Date_Thru': '2016-08-30'
                    }],
                    'Promotion_Template': 'a1H36000000eJtoEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0xA6B92C'
                },
                {
                    'Slogan': 'Tailor your cookies',
                    'Promotions': [{
                        'Id': 'a1I36000001EWDfEAO',
                        'Phase': 'initial',
                        'Date_From': '2017-01-22',
                        'Date_Thru': '2017-03-30'
                    }],
                    'Promotion_Template': 'a1H36000000eJtoEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0xA6B92C'
                },
                {
                    'Slogan': 'Chocolate pulse 2 x 1',
                    'Promotions': [{
                        'Id': 'a1I36000001EWDgEAO',
                        'Phase': 'initial',
                        'Date_From': '2017-02-22',
                        'Date_Thru': '2017-03-30'
                    }],
                    'Promotion_Template': 'a1H36000000eJtoEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0xA6B92C'
                },
                {
                    'Slogan': 'Crazy Snacks',
                    'Promotions': [{
                        'Id': 'a1I36000001EWDhEAO',
                        'Phase': 'commited',
                        'Date_From': '2017-02-22',
                        'Date_Thru': '2017-03-30'
                    }],
                    'Promotion_Template': 'a1H36000000eJtmEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0x0D8690'
                },
                {
                    'Slogan': 'Easter Cookies optimization',
                    'Promotions': [{
                        'Id': 'a1I36000001EWDiEAO',
                        'Phase': 'commited',
                        'Date_From': '2016-07-22',
                        'Date_Thru': '2017-03-30'
                    }],
                    'Promotion_Template': 'a1H36000000eJtmEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0x0D8690'
                },
                {
                    'Slogan': 'Halloween Cookies',
                    'Promotions': [{
                        'Id': 'a1I36000001EWDjEAO',
                        'Phase': 'commited',
                        'Date_From': '2016-09-22',
                        'Date_Thru': '2016-09-30'
                    }],
                    'Promotion_Template': 'a1H36000000eJtmEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0x0D8690'
                },
                {
                    'Slogan': 'End of Month Sales',
                    'Promotions': [
                        {
                            'Id': 'a1I36000001EWDkEAO',
                            'Phase': 'commited',
                            'Date_From': '2016-03-22',
                            'Date_Thru': '2016-03-30'
                        },
                        {
                            'Id': 'a1I36000001EWDkEAO',
                            'Phase': 'commited',
                            'Date_From': '2016-04-22',
                            'Date_Thru': '2016-04-30'
                        },
                        {
                            'Id': 'a1I36000001EWDkEAO',
                            'Phase': 'commited',
                            'Date_From': '2016-05-22',
                            'Date_Thru': '2016-05-30'
                        },
                        {
                            'Id': 'a1I36000001EWDkEAO',
                            'Phase': 'commited',
                            'Date_From': '2016-06-22',
                            'Date_Thru': '2016-06-30'
                        },
                        {
                            'Id': 'a1I36000001EWDkEAO',
                            'Phase': 'commited',
                            'Date_From': '2016-07-22',
                            'Date_Thru': '2016-07-30'
                        },
                        {
                            'Id': 'a1I36000001EWDkEAO',
                            'Phase': 'commited',
                            'Date_From': '2016-08-22',
                            'Date_Thru': '2016-08-30'
                        }
                    ],
                    'Promotion_Template': 'a1H36000000eJtmEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0x0D8690'
                },
                {
                    'Slogan': 'Crazy Snacks',
                    'Promotions': [{
                        'Id': 'a1I36000001EWDlEAO',
                        'Phase': 'commited',
                        'Date_From': '2016-11-22',
                        'Date_Thru': '2016-11-30'
                    }],
                    'Promotion_Template': 'a1H36000000eJtmEAE',
                    'Account_Name': 'Kroger Atlanta',
                    'Account_Id': '0013600000KGy48AAD',
                    'Commit_Color': '0x0D8690'
                }

            ]
        };

        result.data = result.data.map(cal => {
            cal.Promotions = cal.Promotions.map(prm=> {
                prm.Date_From = Date.parse(prm.Date_From);
                prm.Date_Thru = Date.parse(prm.Date_Thru);
                return prm;
            });
            return cal;
        });
        
        return result;
    }
};

module.exports = localpromotionsmock;
