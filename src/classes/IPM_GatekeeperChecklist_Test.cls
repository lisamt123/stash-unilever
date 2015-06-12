@isTest
public class IPM_GatekeeperChecklist_Test {
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    public static IPM_Questionnaire__c ques;
    
    public static IPM_Questionnaire__c rndques;
    
    
    public static list<ID> projIDList;
    
    static testMethod void initializeData()
    {
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
               
               projDocSec=new IPM_Project_Document_Section__c();
               projDocSec.IPM_Project_Document__c=projDoc.ID;
               projDocSec.IPM_Selected_Channel_Name__c='HyperMarket';  
               insert projDocSec;
        
            projDocSecCon=new IPM_Project_Document_Section_Content__c();
            projDocSecCon.IPM_Project_Document_Section__c=projDocSec.ID;
            insert projDocSecCon;
        
          ques=new IPM_Questionnaire__c();
          ques.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('GateKeeperChecklist').RecordTypeId;
          ques.IPM_Sequence_Number__c=1;
          ques.IPM_Section_Sequence_Number__c='1.2.1';
          ques.IPM_Question__c='Test GK Question';
          ques.IPM_RQS_Gate_Type__c='Charter';
          ques.IPM_HelpText_Yes__c='Help Text Yes';
          ques.IPM_HelpText_No__c='help Text No';
          ques.IPM_HelpText_Partly__c='help text partly';
          ques.IPM_Project_Document_Section__c=projDocSec.Id;
          ques.Is_Master__c=true;
          insert ques;
        
        //rndques
          rndques=new IPM_Questionnaire__c();
          rndques.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RNDQuestion').RecordTypeId;
          rndques.IPM_Question__c='Test GK Question';
          rndques.IPM_RQS_Gate_Type__c='Charter';
          rndques.Is_Master__c=true;
          insert rndques;
    }
    
      static testMethod void testGatekeeperChecklist()
           {
               initializeData();
               PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
               Test.setCurrentPage(pRef);
               IPM_GatekeeperChecklist ipmGK=new IPM_GatekeeperChecklist();
              
               ipmGK.projectID=project.Id;
                // ipmCC.Names=new List<String>();
                 
           }
    
    static testMethod void testgenerateGKChecklist()
           {
               initializeData();
               PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
               Test.setCurrentPage(pRef);
               IPM_GatekeeperChecklist.generateGKChecklist('Charter', projIDList);
                IPM_GatekeeperChecklist.generateRnDQuestion('Charter', projIDList);
               //ipmGK.projectID=project.Id;
                // ipmCC.Names=new List<String>();
                 
           }
    
    static testMethod void testupdateGKchecklist()
    {
            initializeData();
               PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
               Test.setCurrentPage(pRef);
             IPM_GatekeeperChecklist ipmGK=new IPM_GatekeeperChecklist();
            ipmGK.cmts=true;
            ipmGK.quesId=ques.Id;
            ques.IPM_GK_Answers__c='Partly';
            ques.IPM_Comments__c='Answered';
            ipmGK.updateGKchecklist();
            ipmGK.cmts=true;
            ipmGK.quesId=ques.Id;
            ques.IPM_GK_Answers__c='Partly';
            ipmGK.updateGKchecklist();
        
    }
    
     static testMethod void testgetSectioWiseGKChecklist()
     {
         initializeData();
               PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
               Test.setCurrentPage(pRef);
            IPM_GatekeeperChecklist ipmGK=new IPM_GatekeeperChecklist();
             ipmGK.SecId=projDocSec.ID;
             ipmgk.getSectioWiseGKChecklist();
     }
    
    

}