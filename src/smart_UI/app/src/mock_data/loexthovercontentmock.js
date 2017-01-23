var loexthovercontentmock = {
    responseTime: 1000,
    read: function (promotionId) {
        var hoverdata = [
            {
                'promotionId': 'a1I36000001EWDoEAO',
                'content': {
                    'Tactics': [
                        {
                            'Id': 'a1W36000000qHpkEAE',
                            'Date_From': '2016-04-09',
                            'Date_Thru': '2016-04-28',
                            'Description': 'Display',
                            'TacticTemplate': 'a1V36000000nYQfEAM'
                        },
                        {
                            'Id': 'a1W36000000qHplEAN',
                            'Date_From': '2016-04-09',
                            'Date_Thru': '2016-04-28',
                            'Description': 'BOGOF',
                            'TacticTemplate': 'a1V36000000nYQgEAM'
                        }
                    ]
                }
            },
            {
                'promotionId': 'a1I36000001EWDaEAO',
                'content': {
                    'Tactics': [
                        {
                            'Id': 'a1W36000000qHpkEAE',
                            'Date_From': '2016-04-09',
                            'Date_Thru': '2016-04-28',
                            'Description': 'Display',
                            'TacticTemplate': 'a1V36000000nYQfEAM'
                        },
                        {
                            'Id': 'a1W36000000qHplEAN',
                            'Date_From': '2016-04-09',
                            'Date_Thru': '2016-04-28',
                            'Description': 'BOGOF',
                            'TacticTemplate': 'a1V36000000nYQgEAM'
                        }
                    ]
                }
            },
            {
                'promotionId': 'a1I36000001EWDcEAO',
                'content': {
                    'Tactics': [
                        {
                            'Id': 'a1W36000000qHpkEAE',
                            'Date_From': '2016-04-09',
                            'Date_Thru': '2016-04-28',
                            'Description': 'Display',
                            'TacticTemplate': 'a1V36000000nYQfEAM'
                        },
                        {
                            'Id': 'a1W36000000qHplEAN',
                            'Date_From': '2016-04-09',
                            'Date_Thru': '2016-04-28',
                            'Description': 'BOGOF',
                            'TacticTemplate': 'a1V36000000nYQgEAM'
                        }
                    ]
                }
            }
        ];
        var promoHover = _.find(hoverdata, {promotionId: promotionId});
        var result = {
            '__Model': 'LOExtHoverContent',
            '__Status': true,
            'data': (promoHover) ? [promoHover] : [hoverdata[0]]
        };
        result.data[0].promotionId = promotionId.promotionId;
        return result;
    }
};

module.exports = loexthovercontentmock;
