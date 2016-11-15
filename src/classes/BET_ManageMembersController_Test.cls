//@isTest(seeAllData=true)
@isTest
private class BET_ManageMembersController_Test {
      static private uw_BET__c testBET;
      static private BET_ManageMembersSettings__c betMembersSettings;
      static private User internalUser, externalUser;
      //static private CollaborationGroup cg;

      static void setupTestData() {
          // Custom settings
          //BET_ManageMembersSettings__c betMembersSettings = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
          betMembersSettings = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
          
          if ( betMembersSettings == null ) {       
              betMembersSettings = new BET_ManageMembersSettings__c();
         
              betMembersSettings.Name = 'BETManageMembersConfig';
              betMembersSettings.ManagerRole__c = 'Manager'; 
              betMembersSettings.MemberRole__c = 'Member';
              betMembersSettings.ExternalRole__c = 'External Agency User';
              betMembersSettings.ApprovedStatus__c = 'Approved';
              betMembersSettings.DeniedStatus__c = 'Denied';
              betMembersSettings.ToolkitAccessLevel__c = 'Toolkit Experience (Toolkit only)';
              betMembersSettings.ExternalAccessLevel__c = 'External View (Chatter group only)';
              betMembersSettings.InternalUserRecordType__c = 'InternalUser';
              betMembersSettings.BET_Member_Object_Name__c = 'uw_BET_Team_Member__c';
              
              insert betMembersSettings;
          }
          
          //private static final String EXTERNAL_EMAIL = 'external.agency@email.com.edu';
          //private static final String EXTERNAL_USERNAME = 'externalagencyemail.com.edu@org.org.org';
          //private static final String GOOD_SEARCH_TERM = 'Purpleuser';
          
          //CollaborationGroup cg = new CollaborationGroup();
          //cg = new CollaborationGroup();
          //cg.Name = 'TestCollaborationGroup';
          //cg.CollaborationType= 'Private';
          //insert cg;
          //System.Debug('INSERT COLLABORATIONGROUP SUCCESSFUL: ' + cg.Id);
          
          // Create a Brand
          uw_Brand__c brand = new uw_Brand__c();
          brand.Name = 'brand1';
          insert brand;
          
          // Create an Inoplan Project
          uw_Inoplan_Project__c inoProject = new uw_Inoplan_Project__c();
          inoProject.name = 'No Inoplan Project' + Math.random();
          insert inoProject;
                
          // Create a BET
          uw_BET__c bet = new uw_BET__c();
          bet.uw_Brand__c = brand.Id;
          bet.Status__c = 'First release';
          bet.Sharing__c = 'Private';
          bet.Product_Category_Sub_Division__c = 'Foods';
          bet.Category_Level_2__c ='Spreads';
          bet.Inoplan_Project__c = inoProject.id;
          bet.Name = 'bet1';
          insert bet;
          
          testBet = [SELECT Id, Studio_Chatter_Group__c FROM uw_BET__c WHERE id = :bet.Id];
          //testBET = bet;
          System.Debug('Test BET Id: ' + testBET.Id + ', Test BET Chatter Id: ' + testBet.Studio_Chatter_Group__c );
                    
           // Internal user
           
           Profile internalProfile = [Select Id From profile Where name='Unilever Way - Marketing - Standard Marketing User' LIMIT 1]; 
           //User internalUser = new User(alias = 'u1xyz', email='u1xyz@unilever.com', 
           internalUser = new User(alias = 'u1xyz', email='u1xyz@unilever.com',
           emailencodingkey='UTF-8', lastname='BETTester1', languagelocalekey='en_US', 
           localesidkey='en_US', profileid = internalProfile.Id, 
           timezonesidkey='America/Los_Angeles', username='BETtester1xyz@unileverxyz.com');
           
           insert internalUser;
             
          // External user
           Profile externalProfile = [Select Id From profile Where name='Chatter External User' LIMIT 1]; 
           //User externalUser = new User(alias = 'extalias', email='external.agency@email.com.edu', 
           externalUser = new User(alias = 'extalias', email='external.agency@email.com.edu',
           emailencodingkey='UTF-8', lastname='external', languagelocalekey='en_US', 
           localesidkey='en_US', profileid = externalProfile.Id, 
           timezonesidkey='America/Los_Angeles', username='externalagencyemail.com.edu@org.org.org');
           
           insert externalUser;

      }

      
      static testMethod void  getBetName() {
          // Create Test Data
          setupTestData(); 
          
          System.Debug('get BetName Test BET Id: ' + testBET.Id);
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          
          // Run Test
          Test.startTest();
          String betName = controller.getBetName();
          System.Debug('BET Name: ' + betName);
          Test.stopTest();
          
          // Assert Test result
          System.assertEquals('bet1', betName);
      }
      
