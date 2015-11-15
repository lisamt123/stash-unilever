/*****************************************************************************
*@Author:Cognizant
*@Date:01/02/2015
*@Description : To test ipmRolloutPlansAddController class functionalities
*/

@isTest
public class IPM_RolloutPlansAddControllerTests{
    public static IPM_Project__c project;
    public static IPM_Project_Rollout__c proRoll;
    public static String projectId;
    public static  List<String> lstTemp=new  List<String>();
    public static  IPM_Country__c ipmCountry = new IPM_Country__c();
    
    public static final String AFRICAEMERGINGMARKETS_STR = 'Africa Emerging Markets';
    public static final String ANGELO_STR = 'Angola';
    public static final String PROROLLLID_STR = 'proRoll.Id';
    public static final String TEST_ABC_STR = 'abc,abc';
    public static final String PAGEREF_STR = 'apex/ipmrolloutplansadd?id=';
    
    /**************************************************************
    *@Description :testmethod to initializeData
    */
    static void initializeData(){
        
        User PLUser = IPM_TestFactory_Helper.createUser(true); 
        project = IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.Sustainability_Period__c='3';
        project.IPM_Target_Launch_Dates__c=system.today();
        project.IPM_IsCompleted__c=true; 
        project.IPM_Project_Type__c='Original';
        //project.IPM_Company_Card__c='Global Company Card';
        project.IPM_Project_Name__c='ProjectName';
        project.IPM_Phase__c='Ideas';
        project.IPM_Brand_Positioning__c='Dirt Is Good';
        project.IPM_GateKeeping_Model__c='GCLT&RCLT';
        project.IPM_ProjectSubType__c='Innovation/Rennovation';
        project.IPM_Category_Text__c='Household Care';
        project.IPM_Project_Leader__c=PLUser.Id;
        project.IPMProject_Span__c ='PROJECT_SPAN_REGIONAL';
        insert project;


        /*
        project=IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.IPM_Phase__c='Feasibility';
        project.Sustainability_Period__c='3';
        project.IPMProject_Span__c ='PROJECT_SPAN_REGIONAL';
        insert project;
        */
        
        /*****************************Test Data Added by Shailesh***********************************************/
        List<MDO_Geography__c> mdoList = new List<MDO_Geography__c>();
        MDO_Geography__c mdmMain = new MDO_Geography__c(Name = 'World',geography_type__c = 'World', mdm_id__c = 'GEO001', Status__c='Active');
        insert mdmMain;
        MDO_Geography__c mdmMain1 = new MDO_Geography__c(Name = 'Europe',geography_type__c = 'Region', 
                                                         mdm_id__c = 'GEO004', Status__c='Active',parent_mdm_Id__c='GEO001',
                                                         parent_id__c = mdmMain.Id,parent_L1__c =mdmMain.Id,parent_mdm_id_tree__c ='GEO001');
        insert mdmMain1;
        
        MDO_Geography__c mdmMain12 = new MDO_Geography__c(Name = 'Europe',geography_type__c = 'Unilever Cluster', parent_L2__c = mdmMain.Id,
                                                         mdm_id__c = 'GEO005', Status__c='Active',parent_mdm_Id__c='GEO004',
                                                         parent_id__c = mdmMain1.Id,parent_L1__c =mdmMain1.Id,parent_mdm_id_tree__c ='GEO001,GEO004');
        insert mdmMain12;
        
        MDO_Geography__c mdmMain2 = new MDO_Geography__c(Name = 'UK & Ireland',geography_type__c = 'Country Cluster', parent_L2__c = mdmMain1.Id,
                                                         mdm_id__c = 'GEO006', Status__c='Active',parent_mdm_Id__c='GEO005',parent_L3__c = mdmMain.Id,
                                                         parent_id__c = mdmMain1.Id,parent_L1__c =mdmMain12.Id,parent_mdm_id_tree__c ='GEO001,GEO004,GEO005');
        insert mdmMain2;
        
        MDO_Geography__c mdmMain23 = new MDO_Geography__c(Name = 'UK & Ireland',geography_type__c = 'Country Group', parent_L2__c = mdmMain12.Id,parent_L4__c=mdmMain.id,
                                                         mdm_id__c = 'GEO007', Status__c='Active',parent_mdm_Id__c='GEO006',parent_L3__c = mdmMain1.Id,
                                                         parent_id__c = mdmMain1.Id,parent_L1__c =mdmMain2.Id,parent_mdm_id_tree__c ='GEO001,GEO004,GEO005,GEO006');
        insert mdmMain23;
        
        MDO_Geography__c mdmMain234 = new MDO_Geography__c(Name = 'UK & Ireland',geography_type__c = 'Country Sub Group', parent_L2__c = mdmMain2.Id,parent_L4__c=mdmMain1.id,parent_L5__c=mdmMain.Id,
                                                         mdm_id__c = 'GEO008', Status__c='Active',parent_mdm_Id__c='GEO007',parent_L3__c = mdmMain12.Id,
                                                         parent_id__c = mdmMain23.Id,parent_L1__c =mdmMain2.Id,parent_mdm_id_tree__c ='GEO001,GEO004,GEO005,GEO006,GEO007');
        insert mdmMain234;
        
        MDO_Geography__c mdmMainCountry = new MDO_Geography__c(Name = 'United Kingdom',geography_type__c = 'Country', parent_L2__c =mdmMain23.Id,parent_L4__c=mdmMain12.Id,
                                                         ISO_3166_1_alpha__c = 'GBR',ISO_3166_1_code__c ='GB',name_ISO_medium__c='United Kingdom',
                                                         name_ISO_office_english__c='UNITED KINGDOM',name_ISO_short__c='United Kingdom',name_united_nations__c='UIM00080',parent_L5__c=mdmMain1.id,parent_L6__c=mdmMain.Id,
                                                         mdm_id__c = 'GB', Status__c='Active',parent_mdm_Id__c='GEO008',parent_L3__c = mdmMain2.Id,
                                                         parent_id__c = mdmMain234.Id,parent_L1__c =mdmMain23.Id,parent_mdm_id_tree__c ='GEO001,GEO004,GEO005,GEO006,GEO007,GEO008');
        insert mdmMainCountry;
        
        
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        /****************************************************************************/
        system.assert(project.Sustainability_Period__c!=null);
        ApexPages.CurrentPage().getparameters().put('id', project.id);
        
        proRoll=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        proRoll.IPM_Project__c=project.ID;
        insert proRoll;
        system.assert(proRoll.RecordTypeId!=null);
        
        mdm_Geography__c mdmGeography = new mdm_Geography__c();
        mdmGeography.Unilever_Cluster__c = 'Africa';
        mdmGeography.Country_Group__c = AFRICAEMERGINGMARKETS_STR;
        mdmGeography.ISO_3166_1_Alpha_Code__c= 'AGO';
        mdmGeography.Region__c ='Asia/RAM';
        mdmGeography.Region_Code__c ='GEO0003';
        mdmGeography.Country_Sub_Group_Code__c = 'LV5_GEO0085';
        mdmGeography.Country_Sub_Group_Name__c = AFRICAEMERGINGMARKETS_STR;
        mdmGeography.Unilever_Cluster_Code__c = 'GEO0060';
        mdmGeography.ISO_Country_Dependency_Code__c = 'UIM00015';
        mdmGeography.Country_Cluster__c = AFRICAEMERGINGMARKETS_STR;
        mdmGeography.ISO_Country_Dependency_Medium_Name__c = ANGELO_STR;
        mdmGeography.Country_Cluster_Code__c = 'GEO0085';
        mdmGeography.ISO_Country_Dependency_Short_Name__c = ANGELO_STR;
        mdmGeography.Country_Group__c = AFRICAEMERGINGMARKETS_STR;
        mdmGeography.ISO_Country_Dependency_Office_EN_Name__c = ANGELO_STR;
        mdmGeography.Country_Group_Code__c = 'LV4_GEO0085';
        mdmGeography.Market_Type__c = 'Developing & Emerging';
        mdmGeography.ISO_Country_Dependency_Name__c = ANGELO_STR;
        mdmGeography.Market_Type_Code__c='D002';
        mdmGeography.ISO_3166_1_Num_Code__c ='024';
        mdmGeography.UN_Independent_Country__c =ANGELO_STR;
        mdmGeography.ISO_3166_1_Code__c = 'AO';
        mdmGeography.World__c = 'World';
        mdmGeography.World_Code__c='GEO0001';
        mdmGeography.ISO_Country_Dependency_Name__c = ANGELO_STR;
        insert mdmGeography;
        system.assert(mdmGeography.id!=null);
        
        ipmCountry.IPM_Project__c = project.Id;
        ipmCountry.MDO_Geography__c= mdmMainCountry.Id;
        insert ipmCountry;
        system.assert(ipmCountry.IPM_Project__c!=null);
    }
    
