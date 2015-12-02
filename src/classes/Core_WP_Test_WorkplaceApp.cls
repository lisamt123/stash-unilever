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

@isTest
public class Core_WP_Test_WorkplaceApp{
    
    /*******************************************************************
    Purpose: This method used to cover Core_WP_WorkPlaceController and Core_WP_WorkPlaceControllerHelper classes used for Workplace
    Parameters: 
    Returns: 
    ********************************************************************/ 
    @isTest(SeeAllData=true)
    static void TestWorkplaceDetails(){
        test.starttest();
        
        Profile p = [Select Id from Profile where Name = 'System Administrator' LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD1234@test1341.com', Email = 'test12341@abc123.com',
                            FirstName = 'Test1234', LastName = 'User1234', alias='tx1234', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',City='100VE');
        insert usr;
        System.assert(usr!= null);
        
        CollaborationGroup objGroup= new CollaborationGroup(Name = 'my_group1', CollaborationType = 'public');
        insert objGroup;
        System.assert(objGroup!= null);
        Workplace__c workplace=new Workplace__c(Address__c='Test Address',Floor_Plan__c='Test Floor Plan',Gym__c='Test Gym',
                                                HealthandSafety__c='Test Health',Key_Contacts__c='Test Key',Location__Latitude__s=51.407836,
                                                Location__Longitude__s=-0.304411,Name='Kingston',Shop__c='Test Shop',Sustainability_Month1_Value__c=1361,
                                                Sustainability_Month2_Value__c=1321,Sustainability_Month3_Value__c=1244,Sustainability_Target_Value__c=1999,
                                                Transport__c='Test Transport',Workplace_Group__c=objGroup.Id,Workplace_Image__c='Test Image',
                                                Workplace_Local_Groups__c=objGroup.Id);
        insert workplace;
        System.assert(workplace!= null);
        
        Workplace__c workplace1=new Workplace__c(Address__c='Test Address',Floor_Plan__c='Test Floor Plan',Gym__c='Test Gym',
                                                HealthandSafety__c='Test Health',Key_Contacts__c='Test Key',Location__Latitude__s=51.407836,
                                                Location__Longitude__s=-0.304411,Name='100VE',Shop__c='Test Shop',Sustainability_Month1_Value__c=1361,
                                                Sustainability_Month2_Value__c=1321,Sustainability_Month3_Value__c=1244,Sustainability_Target_Value__c=1999,
                                                Transport__c='Test Transport',Workplace_Group__c=objGroup.Id,Workplace_Image__c='Test Image',
                                                Workplace_Local_Groups__c=objGroup.Id);
        insert workplace1;
        System.assert(workplace1!= null);
        
        Attachment attachmnt =new Attachment();
        attachmnt.name='textfileone.txt';
        attachmnt.body =blob.valueOf('my attachment text');
        attachmnt.ParentId =workplace.Id;
        insert  attachmnt;
        System.assert(attachmnt!= null);
        
        Core_WP_WorkPlaceController.getCurrentUserLocation();
        Core_WP_WorkPlaceController.getworkplaceIdByName('Kingston');
        Core_WP_WorkPlaceController.getWorkplaceDetails(workplace.Id);
        Core_WP_WorkPlaceController.getKeyDetails(workplace.Id);
        Core_WP_WorkPlaceController.getDepartmentByFloorDetails(workplace.Id);
        Core_WP_WorkPlaceController.getHealthyAndSafetyDetails(workplace.Id);
        Core_WP_WorkPlaceController.getGymScheduleDetails(workplace.Id);
        Core_WP_WorkPlaceController.getShopTimingsDetails(workplace.Id);
        Core_WP_WorkPlaceController.getTransportDetails(workplace.Id);
        Core_WP_WorkPlaceController.getLocalGroups(workplace.Id);
        Core_WP_WorkPlaceController.getCafeteriaMenuDetails(workplace.Id);
        Core_WP_WorkPlaceController.getSustainibilityValues(workplace.Id);
        
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
        
        CollaborationGroup objGroup= new CollaborationGroup(Name = 'my_group1', CollaborationType = 'public');
        insert objGroup;
        System.assert(objGroup!= null);
        Workplace__c workplace=new Workplace__c(Address__c='Test Address',Floor_Plan__c='Test Floor Plan',Gym__c='Test Gym',
                                                HealthandSafety__c='Test Health',Key_Contacts__c='Test Key',Location__Latitude__s=51.407836,
                                                Location__Longitude__s=-0.304411,Name='Kingston',Shop__c='Test Shop',Sustainability_Month1_Value__c=1361,
                                                Sustainability_Month2_Value__c=1321,Sustainability_Month3_Value__c=1244,Sustainability_Target_Value__c=1999,
                                                Transport__c='Test Transport',Workplace_Group__c=objGroup.Id,Workplace_Image__c='Test Image',
                                                Workplace_Local_Groups__c=objGroup.Id);
        insert workplace;
        System.assert(workplace!= null);
        
        Workplace__c workplace1=new Workplace__c(Address__c='Test Address',Floor_Plan__c='Test Floor Plan',Gym__c='Test Gym',
                                                HealthandSafety__c='Test Health',Key_Contacts__c='Test Key',Location__Latitude__s=51.407836,
                                                Location__Longitude__s=-0.304411,Name='100VE',Shop__c='Test Shop',Sustainability_Month1_Value__c=1361,
                                                Sustainability_Month2_Value__c=1321,Sustainability_Month3_Value__c=1244,Sustainability_Target_Value__c=1999,
                                                Transport__c='Test Transport',Workplace_Group__c=objGroup.Id,Workplace_Image__c='Test Image',
                                                Workplace_Local_Groups__c=objGroup.Id);
        insert workplace1;
        System.assert(workplace1!= null);
        
        Attachment attachmnt =new Attachment();
        attachmnt.name='textfileone.txt';
        attachmnt.body =blob.valueOf('my attachment text');
        attachmnt.ParentId =workplace.Id;
        insert  attachmnt;
        System.assert(attachmnt!= null);
        
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