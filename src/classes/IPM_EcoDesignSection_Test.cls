/*******************************************************
* @Author:Cognizant	
* @Name: IPM_EcoDesignSection_Test
* @Description: Test class for IPM_EcoDesignSection
* @Author:Cognizant
* @Date:04/22/2015
* *****************************************************/

@isTest
private class IPM_EcoDesignSection_Test 
{
	private static List<IPM_Assessment__c> finalAssessmentList = new List<IPM_Assessment__c>();
	private static List<IPM_Company_Card__c> companyCardList; 
	private static List<IPM_Country__c> countryList= new List<IPM_Country__c>();
	private static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
	private static List<IPM_Project__c> projectListPhaseChange;
	private static final String ENVIRONMENTAL_IMPACT = 'Environmental_Impact';
	private static final String WITH_MCO = 'With MCO';
	private static final String ORIGINAL = 'Original';
	private static final String REGIONAL = 'Regional';
	private static final String REGIONAL_COMPANY_CARD = 'Regional Company Card';
	private static final String PROJ_DOC_SEC_Id = 'ProjDocSecId';
	private static final String ID = 'Id';
	private static final String TESTSTR = 'Test';
	private static final String PRINTDOC = 'printDoc';
	private static final String GLOBAL_PL = 'GLOBAL_PL';
	private static final String REGIONAL_PL = 'REGIONAL_PL';
	private static final String LOCAL_PL = 'LOCAL_PL';
	private static final String GLOBAL_COMPANY_CARD = 'Global Company Card';
	private static final String EICOUNTRIES_NOT_MATCHED = 'EICountries size not matched';
	private static final String NON_EICOUNTRIES_NOT_MATCHED = 'NonEICountries size not matched';
	private static final String DOCUMENT_NOT_CREATED = 'Document not created';
	private static final String ASSESSMENT_NOT_CREATED = 'Assessments are not created';
	private static final String COUNTRIES_NOT_CREATED = 'Countries not created';
	private static final String GEOGRAPHY_NOT_CREATED = 'Geography not created';
	private static final String PROJECTS_NOT_CREATED = 'Projects not created';
	private static final String PROJECT_PHASE_INCORRECT = 'Project phase is not correct';
	private static final String TESTCOMMENT_1 = 'TestComments1';
	private static final String TESTCOMMENT_2 = 'TestComments2';
	private static final String TESTCOMMENT_3 = 'TestComments3';
	private static final String AF = 'AF';
	private static final String AG = 'AG';
	private static final String LA = 'LA';
	private static final String BR = 'BR';

	/***********************************
	Description of the purpose of the method. 
	@name: projectSetUp
	@Description: To test insertAssessments method
	***********************************/
	@testSetup static void projectSetUp() 
	{
		// Create an instance of admin user.
		User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
		insert adminUser;
		User globalProjectLeader = null;
		// Create an instances of standard Users for Allocation to Project Leaders.
		System.runAs(adminUser)
		{   
			globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
			User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
			User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
			
			// Update LastNames to match functionalRoles
			globalProjectLeader.lastname = GLOBAL_PL;
			regionalProjectLeader.lastname = REGIONAL_PL;
			localProjectLeader.lastname = LOCAL_PL; 
			
			List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
			update userList;
			
			// Create Company Card information(Master Data)
			IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
			IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
			IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
			
			companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
			insert companyCardList;
			
			// Inserting Master Data whose OWD are set to readOnly/View All    
			IPM_TestFactory_Helper.getProjectMasterData();
		} 
		
		// Insert the project as a Global project Leader.
		projectList = IPM_TestFactory_Helper.projectSetUp(8,globalProjectLeader);
		
		System.runAs(globalProjectLeader)
		{   
			
			for(IPM_Project__c proj : projectList)
			{
				proj.First_Sync_To_EcoDesign__c = true;
				proj.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
				proj.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
				proj.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
				proj.IPM_CompanyCardText__c = GLOBAL_COMPANY_CARD;
				proj.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
				proj.IPM_Company_Card__c = companyCardList[0].Id;
				proj.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
				proj.IPM_Project_Leader__c = UserInfo.getUserId();
				proj.IPM_SourceProjectType__c = ORIGINAL;
				proj.Success_Timestamp_EcoDesign__c = System.now().addHours(2);

			}
			insert projectList;
			List<IPM_Project__c> projectListTemp = [Select id From IPM_Project__c Where id IN : projectList ];
			system.assert(projectListTemp.size() > 0,PROJECTS_NOT_CREATED);
		}
	}
	
	
	/***********************************
	* @Description: Validate EcoDesign functionality for Global Original Project
	  @name validateEcoDesignSaveGlobal
	* *********************************/
	public static testmethod void validateEcoDesignSaveGlobal() 
	{
		List<MDO_Geography__c> mdo_geoList = new List<MDO_Geography__c>();
		MDO_Geography__c geo;
		User globalUser = [Select Id,LastName from User where LastName=: GLOBAL_PL limit 1][0];
		Test.startTest();
		System.runAs(globalUser)
		{
			projectList = [Select id, name from IPM_Project__c limit 1000];
			for(integer i=0 ;i<10 ;i++) 
			{

				geo = new MDO_Geography__c(name = TESTSTR+i);
				mdo_geoList.add(geo);  
			}
			insert mdo_geoList;      
			List<MDO_Geography__c> geoListTemp = [Select id,name From MDO_Geography__c Where id IN: mdo_geoList];
			system.assertNotEquals(geoListTemp.size(),0,GEOGRAPHY_NOT_CREATED);   
			
			for(integer i=0; i<10 ; i++) 
			{
				if(i < 7) 
				{
					IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
					IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = WITH_MCO,
					IS_EI_Country__c = true,isActive__c = true);    
					countryList.add(tempCountry);
				}
				else 
				{
					IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
					IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = WITH_MCO,
					IS_EI_Country__c = false,isActive__c = true);    
					countryList.add(tempCountry);
				}
			}
			insert countryList;
			List<IPM_Country__c> countryListTemp = [Select id From IPM_Country__c Where id IN : countryList];
			system.assertNotEquals(countryListTemp.size(),0,COUNTRIES_NOT_CREATED); 
			