    /**************************************************************
    *@Description :testmethod to ChangeCluster
    */
    static testMethod void testChangeCluster() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        irp.globalCountries=TEST_ABC_STR;
        irp.regionalMco=TEST_ABC_STR;
        irp.regionalCountry=TEST_ABC_STR;
        irp.regionalNoRoll=TEST_ABC_STR;
        
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null);
        irp.changeCluster();
        System.assertEquals(irp.isEditable,false);
       // System.assert(irp.selectedCluster!=null);
        Test.stopTest();  
    } 
    
    /**************************************************************
    *@Description :testmethod to ChangeMCO
    */
    static testMethod void testChangeMCO() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null);
        
        irp.changeMCO();
        system.assert(irp.selectedKey!=null);
        
        Test.stopTest();  
    } 
    /**************************************************************
    *@Description :testmethod to DoNothing
    */
    static testMethod void testDoNothing() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null);
        Test.stopTest();  
    } 
    
    /**************************************************************
    *@Description :testmethod to SelectAllCountry
    */
    static testMethod void testSelectAllCountry() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null); 
        Test.stopTest();  
    } 
    
    /**************************************************************
    *@Description :testmethod to SelectCountries
    */
    static testMethod void testSelectCountries() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null);
        Test.stopTest(); 
    }
    
    /**************************************************************
    *@Description :testmethod to Cancel
    */
    static testMethod void testCancel() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null);
        irp.globalCountries='abc';
        irp.regionalMco=TEST_ABC_STR;
        irp.regionalCountry=TEST_ABC_STR;
        irp.regionalNoRoll=TEST_ABC_STR;
        
        PageReference pRefnew =irp.cancel();
        system.assert(pRefnew!=null);
        Test.stopTest();  
    }
    
    /**************************************************************
    *@Description :testmethod to GenerateRolloutPlans
    */
    static testMethod void testGenerateRolloutPlans() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null);
        Test.stopTest();      
    }
    
    /**************************************************************
    *@Description :testmethod to GenerateRollouts
    */
    static testMethod void testGenerateRollouts() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null);
        irp.project=project;
        irp.generateRollouts();
        system.assert(irp.project!=null);
        Test.stopTest();  
    }  
    
    
    /**************************************************************
    *@Description :testmethod to SearchRolloutCountry
    */
    static testMethod void testSearchRolloutCountry() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        irp.searchCountry = 'A';
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null);
        irp.searchRolloutCountry();
        //system.assert(irp.isNoResult==false);
        Test.stopTest();  
    }
    
    /*
    *@Description :testmethod to SearchRolloutCountry
    */
    static testMethod void testSearchRolloutCountryNULL() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null);
        irp.searchRolloutCountry();
        //system.assert(irp.isNoResult==false);
        Test.stopTest();  
    }
    
    
    /**************************************************************
    *@Description :testmethod to Redirect
    */
    static testMethod void testRedirect() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get(PROROLLLID_STR);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.searchCountry = 'United Kingdom';
        irp.project=project;
        PageReference pRef = new PageReference(PAGEREF_STR+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        system.assert(pRef!=null);
        irp.globalCountries='abc';
        irp.regionalMco=TEST_ABC_STR;
        irp.regionalCountry=TEST_ABC_STR;
        irp.regionalNoRoll=TEST_ABC_STR;
        
        PageReference pRefnew =irp.cancel();
        system.assert(pRefnew!=null);
        Test.stopTest();  
    }
    
    
    
    
}