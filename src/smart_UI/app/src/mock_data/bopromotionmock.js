global.BOPromotionEAR = [
    {"Type": "Object", "Name": "Promotion__c", "Editable": true},
    {"Type": "Attribute", "Name": "Slogan__c", "Editable": false},
    {"Type": "Attribute", "Name": "Commit_Date__c", "Visible": true},
    {"Type": "Attribute", "Name": "AggregatedKPI", "Visible": false},
    {"Type": "Attribute", "Name": "TacticLift", "Visible": true},
    //PMA - START CODE - 2017-01-12 - Toolbar buttons visibility
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_SUBMIT", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_APPROVE", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_REJECT", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_PUSH", "Visible": true},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_RELEASE", "Visible": true},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_CLOSE", "Visible": true},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_DUPLICATE", "Visible": true},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_DELETE", "Visible": true},
    //PMA - END CODE - 2017-01-12 - Toolbar buttons visibility
    //PMA - START CODE - 2017-01-16 - New UK Button
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_SIMULATION", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_MODEL", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_PLANNED", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_SUBMITTEDFORAPPROVAL", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_REJECTED", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_FINALISED", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_CANCELLED", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_STOPPED", "Visible": false},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_AUDITTRAIL", "Visible": true},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_ADDTACTIC", "Visible": true},
    {"Type": "UIElement", "Name": "TOOLBAR_BTN_THRESHOLD", "Visible": true},
    //PMA - END CODE - 2017-01-16 - New UK Button
    {"Type": "UIElement", "Name": "DELETE_BUTTON", "Editable": true},
    {"Type": "UIElement", "Name": "DERIVE_BUTTON", "Editable": true},
    //API - START CODE - TPM-1499 - New Promo Layout
    {"Type": "UIElement", "Name": "TILE_PROMO_MAIN_UKI", "Visible": true},
    {"Type": "UIElement", "Name": "TILE_PROMO_MAIN_CORE", "Visible": false},
    {"Type": "UIElement", "Name": "TILE_PROMO_MAIN_SOCO", "Visible": false}
    //API - END CODE - TPM-1499 - New Promo Layout
];

var boPromotionMock = {
    read: function (promotionId) {
        var result = {
            '__Model': 'BOPromotion',
            '__Status': true,
            'data': [{
                'Id': 'a1I36000001EWDoEAO',
                'OwnerId': '00536000001kEaAAAU',
                'IsDeleted': false,
                'Name': 'P-0000491',
                'RecordTypeId': '01236000000G21rAAC',
                'CreatedDate': '2016-05-12T11:38:32.000+0000',
                'CreatedById': '00536000001kEaAAAU',
                'LastModifiedDate': '2016-05-12T11:38:32.000+0000',
                'LastModifiedById': '00536000001kEaAAAU',
                'SystemModstamp': '2016-05-12T11:38:32.000+0000',
                'LastViewedDate': '2016-07-13T10:10:45.000+0000',
                'LastReferencedDate': '2016-07-13T10:10:45.000+0000',
                'Active__c': true,
                'Anchor_Account__c': '0013600000KGy48AAD',
                'Anchor_Account_Name': 'Kroger Kansas',
                'Commit_Date__c': '2016-10-03',
                'Date_From__c': '2018-04-03',
                'Date_Thru__c': '2017-04-04',
                'Delivery_Date_From__c': '2016-10-03',
                'Delivery_Date_Thru__c': '2018-06-03',
                'Name__c': 'P-0000491',
                'Order_Date_From__c': '2016-10-03',
                'Order_Date_Thru__c': '2018-06-03',
                'Phase__c': 'Planning',
                'Placement_Date_From__c': '2016-10-03',
                'Placement_Date_Thru__c': '2018-06-03',
                'Promotion_Template_Description__c': 'Account Promotion',
                'Promotion_Template__c': 'a1H36000000eJtmEAE',
                'Slogan_Language_1__c': 'Easter Crisps BOGOF/HGE/Ad',
                'Slogan__c': 'Easter Crisps BOGOF/HGE/Ad',
                'old_id__c': 'a0g61000000OkZOAA0',
                //SoCo
                'UL_Lift__c': 10.2,
                'UL_IIBB_Tax__c': 9,
                'UL_Volume_Type__c':'Shipment',
                'UL_Front_Margin__c' : 15,
                'UL_Current_Status__c':'Inital',
                'UL_Free_Text__c': 'Thats my mocked up comment',
                //PMA - START CODE - 2017-01-12 - New custom field
                'UL_Cannibalisation_Rate__c': 0,
                'UL_Market__c' : 'UL Market',
                //PMA - END CODE - 2017-01-12 - New custom field
                //UKI
                'UL_Delivery_Profile__c' : '',
                'UL_Feature__c' : '',
                'UL_Mechanic__c': '',
                'UL_Sub_Mechanic__c': '',
                'UL_Pre_Evaluation_Comment__c' :  '',
                'UL_Primary_Objective__c': '',
                'UL_Secondary_Objective__c': '',
                'UL_Promotion_Type__c':'',
                'UL_Category__c' : '', 
                'UL_Brand__c' : '', 
                'UL_Cannibalisation_Override__c' : '' ,
                'UL_Post_Dip_End_Date__c' : '',
                'UL_Account__c': '0013600000KGy48AAD' ,
                'UL_Promotion_ID__c': '<a href="/aER4C0000004CC9" target="_self">P-00000021</a>',
            }]
        };

        return result;
    }
};

module.exports = boPromotionMock;
