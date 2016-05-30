/**
* @author       Cognizant 
* @date         15/04/2015
* @description  This class is used to test the functionality of IPM_FileUploadController class 
*/
@isTest
private class IPM_FinGateController_Test {
    private static IPM_Project__c project;    
    private static User stdUserForFinGate;
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static final string LOCAL_STR='Local';
    private static final string REGIONAL_STR='Regional';
    private static List<IPM_Country__c>countryList=new List<IPM_Country__c>();
    private static User globalUser;
    private static IPM_FinGateController finGate;
    private static PageReference  pRef;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<MDO_Geography__c> mdoGeoList=new List<MDO_Geography__c>();
    private static final string PROJECT_DOC_NOT_CREATED='Project Document not created';
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup 
	static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForFinGate= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForFinGate.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForFinGate.id,'user not inserted properly');//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card not inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForFinGate);
        System.runAs(stdUserForFinGate) {
            insert projectList;
            
            project=projectList[0];
            project.Name='ProChgStatus';
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'Projects not created properly.');//positive test
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForFinGate,stdUserForFinGate,stdUserForFinGate});
            insert regionalRolloutList;
            List<IPM_Project_Rollout__c> proRegListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:regionalRolloutList[0].ID LIMIT 1];
            System.assertEquals(proRegListObj[0].IPM_Rollout_Span__c,REGIONAL_STR,'regional rollout not created');//positive test
            
            Map<Id,List<IPM_Project_Rollout__c>> projectToRolloutMap = new Map<Id,List<IPM_Project_Rollout__c>>();
            for(IPM_Project_Rollout__c projectRollout : regionalRolloutList)
            {
                List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
                if(projectToRolloutMap.containsKey(projectRollout.IPM_Project__c))
                {
                    projectRolloutList = projectToRolloutMap.get(projectRollout.IPM_Project__c);
                }
                projectRolloutList.add(projectRollout);
                projectToRolloutMap.put(projectRollout.IPM_Project__c,projectRolloutList);
                
            }
            
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{stdUserForFinGate});  
            
            insert localRolloutList; 
            
            List<IPM_Project_Rollout__c> proLocListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:localRolloutList[0].ID LIMIT 1];
            System.assertEquals(proLocListObj[0].IPM_Rollout_Span__c,LOCAL_STR,'local rollout not created');//positive test
            
            
            
            // Create Country specific information.
           String geoExternalId = '';
            for(IPM_Project_Rollout__c localRolloutObj : localRolloutList)
            {
                
                if(localRolloutObj.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AG';
                }
                else if(localRolloutObj.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BR';
                }
                
                MDO_Geography__c mdo = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId); 
                mdoGeoList.add(mdo);    
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo.id,
                IPM_Project__c = localRolloutObj.IPM_Project__c,local_Rollout__c = localRolloutObj.Id,IPM_Rollout_Status__c = 'With MCO');    
                countryList.add(tempCountry);
            }
            
                    
             insert mdoGeoList;
             List<MDO_Geography__c>mdoList=[select Id from MDO_Geography__c where id=:mdoGeoList[0].Id limit 1];
             system.assertNotEquals(mdoList[0].Id,null,'mdo not created');   
            
             insert countryList;
            
            List<IPM_Country__c>counList=[select Id,IPM_Rollout_Status__c from IPM_Country__c where Id=:countryList[0].Id limit 1];
            system.assertEquals(counList[0].IPM_Rollout_Status__c,'With MCO','country not inserted');
        }
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    public static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        system.runAs(globalUser){
            List<IPM_Project__c>projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            List<IPM_Project__c>projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            System.assertEquals(projlList[0].Name,TEST_COMMENTS_STR,'project not created');//positive test
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_NOT_CREATED);
            }
            finGate=new IPM_FinGateController();
            pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('id', projectListObj[0].Id);
            pRef.getParameters().put('printDoc', IPM_ConstantUtils.CHARTER_GATE);
            Test.setCurrentPage(pRef);
        }
    }

    /*******************************************************************************************************
    * @description  Test Method to test IPM_FinGateController methods
    */
    static testMethod void runFinGateTest(){
        initializeTestMethodData();
        system.runAs(globalUser){
            test.startTest();
            finGate.projectId=project.ID;
            finGate.financialsCalendar= new IPM_FinancialWrapper();
            finGate.financialsInnovation= new IPM_FinancialWrapper();
            finGate.setprojectId(project.ID);
            List<IPM_Project__c>projctList = [SELECT Id,Name,IPM_Project_Name__c, Sustainability_Period__c, IPMProject_Span__c, Market_Cluster__c, Market_Cluster_Name__c, IPM_Parent_Project__c, 
                              IPM_Project_Type__c, IPM_Phase__c FROM IPM_Project__C  WHERE Id=:finGate.projectId];
            System.assertEquals(projctList[0].Name,TEST_COMMENTS_STR,'Financial not generated properly');
            System.assertEquals(projctList[0].Sustainability_Period__c,String.valueOf(finGate.sustainabilityPeriod),'Financial not generated properly');
            System.assertEquals(projctList[0].IPMProject_Span__c,finGate.fieldSuffix,'Financial not generated properly');
            System.assertEquals(projctList[0].IPMProject_Span__c,finGate.fieldSuffix,'Financial not generated properly');
            test.stopTest();
        }
    }
    
    
}