/*************************************************************************************
Name : BET_SuggestedMemberServiceTest

Purpose : Test class for BET_SuggestedMemberService

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  28-07-2015  Initial
*************************************************************************************/
@isTest
private class BET_SuggestedMemberServiceTest {

    private static final String BET_OWNER_OR_MANAGER = 'Current user must be owner or manager of a BET';

    @isTest static void testCheckIfUsersAreManagerOrOwnerOfBet(){
        Test.startTest();
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        insert betObject;
        system.assertEquals(true, BET_SuggestedMemberService.checkIfUsersAreManagerOrOwnerOfBet(betObject.id,new List<Id>{UserInfo.getUserId()}).get(UserInfo.getUserId()),BET_OWNER_OR_MANAGER);
        uw_BET_Team_Member__c memberRequestToInsert = new uw_BET_Team_Member__c();
        memberRequestToInsert.BETEnabled__c = true;
        memberRequestToInsert.BET__c = betObject.id;
        memberRequestToInsert.Editing__c = false;
        memberRequestToInsert.Invite_Pending__c = false;
        memberRequestToInsert.Role__c = Label.BetTeamMemberRoleManager;
        memberRequestToInsert.StudioEnabled__c = true;
        memberRequestToInsert.Team_Member__c = UserInfo.getUserId();
        insert memberRequestToInsert;
        system.assertEquals(true, BET_SuggestedMemberService.checkIfUsersAreManagerOrOwnerOfBet(betObject.id,new List<Id>{UserInfo.getUserId()}).get(UserInfo.getUserId()),BET_OWNER_OR_MANAGER);
        Test.stopTest();
    }

    @isTest static void testCheckIfUserIsManagerOrOwnerOfBet(){
        Test.startTest();
        //check for owner
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        //check empty bet
        system.assertEquals(false, BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(null,UserInfo.getUserId()),'Null user should be marked as not manager or member');
        insert betObject;
        system.assertEquals(true, BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betObject.id,UserInfo.getUserId()),BET_OWNER_OR_MANAGER);
        //create team member with manager role
        /*
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = new User(Alias = 'newBet', Email='nebetTestUSr@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='newBetTestUsr', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='nebetTestUSr@testorg.com',isActive = true);
        */
        User testUser = BET_TestUtils.createUserSystemAdmin();
        
