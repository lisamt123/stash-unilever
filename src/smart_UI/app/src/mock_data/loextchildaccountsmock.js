var loextchildaccounts = {
    read: function (promotionId) {
        var result = {
            '__Model': 'LOExtChildAccounts',
            '__Status': true,
            'data': [{
                "ChildAccountID": "0015800000Yzp8qAAB",
                "ChildAccountName": "Test Account 1 AR0100",
                "Included": true,
                "CustomerUnique": "Customer Unique 1",
                "PushedPromoID": "a1R58000003CjyWEAS0",
                "PromotionSlogan": "Promotion Slogan 1"
            }, {
                "ChildAccountID": "0115800000Yzp8qAAB",
                "ChildAccountName": "Test Account 2 AR01",
                "Included": false,
                "CustomerUnique": "Customer Unique 2",
                "PushedPromoID": "a1R58000003CjyWEAS1",
                "PromotionSlogan": "Promotion Slogan 2"
            }]
        };

        return result;
    }
};

module.exports = loextchildaccounts;
