@isTest
public class IPM_AssortStrategy_Test {
    
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    public static IPM_Customer_Channel_Priority_Order__c iccPO;
    
    public static ID projID;
    public static ID projDocSecID;
   
    static testMethod void initializeData()
    {
               project=new IPM_Project__c();
               project.Name='TestComments';
               
               project.IPM_Phase__c='Ideas';
               insert project;
               
               projDoc=new IPM_Project_Document__c();
               projDoc.IPM_GateDocuments__c='Charter'; 
               projDoc.IPM_Project__c=project.ID;
               insert projDoc;
               
               projDocSec=new IPM_Project_Document_Section__c();
               projDocSec.IPM_Project_Document__c=projDoc.ID;
               projDocSec.IPM_Selected_Channel_Name__c='HyperMarket';   
               insert projDocSec;
        
                projDocSecCon=new IPM_Project_Document_Section_Content__c();
                projDocSecCon.IPM_Project_Document_Section__c=projDocSec.ID;
                insert projDocSecCon;
              
                projDocSecID=projDocSec.Id;
                projID=project.Id;
                    
                iccPO=new IPM_Customer_Channel_Priority_Order__c();
                iccPO.Name='HyperMarket';
                iccPO.Priority_Order_Value__c='1';
                insert iccPO;
                
        
            
    }
    static testMethod void testCustomerChannel()
           {
               IPM_AssortmentStrategy ipmCC=new IPM_AssortmentStrategy ();
               ipmCC.Names=new List<String>();
                
           }
       
    static testMethod void testcreateChannel()
     {
            initializeData();
            set<string>cuname=new set<string>();
            cuname.add('HyperMarket');
            set<string>cuname1=new set<string>();
            cuname1.add('CU CIF BANO REP ECON DOYP 450ML DOM');
            PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
            Test.setCurrentPage(pRef);
            IPM_AssortmentStrategy  ipmCC=new IPM_AssortmentStrategy ();
            ipmcc.ProdocSecId=projDocSec.Id;
            ipmcc.setchannelName=cuname;
            ipmcc.setSelectedCUsNames=cuname1;
            ipmcc.IPMProdocContent.IPM_Distribution_Type__c='Numeric';
           
            //ipmcc.projectId=project.Id;
            //ipmcc.
            //ipmcc.createChannel();
           // ipmcc.conName=new List<String>();
            ipmcc.CreateAssortStrategy();
         
         
     }
    static testMethod void testchangePriority()
     {
         initializeData();
            PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
            Test.setCurrentPage(pRef);
            IPM_AssortmentStrategy ipmCC=new IPM_AssortmentStrategy ();
            ipmcc.ProdocSecId=projDocSec.Id;
            //ipmcc.projectId=project.Id;
            //ipmcc.secConId=projDocSecCon.Id;
            ipmcc.selecteAssortTodelete=projDocSecCon.Id;
            ipmcc.updateAssortS();
     }
       
    static testMethod void testdeleteSectionContent()
    {
             initializeData();
             PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
            Test.setCurrentPage(pRef);
            IPM_AssortmentStrategy ipmCC=new IPM_AssortmentStrategy ();
            ipmcc.ProdocSecId=projDocSec.Id;
            //ipmcc.projectId=project.Id;
            //ipmcc.secConId=projDocSecCon.Id;
            ipmcc.DltAllAssort();
            
    }
     
   
   

}