/**********************************************************************
 Name:  FAU_ProgramTest()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Test Methods for FAU_Program & FAU_PArticipant                                                   
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
@isTest
private class FAU_ProgramTest {
    private static String PROFILE_PARTICIPANT_HOLDS = 'System Administrator';
    private static String PROGRAM_STATUS_NEW = 'Not yet invited';
    private static String PROGRAM_STATUS_ACTIVE = 'Active';
    private static String PARTICIPANT_STATUS_DECLINED = 'Declined';
    private static String PARTICIPANT_STATUS_ACCEPTED = 'Accepted';
  
  	@isTest
  	private static void completeProgramTest(){
  		FAU_Program__c program = FAU_TestUtil.buildProgram('Test Program', Date.today(), 'Test Location');
        insert program;
        FAU_Webinar__c webinar =  FAU_TestUtil.createWebinar(program);
        program.FAU_Status__c = 'Active';
        program.FAU_Participant_Chatter_Group_Id__c  = 'test1234test';
        update program;
        FAU_Participant__c participant = FAU_TestUtil.buildParticipant(null, 'Test State', program);
        insert participant;        
        program.FAU_Status__c = 'Completed';
        update program;
        FAU_Participant__c partAfter = [select FAU_Invite_State__c from FAU_Participant__c where id=:participant.id];
        System.assertEquals(partAfter.FAU_Invite_State__c,'Completed');
  	}
    
    @isTest
    static void testInsertParticipant()
    {
    	
    	Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;   
    	
    	System.runAs(u){
	        User[] users = createUsersWithProfile(PROFILE_PARTICIPANT_HOLDS, 1);
	
	        Date startDateFixture = Date.newInstance(2015, 10, 25);
	        String locationFixture = 'Singapore';
	        String inviteStateFixture = 'Invited';
	             
	        Test.startTest();
	
	        FAU_Participant__c participantRecord
	             = createParticipantFixture(users[0], startDateFixture, locationFixture, inviteStateFixture);
	        
	        Test.stopTest();
	        
	        Integer iNoPartShare = [Select Id FROM FAU_Participant__Share WHERE ParentId = :participantRecord.Id 
	                                                                AND UserOrGroupId = :users[0].Id  
	                                                                AND AccessLevel = 'Edit'  LIMIT 1].size();
	        System.assertEquals(1, iNoPartShare);
	
	        //module partcipant
	        Integer iNoPartMod = [Select Id FROM FAU_Module_Participant__c WHERE FAU_Participant__c = :participantRecord.Id LIMIT 1].size();
	        System.assertEquals(1, iNoPartMod);     
	
	        //webinar partcipant
	        Integer iNoWebMod = [Select Id FROM FAU_Webinar_Participant__c WHERE FAU_Participant__c = :participantRecord.Id LIMIT 1].size();
	          
	        System.assertEquals(1, iNoWebMod);   
	
	         //milestone partcipant
	        Integer iNoMileMod = [Select Id FROM FAU_Milestone_Participant__c WHERE FAU_Participant__c = :participantRecord.Id LIMIT 1].size();
	          
	        System.assertEquals(1, iNoMileMod); 
    	}
    }

    @isTest 
    static void testFailInsertParticipant(){
        
        FAU_Program__c programRecord = new FAU_Program__c();
        
        Test.startTest();
        try
        {
            insert programRecord;
         
         }
        catch(Exception e)
        {
            //Boolean expectedExceptionThrown =  e.getMessage().size();
            System.Debug('#### expectedExceptionThrown ' + e.getMessage()); 
            //System.AssertEquals(expectedExceptionThrown, true);
        } 
        Test.stopTest();
    } 
 


    @isTest
    static void testUpdateParticipant()
    {
    	Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;   
    	
    	System.runAs(u){
    			
	        User[] users = createUsersWithProfile(PROFILE_PARTICIPANT_HOLDS, 2);
	        //User[] user2 = createUserWithProfile(PROFILE_PARTICIPANT_HOLDS, 1);
	
	        Date startDateFixture = Date.newInstance(2015, 10, 25);
	        String locationFixture = 'Singapore';
	        String inviteStateFixture = 'Invited';
	
	        FAU_Participant__c participantRecord
	             = createParticipantFixture(users[0], startDateFixture, locationFixture, inviteStateFixture); 
	             
	        Test.startTest();
	
	        participantRecord.FAU_User__c = users[1].Id;
	        update participantRecord;
	        
	        Test.stopTest();
	        
	        Integer iNoShare = [Select Id FROM FAU_Participant__Share WHERE ParentId = :participantRecord.Id 
	                                                                AND UserOrGroupId = :users[1].Id  
	                                                                AND AccessLevel = 'Edit'  LIMIT 1].size();
	        System.assertEquals(1, iNoShare);
    	}
             
    }
    
    @isTest
    static void testUpdateStatusDeclineParticipant()
    {
    	
    	Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;   
    	
    	System.runAs(u){
	        User[] users = createUsersWithProfile(PROFILE_PARTICIPANT_HOLDS, 2);
	        //User[] user2 = createUserWithProfile(PROFILE_PARTICIPANT_HOLDS, 1);
	
	        Date startDateFixture = Date.newInstance(2015, 10, 25);
	        String locationFixture = 'Singapore';
	        String inviteStateFixture = PROGRAM_STATUS_NEW;
	
	        FAU_Participant__c participantRecord
	             = createParticipantFixture(users[0], startDateFixture, locationFixture, inviteStateFixture); 
	             
	        Test.startTest();
	
	        participantRecord.FAU_Invite_State__c = PARTICIPANT_STATUS_DECLINED;
	        update participantRecord;
	        
	        Test.stopTest();
	        
	        Integer iNoShare = [Select Id FROM FAU_Participant__Share WHERE ParentId = :participantRecord.Id 
	                                                                AND UserOrGroupId = :users[0].Id  
	                                                                AND AccessLevel = 'Edit'  LIMIT 1].size();
	        System.assertEquals(0, iNoShare);
    	}
             
    }
    
    @isTest
    static void testUpdateStatusAcceptParticipant()
    {
    	Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;   
    	
    	System.runAs(u){	
	        User[] users = createUsersWithProfile(PROFILE_PARTICIPANT_HOLDS, 2);
	        //User[] user2 = createUserWithProfile(PROFILE_PARTICIPANT_HOLDS, 1);
	
	        Date startDateFixture = Date.newInstance(2015, 10, 25);
	        String locationFixture = 'Singapore';
	        String inviteStateFixture = PARTICIPANT_STATUS_DECLINED;
	
	        FAU_Participant__c participantRecord
	             = createParticipantFixture(users[0], startDateFixture, locationFixture, inviteStateFixture); 
	             
	        Test.startTest();
	
	        participantRecord.FAU_Invite_State__c = PARTICIPANT_STATUS_ACCEPTED;
	        participantRecord.FAU_Personal_Assistant__c = users[1].id;
	        update participantRecord;
	        participantRecord.FAU_Personal_Assistant__c = null;
	        update participantRecord;
	        
	        Test.stopTest();
	        
	        Integer iNoShare = [Select Id FROM FAU_Participant__Share WHERE ParentId = :participantRecord.Id 
	                                                                AND UserOrGroupId = :users[0].Id  
	                                                                AND AccessLevel = 'Edit'  LIMIT 1].size();
	        System.assertEquals(1, iNoShare);
    	}
             
    }
    
    @isTest
    static void testUpdateRequestEmailAcceptParticipant()
    {
    	Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;   
    	
    	System.runAs(u){	
	        User[] users = createUsersWithProfile(PROFILE_PARTICIPANT_HOLDS, 2);
	        //User[] user2 = createUserWithProfile(PROFILE_PARTICIPANT_HOLDS, 1);
	
	        Date startDateFixture = Date.newInstance(2015, 10, 25);
	        String locationFixture = 'Singapore';
	        String inviteStateFixture = PARTICIPANT_STATUS_DECLINED;
	
	        FAU_Participant__c participantRecord
	             = createParticipantFixture(users[0], startDateFixture, locationFixture, inviteStateFixture); 
	             
	        Test.startTest();
	
	        participantRecord.FAU_Request_PA_User_Email_Address__c = 'test@test.com';
	        update participantRecord;
	        
	        Test.stopTest();
	        
	         // ensure that the opp was submitted for approval
        	ProcessInstance[] processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :participantRecord.id];
    		System.assertEquals(processInstances.size(),1);
    	}
             
    }
    
    @isTest
    static void testRemoveParticipant()
    {
    	Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;   
    	
    	System.runAs(u){
	    		
	        User[] user1 = createUsersWithProfile(PROFILE_PARTICIPANT_HOLDS, 1);
	
	        Date startDateFixture = Date.newInstance(2015, 10, 25);
	        String locationFixture = 'Singapore';
	        String inviteStateFixture = PROGRAM_STATUS_NEW;
	
	
	        FAU_Participant__c participantRecord
	             = createParticipantFixture(user1[0], startDateFixture, locationFixture, inviteStateFixture);
	        
	        Test.startTest();
	            participantRecord.FAU_User__c = null;
	            update participantRecord;
	        Test.stopTest();
	        
	        Integer iNoPartShare = [Select Id FROM FAU_Participant__Share WHERE ParentId = :participantRecord.Id 
	                                                                AND UserOrGroupId = :user1[0].Id  
	                                                                AND AccessLevel = 'Edit'  LIMIT 1].size();
	        System.assertEquals(0, iNoPartShare);
    	}
             
    }

    static void testInsertWebinarParticipant()
    {
    	Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;   
    	
    	System.runAs(u){
	        User[] users = createUsersWithProfile(PROFILE_PARTICIPANT_HOLDS, 1);
	
	        Date startDateFixture = Date.newInstance(2015, 10, 25);
	        String locationFixture = 'Singapore';
	        String inviteStateFixture = 'Invited';
	             
	        
	
	        FAU_Participant__c participantRecord
	             = createParticipantFixture(users[0], startDateFixture, locationFixture, inviteStateFixture);
	        
	        FAU_Webinar__c webinarRecord = new FAU_Webinar__c();
	        webinarRecord.FAU_Program_Wave__c = participantRecord.FAU_Program_Id__c;
	        webinarRecord.FAU_End_Time__c = date.today() + 100;
	        webinarRecord.FAU_Start_Time__c = date.Today() + 90;
	        webinarRecord.FAU_URL__c = 'wwww.Google.com';
	        webinarRecord.FAU_Title__c = 'Sample';
	        insert webinarRecord; 
	
	        Test.startTest();
	        FAU_Webinar_Participant__c webinarParticipant = new FAU_Webinar_Participant__c();
	        webinarParticipant.FAU_Participant__c = participantRecord.Id;
	        webinarParticipant.FAU_Webinar__c = webinarRecord.Id;
	        webinarParticipant.FAU_Has_Accepted__c = true;
	        insert webinarParticipant;
	        Test.stopTest(); 
	        //webinar partcipant
	        Integer iNoWebPart = [Select Id FROM FAU_Webinar_Participant__c WHERE FAU_Participant__c = :participantRecord.Id 
	                                                                        AND FAU_Webinar__c = :webinarRecord.Id LIMIT 1].size();
	         
	        System.assertEquals(1, iNoWebPart);  
    	} 
    }

    
    @isTest
    static void testNegativeSecurityParticipant()
    {
    	Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;   
    	
    	System.runAs(u){
	        User[] users = createUsersWithProfile(PROFILE_PARTICIPANT_HOLDS, 2);
	
	        Date startDateFixture = Date.newInstance(2015, 10, 25);
	        String locationFixture = 'Singapore';
	        String inviteStateFixture = PROGRAM_STATUS_NEW;
	
	
	        FAU_Participant__c participantRecord
	             = createParticipantFixture(users[0], startDateFixture, locationFixture, inviteStateFixture);
	        
	        Test.startTest();
	            participantRecord.FAU_User__c = null;
	            update participantRecord;
	        Test.stopTest();
	        
	        Integer iNoPartShare = [Select Id FROM FAU_Participant__Share WHERE ParentId = :participantRecord.Id 
	                                                                AND UserOrGroupId = :users[1].Id  
	                                                                AND AccessLevel = 'Edit'  LIMIT 1].size();
	        System.assertEquals(0, iNoPartShare);
    	}
             
    }

    @isTest
    static void testModuleUpdate()
    {
        Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;   
    	
    	System.runAs(u){
	        
	        User[] users = createUsersWithProfile(PROFILE_PARTICIPANT_HOLDS, 1);
	
	        Date startDateFixture = Date.newInstance(2015, 10, 25);
	        String locationFixture = 'Singapore';
	        String inviteStateFixture = 'Invited';
	        
	        FAU_Participant__c participantRecord
	             = FAU_TestUtil.createParticipantFixture(users[0], startDateFixture, locationFixture, inviteStateFixture);
	        
	        FAU_Module__c module1 = new FAU_Module__c();
	        module1.FAU_Description__c = 'Module 1 Description'; 
	        module1.FAU_Program__c = participantRecord.FAU_Program_Wave__c;
	        module1.FAU_Start_Date__c = Date.newInstance(2016, 06, 26);
	        module1.FAU_End_Date__c = Date.newInstance(2016, 06, 27);
	        insert module1;
	        
	        Test.startTest();
	            module1.FAU_Start_Date__c = Date.newInstance(2016, 06, 25);
	            update module1;
	        Test.stopTest();
	        
	        Date dtWorkflowStartDate= [Select Id,  FAU_Workflow_Start_Date__c FROM FAU_Module_Participant__c 
	                                    WHERE FAU_Module__c = :module1.Id 
	                                    LIMIT 1].FAU_Workflow_Start_Date__c;
	        System.assertEquals(module1.FAU_Start_Date__c, dtWorkflowStartDate);
    	}         
    }
    
    static private FAU_Participant__c createParticipantFixture(User user, Date startDate, String location, String inviteState)
    {
        FAU_Program__c programRecord = new FAU_Program__c();
        programRecord.FAU_Start_Date__c = startDate;
        programRecord.FAU_Primary_Location__c = location;
        programRecord.recordTypeId =  Schema.SObjectType.FAU_Program__c.getRecordTypeInfosByName().get('Core').getRecordTypeId();


        insert programRecord;
 
        FAU_Module__c module1 = new FAU_Module__c();
        module1.FAU_Description__c = 'Module 1 Description'; 
        module1.FAU_Program__c = programRecord.Id;
        module1.FAU_Start_Date__c = Date.newInstance(2016, 06, 26);
        module1.FAU_End_Date__c = Date.newInstance(2016, 06, 27);
        insert module1;

        FAU_Webinar__c webinar1 = new FAU_Webinar__c();
        webinar1.FAU_Description__c = 'Webinar 1 Description';
        webinar1.FAU_Title__c = 'Its all about stuff';
        webinar1.FAU_Program_Wave__c = programRecord.Id;
        webinar1.FAU_Start_Time__c = Date.newInstance(2016, 10, 27);
        webinar1.FAU_End_Time__c = Date.newInstance(2016, 10, 27);
        webinar1.FAU_URL__c = 'http://google.com';
        insert webinar1;
        FAU_Webinar__c webinar2 = new FAU_Webinar__c();
        webinar2.FAU_Description__c = 'Webinar 1 Description';
        webinar2.FAU_Title__c = 'Its all about stuff';
        webinar2.FAU_Program_Wave__c = programRecord.Id;
        webinar2.FAU_Start_Time__c = Date.newInstance(2016, 10, 27);
        webinar2.FAU_End_Time__c = Date.newInstance(2016, 10, 27);
        webinar2.FAU_URL__c = 'http://google.com';
        insert webinar2;

        FAU_Milestone__c Milestone1 = new FAU_Milestone__c();
        Milestone1.FAU_Description__c = 'Description 1: Its all about stuff';
        Milestone1.FAU_Program_Wave__c = programRecord.Id;
        Milestone1.FAU_1st_Reminder__c = Date.newInstance(2016, 10, 27);
        Milestone1.FAU_2nd_Reminder__c = Date.newInstance(2016, 10, 27);
        Milestone1.FAU_Due_Date__c = Date.newInstance(2016, 10, 27);
        Milestone1.FAU_Milestone_Completition__c = 'Participant Update';
        insert Milestone1;

        programRecord.FAU_Status__c = PROGRAM_STATUS_ACTIVE;
        update programRecord;

        FAU_Participant__c participantRecord = new FAU_Participant__c();
        participantRecord.FAU_Invite_State__c = inviteState;
        participantRecord.FAU_Program_Wave__c = programRecord.Id;
        participantRecord.FAU_User__c = user.Id;
 
        insert participantRecord;
        
        return participantRecord;
    }
    
    
    
    static private User[] createUsersWithProfile(String profileName, integer iNumberofUsers)
    {
        User[] users = new User[]{};
        
        Profile profile = [SELECT Id, Name FROM Profile WHERE Name = :profileName];
        for(integer i = 0; i < iNumberofUsers; i++){
            User user = new User(Alias = 'utest'
                , Email='dharfleet@salesforce.com' 
                , EmailEncodingKey='UTF-8'
                , LastName='Test'
                , FirstName='Unit'
                , LanguageLocaleKey='en_US'
                , LocaleSidKey='en_US'
                , ProfileId = profile.Id
                , TimeZoneSidKey='America/Los_Angeles'
                , UserName='unitTest' + Math.random() + i + '@domain.org');
            users.add(user);
        }
        insert users;

        System.assert(user.Id != null);

        return users;
    }
}