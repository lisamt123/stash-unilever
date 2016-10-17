@isTest
private class BFM_PODUpload_Test {
    static testMethod void PODUpload(){
    blob filebody;
    test.startTest();
    BFM_File__c file = new BFM_File__c();
    file.File_Name__c = 'testfile';
    file.Size__c = '1MB';
    insert file;
    system.assertEquals('testfile', file.File_Name__c);
    
    BFM_PODUpload podcont = new BFM_PODUpload(file,filebody);
    //Test.setMock(HttpCalloutMock.class, new BFM_HttpResponceTest_CC());
    podcont.uploadPOD();
    podcont.getErrors();
    podcont.isSuccess = true;
    test.stopTest();
    } 
}