/**
* @author       Cognizant 
* @date         27/10/2015
* @description  This class is used to test the functionality of IPM_FinancialController class (Currency methods only)
*/
@isTest
public class IPM_FinancialController_Currency_Test {

    public static IPM_Project__c project4;
    public static final String FINANCIAL_CONTROLLER_STR = '/apex/IPM_Financial_Currency?id=';
    
    static testMethod void initializeDataTemp3(){
        
        test.startTest();

		project4=IPM_TestFactory_Helper.createIPMProject(FALSE);
        
           project4.Sustainability_Period__c='3';
           project4.IPM_Target_Launch_Dates__c=system.today().addYears(3); 
           project4.IPM_IsCompleted__c=true; 
		   project4.IPM_Project_Type__c='Original';
		   project4.IPM_Project_Name__c='ProjectName';
		   project4.IPM_Phase__c='Ideas';
           project4.IPM_Brand_Positioning__c='Dirt Is Good';
           project4.IPM_GateKeeping_Model__c='RCLT';
           project4.IPM_ProjectSubType__c='Innovation/Rennovation';
           project4.IPM_Category_Text__c='Household Care';
           project4.IPM_SourceProjectType__c = IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL;
           insert project4;
        
        IPM_Project__c Queryproject = [Select Id from IPM_Project__c where id=:project4.Id];
        system.assertNotEquals(Queryproject.Id, null);
           
          
          test.stopTest();
    }
    /*
	Created by - Sanjay Singh
	Purpose - Currency related implementation
	Note: Below method covers new code written for currency related changes but whole class does not cover 75% as its clonned from IPM_Financial test class
	*/
    static testMethod void testCurrency(){
        //set up exchange rate object data
        initializeDataTemp3(); 
            list<IPM_Exchange_Rate__c> liEX = new list<IPM_Exchange_Rate__c>();
            liEX.add(new IPM_Exchange_Rate__c(Name='EUR', Currency_Code__c='EUR',Exchange_Rate__c=1));
            liEX.add(new IPM_Exchange_Rate__c(Name='GBP', Currency_Code__c='GBP',Exchange_Rate__c=0.8)); 
            liEX.add(new IPM_Exchange_Rate__c(Name='USD', Currency_Code__c='USD',Exchange_Rate__c=1.3));         
        insert liEX;          
        PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project4.Id);
        Test.setCurrentPage(pRef); 
        IPM_FinancialController ipmCurr=new IPM_FinancialController();
        ipmCurr.getItems();
        ipmCurr.selectedCurrency = 'GBP';
        ipmCurr.applyRate();
        //verify if exchange rate is applied as per selected country
        system.assertEquals(ipmCurr.exRate,0.8);
        
        ipmCurr.selectedCurrency = 'EUR';
        ipmCurr.applyRate();
        //verify if exchange rate is applied when go back to default currency
        system.assertEquals(ipmCurr.exRate,1);
        
        
    }
   
}