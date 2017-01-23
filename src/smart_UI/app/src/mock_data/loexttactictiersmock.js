var loexttactictiersmock = {
    read: function (promotionId) {
        var result = {
            '__Model': 'LOExtTacticTiers',
            '__Status': true,
            'data': [{
                tacticId: 'a1W36000000qHpkEAE',
                JSONTier: '[{"fromValue":1,"toValue":1000,"amount":0.1},{"fromValue":1001,"toValue":2000,"amount":0.2},{"fromValue":2001,"toValue":3000,"amount":0.3}]'
            }]
        };

        return result;
    }
};

module.exports = loexttactictiersmock;
