//PMA - START CODE - TPM-1498 - Audit Trail
var lopromotionhistory = {
    read: function (promotionId) {
        var result = {
            '__Model': 'LOPromotionHistory',
            '__Status': true,
            'data': [{
                "Name": "Name 1",
                "CreatedDate": '2017-01-15 12:45:30',
                "NewValue": "New value 1-1",
                "OldValue": "Old value 1-2"
            }, {
                "Name": "Name 2",
                "CreatedDate": '2017-01-16 13:45:30',
                "NewValue": "New value 2-1",
                "OldValue": "Old value 2-2"
            }, {
                "Name": "Name 3",
                "CreatedDate": '2017-01-17 14:45:30',
                "NewValue": "New value 3-1",
                "OldValue": "Old value 3-2"
            }]
        };

        return result;
    }
};

module.exports = lopromotionhistory;
//PMA - END CODE - TPM-1498 - Audit Trail */