			integer cnt = 1;
			for(IPM_Country__c countryEle : countryList) 
			{
				if((cnt < 3 && countryEle.IS_EI_Country__c) || (cnt > 6 && !countryEle.IS_EI_Country__c)) 
				{
					IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
					if(cnt == 1 || cnt == 9) 
					{
						assessment.IPM_Is_Lead_Assessment__c = true;
					}
					else 
					{
						assessment.IPM_Is_Lead_Assessment__c = false;
					}
					finalAssessmentList.add(assessment);
				}
				cnt++;
			}    
			insert finalAssessmentList;  
			List<IPM_Assessment__c> finalAssessmentListTemp = [Select Id from IPM_Assessment__c where Id IN: finalAssessmentList limit 1000];
			System.assertNotEquals(finalAssessmentListTemp.size(),0,ASSESSMENT_NOT_CREATED);
		}
		List<IPM_Project_Document__c> projDocListWithProj = [Select id,name,IPM_GateDocuments__c From IPM_Project_Document__c limit 1000];
		List<IPM_Project_Document_Section__c> projDocSectionList = [Select Id From IPM_Project_Document_Section__c Where IPM_Master_Section_External_Id__c =: ENVIRONMENTAL_IMPACT and  IPM_Project_Document__c =: projDocListWithProj[0].id];
		PageReference ecoDesignRef = Page.IPM_ProjectDocumentSectionEditor; 
		ecoDesignRef.getParameters().put(ID,projectList[0].Id);
		ecoDesignRef.getParameters().put(PROJ_DOC_SEC_Id,projDocSectionList[0].Id);
		Test.setCurrentPage(ecoDesignRef);
		//Instantiating the IPM_EcoDesignSection class and checking the list size
		IPM_EcoDesignSection ecoDesignHandler = new IPM_EcoDesignSection();
		System.assertEquals(ecoDesignHandler.countryAssessmentWrapListEICountries.size(),7, EICOUNTRIES_NOT_MATCHED);        
		System.assertEquals(ecoDesignHandler.countryAssessmentWrapListNonEICountries.size(),3,NON_EICOUNTRIES_NOT_MATCHED);
		Test.stopTest();
	}  
	
	/***********************************
	* @Description: validate EcoDesign functionality for Regional Original Project
	  @name validateEcoDesignSaveRegionalOriginal	
	* *********************************/
	
	public static testmethod void validateEcoDesignSaveRegionalOriginal() 
	{

		List<User> userList = [Select Id,LastName from User where LastName=: GLOBAL_PL limit 1];
		List<IPM_Project__c> projectListRegional;
		Test.startTest();
		System.runAs(userList[0])
		{
			//  Create User profile Information
			List<String> projectNames = new List<String>();
			companyCardList = [Select id from IPM_Company_Card__c limit 3]; 
			// Create project for assignment.
			projectListRegional = IPM_TestFactory_Helper.createOriginalProjectList(false, 1);
			for(IPM_Project__c project : projectListRegional) 
			{
				project.IPM_Project_Name__c = 'NewOrgProj';
				project.IPM_Company_Card__c = companyCardList[1].Id;
				project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
				project.IPM_Project_Leader__c = UserInfo.getUserId();
				project.IPM_SourceProjectType__c = ORIGINAL;
				project.IPMProject_Span__c = REGIONAL;
				project.IPM_Gatekeeping_model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
				project.IPM_CompanyCardText__c = REGIONAL_COMPANY_CARD;
				project.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_LITE;
				project.Success_Timestamp_EcoDesign__c = System.now().addHours(2);
				projectNames.add(project.IPM_Project_Name__c);                       
			}
			insert projectListRegional;

		}
		
		List<MDO_Geography__c> mdo_geoList = new List<MDO_Geography__c>();
		MDO_Geography__c geo;
		
		System.runAs(userList[0]) {
			projectList = [Select id, name from IPM_Project__c  where IPMProject_Span__c =:IPM_ConstantUtils.PROJECT_SPAN_GLOBAL limit 1000];
			for(integer i=0 ;i<10 ;i++) 
			{
				geo = new MDO_Geography__c(name = TESTSTR+i);
				mdo_geoList.add(geo);  
			}
			insert mdo_geoList; 
			List<MDO_Geography__c> geoListTemp = [Select id,name From MDO_Geography__c Where id IN: mdo_geoList];
			system.assertNotEquals(geoListTemp.size(),0,GEOGRAPHY_NOT_CREATED);   
			     
			for(integer i=0; i<10 ; i++) 
			{
				if(i < 7)
				{
					IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
					IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = WITH_MCO,
					IS_EI_Country__c = true,isActive__c = true,IPM_Regional_Proj_Association_Timestamp__c =System.now());    
					countryList.add(tempCountry);
				}
				else 
				{
					IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
					IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = WITH_MCO,
					IS_EI_Country__c = false,isActive__c = true,IPM_Regional_Proj_Association_Timestamp__c =System.now());    
					countryList.add(tempCountry);
				}
			}
			insert countryList;
			List<IPM_Country__c> countryListTemp = [Select id From IPM_Country__c Where id IN : countryList];
			system.assertNotEquals(countryListTemp.size(),0,COUNTRIES_NOT_CREATED); 
			
			integer cnt = 1;
			for(IPM_Country__c countryEle : countryList) 
			{
				if((cnt < 3 && countryEle.IS_EI_Country__c) || (cnt > 6 && !countryEle.IS_EI_Country__c)) 
				{
					IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
					
					if(cnt == 1 || cnt == 9) 
					{
						assessment.IPM_Is_Lead_Assessment__c = true;
					}
					else 
					{
						assessment.IPM_Is_Lead_Assessment__c = false;
					}
					finalAssessmentList.add(assessment);
				}
				cnt++;
			}    
			insert finalAssessmentList;  
			List<IPM_Assessment__c> finalAssessmentListTemp = [Select Id from IPM_Assessment__c where Id IN: finalAssessmentList limit 1000];
			System.assertNotEquals(finalAssessmentListTemp.size(),0,ASSESSMENT_NOT_CREATED);
		}
		List<IPM_Project_Document__c> projDocListWithProj = [Select id,name,IPM_GateDocuments__c From IPM_Project_Document__c limit 1000];
		List<IPM_Project_Document_Section__c> projDocSectionList = [Select Id From IPM_Project_Document_Section__c Where IPM_Master_Section_External_Id__c =: ENVIRONMENTAL_IMPACT and  IPM_Project_Document__c =: projDocListWithProj[0].id];
		PageReference ecoDesignRef = Page.IPM_ProjectDocumentSectionEditor; 
		ecoDesignRef.getParameters().put(ID,projectList[0].Id);
		ecoDesignRef.getParameters().put(PROJ_DOC_SEC_Id,projDocSectionList[0].Id);
		Test.setCurrentPage(ecoDesignRef);
		IPM_EcoDesignSection ecoDesignHandler = new IPM_EcoDesignSection();
		System.assertEquals(ecoDesignHandler.countryAssessmentWrapListEICountries.size(),7,EICOUNTRIES_NOT_MATCHED);        
		System.assertEquals(ecoDesignHandler.countryAssessmentWrapListNonEICountries.size(),3,NON_EICOUNTRIES_NOT_MATCHED);
		Test.stopTest();
	}
	
	/***********************************
	* @Description: validate EcoDesign functionality for Phase change
	* @name testForDifferentPhases
	* *********************************/
	public static testmethod void testForDifferentPhases() 
	{
		List<User> userList = [Select Id,LastName from User where LastName=: GLOBAL_PL limit 1];
		List<MDO_Geography__c> mdo_geoList = new List<MDO_Geography__c>();
		MDO_Geography__c geo;
		Test.startTest();
		System.runAs(userList[0]) 
		{
			projectList = [Select id, name,IPM_Project_Type__c,IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c,IPM_CompanyCardText__c from IPM_Project__c  where IPMProject_Span__c =:IPM_ConstantUtils.PROJECT_SPAN_GLOBAL limit 1000];
			for(integer i=0 ;i<10 ;i++) 
			{
				geo = new MDO_Geography__c(name = TESTSTR+i);
				mdo_geoList.add(geo);  
			}
			insert mdo_geoList;      
			for(integer i=0; i<10 ; i++) 
			{
				if(i < 7) 
				{
					IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
					IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = WITH_MCO,
					IS_EI_Country__c = true,isActive__c = true,IPM_Regional_Proj_Association_Timestamp__c =System.now());    
					countryList.add(tempCountry);
				}
				else 
				{
					IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
					IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = WITH_MCO,
					IS_EI_Country__c = false,isActive__c = true,IPM_Regional_Proj_Association_Timestamp__c =System.now());    
					countryList.add(tempCountry);
				}
			}
			insert countryList;
			List<IPM_Country__c> countryListTemp = [Select id From IPM_Country__c Where id IN : countryList];
			system.assertNotEquals(countryListTemp.size(),0,COUNTRIES_NOT_CREATED); 
			
			integer cnt = 1;
			for(IPM_Country__c countryEle : countryList) 
			{
				if((cnt < 3 && countryEle.IS_EI_Country__c) || (cnt > 6 && !countryEle.IS_EI_Country__c)) 
				{

					IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
					
					if(cnt == 1 || cnt == 9) 
					{
						assessment.IPM_Is_Lead_Assessment__c = true;
					}
					else
					{
						assessment.IPM_Is_Lead_Assessment__c = false;
					}
					finalAssessmentList.add(assessment);
				}
				cnt++;
			}    
			insert finalAssessmentList;
			List<IPM_Assessment__c> finalAssessmentListTemp = [Select Id from IPM_Assessment__c where Id IN: finalAssessmentList limit 1000];
			System.assertNotEquals(finalAssessmentListTemp.size(),0,ASSESSMENT_NOT_CREATED);
			
			IPM_Project__c projToChangePhase = projectList[0];
			projToChangePhase.IPM_Phase__c  = IPM_ConstantUtils.FEASIBILITY_PHASE;
			projToChangePhase.Success_Timestamp_EcoDesign__c = System.now().addHours(2);
			update projToChangePhase;
			
			IPM_TestFactory_Helper.initiateProjectPhaseChange(new List<Id>{projectList[0].id},userList[0]);
			
			List<IPM_Project_Document__c> projDocListWithProj = [Select id,name,IPM_GateDocuments__c From IPM_Project_Document__c limit 1000];
			List<IPM_Project_Document_Section__c> projDocSectionList = [Select Id From IPM_Project_Document_Section__c Where IPM_Master_Section_External_Id__c =: ENVIRONMENTAL_IMPACT and  IPM_Project_Document__c =: projDocListWithProj[0].id];
			PageReference ecoDesignRef = Page.IPM_ProjectDocumentSectionEditor; 
			ecoDesignRef.getParameters().put(ID,projectList[0].Id);
			ecoDesignRef.getParameters().put(PROJ_DOC_SEC_Id,projDocSectionList[0].Id);
			
			//contract document
			PageReference IPMGateDocRef1 = Page.IPM_GateDocument;
			IPMGateDocRef1.getParameters().put(ID,projectList[0].Id);
			IPMGateDocRef1.getParameters().put(PRINTDOC,IPM_ConstantUtils.CONTRACT_GATE);

			Test.setCurrentPage(IPMGateDocRef1);
			IPM_EcoDesignSection ecoDesignHandler1 = new IPM_EcoDesignSection();
			
			//MarketReady
			PageReference IPMGateDocRef2 = Page.IPM_GateDocument;
			IPMGateDocRef2.getParameters().put(ID,projectList[0].Id);
			IPMGateDocRef2.getParameters().put(PRINTDOC,IPM_ConstantUtils.MARKET_READY_GATE);          
			
			Test.setCurrentPage(IPMGateDocRef2);
			IPM_EcoDesignSection ecoDesignHandler2 = new IPM_EcoDesignSection();
			
			//Market Deployment
			PageReference IPMGateDocRef3 = Page.IPM_GateDocument;
			IPMGateDocRef3.getParameters().put(ID,projectList[0].Id);
			IPMGateDocRef3.getParameters().put(PRINTDOC,IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE);          
			
			Test.setCurrentPage(IPMGateDocRef3);
			IPM_EcoDesignSection ecoDesignHandler3 = new IPM_EcoDesignSection();
			
			PageReference IPMGateDocRef4 = Page.IPM_GateDocument;
			IPMGateDocRef4.getParameters().put(ID,projectList[0].Id);
			IPMGateDocRef4.getParameters().put(PRINTDOC,IPM_ConstantUtils.BLANK);          
			
			Test.setCurrentPage(IPMGateDocRef4);
			IPM_EcoDesignSection ecoDesignHandler4 = new IPM_EcoDesignSection();
			
			System.assertEquals(ecoDesignHandler1.countryAssessmentWrapListEICountries.size(),7,EICOUNTRIES_NOT_MATCHED); 
			System.assertEquals(ecoDesignHandler2.countryAssessmentWrapListEICountries.size(),7,EICOUNTRIES_NOT_MATCHED); 
			System.assertEquals(ecoDesignHandler3.countryAssessmentWrapListEICountries.size(),7,EICOUNTRIES_NOT_MATCHED); 
			System.assertEquals(ecoDesignHandler4.countryAssessmentWrapListEICountries.size(),7,EICOUNTRIES_NOT_MATCHED); 
		}  
		Test.stopTest();  
	}
	/**
	* @Description:  Used for testing Global, Regional and Local Project creation and associated Assessment to the Regional Projects. Check whether 
	* Assessments attached to Regional Project or not in controller. 
	*  @name createRegional
	* @Sonar Issue Comment : As logic requires creation of Global, Regional and Local projects and
	* their associated data. Associate Country and  Assessment to the Global, Regional and Local Projects. 
	* Show Assessments for Regional Projects on the Page 'IPM_ProjectDocumentSectionEditor'   
	*/	
	public static testmethod void createRegional()
	{
		// Get the newly created Projects from Database. 
		Set<String> projectNameSet = new Set<String>{TESTCOMMENT_1,TESTCOMMENT_2,TESTCOMMENT_3};
		List<Id> globalProjectIdList = new List<Id>();
		Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
		
		User globalProjectLeader = null;
		User regionalProjectLeader = null;
		User localProjectLeader = null;
		
		Test.startTest();
		// Get the list of user's for project leaders.
		List<User> userList = [Select Id,Name,lastName from User where LastName in(:GLOBAL_PL,:REGIONAL_PL,:LOCAL_PL)];
		
		// Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
		IPM_TestFactory_Helper.shareMasterProject(userList); 
		
		for(User lUser  :userList)
		{
			if(lUser.lastName == GLOBAL_PL)
			{
				globalProjectLeader = lUser;
			}
			if(lUser.lastName == REGIONAL_PL)
			{
				regionalProjectLeader = lUser;
			}
			if(lUser.lastName == LOCAL_PL)
			{
				localProjectLeader = lUser;
			}
		}
		
		System.RunAs(globalProjectLeader)
		{
			List<IPM_Project__c> proList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r) from IPM_Project__c where Name in:projectNameSet];
			for(IPM_Project__c project : proList)
			{
				projectMap.put(project.Id,project);
			}
			
			/********************************Global Project Leaders Project View and Data Access****************************************/
			for(IPM_Project__c project : proList)
			{
				// Once project is created Charter document would be available.
				System.assertEquals(project.Project_Documents__r.size(),1,DOCUMENT_NOT_CREATED);

				// Project default phase would always be set as IDEAS.
				System.assertEquals(project.IPM_Phase__c,IPM_ConstantUtils.PHASE_IDEAS,PROJECT_PHASE_INCORRECT); // Phase would be always ideas for Global Project.
			}
			
			/******************************** Create Regional Rollouts for Created Global project ****************************************/
			List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,proList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
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
			List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{localProjectLeader,localProjectLeader,localProjectLeader});  
			
			insert localRolloutList; 
			
			// Create Country specific information.
			for(IPM_Project_Rollout__c localRollout : localRolloutList)
			{
				String geoExternalId = IPM_ConstantUtils.BLANK;
				if(localRollout.IPM_Rollout_Project__c.contains(AF))
				{
					geoExternalId = AG;
				}
				else if(localRollout.IPM_Rollout_Project__c.contains(LA))
				{
					geoExternalId = BR;
				}
				
				IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
				IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO,isActive__c = true);    
				
				countryList.add(tempCountry);
			}
			
			insert countryList;
			List<IPM_Country__c> countryListTemp = [Select id From IPM_Country__c Where id IN : countryList];
			system.assertNotEquals(countryListTemp.size(),0,COUNTRIES_NOT_CREATED);   
			
			/******************************** Initiate Phase Change and Regional Project Creation  ****************************************/
			// Set GateKeeping Model as RCLT and start with Regional Project Creation.
			for(IPM_Project__c project : proList)
			{
				project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
			}  
			
			update proList;
			
			for(IPM_Project__c project : proList)
			{
				globalProjectIdList.add(project.Id);    
			}
			
			// Initiate Phase Change would result in Rollout Project Creation.
			projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
			
			update projectListPhaseChange;

		}
					
		Test.stopTest();
		List<IPM_Project__c> regionalProjects = new List<IPM_Project__c>();
		
		System.RunAs(globalProjectLeader)
		{
			Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);

			for(Id gbProjectId : globalToRegionalMap.keySet())
			{
				regionalProjects.addAll(globalToRegionalMap.get(gbProjectId)); 
			}
			
			List<IPM_Project__c> DBRegionalProjects = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c,(Select Id from Project_Documents__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];  
			for(IPM_Project__c regionalProject : DBRegionalProjects) 
			{
				// Only Contract document Available at Regional Level.
				System.assertEquals(regionalProject.Project_Documents__r.size(),1,DOCUMENT_NOT_CREATED);
			}

			List<IPM_Project__c> regionalProj = [Select id,name,IPMProject_Span__c From IPM_Project__c Where IPMProject_Span__c =: IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ];
			IPM_Project__c regProject = regionalProj[0];
			regProject.Success_Timestamp_EcoDesign__c = System.now().addHours(2);
			
			update regProject;

			List<MDO_Geography__c> mdo_geoList = new List<MDO_Geography__c>();
			for(integer i=0 ;i<10 ;i++) 
			{
				MDO_Geography__c geo = new MDO_Geography__c(name = TESTSTR+i);
				mdo_geoList.add(geo);  
			}
			insert mdo_geoList;    
			List<IPM_Country__c> countryListReg = new List<IPM_Country__c>();   
			for(integer i=0; i<10 ; i++) 
			{
				if(i < 7) 
				{
					IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
					IPM_Regional_Project__c = regProject.id,IPM_Rollout_Status__c = WITH_MCO,
					IS_EI_Country__c = true,isActive__c = true,IPM_Regional_Proj_Association_Timestamp__c =System.now());    
					countryListReg.add(tempCountry);
				}
				else 
				{
					IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
					IPM_Regional_Project__c = regProject.id,IPM_Rollout_Status__c = WITH_MCO,
					IS_EI_Country__c = false,isActive__c = true,IPM_Regional_Proj_Association_Timestamp__c =System.now());    
					countryListReg.add(tempCountry);
				}
			}
			insert countryListReg;
			integer cnt = 1;
			for(IPM_Country__c countryEle : countryListReg) 
			{
				if((cnt < 3 && countryEle.IS_EI_Country__c) || (cnt > 6 && !countryEle.IS_EI_Country__c)) 
				{
					IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, regionalProj[0].id, countryEle.id,IPM_ConstantUtils.FEASIBILITY_PHASE );
					
					if(cnt == 1 || cnt == 9) 
					{
						assessment.IPM_Is_Lead_Assessment__c = true;
					}
					else 
					{
						assessment.IPM_Is_Lead_Assessment__c = false;
					}
					finalAssessmentList.add(assessment);
				}
				cnt++;
			}    
			insert finalAssessmentList; 
			List<IPM_Assessment__c> finalAssessmentListTemp = [Select Id from IPM_Assessment__c where Id IN: finalAssessmentList limit 1000];
			System.assertNotEquals(finalAssessmentListTemp.size(),0,ASSESSMENT_NOT_CREATED); 
			
			List<IPM_Project_Document__c> projDocListWithProj = [Select id,name,IPM_GateDocuments__c From IPM_Project_Document__c limit 1000];
			List<IPM_Project_Document_Section__c> projDocSectionList = [Select Id From IPM_Project_Document_Section__c Where IPM_Master_Section_External_Id__c =: ENVIRONMENTAL_IMPACT and  IPM_Project_Document__c =: projDocListWithProj[0].id];
			PageReference ecoDesignRef = Page.IPM_ProjectDocumentSectionEditor; 
			ecoDesignRef.getParameters().put(ID,regionalProj[0].Id);
			ecoDesignRef.getParameters().put(PROJ_DOC_SEC_Id,projDocSectionList[0].Id);
			Test.setCurrentPage(ecoDesignRef);
			//Instantiating the IPM_EcoDesignSection class and checking the list size
			IPM_EcoDesignSection ecoDesignHandler = new IPM_EcoDesignSection();
			System.assertEquals(ecoDesignHandler.countryAssessmentWrapListEICountries.size(),7,EICOUNTRIES_NOT_MATCHED);        
		}
	}
	/**
	* @Description : Used for testing Global, Regional and Local Project creation and associated Assessment to the Global Project. Check whether consolidated 
	* view is set in controller or not. 
	* @name :  createGlobalConsolidatedLogic
	* @Sonar Issue Comment : As logic requires creation of Global, Regional and Local projects. 
	* Associate Country and  Assessment to the Global, Regional and Local Projects. Show consolidated view of Assessments for the Global and Regional Projects 
	* on the Page 'IPM_ProjectDocumentSectionEditor' 
	*/	
	public static testmethod void createGlobalConsolidatedLogic()
	{
		// Get the newly created Projects from Database. 
		Set<String> projectNameSet = new Set<String>{TESTCOMMENT_1,TESTCOMMENT_2,TESTCOMMENT_3};
		List<Id> globalProjectIdList = new List<Id>();
		Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
		User globalProjectLeader = null;
		User regionalProjectLeader = null;
		User localProjectLeader = null;
		Test.startTest();
		// Get the list of user's for project leaders.
		List<User> userList = [Select Id,Name,lastName from User where LastName in (:GLOBAL_PL,:REGIONAL_PL,:LOCAL_PL)];
		// Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
		IPM_TestFactory_Helper.shareMasterProject(userList); 
		for(User lUser  :userList)
		{
			if(lUser.lastName == GLOBAL_PL)
			{
				globalProjectLeader = lUser;
			}
			if(lUser.lastName == REGIONAL_PL)
			{
				regionalProjectLeader = lUser;
			}
			if(lUser.lastName == LOCAL_PL)
			{
				localProjectLeader = lUser;
			}
		}
		System.RunAs(globalProjectLeader)
		{
			List<IPM_Project__c> proList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r) from IPM_Project__c where Name in:projectNameSet];
			for(IPM_Project__c project : proList)
			{
				projectMap.put(project.Id,project);
			}
			/********************************Global Project Leaders Project View and Data Access****************************************/
			for(IPM_Project__c project : proList)
			{
				// Once project is created Charter document would be available.
				System.assertEquals(project.Project_Documents__r.size(),1,DOCUMENT_NOT_CREATED);
				// Project default phase would always be set as IDEAS.
				System.assertEquals(project.IPM_Phase__c,IPM_ConstantUtils.PHASE_IDEAS,PROJECT_PHASE_INCORRECT); // Phase would be always ideas for Global Project.
			}
			/******************************** Create Regional Rollouts for Created Global project ****************************************/
			List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,proList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
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
			List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{localProjectLeader,localProjectLeader,localProjectLeader});  
			insert localRolloutList; 
			// Create Country specific information.
			for(IPM_Project_Rollout__c localRollout : localRolloutList)
			{
				String geoExternalId = IPM_ConstantUtils.BLANK;
				if(localRollout.IPM_Rollout_Project__c.contains(AF))
				{
					geoExternalId = AG;
				}
				else if(localRollout.IPM_Rollout_Project__c.contains(LA))
				{
					geoExternalId = BR;
				}
				IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
				IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO ,isActive__c = true);    
				countryList.add(tempCountry);
			}
			insert countryList;
			/******************************** Initiate Phase Change and Regional Project Creation  ****************************************/
			for(IPM_Project__c project : proList)
			{
				globalProjectIdList.add(project.Id);    
			}
			// Initiate Phase Change would result in Rollout Project Creation.
			projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
			update projectListPhaseChange;
			Test.stopTest();
		}
		List<IPM_Project__c> regionalProjects = new List<IPM_Project__c>();
		System.RunAs(globalProjectLeader)
		{
			Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);
			for(Id gbProjectId : globalToRegionalMap.keySet())
			{
				regionalProjects.addAll(globalToRegionalMap.get(gbProjectId)); 
			}
			List<IPM_Project__c> DBRegionalProjects = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c,(Select Id from Project_Documents__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];  
			for(IPM_Project__c regionalProject : DBRegionalProjects) 
			{
				// Only Contract document Available at Regional Level.
				System.assertEquals(regionalProject.Project_Documents__r.size(),1,DOCUMENT_NOT_CREATED);
			}
			List<IPM_Project__c> regionalProj = [Select id,name,IPMProject_Span__c From IPM_Project__c Where IPMProject_Span__c =: IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ];
			IPM_Project__c regProject = regionalProj[0];
			regProject.Success_Timestamp_EcoDesign__c = System.now().addHours(2);
			update regProject;
			List<MDO_Geography__c> mdo_geoList = new List<MDO_Geography__c>();
			for(integer i=0 ;i<10 ;i++) 
			{
				MDO_Geography__c geo = new MDO_Geography__c(name = TESTSTR+i);
				mdo_geoList.add(geo);  
			}
			insert mdo_geoList;    
			List<IPM_Country__c> countryListReg = new List<IPM_Country__c>();   
			List<IPM_Project__c> regnlProjList = [Select Id from IPM_Project__c Where IPMProject_Span__c =: IPM_ConstantUtils.PROJECT_SPAN_REGIONAL and IPM_Parent_Project__c =:projectListPhaseChange[0].id  ];
			for(integer i=0; i<10 ; i++) 
			{
				if(i < 7) 
				{
					IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
					IPM_Project__c = projectListPhaseChange[0].id,IPM_Rollout_Status__c = WITH_MCO,
					IS_EI_Country__c = true,isActive__c = true,IPM_Regional_Proj_Association_Timestamp__c =System.now(), IPM_Regional_Project__c =regnlProjList[0].id );    
					countryListReg.add(tempCountry);
				}
				else 
				{
					IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
					IPM_Project__c = projectListPhaseChange[0].id,IPM_Rollout_Status__c = WITH_MCO,
					IS_EI_Country__c = false,isActive__c = true,IPM_Regional_Proj_Association_Timestamp__c =System.now(),  IPM_Regional_Project__c =regnlProjList[0].id);    
					countryListReg.add(tempCountry);
				}
			}
			insert countryListReg;
			integer cnt = 1;
			for(IPM_Country__c countryEle : countryListReg) 
			{
				if((cnt < 3 && countryEle.IS_EI_Country__c) || (cnt > 6 && !countryEle.IS_EI_Country__c)) 
				{
					IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectListPhaseChange[0].id, countryEle.id,IPM_ConstantUtils.FEASIBILITY_PHASE );
					IPM_Assessment__c assessmentRegional = IPM_TestFactory_Helper.createAssessments(false, regnlProjList[0].id, countryEle.id,IPM_ConstantUtils.FEASIBILITY_PHASE );
					if(cnt == 1 || cnt == 9) 
					{
						assessment.IPM_Is_Lead_Assessment__c = true;
					}
					else 
					{
						assessment.IPM_Is_Lead_Assessment__c = false;
					}
					finalAssessmentList.add(assessment);
					finalAssessmentList.add(assessmentRegional);
				}
				cnt++;
			}    
			insert finalAssessmentList;  
			List<IPM_Project_Document__c> projDocListWithProj = [Select id,name,IPM_GateDocuments__c From IPM_Project_Document__c limit 1000];
			List<IPM_Project_Document_Section__c> projDocSectionList = [Select Id From IPM_Project_Document_Section__c Where IPM_Master_Section_External_Id__c =: ENVIRONMENTAL_IMPACT and  IPM_Project_Document__c =: projDocListWithProj[0].id];
			PageReference ecoDesignRef = Page.IPM_ProjectDocumentSectionEditor; 
			ecoDesignRef.getParameters().put(ID,projectListPhaseChange[0].Id);
			ecoDesignRef.getParameters().put(PROJ_DOC_SEC_Id,projDocSectionList[0].Id);
			Test.setCurrentPage(ecoDesignRef);
			//Instantiating the IPM_EcoDesignSection class and checking the list size
			IPM_EcoDesignSection ecoDesignHandler = new IPM_EcoDesignSection();
			System.assertEquals(ecoDesignHandler.countryAssessmentWrapListEICountries.size(),7,EICOUNTRIES_NOT_MATCHED);        
		}
	}
}
