/**********************************************************************
 Name:  FAU_Participant_Biography_Doc_ConTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: This is test class for FAU_Participant_Biography_Doc_Controller Apex Class 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0   Kumar Ravula    27/11/2014      INITIAL DEVELOPMENT   Test for FAU_Participant_Biography_Doc_Controller
***********************************************************************/

@isTest
public class FAU_Participant_Biography_Doc_ConTest{

    /*******************************************************************
    Purpose:  test method to test PDF generation functionality                                                       
    Parameters: Not Required
    Returns: Nothing
    Throws [Exceptions]: No                                                      
    ******************************************************************/

    static testMethod void validateParticipantBiographyDocController(){
        
        Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;       
        
        User u1 = new User(firstName='vanessa1', lastname='barros21', profileId= pp.id,Username = 'vanessa166818@dfg.com', 
                Email='vaness1a@dfg.com', Alias='g116688', CommunityNickname='df1g', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        insert u1;
        
        System.runAs(u1){
            
            FAU_Program__c programobj = new FAU_Program__c();
            programobj.name = 'TestName';
            programobj.FAU_Primary_Location__c = 'TestLocation';
            programobj.FAU_Invitation_ResponseDeadline__c = system.Today();
            programobj.FAU_Status__c='Draft';
            programobj.recordTypeId =  Schema.SObjectType.FAU_Program__c.getRecordTypeInfosByName().get('Core').getRecordTypeId();
        
            insert programobj;
        
            FAU_Webinar__c webinarobj = new FAU_Webinar__c();
            webinarobj.FAU_Title__c='TestTitle';
            webinarobj.FAU_Program_Wave__c = programobj.id;
            webinarobj.FAU_Start_Time__c = system.now();
            webinarobj.FAU_End_Time__c = system.now();
            webinarobj.FAU_URL__c = 'www.google.com';
            webinarobj.FAU_Description__c = 'test description';
        
            insert webinarobj;
        
            programobj.FAU_Status__c='Active';
            update programobj;
        
            FAU_Participant__c participantobj= new FAU_Participant__c();
            participantobj.FAU_Program_Wave__c =programobj.id;
            participantobj.FAU_User__c = u.id;
            participantobj.FAU_Invite_State__c='Accepted';
        
            insert participantobj;
        
            PageReference pf = new PageReference('/apex/FAU_Participant_Biography_Doc?Id='+programobj.id);
            test.setCurrentPage(pf);
            ApexPages.StandardController controller = new ApexPages.StandardController(programobj);
            //FAU_Participant_Biography_Doc_Controller testctrl = new FAU_Participant_Biography_Doc_Controller(controller);
        }
    }
}