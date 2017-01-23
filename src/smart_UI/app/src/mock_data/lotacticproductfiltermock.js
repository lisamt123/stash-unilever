var loTacticProductFilter = {
    read: function (promotionId) {
        var result = {
            '__Model': 'LOTacticProductFilter',
            '__Status': true,
            'data': [
                {
                    "tacticId": "a1W36000000qHpkEAE",
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
                        },
                        "manualproducts": [{"included": true, "productid": "a0d6100000ff0OEAXAA4"}]
                    }
                },
                {
                    "tacticId": "a1W36000000qHplEAN",
                    "productfilter": {
                        "criteria": {
                            "category__c": ["Hygiene", "Snacks"],

                            "pack_size__c:": ["10", "20", "30"],
                            "Pack_Size_Unit": ["pk", "box"],
                            "Container_Size": ["100", "200", "250"],
                            "Container_Size_Unit": ["l", "m3"],
                            "Product_Form": ["Solid", "Liquid"],
                            "Container_Type": ["Can", "Bottle", "Plastic"]
                        }
                    }
                },
                {
                    "tacticId": "a1W360000010GJhEAM",
                    "productfilter": {
                        "criteria": {
                            "category__c": ["Hygiene"],
                            "Product_Form": ["Liquid"],
                            "Container_Type": ["Can", "Bottle", "Plastic"]
                        }
                    }
                }
            ]
        };

        return result;
    }
};

module.exports = loTacticProductFilter;
