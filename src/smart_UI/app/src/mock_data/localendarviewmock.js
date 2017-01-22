var localendarviewmock = {
    read: function (promotionId) {
        var result = {
            '__Model': 'LOCalendarView',
            '__Status': true,
            'data': [
                {
                    'Id': 'a0a58000001QYEwAAR',
                    'Name': 'Coral Springs',
                    'Description': 'Coral Springs',
                    'IsDefault': true,
                    'FilterCriteria': {
                        "accountfilter": {
                            "criteria": {
                                "account_id__c": ["0013600000KGy47AAD"]
                            }
                        },
                        "promotionfilter": {
                            "criteria": {
                                "promotion_template__c": [],
                                "tactic_template__c": ["a1V36000000nYQfEAM", "a1V36000000nYQfEAM"],

                            }
                        },
                        "productfilter": {
                            "criteria": {
                                "category__c": ["Hygiene", "Snacks"],
                                /*"criterion_3_product__c": ["a1D36000001z7Rc", "a1D36000001z7Rd", "a1D36000001z7Re"],
                                 "Pack_Size:": ["10", "20", "30"],
                                 "Pack_Size_Unit": ["pk", "box"],
                                 "Container_Size": ["100", "200", "250"],
                                 "Container_Size_Unit": ["l", "m3"],
                                 "Product_Form": ["Solid", "Liquid"],
                                 "Container_Type": ["Can", "Bottle", "Plastic"]*/
                            }
                        }

                    }
                },
                {
                    'Id': 'a0a58000001QYExAAR',
                    'Name': 'View Springs',
                    'Description': 'View Springs',
                    'IsDefault': false,
                    'FilterCriteria': {
                        "accountfilter": {
                            "criteria": {
                                "account_id__c": ["0013600000KGy48AAD"]
                            }
                        },
                        "promotionfilter": {
                            "criteria": {
                                "promotion_template__c": ["a1H36000000eJtmEAE"],
                                "tactic_template__c": ["a1V36000000nYQfEAM", "a1V36000000nYQfEAM"],

                            }
                        },
                        "productfilter": {
                            "criteria": {
                                "category__c": ["Hygiene", "Snacks"],
                                "criterion_3_product__c": ["a1D36000001z7Rc", "a1D36000001z7Rd", "a1D36000001z7Re"],
                                "Pack_Size:": ["10", "20", "30"],
                                "Pack_Size_Unit": ["pk", "box"],
                                "Container_Size": ["100", "200", "250"],
                                "Container_Size_Unit": ["l", "m3"],
                                "Product_Form": ["Solid", "Liquid"],
                                "Container_Type": ["Can", "Bottle", "Plastic"]
                            }
                        }

                    }
                }
            ]
        };

        return result;
    }
};

module.exports = localendarviewmock;
