/******************************************** 
   @Author:Cognizant
   @name:IPM_CountryHandler_Test
   @CreateDate:04/09/2015
   @Description:Test class to test IPM_CountryHandler Class
   @Version:1.0
   @reference: 
*********************************************/
@isTest
private class IPM_CountryHandler_Test {
    public static User platformUser;
    public static List<IPM_Project__c > projectList;
    public static List<IPM_Country__c> countryTest = new List<IPM_Country__c>();
    public static list<MDO_Geography__c> geographyList;
    public static list<MDO_Geography__c> geographyDetailList;
    private static list<String> countryNameList =  new list<String>{'Chile','New Zealand'};
    
    /***********************************
      @name: projectSetUpData
      @Description: Project Test Data Creation
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
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
         IPM_TestFactory_Helper.getProjectMasterData();
         
         projectList = IPM_TestFactory_Helper.projectSetUp(3,platformUser);
         
         System.runAs(platformUser)
         {
           insert projectList;
           
           //create geography related test data
        	geographyList = new list<MDO_Geography__c>();
        	for(string name:countryNameList)
        	{
            	MDO_Geography__c geography = IPM_TestFactory_Helper.createMDOGeography(false);
            	geography.Name = name;
            	geographyList.add(geography);
        	}   
        	insert geographyList;
         }  
         system.assertEquals(projectList.size(),3,'Projects are not created');
         system.assertEquals(geographyList.size(),2,'Geography are not created');
    }
    
    /***********************************
      @name: initializeData
      @Description: Test Data Creation
      @param: none
      @return: none
      @throws: none
    ***********************************/
    static void initializeData(){
    
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<IPM_Project__c> projectDetailList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,EcoDesign_Sync_Status__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),
                                                    (Select Id,Name,IPM_Task_Complexity__c,IPM_Project__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r)
                                                from IPM_Project__c where Name in:projectNameSet];
        
        geographyDetailList = [SELECT id,Name FROM MDO_Geography__c WHERE Name IN: countryNameList];
        system.assertEquals(geographyDetailList.size(),2);
        
        //create country test data
        for(integer i=0 ;i<10 ;i++){
            IPM_Country__c insertCountry = IPM_TestFactory_Helper.createIPMCountry(false);
            if(i!=7){
                insertCountry.IPM_Project__c = projectDetailList[0].Id;
                insertCountry.IPM_Regional_Project__c = projectDetailList[1].Id;
            }
            insertCountry.IPM_Local_Project__c = projectDetailList[2].Id;
            insertCountry.MDO_Geography__c=geographyDetailList[0].id;
            insertCountry.isActive__c = true;
            countryTest.add(insertCountry);
        }
        insert countryTest;
        
        list<IPM_Country__c> countryList = [SELECT Id,IPM_Project__c,MDO_Geography__c,IPM_Local_Project__c,MDO_Geography__r.Name FROM IPM_Country__c WHERE                  MDO_Geography__r.Name IN:countryNameList];
        for(IPM_Country__c country :countryList)
        {
            system.assertEquals(country.IPM_Local_Project__c,projectDetailList[2].Id);
        }
        
        //check if the  project Eco Design status has been updated after country is added
        List<IPM_Project__c> updatedProjectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,EcoDesign_Sync_Status__c from IPM_Project__c where Name in:projectNameSet];
        for(IPM_Project__c proj: updatedProjectList)
        {
            system.assertEquals('Ready', proj.EcoDesign_Sync_Status__c);
        }
        
    }
    
    /***********************************
      @name: testCountryHandler
      @Description: 
      @param: none
      @return: none
      @throws: none
    ***********************************/
    static testMethod void testCountryHandler(){
    
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        system.runAs(globalUser)
        {
        	Test.startTest();
            	initializeData();
            	
            	countryTest[0].MDO_Geography__c = geographyDetailList[1].id;
                update countryTest;
                
                Boolean isDelete = false;
                List<IPM_Country__c> countryTest1 =new List<IPM_Country__c>();
                
                for(IPM_Country__c ipc:countryTest)
                {
                    if(ipc.id==countryTest[0].id)
                    {
                        isDelete=true;
                    }
                    else{
                        countryTest1.add(ipc);
                    }
                }
                if(isDelete)
                {
                    delete countryTest[0];
                }
                system.assertNotEquals(countryTest1.size(), countryTest.size());
            Test.stopTest();
        }
    }
}