/* Test Class written by ACC-IDC-Srilakshmi for Incident -ULHD00007465430 -Deleting a BET does not delete the corresponding group */

@isTest
private class uw_BET_before_delete_test_class
{
     public static testMethod void before_delete()
     {               
        User internalUser = uw_UnitTestDataFactory.initInternaSysAdminlUser('Test', 'internal@unilevertest.com', 'Test User', 'internal@unilevertest.com');
        uw_Brand__c brand = uw_UnitTestDataFactory.createParentBrand();       
        insert brand; 
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;            
        uw_BET__c bet = uw_UnitTestDataFactory.createBet(brand, 'Test Bet'+Math.random(),inoPlanProject);               
        insert bet;
        uw_BET__c testBet = [Select id, Name, Studio_Chatter_Group__c from uw_BET__c where Id = :bet.Id];          
        
        Id BETID =testBet.Id;
        Id STUDIOGROUPID=testBet.Studio_Chatter_Group__c; 
        // Create A group member       


       //Testing the BET Chatter group is created after creating the BET
       List<CollaborationGroup> BET_Chatter_group =[Select Id from CollaborationGroup where Id =:STUDIOGROUPID];
       System.assertEquals(BET_Chatter_group.size(),1);
  
         //Creating BET Chatter group member
         CollaborationGroupMember groupMember = new CollaborationGroupMember();    
         groupMember.CollaborationGroupId  = testBet.Studio_Chatter_Group__c;   
         groupMember.MemberId = internalUser.Id;       
         insert groupMember;

    //Creating Team member
     uw_BET_Team_Member__c tm = new uw_BET_Team_Member__c();
     tm.Access_Level__c='Edit';
     tm.StudioEnabled__c=true;
     tm.BETEnabled__c=true;
     tm.Team_Member__c=internalUser.Id;
     tm.Role__c='Member';
     insert tm;

         
         //deleting the  BET
         delete bet;
         
        //Testing BET Record deletion
    List<uw_BET__c> bet_deleted = [Select Id from uw_BET__c  Where Id =:BETID LIMIT 1];
        System.assertEquals(bet_deleted.size(),0);

        //Testing BET Team member record deletion upon BET record deletion
        List<uw_BET_Team_Member__c> tm1 = [Select Id,BET__c from uw_BET_Team_Member__c where  BET__c =:BETID];    
        system.assertEquals(tm1.size(),0);

    //Testing BET Chatter group deletion upon BET record deletion
    List<CollaborationGroup> BET_group =[Select Id from CollaborationGroup where Id =:STUDIOGROUPID];
    system.assertEquals(BET_group.size(),0);

    
     }
     
 }