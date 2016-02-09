/**********************************************************************
Name: OV_SequenceController_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test for OV_SequenceController
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             02/09/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_SequenceController_Test {

    public static final String recordTypeLabel  = 'RecordType';
    public static final String SUBJECT_LABEL    = 'Subject';

    @isTest
    static void testWithShelf() {
        OV_Fields_Ids__c c = new OV_Fields_Ids__c();
        c.Shelf_Sort_Order__c = 'some sort order 1';
        insert c;

        ApexPages.currentPage().getParameters().put(recordTypeLabel , Schema.SObjectType.OV_Shelf__c.getRecordTypeInfosByName().get(SUBJECT_LABEL).getRecordTypeId());
        String recordType = ApexPages.currentPage().getParameters().get(recordTypeLabel );
        String returnURL = null;
        String ent = null;  

        OV_Shelf__c shelf1 = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);
        OV_Shelf__c shelf2 = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, false);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(shelf2);
        OV_SequenceController controller = new OV_SequenceController(sc);

        OV_Fields_Ids__c customSettings = OV_Fields_Ids__c.getInstance();
        Schema.DescribeSObjectResult objectDesc = shelf2.getSObjectType().getDescribe();
        String url = objectDesc.getKeyPrefix()+'/e?retURL='+returnURL+'&RecordType='+recordType+'&ent='+ent+'&nooverride=1&'+customSettings.Shelf_Sort_Order__c+'=2';

        System.assertEquals(url, controller.urlToRedirect);
    }

    @isTest
    static void testWithoutShelf() {
        OV_Fields_Ids__c c = new OV_Fields_Ids__c();
        c.Shelf_Sort_Order__c = 'some sort order 2';
        insert c;

        ApexPages.currentPage().getParameters().put(recordTypeLabel , Schema.SObjectType.OV_Shelf__c.getRecordTypeInfosByName().get(SUBJECT_LABEL).getRecordTypeId());
        String recordType = ApexPages.currentPage().getParameters().get(recordTypeLabel );
        String returnURL = null;
        String ent = null;  

        OV_Shelf__c shelf1 = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, false);
                
        ApexPages.StandardController sc = new ApexPages.StandardController(shelf1);
        OV_SequenceController controller = new OV_SequenceController(sc);

        OV_Fields_Ids__c customSettings = OV_Fields_Ids__c.getInstance();
        Schema.DescribeSObjectResult objectDesc = shelf1.getSObjectType().getDescribe();
        String url = objectDesc.getKeyPrefix()+'/e?retURL='+returnURL+'&RecordType='+recordType+'&ent='+ent+'&nooverride=1&'+customSettings.Shelf_Sort_Order__c+'=1';

        System.assertEquals(url, controller.urlToRedirect);

        controller.init();


    }

}