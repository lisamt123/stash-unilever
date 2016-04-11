/****************************************************************************************************************************
*  @Author Cognizant
*  @name <Class name>
*  @CreateDate 16/09/2015
*  @Description Test Class for IPM_ProjectSectionContentHelper Class
*  @Version 1.0
*  @reference IPM_ProjectSectionContentHelper Class
*/
@isTest   
private class IPM_ProjectSectionContentHelper_Test {
    public static IPM_Project__c project;// Project object initialization
    
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    public static User stdUserForProSecContent;
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    private static final string TEST_COMMENTS_STR='TestComments1';
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static List<IPM_Project__c> projlList=new List<IPM_Project__c>();
    public static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    public static User globalUser;
    public static IPM_ProjectSectionContentHelper ipmProjSecConHelper;
    public static IPM_Project_Document_Section_Content__c projectDocSecContentObj=new IPM_Project_Document_Section_Content__c();
    private static string SECTION_UPDATE_STR='section not update';
    private static final string INDIA_STR='IND'; 
    public static IPM_Gate_CMI__c gateCMI;
    public static List<IPM_OTIF_Status__c> OTIFSettingList = new List<IPM_OTIF_Status__c>();    
    public static Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap=new Map<Id,List<IPM_Project_Document_Section__c>>();
    public static Map<Id,Map<String,IPM_Project_Document__c>> projectToDocumentMap=new Map<Id,Map<String,IPM_Project_Document__c>>();
    public static Map<Id,IPM_Project__c> projectMap=new Map<Id,IPM_Project__c>();
    public static IPM_OTIF_Status__c otifstatus=new IPM_OTIF_Status__c();
    public static Map<Id,List<IPM_Project_Document_Section__c>> docSecMap;
    public static Map<Id,Map<String,IPM_Project_Document__c>> docMap;
    public static Map<Id,IPM_Project__c> projMap;
    public static Map<String,IPM_Project_Document__c>docStringMap;
    public static IPM_Project__c ParentProject;// Project object initialization
    public static List<IPM_Country__c>countryList=new List<IPM_Country__c>();
    public static List<MDO_Geography__c> mdoGeoList=new List<MDO_Geography__c>();
    private static string LOCAL_STR='Local';
    private static string REGIONAL_STR='Regional';
    public static IPM_Country__c countryObj=new IPM_Country__c();
    public static List<IPM_Project_Document_Section__c>projectDocSecList=new List<IPM_Project_Document_Section__c>();
    private static string CONTENT_NOT_UPDATED_STR='content not updated';
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForProSecContent= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForProSecContent.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForProSecContent.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card not inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForProSecContent);
        System.runAs(stdUserForProSecContent) {
            insert projectList;
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectList[0].ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project not created');//positive test
            project=projectList[0];
            project.Name='ProChgStatus';
            
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForProSecContent,stdUserForProSecContent,stdUserForProSecContent});
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
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{stdUserForProSecContent});  
            
            insert localRolloutList; 
            
            List<IPM_Project_Rollout__c> proLocListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:localRolloutList[0].ID LIMIT 1];
            System.assertEquals(proLocListObj[0].IPM_Rollout_Span__c,LOCAL_STR,'local rollout not created');//positive test
            
            // Create Country specific information.
            
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
            countryObj=countryList[0];
        }
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    public static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        system.runAs(globalUser){
           
            ParentProject= IPM_TestFactory_Helper.createIPMProject(FALSE);
            ParentProject.Name='parent project';
            insert ParentProject;
            List<IPM_Project__c>parProjectList=[select Id,Name from IPM_Project__c where Id=:ParentProject.Id Limit 1];
            System.assertEquals(parProjectList[0].Name,'parent project','parent project not inserted');
            
            List<Id> globalProjectIdList = new List<Id>();
        
            projectListObj = [Select Id,IPM_Parent_Project__c,IPM_Bosscard__c,IPM_CompanyCardText__c,IPM_Project_Type__c,IPM_Phase__c, Name,IPM_GateKeeping_Model__c,IPMProject_Span__c,(Select Id,IPM_GateDocuments__c,IPM_Project__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r )
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            project.IPM_Parent_Project__c=ParentProject.Id;
            update project;
            
            List<IPM_Project__c>projectList1=[select IPM_Parent_Project__c from IPM_Project__c where Id=:project.Id Limit 1];
            System.assertEquals(projectList1[0].IPM_Parent_Project__c,ParentProject.Id,'project not updated');
            
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Type__c,IPM_Master_Section_External_Id__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
            projectDocSecListObj[0].IPM_Master_Section_External_Id__c = IPM_ConstantUtils.CMI_SECTION;
            update projectDocSecListObj;
            
            projectDocSecList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id Limit 1];
            System.assertEquals(projectDocSecList[0].IPM_Master_Section_External_Id__c,IPM_ConstantUtils.CMI_SECTION,SECTION_UPDATE_STR);
            
            projectDocSecContentObj = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projectDocSecContentObj.IPM_Project_Document_Section__c = projectDocSecListObj[0].ID;
            projectDocSecContentObj.IPM_Content_Type__c = IPM_ConstantUtils.CMIGATE_CONTENT_TYPE;
            
            insert projectDocSecContentObj;
            
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecContentObj.Id];
            System.assertEquals(conList[0].IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE,'content not created');
            otifstatus.Name ='Test5';
            otifstatus.IPM_Gate_Document_Type__c= IPM_ConstantUtils.CHARTER_GATE;
            insert otifstatus;
            List<IPM_OTIF_Status__c>otifLst=[select Id,IPM_Gate_Document_Type__c from IPM_OTIF_Status__c where Id=:otifstatus.Id];
            System.assertEquals(otifLst[0].IPM_Gate_Document_Type__c,IPM_ConstantUtils.CHARTER_GATE,'otif not created');
            gateCMI = IPM_TestFactory_Helper.createGateCMI(project.ID, false);
            gateCMI.IPM_Project__c = project.ID;
            gateCMI.Country__c=INDIA_STR;
            insert gateCMI;
            List<IPM_Gate_CMI__c>cmicounList=[select Results__c,Country__c from IPM_Gate_CMI__c where Id=:gateCMI.Id];
            System.assertEquals(cmicounList[0].Country__c,INDIA_STR,'cmi not created');           
            globalProjectIdList = new List<Id>();
            for(IPM_Project__c proj : projectListObj)
            {
              
                globalProjectIdList.add(proj.Id);    
            } 
                
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalUser); 
            update projectListPhaseChange;
            
            List<IPM_Project__c>projList=[select Id,IPM_Phase__c from IPM_Project__c where Id=:projectListPhaseChange[0].Id Limit 1];
            System.assertEquals(projList[0].IPM_Phase__c,'Ideas','phase not changed');
            
                
            ipmProjSecConHelper=new IPM_ProjectSectionContentHelper();
        }
    }

    /*
    * @Description Tests actual content
    */
    static testMethod void testcreateOTIFStatus() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            Test.startTest();
            IPM_ProjectHelper.gateToOTIFCustomSetting = IPM_Utils.getOTIFMapping();
            docSecMap=new map<Id,List<IPM_Project_Document_Section__c>>();
            docSecMap.put(projDocList[0].Id,projectDocSecListObj);
            docStringMap=new Map<String,IPM_Project_Document__c>(); 
            docStringMap.put(IPM_ConstantUtils.CHARTER_GATE,projDocList[0]);
            docMap=new Map<Id,Map<String,IPM_Project_Document__c>>();
            docMap.put(project.Id,docStringMap);
            projMap=new Map<Id,IPM_Project__c>();
            projMap.put(project.Id,project);            
            IPM_ProjectSectionContentHelper.createOTIFStatus(docSecMap,docMap,projMap);
            List<IPM_Project_Document_Section__c>sectionList=[select Id,IPM_Section_Name__c  from IPM_Project_Document_Section__c where IPM_Section_Name__c=:IPM_ConstantUtils.OTIF_STATUS OR IPM_Section_Name__c=:IPM_ConstantUtils.OTIF Limit 1];
            System.assertEquals(sectionList.size()>0,true,'otif section not created');
            Test.stopTest();
        }
    }
    /*************************************************************************************************************************
    * @description Test Data
    */
    
    static testMethod void testcreateFinancialActionStandard() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            Test.startTest();
            IPM_ProjectHelper.gateToOTIFCustomSetting = IPM_Utils.getOTIFMapping();
            docSecMap=new map<Id,List<IPM_Project_Document_Section__c>>();
            docSecMap.put(projDocList[0].Id,projectDocSecListObj);
            docStringMap=new Map<String,IPM_Project_Document__c>(); 
            docStringMap.put(IPM_ConstantUtils.CHARTER_GATE,projDocList[0]);
            docMap=new Map<Id,Map<String,IPM_Project_Document__c>>();
            docMap.put(project.Id,docStringMap);
            projMap=new Map<Id,IPM_Project__c>();
            projMap.put(project.Id,project);
            IPM_ProjectHelper.initializeProjectDetail(projMap);
            IPM_ProjectSectionContentHelper.createFinancialActionStandard(docSecMap,docMap, projMap);
            List<IPM_Project_Document_Section_Content__c>conListObj=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where IPM_Content_Type__c=:IPM_ConstantUtils.FINANCIAL_ACTION_STANDARDS];
            System.assertEquals(conListObj[0].IPM_Content_Type__c,IPM_ConstantUtils.FINANCIAL_ACTION_STANDARDS,'financial content not created');
            Test.stopTest();
        }
    }
    /*************************************************************************************************************************
    * @description Test Data
    */
    static testMethod void testmanageCMISections() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            Test.startTest();
            IPM_ProjectHelper.gateToOTIFCustomSetting = IPM_Utils.getOTIFMapping();          
            docSecMap=new map<Id,List<IPM_Project_Document_Section__c>>();
            docSecMap.put(projDocList[0].Id,projectDocSecListObj);           
            docStringMap=new Map<String,IPM_Project_Document__c>(); 
            docStringMap.put(IPM_ConstantUtils.CHARTER_GATE,projDocList[0]);           
            docMap=new Map<Id,Map<String,IPM_Project_Document__c>>();
            docMap.put(project.Id,docStringMap);
            projMap=new Map<Id,IPM_Project__c>();
            projMap.put(project.Id,project);            
            IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap = docSecMap;        
            IPM_Project_Document_Section_Content__c tempProjDocSecCon = new IPM_Project_Document_Section_Content__c();
            tempProjDocSecCon = projectDocSecContentObj;
            tempProjDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.CMIGATE_CONTENT_TYPE;          
            IPM_ProjectHelper.DBprojectSectionSpecificContentMap.put(projectDocSecListObj[0].ID, new List<IPM_Project_Document_Section_Content__c>{projectDocSecContentObj, tempProjDocSecCon });
            IPM_ProjectHelper.DBprojectSpecificCMIGateMap.put(projMap.values()[0].ID, new List<IPM_Gate_CMI__c>{gateCMI});
            IPM_ProjectHelper.initializeProjectDetail(projMap); 
            IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap = docSecMap;           
            IPM_ProjectHelper.DBprojectSpecificDocumentMap.put(projMap.values()[0].ID, projDocList);           
            IPM_ProjectHelper.projectMasterMap.put(project.IPM_Parent_Project__c, project);
            IPM_ProjectHelper.projectMasterMap.put(ParentProject.Id,ParentProject);
            Map<String,IPM_Country__c>countryMap=new Map<String,IPM_Country__c>();
            countryMap.put(INDIA_STR,countryObj);
            IPM_ProjectHelper.projectToCountryMap.put(project.Id,countryMap);
            IPM_ProjectHelper.projectDocumentMap.put(projDocList[0].ID, projDocList[0]);
            IPM_ProjectHelper.projectSectionMap.put(projectDocSecListObj[0].ID, projectDocSecListObj[0]);          
            IPM_ProjectSectionContentHelper.manageCMISections(docSecMap,docMap,projMap);
            IPM_ProjectHelper.DBprojectSpecificCMIGateMap.put(ParentProject.ID, new List<IPM_Gate_CMI__c>{gateCMI});
            IPM_ProjectSectionContentHelper.manageCMISections(docSecMap,docMap,projMap);
            List<IPM_Project_Document_Section_Content__c>conListObj=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecContentObj.Id];
            System.assertEquals(conListObj[0].IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE,'cmi content not created');         
            projectDocSecContentObj.IPM_Content_Type__c = IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION;
            update projectDocSecContentObj;
             List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecContentObj.Id];
            System.assertEquals(conList[0].IPM_Content_Type__c,IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION,CONTENT_NOT_UPDATED_STR);
            IPM_ProjectSectionContentHelper.manageCMISections(docSecMap,docMap,projMap);
            
            
            Test.stopTest();
        }
    }
    /*************************************************************************************************************************
    * @description Test Data
    */
    static testMethod void testmanageCustomerEvidenceConcepts() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            Test.startTest();
            projectDocSecListObj[0].IPM_Master_Section_External_Id__c = IPM_ConstantUtils.CONSUMER_EVIDENCE_CONCEPT;
            update projectDocSecListObj;
            projectDocSecList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id Limit 1];
            System.assertEquals(projectDocSecList[0].IPM_Master_Section_External_Id__c,IPM_ConstantUtils.CONSUMER_EVIDENCE_CONCEPT,SECTION_UPDATE_STR);  
            projectDocSecContentObj.IPM_Content_Type__c = IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE;
            update projectDocSecContentObj;
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecContentObj.Id];
            System.assertEquals(conList[0].IPM_Content_Type__c,IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE,CONTENT_NOT_UPDATED_STR);        
            IPM_ProjectHelper.gateToOTIFCustomSetting = IPM_Utils.getOTIFMapping();
            docSecMap=new map<Id,List<IPM_Project_Document_Section__c>>();
            docSecMap.put(projDocList[0].Id,projectDocSecListObj);
            docStringMap=new Map<String,IPM_Project_Document__c>(); 
            docStringMap.put(IPM_ConstantUtils.CHARTER_GATE,projDocList[0]);
            docMap=new Map<Id,Map<String,IPM_Project_Document__c>>();
            docMap.put(project.Id,docStringMap);
            projMap=new Map<Id,IPM_Project__c>();
            projMap.put(project.Id,project);
            IPM_ProjectHelper.DBprojectSpecificDocumentMap.put(projMap.values()[0].ID, projDocList);
            IPM_Project_Document_Section_Content__c tempProjDocSecCon = new IPM_Project_Document_Section_Content__c();
            tempProjDocSecCon = projectDocSecContentObj;
            tempProjDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE; 
            IPM_ProjectHelper.DBprojectSectionSpecificContentMap.put(projectDocSecListObj[0].ID, new List<IPM_Project_Document_Section_Content__c>{projectDocSecContentObj, tempProjDocSecCon });    
            IPM_ProjectSectionContentHelper.manageCustomerEvidenceConcepts(projMap,projDocList,projectDocSecListObj);
            List<IPM_Project_Document_Section_Content__c>conListObj=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecContentObj.Id];
            System.assertEquals(conListObj[0].IPM_Content_Type__c,IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE,'consumer evidence content not created');
            Test.stopTest();
        }
    }
    /*************************************************************************************************************************
    * @description Test Data
    */
    static testMethod void testmanageCustomerChannel() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            Test.startTest();
            
            projectDocSecListObj[0].IPM_Master_Section_External_Id__c = IPM_ConstantUtils.CUSTOMER_CHANNEL;
            update projectDocSecListObj;
            projectDocSecList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id Limit 1];
            System.assertEquals(projectDocSecList[0].IPM_Master_Section_External_Id__c,IPM_ConstantUtils.CUSTOMER_CHANNEL,SECTION_UPDATE_STR);
            docSecMap=new map<Id,List<IPM_Project_Document_Section__c>>();
            docSecMap.put(projDocList[0].Id,projectDocSecListObj);
            docStringMap=new Map<String,IPM_Project_Document__c>(); 
            docStringMap.put(IPM_ConstantUtils.CHARTER_GATE,projDocList[0]);
            docMap=new Map<Id,Map<String,IPM_Project_Document__c>>();
            docMap.put(project.Id,docStringMap);
            projMap=new Map<Id,IPM_Project__c>();
            projMap.put(project.Id,project);
            IPM_Project_Document_Section_Content__c tempProjDocSecCon = new IPM_Project_Document_Section_Content__c();
            tempProjDocSecCon = projectDocSecContentObj;
            tempProjDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION;
            projectDocSecContentObj.IPM_Content_Type__c = IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION;
            update projectDocSecContentObj;
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecContentObj.Id];
            System.assertEquals(conList[0].IPM_Content_Type__c,IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION,CONTENT_NOT_UPDATED_STR);
           
            IPM_ProjectSectionContentHelper.manageCustomerChannel(projMap,projDocList,projectDocSecListObj);
            projectDocSecList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id Limit 1];
            System.assertEquals(projectDocSecList[0].IPM_Master_Section_External_Id__c,IPM_ConstantUtils.CUSTOMER_CHANNEL,'customer channel content not created');
            Test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    static testMethod void testmanageFinancialActionStandards() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            Test.startTest();
            projectDocSecListObj[0].IPM_Master_Section_External_Id__c =IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD;
            update projectDocSecListObj;
            projectDocSecList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id Limit 1];
            System.assertEquals(projectDocSecList[0].IPM_Master_Section_External_Id__c,IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD,SECTION_UPDATE_STR);
            docSecMap=new map<Id,List<IPM_Project_Document_Section__c>>();
            docSecMap.put(projDocList[0].Id,projectDocSecListObj);
            docStringMap=new Map<String,IPM_Project_Document__c>(); 
            docStringMap.put(IPM_ConstantUtils.CHARTER_GATE,projDocList[0]);
            docMap=new Map<Id,Map<String,IPM_Project_Document__c>>();
            docMap.put(project.Id,docStringMap);
            projMap=new Map<Id,IPM_Project__c>();
            projMap.put(project.Id,project);
            IPM_Project_Document_Section_Content__c tempProjDocSecCon = new IPM_Project_Document_Section_Content__c();
            tempProjDocSecCon = projectDocSecContentObj;
            tempProjDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION;
            projectDocSecContentObj.IPM_Content_Type__c = IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION;
            update projectDocSecContentObj;
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecContentObj.Id];
            System.assertEquals(conList[0].IPM_Content_Type__c,IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION,CONTENT_NOT_UPDATED_STR);
            IPM_ProjectSectionContentHelper.manageFinancialActionStandards(projMap,projDocList,projectDocSecListObj);
            projectDocSecList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id Limit 1];
            System.assertEquals(projectDocSecList[0].IPM_Master_Section_External_Id__c,IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD,'financial action standard section is not created');
            Test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    static testMethod void testmanageCuComplexity() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            Test.startTest();
            projectDocSecListObj[0].IPM_Master_Section_External_Id__c = IPM_ConstantUtils.IPM_CU_COMPLEXITY;
            update projectDocSecListObj;
            projectDocSecList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id Limit 1];
            System.assertEquals(projectDocSecList[0].IPM_Master_Section_External_Id__c,IPM_ConstantUtils.IPM_CU_COMPLEXITY,SECTION_UPDATE_STR);
            docSecMap=new map<Id,List<IPM_Project_Document_Section__c>>();
            docSecMap.put(projDocList[0].Id,projectDocSecListObj);
            docStringMap=new Map<String,IPM_Project_Document__c>(); 
            docStringMap.put(IPM_ConstantUtils.CHARTER_GATE,projDocList[0]);
            docMap=new Map<Id,Map<String,IPM_Project_Document__c>>();
            docMap.put(project.Id,docStringMap);
            projMap=new Map<Id,IPM_Project__c>();
            projMap.put(project.Id,project);
            
            IPM_Project_Document_Section_Content__c tempProjDocSecCon = new IPM_Project_Document_Section_Content__c();
            tempProjDocSecCon = projectDocSecContentObj;
            tempProjDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION;
            projectDocSecContentObj.IPM_Content_Type__c = IPM_ConstantUtils.CUCOMPLEXITY_CONTENT_TYPE;
            update projectDocSecContentObj;
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecContentObj.Id];
            System.assertEquals(conList[0].IPM_Content_Type__c,IPM_ConstantUtils.CUCOMPLEXITY_CONTENT_TYPE,CONTENT_NOT_UPDATED_STR);
            IPM_ProjectSectionContentHelper.manageCuComplexity(projMap,projDocList,projectDocSecListObj);
            projectDocSecList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id Limit 1];
            System.assertEquals(projectDocSecList[0].IPM_Master_Section_External_Id__c,IPM_ConstantUtils.IPM_CU_COMPLEXITY,'Cu Complexity section is not created');
            Test.stopTest();
        }
    }
    /*************************************************************************************************************************
    * @description Test Data
    */
    static testMethod void testmanageAssumptions() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            Test.startTest(); 
            projectDocSecListObj[0].IPM_Master_Section_External_Id__c = IPM_ConstantUtils.ASSUMPTIONS;
            update projectDocSecListObj;
            projectDocSecList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id Limit 1];
            System.assertEquals(projectDocSecList[0].IPM_Master_Section_External_Id__c,IPM_ConstantUtils.ASSUMPTIONS,SECTION_UPDATE_STR);
            docSecMap=new map<Id,List<IPM_Project_Document_Section__c>>();
            docSecMap.put(projDocList[0].Id,projectDocSecListObj);
            docStringMap=new Map<String,IPM_Project_Document__c>(); 
            docStringMap.put(IPM_ConstantUtils.CHARTER_GATE,projDocList[0]);
            docMap=new Map<Id,Map<String,IPM_Project_Document__c>>();
            docMap.put(project.Id,docStringMap);
            projMap=new Map<Id,IPM_Project__c>();
            projMap.put(project.Id,project);
            IPM_ProjectSectionContentHelper.manageAssumptions(projMap,projDocList,projectDocSecListObj);
            projectDocSecList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id Limit 1];
            System.assertEquals(projectDocSecList[0].IPM_Master_Section_External_Id__c,IPM_ConstantUtils.ASSUMPTIONS,'assumption section is not created');
            Test.stopTest();
        }
    }
}