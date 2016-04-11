/******************************************** 
*@Author:Cognizant
*@Date:18/08/2015
*@Description : To test IPM_ProjectSetUpController class functionalities  
*********************************************/
@isTest
private class IPM_ProjectSetUpController_Test {
    //*@Description: Object Variable decleration 
    private static Map<Id,IPM_Company_Card__c> companyCardMap;
    private static List<IPM_User_Profile__c> userProfileList;
    public static List<IPM_Project__c> projectDependents;
    public static IPM_Project__c projectWithOutBoss;
    public static MDO_BrandPositions__c mdoBrandPositions;
    public static User userInitialize; 
    public static IPM_Market_Cluster_Short_Names__c marketClusterName;
    public static IPM_ProjectSetUpController  sic;
    /**************************************************
    * @description : Master data 
    ***************************************************/ 
    static void initializedData()
    {   
        system.runAs(IPM_TestFactory_Helper.createUserAdmin(false)){
            //Insert user
            userInitialize = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
            
        }
        List<User>plUserList=new List<User>();
        plUserList.add(userInitialize);
        //initializing the lists
        companyCardMap = new Map<Id,IPM_Company_Card__c>();
        userProfileList = new List<IPM_User_Profile__c>();
        //Insert Custom Setting of Project Metadata
        IPM_TestFactory_Helper.createIPMProjectMetadata();
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
        ProjectWithOutBoss.IPM_Project_Leader__c=userInitialize.id;
        insert projectWithOutBoss;
        List<IPM_Project__c> BDProjectList = [ SELECT Id,Name FROM IPM_Project__c WHERE Name='ProjectWithOutBoss' LIMIT 1];
        system.assertEquals(BDProjectList[0].Name,ProjectWithOutBoss.Name);
        
        List<IPM_Project__Share>projectShareList=IPM_TestFactory_Helper.shareIPMProject(BDProjectList,plUserList);
        insert projectShareList;
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>();
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        companyCardList.add(globalCompanyCard);
        insert companyCardList;
        for(IPM_Company_Card__c companyCard : companyCardList )
        {
            companyCardMap.put(companyCard.Id,companyCard);
        } 
        
        //Insert MDO Brand Positions
        mdoBrandPositions = IPM_TestFactory_Helper.createMDOBrandPositions(false);
        insert mdoBrandPositions;
        
        
        //Initialize BET data
        uw_bet__c bet = BET_TestUtils.getTestBet();
        insert bet;
        
        List<uw_bet__c>betList=[SELECT ID FROM uw_bet__c WHERE ID=:bet.id LIMIT 1];
        system.assertEquals(betList[0].id,bet.id,'bet id is:'+betList[0].id);

        ProjectWithOutBoss.BET_Link_Requested__c = null;
        ProjectWithOutBoss.bet__c = bet.id;
        update ProjectWithOutBoss;
        
        //insert User profile
        Id loggedInUser = userinfo.getuserid();
        userProfileList = IPM_TestFactory_Helper.createUserProfileList(new List<Id>{loggedInUser},companyCardList,false);  
        insert userProfileList;
    }
    /**********************************************************************
    *@Description : processes project initiation from Single Company Card View.
    ***********************************************************************/
    public static testmethod void processSingleCompanyCard()
    {       
        initializedData();
        Test.startTest();
        system.runAs(userInitialize){
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
            sic.hideProjectSuggetion();
            sic.searchDuplicateProject();
        }
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
        sic.searchDuplicateProject();
        // Set the same project Name
        sic.project.IPM_Project_Name__c ='TESTPROJECT';
        sic.saveProceed();
        System.assertEquals(sic.project.IPM_IsSaved__c,false);
        Test.stopTest();
        // Set the same project Name
        sic.project.IPM_Project_Name__c ='TESTPROJECTNEW';
        sic.saveProceed();
        sic.saveIPMApproach();
        sic.saveComplexityType();
        sic.removeProjectLogo();
        sic.none();
        System.assertEquals(sic.project.IPM_Project_Logo_Id__c,'');
        
        sic.projectMetadata.IPM_MultipleBrandPosApplicable__c=true;
        sic.project.IPM_Brand_Positioning__c='val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13,val14,val15,val16,val17,val18,val19,val20,val21,val22,val23,val24';
        sic.saveProceed();
        System.assertEquals(sic.isMaxBrandPosition,true);
        //String[] maxBrandPosition =sic.project.IPM_Brand_Positioning__c.split(IPM_ConstantUtils.COMMA);
        
        IPM_ProjectSetupController.savetabname('testtab',string.valueOf(sic.project.id));
        
        List<IPM_Project__c> projectList = [Select Id,Name from IPM_Project__c where IPM_Project_Name__c='TESTPROJECTNEW'];
        System.assertEquals(projectList.size(),1);
        system.runAs(userInitialize){
            sic.project.Name='Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name ';
            sic.processProjectSave();
            sic.project.IPM_Project_Job_Status__c= IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
            sic.initialise();
            sic.removeProjectLogo();
            
            sic.projectMetadata.IPM_FastTrackApplicable__c=false;
            sic.projectMetadata.IPM_WhiteSpaceApplicable__c=false;
            System.assertEquals(sic.project.IPM_White_Space_Project__c,false);    
            System.assertEquals(sic.project.IPM_Fast_Track_Project__c,false);  
            
            if(sic.project.IPM_GateKeepingModel__c.equals(IPM_Utils.GATE_KEEPING_MODEL_1) || sic.project.IPM_GateKeepingModel__c.equals(IPM_Utils.GATE_KEEPING_MODEL_2))
            	{
            		System.assertEquals(sic.project.IPM_Approver_of_Charter__c, sic.projectMetadata.IPM_DefaultCharterQuestionAnswer__c);
            	} 
			sic.processProjectSave();
        }
        
        
        
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
        //System.assertEquals(companyCardMap.size(), (companyCardSelect.size() -1 ) );        
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
                        System.assert( (selectedCompanyCard.IPM_Managed_category__c).contains(managedCategory.getValue())); 
                        sic.project.IPM_Category_Text__c = managedCategory.getValue();
                    }       
                }               
                List<SelectOption> brandPosOptionList = sic.getBrandPos();
                if(brandPosOptionList.size()>1){
                    sic.project.IPM_Brand_Positioning__c = brandPosOptionList[1].getValue();  
                }
				sic.project.IPM_Brand_Positioning__c='Dove';
				
				sic.getBrandPos();
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
                    List<SelectOption> charterApproverSelect = sic.getCharterApprovers();
                    List<SelectOption> gateKeepingSelect = sic.getGateKeepingModels();
                    if(sic.projectMetadata.IPM_GatekeepingModelsApplicable__c)
                    {
                        sic.getHelpTextCharterQuestions();
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
    *@Description :testmethod to set TLD editable. setIsTLDFieldEditable()
    ***************************************************************/
    static testmethod void testsetIsTLDFieldEditable(){
        initializedData();
        test.startTest();
        system.runAs(userInitialize){
            projectDependents = IPM_TestFactory_Helper.projectSetup(1,userInitialize);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID,projectWithOutBoss.id);
            ApexPages.StandardController sc = new ApexPages.standardController(projectWithOutBoss);
            sic = new IPM_ProjectSetUpController (sc); 
            sic.project = projectDependents[0];
            IPM_Project_Document__c projectGateDocument=IPM_TestFactory_Helper.createIPMProjectDocument(false);
    
            sic.project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL ;
            sic.project.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE ;
            sic.setIsTLDFieldEditable(); 
            
            sic.project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL ;
            sic.project.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            sic.setIsTLDFieldEditable(); 
            
            sic.project.IPM_Phase__c =IPM_ConstantUtils.FEASIBILITY_PHASE ;
            sic.project.IPMProject_Span__c = IPM_ConstantUtils.IPMREGIONAL;
            sic.project.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            sic.setIsTLDFieldEditable(); 
            
            sic.project.IPM_Phase__c =IPM_ConstantUtils.PHASE_PLE;
            sic.project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            sic.project.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            sic.setIsTLDFieldEditable();
            
            sic.project.IPM_Phase__c =IPM_ConstantUtils.PHASE_MARKET_READY;
            sic.project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            sic.project.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            sic.setIsTLDFieldEditable();
        
            sic.project.IPM_Phase__c =IPM_ConstantUtils.PHASE_CAPABILITY;
            sic.setIsTLDFieldEditable();
            system.assertEquals(sic.isTLDFieldEditable,false);
        }
        test.stopTest();
    }
    
    /**************************************************************
    *@Description :testmethod to get logged in user type
    ***************************************************************/
    static testmethod void testgetMilesTaskIpmuserType1(){
        initializedData();
        List<User>userShareList=new List<User>();
        PageReference pageRef = Page.IPM_ProjectSetUpView;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID, projectWithOutBoss.id);
        ApexPages.StandardController sc = new ApexPages.standardController(projectWithOutBoss);       
        sic = new IPM_ProjectSetUpController(sc);
        sic.isImage=false;
        sic.isBDuser=false;
        sic.isvisible =false;
        sic.functionRole='';
        sic.projbetlink='';
        sic.project.BET_Link_Requested__c='Test';
        //sic.datename='';
        sic.ImageId=ApexPages.currentPage().getParameters().get('image');   
        /*IPM_Task__c projectTask =IPM_TestFactory_Helper.createIPMTask(sic.project.id,FALSE);
        projectTask.IPM_Project__c=sic.project.id;
        insert projectTask;*/
        User u4 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(u4.id, null);//positive test
        userShareList.add(u4);
        IPM_Project_Resource__c  ipmProjectResource = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource.IPM_User__c=u4.id;
        ipmProjectResource.IPM_Project__c = sic.project.id; 
        insert ipmProjectResource;
        IPM_Project_Resource__c  ipmProjectResource1 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource1.IPM_Role_Type__c = 'CMI';
        ipmProjectResource1.IPM_User__c = u4.id;
        insert ipmProjectResource1;
        User u5 = IPM_TestFactory_Helper.createUser(true);
        System.assertNotEquals(u5.id, null);//positive test
        userShareList.add(u5);
        IPM_Project_Resource__c  ipmProjectResource2 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource2.IPM_User__c = u5.id;
        ipmProjectResource2.IPM_Role_Type__c='BD';
        insert ipmProjectResource2;
		List<IPM_Project__c>shareProjectLst=new List<IPM_Project__c>();
        shareProjectLst.add(projectWithOutBoss);
        List<IPM_Project__Share>projectShareList=IPM_TestFactory_Helper.shareIPMProject(shareProjectLst,userShareList);
        insert projectShareList;
        system.runAs(u4){ 
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
        }
        system.runAs(u4){
            System.assertNotEquals(ipmProjectResource1.id, null);//positive test
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            //system.assert(sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        Test.startTest();
        system.runAs(u5){
            System.assertNotEquals(ipmProjectResource2.id, null);//positive test
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(!sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        Test.stopTest();   
    }
    
}