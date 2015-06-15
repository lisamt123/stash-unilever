@isTest
public class ipmRolloutPlansTableControllerTests{
    public static IPM_Project__c project;
    public static IPM_Project__c project1;
    public static IPM_Project_Rollout__c proRoll; 
    public static String projectId;
    static void initializeData(){
        project=new IPM_Project__c();
        project.Name='Test Finanace D';
        project.IPM_Phase__c='Feasibility';
        project.Sustainability_Period__c='3';
        project.IPMProject_Span__c = 'Global';
        insert project;
        
        
        project1=new IPM_Project__c();
        project1.IPM_Parent_Project__c=project.Id;
        project1.Name='Test Finanace D1';
        project1.IPM_Phase__c='Feasibility';
        project1.Sustainability_Period__c='3';
        project1.IPMProject_Span__c = 'Regional';
        insert project1;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'sta2224', Email='standarduser@testorg9224.com', 
        EmailEncodingKey='UTF-8', LastName='Testing224', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg4.com', 
              IPM_Category__c = 'test2224'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u;
        System.runAs(u) {
                 // The following code runs as user 'u' 
                 System.debug('Current User: ' + UserInfo.getUserName());
                 System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
        
        
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='TEST FINANCE D_EUR';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=project.ID;
        proRoll.Target_Launch_Date__c=System.today();
       // proRoll.IPM_Regional_PL__c = u.Id;
       
        ApexPages.CurrentPage().getparameters().put('id', project.Id);
        insert proRoll;
              
    }

    static void initializeData1(){
        project=new IPM_Project__c();
        project.Name='Test Finanace D';
        project.IPM_Phase__c='Feasibility';
        project.Sustainability_Period__c='3';
        project.IPMProject_Span__c='Global';
        insert project;
        
        project1=new IPM_Project__c();
        project1.IPM_Parent_Project__c=project.Id;
        project1.Name='Test Finanace D1';
        project1.IPM_Phase__c='Feasibility';
        project1.Sustainability_Period__c='3';
        project1.IPMProject_Span__c = 'Regional';
        insert project1;
        //ApexPages.CurrentPage().getparameters().put(project1.Id);
        ApexPages.CurrentPage().getparameters().put('id', ''+project1.Id);
         
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='TEST FINANCE D_EUR';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=project.ID;
        proRoll.Target_Launch_Date__c=System.today();
        insert proRoll;
              
    }


    static testMethod void doTest() {
        Test.startTest();
        initializeData();
        String selectedMCORollout=project.ID;
        projectId = ApexPages.currentPage().getParameters().get('id');
        ipmRolloutPlansTableControllerTests thisTestClass= new ipmRolloutPlansTableControllerTests();
        ipmRolloutPlansTableController irp= new ipmRolloutPlansTableController();
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+project.ID);
        Test.setCurrentPageReference(pRef);
        irp.project = project;
        irp.editRollout();
        irp.cancelRollout();
        irp.checkRollouts();
        irp.addRollout();
        
        irp.saveRollout();
        //irp.generateLocalProjects(); 
        irp.selectedMCORollout= proRoll.Id; 
        irp.deleteMCORollout();  

        
        Test.stopTest();
        
        
          
    }
    
    static testMethod void doTest1() {
        Test.startTest();
        
        initializeData1();
        String selectedMCORollout=project.ID;
        projectId = ApexPages.currentPage().getParameters().get('project.Id');
        ipmRolloutPlansTableControllerTests thisTestClass= new ipmRolloutPlansTableControllerTests();
        ipmRolloutPlansTableController irp= new ipmRolloutPlansTableController();
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+project.ID);
        Test.setCurrentPageReference(pRef);
        irp.project = project1;
        irp.editRollout();
        irp.cancelRollout();
        irp.checkRollouts();
        irp.addRollout();
        
        irp.saveRollout();
        //irp.generateLocalProjects(); 
        irp.selectedMCORollout= proRoll.Id; 
        irp.deleteMCORollout();  
        
  
        
        Test.stopTest();
        
        
          
    }
    
 }