/******************************************** 
*@Author:Cognizant
*@Date:18/08/2015
*@Description : To test IPM_ProjectSetUpController class functionalities  
*********************************************/
@isTest
private class IPM_ProjectSetUpController_Test {
    //*@Description: Object Variable decleration 
<<<<<<< HEAD
    public static Map<Id,IPM_Company_Card__c> companyCardMap;
    public static List<IPM_User_Profile__c> userProfileList;
    //public static List<IPM_Project_Resource__c> ipmProjectResourcex;
    public static List<IPM_ProjectMetadata__c> projectMetadata;
    public static List<IPM_Project__c> projectDependents;
    public static IPM_Project__c projectWithOutBoss;
    public static IPM_Bosscard__c bosscard;
    public static MDO_BrandPositions__c mdoBrandPositions;
    public static User userInitialize; 
    public static IPM_Market_Cluster_Short_Names__c marketClusterName;
    //public static IPM_Project_Rollout__c childProject;
    public static IPM_ProjectSetUpController  sic;
=======
    private static Map<Id,IPM_Company_Card__c> companyCardMap= new Map<Id,IPM_Company_Card__c>();
    private static List<IPM_User_Profile__c> userProfileList= new List<IPM_User_Profile__c>();
    private static string ProjectName='ProjectWithOutBoss';
    private static IPM_Project__c projectWithOutBoss;
    private static User userInitialize; 
    private static IPM_ProjectSetUpController  sic;  
    private static final string GOT_ERROR_STRING='got error while saving a project';
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
    /**************************************************
    * @description : Master data 
    ***************************************************/ 
    @testSetup static void initializedData()
    {   
        system.runAs(IPM_TestFactory_Helper.createUserAdmin(false)){
            //Insert user
            userInitialize = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
            
        }
        List<User>plUserList=new List<User>();
<<<<<<< HEAD
        plUserList.add(userInitialize);
        //initializing the lists
        projectMetadata = new List<IPM_ProjectMetadata__c>();
        companyCardMap = new Map<Id,IPM_Company_Card__c>();
        userProfileList = new List<IPM_User_Profile__c>();
        //Insert Custom Setting of Project Metadata
        projectMetadata = IPM_TestFactory_Helper.createIPMProjectMetadata();
=======
        plUserList.add(userInitialize);        
        
        MDO_BrandPosition__c mdoBPosition=new MDO_BrandPosition__c();
		mdoBPosition.Name='Lux';
		mdoBPosition.status__c=ipm_constantutils.BRANDPOSITION_STATUS_ACTIVE;
		insert mdoBPosition;
		
		List<MDO_BrandPosition__c>mdoBrandPosList=[SELECT Name FROM MDO_BrandPosition__c WHERE ID=:mdoBPosition.ID LIMIT 1];
		system.assertEquals(mdoBrandPosList[0].Name,mdoBPosition.Name,'brand position name is not matched');
		
		MDO_Category__c mdoCategory=new MDO_Category__c();
		mdoCategory.Name='Household Care';
		insert mdoCategory;
		
		List<MDO_Category__c>mdoCategoryList=[SELECT Name FROM MDO_Category__c WHERE ID=:mdoCategory.ID LIMIT 1];
		system.assertEquals(mdoCategoryList[0].Name,mdoCategory.Name,'mdo category name is not matched');
		
		MDO_Category__c mdoCategories=new MDO_Category__c();
		mdoCategories.Name='House Care';
		mdoCategories.parent_id__c=mdoCategory.id;
		insert mdoCategories;
		
		List<MDO_Category__c>mdoCategoriesList=[SELECT Name FROM MDO_Category__c WHERE ID=:mdoCategories.ID LIMIT 1];
		system.assertEquals(mdoCategoriesList[0].Name,mdoCategories.Name,'mdo parent category name is not matched');
		
		
		MDO_BrandPositions__c mdoBrandPositions=new MDO_BrandPositions__c();
		mdoBrandPositions.status__c=ipm_constantutils.BRANDPOSITION_STATUS_ACTIVE;
		mdoBrandPositions.brand_position_id__c=mdoBPosition.id;
		mdoBrandPositions.product_category_id__c=mdoCategories.id;
		insert mdoBrandPositions;
		
		List<MDO_BrandPositions__c>mdoBPositionsList=[SELECT brand_position_id__c FROM MDO_BrandPositions__c WHERE ID=:mdoBrandPositions.ID LIMIT 1];
		system.assertEquals(mdoBPositionsList[0].brand_position_id__c,mdoBrandPositions.brand_position_id__c,'mdo brand positions id is not matched');
    
	//Insert Custom Setting of Project Metadata
     	IPM_TestFactory_Helper.createIPMProjectMetadata();
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        //insert custom setting of IPM_Market_Cluster_Short_Names__c
        IPM_TestFactory_Helper.createMarketshortName(true);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>();
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        companyCardList.add(globalCompanyCard);
        insert companyCardList;
        List<IPM_Company_Card__c> compCardList =[SELECT NAME FROM IPM_Company_Card__c WHERE Name='Test Company Card' LIMIT 1];
        system.assertEquals(compCardList[0].Name,companyCardList[0].Name,'Company card name is:'+compCardList[0].Name);
        for(IPM_Company_Card__c companyCard : companyCardList )
        {
            companyCardMap.put(companyCard.Id,companyCard);
        } 
        
        //Insert Project (without Bosscard)
        projectWithOutBoss = IPM_TestFactory_Helper.createIPMProject(false);
        ProjectWithOutBoss.IPM_PM_Approach__c=IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
        ProjectWithOutBoss.IPM_Project_Leader__c = userinfo.getuserid();
        ProjectWithOutBoss.Name=ProjectName;
        ProjectWithOutBoss.IPM_Project_Name__c=ProjectName;
        ProjectWithOutBoss.IPM_Project_Type__c='Original';
        ProjectWithOutBoss.IPM_Project_Leader__c=userInitialize.id;
        ProjectWithOutBoss.IPM_Company_Card__c=globalCompanyCard.id;
        ProjectWithOutBoss.IPM_Category_Text__c='Household Care';
        insert projectWithOutBoss;
        List<IPM_Project__c> BDProjectList = [ SELECT Id,Name FROM IPM_Project__c WHERE Name=:ProjectWithOutBoss.Name LIMIT 1];
        system.assertEquals(BDProjectList[0].Name,ProjectWithOutBoss.Name,'Project name is :'+BDProjectList[0].Name);
        
        List<IPM_Project__Share>projectShareList=IPM_TestFactory_Helper.shareIPMProject(BDProjectList,plUserList);
        insert projectShareList;
        List<IPM_Project__Share>projShareList=[SELECT ParentId from IPM_Project__Share WHERE ParentId=:BDProjectList[0].id LIMIT 1];
        system.assertEquals(projShareList[0].ParentId,BDProjectList[0].id,'shareed project id is:'+projShareList[0].ParentId);
        
        IPM_Milestone__c proMiles=new IPM_Milestone__c();
        proMiles.Name=IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE;
        proMiles.IPM_Due_Date__c=system.today().addMonths(12);
        proMiles.IPM_Name__c=IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE;
        proMiles.IPM_Project__c=projectWithOutBoss.id;
        proMiles.IPM_Active__c = true;
        insert proMiles;
        
        List<IPM_Milestone__c> milestones = [Select IPM_Due_Date__c from IPM_Milestone__c where IPM_Project__c =: projectWithOutBoss.id and IPM_Active__c = true and IPM_Name__c =: IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE limit 1];
        system.assertEquals(milestones[0].IPM_Due_Date__c,system.today().addMonths(12),'milestone date is not matching');
        
        
        
        //Insert MDO Brand Positions
        IPM_TestFactory_Helper.createMDOBrandPositions(true);
        //Initialize BET data
        uw_bet__c bet = BET_TestUtils.getTestBet();
        insert bet;
        
        List<uw_bet__c>betList=[SELECT ID FROM uw_bet__c WHERE ID=:bet.id LIMIT 1];
        system.assertEquals(betList[0].id,bet.id,'bet id is:'+betList[0].id);

        ProjectWithOutBoss.BET_Link_Requested__c = null;
        ProjectWithOutBoss.bet__c = bet.id;
        update ProjectWithOutBoss;
        List<IPM_Project__c> ProjList = [ SELECT Id,bet__c FROM IPM_Project__c WHERE id=:ProjectWithOutBoss.id LIMIT 1];
        system.assertEquals(ProjList[0].bet__c,bet.id,'bet id is :'+ProjList[0].bet__c);
        
        //insert User profile
        Id loggedInUser = userinfo.getuserid();
        userProfileList = IPM_TestFactory_Helper.createUserProfileList(new List<Id>{loggedInUser},companyCardList,false);  
        insert userProfileList;
        
        List<IPM_User_Profile__c> usrProfileList=[SELECT IPM_User__c FROM IPM_User_Profile__c WHERE IPM_User__c=:loggedInUser LIMIT 1];
        system.assertEquals(usrProfileList[0].IPM_User__c,loggedInUser,'user profile user id is:'+usrProfileList[0].IPM_User__c);
    }
    /**********************************************************************
    *@Description : get all initialised values from @testSetup method
    ***********************************************************************/
    static void getPagerefences(){
        
        //create custom setting data for TLD validation
        IPM_TLD_Restriction__c restTLD = new IPM_TLD_Restriction__c(); 
        restTLD.name = 'InEffect?';
        restTLD.IPM_TLD_Restriction_In_Effect__c=false;
        insert restTLD;
        
        userInitialize=[Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        List<IPM_Company_Card__c> compCardList =[SELECT NAME FROM IPM_Company_Card__c WHERE Name='Test Company Card' LIMIT 1];
        
        for(IPM_Company_Card__c companyCard : compCardList )
        {
            companyCardMap.put(companyCard.Id,companyCard);
        } 
        projectWithOutBoss= [ SELECT Id,Name,IPM_Project_Name__c FROM IPM_Project__c WHERE Name=:ProjectName LIMIT 1];
        PageReference pageRef = Page.IPM_ProjectSetUpView;
        Test.setCurrentPageReference(pageRef);  
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID, projectWithOutBoss.id);
        ApexPages.CurrentPage().getparameters().put('image','images');
        ApexPages.StandardController sc = new ApexPages.standardController(projectWithOutBoss);
        sic = new IPM_ProjectSetUpController (sc);
    }
    
    
    /**********************************************************************
    *@Description : processes project initiation from Single Company Card View.
    ***********************************************************************/
    private static testmethod void processSingleCompanyCard()
    {       
        getPagerefences();
        Test.startTest();
        system.runAs(userInitialize){
            
            initiateProjectCreation();
            sic.saveProceed();//save project details
            
            List<IPM_Project__c>projectList=[SELECT IPM_Project_Name__c,IPM_Company_Card__c FROM IPM_Project__c where id=:projectWithOutBoss.id LIMIT 1];
            system.assertEquals(projectList[0].IPM_Project_Name__c, projectWithOutBoss.IPM_Project_Name__c, 'Project name should be same as:'+projectList[0].IPM_Project_Name__c);
            sic.hideProjectSuggetion();
            sic.searchDuplicateProject();
            boolean isTDL=false;
            isTDL=sic.isProjectTLDBeforeMilestoneGates(system.today());
            system.assertEquals(isTDL,true,'isTLD is false');
            IPM_ProjectSetupController.savetabname('testtab',null);
            sic.project.IPM_PM_Approach__c='External';
            sic.saveIPMApproach();
            system.assertEquals(sic.project.IPM_PM_Approach__c,IPM_ConstantUtils.IPM_APPROACH_INTERNAL,'IPM approach is not internal');
            
            sic.project.IPM_Category_Text__c='Household Care';
            sic.project.IPM_Region_Shr__c='Global';
            sic.project.IPM_CompanyCardText__c=IPM_ConstantUtils.COMPANY_CARD_GLOBAL;
            sic.project.IPM_Brand_Positioning__c='Lux';
            sic.getBrandPos();
                
            
        }
        Test.stopTest(); 
    }
    /**********************************************************************
    *@Description : processes project initiation from multiple Company Cards View.
    ***********************************************************************/
    private static testmethod void processMultipleCompanyCards()
    {
        getPagerefences();
        
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
        initiateProjectCreation();
        sic.project.IPM_Target_Launch_Dates__c = system.today()+1;
        sic.saveProceed();
        System.assertEquals(sic.isTLDLessThnSixMnth,true,'TLD date is less than six month');
        sic.project.IPM_Target_Launch_Dates__c = system.today().addMonths(12);
        sic.saveProceed();
        System.assertEquals(sic.isTLDLessThnSixMnth,false,'TLD date is more than six month');
        sic.project.IPM_Project_Name__c ='These are Spe&%#_';
        sic.saveProceed();
        
        System.assertEquals(sic.isContainSpecialChars,true,'Project name contains special character');
        // Creating project with duplicate Name
        IPM_Project__c duplicateProject = new IPM_Project__c(Name='TESTPROJECT',IPM_Project_Name__c='TESTPROJECT');
        insert duplicateProject;
        sic.searchDuplicateProject();
        // Set the same project Name
        sic.project.IPM_Project_Name__c ='TESTPROJECT';
        sic.saveProceed();
        System.assertEquals(sic.project.IPM_IsSaved__c,false,'Project is not saved');
        
        // Set the same project Name
        sic.project.IPM_Project_Name__c ='TESTPROJECTNEW';
        sic.saveProceed();
        sic.saveIPMApproach();
        system.assertEquals(sic.project.IPM_PM_Approach__c,IPM_ConstantUtils.IPM_APPROACH_EXTERNAL,'IPM approach is not external');
        sic.saveComplexityType();
        sic.ComplexityType='';
        sic.saveComplexityType();
        sic.removeProjectLogo();
        sic.none();
        System.assertEquals(sic.project.IPM_Project_Logo_Id__c,'','Project logo id is Empty');
        Test.stopTest();
        sic.projectMetadata.IPM_MultipleBrandPosApplicable__c=true;
        sic.project.IPM_Brand_Positioning__c='val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13,val14,val15,val16,val17,val18,val19,val20,val21,val22,val23,val24';
        sic.saveProceed();
        System.assertEquals(sic.isMaxBrandPosition,true,'User has selected more than 20 brand positions');
        
        IPM_ProjectSetupController.savetabname('testtab',string.valueOf(sic.project.id));
        
        List<IPM_Project__c> projectList = [Select Id,Name,IPM_Project_Name__c from IPM_Project__c where IPM_Project_Name__c='TESTPROJECTNEW' LIMIT 1];
        System.assertEquals(projectList.size(),1,'project got saved with updated project name as:'+projectList[0].IPM_Project_Name__c);
        system.runAs(userInitialize){
            sic.project.Name='Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name Invalid project name ';
            sic.processProjectSave();
            sic.project.IPM_Project_Job_Status__c= IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
            sic.initialise();
            sic.removeProjectLogo();
            sic.projectMetadata.IPM_FastTrackApplicable__c=false;
            sic.projectMetadata.IPM_WhiteSpaceApplicable__c=false;
<<<<<<< HEAD
            System.assertEquals(sic.project.IPM_White_Space_Project__c,false);    
            System.assertEquals(sic.project.IPM_Fast_Track_Project__c,false);    
			sic.processProjectSave();
=======
            System.assertEquals(sic.project.IPM_White_Space_Project__c,false,'User marked project as without white space');    
            System.assertEquals(sic.project.IPM_Fast_Track_Project__c,false,'User marked project as without fast track');   
            if(sic.project.IPM_GateKeepingModel__c.equals(IPM_Utils.GATE_KEEPING_MODEL_1) || sic.project.IPM_GateKeepingModel__c.equals(IPM_Utils.GATE_KEEPING_MODEL_2))
            {
                System.assertEquals(sic.project.IPM_Approver_of_Charter__c, sic.projectMetadata.IPM_DefaultCharterQuestionAnswer__c);
            }  
            sic.processProjectSave();
            List<IPM_Project__c> updatedProjectList = [ SELECT Id,IPM_White_Space_Project__c FROM IPM_Project__c WHERE Id=:ProjectWithOutBoss.id LIMIT 1];
            system.assertEquals(updatedProjectList[0].IPM_White_Space_Project__c,false,'Project white space is :'+updatedProjectList[0].IPM_White_Space_Project__c);
            
            
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        }
        
        
        
    }
    /**************************************************************
    *@Description :executes the core logic and asserts for project initiation.
    ***************************************************************/
    private static void initiateProjectCreation()
    {       
        
        List<SelectOption> companyCardSelect = sic.getAllcompanycard();     
        if(companyCardSelect.size() > 2)
        {
            // Error Scenario
            sic.populateCategory();
            System.assertEquals(sic.isBusinessError,false,'no business error displayed on page');
        }       
               
        // Error Scenario
        sic.saveProceed();      
        System.assertEquals(sic.isBusinessError,true,GOT_ERROR_STRING);      
        for(SelectOption selectCC : companyCardSelect)
        {
            if(selectCC.getValue() !=null && !String.isBlank(selectCC.getValue()) )
            {
                sic.project.IPM_Company_Card__c = selectCC.getValue();          
                           
                // Update Company Card Text 
                sic.populateCategory();     
                List<SelectOption> categorySelect = sic.getCategory();
                              
                sic.saveProceed();      
                System.assertEquals(sic.isBusinessError,true,GOT_ERROR_STRING);      
                for(SelectOption managedCategory : categorySelect)
                {
                    if(managedCategory.getValue() != null && !String.isBlank(managedCategory.getValue()) )
                    {
                         
                        sic.project.IPM_Category_Text__c = managedCategory.getValue();
                    }       
                }                
                List<SelectOption> brandPosOptionList = sic.getBrandPos();
                if(brandPosOptionList.size() > 1){
                    sic.project.IPM_Brand_Positioning__c = brandPosOptionList[1].getValue();  
                }
                sic.project.IPM_Brand_Positioning__c='Dove';
                
                sic.getBrandPos();
                // Error Scenario
                sic.getGateKeepingModels();
                System.assertEquals(sic.isBusinessError,true,GOT_ERROR_STRING);              
                List<SelectOption> selectProjectType = sic.getProjectSubTypes();                
                // Error Scenario
                sic.saveProceed();
                System.assertEquals(sic.isBusinessError,true,GOT_ERROR_STRING);              
                for(SelectOption subProjectType : selectProjectType)
                {
                    sic.project.IPM_ProjectSubType__c = subProjectType.getValue();
                    sic.getHelpTextProjectSubType();                
                    sic.populateProjectInformation();
                    
                    System.assertEquals(sic.project.IPM_Project_Type__c,sic.projectMetadata.IPM_Project_Type__c,'Project type is:'+sic.projectMetadata.IPM_Project_Type__c);
                    System.assertEquals(sic.project.IPMProject_Span__c,sic.projectMetadata.IPM_Project_Span__c,'Project sapn is:'+sic.projectMetadata.IPM_Project_Span__c);
                    System.assertEquals(sic.project.IPM_Phase__c,sic.projectMetadata.IPM_DefaultPhase__c,'Project default pahse is:'+sic.projectMetadata.IPM_DefaultPhase__c);
                    System.assertEquals(sic.project.IPM_Complexity__c,sic.projectMetadata.IPM_DefaultComplexity__c,'Project default complexity is:'+sic.projectMetadata.IPM_DefaultComplexity__c);
                    sic.getCharterApprovers();
                    List<SelectOption> gateKeepingSelect = sic.getGateKeepingModels();
                    if(sic.projectMetadata.IPM_GatekeepingModelsApplicable__c)
                    {
                        sic.getHelpTextCharterQuestions();
                        sic.getHelpTextGateKeeping();
                        for(SelectOption GKModel : gateKeepingSelect)
                        {
                            sic.project.IPM_GateKeeping_Model__c =GKModel.getValue();
                            System.assert(sic.projectMetadata.IPM_ApplicableGateKeepingModels__c.contains(GKModel.getValue()),'project gate keeping model is:'+GKModel.getValue());
                        }
                    }
                    else
                    {
                        System.assertEquals(gateKeepingSelect.size(),0,'gatekeeping list size should be zero when it is not applicable');
                    }
                    
                }
            }
        }

    }
    
