/****************************************************************************
 * ClassName: SendEmail_Test
 * Description: Test class for SendEmail_Custom & CustomLookupSelectionController  
 * Author: Accenture Offshore Team
 * *************************************************************************/
@isTest
public class FAU_SendEmail_Test{

PRIVATE STATIC FINAL string email1='s.a.chodisetti@accenture.com';
PRIVATE STATIC FINAL string email2='a.p.chakraborty@accenture.com';
PRIVATE STATIC FINAL string email3='santhosh.kumar.aloor@accenture.com';
PRIVATE STATIC FINAL string email4='dinesh.ab.kumar@accenture.com';
    
/*method Name: SendEmailTest
*/
 static testmethod void sendEmailTest(){  
    test.starttest();
    
    FAU_Participant__c[] lParticipantUL2020 =new FAU_Participant__c[]{}; 
    User FAUEmailu = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);
    User FAUEmailuf = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);
  
    Date startDateFixture = Date.newInstance(2015, 10, 25);
    String locationFixture = 'Singapore';
    String inviteStateFixture = '';

    FAU_Participant__c testFAUParticipant
             = FAU_TestUtil.createParticipantFixture(FAUEmailu, startDateFixture, locationFixture, inviteStateFixture);

    lParticipantUL2020.add(testFAUParticipant);
    
    RecordType recTypeProgram = [SELECT Id FROM RecordType WHERE Name =: 'UL2020' AND SObjectType =: 'FAU_Program__c'];
    
    //Program record
    FAU_Program__c FAUprogramUL2020 = new FAU_Program__c (name= 'testprogram', FAU_Status__c = 'Active', FAU_Primary_Location__c = 'Singapore', FAU_Program_Fee__c = 100);
    FAUprogramUL2020.FAU_Invitation_ResponseDeadline__c = date.newInstance(2016, 12, 30);
    FAUprogramUL2020.FAU_Biography_Deadline__c = date.newInstance(2016, 12, 31);
    FAUprogramUL2020.RecordTypeId = recTypeProgram.id;
    database.insert(FAUprogramUL2020);
  
     //SendEmail_Custom class testing  
     FAU_Email__c ssctestEmailfacr = new FAU_Email__c();
     List<FAU_Email__c> listfauemail = new List<FAU_Email__c>();
     listfauemail.add(ssctestEmailfacr);

     PageReference pf = Page.FAU_SendEmail1;
     test.setCurrentPage(pf);
     pf.getParameters().put('id', FAUprogramUL2020.id);


     FAU_SendEmail_Custom semail= new FAU_SendEmail_Custom(new ApexPages.StandardSetController(listfauemail));
     semail.cancel();
     semail.OpenAttachmentPopup();
     semail.openTemplatePopup();
     semail.closeTemplatePopup();
     semail.templateId = semail.Templatelist.get(0).Id;
     semail.SelectTemplate();
     semail.updateAttachmentList();
     semail.clearToField();
     semail.ToField=FAUEmailu.email;
     semail.ShowAdditionalFieldValue= email1;
     semail.BCcFieldValue= email2;
     semail.CcFieldValue= email3;
     semail.SendEmail(); 

    //CustomLookupSelectionController class testing   
     PageReference pfr = Page.FAU_CustomLookupSelectionPage;
     test.setCurrentPage(pfr);
     pfr.getParameters().put('id', FAUprogramUL2020.id); 
 
     FAU_CustomLookupSelectionController FAUprogcustemail = new FAU_CustomLookupSelectionController();
     FAUprogcustemail.searchString ='test';
     FAUprogcustemail.search();
     FAUprogcustemail.getFormTag();
     FAUprogcustemail.getTextBox();
     test.stoptest();
     
 }
/*method Name: SendEmailTest negative testing on SendEmail_Custom class
*/
/* static testmethod void sendEmailTest2(){  
 
   
 } */

}