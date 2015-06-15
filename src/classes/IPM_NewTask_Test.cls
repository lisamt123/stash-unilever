@isTest
public class IPM_NewTask_Test{
    
    public static TestMethod void createTaskView(){
    Test.startTest();
     User u2 = new User(); 
              Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User']; 


              
              u2 = new User(Alias = 'jjjlll8', Email='standarduser@testorg4.com', 
              EmailEncodingKey='UTF-8', LastName='Testingkk4', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standardusertugadkk@testorg14jlt.com', 
              IPM_Category__c = 'testakk14'  , IPM_Brand_Positioning__c= 'testakk14',IPM_Brand_Name__c ='testakk1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='testakk', isActive =true);
              insert u2;
       List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
       PermissionSet Fps=new PermissionSet();
       PermissionSetAssignment assignpermission=new PermissionSetAssignment ();
       system.runAs(u2){
       
       Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
      
       assignpermission.AssigneeId =u2.id;
       assignpermission.PermissionSetId=Fps.id;
       insert assignpermission;
      }
        /*List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
          PermissionSet Fps=new PermissionSet();      
           Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1];
            
            
           PermissionSetAssignment permissionSetAssignment=  [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :fps.Id limit 1];
            */
        IPM_Project__c projects=new IPM_Project__c();
        projects.Name='teesta';
        projects.IPM_Project_Name__c='testa';
        projects.IPM_PM_Approach__c='External';
        projects.IPM_IsCompleted__c=true;
        projects.IPM_Fast_Track_Project__c=false;
        projects.IPM_Phase__c='Ideas';
        projects.IPM_Market_Type__c='Developing';
        projects.IPM_Complexity__c='Lite';
        projects.IPM_Target_Launch_Dates__c=System.today()+12;
        projects.IPM_Project_Leader__c=UserInfo.getUserId();
        //projects.IPM_Project_Gatekeeper__c=UserInfo.getUserId();
        //projects.Deputy_Project_Leader__c=UserInfo.getUserId();
        //projects.IPM_Technical_Project_Leader__c=UserInfo.getUserId();
        insert projects;  
        
        
        
        system.debug('Assigne.......'+assignpermission.AssigneeId);
        IPM_Project_Resource__c pResource=new IPM_Project_Resource__c();
        pResource.IPM_Project__c=projects.Id;
        pResource.IPM_Role_Type__c='Supply Chain';
        pResource.IPM_User__c = assignpermission.AssigneeId ;
       // pResource.IPM_Role_Type__c='BD';
        insert pResource;
        
        IPM_Task__c task=new IPM_Task__c();
        task.IPM_Active__c  =true;
        //task.IPM_Assignee__c =UserInfo.getUserId();
        //task.IPM_Completed_Date__c =false
        task.IPM_Completed__c =false;
        //task.IPM_Due_Date1__c = 
        task.IPM_Function__c ='BD';
        task.IPM_Phase__c = 'Ideas';
        //task.IPM_Project_Document_Section__c    =
        //task.IPM_Project_Template__c    =
        task.IPM_Project__c =projects.Id;
        //task.IPM_Section_Number__c  =
        //task.IPM_Section__c =
        task.IPM_Task_Complexity__c ='Lite';
        task.IPM_Task_Name__c ='test';
        task.IPM_Task_Type__c ='Non-Negotiable';
        task.IPM_Type_of_Gate__c ='Charter';
        //task.IPM_Version_Number__c=
        insert task;
        
         System.debug('Tasks:'+task);
         
         IPM_Project_Document__c pDocument=new IPM_Project_Document__c();
         pDocument.IPM_Project__c=projects.Id;
         pDocument.IPM_GateDocuments__c='Charter';
         insert pDocument;
        
         
         //ApexPages.currentPage().getParameters().put('projDocSecId',projDocSec.Id);
         ApexPages.currentPage().getParameters().put('taskId',task.Id);
                             
         apexpages.currentpage().getparameters().put('projectId',projects.Id);
         ApexPages.StandardController sc = new ApexPages.StandardController(task);
        IPM_NewTask taskview =new IPM_NewTask(sc);
        
         //IPM_NewTask newTasks=new IPM_NewTask();
         taskview.getSections();
         taskview.closePopup();
         taskview.showPopup();
         taskview.dosaveTasks();
         Test.stopTest();
        
        }
         public static User  testRunAs() {
   
      List<User> usrname = [SELECT UserName from User where UserName='standarduser@testorg4.com' ];
      User u = new User();
        
        if(usrname== null){
              // Setup test data
              // This code runs as the system user
              Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 


              
              u = new User(Alias = 'standt4', Email='standarduser@testorg4.com', 
              EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg4.com', 
              IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
              insert u;
              
              
              
              System.runAs(u) {
                 // The following code runs as user 'u' 
                 System.debug('Current User: ' + UserInfo.getUserName());
                 System.debug('Current Profile: ' + UserInfo.getProfileId()); 
              }
      }
      else {
             if(usrname.size()>0){
                 u = [SELECT Alias,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,ProfileId ,TimeZoneSidKey,UserName, IPM_Category__c ,IPM_Brand_Positioning__c, IPM_Brand_Name__c ,IPM_Role__c , IPM_Sub_Category__c    from User where UserName='standarduser@testorg4.com' ];
                 
             }     
         }   
      return u ;
   }
        
    
    
    
    }