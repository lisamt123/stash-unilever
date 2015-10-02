/*************************************************************************************
Name : BET_SuggestMembersControllerTest

Purpose : Test class for BET_SuggestMembersController

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  27-07-2015  Initial
*************************************************************************************/
@isTest
private class BET_SuggestMembersControllerTest {
	
    @isTest static void testGetSuggestedMembers(){
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        insert betObject;
        List<Id> suggested_MembersCtrl = new List<Id>();
        List<Id> suggested_ManagersCtrl = new List<Id>();
        List<BET_MemberBucketWrapper> user_bucketsCtrl = new List<BET_MemberBucketWrapper>();
        
        BET_TestUtils.generateTestDataForSuggestedMembers(suggested_MembersCtrl, suggested_ManagersCtrl, user_bucketsCtrl);
        Test.startTest();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.betIdCtrl = betObject.id;
        componentController.projectIdCtrl = null;
        componentController.suggested_MembersCtrl = suggested_MembersCtrl;
        componentController.suggested_ManagersCtrl = suggested_ManagersCtrl;
        componentController.user_bucketsCtrl = user_bucketsCtrl;
        List<BET_SuggestMembersController.SuggestedMembersWrapper> result = componentController.getSuggestedMembers();
        //there should be returned 4 groups
        system.assertEquals(4, result.size());
         //check if user's were aggregated properly
        for(BET_SuggestMembersController.SuggestedMembersWrapper item : result){
            Boolean isManagerInGroup = false;
            if(item.groupName == Label.BET_SuggestedMemberOtherMembers){
                //other group shouldn't have any members
                system.assertEquals(0, item.groupUsers.size());
            }else{
                for(BET_SuggestMembersController.SuggestedMemberItemWrapper userItem : item.groupUsers){
                    if(userItem.isManager){
                        isManagerInGroup = true;
                    }
                }
                //group should have a manager
                system.assertEquals(true, isManagerInGroup);
                //each group should have 4 memebers
                system.assertEquals(4, item.groupUsers.size());
                
            }
        }
        
        Test.stopTest();    
    }
    
    @isTest static void testAddingOtherMembers(){
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        insert betObject;
        List<Id> suggested_MembersCtrl = new List<Id>();
        List<Id> suggested_ManagersCtrl = new List<Id>();
        List<BET_MemberBucketWrapper> user_bucketsCtrl = new List<BET_MemberBucketWrapper>();
        
        BET_TestUtils.generateTestDataForSuggestedMembers(suggested_MembersCtrl, suggested_ManagersCtrl, user_bucketsCtrl);
        Test.startTest();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.betIdCtrl = betObject.id;
        componentController.projectIdCtrl = null;
        componentController.suggested_MembersCtrl = suggested_MembersCtrl;
        componentController.suggested_ManagersCtrl = suggested_ManagersCtrl;
        componentController.user_bucketsCtrl = user_bucketsCtrl;
        componentController.getSuggestedMembers();
        //try to add new members
        //search users whose name cointains a character
        componentController.searchUserName = 'a';
        //componentController.searchUsers();
        //system.assertEquals(true, componentController.freeAddMembers.size()>0);
        //componentController.newlyAddedUsers = '';
        Id userForDeletion = null;
        //for(User u : componentController.freeAddMembers){
        //    componentController.newlyAddedUsers += u.id+',';
        //    userForDeletion = u.id;
        //}
        Integer numberOfNewlyAddedUsers = componentController.freeAddMembers.size();
        //componentController.newlyAddedUsers = componentController.newlyAddedUsers.substring(0,componentController.newlyAddedUsers.length()-1);
        //componentController.addNewMembers();
        componentController.addMembers();
        //check if new users will be presented on UI
        List<BET_SuggestMembersController.SuggestedMembersWrapper> result1 = componentController.getSuggestedMembers();
        
         //check if user's were aggregated properly
        for(BET_SuggestMembersController.SuggestedMembersWrapper item : result1){
            //Boolean isManagerInGroup = false;
            if(item.groupName == Label.BET_SuggestedMemberOtherMembers){
                //check if memebers where added under other users section
                system.assertEquals(numberOfNewlyAddedUsers, item.groupUsers.size()); 
            }
        }
        //check if other users and suggested members were added into database
        system.assertEquals(numberOfNewlyAddedUsers+suggested_MembersCtrl.size(), [Select id FROM BET_Member_Request__c where Brand_Experience_Toolkit__c = : betObject.id].size());
        //try to add the same members ito database - check if duplicated records are not created

        componentController.externalMemberEmail = 'm.bluj@polsource.com';
        componentController.addExternalMember();

        componentController.addMembers();
        system.assertEquals(numberOfNewlyAddedUsers+suggested_MembersCtrl.size()+1, [Select id FROM BET_Member_Request__c where Brand_Experience_Toolkit__c = : betObject.id].size());
        //check deleting from UI
        //componentController.memberToDelete = userForDeletion;
        //componentController.deleteMember();
        system.assertEquals(numberOfNewlyAddedUsers+suggested_MembersCtrl.size(), componentController.suggested_MembersCtrl.size());
       
        Test.stopTest();    
    }
    
