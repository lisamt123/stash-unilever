global.LOTacticEAR = [
    {"Type": "Object", "Name": "Tactic__c", "Editable": true},
    {"Type": "Attribute", "Name": "Lift__c", "Visible": false},
    {"Type": "UIElement", "Name": "TACTIC_BTN_MANAGE_PRODS", "Visible": false},
    {"Type": "UIElement", "Name": "TACTIC_BTN_MANAGE_FUNDS", "Visible": true},
    {"Type": "UIElement", "Name": "TACTIC_BTN_MANAGE_TIERS", "Visible": true},
    {"Type": "UIElement", "Name": "ADD_FUND_BUTTON", "Editable": true},
    {"Type": "UIElement", "Name": "DELETE_FUND_BUTTON", "Editable": false}
];

var loTacticMock = {
    read: function (promotionId) {
        /*  if (this.data){
         return this.data;
         }*/
        var result = {
            '__Model': 'LOTactic',
            '__Status': true,
            'data': [{
                'Id': 'a1W36000000qHpkEAE',
                'IsDeleted': false,
                'Name': 'T-0000003',
                'RecordTypeId': '01236000000G21sAAC',
                'CreatedDate': '2016-05-12T12:02:15.000+0000',
                'CreatedById': '00536000001kEaAAAU',
                'LastModifiedDate': '2016-05-30T07:29:36.000+0000',
                'LastModifiedById': '00536000001kEaAAAU',
                'SystemModstamp': '2016-05-30T07:29:36.000+0000',
                'Promotion__c': 'a1I36000001EWDoEAO',
                'Amount__c': 2000.00,
                'Compensation_Model__c': 'LumpSum',
                'Date_From__c': '2016-04-09',
                'Date_Thru__c': '2016-04-28',
                'Included__c': true,
                'Instore_Date_From__c': '2016-04-09',
                'Instore_Date_Thru__c': '2016-04-28',
                'Lift__c': 125.00,
                'Payment_Method__c': 'Deduction',
                'Pct_of_Stores__c': 100.00,
                'Record_Link__c': '<a href=\'/a1W36000000qHpk\' target=\'_self\'>View</a>',
                'Shipment_Date_From__c': '2016-04-09',
                'Shipment_Date_Thru__c': '2016-04-28',
                'Tactic_Template__c': 'a1V36000000nYQfEAM',
                'old_id__c': 'a1P6100000184vUEAQ',
                //PMA - START CODE - 2017-01-12 - New custom field
                'UL_Payment_Method__c': 'Deduction',
                'UL_Redemption__c': 10,
                //PMA - END CODE - 2017-01-12 - New custom field
                "productfilter": {
                    "criteria": {
                        "Category__c": ["Hygiene", "Snacks"],
                        "Criterion_3_product__c": ["a1D36000001z7Rc", "a1D36000001z7Rd", "a1D36000001z7Re"],
                        "Pack_size__c:": ["10", "20", "30"],
                        "Pack_size_unit__c": ["pk", "box"],
                        "Container_size__c": ["100", "200", "250"],
                        "Container_size_unit__c": ["l", "m3"],
                        "Product_form__c": ["Solid", "Liquid"],
                        "Container_type__c": ["Can", "Bottle", "Plastic"]
                    }
                }
            }, {
                'Id': 'a1W36000000qHplEAN',
                'IsDeleted': false,
                'Name': 'T-0000004',
                'RecordTypeId': '01236000000G21sAAC',
                'CreatedDate': '2016-05-12T12:02:15.000+0000',
                'CreatedById': '00536000001kEaAAAU',
                'LastModifiedDate': '2016-05-12T12:02:15.000+0000',
                'LastModifiedById': '00536000001kEaAAAU',
                'SystemModstamp': '2016-05-12T12:02:15.000+0000',
                'Promotion__c': 'a1I36000001EWDoEAO',
                'Amount__c': 25000.00,
                'Compensation_Model__c': 'LumpSum',
                'Date_From__c': '2016-04-09',
                'Date_Thru__c': '2016-04-28',
                'Included__c': true,
                'Instore_Date_From__c': '2016-04-09',
                'Instore_Date_Thru__c': '2016-04-28',
                'Lift__c': 55.00,
                'Payment_Method__c': 'Deduction',
                'Pct_of_Stores__c': 100.00,
                'Record_Link__c': '<a href=\'/a1W36000000qHpl\' target=\'_self\'>View</a>',
                'Shipment_Date_From__c': '2016-04-09',
                'Shipment_Date_Thru__c': '2016-04-28',
                'Tactic_Template__c': 'a1V36000000nYQgEAM',
                'old_id__c': 'a1P6100000184veEAA'
            }, {
                'Id': 'a1W360000010GJhEAM',
                'IsDeleted': false,
                'Name': 'T-0000114',
                'RecordTypeId': '01236000000G21sAAC',
                'CreatedDate': '2016-05-12T12:02:15.000+0000',
                'CreatedById': '00536000001kEaAAAU',
                'LastModifiedDate': '2016-05-12T12:02:15.000+0000',
                'LastModifiedById': '00536000001kEaAAAU',
                'SystemModstamp': '2016-05-12T12:02:15.000+0000',
                'Promotion__c': 'a1I36000001EWDoEAO',
                'Amount__c': 30000.00,
                'Compensation_Model__c': 'LumpSum',
                'Date_From__c': '2016-04-10',
                'Date_Thru__c': '2016-04-28',
                'Included__c': true,
                'Instore_Date_From__c': '2016-04-09',
                'Instore_Date_Thru__c': '2016-04-29',
                'Lift__c': 95.00,
                'Payment_Method__c': 'Deduction',
                'Pct_of_Stores__c': 100.00,
                'Record_Link__c': '<a href=\'/a1W36000000qHrX\' target=\'_self\'>View</a>',
                'Shipment_Date_From__c': '2016-04-09',
                'Shipment_Date_Thru__c': '2016-04-29',
                'Tactic_Template__c': 'a1V36000000nYQfEAM',
                'old_id__c': 'a1P61000000CQeCEAW'
            }]
        };
        this.data = result;

        return result;
    }
};

module.exports = loTacticMock;
