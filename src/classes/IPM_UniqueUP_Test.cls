@isTest
public class IPM_UniqueUP_Test {
public static IPM_Project__c project;
public static IPM_Project_Document__c proDoc=new IPM_Project_Document__c();
public static IPM_User_Profile__c up=new IPM_User_Profile__c();
public static Map<Id, IPM_Project_Document__c> newPDocumentsMap=new Map<Id, IPM_Project_Document__c>();
public static IPM_Company_Card__c comCard=new IPM_Company_Card__c();
static testMethod void initializeData(){

//PermissionSet Fps=new PermissionSet();
        //Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        //PermissionSetAssignment psa = new PermissionSetAssignment();
       
        /*User u = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u = new User(Alias = 'raj22mm', Email='raj22@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='raj22mm@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u;
          //System.runAs(u) {
                //psa.AssigneeId = u.Id;
                //psa.PermissionSetId = Fps.Id;
                //insert psa;}
                
                 String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Company_Card__c' and Name='Regional Company Card'].Id;
        comCard.Name='com';
        comCard.IPM_Managed_Category__c='Savory';
        comCard.IPM_Currency__c='AED';
        comCard.IPM_TxtGeographical_Scope__c='geo';
        comCard.RecordTypeId=strRecordTypeId1; 
        comCard.IPM_Market_Cluster__c='clus';
        comCard.IPM_MCO__c='mco';
          up.Name='sadsa';
                up.IPM_Category__c='Laundry';
                up.IPM_Company_Card__c=comCard.Id;
                up.IPM_User__c=u.Id;
                up.IPM_User_Role__c='GateKeeper';
                up.IPM_User_Function__c='BD';
        
        System.runAs(u) {
        insert comCard;
        insert up;
        }*/
                
              
                

project=new IPM_Project__c();


project.Name='TestComments';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
insert project;


        proDoc.IPM_GateDocuments__c='Charter'; 
        proDoc.IPM_Project__c=project.ID;
        //proDoc.IPM_Project_Template__c=projTemp.Id;
        insert proDoc;    
 
 newPDocumentsMap.put(proDoc.Id,proDoc);

}


 
     
     static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_UniqueUP?id='+project.Id);
         Test.setCurrentPage(pRef);
         
       
     
         
     }
}