/*************************************************************
*@Author:Cognizant
*@Date:October 2014
*@Description : To test IPM_CMIGateSectionController class
*************************************************************/

@isTest
private class IPM_CMIGateSectionController_Test {
    
    public static IPM_Project__c project;// Project object initialization
    private static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    private static PageReference pRef;
    private static User stdUserForCMIGATE;
    private static IPM_Gate_CMI__c gateCmi;
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static IPM_Project_Document_Section_Content__c projDocSecCon;
    private static IPM_CMIGateSectionController ipmCmiCon;
    private static User globalUser;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    private static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    private static final String ASSERT_ERROR_STR = 'Projects not Created Properly.Actual size should be ';
    private static final String EMPTY_STRING=''; 
    private static List<Id> globalProjectIdList = new List<Id>();
    
    Public static user globalProjectLeader;
    Public static user regionalProjectLeader;
    Public static user localProjectLeader;
      
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        
        
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
             globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(EMPTY_STRING);
            regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(EMPTY_STRING);
            localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(EMPTY_STRING);
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = 'GLOBAL_PL';
            regionalProjectLeader.lastname = 'REGIONAL_PL';
            localProjectLeader.lastname = 'LOCAL_PL'; 
            
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;
            
            
         
            List<User> dbUserList =  [Select Id from User where id in :userList];
            System.assertEquals(dbUserList.size(),userList.size(),'Users not Created Properly.Actual no of Users should be'+userList.size());
            
