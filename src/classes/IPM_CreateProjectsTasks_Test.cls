@isTest
public class IPM_CreateProjectsTasks_Test{

    public static TestMethod void createProjects(){
        User u2 = new User(); 
              Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 


              
              u2 = new User(Alias = 'standt14', Email='standarduser@testorg14.com', 
              EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg14.com', 
              IPM_Category__c = 'test14'  , IPM_Brand_Positioning__c= 'test14',IPM_Brand_Name__c ='test1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
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
        
        IPM_Project__c projects=new IPM_Project__c();
        projects.Name='teest';
        projects.IPM_Project_Name__c='test';
        projects.IPM_PM_Approach__c='Internal';
        projects.IPM_IsCompleted__c=true;
        projects.IPM_Phase__c='Ideas';
        projects.IPM_Complexity__c='Lite';
        projects.IPM_Project_Leader__c=UserInfo.getUserId();
        insert projects;
        
        IPM_Project_Document__c pDocument=new IPM_Project_Document__c();
        pDocument.IPM_Project__c=projects.Id;
        pDocument.IPM_GateDocuments__c ='Charter';
        insert pDocument;
        
        IPM_Project_Document__c pDocument1=new IPM_Project_Document__c();
        pDocument1.IPM_Project__c=projects.Id;
        pDocument1.IPM_GateDocuments__c ='Contract';
        insert pDocument1;
            
        IPM_Project_Document_Section__c pdSection=new IPM_Project_Document_Section__c();
        pdSection.IPM_Section_Name__c='test';
        pdSection.IPM_Project_Document__c =pDocument.Id;
        insert pdSection;
        
      /* List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
       PermissionSet Fps=new PermissionSet();
       Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
       

       PermissionSetAssignment permissionSetAssignment=  [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :fps.Id limit 1];
        */
        IPM_Project_Resource__c pResource=new IPM_Project_Resource__c();
        pResource.IPM_User__c=assignpermission.AssigneeId;
        pResource.IPM_Project__c=projects.Id;
        pResource.IPM_Role_Type__c='test';
        //pResource.IPM_Project_Role_Owner__c =;
        insert pResource;
        
        IPM_Project_Template__c ptemplate=new IPM_Project_Template__c();
        ptemplate.IPM_Category__c='HHC';
        ptemplate.IPM_Template_Complexity__c = 'Default';
        ptemplate.IPM_Project__c =projects.Id;
        insert ptemplate;
        
        IPM_Document_Template__c dTemplate=new IPM_Document_Template__c();
        dTemplate.IPM_Document_Template_Name__c='test';
        dTemplate.IPM_Project_Template__c=ptemplate.Id;
        insert dTemplate;
        
        IPM_Section__c section=new IPM_Section__c();
        //section.Name='test';
        section.IPM_Section_Sequence__c='123';
        section.IPM_Document_Template__c=dTemplate.Id;
        section.IPM_FunctionalRole__c='BD';
        insert section;
        
        
        List<IPM_Task__c> lsttasks=new List<IPM_Task__c>();
        IPM_Task__c task=new IPM_Task__c();
        task.IPM_Assignee__c = UserInfo.getUserId();
        task.IPM_Project_Template__c = ptemplate.Id;
        task.IPM_Section__c =section.Id;
        task.IPM_Task_Complexity__c ='Lite';
        task.IPM_Task_Name__c='Test';
        //IPM_Task_Type__c=
        //IPM_Type_of_Gate__c=''
        task.IPM_Phase__c='Ideas';
        //IPM_Function__c=
        task.IPM_Project_Document_Section__c =pdSection.Id;
        task.IPM_Project_Template__c =ptemplate.Id;
        task.Name='Test Sample Task';
        //RecordTypeId ='';
        lsttasks.add(task);
        insert task;
        
        IPM_Task__c task1=new IPM_Task__c();
        task1.IPM_Assignee__c = UserInfo.getUserId();
        task1.IPM_Project_Template__c = ptemplate.Id;
        task1.IPM_Section__c =section.Id;
        task1.IPM_Task_Complexity__c ='Full';
        task1.IPM_Task_Name__c='Test';
        //IPM_Task_Type__c=
        //IPM_Type_of_Gate__c=''
        task1.IPM_Phase__c='Ideas';
        //IPM_Function__c=
        task1.IPM_Project_Document_Section__c =pdSection.Id;
        task1.IPM_Project_Template__c =ptemplate.Id;
        task1.Name='Test Sample Task';
        //RecordTypeId ='';
        //lsttasks.add(task1);
        insert task1;
        
        //upsert lsttasks
        
        
       // test.startTest();
        projects.IPM_Complexity__c='Full';
        projects.IPM_Phase__c='Feasibility';
        projects.IPM_Fast_Track_Project__c=true;
        projects.IPMProject_Span__c = 'Global';
        update projects;
        //test.stopTest();
    }
}