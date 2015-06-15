@isTest
public class IPM_ObjHistoryComponentController_Test {
    
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    public static Id docId;
     public static list<ID> projIDList;
    
     public static SObject projDocSeclist;
     public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
     
    public static IPM_Section__c secMst;
    
     static testMethod void initializeData()
    {
        
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
                   insert project;
                  projIDList=new List<ID>();       
                    projIDList.add(project.Id);
                   projDoc=new IPM_Project_Document__c();
                   projDoc.IPM_GateDocuments__c='Charter'; 
                   projDoc.IPM_Project__c=project.ID;
                   insert projDoc;
                   docId=projDoc.Id;
                   
                   projDocSec=new IPM_Project_Document_Section__c();
                   projDocSec.IPM_Project_Document__c=projDoc.ID;
                   projDocSec.IPM_Section_Name__c='Idea / Graphic';
               projDocSec.IPM_Section__c=secMst.Id;
                projDocSec.IPM_Gate_Document_Summary__c='Setup the History data';
                   projDocSec.IPM_PDP_Document_Summary__c='Setup the History data';
               insert projDocSec;
              projDocSeclist=[Select Id,IPM_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projDoc.Id Limit 1];
            
                projDocSecCon=new IPM_Project_Document_Section_Content__c();
                projDocSecCon.IPM_Project_Document_Section__c=projDocSec.ID;
                insert projDocSecCon;
    }
    
    
    static testMethod void testHistory()
     {
     test.startTest();
         initializeData();
         IPM_ObjectAllHistoryComponentController objHistory=new IPM_ObjectAllHistoryComponentController();
         projDocSec.IPM_Gate_Document_Summary__c='Setup the History data Now';
         update projDocSec;
         
         objHistory.myObject=projDocSeclist;
         objHistory.recordLimit=1;
         
         objHistory.projectId=project.id;
         objHistory.sectionId=projDocSec.Id;
         
         objHistory.getObjectHistory();
         
      
          //section History test
                
         IPM_ObjectHistoryComponentController objSecHistory=new IPM_ObjectHistoryComponentController();
         PageReference pRef = new PageReference('/apex/IPMSectionHistory?id='+projDocSec.Id);
         Test.setCurrentPage(pRef);
         
          objSecHistory.myObject=projDocSeclist;
         IPM_ObjectHistoryComponentController.objectLabel='IPM_Project_Document_Section__c';
          objSecHistory.recordLimit=50;
         //objSecHistory.projectId=project.id;
        // objSecHistory.sectionId=projDocSec.Id;
        objSecHistory.getObjectHistory();
        
        
         String fieldName='dsd';
        String str;
        IPM_ObjectAllHistoryComponentController.returnFieldLabel(fieldName);
        IPM_ObjectAllHistoryComponentController.objectHistoryLine objHis1 =new IPM_ObjectAllHistoryComponentController.objectHistoryLine();
        objHis1.theDate='ghgj';
        objHis1.who='dsfsd';
        objHis1.userId=project.Id;
        objHis1.action='gdfg';
        objHis1.whoImage='hfgh';
        objHis1.recordLink='rgr';
        objHis1.actionType='ger';
        
        
        IPM_ObjectHistoryComponentController.returnFieldLabel(fieldName);
        IPM_ObjectHistoryComponentController.objectHistoryLine objHis =new IPM_ObjectHistoryComponentController.objectHistoryLine();
        objHis.theDate='ghgj';
        objHis.who='dsfsd';
        objHis.userId=project.Id;
        objHis.action='gdfg';
        objHis.whoImage='hfgh';
        objHis.fieldName='bhfgh';
         test.stopTest();
      
        
        
     }


}