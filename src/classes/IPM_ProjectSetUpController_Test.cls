/******************************************** 
*@Author:Cognizant
*@Date:18/08/2015
*@Description : To test IPM_ProjectSetUpController class functionalities  
*********************************************/
@isTest
private class IPM_ProjectSetUpController_Test {
    //*@Description: Object Variable decleration 
    public static Map<Id,IPM_Company_Card__c> companyCardMap;
    public static List<IPM_User_Profile__c> userProfileList;
    public static List<IPM_ProjectMetadata__c> projectMetadata;
    public static IPM_Project__c projectWithOutBoss;
    public static IPM_Bosscard__c bosscard;
    public static User userInitialize; 
    public static IPM_Market_Cluster_Short_Names__c marketClusterName;
    public static List<mdm_Brand_Position__c> brandPositionList;
    public static IPM_ProjectSetUpController  sic;
    /**************************************************
    * @description : Master data 
    ***************************************************/ 
    static void initializedData()
    {   
        //initializing the lists
        projectMetadata = new List<IPM_ProjectMetadata__c>();
        companyCardMap = new Map<Id,IPM_Company_Card__c>();
        userProfileList = new List<IPM_User_Profile__c>();
        //Insert Custom Setting of Project Metadata
        projectMetadata = IPM_TestFactory_Helper.createIPMProjectMetadata();
        //insert custom setting of IPM_Market_Cluster_Short_Names__c
        marketClusterName=IPM_TestFactory_Helper.createMarketshortName(false);
        insert marketClusterName;
        //Insert Project (without Bosscard)
        projectWithOutBoss = IPM_TestFactory_Helper.createIPMProject(false);
        ProjectWithOutBoss.IPM_PM_Approach__c=IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
        ProjectWithOutBoss.IPM_Project_Leader__c = userinfo.getuserid();
        ProjectWithOutBoss.Name='ProjectWithOutBoss';
        ProjectWithOutBoss.IPM_Project_Name__c='ProjectWithOutBoss';
        ProjectWithOutBoss.IPM_Project_Type__c='Original';
        insert projectWithOutBoss;
        List<IPM_Project__c> BDProjectList = [ SELECT Id,Name FROM IPM_Project__c WHERE Name='ProjectWithOutBoss' LIMIT 1];
        system.assertEquals(BDProjectList[0].Name,ProjectWithOutBoss.Name);
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>();
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        companyCardList.add(globalCompanyCard);
        insert companyCardList;
        for(IPM_Company_Card__c companyCard : companyCardList )
        {
            companyCardMap.put(companyCard.Id,companyCard);
        }     
        //insert User profile
        Id loggedInUser = userinfo.getuserid();
        userProfileList = IPM_TestFactory_Helper.createUserProfileList(new List<Id>{loggedInUser},companyCardList,false);  
        insert userProfileList;
        //insert Mdm Brand Positioning 
        brandPositionList = IPM_TestFactory_Helper.createMDMBrandPositionList(false);
        insert brandPositionList;
    }
    /**********************************************************************
    *@Description : processes project initiation from Single Company Card View.
    ***********************************************************************/
    public static testmethod void processSingleCompanyCard()
    {       
        initializedData();
        Test.startTest();
        PageReference pageRef = Page.IPM_ProjectSetUpView;
        Test.setCurrentPageReference(pageRef);  
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID, projectWithOutBoss.id);
        ApexPages.StandardController sc = new ApexPages.standardController(projectWithOutBoss);
        sic = new IPM_ProjectSetUpController (sc);
        initiateProjectCreation();
        sic.saveProceed();
        List<IPM_Project__c>projectList=[SELECT IPM_Project_Name__c FROM IPM_Project__c where id=:projectWithOutBoss.id LIMIT 1];
        system.assertEquals(projectList[0].IPM_Project_Name__c, projectWithOutBoss.IPM_Project_Name__c, 'Project name should be same as:'+projectList[0].IPM_Project_Name__c);
        Test.stopTest();
    }
    /**********************************************************************
    *@Description : processes project initiation from multiple Company Cards View.
    ***********************************************************************/
    public static testmethod void processMultipleCompanyCards()
    {
        initializedData();
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>();
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        companyCardList.add(localCompanyCard);      
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        companyCardList.add(regionalCompanyCard);       
        insert companyCardList;     
        for(IPM_Company_Card__c companyCard : companyCardList )
        {
            companyCardMap.put(companyCard.Id,companyCard);
        }       
        Id loggedInUser = userinfo.getuserid();
        List<IPM_User_Profile__c> tempUserProfileList = IPM_TestFactory_Helper.createUserProfileList(new List<Id>{loggedInUser},companyCardList,false);     
        insert tempUserProfileList;
        userProfileList.addAll(tempUserProfileList);    
        
        Test.startTest();
        PageReference pageRef = Page.IPM_ProjectSetUpView;
        Test.setCurrentPageReference(pageRef);  
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID,projectWithOutBoss.id);
        ApexPages.StandardController sc = new ApexPages.standardController(projectWithOutBoss);
        sic = new IPM_ProjectSetUpController (sc);  
        initiateProjectCreation();
        sic.project.IPM_Target_Launch_Dates__c = system.today();
        sic.saveProceed();
        System.assertEquals(sic.isTLDLessThnSixMnth,true);
        sic.project.IPM_Target_Launch_Dates__c = system.today().addMonths(12);
        sic.saveProceed();
        System.assertEquals(sic.isTLDLessThnSixMnth,false);
        sic.project.IPM_Project_Name__c ='These are Spe&%#_';
        sic.saveProceed();
        System.assertEquals(sic.isContainSpecialChars,true);
        // Creating project with duplicate Name
        IPM_Project__c duplicateProject = new IPM_Project__c(Name='TESTPROJECT',IPM_Project_Name__c='TESTPROJECT');
        insert duplicateProject;
        // Set the same project Name
        sic.project.IPM_Project_Name__c ='TESTPROJECT';
        sic.saveProceed();
        System.assertEquals(sic.project.IPM_IsSaved__c,false);
        // Set the same project Name
        sic.project.IPM_Project_Name__c ='TESTPROJECTNEW';
        sic.saveProceed();
        sic.saveIPMApproach();
        sic.saveComplexityType();
        //System.assertEquals(sic.isContainSpecialChars,false);
        //System.assertEquals(sic.isTLDLessThnSixMnth,false);
        //System.assertEquals(sic.isBusinessError,false);
        List<IPM_Project__c> projectList = [Select Id,Name from IPM_Project__c where IPM_Project_Name__c='TESTPROJECTNEW'];
        System.assertEquals(projectList.size(),1);
        Test.stopTest();
    }
    /**************************************************************
    *@Description :executes the core logic and asserts for project initiation.
    ***************************************************************/
    public static void initiateProjectCreation()
    {       
        List<SelectOption> companyCardSelect = sic.getAllcompanycard();     
        if(companyCardSelect.size() > 2)
        {
            // Error Scenario
            sic.populateCategory();
            System.assertEquals(sic.isBusinessError,true);
        }       
        System.assertEquals(companyCardMap.size(), (companyCardSelect.size() -1 ) );        
        // Error Scenario
        sic.saveProceed();      
        System.assertEquals(sic.isBusinessError,true);      
        for(SelectOption selectCC : companyCardSelect)
        {
            if(selectCC.getValue() !=null && !String.isBlank(selectCC.getValue()) )
            {
                sic.project.IPM_Company_Card__c = selectCC.getValue();          
                IPM_Company_Card__c selectedCompanyCard = companyCardMap.get(sic.project.IPM_Company_Card__c);              
                // Update Company Card Text 
                sic.populateCategory();     
                List<SelectOption> categorySelect = sic.getCategory();
                System.assertEquals(selectedCompanyCard.IPM_Managed_category__c.split(IPM_ConstantUtils.DELIMITER).size(), (categorySelect.size() - 1 ) );              
                sic.saveProceed();      
                System.assertEquals(sic.isBusinessError,true);      
                for(SelectOption managedCategory : categorySelect)
                {
                    if(managedCategory.getValue() != null && !String.isBlank(managedCategory.getValue()) )
                    {
                        //System.assert( (selectedCompanyCard.IPM_Managed_category__c).contains(managedCategory.getValue())); 
                        sic.project.IPM_Category_Text__c = managedCategory.getValue();
                    }       
                }               
                List<SelectOption> brandPosOptionList = sic.getBrandPos();
                if(brandPosOptionList.size()>1){
                	sic.project.IPM_Brand_Positioning__c = brandPosOptionList[1].getValue();  
                }
                // Error Scenario
                sic.getGateKeepingModels();
                System.assertEquals(sic.isBusinessError,true);              
                List<SelectOption> selectProjectType = sic.getProjectSubTypes();                
                // Error Scenario
                sic.saveProceed();
                System.assertEquals(sic.isBusinessError,true);              
                for(SelectOption subProjectType : selectProjectType)
                {
                    sic.project.IPM_ProjectSubType__c = subProjectType.getValue();
                    sic.getHelpTextProjectSubType();                
                    sic.populateProjectInformation();
                    //System.assert(sic.projectMetadata.IPM_ProjectSubType__c.contains(sic.project.IPM_ProjectSubType__c));
                    System.assertEquals(sic.project.IPM_Project_Type__c,sic.projectMetadata.IPM_Project_Type__c);
                    System.assertEquals(sic.project.IPMProject_Span__c,sic.projectMetadata.IPM_Project_Span__c);
                    System.assertEquals(sic.project.IPM_Phase__c,sic.projectMetadata.IPM_DefaultPhase__c);
                    System.assertEquals(sic.project.IPM_Complexity__c,sic.projectMetadata.IPM_DefaultComplexity__c);
                    List<SelectOption> gateKeepingSelect = sic.getGateKeepingModels();
                    if(sic.projectMetadata.IPM_GatekeepingModelsApplicable__c)
                    {
                        sic.getHelpTextGateKeeping();
                        for(SelectOption GKModel : gateKeepingSelect)
                        {
                            sic.project.IPM_GateKeeping_Model__c =GKModel.getValue();
                            System.assert(sic.projectMetadata.IPM_ApplicableGateKeepingModels__c.contains(GKModel.getValue()));
                        }
                    }
                    else
                    {
                        System.assertEquals(gateKeepingSelect.size(),0);
                    }
                }
            }
        }
    }
    
    /**************************************************************
    *@Description :testmethod to get logged in user type
    ***************************************************************/
    static testmethod void testgetMilesTaskIpmuserType1(){
        initializedData();
        PageReference pageRef = Page.IPM_ProjectSetUpView;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID, projectWithOutBoss.id);
        ApexPages.StandardController sc = new ApexPages.standardController(projectWithOutBoss);       
        sic = new IPM_ProjectSetUpController(sc);
        User u4 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(u4.id, null);//positive test
        IPM_Project_Resource__c  ipmProjectResource1 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource1.IPM_Role_Type__c = 'CMI';
        ipmProjectResource1.IPM_User__c = u4.id;
        insert ipmProjectResource1;
        system.runAs(u4){
            System.assertNotEquals(ipmProjectResource1.id, null);//positive test
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            //system.assert(sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        Test.startTest();
        User u5 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(u5.id, null);//positive test
        IPM_Project_Resource__c  ipmProjectResource2 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource2.IPM_User__c = u5.id;
        ipmProjectResource2.IPM_Role_Type__c='BD';
        insert ipmProjectResource2;
        system.runAs(u5){
            System.assertNotEquals(ipmProjectResource2.id, null);//positive test
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(!sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        Test.stopTest();   
    }
    /**************************************************************
    *@Description :testmethod to get logged in user type
    ***************************************************************/
    static testmethod void testgetMilesTaskIpmuserType2(){
        Test.startTest();
        initializedData();
        PageReference pageRef = Page.IPM_ProjectSetUpView;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID, projectWithOutBoss.id);
        ApexPages.StandardController sc = new ApexPages.standardController(projectWithOutBoss); 
        sic = new IPM_ProjectSetUpController (sc);      
        User u6 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(u6.id, null);//positive test
        IPM_Project_Resource__c  ipmProjectResource3 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource3.IPM_Role_Type__c = 'R&D';
        ipmProjectResource3.IPM_User__c = u6.id;
        insert ipmProjectResource3;//insert ipm resource
        system.runAs(u6)
        {
            System.assertNotEquals(ipmProjectResource3.id, null);//positive test
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(!sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        Test.stopTest();
    }
    /**************************************************************
    *@Description :testmethod to get logged in user type
    ***************************************************************/
    static testmethod void testgetMilesTaskIpmuserType3(){
        initializedData();
        PageReference pageRef = Page.IPM_ProjectSetUpView;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID, projectWithOutBoss.id);
        ApexPages.StandardController sc = new ApexPages.standardController(projectWithOutBoss);
        sic = new IPM_ProjectSetUpController (sc);
        Test.startTest();
        User u7 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(u7.id, null);//positive test
        IPM_Project_Resource__c  ipmProjectResource4 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource4.IPM_Role_Type__c = 'CD';
        ipmProjectResource4.IPM_User__c = u7.id;
        insert ipmProjectResource4;
        system.runAs(u7){
            System.assertNotEquals(ipmProjectResource4.id, null);//positive test
            sic.project.IPM_Project_Gatekeeper__c=u7.id;
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(!sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        User newUsr = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(newUsr.id, null);//positive test
        IPM_Project_Resource__c  ipmProjectResource5 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource5.IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN;
        ipmProjectResource5.IPM_User__c = newUsr.id;
        insert ipmProjectResource5;
        system.runAs(newUsr){
            System.assertNotEquals(ipmProjectResource5.id, null);//positive test
            sic.project.IPM_Project_Gatekeeper__c=newUsr.id;
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(!sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        User newUsr1 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(newUsr1.id, null);//positive test
        IPM_Project_Resource__c  ipmProjectResource6 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource6.IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_FINANCE;
        ipmProjectResource6.IPM_User__c = newUsr1.id;
        insert ipmProjectResource6;
        system.runAs(newUsr1){
            System.assertNotEquals(ipmProjectResource6.id, null);//positive test
            sic.project.IPM_Project_Gatekeeper__c=newUsr1.id;
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(!sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        User newUsr2 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(newUsr2.id, null);//positive test
        IPM_Project_Resource__c  ipmProjectResource7 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource7.IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_BB;
        ipmProjectResource7.IPM_User__c = newUsr2.id;
        insert ipmProjectResource7;
        system.runAs(newUsr2){
            System.assertNotEquals(ipmProjectResource7.id, null);//positive test
            sic.project.IPM_Project_Gatekeeper__c=newUsr2.id;
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(!sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        Test.stopTest(); 
    } 
   /**************************************************************
    *@Description :testmethod to get logged in user type
    **************************************************************/
    static testmethod void testgetMilesTaskIpmuserType4(){
        initializedData();
        PageReference pageRef = Page.IPM_ProjectSetUpView;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID, projectWithOutBoss.id);
        ApexPages.StandardController sc = new ApexPages.standardController(projectWithOutBoss);
        sic = new IPM_ProjectSetUpController (sc);
        test.startTest();
        User u8 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(u8.id, null);//positive test
        sic.project.IPM_Project_Gatekeeper__c=u8.id;//assign gatekeeper user to project
        system.runAs(u8){
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            //Under development 
            //system.assert(!sic.isTaskeditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
            //system.assertNotEquals(sic.isTaskeditable,true);//negative test
        }
        User u9 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(u9.id, null);//positive test
        sic.project.Deputy_Project_Leader__c=u9.id;
        system.runAs(u9){
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(sic.isTaskeditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        User u10 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(u10.id, null);//positive test
        sic.project.IPM_Technical_Project_Leader__c=u10.id;
        system.runAs(u10){
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(sic.isTaskeditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        test.stopTest();    
    }
}