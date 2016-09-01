@isTest
public class AA_FileUploadUtility_Test {

     static testMethod void saveTheFileTest(){
        Test.startTest();
        String fileName='TestFile';
        String base64Data='TestBase';
        String contentType='png';
         String fileId='';
         //String subjectId='1234';
         //String textToPost='Test2';
         String myString = 'StringToBlob';
         Blob myBlob = Blob.valueof(myString);
       
         Id testId=AA_FileUploadUtility.saveTheChunk(fileName,base64Data,contentType,fileId);
         ContentVersion cv= new ContentVersion(title='test',PathOnClient='test.png',VersionData=myBlob);
         insert cv;
         
       // fileId='068180000002gM7AAI';
        AA_FileUploadUtility.saveTheChunk(fileName,base64Data,contentType,cv.Id);
        Test.stopTest();
    }
}