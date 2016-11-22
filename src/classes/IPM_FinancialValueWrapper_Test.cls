/*******************************************************
 * @Description: Test class for IPM_FinancialValueWrapper 
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/

@isTest
public class IPM_FinancialValueWrapper_Test {
   
   private static final string FIELDSUFFIX = 'Global';
   private static User stdUserForFinValueWpr;
   private static Set<String> projectNameSet = new Set<String>{'TestComments1'};
   private static final String GLOBAL_PL = 'GLOBAL_PL';
   /***********************************
  Description of the purpose of the method.
  @name: projectSetUp
  @Description: To test insertAssessments method
  ***********************************/
  @testSetup static void projectSetUp(){
    	
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            // user has to be created as system admin 
            stdUserForFinValueWpr = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            stdUserForFinValueWpr.lastname = GLOBAL_PL;
            update stdUserForFinValueWpr;
        }       
       
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
         
        IPM_TestFactory_Helper.getProjectMasterData();
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{stdUserForFinValueWpr});
        List<IPM_Project__c>projectList=new list<IPM_Project__c>();
        System.runAs(stdUserForFinValueWpr){
            projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForFinValueWpr);
            insert projectList;      		
        }  
        List<IPM_Project__c>projList=[Select Id, Name from IPM_Project__c where Id=:projectList[0].Id Limit 1];
        System.assertEquals(projList[0].Name,'TestComments1','Project record not saved successfully');
        
        List<IPM_Financial__c> consolidatedFinLst = new List <IPM_Financial__c>([Select Id, Red_Validation_Cells_Global__c, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c Where Financial_external_Id__c like '%CONSOLIDATED' limit 1000]);
        
	    Test.startTest();
	     
	     //creating local financials starts
	     List<IPM_Financial_year__c> finYearLst = new List<IPM_Financial_year__c>();
	     IPM_Financial_year__c finTemp;
	      
	     for(IPM_Financial__c fin : consolidatedFinLst){
	           finTemp = IPM_TestFactory_Helper.createIPMFinancialYear(false);
	           finTemp.IPM_Financial__c = fin.Id;
	           finYearLst.add(finTemp);
	     }
	      
         insert finYearLst;
         
      	 Test.stopTest();
      	
  }
   
   
   /*************************************
   * @Description: Test Method invocation
   ***************************************/ 
   static testMethod void testFinancialValueWrapper() 
     {
        
      	User globalProjectLeader = [Select Id,Name,lastName from User where LastName =:GLOBAL_PL limit 1];
      
      	List<IPM_Financial__c> lstFin = new List <IPM_Financial__c>([Select Id, Local_Project__c, Yellow_Validation_Cells_Global__c, Red_Validation_Cells_Global__c, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c limit 1000]);
	  	List<IPM_Project__c> lstProjects = [Select id, name, IPMProject_Span__c, IPM_Phase__c, IPM_ProjectGKM__c,IPM_SourceProjectType__c from IPM_Project__c Where Name IN: projectNameSet];
      
      	String queryString='Select ';
      	For (String field : Schema.SObjectType.IPM_Financial_Year__c.fields.getMap().KeySet()){
  		  	if (!field.equalsignoreCase('Id') ){
              	queryString+= field + ', ';
          	}
      	}
      	queryString += ' id From IPM_Financial_year__c  WHERE IPM_Financial__c =\'' + lstFin[0].Id + '\'';
      	List<IPM_Financial_year__c> finYears = Database.query(queryString);
        test.startTest();
        system.runAs(globalProjectLeader){      		
			IPM_FinancialValueWrapper valueWrapper = new IPM_FinancialValueWrapper(FinYears[0], lstProjects[0], FIELDSUFFIX, IPM_ConstantUtils.FIELD_LITERAL_VOLUME, 0, lstFin[0],IPM_ConstantUtils.TAB_MYVIEW_NAME);
			System.assertEquals(valueWrapper.scale, 0, 'Scale should be 0'); 
        }
        test.stopTest();
     }
}