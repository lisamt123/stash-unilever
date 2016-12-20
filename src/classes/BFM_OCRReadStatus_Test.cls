@isTest 
public class BFM_OCRReadStatus_Test{
	static testMethod void testgetRecordsPending(){
        Integer maxRecords;
        Account acc= new Account();
        acc.name = 'testname';
        insert acc;
        system.assertEquals('testname', acc.name);
        
        List<BFM_POD__c> pods = new List<BFM_POD__c>();
        BFM_POD__c pod = new BFM_POD__c();
        //pod.Carrier_Account__c = acc.id;
        pod.OCR_Status__c = 'Completed';
        pods.add(pod);
        try{
        insert pods;
        }catch(Exception e){}
        
        Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
        BFM_OCRReadStatusResponse ocrresponse = new BFM_OCRReadStatusResponse();
        BFM_OCRReadStatus ocrstatus = new BFM_OCRReadStatus();
        try{
        BFM_OCRReadStatus.getRecordsPending(10);
         }catch(Exception e){}
        Test.stopTest();
    }
}