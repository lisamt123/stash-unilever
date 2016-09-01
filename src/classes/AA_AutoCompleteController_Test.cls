@isTest
/**
 * Name:        -   AA_AutoCompleteController_Test
 * @description -   This is the test class for AA_AutoCompleteController Class to verify the code  for the services requested from frontend & which includes the business logic.
 * @Author      -   Ipsita S    
 */
public class AA_AutoCompleteController_Test{      
  
    static testMethod void LookupTest(){
    
    	
      	String searchStringBrand='dov';
       	String searchStringRetailer='bi';
       	String searchStringUser='ra';
       	String objectName='aa_Agent_App_Competitor_Brand__c';
       	String objectName1='aa_Agent_Retailer__c';
       	String objectName2='User';
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
        
        aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
        insert uniBrand;
        
        aa_Agent_App_Competitor_Brand__c uniBrand1 = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
        insert uniBrand1;
        aa_Agent_App_Competitor_Brand__c uniBrand2 = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
        insert uniBrand2;
        	String recordType1='Unilever Brand';
       	//String recordType1='CompetitorBrand';
       	//String recordType2='UnileverBrand';
       	String recordType3= 'null';
       	//String recordType4='ti';
       
        List<AA_AutoCompleteController.Result> results = new List<AA_AutoCompleteController.Result>();
        List<AA_AutoCompleteController.Result> results1 = new List<AA_AutoCompleteController.Result>();
        List<AA_AutoCompleteController.Result> results2 = new List<AA_AutoCompleteController.Result>();
    	Test.startTest();
    	results = AA_AutoCompleteController.lookup(searchStringBrand, objectName, recordType1);
    	System.assert(results.isEmpty());
    	results1 =AA_AutoCompleteController.lookup(searchStringRetailer,objectName1,recordType3);
     	System.assert(results1.isEmpty());
    	results2 =AA_AutoCompleteController.lookup(searchStringUser,objectName2,recordType3);
    	System.assert(results2.isEmpty());
    	Test.stopTest();
    }
    
    static testMethod void ResultTest(){
    	aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand);
       	insert compBrand; 
    	aa_Agent_App_Competitor_Brand__c uniBrand= new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand);
       	insert uniBrand;
    	
    	Test.startTest();
    	AA_AutoCompleteController.Result obj1=new AA_AutoCompleteController.Result('testResult',compBrand.Id);
    	System.assertEquals('testResult',obj1.SObjectLabel);
    	AA_AutoCompleteController.Result obj2=new AA_AutoCompleteController.Result('testResult',uniBrand.Id);
    	System.assertEquals('testResult',obj2.SObjectLabel);
	    Test.stopTest();
    }
    
  }