@isTest
private class BFM_PublishXML_Test{
private static testMethod void testBFM_PublishXML (){
 blob filebody;
 List<String> errors;
 Test.startTest();
  BFM_File__c file = new BFM_File__c();
    file.File_Name__c = 'testfile';
    file.Size__c = '1MB';
    file.Body_Blob__c='qweeeeeeeeeeeeeeeeeeeeeeee';
    insert file;
    system.assertEquals('testfile', file.File_Name__c);
    BFM_PublishXML xml=new BFM_PublishXML(file,filebody);
    xml.doPublish();

 Test.stopTest();
}
}