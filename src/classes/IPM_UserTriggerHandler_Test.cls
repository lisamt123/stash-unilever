@isTest
public class IPM_UserTriggerHandler_Test {
public static IPM_Project__c project;

static testMethod void initializeData(){
project=new IPM_Project__c();


project.Name='TestComments';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
insert project;



}


 
     
     static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_UserTriggerHandler?id='+project.Id);
         Test.setCurrentPage(pRef);
         IPM_UserTriggerHandler useTri=new IPM_UserTriggerHandler(true);
          User[] newUsers= new List<User>();
          Map<Id, User> oldUsersMap=new Map<Id, User>();
          User[] oldUsers= new List<User>();
         useTri.OnAfterUpdate(newUsers,oldUsersMap);
         useTri.OnAfterDelete(oldUsers);
       
     
         
     }
}