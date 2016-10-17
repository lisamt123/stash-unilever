@isTest
public class BFM_NFSUpload_Test{
 static testMethod void testBFM_NFSUpload_Test(){
 BFM_File__c file=new BFM_File__c();
 Blob b = Blob.valueOf('Test Data');
 file.Content_Type__c='application/pdf';
 file.File_Name__c='megha.pdf';
 file.File_Type__c='NFS';
 file.Size__c='1000';
 //file.Body_Blob__c
 insert file;
 
 BFM_NFSUpload nfs=new BFM_NFSUpload(file,b);
 nfs.uploadNFS();
 nfs.isSuccess();
 nfs.getErrors();
 
 }
}