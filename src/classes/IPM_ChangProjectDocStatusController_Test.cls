/******************************************************************************************************************************
* @author Cognizant 
* @date 15/12/2014
* @description Test Class for Chante Project Document Status Controller. This is when the Project Leader Approves a Document
	Lots of valdations needs to be fullfilled hence there are many fields in this test class
*/
@isTest
private class  IPM_ChangProjectDocStatusController_Test { 
    private static PageReference  pRef;
    private static IPM_Project__c project;// Project object initialization
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();// Project Documetn List
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    public static List<SelectOption> secOpt=new List<SelectOption>();
    private static IPM_Project_Type__c proType;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static List<IPM_Milestone__c>mileListObj;
    private static List<IPM_Project_Document__c>docStatus;
    private static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    private static User stdUserForChangStatus;
   private static final string STATUS_NOT_MATCHED_STR='status not matched';// assert statements
    private static final string STATUS_NOT_CHANGED_STR='status not changed';// assert statements
    private static User globalUser;
    private static string REGIONAL_STR='Regional';
    private static IPM_Project__c regProject;// Project object initialization\
    private static IPM_ChangProjectDocumentStatusController chngPro;
    private static List<IPM_Project_Document__c>docListObj=new List<IPM_Project_Document__c>();
    private static List<IPM_Project_Document__c>docList=new List<IPM_Project_Document__c>();
    private static final string RESULT_STR='result';
    private static IPM_Project_Document_Section_Content__c projectDocSecConListObj=new IPM_Project_Document_Section_Content__c();
    private static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    private static IPM_Gate_CMI__c gateCMICountry;
    private static final string INVALID_NAME='TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTes';
    private static IPM_Project__c childProj;
    private static IPM_Project__c childProjs;
    private static IPM_Financial__c localFin;
    private static string ROLLOUT_STR='Rollout';
    private static string GLOBALCOMPANY_CARD_STR='Global Company Card';
    private static string INNOVATIONRENO_STR='Innovation/Renovation';
    private static string RCLT_STR='RCLT';
    private static string LITE_STR='Lite';
    private static string PROJECT_CREATION_STR='Project Creation';
    private static string PROJECT_STATUS_STR='Eligible For Processing';
    private static string PROJECT_CATEGORY_STR='Household Care';
    private static string CURRENTPHASE_STR='Current Phase is';
    private static string ERRORONPAGE_STR='display error message on page';
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            // user has to be created as system admin 
            stdUserForChangStatus= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForChangStatus.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForChangStatus.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card not inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForChangStatus);
        System.runAs(stdUserForChangStatus) {
            insert projectList;
            project=projectList[0];
            
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project not inserted');//positive test
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForChangStatus,stdUserForChangStatus,stdUserForChangStatus});
            insert regionalRolloutList;
            regionalRolloutList[0].IPM_Regional_PL__c=stdUserForChangStatus.Id;
            regionalRolloutList[0].Target_Launch_Date__c=null;
            regionalRolloutList[0].IPM_Project__c=project.Id;
            update regionalRolloutList;
            List<IPM_Project_Rollout__c> proRegListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:regionalRolloutList[0].ID LIMIT 1];
            System.assertEquals(proRegListObj[0].IPM_Rollout_Span__c,REGIONAL_STR,'regional rollout not created');//positive test
            
            
           
        }
    }

    /*************************************************************************************************************************
    * @description Test Data
    */
    static void initializeTestMethodData(){    
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        System.runAs(globalUser){ 
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name,IPM_Project__c,IPM_Active__c from IPM_Milestones__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            project.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
            update project; 
            List<IPM_Project__c>projList=[select Id,IPM_GateKeeping_Model__c,IPM_Project_Type__c,Name from IPM_Project__c where Id=:project.Id];
            System.assertEquals(projList[0].IPM_GateKeeping_Model__c,IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT,'project not updated');          
            
            regProject= IPM_TestFactory_Helper.createIPMProject(FALSE);
            regProject.Name='regional project';
            regProject.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            regProject.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            insert regProject;
            List<IPM_Project__c>regProList=[select Id,IPM_Project_Type__c,Name from IPM_Project__c where Id=:regProject.Id];
            System.assertEquals(regProList[0].IPM_Project_Type__c,IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,'regional project not created');
            
            for(IPM_Project__c projectObj : projectListObj){
                projDocList = projectObj.Project_Documents__r;
                mileListObj = projectObj.IPM_Milestones__r;
                system.assertEquals(projDocList[0].IPM_GateDocuments__c,'Charter','Project Document not created'); 
            }
            
            IPM_Project_Document_Section__c projectDocSec = new IPM_Project_Document_Section__c();
            projectDocSec.IPM_Project_Document__c = projDocList[0].Id;
            projectDocSec.IPM_Negotiable__c = true;
            projectDocSec.IPM_Default_Section__c = true;
            insert projectDocSec;
            
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Negotiable__c,IPM_Default_Section__c,IPM_Section_Sequence__c,IPM_Project_Document__c,IPM_Section__r.External_ID__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id,'Project Document Sections not created');
            
            
            gateCMICountry=new IPM_Gate_CMI__c();
            gateCMICountry.IPM_Project__c = project.Id;
            
            gateCMICountry.IPM_Skip_Test__c=false;
            
            insert gateCMICountry;
            List<IPM_Gate_CMI__c>cmicounList=[select Results__c,IPM_Skip_Test__c from IPM_Gate_CMI__c where Id=:gateCMICountry.Id];
            System.assertEquals(cmicounList[0].IPM_Skip_Test__c,false,'cmi not created');
            
            projectDocSecConListObj = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projectDocSecConListObj.IPM_Project_Document_Section__c = projectDocSecListObj[0].ID;
            projectDocSecConListObj.IPM_CMI_Is_Free_Text__c=false;
            projectDocSecConListObj.IPM_CMI_Result__c=RESULT_STR;
            insert projectDocSecConListObj;
            
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_CMI_Is_Free_Text__c,IPM_CMI_Result__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecConListObj.Id];
            System.assertEquals(conList[0].IPM_CMI_Result__c,RESULT_STR,'content not created');
            
            
            mileListObj[0].IPM_Type_of_Milestone__c= IPM_ConstantUtils.STANDARD;
            mileListObj[0].IPM_Active__c=true;
            mileListObj[0].IPM_Phase__c='Ideas';
            mileListObj[0].IPM_Due_Date__c=null;
            update mileListObj[0];
            List<IPM_Milestone__c>mileList1=[select Id,IPM_Active__c,IPM_Due_Date__c from IPM_Milestone__c where Id=:mileListObj[0].Id];
            System.assert(mileList1[0].IPM_Active__c,'milestones not updated');
            
            List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where NAME='Test Local Company Card' limit 1];
            //regional project and local project creation
            childProj=new IPM_Project__c();
            childProj.IPM_Parent_Project__c=project.id;
            childProj.IPM_Project_Name__c=project.Name+'_Name';
            childProj.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            childProj.IPM_Target_Launch_Dates__c=system.today();
            childProj.IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
            childProj.IPM_Company_Card__c=comList[0].id;
            childProj.IPM_CompanyCardText__c=GLOBALCOMPANY_CARD_STR;
            childProj.IPM_ProjectSubType__c=INNOVATIONRENO_STR;
            childProj.IPM_Project_Type__c=ROLLOUT_STR;
            childProj.IPM_GateKeeping_Model__c=RCLT_STR;
            childProj.IPM_Complexity__c=LITE_STR;
            childProj.IPM_Temporary_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
            childProj.IPM_ProjectJobType__c=PROJECT_CREATION_STR;
            childProj.IPM_Project_Job_Status__c=PROJECT_STATUS_STR;
            childProj.IPM_Category_Text__c=PROJECT_CATEGORY_STR;
            insert childProj;
            list<IPM_Project__c>lstLocalProj=[SELECT IPM_Category_Text__c FROM IPM_Project__c WHERE ID=:childProj.ID LIMIT 1];
          System.assertEquals(lstLocalProj[0].IPM_Category_Text__c,PROJECT_CATEGORY_STR,'Project category is'+lstLocalProj[0].IPM_Category_Text__c);
            childProjs=new IPM_Project__c();
            childProjs.IPM_Parent_Project__c=childProj.id;
            childProjs.IPM_Project_Name__c=project.Name+'_Names';
            childProjs.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            childProjs.Rollout_Plan_Target_Launch_Date__c=system.today().addDays(4);
            childProjs.IPM_Target_Launch_Dates__c=system.today().addDays(1);
            childProjs.IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
            childProjs.IPM_Company_Card__c=comList[0].id;
            childProjs.IPM_CompanyCardText__c=GLOBALCOMPANY_CARD_STR;
            childProjs.IPM_ProjectSubType__c=INNOVATIONRENO_STR;
            childProjs.IPM_Project_Type__c=ROLLOUT_STR;
            childProjs.IPM_GateKeeping_Model__c=RCLT_STR;
            childProjs.IPM_Complexity__c=LITE_STR;
            childProjs.IPM_Temporary_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
            childProjs.IPM_ProjectJobType__c=PROJECT_CREATION_STR;
            childProjs.IPM_Project_Job_Status__c=PROJECT_STATUS_STR;
            childProjs.IPM_Category_Text__c=PROJECT_CATEGORY_STR;
            insert childProjs;
            list<IPM_Project__c>lstLocalProjs=[SELECT IPM_Category_Text__c FROM IPM_Project__c WHERE ID=:childProjs.ID LIMIT 1];
          System.assertEquals(lstLocalProjs[0].IPM_Category_Text__c,PROJECT_CATEGORY_STR,'Project category is:'+lstLocalProjs[0].IPM_Category_Text__c);
            //create local financial
            Id LOCAL_FIN_RECTYPE = Schema.SObjectType.IPM_Financial__c.RecordTypeInfosByName.get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).RecordTypeId;
        localFin=new IPM_Financial__c();
        localFin.Local_Project__c=childProjs.id;
        localFin.IPM_Business_Case_Confirmed__c=false;
      localFin.Is_BC_Confirmed_Capability__c=false;
      localFin.recordTypeId =LOCAL_FIN_RECTYPE;
        localFin.Target_Launch_Date__c=system.today();
        localFin.Financial_External_ID__c=project.Name+'Names';
        localFin.Volume_Unit_Local__c='Total 000 Units';
        insert localFin;
        list<IPM_Financial__c>lstLocalFin=[SELECT Local_Project__c FROM IPM_Financial__c WHERE ID=:localFin.ID LIMIT 1];
          System.assertEquals(lstLocalFin[0].Local_Project__c,childProjs.id,'Financial local project is'+lstLocalFin[0].Local_Project__c);
            pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('id', projectListObj[0].Id);
            Test.setCurrentPage(pRef);
            chngPro=new IPM_ChangProjectDocumentStatusController();
            
        }  

    }
    /****************************************************************************************
    *@Description:below test method is used to test local rollout functionality.
    * example:if local project BB document is not confirmed and regional PL try to propose gate document
                     then Pl will get page meesage and he/she is not able to propose gate document.
    *****************************************************************************************/
    static testMethod void testgetLocalProjectDetails(){
       test.startTest();
       initializeTestMethodData();
       test.stopTest();
       
        system.runAs(globalUser){
              childProj.IPM_Project_Type__c=ROLLOUT_STR;
              childProjs.IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
              update childProjs;
              list<ipm_project__c>localProjectList=[SELECT IPM_Phase__c FROM ipm_project__c WHERE id=:childProjs.id LIMIT 1];
              system.assertEquals(localProjectList[0].IPM_Phase__c,IPM_ConstantUtils.PHASE_FEASIBILITY,'regional project phase is not feasibility');
              chngPro.project=childProj;
              chngPro.projectId=childProj.id;
              chngPro.showValidation=true;
              chngPro.getLocalProjectDetails(); 
              system.assertEquals(chngPro.showValidation,false,ERRORONPAGE_STR);//positive test
              
              childProj.IPM_Phase__c=IPM_ConstantUtils.PHASE_CAPABILITY;
              childProjs.IPM_Phase__c=IPM_ConstantUtils.PHASE_CAPABILITY;
              update childProjs;
             
              list<ipm_project__c>localProjectsList=[SELECT IPM_Phase__c FROM ipm_project__c WHERE id=:childProjs.id LIMIT 1];
              system.assertEquals(localProjectsList[0].IPM_Phase__c,IPM_ConstantUtils.PHASE_CAPABILITY,'LOCAL project phase is not capability');
              chngPro.showValidation=true;
              chngPro.getLocalProjectDetails();
              system.assertEquals(chngPro.showValidation,false,ERRORONPAGE_STR);//positive test
              localFin.IPM_Business_Case_Confirmed__c=true;
              localFin.Is_BC_Confirmed_Capability__c=true;
              update localFin;
              list<ipm_financial__c>localFinList=[SELECT IPM_Business_Case_Confirmed__c FROM ipm_financial__c WHERE id=:localFin.id LIMIT 1];
              system.assertEquals(localFinList[0].IPM_Business_Case_Confirmed__c,true,'business case is not confirmed');
              IPM_FinancialController finController=new IPM_FinancialController();
              finController.project=childProjs;
              finController.currentFinancial=localFin;
              finController.isTargetLaunchDateMisaligned=true;
              finController.localProjectConditions();
              system.assertEquals(finController.tldAcceptFromValue==null,false,'Tld date text should not be empty');//positive test
              
        }
              
    }
    static testMethod void dotestNotStarted(){
    	test.startTest();
        initializeTestMethodData();
        test.stopTest();
        system.runAs(globalUser){
            
            chngPro.milestoneError=false;
            chngPro.riskError=false;
            chngPro.rolloutNotExistsError=false;
            chngPro.rolloutRegionalPLFilledError=false;
            chngPro.rolloutCountryPLFilledError=false;
            chngPro.ecoDesignNoAssessmentError=false;
            chngPro.projectDoc=projDocList[0];
            chngPro.isRiskComplete=false;
           
            chngPro.financialError=false;
            chngPro.showValidation=true;
            chngPro.associatedProjectType=proType;
            secOpt=chngPro.getContractApprovers();
            chngPro.Status=IPM_ConstantUtils.STATUS_NOT_STARTED;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            chngPro.updateStatus();
            update projDocList;
            docListObj=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_NOT_STARTED,STATUS_NOT_CHANGED_STR);
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where IPM_Project__c=:chngPro.projectId];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_NOT_STARTED,STATUS_NOT_MATCHED_STR);
            
        }
    }
    
    
    
    
    static testMethod void dotestInProgress(){
    	test.startTest();
        initializeTestMethodData();
        test.stopTest();
        system.runAs(globalUser){
            chngPro.Status=IPM_ConstantUtils.STATUS_IN_PROGRESS;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList[0];
            docListObj=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS,STATUS_NOT_CHANGED_STR);
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where IPM_Project__c=:chngPro.projectId];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS,STATUS_NOT_MATCHED_STR);
         
            
        }
    }
    
    
    static testMethod void dotestStopped(){
        test.startTest();
        initializeTestMethodData();
        test.stopTest();
        system.runAs(globalUser){
            chngPro.projectDoc=projDocList[0];
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            projDocList[0].IPM_Stopped_Comments__c='abc';
            update projDocList;
            docList=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED,STATUS_NOT_CHANGED_STR);
            chngPro.submit();
            projDocList[0].IPM_Stopped_Comments__c='';
            update  projDocList;
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED,STATUS_NOT_MATCHED_STR);
            chngPro.project.Name=INVALID_NAME;
            chngPro.projectDoc.IPM_Stopped_Comments__c='testcomments';
            chngPro.stopProject();
            
        }
    }
    
    static testMethod void dotestApproveWithEdits(){
        test.startTest();
        initializeTestMethodData();
        test.stopTest();
        system.runAs(globalUser){
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList;
            docList=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS,STATUS_NOT_CHANGED_STR);
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS,STATUS_NOT_MATCHED_STR);
            chngPro.project.Name=INVALID_NAME;
            chngPro.approvedWithEditsProject();
        }
    }
    
    static testMethod void dotestPostponed(){
    	test.startTest();
    	initializeTestMethodData();
        test.stopTest();
        
        system.runAs(globalUser){
	    projDocList[0].IPM_Postponed_Comments__c='abc';
            projDocList[0].IPM_Postponement_Date__c=system.today();
            update projDocList;
            docList=[select IPM_Postponement_Date__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Postponement_Date__c,system.today(),'date changed');
            chngPro.projectDoc=projDocList[0];
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList;
            docList=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED,STATUS_NOT_CHANGED_STR);
            projDocList[0].IPM_Postponement_Date__c=system.today().addDays(7); 
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED,STATUS_NOT_MATCHED_STR);
            chngPro.project.Name=INVALID_NAME;
            
            chngPro.postponeProject();
            
            // To test validation when No comments is added 
            projDocList[0].IPM_Postponed_Comments__c= '';
            projDocList[0].IPM_Postponement_Date__c = system.today();
            update projDocList;
            chngPro.postponeProject();
        }
    }
    
    static testMethod void dotestPropose(){
        test.startTest();
    	initializeTestMethodData();
        test.stopTest();
        
        system.runAs(globalUser){
            
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED;
           
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList;
            docListObj=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED,STATUS_NOT_CHANGED_STR);
            
            chngPro.projSectionList = projectDocSecListObj;
            chngPro.submit();
            
            chngPro.project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED,STATUS_NOT_MATCHED_STR);
            chngPro.showValidation=true;
            chngPro.proposeProject();
            chngPro.project.Name=INVALID_NAME;
            chngPro.proposeProject();
        }
    }
    
    static testMethod void dotestPropose1(){
        test.startTest();
    	initializeTestMethodData();
        test.stopTest();
        system.runAs(globalUser){
            
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED;
           
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList;
            docListObj=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED,STATUS_NOT_CHANGED_STR);
            
            chngPro.project.IPM_GateKeeping_Model__c =IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            
            chngPro.submit();
            mileListObj[0].IPM_Due_Date__c=System.today();
            update mileListObj[0];
            chngPro.submit();
            
            chngPro.project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            chngPro.project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            chngPro.validateRolloutAndFin();
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED,STATUS_NOT_MATCHED_STR);
            
        }
    }
    static testMethod void dotestApprove(){
    	test.startTest();
    	initializeTestMethodData();
        test.stopTest();
        system.runAs(globalUser){
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            secOpt=chngPro.getcomplexities();
            update projDocList;
            docList=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED,STATUS_NOT_CHANGED_STR);
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED,STATUS_NOT_MATCHED_STR);
            chngPro.project.Name=INVALID_NAME;
            chngPro.approveProject();
        }
    }
}