@isTest
public class IPM_OTIFstatusController_Test {
     
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project_Document__c> projDocList;
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    
    static testMethod void initializeData()
    {  
            
             project=new IPM_Project__c();
               project.Name='TestComments';
               project.IPM_Phase__c='Ideas';
             project.IPM_Complexity__c='Full';
             project.IPM_GateKeeping_Model__c='Both';  
               insert project;
               
               projDoc=new IPM_Project_Document__c();
               projDoc.IPM_GateDocuments__c='Charter'; 
               projDoc.IPM_Project__c=project.ID;
               insert projDoc;
               projDocList=new List<IPM_Project_Document__c>();
             projDocList.add(projDoc);
                    
               projDocSec=new IPM_Project_Document_Section__c();
               projDocSec.IPM_Project_Document__c=projDoc.ID;
               //projDocSec.IPM_Section_Sequence__c='7.4';  
               insert projDocSec;
        
            projDocSecCon=new IPM_Project_Document_Section_Content__c();
            projDocSecCon.IPM_Project_Document_Section__c=projDocSec.ID;
          projDocSecCon.IPM_OTIF_No_of_Status__c=4;
          projDocSecCon.IPM_OTIF_Measure__c='Measure 1';
          projDocSeccon.IPM_OTIF_Responsibility__c='BD';
          projDocSecCon.IPM_OTIF_Status__c='Not Applicable';
            projDocSecCon.IPM_OTIF_HelpText_Red__c='Red';
                 projDocSecCon.IPM_OTIF_HelpText_NA__c='NA';
                 projDocSecCon.IPM_OTIF_HelpText_Green__c='Green';
                 projDocSecCon.IPM_OTIF_HelpText_Amber__c='Amber';
                 projDocSecCon.IPM_Section_Number__c='2.2';
                 projDocSecCon.IPM_OTIF_Sequence__c=1;
                 projDocSecCon.IPM_Section_Id__c=projDocSec.ID;
                 projDocSecCon.IPM_Section_Name__c='Customer Channel';
                 projDocSecCon.IPM_Section_type__c='Checklist';
            insert projDocSecCon;
    }
    
    static testMethod void testShowContent()
    {
              initializeData();
               PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
               Test.setCurrentPage(pRef);
            
            IPM_OTIFstatusController otif=new IPM_OTIFstatusController();
            otif.projDocSecId=projDocSec.ID;
            otif.getprojDocSecId();
            otif.setprojDocSecId(projDocSec.ID);
            otif.type='table';
            otif.showSectionContent();
            otif.type='section';
            otif.showSectionContent();
            
            otif.secConId=projDocSecCon.Id;
            otif.status='Red';
            otif.updateOTIFStatus();
    }

}