    /**************************************************************
    *@Description :testmethod to set TLD editable. setIsTLDFieldEditable()
    ***************************************************************/
    static testmethod void testsetIsTLDFieldEditable(){
        getPagerefences();
        test.startTest();
        system.runAs(userInitialize){
            
            
            IPM_TestFactory_Helper.createIPMProjectDocument(false);
    
            sic.project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL ;
            sic.project.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE ;
            sic.setIsTLDFieldEditable(); //test tld is editable or not
            
            sic.project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL ;
            sic.project.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            sic.setIsTLDFieldEditable(); //test tld is editable or not
            
            sic.project.IPM_Phase__c =IPM_ConstantUtils.FEASIBILITY_PHASE ;
            sic.project.IPMProject_Span__c = IPM_ConstantUtils.IPMREGIONAL;
            sic.project.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            sic.setIsTLDFieldEditable(); //test tld is editable or not
            
            sic.project.IPM_Phase__c =IPM_ConstantUtils.PHASE_PLE;
            sic.project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            sic.project.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            sic.setIsTLDFieldEditable();//test tld is editable or not
            
            sic.project.IPM_Phase__c =IPM_ConstantUtils.PHASE_MARKET_READY;
            sic.project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            sic.project.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            sic.setIsTLDFieldEditable();//test tld is editable or not
        
            sic.project.IPM_Phase__c =IPM_ConstantUtils.PHASE_CAPABILITY;
            sic.setIsTLDFieldEditable();//test tld is editable or not
            system.assertEquals(sic.isTLDFieldEditable,false,'TLD is not editable on page');
        }
        test.stopTest();
    }
    