      static testMethod void  getPendingRequests() {
          setupTestData(); 
          
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = betMembersSettings.MemberRole__c;
          teamMember.Team_Member__c = internalUser.Id;
          teamMember.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
          teamMember.Pending_Request__c = true;
          teamMember.BETEnabled__c = true;
 
          insert teamMember;
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          
          // Run Test
          Test.startTest();
          List<uw_BET_Team_Member__c> teamMemberList = controller.getPendingRequests();
          System.Debug('Pending Request Size: ' + teamMemberList.size());
          Test.stopTest();
          
          // Assert Test result
          System.assertEquals(1, teamMemberList.size());
             
      }
      
      static testMethod void  getMembers() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = betMembersSettings.MemberRole__c;
          teamMember.Team_Member__c = internalUser.Id;
          teamMember.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
          teamMember.Request_Status__c = 'Approved';
          teamMember.Pending_Request__c = false;
          teamMember.BETEnabled__c = true;
 
          insert teamMember;
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          
          // Run Test
          Test.startTest();
          List<uw_BET_Team_Member__c> teamMemberList = controller.getMembers();
          System.Debug('Members Size: ' + teamMemberList.size());
          Test.stopTest();
          
          // Assert Test result
          System.assertEquals(2, teamMemberList.size());  // Count: BET Owner + the added member
             
      }
      
      static testMethod void  approveRequest() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = betMembersSettings.MemberRole__c;
          teamMember.Team_Member__c = internalUser.Id;
          teamMember.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
          teamMember.Pending_Request__c = true;
          teamMember.BETEnabled__c = true;
 
          insert teamMember;
          System.Debug('INSERT TEAMMEMBER ID: ' + teamMember.Id);
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          
          controller.recordId = teamMember.Id;
          
          // Run Test
          Test.startTest();
          PageReference pRef = controller.approveRequest();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> approvedteamMemberList = [SELECT Id, Name, Pending_Request__c, Request_Status__c FROM uw_BET_Team_Member__c WHERE Id = :teamMember.Id];
          
          // Assert Test result
          System.assertEquals(1, approvedteamMemberList.size());
          System.assertEquals('Approved', approvedteamMemberList[0].Request_Status__c);
          System.assertEquals(false, approvedteamMemberList[0].Pending_Request__c);
             
          List<uw_BET__Share> betShareList = [SELECT Id FROM uw_BET__Share WHERE UserOrGroupId = :teamMember.Team_Member__c AND ParentId = :testBet.Id];   
          System.assertEquals(1, betShareList.size()); 
          
          List<EntitySubscription> entitySubscriptionList = [SELECT Id FROM EntitySubscription WHERE SubscriberId = :teamMember.Team_Member__c AND ParentId = :testBet.Id];   
          System.assertEquals(1, entitySubscriptionList.size()); 
          
          List<CollaborationGroupMember> cgmList = [SELECT Id FROM CollaborationGroupMember WHERE MemberId = :teamMember.Team_Member__c];   
          System.assertEquals(1, cgmList.size());
      }
      
      static testMethod void  denyRequest() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = betMembersSettings.MemberRole__c;
          teamMember.Team_Member__c = internalUser.Id;
          teamMember.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
          teamMember.Pending_Request__c = true;
          teamMember.BETEnabled__c = true;
 
          insert teamMember;
          System.Debug('INSERT TEAMMEMBER ID: ' + teamMember.Id);
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          
          controller.recordId = teamMember.Id;
          System.Debug('CONTROLLER RECORDID: ' + controller.recordId);
          
          // Run Test
          Test.startTest();
          PageReference pRef = controller.denyRequest();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> deniedteamMemberList = [SELECT Id, Name, Pending_Request__c, Request_Status__c FROM uw_BET_Team_Member__c WHERE Id = :teamMember.Id];
          
          System.Debug('APPROVED TEAMMEMBERLIST SIZE: ' + deniedteamMemberList.size() + ', ID: ' + deniedteamMemberList[0].Id);
          // Assert Test result
          System.assertEquals(1, deniedteamMemberList.size());
          System.assertEquals('Denied', deniedteamMemberList[0].Request_Status__c);
          System.assertEquals(false, deniedteamMemberList[0].Pending_Request__c);
      }
      
       static testMethod void setManagerRole() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = betMembersSettings.MemberRole__c;
          teamMember.Team_Member__c = internalUser.Id;
          teamMember.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
          teamMember.Request_Status__c = 'Approved';
          teamMember.Pending_Request__c = false;
          teamMember.BETEnabled__c = true;
 
          insert teamMember; 
          
          uw_BET__Share betShare  = new uw_BET__Share();
          betShare.UserOrGroupId = teamMember.Team_Member__c;
          betShare.AccessLevel = 'Read';
          betShare.ParentId = testBET.Id;
    
          insert betShare;

          CollaborationGroupMember cgm = new CollaborationGroupMember();
          cgm.CollaborationRole = 'Standard';
          cgm.CollaborationGroupId = testBet.Studio_Chatter_Group__c;
          cgm.MemberId = teamMember.Team_Member__c;
          cgm.NotificationFrequency = 'N';
          
          insert cgm;

          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          ApexPages.currentPage().getParameters().put('memberId',teamMember.Id);
          ApexPages.currentPage().getParameters().put('role','Manager');
          
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
         
          // Run Test
          Test.startTest();
          PageReference pRef = controller.setRole();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name, Role__c FROM uw_BET_Team_Member__c WHERE Id = :teamMember.Id];
          
          // Assert Test result
          System.assertEquals(1, teamMemberList.size());
          System.assertEquals('Manager', teamMemberList[0].Role__c);
          
   
          List<uw_BET__Share> betShareList = [SELECT Id, AccessLevel FROM uw_BET__Share WHERE UserOrGroupId = :teamMember.Team_Member__c AND ParentId = :testBet.Id];   
          System.assertEquals('Edit', betShareList[0].AccessLevel); 
          
          List<CollaborationGroupMember> cgmList = [SELECT Id, CollaborationRole FROM CollaborationGroupMember WHERE MemberId = :teamMember.Team_Member__c];   
          System.assertEquals('Admin', cgmList[0].CollaborationRole);
 
      }
      
      static testMethod void setMemberRole() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = betMembersSettings.ManagerRole__c;
          teamMember.Team_Member__c = internalUser.Id;
          teamMember.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
          teamMember.Request_Status__c = 'Approved';
          teamMember.Pending_Request__c = false;
          teamMember.BETEnabled__c = true;
 
          insert teamMember; 
          
          uw_BET__Share betShare  = new uw_BET__Share();
          betShare.UserOrGroupId = teamMember.Team_Member__c;
          betShare.AccessLevel = 'Edit';
          betShare.ParentId = testBET.Id;
    
          insert betShare;
          
          CollaborationGroupMember cgm = new CollaborationGroupMember();
          cgm.CollaborationRole = 'Admin';
          cgm.CollaborationGroupId = testBet.Studio_Chatter_Group__c;
          cgm.MemberId = teamMember.Team_Member__c;
          cgm.NotificationFrequency = 'N';

          insert cgm;

          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          ApexPages.currentPage().getParameters().put('memberId',teamMember.Id);
          ApexPages.currentPage().getParameters().put('role','Member');
          
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
         
          // Run Test
          Test.startTest();
          PageReference pRef = controller.setRole();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name, Role__c FROM uw_BET_Team_Member__c WHERE Id = :teamMember.Id];
          
          // Assert Test result
          System.assertEquals(1, teamMemberList.size());
          System.assertEquals('Member', teamMemberList[0].Role__c);
          
   
          List<uw_BET__Share> betShareList = [SELECT Id, AccessLevel FROM uw_BET__Share WHERE UserOrGroupId = :teamMember.Team_Member__c AND ParentId = :testBet.Id];   
          System.assertEquals('Read', betShareList[0].AccessLevel); 
          
          List<CollaborationGroupMember> cgmList = [SELECT Id, CollaborationRole FROM CollaborationGroupMember WHERE MemberId = :teamMember.Team_Member__c];   
          System.assertEquals('Standard', cgmList[0].CollaborationRole);
 
      }
      
      static testMethod void isUserExist() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = betMembersSettings.MemberRole__c;
          teamMember.Team_Member__c = internalUser.Id;
          teamMember.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
          teamMember.Request_Status__c = 'Approved';
          teamMember.Pending_Request__c = false;
          teamMember.BETEnabled__c = true;
 
          insert teamMember; 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
         
          // Run Test
          Test.startTest();
          Boolean isExist = controller.isUserExist(teamMember);
          Test.stopTest();
          
          System.assertEquals(true, isExist);
      }
      
      
       static testMethod void addInternalMember() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.Team_Member__c = internalUser.Id;
          controller.BETTeamMember.Role__c = betMembersSettings.MemberRole__c;
         
          // Run Test
          Test.startTest();
          PageReference pRef  = controller.addMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND Team_Member__c = :internalUser.Id];
          System.assertEquals(1, teamMemberList.size());
          System.assertEquals(betMembersSettings.MemberRole__c, teamMemberList[0].Role__c);     
          
          List<uw_BET__Share> betShareList = [SELECT Id FROM uw_BET__Share WHERE UserOrGroupId = :teamMemberList[0].Team_Member__c AND ParentId = :testBet.Id];   
          System.assertEquals(1, betShareList.size()); 
          
          List<EntitySubscription> entitySubscriptionList = [SELECT Id FROM EntitySubscription WHERE SubscriberId = :teamMemberList[0].Team_Member__c AND ParentId = :testBet.Id];   
          System.assertEquals(1, entitySubscriptionList.size()); 
          
          List<CollaborationGroupMember> cgmList = [SELECT Id FROM CollaborationGroupMember WHERE MemberId = :teamMemberList[0].Team_Member__c];   
          System.assertEquals(1, cgmList.size());                                 
      }
      
      static testMethod void addExternalMember() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = 'external.agency@email.com.edu';
         
          // Run Test
          Test.startTest();
          PageReference pRef  = controller.addMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND Team_Member__c = :externalUser.Id];
          System.assertEquals(1, teamMemberList.size());
          System.assertEquals(betMembersSettings.ExternalRole__c, teamMemberList[0].Role__c); 
          
          List<uw_BET__Share> betShareList = [SELECT Id FROM uw_BET__Share WHERE UserOrGroupId = :teamMemberList[0].Team_Member__c AND ParentId = :testBet.Id];   
          System.assertEquals(0, betShareList.size()); 
          
          List<EntitySubscription> entitySubscriptionList = [SELECT Id FROM EntitySubscription WHERE SubscriberId = :teamMemberList[0].Team_Member__c AND ParentId = :testBet.Id];   
          System.assertEquals(0, entitySubscriptionList.size()); 
          
          List<CollaborationGroupMember> cgmList = [SELECT Id FROM CollaborationGroupMember WHERE MemberId = :teamMemberList[0].Team_Member__c];   
          System.assertEquals(1, cgmList.size());                                       
      }
      
      static testMethod void addMemberErrorInternalAndExternal() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = 'external.agency@email.com.edu';
          controller.BETTeamMember.Team_Member__c = internalUser.Id;
          controller.BETTeamMember.Role__c = betMembersSettings.MemberRole__c;
         
          // Run Test
          Test.startTest();
          PageReference pRef  = controller.addMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<Apexpages.Message> msgs = ApexPages.getMessages();
          boolean b = false;
          System.Debug('MESSAGES SIZE: ' + msgs.size());
          for(Apexpages.Message msg:msgs){
             System.Debug('MESSAGE: ' + msg.getDetail());
             if (msg.getDetail().contains('You should select either an internal or an external user. The two types of users cannot be added at once.')) b = true;
          }
          system.assert(b);//Assert the Page Message was Properly Displayed
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND Team_Member__c = :internalUser.Id];
          System.assertEquals(0, teamMemberList.size());                                    
      }
      
      
      static testMethod void addMemberErrorNoInternalOrExternal() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = null;
          controller.BETTeamMember.Team_Member__c = null;
          controller.BETTeamMember.Role__c = betMembersSettings.MemberRole__c;
         
          // Run Test
          Test.startTest();
          PageReference pRef  = controller.addMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<Apexpages.Message> msgs = ApexPages.getMessages();
          boolean b = false;
          System.Debug('MESSAGES SIZE: ' + msgs.size());
          for(Apexpages.Message msg:msgs){
             System.Debug('MESSAGE: ' + msg.getDetail());
             if (msg.getDetail().contains('You should select an internal or an external user.')) b = true;
          }
          system.assert(b);//Assert the Page Message was Properly Displayed
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND Team_Member__c = :internalUser.Id];
          System.assertEquals(0, teamMemberList.size());                                    
      }
      
      static testMethod void addMemberErrorExistingUser() {
          setupTestData(); 
          
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = betMembersSettings.MemberRole__c;
          teamMember.Team_Member__c = internalUser.Id;
          teamMember.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
          teamMember.Request_Status__c = 'Approved';
          teamMember.Pending_Request__c = false;
          teamMember.BETEnabled__c = true;
 
          insert teamMember; 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.Team_Member__c = internalUser.Id;
          controller.BETTeamMember.Role__c = betMembersSettings.MemberRole__c;
         
          // Run Test
          Test.startTest();
          PageReference pRef  = controller.addMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<Apexpages.Message> msgs = ApexPages.getMessages();
          boolean b = false;
          System.Debug('MESSAGES SIZE: ' + msgs.size());
          for(Apexpages.Message msg:msgs){
             System.Debug('MESSAGE: ' + msg.getDetail());
             if (msg.getDetail().contains('User already exists.')) b = true;
          }
          system.assert(b);//Assert the Page Message was Properly Displayed
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND Team_Member__c = :internalUser.Id];
          System.assertEquals(1, teamMemberList.size());                                    
      }
      
      
      static testMethod void addMemberDMLBeforeInsertException() {
          setupTestData(); 

          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.Team_Member__c = internalUser.Id;
          controller.BETTeamMember.Role__c = betMembersSettings.MemberRole__c;
          controller.BETTeamMember.Request_Status__c = 'DMLExceptionBeforeInsert';
         
          // Run Test
          Test.startTest();
          PageReference pRef  = controller.addMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND Team_Member__c = :internalUser.Id];
          System.assertEquals(0, teamMemberList.size());                                    
      }
      
       static testMethod void addMemberDMLAfterInsertException() {
          setupTestData(); 

          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.Team_Member__c = internalUser.Id;
          controller.BETTeamMember.Role__c = betMembersSettings.MemberRole__c;
          controller.BETTeamMember.Request_Status__c = 'DMLExceptionAfterInsert';
         
          // Run Test
          Test.startTest();
          PageReference pRef  = controller.addMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND Team_Member__c = :internalUser.Id];
          System.assertEquals(0, teamMemberList.size());                                    
      }
      
       static testMethod void addMemberDMLBETShareException() {
          setupTestData(); 

          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.Team_Member__c = internalUser.Id;
          controller.BETTeamMember.Role__c = betMembersSettings.MemberRole__c;
          controller.BETTeamMember.Request_Status__c = 'DMLExceptionBETShareInsert';
         
          // Run Test
          Test.startTest();
          PageReference pRef  = controller.addMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND Team_Member__c = :internalUser.Id];
          System.assertEquals(0, teamMemberList.size());                                    
      }
      
      static testMethod void  deleteMember() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = betMembersSettings.ManagerRole__c;
          teamMember.Team_Member__c = internalUser.Id;
          teamMember.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
          teamMember.Request_Status__c = 'Approved';
          teamMember.Pending_Request__c = false;
          teamMember.BETEnabled__c = true;
 
          insert teamMember; 
          
          uw_BET__Share betShare  = new uw_BET__Share();
          betShare.UserOrGroupId = teamMember.Team_Member__c;
          betShare.AccessLevel = 'Edit';
          betShare.ParentId = testBET.Id;
    
          insert betShare;
          
          CollaborationGroupMember cgm = new CollaborationGroupMember();
          cgm.CollaborationRole = 'Admin';
          cgm.CollaborationGroupId = testBet.Studio_Chatter_Group__c;
          cgm.MemberId = teamMember.Team_Member__c;
          cgm.NotificationFrequency = 'N';

          insert cgm;
          
          EntitySubscription entitySubscription = new EntitySubscription();
          entitySubscription.SubscriberId = teamMember.Team_Member__c;
          entitySubscription.ParentId = teamMember.Bet__c;
          
          insert entitySubscription;
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.recordId = teamMember.Id;
         
          // Run Test
          Test.startTest();
          PageReference pRef = controller.deleteMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND Team_Member__c = :internalUser.Id];
          System.assertEquals(0, teamMemberList.size());  
          
      }
}