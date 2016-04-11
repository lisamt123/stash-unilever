/******************************************** 
@Author:Cognizant
@name:IPM_AssesmentHandler_Helper_Test
@CreateDate:03/09/2015
@Description:Test class to test IPM_AssesmentHandler_Helper Class
@Version:1.0
@reference: 
*********************************************/

@isTest
private class IPM_AssesmentHandler_Helper_Test 
{
	private static List<IPM_Assessment__c> finalAssessmentList = new List<IPM_Assessment__c>();
	private static List<IPM_Project__c> projectList;
	private static final String GLOBAL_COMPANY_CARD = 'Global Company Card';
	private static final String PLATFORM_USER = 'PLATFORM_USER';
	private static final String ASSESSMENT_NOT_DELETED = 'Assessments are not deleted';
	private static final String PROJECTS_NOT_CREATED = 'Projects not created';
	private static final String COUNTRIES_NOT_CREATED = 'Countries not created';
	private static final String With_MCO = 'With_MCO';
	
	/***********************************
	Description of the purpose of the method. 
	@name: insertAssessmentTest
	@Description: To test insertAssessments method
	@param: none
	@return: none
	@throws: none
	***********************************/
	@testSetup static void projectSetUpData() 
	{
		User platformUser;
		List<IPM_Company_Card__c> companyCardList; 
		System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
		{
			platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
			
		}
		// Create Company Card information 
		IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
		IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
		IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
		
		companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
		insert companyCardList;
		
		IPM_TestFactory_Helper.getProjectMasterData();
		
		projectList = IPM_TestFactory_Helper.projectSetUp(8,platformUser);
		
		System.runAs(platformUser)
		{
			for(IPM_Project__c proj : projectList)
			{
				proj.First_Sync_To_EcoDesign__c = true;
				proj.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
				proj.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
				proj.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
				proj.IPM_CompanyCardText__c = GLOBAL_COMPANY_CARD;
				proj.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
			}
			insert projectList;
		}  
		List<IPM_Project__c> projectListTemp = [Select id From IPM_Project__c Where id IN : projectList ];
		system.assertNotEquals(projectListTemp.size(),0,PROJECTS_NOT_CREATED);
	}

