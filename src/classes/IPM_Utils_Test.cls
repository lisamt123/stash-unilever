/**
 * Description : To update project name and rollout name
 * @author : Cognizant
 */
@isTest
private class IPM_Utils_Test {
    
    private static IPM_Project__c project;// Project object initialization
    private static list<MDO_Geography__c> geographyList;
    private static list<MDO_Geography__c> geographyDetailList;
    private static list<String> countryNameList =  new list<String>{'Chile','New Zealand'};
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Financial__c> finList=new List<IPM_Financial__c>();
    private static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    private static IPM_Project_Rollout__c projRoll;
    private static List<IPM_Country__c> countryTest = new List<IPM_Country__c>();
    private static User stdUserForAssort;
    private static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    private static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static string LOCAL_STR='Local';
    private static string REGIONAL_STR='Regional';
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static User globalUser;
    private static IPM_Project_Document_Section_Content__c projDocSecCon;
    private static String CONSOLIDATED_FINANCIAL_RECORDTYPE;
    private static IPM_Company_Card__c globalCompanyCard=new IPM_Company_Card__c();
    private static Map<Id,IPM_Project__c> childProjMap=new Map<Id,IPM_Project__c>();
    private static Map<Id,Map<Id,IPM_Project__c>> projectToChildMap=new Map<Id,Map<Id,IPM_Project__c>>();
    private static Map<Id,IPM_Project__c> projectDetailMap=new Map<Id,IPM_Project__c>();
    /*****************************************************************************
    * @description Test Data
    */  
    
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForAssort= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForAssort.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForAssort.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        IPM_User_Profile__c usrObj =IPM_TestFactory_Helper.createUserProfile(false);
        usrObj.IPM_User_Role__c='Supply Chain';
        usrObj.IPM_User__c=stdUserForAssort.id;
        insert usrObj;
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(3,stdUserForAssort);
        
            
        System.runAs(stdUserForAssort) {
            insert projectList;
            
            project=projectList[0];
            //project.Name='ProChgStatus';
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project name');//positive test
            
            //create geography related test data
          geographyList = new list<MDO_Geography__c>();
          for(string name:countryNameList)
          {
              MDO_Geography__c geography = IPM_TestFactory_Helper.createMDOGeography(false);
              geography.Name = name;
              geographyList.add(geography);
          }   
          insert geographyList;
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForAssort,stdUserForAssort,stdUserForAssort});
            insert regionalRolloutList;
            List<IPM_Project_Rollout__c> proRegListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:regionalRolloutList[0].ID LIMIT 1];
            System.assertEquals(proRegListObj[0].IPM_Rollout_Span__c,REGIONAL_STR,'regional rollout created');//positive test
            projRoll=regionalRolloutList[0];
            
      
            
        }
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    public static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        system.runAs(globalUser){
            projectListObj = [Select Id, Name,IPM_Project_Name__c,EcoDesign_Sync_Status__c,Fetch_Timestamp_Mulesoft__c,Success_TimeStamp_EcoDesign__c,
                                    BET_Update__c,BET_Link_Requested__c,BET_Link_Requested_on_Date__c,IPM_SourceProjectType__c,IPM_Project_Type__c,
                                    IPM_Answer_of_Q1__c,IPM_Company_Card__c,IPM_CompanyCardText__c, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r )
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
           IPM_Project__c childProj=new IPM_Project__c();
            childProj.IPM_Parent_Project__c=project.id;
            childProj.IPM_Project_Name__c=project.Name+'_Name';
            childProj.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            insert childProj;
            IPM_Project__c childProjs=new IPM_Project__c();
            childProjs.IPM_Parent_Project__c=childProj.id;
            childProjs.IPM_Project_Name__c=project.Name+'_Names';
            childProjs.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            insert childProjs;
            
            childProjMap.put(childProj.id,childProj);
            projectDetailMap.put(project.id,project);
            projectToChildMap.put(project.id,projectDetailMap);
            
            
            geographyDetailList = [SELECT id,Name FROM MDO_Geography__c WHERE Name IN: countryNameList];
          system.assertEquals(geographyDetailList.size(),2);
          
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                //System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            
            //projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            //where IPM_Project_Document__c=:projDocList[0].Id];
            //system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
            
            //create country test data
          for(integer i=0 ;i<10 ;i++){
              IPM_Country__c insertCountry = IPM_TestFactory_Helper.createIPMCountry(false);
              if(i!=7){
                  insertCountry.IPM_Project__c = projectListObj[0].Id;
                  insertCountry.IPM_Regional_Project__c = projectListObj[1].Id;
                  
              }
              insertCountry.IPM_Local_Project__c = projectListObj[2].Id;
              insertCountry.MDO_Geography__c=geographyDetailList[0].id;
              insertCountry.isActive__c = true;
              countryTest.add(insertCountry);
          }
          insert countryTest;
          
          list<IPM_Country__c> countryList = [SELECT Id,IPM_Project__c,MDO_Geography__c,IPM_Local_Project__c,MDO_Geography__r.Name FROM IPM_Country__c WHERE                  MDO_Geography__r.Name IN:countryNameList];
          for(IPM_Country__c country :countryList)
          {
              system.assertEquals(country.IPM_Local_Project__c,projectListObj[2].Id);
          }
          
          for(IPM_Project__c projectObj : projectListObj) {
                finList = projectObj.IPM_Financials_Consolidated__r;
          }
            
          String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
          CONSOLIDATED_FINANCIAL_RECORDTYPE=strRecordTypeId1;
          finYear = IPM_TestFactory_Helper.createIPMFinancialYear(FALSE);
          finYear.IPM_Financial__c=finList[0].Id;
          finYear.Charter_Approved__c=true;
          finYear.Contract_Approved__c=true;
          finYear.MD_Approved__c=true;
          finYear.MD_Approved__c=true;
          finYear.Copy_Global_to_Local__c=true;
          finYear.Copy_Global_to_Regional__c=true;
          finYear.Copy_Local_to_Regional__c=true;
          finYear.Copy_Regional_to_Local__c=true;       
          
          insert finYear;        
          system.assertNotEquals(finYear.id, null);  
        }
        IPM_TestFactory_Helper.createIPMOTIFStatus(true);
        IPM_OTIF_Status__c OTIFObj =new IPM_OTIF_Status__c();
        OTIFObj.IPM_Gate_Document_Type__c='Charter Gate';
        OTIFObj.Name='TestOtif';
        insert OTIFObj;
        IPM_Section_Copy_Mapping__c sectionCopyMappingObj =new IPM_Section_Copy_Mapping__c();
        sectionCopyMappingObj.Type_Of_Gate__c='Contract';
        sectionCopyMappingObj.name='copyname';
        insert sectionCopyMappingObj;
        
    }
    
    static testmethod void testUpdateProjectsName(){
        initializeTestMethodData();
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        //project.IPM_CompanyCardText__c =IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
        
        test.startTest();
        //running as global project leader with invalid project name
        system.runAs(globalUser){
            //get project old name and new name along with project id
           
            IPM_Utils.convertStrToSoqlList('String,str');
            //IPM_Utils.getMilestoneRecordType('pRecordType');
            IPM_Utils.getSuffixString('strName,test', ',');
            set<string>shortSet=new set<string>();
            shortSet.add(project.id);
            IPM_Utils.convertSetToSortedList(shortSet);
            IPM_Utils.removeFirst2Words('strName,test,test2', ',');
            IPM_Utils.getsObjPrefix('IPM_Bosscard__c');
            IPM_Utils.checkDataValid('Valid project name');
            String givenKey='1';
            Map<String, Integer> givenMap=new Map<String, Integer>();
            givenMap.put(givenKey,1);
            IPM_Utils.incrementStrIntMap(givenMap,givenKey);
            IPM_Utils.getProjectTypesBasedOnCompanyCard(project);
            IPM_Utils.getPhasesBasedOnProjectType(project);
            IPM_Utils.convertJSArrayToLsArray('get value,get value,get value');
            IPM_Utils.convertSetToString(shortSet);
            Set<id>userIdSet=new set<id>();
            userIdSet.add(globalUser.id);
            IPM_Utils.getUserProfilePhoto(userIdSet);
            IPM_Utils.getMilestoneRecordType(IPM_ConstantUtils.MILESTONES_RECORDTYPE);
            IPM_Utils.getFinancialRecordType('Consolidated');
            sobject taskObject=new IPM_Task__c();
            IPM_Utils.getPicklistValues(taskObject,'IPM_Function__c');
            IPM_Utils.userRole();
            IPM_Utils.getUserDetailsMap(userIdSet);
            string projids=project.id;
            IPM_Utils.getCurrentPhase(projids);
            Project.BET_Update__c=true;
            IPM_Utils.updateProjBETApproved(Project);
            Set<id>projectIsSet=new Set<id>();
            projectIsSet.add(project.id);
            IPM_Utils.getProjectDetails(projectIsSet);
            IPM_Utils.getPhasesBasedOnProjectType(project);
            IPM_Utils.getSectionCopyOverMapping();
            IPM_Utils.getOTIFMapping();
            IPM_Project_Type__c projectType=new IPM_Project_Type__c();
            
            for(IPM_Project_Type__c projectTypeList:IPM_Project_Type__c.getAll().values()){
              if(projectTypeList.IPM_Parent_project_Type__c!=null){
                projectType=projectTypeList;
                break;
              }
            } 
            IPM_Utils.getNextPhase(projectType,true);
            IPM_Utils.getPreviousPhase(projectType,true);
            IPM_Utils.getPreviousPhases(projectType,true);
            IPM_Utils.createProjectITOValueMap(); 
            IPM_Company_Card__c ccCard=[Select id from IPM_Company_Card__c LIMIT 1][0];
            project.IPM_Company_Card__c =ccCard.id;
            List<IPM_Project__c>projectOldType=new List<IPM_Project__c>();
            projectOldType.add(project);
            IPM_Utils.getProjectTypeMetadata(projectOldType);
             List<IPM_Project_Rollout__c> proRegListObjs=[SELECT KeyMCO__c,IPM_Rollout_Project__c,Added_At_Stage__c,Regional_Rollout_External_Id__c from IPM_Project_Rollout__c LIMIT 1];
           IPM_Utils.getFinancialExternalId(proRegListObjs[0]);
           IPM_Utils.prepareProjectToGrandChildMapping(projectToChildMap,childProjMap);
           IPM_Utils.prepareProjectToChildMapping(projectDetailMap,childProjMap);
           IPM_Utils.prepareProjectToGrandParentMapping(childProjMap,projectDetailMap);
         }
         system.runAs(IPM_TestFactory_Helper.createUserAdmin(false)){
           string projid=project.id;
            string roletype='Central Team';
           Boolean isEditable=IPM_Utils.getIpmuserType(projid,roletype);
            Boolean isEditables=IPM_Utils.getIPMRollOutUser(projid);
            system.assertEquals(isEditable, false);
            system.assertEquals(isEditables, false);
            IPM_Utils.userRole();
         }
         test.stopTest();
        
        
    }
}