/**********************************************************************
Name: Core_WP_Test_WorkplaceApp
Copyright © 2015 Salesforce
Project:
-------
Unilever Salesforce Engagement

Purpose:
-------
For Workplace App

History
-------
VERSION AUTHOR   DATE       DETAIL               Description
1.0     Mindtree 29/11/2015 INITIAL DEVELOPMENT  Test class for WorkPlace related classes
***********************************************************************/

@isTest (seeAllData=false)
public class Core_WP_Test_WorkplaceApp{
    
    /*******************************************************************
    Purpose: This method used to cover Core_WP_WorkPlaceController and Core_WP_WorkPlaceControllerHelper classes used for Workplace
    Parameters: 
    Returns: 
    ********************************************************************/ 
    public static testMethod void TestWorkplaceDetails(){
        test.starttest();
        
        Profile p = [Select Id from Profile where Name = 'System Administrator' LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD1234@test1341.com', Email = 'test12341@abc123.com',
                            FirstName = 'Test1234', LastName = 'User1234', alias='tx1234', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',City='100VE');
        insert usr;
        System.assert(usr!= null);
        
        CollaborationGroup objGroup1= new CollaborationGroup(Name = 'my_group1', CollaborationType = 'public');
        insert objGroup1;
        System.assert(objGroup1!= null);
        Workplace__c workplace1=new Workplace__c(Address__c='Test Address1',Floor_Plan__c='Test Floor Plan1',Gym__c='Test Gym1',
                                                HealthandSafety__c='Test Health1',Key_Contacts__c='Test Key1',Location__Latitude__s=51.407836,
                                                Location__Longitude__s=-0.304411,Name='Kingston',Shop__c='Test Shop1',Sustainability_Month1_Value__c=1361,
                                                Sustainability_Month2_Value__c=1321,Sustainability_Month3_Value__c=1244,Sustainability_Target_Value__c=1999,
                                                Transport__c='Test Transport1',Workplace_Group__c=objGroup1.Id,Workplace_Image__c='Test Image1',
                                                Workplace_Local_Groups__c=objGroup1.Id);
        insert workplace1;
        System.assert(workplace1!= null);
        
        Workplace__c workplace2=new Workplace__c(Address__c='Test Address2',Floor_Plan__c='Test Floor Plan2',Gym__c='Test Gym2',
                                                HealthandSafety__c='Test Health2',Key_Contacts__c='Test Key2',Location__Latitude__s=51.407836,
                                                Location__Longitude__s=-0.304411,Name='100VE',Shop__c='Test Shop2',Sustainability_Month1_Value__c=1361,
                                                Sustainability_Month2_Value__c=1321,Sustainability_Month3_Value__c=1244,Sustainability_Target_Value__c=1999,
                                                Transport__c='Test Transport2',Workplace_Group__c=objGroup1.Id,Workplace_Image__c='Test Image2',
                                                Workplace_Local_Groups__c=objGroup1.Id);
        insert workplace2;
        System.assert(workplace2!= null);
        
        Attachment attachmnt1 =new Attachment();
        attachmnt1.name='textfileone.txt';
        attachmnt1.body =blob.valueOf('my attachment text1');
        attachmnt1.ParentId =workplace1.Id;
        insert  attachmnt1;
        System.assert(attachmnt1!= null);
        
        Core_WP_WorkPlaceController.getCurrentUserLocation();
        Core_WP_WorkPlaceController.getworkplaceIdByName('Kingston');
        Core_WP_WorkPlaceController.getWorkplaceDetails(workplace1.Id);
        Core_WP_WorkPlaceController.getKeyDetails(workplace1.Id);
        Core_WP_WorkPlaceController.getDepartmentByFloorDetails(workplace1.Id);
        Core_WP_WorkPlaceController.getHealthyAndSafetyDetails(workplace1.Id);
        Core_WP_WorkPlaceController.getGymScheduleDetails(workplace1.Id);
        Core_WP_WorkPlaceController.getShopTimingsDetails(workplace1.Id);
        Core_WP_WorkPlaceController.getTransportDetails(workplace1.Id);
        Core_WP_WorkPlaceController.getLocalGroups(workplace1.Id);
        Core_WP_WorkPlaceController.getCafeteriaMenuDetails(workplace1.Id);
        Core_WP_WorkPlaceController.getSustainibilityValues(workplace1.Id);
        
        System.runAs(usr) {
            Core_WP_WorkPlaceController.getCurrentUserLocation();
        }
        
        test.stoptest();
    }
    
    /*******************************************************************
    Purpose: This method used to cover Core_WP_EmailService classe used for Workplace
    Parameters: 
    Returns: 
    ********************************************************************/ 
    public static testMethod void TestEmailService(){
        test.starttest();
        
        CollaborationGroup objGroup2= new CollaborationGroup(Name = 'my_group2', CollaborationType = 'public');
        insert objGroup2;
        System.assert(objGroup2!= null);
        Workplace__c workplace3=new Workplace__c(Address__c='Test Address3',Floor_Plan__c='Test Floor Plan3',Gym__c='Test Gym3',
                                                HealthandSafety__c='Test Health3',Key_Contacts__c='Test Key3',Location__Latitude__s=51.407836,
                                                Location__Longitude__s=-0.304411,Name='Kingston',Shop__c='Test Shop3',Sustainability_Month1_Value__c=1361,
                                                Sustainability_Month2_Value__c=1321,Sustainability_Month3_Value__c=1244,Sustainability_Target_Value__c=1999,
                                                Transport__c='Test Transport3',Workplace_Group__c=objGroup2.Id,Workplace_Image__c='Test Image3',
                                                Workplace_Local_Groups__c=objGroup2.Id);
        insert workplace3;
        System.assert(workplace3!= null);
        
        Workplace__c workplace4=new Workplace__c(Address__c='Test Address4',Floor_Plan__c='Test Floor Plan4',Gym__c='Test Gym4',
                                                HealthandSafety__c='Test Health4',Key_Contacts__c='Test Key4',Location__Latitude__s=51.407836,
                                                Location__Longitude__s=-0.304411,Name='100VE',Shop__c='Test Shop4',Sustainability_Month1_Value__c=1361,
                                                Sustainability_Month2_Value__c=1321,Sustainability_Month3_Value__c=1244,Sustainability_Target_Value__c=1999,
                                                Transport__c='Test Transport4',Workplace_Group__c=objGroup2.Id,Workplace_Image__c='Test Image4',
                                                Workplace_Local_Groups__c=objGroup2.Id);
        insert workplace4;
        System.assert(workplace4!= null);
        
        Attachment attachmnt2 =new Attachment();
        attachmnt2.name='textfileone.txt';
        attachmnt2.body =blob.valueOf('my attachment text2');
        attachmnt2.ParentId =workplace3.Id;
        insert  attachmnt2;
        System.assert(attachmnt2!= null);
        
        Core_WP_EmailService emailService=new Core_WP_EmailService();
        
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope= new Messaging.InboundEnvelope();
   
        // setup the data for the email
       
        email.subject = 'Kingston 100ve';
        email.fromAddress = 'someaddress@email.com';
      
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
        // set the body of the attachment
        inAtt.body = blob.valueOf('test');
        inAtt.fileName = 'Menu';
        inAtt.mimeTypeSubType = 'plain/txt';
    
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
  
        emailService.handleInboundEmail(email,envelope);
        
        test.stoptest();
    }
    
}