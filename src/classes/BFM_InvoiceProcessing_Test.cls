@isTest
private class BFM_InvoiceProcessing_Test{
    private static testMethod void testperformInvoiceProcessing(){
        BFM_Error_Log__c errorLog = new BFM_Error_Log__C();
        BFM_MIRO_Header__c miroHeader = new BFM_MIRO_Header__c();
        miroHeader.Access_Key__c='7676578';
        //miroHeader.Annulment_Flag__c
        miroHeader.Annulment_Reason__c='ygyrg';
        //miroHeader.Baseline_Date_for_Due_Date_Calculation__c
        //miroHeader.Cancellation_Flag__c
        miroHeader.Check_Digit_in_Access_Key__c='7';
        //miroHeader.COFINS_Law__c
        miroHeader.Company_Code__c='576';
        //miroHeader.Complement_SES_Flag__c
        miroHeader.Header_Text__c='fyugu';
        miroHeader.Withholding_tax_type__c='fd';
        miroHeader.Withholding_Tax_Code__c='yg';
        system.assertEquals('7676578', miroHeader.Access_Key__c);
        insert miroHeader;
        
        Test.startTest();
        BFM_InvoiceProcessing invoice = new BFM_InvoiceProcessing(miroHeader.id);
        invoice.performInvoiceProcessing();
        Test.stopTest();
        }      
}