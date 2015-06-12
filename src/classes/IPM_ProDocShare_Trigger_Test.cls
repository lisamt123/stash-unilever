@isTest
private class IPM_ProDocShare_Trigger_Test{

    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Template__c projTemp; 
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    public static IPM_User_Profile__C UserProfile;
    public static IPM_Company_Card__C CCard;
    static testmethod void testCreateIPMProjectDocument(){
    
       initializedData();
        
       IPM_TestDataUtils testData = new IPM_TestDataUtils();

       Test.startTest();
        
       //testData.createIPMProjectResource ('BD',project);
       
       User u =testData.createUser();
       User u1 = testData.testRunAs();
       
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
       
       projDoc=new IPM_Project_Document__c();
       projDoc.IPM_GateDocuments__c='Charter'; 
       projDoc.IPM_Project__c=project.ID;
       projDoc.IPM_Project_Template__c=projTemp.Id;
       insert projDoc; 
       
       
       
       IPM_Project_Document__share  projectDocumentShare = new IPM_Project_Document__share  ();
       List<IPM_Project_Document__share  > listIPMProjectDocumentShare  = new List<IPM_Project_Document__share  >();
        
        
       projectDocumentShare.ParentId= projDoc.Id;
       System.debug('*********'+ u.id);
       projectDocumentShare.userOrGroupId =u.Id ;
       projectDocumentShare.accesslevel = 'Edit';
       listIPMProjectDocumentShare.add(projectDocumentShare);
        
       //insert listIPMProjectDocumentShare  ;


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
        
         
       /* CCard=new IPM_Company_Card__C();
        CCard.IPM_Managed_Category__c='HHC';
        insert CCard; 
        UserProfile=new IPM_User_Profile__C();
        //UserProfile.IPM_User__c=u2.id;
        //UserProfile.IPM_User_Category__c='HHC';
        UserProfile.IPM_Work_Level__c='WL2+';
        UserProfile.IPM_Company_Card__C=CCard.id;
        insert UserProfile;*/
       
        
        
    }
    
    


}