            stdUserForCMIGATE=IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForCMIGATE.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForCMIGATE.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForCMIGATE);
        System.runAs(stdUserForCMIGATE) {
            insert projectList;
            project=projectList[0];
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project name');//positive test
        }
    }
    
    
    /*************************************************************************************************************************
    * @description Test Data
    */
     static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        //Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        
        system.runAs(globalUser){
            List<IPM_Project__c>projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            List<IPM_Project__c>projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            
            System.assertEquals(projlList[0].id,project.id);//positive test
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
               System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
            
            gateCmi=IPM_TestFactory_Helper.createGateCMI(project.Id,false);
            gateCmi.IPM_Skip_Test__c=false;
            insert gateCmi;
            
            List<IPM_Gate_CMI__c> cmiObj=[SELECT ID,IPM_Skip_Test__c FROM IPM_Gate_CMI__c WHERE ID=:gateCmi.ID LIMIT 1];
            System.assertEquals(cmiObj[0].IPM_Skip_Test__c,false);//positive test
            
            projDocSecCon = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projDocSecCon.IPM_Project_Document_Section__c = projectDocSecListObj[0].ID;
            projDocSecCon.IPM_Content_Type__c=IPM_ConstantUtils.CMIGATE_CONTENT_TYPE;
            projDocSecCon.IPM_Gate_CMI__c=gateCmi.Id;
            
            insert projDocSecCon;
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projDocSecCon.Id];
            System.assertEquals(conList[0].IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE,'content not created');
            
           pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('Id', project.Id);
            Test.setCurrentPage(pRef);
            
            ipmCmiCon=new IPM_CMIGateSectionController();
        }
    }
            
    /*************************************************************************
    *@Description : to call  the method for IPM_CMIGateSectionController object 
            
    ***************************************************************************/
    static testMethod void dotest1(){
        initializeTestMethodData();
        Test.startTest();
         
        system.RunAs(globalUser){
        	Apexpages.currentpage().getparameters().put('secId',projectDocSecListObj[0].ID);
        	Id projDocSecId = ipmCmiCon.projDocSecId;
        	
        	Apexpages.currentpage().getparameters().put('projId',project.Id);
        	Id projectId = ipmCmiCon.projectId;
        	
        	Apexpages.currentpage().getparameters().put('gate','Charter');
        	String gateType = ipmCmiCon.gateType;
        	
            ipmCmiCon.projectId = project.Id;
            ipmCmiCon.projDocSecId=projectDocSecListObj[0].ID;
            ipmCmiCon.gateType='Charter';
            ipmCmiCon.showTableData();
            List<IPM_Project_Document_Section_Content__c> projectDocSecConObj=[select IPM_Content_Type__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ipmCmiCon.projDocSecId];
            system.assertEquals(projectDocSecConObj[0].IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE,'content type matched');
            Test.stopTest();
        }
    }
            
         static testMethod void dotest2(){
            initializeTestMethodData();
            Test.startTest();
            system.RunAs(globalUser){
            Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
            List<IPM_Project__c>projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            projectList = [SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c,IPM_Project_Name__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
                
                
           /******************************** Create Regional Rollouts for Created Global project ****************************************/
           
           List<User> userList =  [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
        
            for(User lUser  :userList)
            {
                if(lUser.lastName == 'GLOBAL_PL')
                {
                    globalProjectLeader = lUser;
                }
                if(lUser.lastName == 'REGIONAL_PL')
                {
                    regionalProjectLeader = lUser;
                }
            }
           
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            insert regionalRolloutList;
            
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
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
             
            insert localRolloutList; 
           
            List<IPM_Project_Rollout__c> dbRolloutList =  [Select Id from IPM_Project_Rollout__c where id in :localRolloutList];
            System.assertEquals(dbRolloutList.size(),localRolloutList.size(),ASSERT_ERROR_STR+localRolloutList.size());
            
            insertCountry(localRolloutList);
            
            /******************************** Initiate Phase Change and Regional Project Creation  ****************************************/
            List<IPM_Project_Document__c> projectDocumentList = new List<IPM_Project_Document__c>();
            
            // Already Added ProjectId's
            for(IPM_Project__c proj : projectList)
            {
                projectDocumentList.add(project.Project_Documents__r);
            }  
            
            
            //insertCMIRecords(projectList, projectDocumentList);
            insertCMIRecords(projectDocumentList);
            
            for(IPM_Project__c proj : projectList)
            {
                globalProjectIdList.add(project.Id);    
            }
            
            // Initiate Phase Change would result in Rollout Project Creation.
            List<IPM_Project__c> projectListPhaseChange = new List<IPM_Project__c>();
            projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
            
            update projectListPhaseChange;    
            
            Test.stopTest();
                
                
            ipmCmiCon.projectId=project.Id;
            ipmCmiCon.projDocSecId=projectDocSecListObj[0].ID;
            ipmCmiCon.gateType='Contract';
            ipmCmiCon.showTableData();
            List<IPM_Project_Document_Section_Content__c> projectDocSecConObj=[select IPM_Content_Type__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ipmCmiCon.projDocSecId];
            system.assertEquals(projectDocSecConObj[0].IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE,'content type matched');
            
       
        }
    }
    
    private static void insertCountry(List<IPM_Project_Rollout__c>  localRolloutList)
   	{
   		// Create Country specific information.
        List<IPM_Country__c> countryList= new List<IPM_Country__c>();
        
        List<String> iscodes = new List<String>{'AG','BR'}; 
        List<MDO_Geography__c> geoList =  new List<MDO_Geography__c>();
        Map<String,MDO_Geography__c> geoMap = new Map<String,MDO_Geography__c>();
        for(String isoCode : iscodes)
        {
            geoList.add(new MDO_Geography__c(ISO_3166_1_Code__c = isoCode));
        }
        insert geoList;
        
        System.assert(geoList[0].Id != null,'Geo not Created');
        for(MDO_Geography__c geoObj : geoList)
        {
            geoMap.put(geoObj.ISO_3166_1_Code__c,geoObj);
        }
        
        for(IPM_Project_Rollout__c localRollout : localRolloutList)
        {
            String geoExternalId = EMPTY_STRING;
            if(localRollout.IPM_Rollout_Project__c.contains('AF'))
            {
                geoExternalId = 'AG';
            }
            else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
            {
                geoExternalId = 'BR';
            }
            
            IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = geoMap.get(geoExternalId).Id,IPM_Project__c = localRollout.IPM_Project__c,
                local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',isActive__c = true);  
            
            countryList.add(tempCountry);
        }
        
        insert countryList;
        
   	}
   	
   	private static void insertCMIRecords(List<IPM_Project_Document__c> projectDocumentList)
	{
		IPM_ProjectDocumentSectionContentHandler.SKIP_TRIGGER_EXECUTION  = true;
        IPM_ProjectSectionContentHelper.SKIP_TRIGGER_EXECUTION = true;
        //Insert CMI Records. 
        Map<Id,IPM_Gate_CMI__c> projectSpecificCMIGates = new Map<Id,IPM_Gate_CMI__c>();
        List<IPM_Project_Document_Section__c> updatedDocumentSectionList = new List<IPM_Project_Document_Section__c>();
        String selectedCountry = 'AG';
        //Getting Gate CMI Test's and Corresponding KPI's
        Set<Id>  alreadyAddedProjectIds = new Set<Id>();
        
        Map<String,IPM_Gate_CMI_KPI_Inputs__c> testKPIMap=new Map<String,IPM_Gate_CMI_KPI_Inputs__c>();

        for(IPM_Gate_CMI_KPI_Inputs__c testKPI : IPM_Gate_CMI_KPI_Inputs__c.getall().values())
        {
            testKPIMap.put(testKPI.IPM_Test__c,testKPI);
        }
               
        for(IPM_Project_Document__c projectDocument : [SELECT ID,IPM_Project__c,( Select Id from IPM_Project_Sections__r LIMIT 10) from IPM_Project_Document__c where Id in :projectDocumentList])
        {
            if(!alreadyAddedProjectIds.contains(projectDocument.IPM_Project__c))
            {
                for(IPM_Project_Document_Section__c projectDocumentSection :  projectDocument.IPM_Project_Sections__r)
                {
                    String cmiName = 'Charter/Concept/Idea Screener - Nielsen'; 
                    String[] testValues = cmiName.split(IPM_ConstantUtils.Slash);
                    gateCMI = new IPM_Gate_CMI__c();
                    gateCMI.IPM_Project__c = projectDocument.IPM_Project__c;
                    gateCMI.gate__c = testValues[0];
                    gateCMI.Element__c = testValues[1];
                    gateCMI.Test__c = testValues[2];
                    gateCMI.IPM_CMI_Added_At__c = 'Charter';
                    gateCMI.Country__c = selectedCountry;
                    if(testKPIMap.get(gateCMI.Test__c)!=null)
                    {
                        gateCMI.KPI__c = testKPIMap.get(gateCMI.Test__c).IPM_KPI__c;
                        gateCMI.IPM_CMI_Overall_Colour_Score_Method__c= testKPIMap.get(gateCMI.Test__c).IPM_Overall_Colour_Score_Method__c;
                    }   
                    projectSpecificCMIGates.put(projectDocumentSection.Id,gateCMI);
                    projectDocumentSection.IPM_CMI_Selected_Test_Concepts__c = cmiName;
                    projectDocumentSection.IPM_Master_Section_External_Id__c = 'Mix_Qualification_Plan_and_Action_Standards';
                    projectDocumentSection.IPM_CMI_Selected_Countries__c = selectedCountry;
                    updatedDocumentSectionList.add(projectDocumentSection);
                } 
                alreadyAddedProjectIds.add(projectDocument.IPM_Project__c);
            }
        }
        
        insert projectSpecificCMIGates.values(); 
        update updatedDocumentSectionList;
            
        List<IPM_Project_Document_Section_Content__c> projDocSecConList = new List<IPM_Project_Document_Section_Content__c>();
             //Creating Gate CMI Content         
        for(Id projectDocSectionId : projectSpecificCMIGates.KeySet())
        {
            IPM_Gate_CMI_KPI_Inputs__c kpiInputs=new IPM_Gate_CMI_KPI_Inputs__c();
            IPM_Gate_CMI__c gateCMI1 = projectSpecificCMIGates.get(projectDocSectionId);
             //Getting KPI Inputs
            for(IPM_Gate_CMI_KPI_Inputs__c kpi:IPM_Gate_CMI_KPI_Inputs__c.getall().values())
            {
                if(kpi.IPM_Test__c == gateCMI1.Test__c && kpi.IPM_KPI__c == gateCMI1.KPI__c)
                {
                    kpiInputs=kpi;
                }
            }
            IPM_Project_Document_Section_Content__c projDocSecCon1 = new IPM_Project_Document_Section_Content__c();
            projDocSecCon1.IPM_Gate_CMI__c = gateCMI1.Id;
            projDocSecCon1.IPM_Content_Type__c = IPM_ConstantUtils.CMIGATE_CONTENT_TYPE;
            projDocSecCon1.IPM_CMI_Country__c = selectedCountry;
            projDocSecCon1.IPM_Country__c = selectedCountry;
            projDocSecCon1.IPM_CMI_Is_Free_Text__c = true;
            projDocSecCon1.IPM_CMI_Input__c = '1';
            projDocSecCon1.IPM_Project_Document_Section__c = projectDocSectionId;
            projDocSecCon1.IPM_CMI_Overall_Colour_Coding_Method__c= kpiInputs.IPM_Overall_Colour_Score_Method__c;
            projDocSecCon1.IPM_CMI_Overall_Score_Label__c=kpiInputs.IPM_Overall_Score_Label__c;
            projDocSecConList.add(projDocSecCon1);
        }
        
        insert  projDocSecConList;
        IPM_ProjectDocumentSectionContentHandler.SKIP_TRIGGER_EXECUTION  = false;
        IPM_ProjectSectionContentHelper.SKIP_TRIGGER_EXECUTION = false;
	}
   	

    static testMethod void dotest3(){
        initializeTestMethodData();
        Test.startTest();
         
        system.RunAs(globalUser){
            ipmCmiCon.projectId=project.Id;
            ipmCmiCon.projDocSecId=projectDocSecListObj[0].ID;
            ipmCmiCon.gateType='Market Ready';
            ipmCmiCon.showTableData();
            List<IPM_Project_Document_Section_Content__c> projectDocSecConObj=[select IPM_Content_Type__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ipmCmiCon.projDocSecId];
            system.assertEquals(projectDocSecConObj[0].IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE,'content type matched');
            Test.stopTest();
        }
    }
    
     static testMethod void dotest4(){
        initializeTestMethodData();
        Test.startTest();
         
        system.RunAs(globalUser){
            ipmCmiCon.projectId=project.Id;
            ipmCmiCon.projDocSecId=projectDocSecListObj[0].ID;
            ipmCmiCon.gateType='Market Deployment';
            ipmCmiCon.showTableData();
            List<IPM_Project_Document_Section_Content__c> projectDocSecConObj=[select IPM_Content_Type__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ipmCmiCon.projDocSecId];
            system.assertEquals(projectDocSecConObj[0].IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE,'content type matched');
            Test.stopTest();
        }
    }
    
}