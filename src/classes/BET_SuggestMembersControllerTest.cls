/*************************************************************************************
Name : BET_SuggestMembersControllerTest

Purpose : Test class for BET_SuggestMembersController

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  27-07-2015  Initial
*************************************************************************************/
@isTest
private class BET_SuggestMembersControllerTest {
	
    @isTest static void getWrapperTest(){
        BET_SuggestMembersController.SuggestedMembersWrapper otherMemebersWrapper = new BET_SuggestMembersController.SuggestedMembersWrapper();
        otherMemebersWrapper.groupName = Label.BET_SuggestedMemberOtherMembers;
        otherMemebersWrapper.groupUsers = new List<BET_SuggestMembersController.SuggestedMemberItemWrapper>();
        List<Id> otherMemebers = new List<Id>{UserInfo.getUserId()};
        Map<Id,User> suggestedUsers = new Map<Id,User>{UserInfo.getUserId() => new User()};
        Map<Id,Id> managersMap = new Map<Id,Id> {UserInfo.getUserId() => UserInfo.getUserId()};

        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        Test.startTest();
        System.assert(!componentController.getWrapper(otherMemebersWrapper,otherMemebers,suggestedUsers,managersMap).groupUsers.isEmpty(),'Collection should not be empty');
        Test.stopTest();
    }

    @isTest static void addNewMembersTest(){

        uw_BET__c betObject = BET_TestUtils.getTestBet();
        insert betObject;

        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.betIdCtrl = betObject.id;
        componentController.newlyAddedUsers = ''+UserInfo.getUserId();
        componentController.addNewMembers();
        componentController.memberToDelete = UserInfo.getUserId();
        componentController.deleteMember();
        componentController.searchUserName = UserInfo.getFirstName();
        componentController.searchUsers();
        Test.startTest();
        System.assert(componentController.suggested_MembersCtrl.isEmpty(),'List should be empty');
        Test.stopTest();
    }

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
        system.assertEquals(4, result.size(), 'There should be 4 members groups');
         //check if user's were aggregated properly
        for(BET_SuggestMembersController.SuggestedMembersWrapper item : result){
            Boolean isManagerInGroup = false;
            if(item.groupName == Label.BET_SuggestedMemberOtherMembers){
                //other group shouldn't have any members
                system.assertEquals(0, item.groupUsers.size(), 'Other group shoult not have any mambers');
            }else{
                for(BET_SuggestMembersController.SuggestedMemberItemWrapper userItem : item.groupUsers){
                    if(userItem.isManager){
                        isManagerInGroup = true;
                    }
                }
                //group should have a manager
                system.assertEquals(true, isManagerInGroup, 'There should be manager in group');
                //each group should have 4 memebers
                system.assertEquals(4, item.groupUsers.size(), 'There should be 4 members in group');
                
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
                system.assertEquals(numberOfNewlyAddedUsers, item.groupUsers.size(), 'Number of added users should match number of users in group'); 
            }
        }
        //check if other users and suggested members were added into database
        system.assertEquals(numberOfNewlyAddedUsers+suggested_MembersCtrl.size(), [Select id FROM BET_Member_Request__c where Brand_Experience_Toolkit__c = : betObject.id].size(),'Suggested and newly added users number should match member requests number');
        //try to add the same members ito database - check if duplicated records are not created

        componentController.externalMemberEmail = 'm.bluj@polsource.com';
        componentController.addExternalMember();

        componentController.addMembers();
        system.assertEquals(numberOfNewlyAddedUsers+suggested_MembersCtrl.size()+1, [Select id FROM BET_Member_Request__c where Brand_Experience_Toolkit__c = : betObject.id].size(),'Suggested and newly added users number should be larger by 1 then member requests number');
        //check deleting from UI
        //componentController.memberToDelete = userForDeletion;
        //componentController.deleteMember();
        system.assertEquals(numberOfNewlyAddedUsers+suggested_MembersCtrl.size(), componentController.suggested_MembersCtrl.size(),'Numer of members must match');
       
        Test.stopTest();    
    }
    
    @isTest static void testSkipPage(){
        Test.startTest();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.callbackCtrl = null;
        system.assertEquals(null, componentController.skipPage(), 'Page reference should be null');
        
        //set callbackCtrl
        componentController.callbackCtrl = Page.BET_NewBet.getUrl();
        system.assertEquals(Page.BET_NewBet.getUrl(), componentController.skipPage().getUrl(),'Page reference should match new Bet page');
        Test.stopTest();
    }
    
    @isTest static void testGetOwnerPhoto(){
        Test.startTest();
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        insert betObject;
        componentController.betIdCtrl = betObject.id;
        system.assertEquals([SELECT FullPhotoUrl FROM User WHERE id =: UserInfo.getUserId()].get(0).FullPhotoUrl, componentController.getOnwerPhoto(),'Photo URl must match');
        Test.stopTest();
    }
    
    @isTest static void testGetManagerPhoto(){
        Test.startTest();
        //test without manager
        uw_BET__c betObject = BET_TestUtils.getTestBet();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.betIdCtrl = betObject.id;
        system.assertEquals('', componentController.getOnwerPhoto(),'There should be no owner photo');
        
        //set managere for bet
        uw_BET_Team_Member__c beteamManager = new uw_BET_Team_Member__c();
        beteamManager.Team_Member__c = UserInfo.getUserId();
        beteamManager.BET__c = componentController.betIdCtrl;
        beteamManager.Role__c = Label.BETManagerRole;
        insert beteamManager;
        system.assertEquals([SELECT FullPhotoUrl FROM User WHERE id =: UserInfo.getUserId()].get(0).FullPhotoUrl, componentController.getManagerPhoto(),'Photo URl must match');
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
            system.assertEquals(numberOfNewlyAddedUsers+suggested_MembersCtrl.size(), [Select id FROM BET_Member_Request__c where Brand_Experience_Toolkit__c = : betObject.id].size(),'Suggested and newly added users number should match member requests number');
        }
        Test.stopTest(); 
    }
    
    @isTest static void addExternalMemberTest(){
        Test.startTest();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.externalMembers = new List<BET_SuggestMembersController.ExternalAgencyMemberWrapper>();
        componentController.externalMemberEmail = 'm.bluj@polsource.com';
        componentController.addExternalMember();
        System.assertEquals(componentController.externalMembers.size(),1,'There should be one external member added');
        System.assertEquals(componentController.externalMembers.get(0).getPhoto(),'/profilephoto/005/F','Photo url should match default value');
        Test.stopTest();
    }

    @isTest static void delExternalMemeberTest(){
        Test.startTest();
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        componentController.externalMemberEmail = 'm.bluj@polsource.com';
        BET_SuggestMembersController.ExternalAgencyMemberWrapper wrapp = new BET_SuggestMembersController.ExternalAgencyMemberWrapper();
        wrapp.email = componentController.externalMemberEmail;
        componentController.externalMembers = new List<BET_SuggestMembersController.ExternalAgencyMemberWrapper>{wrapp};
        componentController.addExternalMember();
        System.assertEquals(componentController.externalMembers.size(),1,'There should be one external member added');
        componentController.delExternalMemeber();
        System.assertEquals(componentController.externalMembers.size(),0,'There should be no external members');
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
        System.assertEquals(componentController.getManagers().size(),1,'There should be only one manager');
        Test.stopTest();
    }

    @isTest static void goToCallbackTest(){
        BET_SuggestMembersController componentController = new BET_SuggestMembersController();
        Test.startTest();
        System.assert(componentController.goToCallback('/apex/Bet') != null,'Page reference should not be null');
        Test.stopTest();
    }

}