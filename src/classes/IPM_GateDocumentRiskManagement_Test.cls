@isTest
public class IPM_GateDocumentRiskManagement_Test {
    
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    public static IPM_Questionnaire__c pos;
    
    public static IPM_Questionnaire__c rqs;
    public static IPM_POS_RQS_Mapping__c prMapping;
    public static List<IPM_POS_RQS_Mapping__c> prMappingList=new List<IPM_POS_RQS_Mapping__c>();
    
      Public static List<IPM_Questionnaire__c> posQuestionsList=new List<IPM_Questionnaire__c>();
    
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
        
          pos=new IPM_Questionnaire__c();
          pos.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('POS Questionnaire').RecordTypeId;
          pos.IPM_POS_Question_Type__c='Consumer';
          pos.IPM_Sequence_Number__c=1;
          //pos.IPM_Section_Sequence_Number__c='1.2.1';
          pos.IPM_Question__c='Test POS Question';
          //pos.IPM_RQS_Gate_Type__c='Charter';
          pos.IPM_HelpText_Yes__c='Help Text Yes';
          pos.IPM_HelpText_No__c='help Text No';
          pos.IPM_HelpText_Partly__c='help text partly';
          //pos.IPM_Project_Document_Section__c=projDocSec.Id;
          pos.Is_Master__c=true;
          insert pos;
           
          posQuestionsList.add(pos);
        
          pos=new IPM_Questionnaire__c();
          pos.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('POS Questionnaire').RecordTypeId;
          pos.IPM_POS_Question_Type__c='Consumer';
          pos.IPM_Sequence_Number__c=1;
          //pos.IPM_Section_Sequence_Number__c='1.2.1';
          pos.IPM_Question__c='Test POS Question';
          //pos.IPM_RQS_Gate_Type__c='Charter';
          pos.IPM_HelpText_Yes__c='Help Text Yes';
          pos.IPM_HelpText_No__c='help Text No';
          pos.IPM_HelpText_Partly__c='help text partly';
          pos.IPM_Project__c=project.Id;
          pos.Is_Master__c=false;
          pos.IPM_Show_Create_Link__c=true;
          insert pos;
        //rndques
          rqs=new IPM_Questionnaire__c();
          rqs.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;
          rqs.IPM_Question__c='Test RQS Question';
          rqs.IPM_RQS_Gate_Type__c='Charter';
          rqs.IPM_RQS_Question_Type__c='Consumer';
          rqs.IPM_Sequence_Number__c=1;
            rqs.IPM_HelpText_Yes__c='Help Text Yes';
          rqs.IPM_HelpText_No__c='help Text No';
          rqs.IPM_HelpText_Partly__c='help text partly';
          rqs.IPM_HelpText_Five__c='One more';
          rqs.Is_Master__c=true;
          insert rqs;
        
        //rndques
          rqs=new IPM_Questionnaire__c();
          rqs.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;
          rqs.IPM_Question__c='Test RQS Question';
          rqs.IPM_RQS_Gate_Type__c='Charter';
          rqs.IPM_RQS_Question_Type__c='Consumer';
          rqs.IPM_Sequence_Number__c=1;
            rqs.IPM_HelpText_Yes__c='Help Text Yes';
          rqs.IPM_HelpText_No__c='help Text No';
          rqs.IPM_HelpText_Partly__c='help text partly';
          rqs.IPM_HelpText_Five__c='One more';
          rqs.IPM_Project__c=project.Id;
          rqs.Is_Master__c=false;
          insert rqs;
        
          prMapping=new IPM_POS_RQS_Mapping__c();
          prMapping.Name='Consumer';
          prMapping.Score__c=3;
          prMapping.Charter__c='2,17,23,24,25,26';
          prMapping.Contract__c='1,2,3,4,17,18,19,20,21,22,23,24,25,26';
          insert prMapping;
          prMappingList.add(prMapping);
    }
    
    static testMethod void testRiskManagement()
    {
        initializeData();
               PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id+'&gateType=Charter'+'&IsEditable=true');
               Test.setCurrentPage(pRef);
          IPM_GateDocumentRiskManagement.generatePOSforProject(project.Id);
          IPM_GateDocumentRiskManagement risk=new IPM_GateDocumentRiskManagement();
          risk.getPOSList();
          
          
    }
    static testMethod void testsaveRisk()
    {
        initializeData();
               PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id+'&gateType=Charter'+'&IsEditable=true');
               Test.setCurrentPage(pRef);
          IPM_GateDocumentRiskManagement risk=new IPM_GateDocumentRiskManagement();
      //show POS list
          risk.getPOSList();
          //Save POS options
          risk.score=3;
          risk.qId=pos.Id;
          risk.saveScore();
          //proceed to RQS
          risk.proceed();
          //save RQS
          risk.score=4;
          risk.qId=rqs.Id;
          risk.saveRQSScore();
          //add new RQS
          risk.Question.IPM_RQS_Question_Type__c='Consumer';
          risk.Question.IPM_Question__c='Add new';
          risk.addQuestion();
          risk.cancelQuestion();
          
          //change question view
          risk.changeQuestionView();
          risk.backToPos();
        
          // generate Mitigation plan
          risk.generateMitigationPlan();
          // save mitigation comment
          risk.quesId=rqs.Id;
          risk.comments='Test Code covered';
          risk.saveComment();
        
          // rqs delete
          risk.quesId=rqs.Id;
          risk.deleteQuestion();
        
          
    }
    
 }