@isTest
private class IPM_AssignPermission_Trigger_Test{
boolean isPL;
boolean isFinance;
boolean isPLDelete;
Boolean isFinDelete;
list<id> createPLPermissioset=new list<id>();
list<id> createFinancePermissioset=new list<id>();
list<id>deletePLPermission=new list<id>();
list<id>deleteFinance=new list<id>();
List<String> userdetails = new List<String>();
set<id>CheckForUser=new set<id>();
public static IPM_Project__c project;
public static IPM_Project_Document__c projDoc;
public static IPM_Project_Template__c projTemp; 
public static IPM_Project_Document_Section__c projDocSec;
public static IPM_Document_Template__c ipdt;
public static IPM_Project_Template__c projTempl;
public static IPM_Section__c secMst;
public static IPM_Bosscard__c Bosscard;
public static IPM_Task__c ipmltask;
public static IPM_Milestone__c PLIpmMiles;
public static IPM_Questionnaire__c questionaire;
static testmethod void testCreateIPMUserProfile(){
    
       Test.startTest();
        PermissionSet Fps=new PermissionSet();
        PermissionSetAssignment assignpermission=new PermissionSetAssignment ();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        User u = new User(); 
              Profile p1 = [SELECT Id FROM Profile WHERE Name='standard user']; 
              u = new User(Alias = 'permu1', Email='permu1@testorg1444.com', 
              EmailEncodingKey='UTF-8', LastName='Testing444', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='permu1@testorg1444.com', 
              IPM_Category__c = 'test1444'  , IPM_Brand_Positioning__c= 'test1444',IPM_Brand_Name__c ='test1444',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
              insert u;
              User u1 = new User(); 
              Profile p = [SELECT Id FROM Profile WHERE Name='standard user']; 
              u1 = new User(Alias = 'permu2', Email='permu2@permu2.com', 
              EmailEncodingKey='UTF-8', LastName='permu2', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='permu2@permu2.com', 
              IPM_Category__c = 'permu2'  , IPM_Brand_Positioning__c= 'permu2',IPM_Brand_Name__c ='permu2',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
              insert u1;  
              system.debug('u1..'+u1.id);
              system.debug('u..'+u.id);            
       
       IPM_User_Profile__c up=new IPM_User_Profile__c();
       //up.Name='TestUser';
       up.IPM_User__c=u.Id;
       up.IPM_User_Role__c='BD';
       up.IPM_User_Function__c='Project Leader';
       uP.IPM_Central_Team__c=true;
       up.Export_Porfolio_Data__c=true;
       up.IPM_Work_Level__c='WL2+';
       up.IPM_User_Category__c='test';
       IPM_Company_Card__c cc=new IPM_Company_Card__c();
       cc.name='ccname';
       cc.IPM_Managed_Category__c='test';
      
       system.runas(u1){
       insert cc;
       up.IPM_Company_Card__c=cc.id;
      
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
        
       Bosscard=new IPM_Bosscard__c();
       Bosscard.Name='TestGate1';
       insert Bosscard;
        
       project=new IPM_Project__c();
       project.Name='TestGate';
       project.IPM_Phase__c='Ideas';
       project.IPM_Complexity__c='Full';
       project.IPM_Bosscard__c=Bosscard.id;
        
     
       
       project.IPM_Technical_Project_Leader__c =u.Id;
       project.IPM_Project_Leader__c = u.Id;
       project.Deputy_Project_Leader__c = u.Id;
       project.IPM_Project_Gatekeeper__c = u.Id;
       project.IPM_Company_Card__c =cc.Id;
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

        IPM_Project_Document_Section_Content__c  ipmProjDocSectionContent =  new IPM_Project_Document_Section_Content__c ();
        ipmProjDocSectionContent .IPM_Project_Document_Section__c =projDocSec.ID;
        
        insert ipmProjDocSectionContent ;
        
        
        
        ipmltask=new IPM_Task__c ();
        ipmltask.name='testtask';
        ipmltask.IPM_Project__c=project.id;
        insert ipmltask; 
        
        PLIpmMiles=new IPM_Milestone__c();
        PLIpmMiles.name='testtask';
        PLIpmMiles.IPM_Project__c=project.id;
        insert PLIpmMiles; 
        
        IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
       
        ipmProjectResource.IPM_Role_Type__c = 'Finance';
        ipmProjectResource.IPM_Project__c = project.Id ;
        ipmProjectResource.IPM_User__c =u.id ;
        insert ipmProjectResource;
        insert up;
        
        up.IPM_User__c=u1.id;
        update up;
        delete up;
       }
       Test.stopTest();  
    
    }
static testmethod void BPuserPermission(){
IPM_Project__share  proshare = new IPM_Project__share  ();
       List<IPM_Project__share  > listproshare  = new List<IPM_Project__share>();
       IPM_Project_Document__share  projectDocumentShare = new IPM_Project_Document__share  ();
       List<IPM_Project_Document__share  > listIPMProjectDocumentShare  = new List<IPM_Project_Document__share  >();
       IPM_Project_Document_Section__Share  projectDocumentSecShare = new IPM_Project_Document_Section__Share  ();
       List<IPM_Project_Document_Section__Share  > listIPMProjectDocumentSecShare  = new List<IPM_Project_Document_Section__Share>();
       List<IPM_Task__Share>ProTaskShare=new list<IPM_Task__Share>();
       List<IPM_Project_Document_Section__Share>ProDocSec=new list<IPM_Project_Document_Section__Share>();
       List<IPM_Project_Document_Section_Content__Share>ProDocContent=new list<IPM_Project_Document_Section_Content__Share>();
       List<IPM_Milestone__Share>ProMiles=new list<IPM_Milestone__Share>();
       List<IPM_Questionnaire__Share>IpmQuests=new list<IPM_Questionnaire__Share>();
       List<IPM_Bosscard__Share>IpmBossShare=new list<IPM_Bosscard__Share>();
       IPM_Bosscard__Share Bossshare=new IPM_Bosscard__Share();
       IPM_Questionnaire__Share ipmQuestionaireShare = new IPM_Questionnaire__Share();
       List<IPM_Questionnaire__Share > listIPMQuestionaireShare  = new List<IPM_Questionnaire__Share >();

       IPM_Project_Document_Section_Content__c  ipmProjDocSectionContent =new IPM_Project_Document_Section_Content__c ();
       IPM_Project_Document_Section_Content__share  ipmProjDocSectionContentShare = new IPM_Project_Document_Section_Content__share  ();
       List<IPM_Project_Document_Section_Content__share  > listipmProjDocSectionContentShare  = new List<IPM_Project_Document_Section_Content__share  >();

       IPM_Project_Document__Share ProDocShr=new IPM_Project_Document__Share();
       IPM_Project__Share ipmProshr=new IPM_Project__Share ();
       IPM_Project_Resource__Share DPLrsShr=new IPM_Project_Resource__Share ();
       IPM_Project_Resource__Share GatekrsShr=new IPM_Project_Resource__Share ();
       IPM_Project_Resource__Share TPLrsShr=new IPM_Project_Resource__Share ();
       IPM_Project_Document_Section__Share ProSec;
       IPM_Task__Share ProTskShare=new IPM_Task__Share ();
       IPM_Project_Document_Section_Content__Share IpmDocContent=new IPM_Project_Document_Section_Content__Share ();
       IPM_Milestone__Share PLIpmMilesShr=new IPM_Milestone__Share ();
       IPM_Questionnaire__Share IPMQuestshr=new IPM_Questionnaire__Share ();
        
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User u1 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u1 = new User(Alias = 'bpu1', Email='bpu1@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='prs12', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='bpu1@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u1;
          /*System.runAs(u1) {
                psa.AssigneeId = u1.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }*/
        User u = new User();
        PermissionSetAssignment psa1 = new PermissionSetAssignment();   
        u = new User(Alias = 'bpu2', Email='bpu2@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='bpu2@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u;
        User u2 = new User();
        u2 = new User(Alias = 'bpu3', Email='bpu3@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='bpu3@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u2;
       System.runAs(u) {   
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
      
      IPM_Company_Card__c ipmCompanyCard = new IPM_Company_Card__c();
      ipmCompanyCard.name='CCard';
      ipmCompanyCard.IPM_Business_Partner__c=u2.id;
      insert ipmCompanyCard;
      
       ipmCompanyCard.IPM_Business_Partner__c=u1.id;
        update ipmCompanyCard;
        }
}
static testmethod void testCreateIPMUserProfile1(){
    
       Test.startTest();
        PermissionSet Fps=new PermissionSet();
        PermissionSetAssignment assignpermission=new PermissionSetAssignment ();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        User u = new User(); 
              Profile p1 = [SELECT Id FROM Profile WHERE Name='standard user']; 
              u = new User(Alias = 'perms1', Email='perms1@testorg1444.com', 
              EmailEncodingKey='UTF-8', LastName='Testing444', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='perms1@testorg1444.com', 
              IPM_Category__c = 'test1444'  , IPM_Brand_Positioning__c= 'test1444',IPM_Brand_Name__c ='test1444',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
              insert u;
              User u1 = new User(); 
              Profile p = [SELECT Id FROM Profile WHERE Name='standard user']; 
              u1 = new User(Alias = 'perms2', Email='permu2@permu2.com', 
              EmailEncodingKey='UTF-8', LastName='permu2', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='permu2@permu2.com', 
              IPM_Category__c = 'permu2'  , IPM_Brand_Positioning__c= 'permu2',IPM_Brand_Name__c ='permu2',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
              insert u1;  
              system.debug('u1..'+u1.id);
              system.debug('u..'+u.id);            
       
       IPM_User_Profile__c up=new IPM_User_Profile__c();
       //up.Name='TestUser';
       up.IPM_User__c=u.Id;
       up.IPM_User_Role__c='Finance';
       up.IPM_User_Function__c='Gatekeeper';
       uP.IPM_Central_Team__c=true;
       up.Export_Porfolio_Data__c=true;
       up.IPM_Work_Level__c='WL2+';
       up.IPM_User_Category__c='test';
       IPM_Company_Card__c cc=new IPM_Company_Card__c();
       cc.name='ccname';
       cc.IPM_Managed_Category__c='test';
      
       system.runas(u1){
       insert cc;
       up.IPM_Company_Card__c=cc.id;
      
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
        
       Bosscard=new IPM_Bosscard__c();
       Bosscard.Name='TestGate1';
       insert Bosscard;
        
       project=new IPM_Project__c();
       project.Name='TestGate';
       project.IPM_Phase__c='Ideas';
       project.IPM_Complexity__c='Full';
       project.IPM_Bosscard__c=Bosscard.id;
        
     
       
       project.IPM_Technical_Project_Leader__c =u.Id;
       project.IPM_Project_Leader__c = u.Id;
       project.Deputy_Project_Leader__c = u.Id;
       project.IPM_Project_Gatekeeper__c = u.Id;
       project.IPM_Company_Card__c =cc.Id;
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

        IPM_Project_Document_Section_Content__c  ipmProjDocSectionContent =  new IPM_Project_Document_Section_Content__c ();
        ipmProjDocSectionContent .IPM_Project_Document_Section__c =projDocSec.ID;
        
        insert ipmProjDocSectionContent ;
        
        
        
        ipmltask=new IPM_Task__c ();
        ipmltask.name='testtask';
        ipmltask.IPM_Project__c=project.id;
        insert ipmltask; 
        
        PLIpmMiles=new IPM_Milestone__c();
        PLIpmMiles.name='testtask';
        PLIpmMiles.IPM_Project__c=project.id;
        insert PLIpmMiles; 
        
        IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
       
        ipmProjectResource.IPM_Role_Type__c = 'Finance';
        ipmProjectResource.IPM_Project__c = project.Id ;
        ipmProjectResource.IPM_User__c =u.id ;
        insert ipmProjectResource;
        insert up;
        
        
       }
       Test.stopTest();  
    
    }
}