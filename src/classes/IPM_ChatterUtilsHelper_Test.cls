/******************************************** 
   @Author: Cognizant
   @name: IPM_ChatterUtilsHelper_Test
   @CreateDate: 03/09/2015
   @Description: Test class to test IPM_ChatterUtilsHelper Class
   @Version: 1.0
   @reference: 
*********************************************/

@isTest
private with sharing class IPM_ChatterUtilsHelper_Test {
    
    private static List<IPM_Company_Card__c> companyCardList; 
    private static List<IPM_Project__c> projectList;
    private static List<IPM_Project_Resource__c> ipmProjectResourceList;
    private static List<IPM_Country__c> ipmCountryList;
    private static User platformUser;
    private static Set<Id> iDs;
    private static final String COMPANY_CARD_NOT_INSERTED='Company Cards are not inserted';
    private static final String PROJECT_NOT_INSERTED = 'Projects not Inserted';
    private static final String COUNTRY_NOT_INSERTED = 'Country not Inserted';
    private static final String COUNTRY_NOT_DELETED='Countries not deleted!';
    private static final String PROJECTRESOURCE_NOT_INSERTED_ASSERTION = 'Project Resources not Inserted';
    
     /***********************************
      Description of the purpose of the method. 
      @name: projectSetUpData
      @Description: Test Data Creation
      @param: none
      @return: none
      @throws: none
    ***********************************/  
    
     @testSetup static void projectSetUpData() 
     {
     	iDs = new Set<Id>();
     	
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        for(IPM_Company_Card__c eachCompanyCard : companyCardList) {
            iDs.add(eachCompanyCard.Id);
        }
        System.assertEquals(3, [Select count() from IPM_Company_Card__c where id in:iDs],COMPANY_CARD_NOT_INSERTED );
         
         IPM_TestFactory_Helper.getProjectMasterData();
         
         projectList = IPM_TestFactory_Helper.projectSetUp(20,platformUser);

         System.runAs(platformUser)
         {
           integer counter=0;
           for(IPM_Project__c proj : projectList){
                proj.First_Sync_To_EcoDesign__c = true;
                proj.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
                proj.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
                proj.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
                proj.IPM_CompanyCardText__c = 'Global Company Card';
                proj.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
                proj.IPM_Project_Leader__c = userInfo.getuserId();
                proj.IPM_Project_Name__c = 'proj'+counter++;
              }
           insert projectList;
           
           iDs.clear();
           for(IPM_Project__c eachProj : projectList) {
           iDs.add(eachProj.Id);
           }
           System.assertEquals(20, [Select count() from IPM_Project__c where id in:iDs],PROJECT_NOT_INSERTED);
        
         }  
        
      }

     /***********************************
      Description of the purpose of the method. 
      @name: testChatterUtilsHelper
      @Description: To test fetchProjIdLeadRnDMemberIdSetMap method and getprojIdchatterMessageMap method for both insert and delete operation 
      @param: none
      @return: none
      @throws: none
    ***********************************/     
    static testMethod void testChatterUtilsHelper(){ 
    	
    	iDs = new Set<Id>();
    	       
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        
           ipmProjectResourceList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 20);
           projectList = [Select Id, name,First_Sync_To_EcoDesign__c ,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Project_Type__c,IPM_CompanyCardText__c,IPM_Phase__c,IPM_Project_Leader__c,IPM_Project_Name__c from IPM_Project__c Limit 1000];
           for(integer i=0; i<20; i++){
                ipmProjectResourceList[i].IPM_Project__c = projectList[i].Id;
                ipmProjectResourceList[i].IPM_Role_Type__c= 'R&D';
                
           }
           insert ipmProjectResourceList;
           iDs.clear(); 
           for(IPM_Project_Resource__c eachResource : ipmProjectResourceList) {
           iDs.add(eachResource.Id);
           }
           System.assertEquals(20, [Select count() from IPM_Project_Resource__c where id in:iDs],PROJECTRESOURCE_NOT_INSERTED_ASSERTION);
        
        system.runAs(globalUser){
           projectList = [Select Id, name,First_Sync_To_EcoDesign__c ,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Project_Type__c,IPM_CompanyCardText__c,IPM_Phase__c,IPM_Project_Leader__c,IPM_Project_Name__c from IPM_Project__c Limit 1000];
           ipmCountryList = IPM_TestFactory_Helper.createIPMCountryList(false, 20);
           for(integer i=0; i<20; i++){
                ipmCountryList[i].IPM_Project__c=projectList[i].Id;
           }
           test.startTest();
           insert ipmCountryList;
           
           iDs.clear(); 
           for(IPM_Country__c eachCountry : ipmCountryList) {
           iDs.add(eachCountry.Id);
           }
           System.assertEquals(20, [Select count() from IPM_Country__c where id in:iDs],COUNTRY_NOT_INSERTED);
        
           
           List<IPM_Country__c> countriesToDeleteLst = [Select id,IPM_project__c from IPM_Country__c limit 2];
           delete countriesToDeleteLst;
           
           //Eco design sync status should be Ready when the countries are deleted
           System.assertEquals('Ready',[Select Id,EcoDesign_Sync_Status__c from IPM_Project__c where ID =:countriesToDeleteLst[0].IPM_project__c limit 1 ][0].EcoDesign_Sync_Status__c,COUNTRY_NOT_DELETED);
           
           test.stopTest();
        }
        
    }
    
    /***********************************
      Description of the purpose of the method. 
      @name: testChatterUtilsHelperWithOutRnDLeader
      @Description: To test fetchProjIdLeadRnDMemberIdSetMap method and getprojIdchatterMessageMap method for both insert and delete operation 
      when R&D leader is not assigned 
      @param: none
      @return: none
      @throws: none
    ***********************************/     
    static testMethod void testChatterUtilsHelperWithOutRnDLeader(){   
    	iDs = new Set<Id>();
    	     
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        
           projectList = [Select Id, name,First_Sync_To_EcoDesign__c ,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Project_Type__c,IPM_CompanyCardText__c,IPM_Phase__c,IPM_Project_Leader__c,IPM_Project_Name__c from IPM_Project__c Limit 1000];
           system.runAs(globalUser){
           projectList = [Select Id, name,First_Sync_To_EcoDesign__c ,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Project_Type__c,IPM_CompanyCardText__c,IPM_Phase__c,IPM_Project_Leader__c,IPM_Project_Name__c from IPM_Project__c Limit 1000];
           ipmCountryList = IPM_TestFactory_Helper.createIPMCountryList(false, 20);
           for(integer i=0; i<20; i++){
                ipmCountryList[i].IPM_Project__c=projectList[i].Id;
           }
           test.startTest();
           insert ipmCountryList;
           
           iDs.clear(); 
           for(IPM_Country__c eachCountry : ipmCountryList) {
           iDs.add(eachCountry.Id);
           }
           System.assertEquals(20, [Select count() from IPM_Country__c where id in:iDs],COUNTRY_NOT_INSERTED);
        
           List<IPM_Country__c> countriesToDeleteLst = [Select id,IPM_project__c from IPM_Country__c limit 2];
           delete countriesToDeleteLst;
           
           //Eco design sync status should be Ready when the countries are deleted
           System.assertEquals('Ready',[Select Id,EcoDesign_Sync_Status__c from IPM_Project__c where ID =:countriesToDeleteLst[0].IPM_project__c limit 1 ][0].EcoDesign_Sync_Status__c,COUNTRY_NOT_DELETED);
           
           test.stopTest();
        }
        
    }

}