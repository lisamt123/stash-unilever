@isTest
private class AR_Test_AR_ProgressBarHandler {

    static testMethod void statusFromScratch() {
        ar_Application__c app = TestDataFactory.getApplication();
        app.Agree_to_comply_Unilever_Supplier_Code__c = 'Yes';
        app.Length_of_client_relationship__c = '1 - 2 Years';
        app.Additional_Information__c = '';
        insert app;
        
        ar_Experience__c exp = TestDataFactory.getExpertise(app.id);
        insert exp;
            // expertise attachment
            Attachment att1 = new Attachment(Name = 'one_Case studies', ParentId = exp.id, Body = Blob.valueOf('case studie desc'));
            insert att1;
            
            
        Test.startTest();
            AR_ProgressBarHandler handler = new AR_ProgressBarHandler(null);
            
            // FIELD SETS
            Map<String,Map<String,List<Schema.FieldSetMember>>> FieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
            FieldSetMap.put('ar_Application__c',AR_MetaDataHandler.GetAllApplicationFieldsets());
            FieldSetMap.put('ar_Insurance_and_Policy__c',AR_MetaDataHandler.GetAllInsurancePolicyFieldsets());
            FieldSetMap.put('ar_Experience__c', AR_MetaDataHandler.GetAllExperienceFieldsets());
            fieldSetMap.put('ar_Financial__c',AR_MetaDataHandler.GetAllFinancialFieldsets());
			fieldSetMap.put('ar_Competitor__c',AR_MetaDataHandler.GetAllCompetitorFieldsets());
			fieldSetMap.put('ar_Geography__c',AR_MetaDataHandler.GetAllGeographyFieldsets());
			fieldSetMap.put('ar_Revenue_Breakdown__c',AR_MetaDataHandler.GetAllRevenueBreakdownFieldsets());
			fieldSetMap.put('ar_Supplier_Info__c', AR_MetaDataHandler.GetAllSupplierInfoFieldsets());
			fieldSetMap.put('ar_Rate_Card__c',AR_MetaDataHandler.GetAllRateCardFieldsets());
			fieldSetMap.put('ar_Fixed_Price_Rate_Card__c',AR_MetaDataHandler.GetAllFixRateCardFieldsets());
			
            handler.setFieldSetMap(FieldSetMap);
            
            // OBJ DATA
            AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2( app.id );
                // Application
                Set<String> tmp_AppFields = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Application__c'));
                AR_SObjectHolder ApplicationObject = tmp_DataHandler.SelectApplication(tmp_AppFields);
                // Expertise
                Set<String> tmp_FieldsAgencyExperienceObject = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Experience__c'));
                AR_SObjectHolder AgencyExperienceObject = tmp_DataHandler.SelectAgencyExperience(tmp_FieldsAgencyExperienceObject);
            // inject data
            
            handler.setFormObjects(
                new Map<String,AR_SObjectHolder>{
                    'ar_Application__c'=>ApplicationObject,
                    'ar_Experience__c'=>AgencyExperienceObject
                }
            );
            
            // OBJ LIST DATA
            List<AR_SObjectHolder> policies = new List<AR_SObjectHolder>();
            AR_SObjectHolder policy1 = new AR_SObjectHolder( TestDataFactory.getInsurance() );
            policies.add( policy1 ); // test with only 1 record
            handler.setFormLists( 
                new Map<String,List<AR_SObjectHolder>>{
                    'ar_Insurance_and_Policy__c#Insurance'=>policies
                }
            );
            
            // CUSTOM VALIDATIONS
            handler.setCustomValidations(new Map<String,AR_ProgressBarHandler.CustomValidation>{
	        		'supplier_code' => new AR_ProgressBarHandler.SupplierCodeValidation(),
	        		'financials' => new AR_ProgressBarHandler.FinancialsValidation(),
	        		'insurance' => new AR_ProgressBarHandler.InsuranceValidation(),
	        		'supplier_info' => new AR_ProgressBarHandler.SupplierInfoValidation(),
	        		'fixed_priced_rate_cards' => new AR_ProgressBarHandler.FixedPricedRateCardValidation(),
	        		'expertise'=> new AR_ProgressBarHandler.AgencyExpertiseValidation(),
	        		'agency_profile'=>new AR_ProgressBarHandler.AgencyProfileValidation(),
	        		'general_information'=>new AR_ProgressBarHandler.GeneralInformationValidation()
	        	});
            
            String status = handler.checkProgressBarStatus();
            handler.getStatus();
        Test.stopTest();
        
        system.assertEquals(AR_ProgressBarHandler.TOTAL_STEPS, handler.steps.size(), 'Not all steps were loaded.');
        system.assertEquals(AR_ProgressBarHandler.STATUS_UNFINISHED, status, 'Progress bar status is not correct.');
    }
    
    static testMethod void statusResume() {
        Test.startTest();
        
            AR_ProgressBarHandler handler = new AR_ProgressBarHandler('1:c;2:u;5:t');
            system.assert(handler.steps[0].getIsCompleted(), 'Progress bar status was not resumed correctly');
            system.assert(handler.steps[1].getIsUnfinished(), 'Progress bar status was not resumed correctly');
            
            // change step
            handler.setCurrentStep(5);
            system.assert(handler.steps[4].getIsCurrent(), 'Wrong current step');
            
            // change step
            handler.setCurrentStep(1);
            system.assert(handler.steps[0].getIsCurrent(), 'Wrong current step');
            
            handler.getCompleteStatus();
        Test.stopTest();
    }
}