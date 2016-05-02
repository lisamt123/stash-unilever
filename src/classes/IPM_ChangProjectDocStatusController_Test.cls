/******************************************************************************************************************************
* @author Cognizant 
* @date 15/12/2014
* @description Test Class for Chante Project Document Status Controller. This is when the Project Leader Approves a Document
	Lots of valdations needs to be fullfilled hence there are many fields in this test class
*/
@isTest
public class  IPM_ChangProjectDocStatusController_Test {
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
    private static final string STATUS_MATCHED_STR='status matched';// assert statements
    private static final string STATUS_CHANGED_STR='status changed';// assert statements
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
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForChangStatus);
        System.runAs(stdUserForChangStatus) {
            insert projectList;
            project=projectList[0];
            
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project inserted');//positive test
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForChangStatus,stdUserForChangStatus,stdUserForChangStatus});
            insert regionalRolloutList;
            regionalRolloutList[0].IPM_Regional_PL__c=stdUserForChangStatus.Id;
            regionalRolloutList[0].Target_Launch_Date__c=null;
            regionalRolloutList[0].IPM_Project__c=project.Id;
            update regionalRolloutList;
            List<IPM_Project_Rollout__c> proRegListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:regionalRolloutList[0].ID LIMIT 1];
            System.assertEquals(proRegListObj[0].IPM_Rollout_Span__c,REGIONAL_STR,'regional rollout created');//positive test
            
            
           
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
                system.assertEquals(projDocList[0].IPM_GateDocuments__c,'Charter','Project Document created'); 
            }
            
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
            
            
            gateCMICountry=new IPM_Gate_CMI__c();
            gateCMICountry.IPM_Project__c = project.Id;
            
            gateCMICountry.IPM_Skip_Test__c=false;
            
            insert gateCMICountry;
            List<IPM_Gate_CMI__c>cmicounList=[select Results__c,IPM_Skip_Test__c from IPM_Gate_CMI__c where Id=:gateCMICountry.Id];
            System.assertEquals(cmicounList[0].IPM_Skip_Test__c,false,'cmi created');
            
            projectDocSecConListObj = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projectDocSecConListObj.IPM_Project_Document_Section__c = projectDocSecListObj[0].ID;
            projectDocSecConListObj.IPM_CMI_Is_Free_Text__c=false;
            projectDocSecConListObj.IPM_CMI_Result__c=RESULT_STR;
            insert projectDocSecConListObj;
            
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_CMI_Is_Free_Text__c,IPM_CMI_Result__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecConListObj.Id];
            System.assertEquals(conList[0].IPM_CMI_Result__c,RESULT_STR,'content created');
            
            
            mileListObj[0].IPM_Type_of_Milestone__c= IPM_ConstantUtils.STANDARD;
            mileListObj[0].IPM_Active__c=true;
            mileListObj[0].IPM_Phase__c='Ideas';
            mileListObj[0].IPM_Due_Date__c=null;
            update mileListObj[0];
            List<IPM_Milestone__c>mileList1=[select Id,IPM_Active__c,IPM_Due_Date__c from IPM_Milestone__c where Id=:mileListObj[0].Id];
            System.assert(mileList1[0].IPM_Active__c,'milestones not updated');
            
            pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('id', projectListObj[0].Id);
            Test.setCurrentPage(pRef);
            chngPro=new IPM_ChangProjectDocumentStatusController();
            
        }  

    }
    
    static testMethod void dotestNotStarted(){
        initializeTestMethodData();
        test.startTest();
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
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_NOT_STARTED,STATUS_CHANGED_STR);
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where IPM_Project__c=:chngPro.projectId];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_NOT_STARTED,STATUS_MATCHED_STR);
            test.stopTest();
            
        }
    }
    
    
    
    
    static testMethod void dotestInProgress(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            chngPro.Status=IPM_ConstantUtils.STATUS_IN_PROGRESS;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList[0];
            docListObj=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS,STATUS_CHANGED_STR);
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where IPM_Project__c=:chngPro.projectId];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS,STATUS_MATCHED_STR);
            test.stopTest();
            
        }
    }
    
    
    static testMethod void dotestStopped(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            chngPro.projectDoc=projDocList[0];
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            projDocList[0].IPM_Stopped_Comments__c='abc';
            update projDocList;
            docList=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED,STATUS_CHANGED_STR);
            chngPro.submit();
            projDocList[0].IPM_Stopped_Comments__c='';
            update  projDocList;
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED,STATUS_MATCHED_STR);
            chngPro.project.Name=INVALID_NAME;
            chngPro.projectDoc.IPM_Stopped_Comments__c='testcomments';
            chngPro.stopProject();
            test.stopTest();
            
        }
    }
    
    static testMethod void dotestApproveWithEdits(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList;
            docList=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS,STATUS_CHANGED_STR);
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS,STATUS_MATCHED_STR);
            chngPro.project.Name=INVALID_NAME;
            chngPro.approvedWithEditsProject();
            test.stopTest();
            
        }
    }
    
    static testMethod void dotestPostponed(){
        initializeTestMethodData();
        test.startTest();
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
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED,STATUS_CHANGED_STR);
            projDocList[0].IPM_Postponement_Date__c=system.today().addDays(7); 
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED,STATUS_MATCHED_STR);
            chngPro.project.Name=INVALID_NAME;
            chngPro.postponeProject();
            test.stopTest();
            
        }
    }
    
    static testMethod void dotestPropose(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED;
           
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList;
            docListObj=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED,STATUS_CHANGED_STR);
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED,STATUS_MATCHED_STR);
            chngPro.showValidation=true;
            chngPro.proposeProject();
            chngPro.project.Name=INVALID_NAME;
            chngPro.proposeProject();
           test.stopTest();
            
        }
    }
    
    static testMethod void dotestPropose1(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED;
           
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList;
            docListObj=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED,STATUS_CHANGED_STR);
            
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
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED,STATUS_MATCHED_STR);
       test.stopTest();
            
        }
    }
    static testMethod void dotestApprove(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            secOpt=chngPro.getcomplexities();
            update projDocList;
            docList=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED,STATUS_CHANGED_STR);
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED,STATUS_MATCHED_STR);
            chngPro.project.Name=INVALID_NAME;
            chngPro.approveProject();
            test.stopTest();
        }
    }
}