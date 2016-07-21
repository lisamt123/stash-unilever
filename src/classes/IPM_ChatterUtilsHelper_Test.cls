/******************************************** 
   @Author: Cognizant
   @name: IPM_ChatterUtilsHelper_Test
   @CreateDate: 03/09/2015
   @Description: Test class to test IPM_ChatterUtilsHelper Class
   @Version: 1.0
   @reference: 
*********************************************/

@isTest
public with sharing class IPM_ChatterUtilsHelper_Test {
    
    public static List<IPM_Company_Card__c> companyCardList; 
    public static List<IPM_Project__c> projectList;
    public static List<IPM_Project_Resource__c> ipmProjectResourceList;
    public static List<IPM_Country__c> ipmCountryList;
    public static User platformUser;
    
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
         }  
         system.assertEquals(projectList.size(),20,'Projects are not created');

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
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        
           ipmProjectResourceList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 20);
           projectList = [Select Id, name,First_Sync_To_EcoDesign__c ,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Project_Type__c,IPM_CompanyCardText__c,IPM_Phase__c,IPM_Project_Leader__c,IPM_Project_Name__c from IPM_Project__c Limit 1000];
           for(integer i=0; i<20; i++){
                ipmProjectResourceList[i].IPM_Project__c = projectList[i].Id;
                ipmProjectResourceList[i].IPM_Role_Type__c= 'R&D';
                
           }
           insert ipmProjectResourceList;
        system.runAs(globalUser){
           projectList = [Select Id, name,First_Sync_To_EcoDesign__c ,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Project_Type__c,IPM_CompanyCardText__c,IPM_Phase__c,IPM_Project_Leader__c,IPM_Project_Name__c from IPM_Project__c Limit 1000];
           ipmCountryList = IPM_TestFactory_Helper.createIPMCountryList(false, 20);
           for(integer i=0; i<20; i++){
                ipmCountryList[i].IPM_Project__c=projectList[i].Id;
           }
           test.startTest();
           insert ipmCountryList;
           
           List<IPM_Country__c> countriesToDeleteLst = [Select id,IPM_project__c from IPM_Country__c limit 2];
           delete countriesToDeleteLst;
           
           System.assertEquals('Ready',[Select Id,EcoDesign_Sync_Status__c from IPM_Project__c where ID =:countriesToDeleteLst[0].IPM_project__c limit 1 ][0].EcoDesign_Sync_Status__c);
           
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
           
           List<IPM_Country__c> countriesToDeleteLst = [Select id,IPM_project__c from IPM_Country__c limit 2];
           delete countriesToDeleteLst;
           
           System.assertEquals('Ready',[Select Id,EcoDesign_Sync_Status__c from IPM_Project__c where ID =:countriesToDeleteLst[0].IPM_project__c limit 1 ][0].EcoDesign_Sync_Status__c);
           
           test.stopTest();
        }
        
    }

}