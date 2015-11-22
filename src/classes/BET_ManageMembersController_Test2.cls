//@isTest(seeAllData=true)
@isTest
private class BET_ManageMembersController_Test2 {
      static private uw_BET__c testBET;
      static private BET_ManageMembersSettings__c betMembersSettings;
      static private User internalUser, externalUser, internalUser2, externalUser2;
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
           
           
            // Inactive Internal user
           
           //Profile internalProfile = [Select Id From profile Where name='Unilever Way - Marketing - Standard Marketing User' LIMIT 1]; 
           //User internalUser = new User(alias = 'u2xyz', email='u2xyz@unilever.com', 
           internalUser2 = new User(alias = 'u2xyz', email='u2xyz@unilever.com',
           emailencodingkey='UTF-8', lastname='BETTester2', languagelocalekey='en_US', 
           localesidkey='en_US', profileid = internalProfile.Id, 
           timezonesidkey='America/Los_Angeles', username='BETtester2xyz@unileverxyz.com');
           
           internalUser2.IsActive = false;
           insert internalUser2;
             
          // External user
           Profile externalProfile = [Select Id From profile Where name='Chatter External User' LIMIT 1]; 
           //User externalUser = new User(alias = 'extalias', email='external.agency@email.com.edu', 
           externalUser = new User(alias = 'extalias', email='external.agency@email.com.edu',
           emailencodingkey='UTF-8', lastname='external', languagelocalekey='en_US', 
           localesidkey='en_US', profileid = externalProfile.Id, 
           timezonesidkey='America/Los_Angeles', username='externalagencyemail.com.edu@org.org.org');
           
           insert externalUser;
           
           // External user
           //Profile externalProfile = [Select Id From profile Where name='Chatter External User' LIMIT 1]; 
           //User externalUser = new User(alias = 'extalias', email='external.agency@email.com.edu', 
           externalUser2 = new User(alias = 'extali2', email='external.agency2@email.com.edu',
           emailencodingkey='UTF-8', lastname='external2', languagelocalekey='en_US', 
           localesidkey='en_US', profileid = externalProfile.Id, 
           timezonesidkey='America/Los_Angeles', username='externalagency2email.com.edu@org.org.org');
           
