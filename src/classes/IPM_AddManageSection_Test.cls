@isTest
public class IPM_AddManageSection_Test {
    
     public static IPM_Project__c project;
    public static IPM_Project__c regionalProject;
    public static IPM_Project__c localProject;
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    public static IPM_Project_Rollout__c projRoll;
    
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    
    //test data for Market Ready
    static testMethod void initializeData()
    {
        
            /*user=new User();
            user.FirstName='Test';
            user.LastName='User';
        Username, Email, Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey]: [Username, Email, Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey
            insert user;*/
        
            projTempl=new IPM_Project_Template__c();
            projTempl.IPM_Template_Complexity__c='Full';
            insert projTempl;
        
            ipdt=new IPM_Document_Template__c();
            ipdt.IPM_Project_Template__c=projTempl.ID;
            ipdt.IPM_Document_Template_Name__c='Charter Gate Full';
            ipdt.IPM_Document_Type__c='Charter';
            insert ipdt;
        
            secMst=new IPM_Section__c();
            secMst.IPM_Document_Template__c=ipdt.ID;
            secMst.IPM_Section_Sequence__c='1.1';
            secMst.IPM_Section_Name__c='Idea / Graphic';
            insert secMst;
        
         	   project=new IPM_Project__c();
               project.Name='TestComments';
               
               project.IPM_Phase__c='Ideas';
               project.IPM_Complexity__c='Full';
               project.IPM_GateKeeping_Model__c='Both'; 
               insert project;
        
        		 projRoll=new IPM_Project_Rollout__c();
                projRoll.IPM_Project__c=project.ID;
                projRoll.RecordTypeId=Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get('Regional Rollout').RecordTypeId;
                projRoll.IPM_Rollout_Project__c='TestComments_SEAA';
                projRoll.Market_Cluster__c='SEAA';
                projRoll.Target_Launch_Date__c=date.today();
                //projRoll.IPM_Regional_PL__c=UserInfo.getUserId();
                
                insert projRoll;
        	
        	 projDoc=new IPM_Project_Document__c();
               projDoc.IPM_GateDocuments__c='Charter'; 
               projDoc.IPM_Project__c=project.ID;
               projDoc.IPM_Project_Template__c= projTempl.Id;  
                projDOc.IPM_Contract_GateKeeper_Model__c='Both';
               insert projDoc;
                 projDocList.add(projDoc);
                
               projDocSec=new IPM_Project_Document_Section__c();
               projDocSec.IPM_Project_Document__c=projDoc.ID;
               projDocSec.IPM_Section_Name__c='Idea / Graphic'; 
                projDocSec.IPM_Section__c=secMst.Id;
               insert projDocSec;
        	
    }
    
     static testMethod void testAddManage()
     {
         initializeData();
          PageReference pRef = new PageReference('/apex/ipmAddManageSections?id='+project.Id+'&DocType='+projDoc.IPM_GateDocuments__c);
         Test.setCurrentPage(pRef);
         
         IPM_AddManageSection adMng=new IPM_AddManageSection();
         adMng.SaveAddManage();
     }

}