    @isTest static void testSkipPage(){
        Test.startTest();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.callbackCtrl = null;
        system.assertEquals(null, componentController.skipPage());
        
        //set callbackCtrl
        componentController.callbackCtrl = Page.BET_NewBet.getUrl();
        system.assertEquals(Page.BET_NewBet.getUrl(), componentController.skipPage().getUrl());
        Test.stopTest();
    }
    
    @isTest static void testGetOwnerPhoto(){
        Test.startTest();
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        insert betObject;
        componentController.betIdCtrl = betObject.id;
        system.assertEquals([SELECT FullPhotoUrl FROM User WHERE id =: UserInfo.getUserId()].get(0).FullPhotoUrl, componentController.getOnwerPhoto());
        Test.stopTest();
    }
    
    @isTest static void testGetManagerPhoto(){
        Test.startTest();
        //test without manager
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.betIdCtrl = betObject.id;
        system.assertEquals('', componentController.getOnwerPhoto());
        
        //set managere for bet
        uw_BET_Team_Member__c beteamManager = new uw_BET_Team_Member__c();
        beteamManager.Team_Member__c = UserInfo.getUserId();
        beteamManager.BET__c = componentController.betIdCtrl;
        beteamManager.Role__c = Label.BETManagerRole;
        insert beteamManager;
        system.assertEquals([SELECT FullPhotoUrl FROM User WHERE id =: UserInfo.getUserId()].get(0).FullPhotoUrl, componentController.getManagerPhoto());
        Test.stopTest();
    }
    
    @isTest static void testDuplicatedRecordsWhileInsertTeamMemberRequest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      	User testUser = new User(Alias = 'newBet', Email='nebetTestUSr@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='newBetTestUsr', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='nebetTestUSr@testorg.com',isActive = true);
        
		uw_BET__c betObject = BET_TestUtils.getTestBet();
        insert betObject;
        List<Id> suggested_MembersCtrl = new List<Id>();
        List<Id> suggested_ManagersCtrl = new List<Id>();
        List<BET_MemberBucketWrapper> user_bucketsCtrl = new List<BET_MemberBucketWrapper>();
        
        BET_TestUtils.generateTestDataForSuggestedMembers(suggested_MembersCtrl, suggested_ManagersCtrl, user_bucketsCtrl);
        Test.startTest();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.betIdCtrl = betObject.id;
        componentController.projectIdCtrl = null;
        componentController.suggested_MembersCtrl = suggested_MembersCtrl;
        componentController.suggested_ManagersCtrl = suggested_ManagersCtrl;
        componentController.user_bucketsCtrl = user_bucketsCtrl;
        componentController.getSuggestedMembers();
        //try to add new members
        //search users whose name cointains a character
        componentController.searchUserName = 'a';
        //componentController.searchUsers();
        //componentController.newlyAddedUsers = '';
        //Id userForDeletion = null;
        //for(User u : componentController.freeAddMembers){
        //    componentController.newlyAddedUsers += u.id+',';
       // }
        Integer numberOfNewlyAddedUsers = componentController.freeAddMembers.size();
        //componentController.newlyAddedUsers = componentController.newlyAddedUsers.substring(0,componentController.newlyAddedUsers.length()-1);
        //componentController.addNewMembers();
        //insert members into db
        componentController.addMembers();
        //check if other users and suggested members were added into database
       
         
        
        System.runAs(testUser){
        	//try to add the same members ito database - check if duplicated records are not created
        	//Tema member requests created in status New but there already exist such records in Approved 
        	//status no records should be added
        	componentController.addMembers();
            system.assertEquals(numberOfNewlyAddedUsers+suggested_MembersCtrl.size(), [Select id FROM BET_Member_Request__c where Brand_Experience_Toolkit__c = : betObject.id].size());
        }
        Test.stopTest(); 
    }
    
    @isTest static void addExternalMemberTest(){
        Test.startTest();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.externalMemberEmail = 'm.bluj@polsource.com';
        componentController.addExternalMember();
        System.assertEquals(componentController.externalMembers.size(),1);
        System.assertEquals(componentController.externalMembers.get(0).getPhoto(),'/profilephoto/005/F');
        Test.stopTest();
    }

    @isTest static void delExternalMemeberTest(){
        Test.startTest();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.externalMemberEmail = 'm.bluj@polsource.com';
        componentController.addExternalMember();
        System.assertEquals(componentController.externalMembers.size(),1);
        componentController.delExternalMemeber();
        System.assertEquals(componentController.externalMembers.size(),0);
        Test.stopTest();
    }

    @isTest static void getManagersTest(){
        Test.startTest();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();

        uw_BET__c bet = BET_TestUtils.getTestBet();
        insert bet;
        IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
        project.IPM_Project_Leader__c = UserInfo.getUserId();
        update project;

        BET_Member_Request__c request  = new BET_Member_Request__c();
        request.Status__c = 'Approved';
        request.Brand_Experience_Toolkit__c = bet.id;
        request.Project_Id__c = project.id;
        request.Role__c = Label.BETManagerRole;
        request.UserId__c = UserInfo.getUserId();

        insert request;

        componentController.betIdCtrl = bet.id;
        componentController.projectIdCtrl = project.id;
        System.assertEquals(componentController.getManagers().size(),1);
        Test.stopTest();
    }

}