           externalUser2.IsActive = false;
           insert externalUser2;
      }

      
      // New test methods for addExternalUser scenarios
      
       static testMethod void addExternalMemberWithNullEmail() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = null;
         
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
             if (msg.getDetail().contains('You should select an internal or an external user')) b = true;
          }
          system.assert(b);//Assert the Page Message was Properly Displayed
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c, email__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id];
          System.assertEquals(1, teamMemberList.size());                                    
 }
 
 
  static testMethod void addExternalMemberWithEmptyEmail() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = ' ';
         
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
             if (msg.getDetail().contains('The extenal user email address is blank. Please enter a value.')) b = true;
          }
          system.assert(b);//Assert the Page Message was Properly Displayed
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c, email__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id];
          System.assertEquals(1, teamMemberList.size());                                     
 }
 
 
 static testMethod void addExternalMemberWithUnileverEmailNonAgent() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = 'u1xyz@unilever.com';
         
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
             if (msg.getDetail().contains('This email id belongs to an existing internal Unilever user')) b = true;
          }
          system.assert(b);//Assert the Page Message was Properly Displayed
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id];
          System.assertEquals(1, teamMemberList.size());                                     
 }
 
 static testMethod void addExternalMemberWithUnileverEmailNonAgentInActive() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = 'u2xyz@unilever.com';
         
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
             if (msg.getDetail().contains('Chatter account is currently locked')) b = true;
          }
          system.assert(b);//Assert the Page Message was Properly Displayed
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id];
          System.assertEquals(1, teamMemberList.size());                                       
 }
 
 
 
  static testMethod void addExternalMemberNoChatterAccount() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = 'nochatter@unilever.com';
         
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
             if (msg.getDetail().contains('does not have a Chatter account')) b = true;
          }
          system.assert(b);//Assert the Page Message was Properly Displayed
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id];
          System.assertEquals(1, teamMemberList.size());
                                       
 }
 
 
 static testMethod void addExternalMemberExistingInActive() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = 'external.agency2@email.com.edu';
         
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
             if (msg.getDetail().contains('is an existing user (External Agent) but inactive at the moment')) b = true;
          }
          system.assert(b);//Assert the Page Message was Properly Displayed
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Role__c, Team_Member__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id];
          System.assertEquals(1, teamMemberList.size());                                       
   }
 
 
   static testMethod void addExternalMemberPendingInvite() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.email__c = 'external.agency3@email.com.edu';
          teamMember.Invite_Pending__c = true;
          
          insert teamMember; 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = 'external.agency3@email.com.edu';
         
          // Run Test
          Test.startTest();
          PageReference pRef  = controller.addMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Invite_Pending__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND email__c = 'external.agency3@email.com.edu'];
          System.assertEquals(1, teamMemberList.size()); 
          System.assertEquals(true, teamMemberList[0].Invite_Pending__c);                                      
      }
      
      
      static testMethod void addExternalMemberNotExisting() {
          setupTestData(); 
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.BETTeamMember.email__c = 'external.agency3@email.com.edu';
         
          // Run Test
          Test.startTest();
          PageReference pRef  = controller.addMember();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Invite_Pending__c, BET__c FROM uw_BET_Team_Member__c 
                                                        WHERE BET__c = :testBET.Id AND email__c = 'external.agency3@email.com.edu'];
          System.assertEquals(1, teamMemberList.size()); 
          
          List<uw_Terms_Conditions__c> tncList = [SELECT Id, Status__c, uw_BET__c FROM uw_Terms_Conditions__c];
                                                 // WHERE Status__c = 'New' AND uw_BET__c = :testBET.Id];
          System.assertEquals(1, tncList.size());
                                                  
                                               
      }
 
 
     static testMethod void  approveRequestDMLException() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = 'ThrowDMLException';
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
          
          controller.recordId = teamMember.Id;
          
          // Run Test
          Test.startTest();
          PageReference pRef = controller.approveRequest();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> approvedteamMemberList = [SELECT Id, Name, Pending_Request__c, Request_Status__c FROM uw_BET_Team_Member__c WHERE Id = :teamMember.Id];
          
          // Assert Test result
          System.assertEquals(1, approvedteamMemberList.size());
          System.assertEquals(true, approvedteamMemberList[0].Pending_Request__c);
             
          List<uw_BET__Share> betShareList = [SELECT Id FROM uw_BET__Share WHERE UserOrGroupId = :teamMember.Team_Member__c AND ParentId = :testBet.Id];   
          System.assertEquals(0, betShareList.size()); 
          
          List<EntitySubscription> entitySubscriptionList = [SELECT Id FROM EntitySubscription WHERE SubscriberId = :teamMember.Team_Member__c AND ParentId = :testBet.Id];   
          System.assertEquals(0, entitySubscriptionList.size()); 
          
          List<CollaborationGroupMember> cgmList = [SELECT Id FROM CollaborationGroupMember WHERE MemberId = :teamMember.Team_Member__c];   
          System.assertEquals(0, cgmList.size());
      }
 
 
       static testMethod void  deleteMemberDMLException() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = 'ThrowDMLException';
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
          System.assertEquals(1, teamMemberList.size());  
          
      }
 
 
 static testMethod void setRoleDMLException() {
          setupTestData(); 
  
          uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
          teamMember.BET__c = testBet.Id;
          teamMember.Role__c = 'ThrowDMLException';
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
          ApexPages.currentPage().getParameters().put('role','ThrowDMLException');
          
          
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
          System.assertEquals('ThrowDMLException', teamMemberList[0].Role__c);
      }
      
      
       static testMethod void  getBetNameMissingBET() {
          // Create Test Data
          setupTestData(); 
          
          System.Debug('get BetName Test BET Id: ' + testBET.Id);
          
          delete testBet;
          
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
          System.assertEquals(null, betName);
      }
      
      
      static testMethod void  approveRequestMissingBETMember() {
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
          
          //delete testBet;
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          
          controller.recordId = teamMember.Id;
          
          delete teamMember;
          
          // Run Test
          Test.startTest();
          PageReference pRef = controller.approveRequest();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> approvedteamMemberList = [SELECT Id, Name, Pending_Request__c, Request_Status__c FROM uw_BET_Team_Member__c WHERE Id = :teamMember.Id];
          
          // Assert Test result
          System.assertEquals(0, approvedteamMemberList.size());
      }
      
      
      static testMethod void  denyRequestMissingBETMember() {
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
          
          //delete testBet;
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          
          controller.recordId = teamMember.Id;
          System.Debug('CONTROLLER RECORDID: ' + controller.recordId);
          
          delete teamMember;
          // Run Test
          Test.startTest();
          PageReference pRef = controller.denyRequest();
          Test.stopTest();
          
          System.assertEquals(null, pRef);
          
          List<uw_BET_Team_Member__c> deniedteamMemberList = [SELECT Id, Name, Pending_Request__c, Request_Status__c FROM uw_BET_Team_Member__c WHERE Id = :teamMember.Id];
          
          // Assert Test result
          System.assertEquals(0, deniedteamMemberList.size());
      }
      
      
      static testMethod void  deleteMemberMissingBETMember() {
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
          
          //delete testBet;
          
          PageReference pageRef = Page.BET_ManageMembers;
          //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('bet',testBET.Id);
          
          
          ApexPages.StandardController sc = new ApexPages.StandardController(testBET);
          //system.assert(sc != null);
        
          BET_ManageMembersController controller = new BET_ManageMembersController(sc);
          controller.recordId = teamMember.Id;
          
          delete teamMember;
         
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