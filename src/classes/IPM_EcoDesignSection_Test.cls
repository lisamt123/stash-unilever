/*******************************************************
* @Description: Test class for IPM_EcoDesignSection
* @Author:Cognizant
* @Date:04/22/2015
* *****************************************************/

@isTest
public class IPM_EcoDesignSection_Test{
    public static final String ENVIRONMENTAL_IMPACT = 'Environmental_Impact';
    public static final String WITH_MCO = 'With MCO';
    public static final String ORIGINAL = 'Original';
    public static final String REGIONAL = 'Regional';
    public static final String HHC = 'HHC';
    public static final String TESTNAME = 'Test123';
    public static final String PROJECT_LEADER = 'Project Leader';
    public static final String MO = 'MO';
    public static final String REGIONAL_COMPANY_CARD = 'Regional Company Card';
    public static final String PROJ_DOC_SEC_Id = 'ProjDocSecId';
    public static final String ID = 'Id';
    /***********************************
     * @Description: validate EcoDesign functionality for Global Original Project
     * *********************************/
    public static testmethod void validateEcoDesignSave_Global() {
        List<IPM_Project__c> projectList;
        //List<IPM_Project_Document__c> projDocList;
        // Current running in Sharing mode with old sharing logic. Using System admin profile for time being.
        User globalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        globalUser.email = 'globalUser@unilever.test.com';
         
        User regionalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        regionalUser.email = 'regionalUser@unilever.test.com';
        
        User localUser = IPM_TestFactory_Helper.createUserAdmin(false);
        localUser.email = 'localUser@unilever.test.com';
        
        List<User> userList = new List<User>{globalUser,regionalUser,localUser};    
        List<IPM_Assessment__c> finalAssessmentList = new List<IPM_Assessment__c>();
        List<IPM_Company_Card__c> companyCardList ;
        System.runAs(userList[0]) {
            // Create Company Card information 
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            globalCompanyCard.IPM_TxtGeographical_Scope__c = TESTNAME;
            globalCompanyCard.IPM_Business_Partner__c = NULL;
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            regionalCompanyCard.IPM_TxtGeographical_Scope__c = TESTNAME;
            regionalCompanyCard.IPM_Business_Partner__c = NULL;
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            localCompanyCard.IPM_TxtGeographical_Scope__c = TESTNAME;
            localCompanyCard.IPM_Business_Partner__c = NULL;
            companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
        }
        Test.startTest();
        System.runAs(userList[1]) {
            //  Create User profile Information
            List<String> projectNames = new List<String>();
            
            // Get master data for the project including Templates,Documents,Section,Tasks and Milestones.
            IPM_TestFactory_Helper.getProjectMasterData();
            
            // Create project for assignment.
            projectList = IPM_TestFactory_Helper.createOriginalProjectList(false, 1);
            for(IPM_Project__c project : projectList) {
                project.IPM_Company_Card__c = companyCardList[0].Id;
                project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
                project.IPM_Project_Leader__c = userList[0].Id;
                project.IPM_SourceProjectType__c = ORIGINAL;
                project.Success_Timestamp_EcoDesign__c = System.now().addHours(2);
                projectNames.add(project.IPM_Project_Name__c);                       
            }
            insert projectList;
        }
        Test.stopTest();      
        // At this point Async process kicks in and starts creating Related Object information.    
        // Create Country specific information.
        List<MDO_Geography__c> mdo_geoList = new List<MDO_Geography__c>();
        MDO_Geography__c geo;
        List<IPM_Country__c> countryList= new List<IPM_Country__c>();
        System.runAs(userList[0]) {
            for(integer i=0 ;i<10 ;i++) {
                geo = new MDO_Geography__c(name = 'Test'+i);
                mdo_geoList.add(geo);  
            }
            insert mdo_geoList;      
            for(integer i=0; i<10 ; i++) {
                if(i < 7) {
                    IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
                    IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = WITH_MCO,
                    IS_EI_Country__c = true);    
                    countryList.add(tempCountry);
                }
                else {
                    IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
                    IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = WITH_MCO,
                    IS_EI_Country__c = false);    
                    countryList.add(tempCountry);
                }
            }
            insert countryList;
            integer cnt = 1;
            for(IPM_Country__c countryEle : countryList) {
                if((cnt < 3 && countryEle.IS_EI_Country__c) || (cnt > 6 && !countryEle.IS_EI_Country__c)) {
                    //IPM_Assessment__c assessment = new IPM_Assessment__c();
                    IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
                    if(cnt == 1 || cnt == 9) {
                        assessment.IPM_Is_Lead_Assessment__c = true;
                    }
                    else {
                        assessment.IPM_Is_Lead_Assessment__c = false;
                    }
                    finalAssessmentList.add(assessment);
                }
                cnt++;
            }    
            insert finalAssessmentList;  
        }
        List<IPM_Project_Document__c> projDocListWithProj = [Select id,name,IPM_GateDocuments__c From IPM_Project_Document__c limit 1000];
        List<IPM_Project_Document_Section__c> projDocSectionList = [Select Id From IPM_Project_Document_Section__c Where IPM_Master_Section_External_Id__c =: ENVIRONMENTAL_IMPACT and  IPM_Project_Document__c =: projDocListWithProj[0].id];
        PageReference ecoDesignRef = Page.IPM_ProjectDocumentSectionEditor; 
        ecoDesignRef.getParameters().put(ID,projectList[0].Id);
        ecoDesignRef.getParameters().put(PROJ_DOC_SEC_Id,projDocSectionList[0].Id);
        Test.setCurrentPage(ecoDesignRef);
        //Instantiating the IPM_EcoDesignSection class and checking the list size
        IPM_EcoDesignSection ecoDesignHandler = new IPM_EcoDesignSection();
        System.assertEquals(ecoDesignHandler.countryAssessmentWrapListEICountries.size(),7, 'EIcountry size not matched');        
        System.assertEquals(ecoDesignHandler.countryAssessmentWrapListNonEICountries.size(),3, 'NonEICountries size not matched');
    }  
    
        /***********************************
     * @Description: validate EcoDesign functionality for Regional Original Project
     * *********************************/
    public static testmethod void validateEcoDesignSave_Regional() {
        List<IPM_Project__c> projectList;
        // Current running in Sharing mode with old sharing logic. Using System admin profile for time being.
        User globalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        globalUser.email = 'globalUser@unilever.test.com';
         
        User regionalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        regionalUser.email = 'regionalUser@unilever.test.com';
        
        User localUser = IPM_TestFactory_Helper.createUserAdmin(false);
        localUser.email = 'localUser@unilever.test.com';
        
        List<User> userList = new List<User>{globalUser,regionalUser,localUser};    
        List<IPM_Assessment__c> finalAssessmentList = new List<IPM_Assessment__c>();
        List<IPM_Company_Card__c> companyCardList ;
        System.runAs(userList[0]) {
            // Create Company Card information 
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            globalCompanyCard.IPM_TxtGeographical_Scope__c = TESTNAME;
            globalCompanyCard.IPM_Business_Partner__c = NULL;
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            regionalCompanyCard.IPM_TxtGeographical_Scope__c = TESTNAME;
            regionalCompanyCard.IPM_Business_Partner__c = NULL;
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            localCompanyCard.IPM_TxtGeographical_Scope__c = TESTNAME;
            localCompanyCard.IPM_Business_Partner__c = NULL;
            companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
        }
        Test.startTest();
        System.runAs(userList[1]) {
            //  Create User profile Information
            List<String> projectNames = new List<String>();
        
            // Get master data for the project including Templates,Documents,Section,Tasks and Milestones.
            IPM_TestFactory_Helper.getProjectMasterData();
            
            // Create project for assignment.
            projectList = IPM_TestFactory_Helper.createOriginalProjectList(false, 1);
            for(IPM_Project__c project : projectList) {
                project.IPM_Company_Card__c = companyCardList[1].Id;
                project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
                project.IPM_Project_Leader__c = userList[0].Id;
                project.IPM_SourceProjectType__c = ORIGINAL;
                project.IPMProject_Span__c = REGIONAL;
                project.IPM_Gatekeeping_model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
                project.IPM_CompanyCardText__c = REGIONAL_COMPANY_CARD;
                project.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_LITE;
                project.Success_Timestamp_EcoDesign__c = System.now().addHours(2);
                projectNames.add(project.IPM_Project_Name__c);                       
            }
            insert projectList;
        }
        Test.stopTest();      
        // At this point Async process kicks in and starts creating Related Object information.    
        // Create Country specific information.
        List<MDO_Geography__c> mdo_geoList = new List<MDO_Geography__c>();
        MDO_Geography__c geo;
        List<IPM_Country__c> countryList= new List<IPM_Country__c>();
        System.runAs(userList[0]) {
            for(integer i=0 ;i<10 ;i++) {
                geo = new MDO_Geography__c(name = 'Test'+i);
                mdo_geoList.add(geo);  
            }
            insert mdo_geoList;      
            for(integer i=0; i<10 ; i++) {
                if(i < 7) {
                    IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
                    IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = WITH_MCO,
                    IS_EI_Country__c = true,IPM_Regional_Proj_Association_Timestamp__c =System.now());    
                    countryList.add(tempCountry);
                }
                else {
                    IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
                    IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = WITH_MCO,
                    IS_EI_Country__c = false,IPM_Regional_Proj_Association_Timestamp__c =System.now());    
                    countryList.add(tempCountry);
                }
            }
            insert countryList;
            integer cnt = 1;
            for(IPM_Country__c countryEle : countryList) {
                if((cnt < 3 && countryEle.IS_EI_Country__c) || (cnt > 6 && !countryEle.IS_EI_Country__c)) {
                    //IPM_Assessment__c assessment = new IPM_Assessment__c();
                    IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
                
                    if(cnt == 1 || cnt == 9) {
                        assessment.IPM_Is_Lead_Assessment__c = true;
                    }
                    else {
                        assessment.IPM_Is_Lead_Assessment__c = false;
                    }
                    finalAssessmentList.add(assessment);
                }
                cnt++;
            }    
            insert finalAssessmentList;  
        }
        List<IPM_Project_Document__c> projDocListWithProj = [Select id,name,IPM_GateDocuments__c From IPM_Project_Document__c limit 1000];
        List<IPM_Project_Document_Section__c> projDocSectionList = [Select Id From IPM_Project_Document_Section__c Where IPM_Master_Section_External_Id__c =: ENVIRONMENTAL_IMPACT and  IPM_Project_Document__c =: projDocListWithProj[0].id];
        PageReference ecoDesignRef = Page.IPM_ProjectDocumentSectionEditor; 
        ecoDesignRef.getParameters().put(ID,projectList[0].Id);
        ecoDesignRef.getParameters().put(PROJ_DOC_SEC_Id,projDocSectionList[0].Id);
        Test.setCurrentPage(ecoDesignRef);
        //Instantiating the IPM_EcoDesignSection class and checking the list size
        IPM_EcoDesignSection ecoDesignHandler = new IPM_EcoDesignSection();
        System.assertNotEquals(ecoDesignHandler.countryAssessmentWrapListEICountries.size(),0);        
        System.assertEquals(ecoDesignHandler.countryAssessmentWrapListNonEICountries.size(),3);
    }  
}