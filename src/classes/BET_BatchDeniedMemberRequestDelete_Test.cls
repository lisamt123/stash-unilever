/**********************************************************************
Name: BET_BatchDeniedMemberRequestDelete_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for BET_BatchDeniedMemberRequestDelete
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class BET_BatchDeniedMemberRequestDelete_Test { 
      static private uw_BET_Team_Member__c  teamMember1, teamMember2;
      
      static void setupTestData() {
          // Custom settings
          BET_ManageMembersSettings__c betMembersSettings = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
          
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
          bet.Category_Level_2__c ='Dressings';
          bet.Inoplan_Project__c = inoProject.id;
          bet.Name = 'bet1';
          // Note: Insert BET will create an Owner record (uw_BET_Team_Member__c), see uw_Trigger_Handler.addOwnerToBetTeamAsManager() method        
          insert bet;

           // Internal user  
           Profile internalProfile = [Select Id From profile Where name='Unilever Way - Marketing - Standard Marketing User' LIMIT 1]; 
           User internalUser = new User(alias = 'u1xyz', email='u1xyz@unilever.com', 
           emailencodingkey='UTF-8', lastname='BETTester1', languagelocalekey='en_US', 
           localesidkey='en_US', profileid = internalProfile.Id, 
           timezonesidkey='America/Los_Angeles', username='BETtester1xyz@unileverxyz.com');
           insert internalUser;  

           teamMember1 = new uw_BET_Team_Member__c();
           teamMember1.BET__c = bet.Id;
           teamMember1.Role__c = betMembersSettings.MemberRole__c;
           teamMember1.Team_Member__c = internalUser.Id;
           teamMember1.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
           teamMember1.Request_Status__c = betMembersSettings.DeniedStatus__c;
           teamMember1.Pending_Request__c = false;
           teamMember1.BETEnabled__c = true;
           //teamMember.Scheduled_Delete_Date__c = System.today();
           insert teamMember1;

           teamMember2 = new uW_BET_Team_Member__c();
           teamMember2.BET__c = bet.Id;
           teamMember2.Role__c = betMembersSettings.MemberRole__c;
           teamMember2.Team_Member__c = internalUser.Id;
           teamMember2.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
           //teamMember2.Request_Status__c = null;
           teamMember2.Pending_Request__c = true;
           teamMember2.BETEnabled__c = true;
           insert teamMember2;
      }
      
      static void setupTestDataforDMLException() {
          // Custom settings
          BET_ManageMembersSettings__c betMembersSettings = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
          
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
          bet.Category_Level_2__c ='Dressings';
          bet.Inoplan_Project__c = inoProject.id;
          bet.Name = 'bet1';
          // Note: Insert BET will create an Owner record (uw_BET_Team_Member__c), see uw_Trigger_Handler.addOwnerToBetTeamAsManager() method        
          insert bet;

           // Internal user  
           Profile internalProfile = [Select Id From profile Where name='Unilever Way - Marketing - Standard Marketing User' LIMIT 1]; 
           User internalUser = new User(alias = 'u1xyz', email='u1xyz@unilever.com', 
           emailencodingkey='UTF-8', lastname='BETTester1', languagelocalekey='en_US', 
           localesidkey='en_US', profileid = internalProfile.Id, 
           timezonesidkey='America/Los_Angeles', username='BETtester1exception@unileverxyz.com');
           insert internalUser;  

           teamMember1 = new uw_BET_Team_Member__c();
           teamMember1.BET__c = bet.Id;
           teamMember1.Role__c = 'InvalidRole';
           teamMember1.Team_Member__c = internalUser.Id;
           teamMember1.Access_Level__c = betMembersSettings.ToolkitAccessLevel__c;
           teamMember1.Request_Status__c = betMembersSettings.DeniedStatus__c;
           teamMember1.Pending_Request__c = false;
           teamMember1.BETEnabled__c = true;
           //teamMember.Scheduled_Delete_Date__c = System.today();
           insert teamMember1;
      }


    /*******************************************************************
    Purpose: Method to test deleting assets using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void deleteDeniedMembers(){
           // Create test data
           setupTestData();

           // Start test
           Test.startTest();
           // Simulate that the days for waiting (default value: 3 days) passed
           teamMember1.Scheduled_Delete_Date__c = System.today();
           update teamMember1;
           BET_BatchDeniedMemberRequestDelete batchDelete = new BET_BatchDeniedMemberRequestDelete();
           Database.executeBatch(batchDelete, 200);
           Test.stopTest();
           
           // Assert test result
           List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name FROM uw_BET_Team_Member__c];  // Count = One Owner as part of creating BET + a new member with Pending Request
           System.assertEquals(2, teamMemberList.size());
           
           teamMemberList = [SELECT Id, Name FROM uw_BET_Team_Member__c WHERE Pending_Request__c = true];
           System.assertEquals(1, teamMemberList.size());
           
    }
    
    
    /*******************************************************************
    Purpose: Method to test deleting assets using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void deleteDeniedMembersWithDMLDeleteException(){
           // Create test data
           setupTestDataforDMLException();

           // Start test
           Test.startTest();
           // Simulate that the days for waiting (default value: 3 days) passed
           teamMember1.Scheduled_Delete_Date__c = System.today();
           update teamMember1;
           BET_BatchDeniedMemberRequestDelete batchDelete = new BET_BatchDeniedMemberRequestDelete();
           Database.executeBatch(batchDelete, 200);
           Test.stopTest();
           
           // Assert test result
           List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name FROM uw_BET_Team_Member__c];  // Count = One Owner as part of creating BET
           System.assertEquals(1, teamMemberList.size());
    }
}