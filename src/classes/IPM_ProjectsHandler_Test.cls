@isTest
public class IPM_ProjectsHandler_Test{


 static testmethod void testIPM_ProjectsHandlerConstructor(){
     Map<Id,IPM_Project__c> mapNewIPMProjects = new Map<Id,IPM_Project__c>();
     Map<Id,IPM_Project__c> mapOldIPMProjects = new Map<Id,IPM_Project__c>();

     IPM_ProjectsHandler  ipmProjectHandler= new IPM_ProjectsHandler ();  
     
     List<IPM_Project__c> listOldProject= new List<IPM_Project__c>();
     
     IPM_Project__c project = new IPM_Project__c();
     project=new IPM_Project__c();
     project.Name='TestGate';
     project.IPM_Phase__c='Ideas';
     project.IPM_Complexity__c='Full';
     
     insert project;
     mapNewIPMProjects.put(project.Id,project);
     listOldProject.add(project); 
     
     IPM_Project_Task__c ipmProjectTasks= new IPM_Project_Task__c();
     ipmProjectTasks.IPM_Project__c =project.Id ;
     //insert ipmProjectTasks;
     
     IPM_Task__c ipmTask= new IPM_Task__c();
     ipmTask.IPM_Project__c=project.Id ;
     ipmTask.IPM_Task_Complexity__c ='Full' ;
     insert ipmTask;
     
     
     project = new IPM_Project__c();
     project=new IPM_Project__c();
     project.Name='TestGate1';
     project.IPM_Phase__c='Ideas';
     project.IPM_Complexity__c='Lite';
     insert project;
     mapNewIPMProjects.put(project.Id,project);
     listOldProject.add(project); 
     

     ipmProjectTasks= new IPM_Project_Task__c();
     ipmProjectTasks.IPM_Project__c =project.Id ;
     //insert ipmProjectTasks;
     
     ipmProjectTasks= new IPM_Project_Task__c();
     ipmProjectTasks.IPM_Project__c =project.Id ;
     ipmTask.IPM_Task_Complexity__c ='Full' ;
     insert ipmProjectTasks;
     
     
     IPM_ProjectsHandler.processIPMProjects (mapNewIPMProjects ,listOldProject,'UPDATE');
     
 }
 
  static testmethod void testCreateTasks(){

     Map<Id,IPM_Project__c> mapNewIPMProjects = new Map<Id,IPM_Project__c>();
     Map<Id,IPM_Project__c> mapOldIPMProjects = new Map<Id,IPM_Project__c>();
     IPM_ProjectsHandler  ipmProjectHandler= new IPM_ProjectsHandler ();  
     List<IPM_Project__c> listOldProject= new List<IPM_Project__c>();
     
     IPM_Project__c project = new IPM_Project__c();
     project=new IPM_Project__c();
     project.Name='TestGate';
     project.IPM_Phase__c='Ideas';
     project.IPM_Complexity__c='Full';
     
     insert project;
     mapNewIPMProjects.put(project.Id,project);
     project.IPM_Complexity__c='Lite';
     update project;
     
     mapOldIPMProjects.put(project.Id,project);
     listOldProject.add(project); 
     
     IPM_Project_Task__c ipmProjectTasks= new IPM_Project_Task__c();
     ipmProjectTasks.IPM_Project__c =project.Id ;
     insert ipmProjectTasks;
     
     IPM_Task__c ipmTask= new IPM_Task__c();
     ipmTask.IPM_Project__c=project.Id ;
     ipmTask.IPM_Task_Complexity__c ='Full' ;
     insert ipmTask;
     
     IPM_ProjectsHandler ipmProjectsHandlr = new IPM_ProjectsHandler ();
          
     IPM_ProjectsHandler.createTasks(mapNewIPMProjects ,mapOldIPMProjects);
     
     
     
     project = new IPM_Project__c();
     project=new IPM_Project__c();
     project.Name='TestGate1';
     project.IPM_Phase__c='Ideas';
     project.IPM_Complexity__c='Lite';
     insert project;
     mapNewIPMProjects.put(project.Id,project);
     project.IPM_Complexity__c='Full';
     mapOldIPMProjects.put(project.Id,project);
     listOldProject.add(project); 
     
     

     ipmProjectTasks= new IPM_Project_Task__c();
     ipmProjectTasks.IPM_Project__c =project.Id ;
     ipmTask.IPM_Task_Complexity__c ='Full' ;
     insert ipmProjectTasks;
     
     ipmTask= new IPM_Task__c();
     ipmTask.IPM_Project__c=project.Id ;
     insert ipmTask;
     
     ipmProjectsHandlr = new IPM_ProjectsHandler ();
          
     IPM_ProjectsHandler.createTasks(mapNewIPMProjects ,mapOldIPMProjects);
     
 }



}