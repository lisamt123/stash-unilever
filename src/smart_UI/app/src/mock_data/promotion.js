"use strict";

var PromotionService = {
    /****GRID SERVICES***/
    getPromotionsGrid: function (promotionID, handler) {
        //var url ='https://dry-fortress-34630.herokuapp.com/promotion/2/lookup'

        var result = {
            "dimensions": [{
                "name": "Tactic",
                "type": "regular",
                "lookups": ["a1W360000010GJhEAM", "a1W360000010GJiEAM"]
            }, {
                "name": "Product",
                "type": "regular",
                "lookups": ["a1D36000002ZJZzEAO", "a1D36000002ZJZyEAO", "a1D36000002ZJZtEAO", "a1D36000002ZJZsEAO", "a1D36000002ZJZrEAO", "a1D36000002ZJZPEA4", "a1D36000002ZJZOEA4", "a1D36000002ZJZNEA4", "a1D36000002ZJZMEA4", "a1D36000002ZJZLEA4", "a1D36000002ZJZKEA4", "a1D36000002ZJZJEA4", "a1D36000002ZJZIEA4", "a1D36000002ZJZGEA4", "a1D36000002ZJZFEA4", "a1D36000002ZJZEEA4", "a1D36000002ZJZDEA4", "a1D36000002ZJZCEA4", "a1D36000002ZJZBEA4", "a1D36000002ZJZ4EAO", "a1D36000002ZJZ2EAO", "a1D36000002ZJZ1EAO", "a1D36000002ZJZ0EAO", "a1D36000002ZJYKEA4", "a1D36000002ZJYJEA4", "a1D36000002ZJYIEA4", "a1D36000002ZJYHEA4", "a1D36000002ZJYGEA4", "a1D36000002ZJYFEA4", "a1D36000002ZJYEEA4", "a1D36000002ZJYDEA4", "a1D36000002ZJYCEA4", "a1D36000002ZJYBEA4", "a1D36000002ZJYAEA4", "a1D36000002ZJY9EAO", "a1D36000002ZJa0EAG", "a1D36000002Z9uzEAC", "a1D36000002Z2ITEA0", "a1D36000002Z2IJEA0", "a1D36000002XzsYEAS", "a1D36000002XrySEAS"],
                "hierarchy": {
                    "name": "ProductGroup",
                    "lookups": ["a1D36000002ZJVuEAO", "a1D36000002ZJVtEAO", "a1D36000002ZJVsEAO", "a1D36000002ZJX1EAO", "a1D36000002ZJX2EAO", "a1D000000000000000", "a1D36000002Xrz1EAC"],
                    "mapping": [0, 0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 5, 5, 5, 5, 6]
                }
            }, {
                "name": "Measure",
                "type": "measure",
                "lookups": ["Baseline", "Shipment", "LYShipment", "Consumption"]
            }, {
                "name": "Week",
                "type": "time",
                "details": [{
                    "datefrom": 1452988800000,
                    "datethru": 1453507200000,
                    "week": 3,
                    "calendaryear": 2016
                }, {
                    "datefrom": 1453593600000,
                    "datethru": 1454112000000,
                    "week": 4,
                    "calendaryear": 2016
                }, {"datefrom": 1454198400000, "datethru": 1454716800000, "week": 5, "calendaryear": 2016}]
            }],
            "relations": {
                "dimensions": ["Tactic", "Product"],
                "mapping": [[0, 39], [0, 40], [0, 38], [0, 37], [0, 36], [0, 34], [0, 33], [0, 32], [0, 31], [0, 30], [0, 29], [0, 28], [0, 27], [0, 26], [0, 25], [0, 24], [0, 23], [0, 2], [0, 3], [0, 4], [0, 35], [0, 0], [0, 1], [0, 6], [0, 7], [0, 8], [0, 9], [0, 10], [0, 11], [0, 15], [0, 16], [0, 5], [0, 12], [0, 13], [0, 14], [0, 17], [0, 18], [0, 19], [0, 20], [0, 21], [0, 22], [1, 39], [1, 40], [1, 38], [1, 37], [1, 36], [1, 34], [1, 33], [1, 32], [1, 31], [1, 30], [1, 29], [1, 28], [1, 27], [1, 26], [1, 25], [1, 24], [1, 23], [1, 2], [1, 3], [1, 4], [1, 35], [1, 0], [1, 1], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10], [1, 11], [1, 15], [1, 16], [1, 5], [1, 12], [1, 13], [1, 14], [1, 17], [1, 18], [1, 19], [1, 20], [1, 21], [1, 22]]
            },
            "data": [[-1, 40, 0, [42501, 42503, 42500]], [-1, 39, 0, [37001, 37003, 37000]], [-1, 38, 0, [45001, 45003, 45000]], [-1, 37, 0, [50501, 50503, 50500]], [-1, 36, 0, [58501, 58503, 58500]], [-1, 35, 0, [176001, 176003, 176000]], [-1, 34, 0, [149001, 149003, 149000]], [-1, 33, 0, [149501, 149503, 149500]], [-1, 32, 0, [150001, 150003, 150000]], [-1, 31, 0, [150501, 150503, 150500]], [-1, 30, 0, [151001, 151003, 151000]], [-1, 29, 0, [151501, 151503, 151500]], [-1, 28, 0, [152001, 152003, 152000]], [-1, 27, 0, [152501, 152503, 152500]], [-1, 22, 0, [192501, 192503, 192500]], [-1, 21, 0, [192001, 192003, 192000]], [-1, 20, 0, [191501, 191503, 191500]], [-1, 19, 0, [190501, 190503, 190500]], [-1, 18, 0, [187001, 187003, 187000]], [-1, 17, 0, [186501, 186503, 186500]], [-1, 16, 0, [181001, 181003, 181000]], [-1, 15, 0, [180501, 180503, 180500]], [-1, 14, 0, [186001, 186003, 186000]], [-1, 13, 0, [185501, 185503, 185500]], [-1, 12, 0, [184501, 184503, 184500]], [-1, 11, 0, [180001, 180003, 180000]], [-1, 10, 0, [179501, 179503, 179500]], [-1, 9, 0, [179001, 179003, 179000]], [-1, 8, 0, [178501, 178503, 178500]], [-1, 7, 0, [178001, 178003, 178000]], [-1, 6, 0, [177501, 177503, 177500]], [-1, 5, 0, [184001, 184003, 184000]], [-1, 4, 0, [162501, 162503, 162500]], [-1, 3, 0, [162001, 162003, 162000]], [-1, 2, 0, [161501, 161503, 161500]], [-1, 1, 0, [177001, 177003, 177000]], [-1, 0, 0, [176501, 176503, 176500]], [-1, 40, 1, [42501, 42503, 42500]], [-1, 39, 1, [37001, 37003, 37000]], [-1, 38, 1, [45001, 45003, 45000]], [-1, 37, 1, [50501, 50503, 50500]], [-1, 36, 1, [58501, 58503, 58500]], [-1, 35, 1, [176001, 176003, 176000]], [-1, 34, 1, [149001, 149003, 149000]], [-1, 33, 1, [149501, 149503, 149500]], [-1, 32, 1, [150001, 150003, 150000]], [-1, 31, 1, [150501, 150503, 150500]], [-1, 30, 1, [151001, 151003, 151000]], [-1, 29, 1, [151501, 151503, 151500]], [-1, 28, 1, [152001, 152003, 152000]], [-1, 27, 1, [152501, 152503, 152500]], [-1, 22, 1, [192501, 192503, 192500]], [-1, 21, 1, [192001, 192003, 192000]], [-1, 20, 1, [191501, 191503, 191500]], [-1, 19, 1, [190501, 190503, 190500]], [-1, 18, 1, [187001, 187003, 187000]], [-1, 17, 1, [186501, 186503, 186500]], [-1, 16, 1, [181001, 181003, 181000]], [-1, 15, 1, [180501, 180503, 180500]], [-1, 14, 1, [186001, 186003, 186000]], [-1, 13, 1, [185501, 185503, 185500]], [-1, 12, 1, [184501, 184503, 184500]], [-1, 11, 1, [180001, 180003, 180000]], [-1, 10, 1, [179501, 179503, 179500]], [-1, 9, 1, [179001, 179003, 179000]], [-1, 8, 1, [178501, 178503, 178500]], [-1, 7, 1, [178001, 178003, 178000]], [-1, 6, 1, [177501, 177503, 177500]], [-1, 5, 1, [184001, 184003, 184000]], [-1, 4, 1, [162501, 162503, 162500]], [-1, 3, 1, [162001, 162003, 162000]], [-1, 2, 1, [161501, 161503, 161500]], [-1, 1, 1, [177001, 177003, 177000]], [-1, 0, 1, [176501, 176503, 176500]], [-1, 40, 2, [34003, 34000, 34002]], [-1, 39, 2, [29603, 29600, 29602]], [-1, 38, 2, [36003, 36000, 36002]], [-1, 37, 2, [40403, 40400, 40402]], [-1, 36, 2, [46803, 46800, 46802]], [-1, 35, 2, [140803, 140800, 140802]], [-1, 34, 2, [119203, 119200, 119202]], [-1, 33, 2, [119603, 119600, 119602]], [-1, 32, 2, [120003, 120000, 120002]], [-1, 31, 2, [120403, 120400, 120402]], [-1, 30, 2, [120803, 120800, 120802]], [-1, 29, 2, [121203, 121200, 121202]], [-1, 28, 2, [121603, 121600, 121602]], [-1, 27, 2, [122003, 122000, 122002]], [-1, 22, 2, [154003, 154000, 154002]], [-1, 21, 2, [153603, 153600, 153602]], [-1, 20, 2, [153203, 153200, 153202]], [-1, 19, 2, [152403, 152400, 152402]], [-1, 18, 2, [149603, 149600, 149602]], [-1, 17, 2, [149203, 149200, 149202]], [-1, 16, 2, [144803, 144800, 144802]], [-1, 15, 2, [144403, 144400, 144402]], [-1, 14, 2, [148803, 148800, 148802]], [-1, 13, 2, [148403, 148400, 148402]], [-1, 12, 2, [147603, 147600, 147602]], [-1, 11, 2, [144003, 144000, 144002]], [-1, 10, 2, [143603, 143600, 143602]], [-1, 9, 2, [143203, 143200, 143202]], [-1, 8, 2, [142803, 142800, 142802]], [-1, 7, 2, [142403, 142400, 142402]], [-1, 6, 2, [142003, 142000, 142002]], [-1, 5, 2, [147203, 147200, 147202]], [-1, 4, 2, [130003, 130000, 130002]], [-1, 3, 2, [129603, 129600, 129602]], [-1, 2, 2, [129203, 129200, 129202]], [-1, 1, 2, [141603, 141600, 141602]], [-1, 0, 2, [141203, 141200, 141202]], [-1, 40, 3, [42501, 42503, 42500]], [-1, 39, 3, [37001, 37003, 37000]], [-1, 38, 3, [45001, 45003, 45000]], [-1, 37, 3, [50501, 50503, 50500]], [-1, 36, 3, [58501, 58503, 58500]], [-1, 35, 3, [176001, 176003, 176000]], [-1, 34, 3, [149001, 149003, 149000]], [-1, 33, 3, [149501, 149503, 149500]], [-1, 32, 3, [150001, 150003, 150000]], [-1, 31, 3, [150501, 150503, 150500]], [-1, 30, 3, [151001, 151003, 151000]], [-1, 29, 3, [151501, 151503, 151500]], [-1, 28, 3, [152001, 152003, 152000]], [-1, 27, 3, [152501, 152503, 152500]], [-1, 22, 3, [192501, 192503, 192500]], [-1, 21, 3, [192001, 192003, 192000]], [-1, 20, 3, [191501, 191503, 191500]], [-1, 19, 3, [190501, 190503, 190500]], [-1, 18, 3, [187001, 187003, 187000]], [-1, 17, 3, [186501, 186503, 186500]], [-1, 16, 3, [181001, 181003, 181000]], [-1, 15, 3, [180501, 180503, 180500]], [-1, 14, 3, [186001, 186003, 186000]], [-1, 13, 3, [185501, 185503, 185500]], [-1, 12, 3, [184501, 184503, 184500]], [-1, 11, 3, [180001, 180003, 180000]], [-1, 10, 3, [179501, 179503, 179500]], [-1, 9, 3, [179001, 179003, 179000]], [-1, 8, 3, [178501, 178503, 178500]], [-1, 7, 3, [178001, 178003, 178000]], [-1, 6, 3, [177501, 177503, 177500]], [-1, 5, 3, [184001, 184003, 184000]], [-1, 4, 3, [162501, 162503, 162500]], [-1, 3, 3, [162001, 162003, 162000]], [-1, 2, 3, [161501, 161503, 161500]], [-1, 1, 3, [177001, 177003, 177000]], [-1, 0, 3, [176501, 176503, 176500]]]
        };

        var promoObject = boPromotion.serializePromotion();
        //promoObject.LOTactic = boPromotion.LOTactic.serialize();
        boPromotion.LOExtPromotionGrid.apex_getData(JSON.stringify(promoObject)).then(res => {
            handler(JSON.stringify(res.data));
            
        });
    },

    getPromotionsGridMeta: function (promotionID, handler) {
        var result = {
            "axis": {
                "x": "Week",
                "y": ["measures",
                    "Tactic",
                    "Product"]
            },
            "measures": [{
                "name": "Baseline",
                "code": "BASE",
                "type": "read",
                "datasource": {
                    "tablename": "weeklymeasureint",
                    "measurecode": "BASE",
                    "weekoffset": 0
                },
                "aggregation": {
                    "rule": "sum",
                    "skippeddimensions": ["Tactic"]
                },
                "display": {
                    "enabled": true,
                    "round": 0
                },
                "totalcalculation": {
                    "rule": "sum"
                }
            },
                {
                    "name": "TacticBaseline",
                    "code": "BL03",
                    "display": {
                        "enabled": true,
                        "round": 0
                    },
                    "aggregation": {
                        "rule": "sum"
                    },
                    "totalcalculation": {
                        "rule": "sum"
                    },
                    "type": "calculated",
                    "formula": "(Baseline,weekShare) => { return Baseline * weekShare * calcHelper.getVariable('Tactic','pctofstores') / 100}"
                },
                {
                    "name": "BlendedBaseline",
                    "code": "BL02",
                    "display": {
                        "enabled": true,
                        "round": 2
                    },
                    "aggregation": {
                        "rule": "formula"
                    },
                    "totalcalculation": {
                        "rule": "sum"
                    },
                    "type": "calculated",
                    "formula": "(Baseline, TacticBaseline,weekShare) => {return  calcHelper.getLevelName() === 'measures' ? Baseline * weekShare : TacticBaseline; }"
                },
                {
                    "name": "Const",
                    "code": "CNST",
                    "type": "calculated",
                    "aggregation": {
                        "rule": "sum",
                        "skippeddimensions": []
                    },
                    "computed": true,
                    "formula": "()=> { return 1; }",
                    "display": {
                        "enabled": false,
                        "round": 2
                    },
                    "totalcalculation": {
                        "rule": "sum"
                    }
                },
                {
                    "name": "Shipment",
                    "code": "SHIP",
                    "type": "read",
                    "datasource": {
                        "tablename": "weeklymeasureint",
                        "measurecode": "SHIP",
                        "weekoffset": 0
                    },
                    "aggregation": {
                        "rule": "sum",
                        "skippeddimensions": ["Tactic"]
                    },
                    "display": {
                        "enabled": false,
                        "round": 0
                    },
                    "totalcalculation": {
                        "rule": "sum"
                    }
                },
                {
                    "name": "LYShipment",
                    "code": "LYSH",
                    "type": "read",
                    "datasource": {
                        "tablename": "weeklymeasureint",
                        "measurecode": "SHIP",
                        "weekoffset": 52
                    },
                    "aggregation": {
                        "rule": "sum",
                        "skippeddimensions": ["Tactic"]
                    },
                    "display": {
                        "enabled": false,
                        "round": 0
                    },
                    "totalcalculation": {
                        "rule": "sum"
                    }
                },
                {
                    "name": "TotalVolume",
                    "code": "TVLM",
                    "type": "calculated",
                    "aggregation": {
                        "rule": "sum"
                    },
                    "display": {
                        "enabled": true,
                        "round": 0
                    },
                    "totalcalculation": {
                        "rule": "sum"
                    },
                    "formula": "(TacticBaseline,IncrVolume) => { return TacticBaseline + IncrVolume; }"
                },
                {
                    "name": "Consumption",
                    "code": "CONS",
                    "type": "read",
                    "datasource": {
                        "tablename": "weeklymeasureint",
                        "measurecode": "CONS",
                        "weekoffset": 0
                    },
                    "aggregation": {
                        "rule": "sum",
                        "skippeddimensions": ["Tactic"]
                    },
                    "display": {
                        "enabled": false,
                        "round": 0
                    },
                    "totalcalculation": {
                        "rule": "sum"
                    }
                },
                {
                    "name": "IncrVolume",
                    "code": "LIFT",
                    "type": "calculated",
                    "aggregation": {
                        "rule": "sum"
                    },
                    "display": {
                        "enabled": true,
                        "round": 0
                    },
                    "totalcalculation": {
                        "rule": "sum"
                    },
                    "formula": "(TacticBaseline) => { return TacticBaseline  * calcHelper.getVariable('Tactic', 'lift') / 100; } "
                },
                {
                    "name": "Profit",
                    "code": "PRFT",
                    "type": "calculated",
                    "aggregation": {
                        "rule": "sum"
                    },
                    "display": {
                        "enabled": true,
                        "round": 0
                    },
                    "totalcalculation": {
                        "rule": "sum"
                    },
                    "formula": "(weekShare) => { return weekShare * 100; } "
                },
                {
                    "name": "TacticCosts",
                    "code": "Costs",
                    "type": "calculated",
                    "aggregation": {
                        "rule": "sum"
                    },
                    "display": {
                        "enabled": true,
                        "round": 0
                    },
                    "totalcalculation": {
                        "rule": "sum"
                    },
                    "formula": "(TotalVolume$Tactic$Total, TotalVolume) => { return calcHelper.calculateFixedCosts(TotalVolume,TotalVolume$Tactic$Total); }"
                },
                {
                    "name": "ROI",
                    "code": "ROI",
                    "type": "calculated",
                    "aggregation": {
                        "rule": "formula"
                    },
                    "display": {
                        "enabled": true,
                        "round": 2
                    },
                    "totalcalculation": {
                        "rule": "formula"
                    },
                    "formula": "(Profit,TacticCosts) => { return TacticCosts == 0 || TacticCosts == null ? null : 100 * (Profit - TacticCosts) / TacticCosts; }"
                },
                {
                    "name": "dateFrom",
                    "code": "DATE",
                    "type": "calculated",
                    "aggregation": {
                        "rule": "min"
                    },
                    "display": {
                        "enabled": true,
                        "round": 0
                    },
                    "totalcalculation": {
                        "rule": "min"
                    },
                    "formula": "() => { return calcHelper.daysUntilStart(); }"
                },
                {
                    "name": "weekShare",
                    "code": "SHRE",
                    "type": "calculated",
                    "aggregation": {
                        "rule": "formula"
                    },
                    "display": {
                        "enabled": true,
                        "round": 2
                    },
                    "totalcalculation": {
                        "rule": "min"
                    },
                    "formula": "() => { return calcHelper.weekShare() }"
                },
                {
                    "name": "Start or end week",
                    "code": "TATA",
                    "type": "calculated",
                    "aggregation": {
                        "rule": "formula"
                    },
                    "display": {
                        "enabled": true
                    },
                    "totalcalculation": {
                        "rule": "min"
                    },
                    "formula": "() => { return calcHelper.isStartWeek() ? 1 : 0 + calcHelper.isEndWeek() ? 10 : 0  }"
                }
            ],
            variables: {
                "tactics": {
                    "a1W360000010GJhEAM": {
                        "amount": 0.2,
                        "compensationmodel": "PerCase",
                        "datefrom": 1453075200000,
                        "datethru": 1454198400000,
                        "pctofstores": 100,
                        "lift": 110,
                        "tactictype": "PriceReduction"
                    },
                    "a1W360000010GJiEAM": {
                        "amount": 5000,
                        "compensationmodel": "LumpSum",
                        "datefrom": 1453075200000,
                        "datethru": 1454198400000,
                        "pctofstores": 100,
                        "lift": 80,
                        "tactictype": "Display"
                    }
                }, "promotions": {"a1I36000001tBq7EAE": {"datefrom": 1453075200000, "datethru": 1454198400000}}
            }
        };

        var promoObject = boPromotion.serializePromotion();
        boPromotion.LOExtPromotionGrid.apex_getMeta(JSON.stringify(promoObject)).then(res => {

            if (res.data) {
                APEXAbstraction.readCustomLabels(JSON.stringify(res.data.measures.reduce((result, v) => {
                    result.push(v.name);
                    return result;
                }, []))).then(inLabels => {
                    if (inLabels.data) {
                        inLabels = inLabels.data
                    }
                    boPromotion.LOExtProduct.addLabels(inLabels);

                });
            }

            handler(res);
        });
    },

    getKPIforItem: function (itemID, itemType, KPIids, handler) {
        var result = {};
        handler(result);
    },

    getAggregatedKPIforItem: function (itemID, itemType, KPIids, handler) {
        if (itemType == 'product' || itemType == 'productGroup') {
            handler({
                'inc_costs_actual': 1145,
                'inc_costs_planned': 1350,
                'inc_sales_actual': 2875,
                'inc_sales_planned': 2550

            });
        } else {
            var result = {
                'roi_planned': 150120.55,
                'roi_actual': 115000.11,
                'costs_planned': 12.5,
                'costs_actual': 13.5
            };
            handler(result);
        }
    }
};

var ErrorHandler = {
    treatJSRemotingError: function (event) {
        if (event.type === 'exception') {
            alert(event.message + "<br/>\n<pre>" + event.where + "</pre>");
        } else {
            alert(event.message);
        }
    }
};

module.exports.PromotionService = PromotionService;
module.exports.ErrorHandler = ErrorHandler;
