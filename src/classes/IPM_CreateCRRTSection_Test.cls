@isTest
public class IPM_CreateCRRTSection_Test {
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
          PageReference pRef = new PageReference('/apex/IPM_CreateCRRTSection?id='+project.Id);
         Test.setCurrentPage(pRef);
         
       
       
     
         
     }
}