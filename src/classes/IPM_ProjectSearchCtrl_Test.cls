/**
* @DescriptionIPM_ProjectSearchCtrl_Test : This Test class for IPM_ProjectSearchCtrl apex class
*/
@isTest
public class IPM_ProjectSearchCtrl_Test {

    /*string literals replaced*/
    private static final String FID_STR = 'thisFld';
    private static IPM_Project__c proj;
    private static final String IPM_PHASE_FIELD = 'IPM_Phase__c';
    private static final String IPM_PROJECT_FIELD= 'IPM_Project__c';
    private static final String GATEKEEPING_MODEL_FIELD = 'IPM_GateKeeping_Model__c';
    private static final String NAME_FIELD = 'Name';
    private static final String COMPLEXITY_FIELD = 'IPM_Complexity__c';
    private static final String PROJECT_TYPE = 'IPM_Project_Type__c';
    private static final String PROJECT_SPAN = 'IPMProject_Span__c';
    private static final String COMPANY_CARD = 'IPM_Company_Card__c';
    private static IPM_ProjectSearchCtrl psCtrl;
    private static List<MDO_Geography__c> lstGeographies;
    private static List<IPM_Country__c> lstCountries;
    private static final String TRUE_STR = 'true';
    private static final String FALSE_STR = 'false';
    private static final String ALL = 'all';
    private static final String ORIGINAL_PROJ_NAME = 'OriProj';
    private static User platformUserFirst;
    private static User platformUserSecond;
    private static IPM_Company_Card__c companyCard;
    
    static void createTestUsers(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUserFirst = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            platformUserSecond = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        }
        
        companyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        insert companyCard;
        
    }
    
    static void initializeData(){

        lstGeographies =  IPM_TestFactory_Helper.createGeographyList(true,3);
        system.assertEquals(3, lstGeographies.size() , 'Master data for 3 geographies are added.');
        
        //Update Geographies's parent L2 lookup
        for(integer i = 0 ; i < lstGeographies.size() - 1 ; i++){
            lstGeographies[i+1].parent_L2__c = lstGeographies[i].Id;
        }
        update lstGeographies;
        
        //Assign countries to project
        lstCountries = IPM_TestFactory_Helper.createIPMCountryList(false,3);
        insert lstCountries;
    }
    
    /*
     * @Description : Search the project
     */
   static testMethod void projectSearch_SingleProjInsert() {
        createTestUsers();
        Test.startTest();
        
        System.runAs(platformUserFirst) { 
            initializeData();
            //Insert single Project
            proj = IPM_TestFactory_Helper.createIPMProject(false);
            proj.IPM_Project_Type__c ='Original';
            proj.IPM_ProjectSubType__c='Operational';
            proj.IPM_Project_Name__c ='Test Project 1';
            proj.IPM_Phase__c =IPM_ConstantUtils.PHASE_IDEAS;
            proj.IPM_Project_Leader__c = UserInfo.getUserId();
            proj.IPM_Target_Launch_Dates__c = System.today();
            proj.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL; 
            proj.IPM_Company_Card__c = companyCard.Id;
            insert proj;
       
            for(Integer i = 0 ; i < lstCountries.size() ; i++){
                    lstCountries[i].MDO_Geography__c = lstGeographies[i].Id;
                    lstCountries[i].IPM_Project__c = proj.Id;
            }
            update lstCountries;
            
            psCtrl=new IPM_ProjectSearchCtrl();
            psCtrl.mProjects=TRUE_STR;
            psCtrl.aProjects = FALSE_STR;
            psCtrl.selectedProjType = IPM_ConstantUtils.STATUS_ALL;
            psCtrl.selectedActiveProject = TRUE_STR;
            psCtrl.selectedStoppedProject = false;
            psCtrl.selectedPhase=ALL;
            psCtrl.geoAll = TRUE_STR;
            psCtrl.searchTxt='Test ProjectPS';
            psCtrl.bPositionings = 'Dirt Is Good';   
            psCtrl.iTO1 = 100;
            psCtrl.iTO2 = 1000;
            psCtrl.clusters ='Africa';
            psCtrl.mcos ='Africa Emerging Markets';
            psCtrl.countries= 'Angola';
            psCtrl.tldFrom = String.valueOf(System.today() - 5 );
            psCtrl.tldTo = String.valueOf(System.today() + 5 );
            psCtrl.getusertype();  
            psCtrl.loadProjects();
             
            psCtrl.toggleSortProjects();
            system.assertEquals(psCtrl.currentSort.get(FID_STR), 'IPM_Project_Name__c', 'Sorting needs to be done via Project Name');
            psCtrl.toggleSortPhases();
            system.assertEquals(psCtrl.currentSort.get(FID_STR), IPM_PHASE_FIELD, 'Sorting needs to be done via phase');
            psCtrl.toggleSortPLs();
            system.assertEquals(psCtrl.currentSort.get(FID_STR), 'IPM_Project_Leader__r.Name', 'Sorting needs to be done via IPM_Project_Leader__r.Name');
            psCtrl.toggleSortGKs();
            system.assertEquals(psCtrl.currentSort.get(FID_STR), 'IPM_Project_Gatekeeper__r.Name', 'Sorting needs to be done via IPM_Project_Gatekeeper__r.Name');
            psCtrl.toggleSortITOs();
            system.assertEquals(psCtrl.currentSort.get(FID_STR), 'IPM_Project_Name__c', 'Sorting needs to be done via IPM_Project_Name__c');
            psCtrl.toggleSortTLDs();
            system.assertEquals(psCtrl.currentSort.get(FID_STR), 'IPM_Target_Launch_Dates__c', 'Sorting needs to be done via IPM_Target_Launch_Dates__c');
            psCtrl.first();
            psCtrl.last();
            psCtrl.previous();
            psCtrl.next();
            //psCtrl.hasPrevious;
            //psCtrl.hasNext;
            psCtrl.getPageNumber();
            psCtrl.getTotalPages();
            system.assert(proj.Id != null, 'The project record inserted');
        }
        Test.stopTest();
        
    }
    
    //Testmethod to validate my projects count when multiple projects are inserted
    static testMethod void myProjectsSearch_BulkProjInsert() {
        createTestUsers();
        Test.startTest();
        
        //Insert 4 projects in bulk in context of user1
        System.runAs(platformUserFirst) { 
            IPM_TestFactory_Helper.createIPMProjectList(true, 4);
        }
        
        //Insert 5 projects in bulk in context of user2 and check project seach result count as 5 when 'My Project' filter is selected.
        System.runAs(platformUserSecond){     
            
            Map<String,Object> projMap;
            List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
            
            for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => ORIGINAL_PROJ_NAME + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
            }
            insert lstProjects;
            
            psCtrl=new IPM_ProjectSearchCtrl();
            psCtrl.mProjects=TRUE_STR;
            psCtrl.aProjects = FALSE_STR;
            psCtrl.selectedProjType = IPM_ConstantUtils.STATUS_ALL;
            psCtrl.selectedActiveProject = TRUE_STR;
            psCtrl.selectedStoppedProject = false;
            psCtrl.selectedPhase=ALL;
            psCtrl.geoAll = TRUE_STR;
            psCtrl.loadProjects();
                      
            system.assertEquals(5, psCtrl.projects.size() , 'My projects filter will give me 5 records');
           
            Test.stopTest();
        }
    }
    
    
    
    //Testmethod to validate Original projects count when multiple projects are inserted
    static testmethod void validateOriginalProjectCount_BulkProjInsert() {
        Map<String,Object> projMap;
        List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
        createTestUsers();
        Test.startTest();
        
        //Insert 5 projects in bulk in context of user1
        System.runAs(platformUserFirst) { 
            
        //Create 5 Original projects
        for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => 'OriginalProj' + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
            
        }
        
        //Create 5 Rollout projects
        for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => 'RolloutProj' + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
            
        }
        
        //Create 5 Operational projects
        for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => 'OperationalProj' + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        'IPM_Complexity__c' =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
        }
        
        insert lstProjects;
        
        psCtrl=new IPM_ProjectSearchCtrl();
        psCtrl.mProjects=TRUE_STR;
        psCtrl.aProjects = TRUE_STR;
        psCtrl.selectedProjType = 'Original';
        psCtrl.selectedActiveProject = TRUE_STR;
        psCtrl.selectedStoppedProject = false;
        psCtrl.selectedPhase=ALL;
        psCtrl.geoAll = TRUE_STR;
        psCtrl.loadProjects();
            
        system.assertEquals(5, psCtrl.projects.size() , 'Original projects filter will give me 5 records');
           
        Test.stopTest();
        }
    }
    
    //Testmethod to validate Rollout projects count when multiple projects are inserted
    static testMethod void validateRolloutProjectCount_BulkProjInsert() {
        Map<String,Object> projMap;
        List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
        createTestUsers();
        Test.startTest();
        
        //Insert 5 projects in bulk in context of user1
        System.runAs(platformUserFirst) { 
            
        //Create 5 Original projects
        for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => ORIGINAL_PROJ_NAME + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS , PROJECT_SPAN => IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
        }
        
        //Create 5 Rollout projects
        for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => 'RollProj' + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS , PROJECT_SPAN => 'Regional',
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
        }
        
        //Create 5 Operational projects
        for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => 'OperProj' + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS , PROJECT_SPAN => IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
        }
        
        insert lstProjects;
        
        psCtrl=new IPM_ProjectSearchCtrl();
        psCtrl.mProjects=TRUE_STR;
        psCtrl.aProjects = TRUE_STR;
        psCtrl.selectedProjType = 'Rollout';
        psCtrl.selectedActiveProject = TRUE_STR;
        psCtrl.selectedStoppedProject = false;
        psCtrl.selectedPhase=ALL;
        psCtrl.geoAll = TRUE_STR;
        psCtrl.loadProjects();
                    
        system.assertEquals(5, psCtrl.projects.size() , 'Rollout projects filter will give me 5 records');
           
        Test.stopTest();
        }
    }
    
    //Testmethod to validate Operational projects count when multiple projects are inserted
    static testMethod void validateOperationalProjectCount_BulkProjInsert() {
        Map<String,Object> projMap;
        List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
        createTestUsers();
        Test.startTest();
        
        //Insert 5 projects in bulk in context of user1
        System.runAs(platformUserFirst) { 
            
        //Create 5 Original projects
        for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => 'TestComments' + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
        }
        
        //Create 5 Rollout projects
        for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => 'TestComments' + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
        }
        
        //Create 5 Operational projects
        for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => 'TestComments' + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
        }
        
        insert lstProjects;
        
        psCtrl=new IPM_ProjectSearchCtrl();
        psCtrl.mProjects=TRUE_STR;
        psCtrl.aProjects = TRUE_STR;
        psCtrl.selectedProjType = 'Operational';
        psCtrl.selectedActiveProject = TRUE_STR;
        psCtrl.selectedStoppedProject = false;
        psCtrl.selectedPhase=ALL;
        psCtrl.geoAll = TRUE_STR;
        psCtrl.loadProjects();
            
        system.assertEquals(5, psCtrl.projects.size() , 'Operational projects filter will give me 5 records');
           
        Test.stopTest();
        }
    }
    
    //Testmethod to validate all projects count when multiple projects are inserted
    static testMethod void allProjectsNegativeTest() {
        Test.startTest();
        createTestUsers();
        //Insert 5 projects in bulk in context of user1
        System.runAs(platformUserFirst) { 
            Map<String,Object> projMap;
            List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
            
            for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => ORIGINAL_PROJ_NAME + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
            }
            insert lstProjects;
            
            psCtrl=new IPM_ProjectSearchCtrl();
            psCtrl.mProjects=FALSE_STR;
            psCtrl.aProjects = FALSE_STR;
            psCtrl.selectedProjType = IPM_ConstantUtils.BLANK;
            psCtrl.selectedActiveProject = FALSE_STR;
            psCtrl.selectedStoppedProject = false;
            psCtrl.selectedPhase=IPM_ConstantUtils.BLANK;
            psCtrl.geoAll = FALSE_STR;
            psCtrl.clusters =IPM_ConstantUtils.BLANK;
            psCtrl.mcos =IPM_ConstantUtils.BLANK;
            psCtrl.countries= IPM_ConstantUtils.BLANK;
            psCtrl.unassigned  = FALSE_STR;
            psCtrl.getusertype();  
            psCtrl.loadProjects();
            
            system.assertEquals(0, psCtrl.projects.size() , 'All projects filter will give me 0 records');
            Test.stopTest();
        }
        
        
    }
    
    //Testmethod to validate all projects count when multiple projects are inserted
    static testMethod void testStoppedProjectCount() {
        Test.startTest();
        createTestUsers();
        //Insert 5 projects in bulk in context of user1
        System.runAs(platformUserFirst) { 
            Map<String,Object> projMap;
            List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
            
            for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => ORIGINAL_PROJ_NAME + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
            }
            insert lstProjects;
            
            //IPM_TestFactory_Helper.createIPMProjectResource(lstProjects[0].Id,true);

            psCtrl=new IPM_ProjectSearchCtrl();
            psCtrl.mProjects=TRUE_STR;
            psCtrl.aProjects = TRUE_STR;
            psCtrl.selectedProjType = IPM_ConstantUtils.STATUS_ALL;
            psCtrl.selectedActiveProject = FALSE_STR;
            psCtrl.selectedStoppedProject = true;
            psCtrl.selectedPhase=ALL;
            psCtrl.geoAll = TRUE_STR;
            psCtrl.loadProjects();
            
            system.assertEquals(0, psCtrl.projects.size() , 'Stopped projects filter will give me 0 records');
            Test.stopTest();
        }
    }
    
    //Testmethod to validate all projects count when multiple projects are inserted
    static testMethod void geographiesFilterTest_geoAllFalse_countriesNotBlank() {
        Test.startTest();
        createTestUsers();
        System.runAs(platformUserFirst) { 
            initializeData();
        //Insert 5 projects in bulk in context of user1
            Map<String,Object> projMap;
            List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
            
            for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => ORIGINAL_PROJ_NAME + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
            }
            insert lstProjects;
            
            
            for(Integer i = 0 ; i < lstCountries.size() ; i++){
                    lstCountries[i].MDO_Geography__c = lstGeographies[i].Id;
                    lstCountries[i].IPM_Project__c = lstProjects[i].Id;
            }
            update lstCountries;
        
            psCtrl=new IPM_ProjectSearchCtrl();
            psCtrl.mProjects=TRUE_STR;
            psCtrl.aProjects = TRUE_STR;
            psCtrl.selectedProjType = IPM_ConstantUtils.STATUS_ALL;
            psCtrl.selectedActiveProject = TRUE_STR;
            psCtrl.selectedStoppedProject = false;
            psCtrl.selectedPhase=ALL;
            psCtrl.geoAll = FALSE_STR;
            psCtrl.clusters ='AsiaParent';
            psCtrl.mcos ='Asia';
            psCtrl.countries= 'India';
            psCtrl.unassigned = FALSE_STR;
            psCtrl.loadProjects();
            
            system.assertEquals(1, psCtrl.projects.size() , 'All projects filter will give me 1 records');
        }
        Test.stopTest();
        
    }
    
    //Testmethod to validate all projects count when multiple projects are inserted
    static testMethod void geographiesFilterTest_geoAllFalse_unassignedTrue_countriesBlank() {
        Test.startTest();
        createTestUsers();
        System.runAs(platformUserFirst) { 
            initializeData();
        
        //Insert 5 projects in bulk in context of user1
            Map<String,Object> projMap;
            List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
            
            for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => ORIGINAL_PROJ_NAME + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
            }
            insert lstProjects;
            
            
            for(Integer i = 0 ; i < lstCountries.size() ; i++){
                    lstCountries[i].MDO_Geography__c = lstGeographies[i].Id;
                    lstCountries[i].IPM_Project__c = lstProjects[i].Id;
            }
            update lstCountries;
            
            psCtrl=new IPM_ProjectSearchCtrl();
            psCtrl.mProjects=TRUE_STR;
            psCtrl.aProjects = TRUE_STR;
            psCtrl.selectedProjType = IPM_ConstantUtils.STATUS_ALL;
            psCtrl.selectedActiveProject = TRUE_STR;
            psCtrl.selectedStoppedProject = false;
            psCtrl.selectedPhase=ALL;
            psCtrl.geoAll = FALSE_STR;
            psCtrl.clusters =IPM_ConstantUtils.BLANK;
            psCtrl.mcos =IPM_ConstantUtils.BLANK;
            psCtrl.countries= IPM_ConstantUtils.BLANK;
            psCtrl.unassigned = TRUE_STR;
            psCtrl.loadProjects();
            
            system.assertEquals(2, psCtrl.projects.size() , 'All projects filter will give me 2 records');
       }
            Test.stopTest();
    }
    
    //Testmethod to validate all projects count when multiple projects are inserted
    static testMethod void geographiesFilterTest_geoAllFalse_unassignedTrue_countriesNotBlank() {
        Test.startTest();
        createTestUsers();
        System.runAs(platformUserFirst) { 
            initializeData();
            
        //Insert 5 projects in bulk in context of user1
            Map<String,Object> projMap;
            List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
            
            for(Integer i = 0; i < 5; i++){
            projMap =  new Map<String,Object>{NAME_FIELD => ORIGINAL_PROJ_NAME + i,IPM_PHASE_FIELD=> IPM_ConstantUtils.PHASE_IDEAS ,
                                        COMPLEXITY_FIELD =>IPM_ConstantUtils.COMPLEXITY_FULL, GATEKEEPING_MODEL_FIELD => IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH, PROJECT_TYPE => IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_SPAN =>IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,COMPANY_CARD=> companyCard.Id};
            lstProjects.add((IPM_Project__c)IPM_TestFactory.createSObject(IPM_PROJECT_FIELD,projMap,TRUE));
            }
            insert lstProjects;
            
            
            for(Integer i = 0 ; i < lstCountries.size() ; i++){
                    lstCountries[i].MDO_Geography__c = lstGeographies[i].Id;
                    lstCountries[i].IPM_Project__c = lstProjects[i].Id;
            }
            update lstCountries;
        
            psCtrl=new IPM_ProjectSearchCtrl();
            psCtrl.mProjects=TRUE_STR;
            psCtrl.aProjects = TRUE_STR;
            psCtrl.selectedProjType = IPM_ConstantUtils.STATUS_ALL;
            psCtrl.selectedActiveProject = TRUE_STR;
            psCtrl.selectedStoppedProject = false;
            psCtrl.selectedPhase=ALL;
            psCtrl.geoAll = FALSE_STR;
            psCtrl.clusters ='AsiaParent';
            psCtrl.mcos ='Asia';
            psCtrl.countries= 'India';
            psCtrl.unassigned = TRUE_STR;
            psCtrl.loadProjects();
            
            system.assertEquals(2, psCtrl.projects.size() , 'All projects filter will give me 5 records');
        }
        Test.stopTest();
    }
    
    
   
    static testMethod void testGetusertype() {
        createTestUsers();
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUserFirst = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        }
        Test.startTest();
        
        System.runAs(platformUserFirst){
            psCtrl=new IPM_ProjectSearchCtrl();
            psCtrl.getusertype();
            System.assertEquals(false,psCtrl.isProjectEditable, 'ProjectEditable is Checked' );
            System.assertEquals(false,psCtrl.isBossCardEditable, 'BossCardEditable is Checked');
        }
        
        Test.stopTest();
    }
     
    
}