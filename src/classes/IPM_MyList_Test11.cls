@isTest
public class IPM_MyList_Test11{
    public static TestMethod void IPM_MyListTest(){
    
     PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        u = new User(Alias = 'raj22', Email='raj22@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='raj22@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u;
          System.runAs(u) {
                psa.AssigneeId = u.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
         
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
       
        User u1 = new User();
        u1 = new User(Alias = 'raj20', Email='raj20@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='raj20@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u1;
          System.runAs(u1) {
                psa1.AssigneeId = u1.Id;
                psa1.PermissionSetId = Fps.Id;
                insert psa1;
           }
        
        //Insert Company Card
        /*IPM_Company_Card__c compCard=new IPM_Company_Card__c();
        compCard.Name='Test Company Cardm';
        insert compCard;*/
        
        //Insert User Profile
       /* IPM_User_Profile__c up=new IPM_User_Profile__c();
        up.IPM_User__c=u.Id;
        insert up;*/
        
        //Insert User Profile
       /* IPM_User_Profile__c up1=new IPM_User_Profile__c();
        up1.IPM_User__c=u1.Id;
        //up1.IPM_Company_Card__c=compCard.Id;
        insert up1;*/
        
        //User u = testRunAs();
        
       
        
        //System.debug('*******Printing user---'+ u1.Id);
        
        IPM_Task__c ita=new IPM_Task__c(IPM_Assignee__c=userinfo.getuserid(),name='test task');
        insert ita;
        
        IPM_Project__c projects=new IPM_Project__c();
        projects.Name='teest';
        projects.IPM_Project_Name__c='test';
        projects.IPM_PM_Approach__c='External';
        projects.IPM_IsCompleted__c=true;
        projects.IPM_Fast_Track_Project__c=false;
        projects.IPM_Phase__c='Ideas';
        projects.IPM_Market_Type__c='Developing';
        projects.IPM_Complexity__c='Lite';
        projects.IPM_Target_Launch_Dates__c=System.today()+10;
        projects.IPM_Project_Leader__c=u.Id;
        //projects.IPM_Project_Gatekeeper__c=UserInfo.getUserId();
        //projects.Deputy_Project_Leader__c=UserInfo.getUserId();
        //projects.IPM_Technical_Project_Leader__c=UserInfo.getUserId();
        // System.Assert(projects.Id != null, 'The project record not inserted');
        insert projects;  
        
        
        
        IPM_Project__share  proshare = new IPM_Project__share  ();
        List<IPM_Project__share  > listproshare  = new List<IPM_Project__share>();
        proshare.ParentId= projects.Id;
        proshare.userOrGroupId = psa1.AssigneeId;
        proshare.accesslevel = 'Edit';
        listproshare.add(proshare);
        insert listproshare;
        
        
        IPM_Project_Resource__c pResource=new IPM_Project_Resource__c();
        pResource.IPM_User__c=u1.Id;
        pResource.IPM_Project__c=projects.Id;
        pResource.IPM_Role_Type__c='Supply Chain';
        insert pResource;
        
                
        
        IPM_Project_Resource__Share projectResourceShr=new IPM_Project_Resource__Share ();
        List<IPM_Project_Resource__Share> projectResourceShrList=new list<IPM_Project_Resource__Share>();
        projectResourceShr.ParentId= pResource.Id;
        projectResourceShr.userOrGroupId = psa1.AssigneeId;
        projectResourceShr.accesslevel = 'Edit';
        projectResourceShrList.add(projectResourceShr);
        insert projectResourceShrList;
        
        IPM_Milestone__c milestone=new IPM_Milestone__c();
        milestone.IPM_Due_Date__c =System.today()+30;
        milestone.IPM_Name__c ='test';
        milestone.IPM_Phase__c = 'Phase';
        milestone.IPM_Project__c =projects.Id;
        insert milestone;
        
        apexpages.currentpage().getparameters().put('Id',projects.Id);
         ApexPages.StandardController sc = new ApexPages.StandardController(projects);
        IPM_Taskview taskview =new IPM_Taskview(sc);
        taskview.isupdateDates=true;
        taskview.isvisible=true;
        taskview.FunctionRole='';
        taskview.getMileStoneAlerts();
        
        /*        
        IPM_Taskview__Share taskViewShr=new IPM_Taskview__Share ();
        List<IPM_Taskview__Share>protaskViewShr=new list<IPM_Taskview__Share>();        
        taskViewShr.ParentId= taskview.Id;
        taskViewShr.userOrGroupId = permissionSetAssignment.AssigneeId;
        taskViewShr.accesslevel = 'Edit';
        protaskViewShr.add(taskViewShr);
        insert protaskViewShr;
        */
        
        IPM_Milestone__c milestone1=new IPM_Milestone__c();
        milestone1.IPM_Due_Date__c =System.today()+30;
        milestone1.IPM_Name__c ='test';
        milestone1.IPM_Phase__c = 'Capability';
        milestone1.IPM_Project__c =projects.Id;
        insert milestone1;
        
        IPM_Milestone__Share PLIpmMilesShr=new IPM_Milestone__Share ();
        List<IPM_Milestone__Share>ProMiles=new list<IPM_Milestone__Share>();        
        PLIpmMilesShr.ParentId= milestone1.Id;
        PLIpmMilesShr.userOrGroupId = psa1.AssigneeId;
        PLIpmMilesShr.accesslevel = 'Edit';
        ProMiles.add(PLIpmMilesShr);
        insert ProMiles;

               

        
        try{
        taskview.getMileStoneAlerts();
        }catch(Exception e){}
        taskview.getIpmuserType();
        
      //  test.StartTest();
     /*  IPM_Project__c pr=new IPM_Project__c(Id=projects.Id,IPM_Project_Leader__c='',IPM_Project_Gatekeeper__c=UserInfo.getUserId());
        update pr;  
        taskview.getIpmuserType();
        
        IPM_Project__c pr1=new IPM_Project__c(Id=projects.Id,IPM_Project_Leader__c='',IPM_Project_Gatekeeper__c='',Deputy_Project_Leader__c=UserInfo.getUserId());
        update pr1;  
        taskview.getIpmuserType();
        
        IPM_Project__c pr2=new IPM_Project__c(Id=projects.Id,IPM_Project_Leader__c='',IPM_Project_Gatekeeper__c='',Deputy_Project_Leader__c='',IPM_Technical_Project_Leader__c=UserInfo.getUserId());
        update pr2; 
        taskview.getIpmuserType();*/
       // test.stopTest();
    
    
    IPM_MyList ipm=new IPM_MyList();
ipm.toggleSortAssignees();
ipm.filteredPhase();
ipm.filteredUser();
ipm.myTasks();
ipm.myRole();
ipm.deleteTask();
//ipm.setTaskId(string.valueof(ita.id));
//ipm.markComplete();
ipm.project();
ipm.bosscard();
ipm.showAllOverDue();
ipm.getOverduetasksSample();
ipm.todayTasksize();
ipm.getprojectTaskssample();
//ipm.getLaterTasks();
ipm.showAllLaterTasks();
ipm.showCompletedTasks();
ipm.getcompletedTasks();
//ipm.setprojectName('test proj');
ipm.getprojectName();
//ipm.filteredProject();
//ipm.setcategoryName('cat1');
ipm.getcategoryName();
ipm.toggleSortSections();
ipm.toggleSortTasks();
ipm.filterCompleteTasks();
ipm.toggleSortPhases();
//ipm.setbrandName('br1');
ipm.getbrandName();
ipm.toggleDueDate();
//ipm.projectSearch();
ipm.toggleSortCompletion();
ipm.filteredBrand();
    
    }
    
    /*
    
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
              
                  
                  PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
                    PermissionSetAssignment psa = new PermissionSetAssignment();
                    psa.AssigneeId = u.Id;
                    
                    
                    psa.PermissionSetId = ps.Id;
                    insert psa;
                    
                    System.debug('****** psa.AssigneeId '+ psa.AssigneeId );
                  
                  
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
    
    
    */
    
    
    
}