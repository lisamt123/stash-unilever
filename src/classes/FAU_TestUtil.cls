public class FAU_TestUtil
{

	public static final String PROFILE_PARTICIPANT_HOLDS = 'Standard Platform User';
    public static final String PERMISSION_SET_PARTICIPANT_HOLDS = 'FAU_Participant_Platform';


    static public FAU_Program__c buildProgram(String name, Date startDate, String location)
    {
        FAU_Program__c program = new FAU_Program__c();
        program.Name = name;
        program.FAU_Start_Date__c = startDate;
        program.FAU_Primary_Location__c = location;
        //program.FAU_Module_1_Start_Date__c = startDate.addMonths(1);
        //program.FAU_Module_2_Start_Date__c = startDate.addMonths(2);
        program.ownerId = createUserWithProfile(PROFILE_PARTICIPANT_HOLDS).Id;
        program.recordTypeId =  Schema.SObjectType.FAU_Program__c.getRecordTypeInfosByName().get('Core').getRecordTypeId();
        return program;
    }

    static public FAU_Participant__c buildParticipant(String inviteState, FAU_Program__c program)
    {
        return buildParticipant(null, inviteState, program);
    }
    

    static public FAU_Participant__c buildParticipant(User user, String inviteState, FAU_Program__c program)
    {
        FAU_Participant__c participant = new FAU_Participant__c();
        participant.FAU_Invite_State__c = inviteState;
        participant.FAU_Program_Wave__c = program.Id;
        if(user == null)
        {
            participant.FAU_User__c = createUserWithProfile(PROFILE_PARTICIPANT_HOLDS).Id;
        }
        else
        {
            participant.FAU_User__c = user.Id;
        }
        return participant;
    }


  	static public FAU_Participant__c createParticipantFixture(User user, Date startDate, String location, String inviteState)
    {
        FAU_Program__c programRecord = new FAU_Program__c();
        programRecord.Name = 'unit test' + Math.random();
        programRecord.FAU_Start_Date__c = startDate;
        programRecord.FAU_Primary_Location__c = location;
        programRecord.FAU_Module_1_Start_Date__c = Date.newInstance(2016, 05, 24);
        programRecord.FAU_Module_1_Start_Date__c = Date.newInstance(2016, 07, 24);
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

        programRecord.FAU_Status__c = 'Active';
        update programRecord;
        

        FAU_Participant__c participantRecord = new FAU_Participant__c();
        participantRecord.FAU_Invite_State__c = inviteState;
        participantRecord.FAU_Program_Wave__c = programRecord.Id;
        participantRecord.FAU_User__c = createUserWithProfile(PROFILE_PARTICIPANT_HOLDS).Id;
 
        insert participantRecord;
        
        return participantRecord;
    }


    static public User createUserWithProfile(String profileName)
    {
        User user;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        // Issue with MIXED DML Error : http://stackoverflow.com/questions/2387475/how-to-avoid-mixed-dml-operation-error-in-salesforce-tests-that-create-users
        System.runAs ( thisUser ) {
            Profile profile = [SELECT Id, Name FROM Profile WHERE Name = :profileName];
            user = new User(Alias = 'utest'
                , Email='dharfleet@salesforce.com'
                , EmailEncodingKey='UTF-8'
                , LastName='Test'
                , FirstName='Unit'
                , LanguageLocaleKey='en_US'
                , LocaleSidKey='en_US'
                , ProfileId = profile.Id
                , TimeZoneSidKey='America/Los_Angeles'
                , UserName='unitTest' + Math.random() + '@domain.org');

            insert user;

            System.assert(user.Id != null);

            PermissionSet userPermissionSet = [Select UserLicenseId from PermissionSet where Name = :PERMISSION_SET_PARTICIPANT_HOLDS Limit 1];

            PermissionSetAssignment oUserPermissionSetAssignment = new PermissionSetAssignment();
            oUserPermissionSetAssignment.PermissionSetId = userPermissionSet.Id;
            oUserPermissionSetAssignment.AssigneeId = user.Id ;
                                

            insert oUserPermissionSetAssignment; 

            
        }
        return user;
    }

	static public FAU_Milestone__c createMilestone(FAU_Program__c programRecord){
		FAU_Milestone__c Milestone1 = new FAU_Milestone__c();
        Milestone1.FAU_Description__c = 'Description 1: Its all about stuff';
        Milestone1.FAU_Program_Wave__c = programRecord.Id;
        Milestone1.FAU_1st_Reminder__c = Date.newInstance(2016, 10, 27);
        Milestone1.FAU_2nd_Reminder__c = Date.newInstance(2016, 10, 27);
        Milestone1.FAU_Due_Date__c = Date.newInstance(2016, 10, 27);
        Milestone1.FAU_Milestone_Completition__c = 'Participant Update';
        insert Milestone1;
        return Milestone1;
	}

	static public FAU_Module__c createModule(FAU_Program__c programRecord){
		FAU_Module__c module = new FAU_Module__c();
		module.FAU_Program__c = programRecord.id;
		module.FAU_Start_Date__c = Date.newInstance(2016, 10, 27);
		module.FAU_End_Date__c = Date.newInstance(2016, 10, 27);
		module.FAU_Description__c = 'Module 1 Description';
		module.FAU_Module_Number__c = 123;
		insert module;
		return module;
	}

        static public FAU_Webinar__c createWebinar(FAU_Program__c programRecord)
    {
        FAU_Webinar__c webinar = new FAU_Webinar__c();
        webinar.FAU_Description__c = 'Webinar 1 Description';
        webinar.FAU_Title__c = 'Its all about stuff';
        webinar.FAU_Program_Wave__c = programRecord.Id;
        webinar.FAU_Start_Time__c = Date.newInstance(2016, 10, 27);
        webinar.FAU_End_Time__c = Date.newInstance(2016, 10, 27);
        webinar.FAU_URL__c = 'http://google.com';
        insert webinar;
    
        return webinar;
    }
    
    public static User[] createUsersWithProfile(String profileName, integer iNumberofUsers)
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