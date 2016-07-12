@isTest(seealldata=true)
public class AA_Follow_Unfollow_batch_Test {    
    public static testMethod void testMethodFollowUnfollowBatch(){
    test.starttest();
    AA_Follow_Unfollow_batch obj= new AA_Follow_Unfollow_batch();
    aa_Agent_App_User_Preference__c userPref = new aa_Agent_App_User_Preference__c(Auto_follow__c= true,UserId__c = userInfo.getUserid());
    insert userPref;
    List<aa_Agent_App_User_Preference__c> objAgent =  new  List<aa_Agent_App_User_Preference__c>();
    objAgent.add(userPref);
    Database.BatchableContext BC;
    obj.start(BC);
    obj.execute(BC,objAgent);
    obj.finish(BC);
    
    
    test.stoptest();
    
    }
  }