@isTest
public class BFM_MDFeHandler_Test
{
    private static testMethod void testMDFeHandler()
    {
        Test.startTest();
        
        Account acc = BFM_TestUtils.createCarrierAccount();
        acc.cnpj__c = '03189042000100';
        insert acc;
        
        BFM_MDF_e__c mdf = new BFM_MDF_e__c();
        mdf.name='test1';
        mdf.CT_e_Access_Key__c='1231445';
        mdf.Issuer_CNPJ__c='03189042000100';
        insert mdf;
        
        mdf.MDF_e_Sefaz_Status__c='Sefaz Ok';
        update mdf;
        
        delete mdf;
        
        BFM_SEFAZCalloutMock mockResponse = new BFM_SEFAZCalloutMock();
        Test.setMock(HttpCalloutMock.class, mockResponse);
        BFM_SefazCheck_Utility_CC.sefazcheck(mdf.id, 'test', 'test1', 'test2');
        
    }
}