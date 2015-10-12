/*****************************************************************************************************************************
Name: BET_MemberRequestHandlerClsTest
Copyright © 2015 Unilever. 

Purpose: BET_MemberRequestHandlerClsTest is test class for BET_MemberRequestHandlerCls

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   k.szepietowski@polsource.com            28/07/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
@isTest
private class BET_MemberRequestHandlerClsTest {
	
    @isTest static void testPreventMemberRequestDuplicatesWhileInsertWithInvalidProjectId(){
        Test.startTest();
        //check for owner
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        insert betObject;
        String invalidProjectID = BET_TestUtils.createIPMProject('Unit Test IPM Project Name').id;
        BET_Follow_Request__c followRequest = BET_TestUtils.createBetFollowRequest(betObject.id,invalidProjectID);
        insert followRequest;
        //create test member request data
        List<BET_Member_Request__c> betMembersToInsert = new List<BET_Member_Request__c>();
        for(User u : [Select id FROM User Limit 10]){
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
        insert betMembersToInsert;
        Test.stopTest();
        System.assertEquals(betMembersToInsert.size(),10,'There should be 10 elements in list');
    }
    
    
    @isTest static void testPreventMemberRequestDuplicatesWhileInsertWithVailidProjectId(){
        Test.startTest();
        //check for owner
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        insert betObject;
        String invalidProjectID = betObject.id;
        BET_Follow_Request__c followRequest = BET_TestUtils.createBetFollowRequest(betObject.id,invalidProjectID);
        insert followRequest;
        //create test member request data
        List<BET_Member_Request__c> betMembersToInsert = new List<BET_Member_Request__c>();
        List<BET_Member_Request__c> betMembersToInsert1 = new List<BET_Member_Request__c>();
        List<User> usedUsers = new List<User>();
        for(User u : [Select id FROM User Limit 10]){
            BET_Member_Request__c betMemeberItem = new BET_Member_Request__c();
            betMemeberItem.Brand_Experience_Toolkit__c = betObject.id;
            betMemeberItem.ProjectRequest__c = followRequest.id;
            betMemeberItem.UserId__c = u.id;
            betMemeberItem.Project_Id__c = invalidProjectID;
			betMemeberItem.Status__c = Label.BETTeamMemberRequestNewStatus;
            betMemeberItem.Role__c = Label.BetTeamMemberRoleMember;
            betMembersToInsert.add(betMemeberItem);
            usedUsers.add(u);
        }
        
        //BET_CustomBETException should occure for invailid ProjectID wrong format    
        insert betMembersToInsert;
        for(BET_Member_Request__c memeberToClone : betMembersToInsert){
            betMembersToInsert1.add(memeberToClone.clone(false,true));
        }
        
        //try to insert one more time the sampe collection
        try{
            insert betMembersToInsert1;
            //system.assertEquals(0, 1, 'Exception should be thrown so this code instruction should not be executed in test');
        }catch(System.DmlException ex){
            system.assertEquals(true,ex.getMessage().containsIgnoreCase('is already defined'),'Exception message should contain given text');
            
        }
        Test.stopTest();
    }
	
}