@isTest
private class IPM_ShareMilestone_Trigger_Test{

    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Template__c projTemp; 
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;


    static testmethod void testCreateIPMMilestone(){
    
        initializedData();
        
        IPM_TestDataUtils testData = new IPM_TestDataUtils();

        Test.startTest();       
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User  u1 = testData.testRunAs();
              
       
        
        
        project.IPM_Technical_Project_Leader__c =u1.Id;
        project.IPM_Project_Leader__c = u1.Id;
        project.Deputy_Project_Leader__c = u1.Id;
        project.IPM_Project_Gatekeeper__c = u1.Id;
        update project;
       
       
        
       /*IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
       
       ipmProjectResource.IPM_Role_Type__c = 'Finance';
       ipmProjectResource.IPM_Project__c = project.Id ;
       ipmProjectResource.IPM_User__c = u.Id ;
       insert ipmProjectResource;
        

       testData.createIPMProjectResource ('BD',project);*/
        
       IPM_Milestone__c  ipmMilestone1 = testData.createIPMMilestone(project, 'Charter Gate Approval');
        
       IPM_Milestone__share  milestoneShare = new IPM_Milestone__share  ();
       List<IPM_Milestone__share> listIPMMilestone = new List<IPM_Milestone__share>();
        
        
       milestoneShare.ParentId= ipmMilestone1.Id;
       System.debug('*********'+ u1.id);
       milestoneShare.userOrGroupId =u1.Id ;
       milestoneShare.accesslevel = 'Edit';
       listIPMMilestone.add(milestoneShare);
        
       //IPM_Questionnaire__share  questShareCopy = questShare;
       //delete questShare;
        
       //insert questShareCopy;
        
       try{

            insert listIPMMilestone ;
            testData.createIPMProjectResource ('BD',project);
            IPM_Milestone__c ipmQuestionaire = testData.createIPMMilestone(project, 'Charter Gate Approval'); 
       }
        
       catch(Exception e){
        
        
       }
        
       finally{

       }
        
        
        /*
        
        IPM_Milestone__c  ipmMilestone2 = testData.createIPMMilestone(project, 'Contract Gate Approval');
        IPM_Milestone__c  ipmMilestone3 = testData.createIPMMilestone(project, 'Market Ready Gate Approval');
        IPM_Milestone__c  ipmMilestone4 = testData.createIPMMilestone(project, 'Market Deployment Gate Approval');
        IPM_Milestone__c  ipmMilestone5 = testData.createIPMMilestone(project, 'Ship To Trade');
        */
        
        
        Test.stopTest();  
        
    
    }


static void initializedData()
    { 
        
        projTempl=new IPM_Project_Template__c();
        projTempl.IPM_Template_Complexity__c='Full';
        insert projTempl;
        
        ipdt=new IPM_Document_Template__c();
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Contract';
        ipdt.IPM_Document_Type__c='Charter';
        insert ipdt;
        
        secMst=new IPM_Section__c();
        secMst.IPM_Document_Template__c=ipdt.ID;
        secMst.IPM_Section_Sequence__c='1.1';
        secMst.IPM_Section_Name__c='Ideas';
        insert secMst;
        
        
        project=new IPM_Project__c();
        project.Name='TestGate';
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Full';
        insert project;
        
        projTemp=new IPM_Project_Template__c();
        projTemp.IPM_Template_Complexity__c='Full';
        insert projTemp;
        
        projDoc=new IPM_Project_Document__c();
        projDoc.IPM_GateDocuments__c='Charter'; 
        projDoc.IPM_Project__c=project.ID;
        projDoc.IPM_Project_Template__c=projTemp.Id;
        insert projDoc;     
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Negotiable__c=true;
        insert projDocSec;  
        
    }
    
    


}