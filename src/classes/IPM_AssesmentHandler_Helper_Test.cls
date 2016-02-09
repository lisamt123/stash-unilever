/******************************************** 
   @Author:Cognizant
   @name:IPM_AssesmentHandler_Helper_Test
   @CreateDate:03/09/2015
   @Description:Test class to test IPM_AssesmentHandler_Helper Class
   @Version:1.0
   @reference: 
*********************************************/

@isTest
private class IPM_AssesmentHandler_Helper_Test {
    public static User platformUser;
    public static List<IPM_Assessment__c> finalAssessmentList = new List<IPM_Assessment__c>();
    public static List<IPM_Company_Card__c> companyCardList; 
    public static List<IPM_Project__c> projectList;
    public static List<Id> projIdList = new List<Id>();
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
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
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
           for(IPM_Project__c proj : projectList){
            proj.First_Sync_To_EcoDesign__c = true;
            proj.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            proj.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            proj.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            proj.IPM_CompanyCardText__c = 'Global Company Card';
            proj.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
          }
           insert projectList;
         }  
         system.assertEquals(projectList.size(),8,'Projects are not created');

      }
    
    
    static testMethod void testInsertAssessmentTest() {
     
        // At this point Async process kicks in and starts creating Related Object information.    
        // Create Country specific information.
        List<IPM_Country__c> countryList= new List<IPM_Country__c>();
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser)
        {
            test.startTest();
            projectList = [Select Id from IPM_Project__c limit 10000];
            
            mdm_Geography__c geo = new mdm_Geography__c(name = 'France');
            insert geo;      

            for(integer i=0; i<4 ; i++) {
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = geo.Id,
                IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = 'With MCO',
                IS_EI_Country__c = true, isActive__c = true);    
            
                countryList.add(tempCountry);
            }
            
            insert countryList;

            for(IPM_Country__c countryEle : countryList)
            {
                  IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
                  finalAssessmentList.add(assessment);
            }       
            insert finalAssessmentList;
            
            //to implement delete assessment on insertion of new assessment
            IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryList[0].id,IPM_ConstantUtils.PHASE_IDEAS );
            IPM_TestFactory_Helper.createAssessments(true, projectList[0].id, countryList[0].id,IPM_ConstantUtils.PHASE_IDEAS );
           
            
            Id assmntId = [Select Id,IPM_Country__c from IPM_Assessment__c Where Project_Phase__c = 'Ideas' limit 1][0].IPM_Country__c;
            
            IPM_Country__c countryToDelete  =  [Select Id, name from IPM_Country__c where Id =:assmntId limit 1][0];
           
            
            //to implement deletion of assessment on deletion of country
            delete countryToDelete;
            
            IPM_Country__c countryToDeactivate  =  [Select Id, name from IPM_Country__c limit 1][0];
            countryToDeactivate.isActive__c = false;
            
            update countryToDeactivate;
            
            List<IPM_Assessment__c> assmntsOfDeletedCountry = [Select Id from IPM_Assessment__c where IPM_Country__c =:countryToDelete.Id limit 1000];
            
            System.assertEquals(0,assmntsOfDeletedCountry.size(),'Number of country to deleted :'+assmntsOfDeletedCountry.size());
            test.stopTest();
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
    static testMethod void testcopyOverAssmntTest() {
  
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1][0];
        System.runAs(globalUser){
            test.startTest();
            projectList = [Select Id,IPM_Phase__c from IPM_Project__c limit 10000]; 
        
            IPM_Project_Type__c projectType = new IPM_Project_Type__c();
            projectType.Name = 'Original-Global-GCLTRCLT-Capability1';
            projectType.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            projectType.IPM_Project_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            projectType.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            projectType.IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
            projectType.IPM_Source_Company_Card__c = 'Global Company Card';
            projectType.IPM_Copy_Over_Assessments__c = true; 
            insert projectType;
            
            List<IPM_Country__c> countryList = IPM_TestFactory_Helper.createIPMCountryList(false,4);
            for(IPM_Country__c countryEle : countryList){
                countryEle.IPM_project__c = projectList[0].Id;
            }
            
            insert  countryList;
            
            for(IPM_Project__c proj : projectList){
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
            Update projToUpdate;

            IPM_TestFactory_Helper.initiateProjectPhaseChange(projIdList,globalUser);
                
            List<IPM_Assessment__c> noOfAssessmentNow = [Select Id from IPM_Assessment__c where IPM_Project__c =:projectList[0].Id limit 1000];
            System.assertEquals(4,noOfAssessmentNow.Size(),'Number of Assessment is:'+noOfAssessmentNow.Size());
            test.stopTest();
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
    static testMethod void testAssessmentWithWrongPhase() {
  
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1][0];
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
                  if(i<4){
                    assessment.Project_Phase__c = 'Feasibility';
                  }
                  finalAssessmentList.add(assessment);
                  i++;
            }       
            
            //To check if error is thrown when a project with different phase is inserted
            try{
                insert finalAssessmentList;
            }
            catch(Exception e){
                System.assert(e.getMessage().contains(String.valueOf(Label.IPM_EcoDesign_Assesment_Data_Wrong_Phase)), 'Message should be :'+Label.IPM_EcoDesign_Assesment_Data_Wrong_Phase);
            }
            
            test.stopTest();
        }

    }
    
    
    static testMethod void testAssessmentWithWrongCountry() {
  
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1][0];
        List<IPM_Country__c> countryList= new List<IPM_Country__c>();
        System.runAs(globalUser)
        {   
            test.startTest();
            integer i=0;
            projectList = [Select Id from IPM_Project__c limit 10000];
            countryList = IPM_TestFactory_Helper.createIPMCountryList(false,8);
            for(IPM_Country__c countryEle : countryList){
                if(i<4){
                countryEle.IPM_project__c = projectList[i].Id;
                i++;
                }
                
            }
            
            insert countryList;

            for(IPM_Country__c countryEle : countryList)
            {
                  
                  IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, projectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );
                  finalAssessmentList.add(assessment);
            }       
            try{
                insert finalAssessmentList;
            }
            catch(Exception e){
                System.assert(e.getMessage().contains(String.valueOf(Label.IPM_EcoDesign_Assesment_Data_Wrong_Country)), 'Message should be :'+Label.IPM_EcoDesign_Assesment_Data_Wrong_Country);
            }
            
            delete countryList[0];
            test.stopTest();
        }

    }
}