	static testMethod void testInsertAssessmentTest() 
	{
		
		// At this point Async process kicks in and starts creating Related Object information.    
		// Create Country specific information.
		List<IPM_Country__c> countryList= new List<IPM_Country__c>();
		User globalUser = [Select Id,LastName from User where LastName=: PLATFORM_USER limit 1];
		System.runAs(globalUser)
		{
			Test.startTest();
			projectList = [Select Id from IPM_Project__c limit 10000];

			MDO_Geography__c geo = new MDO_Geography__c(name = 'Test');
			insert geo;
			List<MDO_Geography__c> geoListTemp = [Select id,name From MDO_Geography__c Where id =: geo.id];
			system.assertNotEquals(geoListTemp.size(),0,'Geography not created successfully');   

			for(integer i=0; i<4 ; i++) 
			{
				IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = geo.Id,
				IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = With_MCO,
				IS_EI_Country__c = true, isActive__c = true);    
				countryList.add(tempCountry);
			}
			
			insert countryList;
			List<IPM_Country__c> countryListTemp = [Select id From IPM_Country__c Where id IN : countryList];
			system.assertNotEquals(countryListTemp.size(),0,COUNTRIES_NOT_CREATED);   

			for(IPM_Country__c countryEle : countryList)
			{
				IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
				finalAssessmentList.add(assessment);
			}       
			insert finalAssessmentList;
		
			Id assmntId = [Select Id,IPM_Country__c from IPM_Assessment__c Where Project_Phase__c = 'Ideas' limit 1][0].IPM_Country__c;
			IPM_Country__c countryToDelete  =  [Select Id, name from IPM_Country__c where Id =:assmntId limit 1][0];
			//to implement deletion of assessment on deletion of country
			delete countryToDelete;

			IPM_Country__c countryToDeactivate  =  [Select Id, name from IPM_Country__c limit 1][0];
			countryToDeactivate.isActive__c = false;
			update countryToDeactivate;
			
			List<IPM_Assessment__c> assmntsOfDeletedCountry = [Select Id from IPM_Assessment__c where IPM_Country__c =:countryToDelete.Id limit 1000];
			System.assertEquals(assmntsOfDeletedCountry.size(),0,ASSESSMENT_NOT_DELETED);
			Test.stopTest();
		}

	}
	
	/***********************************
	Description of the purpose of the method. 
	@name: copyOverAssmntTest
	@Description: To test copyOverAssessments method
	@param: none
	@return: none
	@throws: none
	***********************************/
	static testMethod void testcopyOverAssmntTest() 
	{
		List<Id> projIdList = new List<Id>();
		User globalUser = [Select Id,LastName from User where LastName =: PLATFORM_USER limit 1][0];
		System.runAs(globalUser)
		{
			test.startTest();
			projectList = [Select Id,IPM_Phase__c from IPM_Project__c limit 10000]; 
			
			IPM_Project_Type__c projectType = new IPM_Project_Type__c();
			projectType.Name = 'Original-Global-GCLTRCLT-Capability1';
			projectType.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
			projectType.IPM_Project_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
			projectType.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
			projectType.IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
			projectType.IPM_Source_Company_Card__c = GLOBAL_COMPANY_CARD;
			projectType.IPM_Copy_Over_Assessments__c = true; 
			insert projectType;
			
			List<IPM_Country__c> countryList = IPM_TestFactory_Helper.createIPMCountryList(false,4);
			for(IPM_Country__c countryEle : countryList)
			{
				countryEle.IPM_project__c = projectList[0].Id;
			}
			
			insert  countryList;
			List<IPM_Country__c> countryListTemp = [Select id,name From IPM_Country__c Where id IN : countryList];
			system.assertNotEquals(countryListTemp.size(),0,COUNTRIES_NOT_CREATED);   
			
			for(IPM_Project__c proj : projectList)
			{
				projIdList.add(proj.Id);
			}
			
			for(IPM_Country__c countryEle : countryList)
			{
				
				IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
				finalAssessmentList.add(assessment);
			}       
			insert finalAssessmentList;
			
			IPM_Project__c projToUpdate = [Select Id,IPM_Phase__c from IPM_Project__c where Id =:projectList[0].Id limit 1000];
			projToUpdate.IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
			update projToUpdate;

			IPM_TestFactory_Helper.initiateProjectPhaseChange(projIdList,globalUser);
			test.stopTest();
			
			List<IPM_Assessment__c> noOfAssessmentNow = [Select Id,Project_Phase__c from IPM_Assessment__c where IPM_Project__c =:projectList[0].Id limit 1000];
			for(IPM_Assessment__c assmntWithChangedPhase : noOfAssessmentNow) 
			{	
				System.assertNotEquals(assmntWithChangedPhase.Project_Phase__c,'Capability','Assessment not is in feasibility phase');
			}
		}
	}
	
	
	/***********************************
	Description of the purpose of the method. 
	@name: copyOverAssmntTest
	@Description: To test copyOverAssessments method
	@param: none
	@return: none
	@throws: none
	***********************************/
	static testMethod void testAssessmentWithWrongPhase() 
	{

		User globalUser = [Select Id,LastName from User where LastName=: PLATFORM_USER limit 1][0];
		List<IPM_Country__c> countryList= new List<IPM_Country__c>();
		System.runAs(globalUser)
		{
			test.startTest();
			projectList = [Select Id from IPM_Project__c limit 10000];
			countryList = IPM_TestFactory_Helper.createIPMCountryList(true,8);
			integer i=0;
			for(IPM_Country__c countryEle : countryList)
			{
				
				IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
				if(i<4)
				{
					assessment.Project_Phase__c = 'Feasibility';
				}
				finalAssessmentList.add(assessment);
				i++;
			}       
			
			//To check if error is thrown when a project with different phase is inserted
			try
			{
				insert finalAssessmentList;
			}
			catch(Exception e)
			{
				System.assert(e.getMessage().contains(String.valueOf(Label.IPM_EcoDesign_Assesment_Data_Wrong_Phase)),Label.IPM_EcoDesign_Assesment_Data_Wrong_Phase);
			}
			test.stopTest();
		}
	}
	
	
	static testMethod void testAssessmentWithWrongCountry() 
	{

		User globalUser = [Select Id,LastName from User where LastName=: PLATFORM_USER limit 1][0];
		List<IPM_Country__c> countryList= new List<IPM_Country__c>();
		System.runAs(globalUser)
		{   
			test.startTest();
			integer i=0;
			projectList = [Select Id from IPM_Project__c limit 10000];
			countryList = IPM_TestFactory_Helper.createIPMCountryList(false,8);
			for(IPM_Country__c countryEle : countryList)
			{
				if(i<4)
				{
					countryEle.IPM_project__c = projectList[i].Id;
					i++;
				}
			}
			
			insert countryList;
			List<IPM_Country__c> countryListTemp = [Select id,name From IPM_Country__c Where id IN : countryList];
			system.assertNotEquals(countryListTemp.size(),0,COUNTRIES_NOT_CREATED);   

			for(IPM_Country__c countryEle : countryList)
			{
				IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
				finalAssessmentList.add(assessment);
			}       
			try
			{
				insert finalAssessmentList;
			}
			catch(Exception e)
			{
				System.assert(e.getMessage().contains(String.valueOf(Label.IPM_EcoDesign_Assesment_Data_Wrong_Country)),Label.IPM_EcoDesign_Assesment_Data_Wrong_Country);
			}
			delete countryList[0];
			test.stopTest();
		}
	}
}