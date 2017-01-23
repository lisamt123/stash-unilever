var logConfig = {
    config: function (promotionId) {
        var result = {
            'data': [
                {"level": "trace", "target": "ConsoleTarget"},
                {"level": "info", "target": "ApexTarget"}
            ]
        };

        return result;
    }
};

module.exports = logConfig;