        System.runAs(testUser){
            //check if before manager creation method return false
            system.assertEquals(false, BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betObject.id,UserInfo.getUserId()),'User should not be owner or manager of a BET');
            uw_BET_Team_Member__c memberRequestToInsert = new uw_BET_Team_Member__c();
            memberRequestToInsert.BETEnabled__c = true;
            memberRequestToInsert.BET__c = betObject.id;
            memberRequestToInsert.Editing__c = false;
            memberRequestToInsert.Invite_Pending__c = false;
            memberRequestToInsert.Role__c = Label.BETManagerRole;
            memberRequestToInsert.StudioEnabled__c = true;
            memberRequestToInsert.Team_Member__c = UserInfo.getUserId();
            insert memberRequestToInsert;
            system.assertEquals(true, BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betObject.id,UserInfo.getUserId()),BET_OWNER_OR_MANAGER);
        }
        //check if bet no longer exist
        Id betId = betObject.id;
        delete betObject;
        system.assertEquals(false, BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betId,UserInfo.getUserId()),'User should not be owner or manager of a BET');
        Test.stopTest();
    }
    
    @isTest static void testRemoveMemberRequestDuplicatesWhileInsertForInvailidProjectId(){
        Test.startTest();
        //check for owner
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        insert betObject;
        String invalidProjectID = '123456789';
        BET_Follow_Request__c followRequest = BET_TestUtils.createBetFollowRequest(betObject.id,invalidProjectID);
        insert followRequest;
        //create test member request data
        List<BET_Member_Request__c> betMembersToInsert = new List<BET_Member_Request__c>();
        for(User u : [Select id FROM User where isActive = true Limit 10]){
            BET_Member_Request__c betMemeberItem = new BET_Member_Request__c();
            betMemeberItem.Brand_Experience_Toolkit__c = betObject.id;
            betMemeberItem.ProjectRequest__c = followRequest.id;
            betMemeberItem.UserId__c = u.id;
            betMemeberItem.Project_Id__c = invalidProjectID;
            betMemeberItem.Status__c = Label.BETTeamMemberRequestNewStatus;
            betMemeberItem.Role__c = Label.BetTeamMemberRoleMember;
            betMembersToInsert.add(betMemeberItem);
        }
        //BET_CustomBETException should occure for invailid ProjectID wrong format
        try{
            betMembersToInsert = BET_SuggestedMemberService.removeMemberRequestDuplicatesWhileInsert(betMembersToInsert);
            system.assertEquals(0, 1, 'Exception should be thrown so this code instruction should not be executed in test');
        }catch(BET_CustomBETException ex){
            system.assertEquals(Label.BetMemberRequestInvailidProjectIDError, ex.getMessage(),'Exception message should be ' + Label.BetMemberRequestInvailidProjectIDError);
        }
        Test.stopTest();
    }
    
    @isTest static void testRemoveMemberRequestDuplicatesWhileInsertForVailidProjectId(){
        Test.startTest();
        //check for owner
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        insert betObject;
        IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project for Members');
        BET_Follow_Request__c followRequest = BET_TestUtils.createBetFollowRequest(betObject.id,project.id);
        insert followRequest;
        //create test member request data
        List<BET_Member_Request__c> betMembersToInsert = new List<BET_Member_Request__c>();
        List<User> usedUsers = BET_TestUtils.createUserSystemAdmin(5);
        for(User u : usedUsers){
            BET_Member_Request__c betMemeberItem = new BET_Member_Request__c();
            betMemeberItem.Brand_Experience_Toolkit__c = betObject.id;
            betMemeberItem.ProjectRequest__c = followRequest.id;
            betMemeberItem.UserId__c = u.id;
            betMemeberItem.Project_Id__c = project.id;
            betMemeberItem.Status__c = Label.BETTeamMemberRequestNewStatus;
            betMemeberItem.Role__c = Label.BetTeamMemberRoleMember;
            betMembersToInsert.add(betMemeberItem);
        }
        //BET_CustomBETException should occure for invailid ProjectID wrong format
        
        betMembersToInsert = BET_SuggestedMemberService.removeMemberRequestDuplicatesWhileInsert(betMembersToInsert);    
        insert betMembersToInsert;
        List<BET_Member_Request__c> tmpMemberRequests = new List<BET_Member_Request__c>();
       
        for(User u : usedUsers){
            BET_Member_Request__c betMemeberItem = new BET_Member_Request__c();
            betMemeberItem.Brand_Experience_Toolkit__c = betObject.id;
            betMemeberItem.ProjectRequest__c = followRequest.id;
            betMemeberItem.UserId__c = u.id;
            betMemeberItem.Project_Id__c = project.id;
            betMemeberItem.Status__c = Label.BETTeamMemberRequestNewStatus;
            betMemeberItem.Role__c = Label.BetTeamMemberRoleMember;
            tmpMemberRequests.add(betMemeberItem);
           
        }
        
        //update Status to approved and check if no records will not be added with status new
        for(BET_Member_Request__c member : betMembersToInsert){
            member.Status__c = Label.BETTeamMemberRequestApprovedStatus;
        }
        Integer numberOfTeamMembersBeforeUpdate = [Select count() FROM uw_BET_Team_Member__c where BET__c =:betObject.id];
        update betMembersToInsert;
        Test.stopTest();

        //check if tem members were added to db
        system.assertEquals([Select count() FROM uw_BET_Team_Member__c where BET__c =:betObject.id]
                - numberOfTeamMembersBeforeUpdate, betMembersToInsert.size(),'Number of members should match');
        tmpMemberRequests = BET_SuggestedMemberService.removeMemberRequestDuplicatesWhileInsert(tmpMemberRequests);
        //such records are already approved so no recors should be added
        system.assertEquals(0, tmpMemberRequests.size(),'There should be no member requests');
        
    }
}