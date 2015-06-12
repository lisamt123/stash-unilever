@isTest
public class IPM_ProjectTaskController_Test {
public static IPM_Project__c project;
public static IPM_Task__c task=new IPM_Task__c();
public static IPM_Project_Template__c proTemp=new IPM_Project_Template__c();
static testMethod void initializeData(){
project=new IPM_Project__c();


project.Name='TestComments';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
insert project;

proTemp.IPM_Template_Complexity__c='Full';
insert proTemp;

        task.IPM_Assignee__c = UserInfo.getUserId();
        task.IPM_Project__c=project.Id;
        //task.IPM_Section__c =section.Id;
        task.IPM_Task_Complexity__c ='Lite';
        task.IPM_Task_Name__c='Test';
        //IPM_Task_Type__c=
        //IPM_Type_of_Gate__c=''
        task.IPM_Phase__c='Ideas';
        //IPM_Function__c=
        task.IPM_Project_Template__c=proTemp.Id;
        task.Name='Test Sample Task';
        //RecordTypeId ='';
        
        insert task;



}


 
     
     static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_ProjectTaskController?id='+project.Id);
         Test.setCurrentPage(pRef);
         IPM_ProjectTaskController proTas=new IPM_ProjectTaskController();
       
       
     
         
     }
}