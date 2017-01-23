var loextchartvaluesmock = {
    read: function (promotionId) {
        var result = {
            '__Model': 'LOExtChartValues',
            '__Status': true,
            'data': [
                {
                    "level": "measures",
                    "id": "a1I36000001EWDoEAO",
                    'kpiId': 'LETP',
                    'value': 115000.11
                },
                {
                    "level": "measures",
                    "id": "a1I36000001EWDoEAO",
                    'kpiId': 'PTPC',
                    'value': 150120.55
                },
                {
                    "level": "measures",
                    "id": "a1I36000001EWDoEAO",
                    'kpiId': 'LROI',
                    'value': 120
                },
                {
                    "level": "measures",
                    "id": "a1I36000001EWDoEAO",
                    'kpiId': 'PROI',
                    'value': 300
                },
                {
                    "level": "Tactic",
                    "id": "a1W36000000qHpkEAE",
                    'kpiId': 'LETP',
                    'value': 11000.11
                },
                {
                    "level": "Tactic",
                    "id": "a1W36000000qHpkEAE",
                    'kpiId': 'PTPC',
                    'value': 1120.55
                },
                {
                    "level": "Tactic",
                    "id": "a1W36000000qHpkEAE",
                    'kpiId': 'roi_actual',
                    'value': 15.5
                },
                {
                    "level": "Tactic",
                    "id": "a1W36000000qHpkEAE",
                    'kpiId': 'PROI',
                    'value': 11.5
                }
            ]
        };

        return result;
    }
};

module.exports = loextchartvaluesmock;