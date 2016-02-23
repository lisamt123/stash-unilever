/******************************************************************************************************************************
* @author Cognizant 
* @date 15/12/2014
* @description Test Class for Gate Document Controller
*/
@isTest
public class  IPM_ChangProjectDocStatusController_Test {
    public static PageReference  pRef;
    public static IPM_Project__c project;// Project object initialization
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    public static List<SelectOption> secOpt=new List<SelectOption>();
    public static IPM_Project_Type__c proType;
    private static final string TEST_COMMENTS_STR='TestComments1';
    public static List<IPM_Milestone__c>mileListObj;
    public static List<IPM_Project_Document__c>docStatus;
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static User stdUserForChangStatus;
    private static final string STATUS_MATCHED_STR='status matched';
    private static final string STATUS_CHANGED_STR='status changed';
    public static User globalUser;
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
            
        }
    }

    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeTestMethodData(){    
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        System.runAs(globalUser){ 
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name,IPM_Project__c,IPM_Active__c from IPM_Milestones__r)
            from IPM_Project__c where Name in:projectNameSet];
           project=projectListObj[0];
         
            for(IPM_Project__c projectObj : projectListObj){
                projDocList = projectObj.Project_Documents__r;
                mileListObj = projectObj.IPM_Milestones__r;
                system.assertEquals(projDocList[0].IPM_GateDocuments__c,'Charter','Project Document created'); 
            }
            pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('id', projectListObj[0].Id);
            Test.setCurrentPage(pRef);
        }  

    }
    
    static testMethod void dotestSubmit(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            projDocList[0].IPM_Stopped_Comments__c='';
            projDocList[0].IPM_Postponed_Comments__c='abc';
            projDocList[0].IPM_Postponement_Date__c=system.today();
            update projDocList;
            List<IPM_Project_Document__c>docList=[select IPM_Postponement_Date__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Postponement_Date__c,system.today(),'date changed');
            
            IPM_ChangProjectDocumentStatusController chngPro=new IPM_ChangProjectDocumentStatusController();
            chngPro.cmiError=false;
            chngPro.milestoneError=false;
            chngPro.riskError=false;
            chngPro.rolloutNotExistsError=false;
            chngPro.rolloutRegionalPLFilledError=false;
            chngPro.rolloutCountryPLFilledError=false;
            chngPro.ecoDesignNoAssessmentError=false;
            chngPro.projectDoc=projDocList[0];
            chngPro.isRiskComplete=false;
            chngPro.isCmiComplete=false;
            chngPro.financialError=false;
            chngPro.showValidation=true;
            chngPro.associatedProjectType=proType;
            secOpt=chngPro.getContractApprovers();
            chngPro.Status=IPM_ConstantUtils.STATUS_NOT_STARTED;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            chngPro.updateStatus();
            update projDocList;
            List<IPM_Project_Document__c>docListObj=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_NOT_STARTED,STATUS_CHANGED_STR);
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where IPM_Project__c=:chngPro.projectId];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_NOT_STARTED,STATUS_MATCHED_STR);
            
            chngPro.Status=IPM_ConstantUtils.STATUS_IN_PROGRESS;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList[0];
            docListObj=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS,STATUS_CHANGED_STR);
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where IPM_Project__c=:chngPro.projectId];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS,STATUS_MATCHED_STR);
            
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList;
            docListObj=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docListObj[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED,STATUS_CHANGED_STR);
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED,STATUS_MATCHED_STR);
            
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList;
            docList=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED,STATUS_CHANGED_STR);
            
            projDocList[0].IPM_Stopped_Comments__c='abc';
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED,STATUS_MATCHED_STR);
            
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            update projDocList;
            docList=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS,STATUS_CHANGED_STR);
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS,STATUS_MATCHED_STR);
            
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
            
            chngPro.Status=IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED;
            projDocList[0].IPM_Document_Status__c=chngPro.Status;
            secOpt=chngPro.getcomplexities();
            update projDocList;
            docList=[select IPM_Document_Status__c from IPM_Project_Document__c where Id=:projDocList[0].Id];
            System.assertEquals(docList[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED,STATUS_CHANGED_STR);
            
            chngPro.submit();
            docStatus=[select IPM_Document_Status__c from IPM_Project_Document__c 
            where Id=:projDocList[0].Id];
            System.assertEquals(docStatus[0].IPM_Document_Status__c,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS,STATUS_MATCHED_STR);
            
            test.stopTest();
            
        }
    }
    

}