    /**************************************************************
    *@Description :testmethod to get logged in user type
    ***************************************************************/
    static testmethod void testgetMilesTaskIpmuserType1(){
        getPagerefences();
        Test.startTest();
        List<User>userShareList=new List<User>();
        
        sic.isImage=false;
        sic.isBDuser=false;
        sic.isvisible =false;
        sic.functionRole='';
        sic.projbetlink='';
        sic.project.BET_Link_Requested__c='Test';
        
        sic.ImageId=ApexPages.currentPage().getParameters().get('image');   
        List<IPM_Project_Resource__c>newProjectResourceList=new List<IPM_Project_Resource__c>();
        User u4 = IPM_TestFactory_Helper.createUser(false);
        userShareList.add(u4);
        User u5 = IPM_TestFactory_Helper.createUser(false);
        userShareList.add(u5);
        
        insert userShareList;//insert list of users
        List<User>newUserList=[SELECT Lastname FROM USER WHERE LastName='IPMUSER_LASTNAME' LIMIT 1];
        system.assertEquals(newUserList[0].Lastname,'IPMUSER_LASTNAME','User Lastname should be:'+newUserList[0].Lastname);
        IPM_Project_Resource__c  ipmProjectResource = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource.IPM_User__c=u4.id;
        ipmProjectResource.IPM_Project__c = sic.project.id; 
        newProjectResourceList.add(ipmProjectResource);
        
        IPM_Project_Resource__c  ipmProjectResource1 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource1.IPM_Role_Type__c = 'CMI';
        ipmProjectResource1.IPM_User__c = u4.id;
        newProjectResourceList.add(ipmProjectResource1);
        
        IPM_Project_Resource__c  ipmProjectResource2 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id,FALSE);
        ipmProjectResource2.IPM_User__c = u5.id;
        ipmProjectResource2.IPM_Role_Type__c='BD';
        newProjectResourceList.add(ipmProjectResource2);
        
        insert newProjectResourceList;//insert project resources
        List<IPM_Project_Resource__c>validateUserList=[SELECT IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE IPM_User__c =:u5.id LIMIT 1];
        system.assertEquals(validateUserList[0].IPM_Role_Type__c,ipmProjectResource2.IPM_Role_Type__c,'user role type is:'+validateUserList[0].IPM_Role_Type__c);
        List<IPM_Project__c>shareProjectLst=new List<IPM_Project__c>();
        shareProjectLst.add(projectWithOutBoss);
        List<IPM_Project__Share>projectShareList=IPM_TestFactory_Helper.shareIPMProject(shareProjectLst,userShareList);
        insert projectShareList;
        
        system.runAs(u4){ 
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(!sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
            sic.project.Is_Archieved__c=null;
            sic.getMilesTaskIpmuserType();
        }
        system.runAs(u4){
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(!sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        
        system.runAs(u5){
            sic.getProjectResource();//get project resource record
            sic.getMilesTaskIpmuserType();//get current logged in user access
            sic.getIpmuserType();//get current logged in user access
            system.assert(!sic.isEditable, IPM_ConstantUtils.MSG_ISEDITABLE_SHOULD_NOT_NULL);//positive test
        }
        Test.stopTest();   
    }
    
}