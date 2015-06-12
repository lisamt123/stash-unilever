public with sharing class AR_ProgressBarComponentController {
    private AR_ProgressBarHandler progressBar {get;set;}
    
    public AR_ApplicationBaseController pageController {
        get;
        set {
            if(value != null) {
                pageController = value;
                pageController.setProgressBarController(this);
                
                this.progressBar =  new AR_ProgressBarHandler( ((ar_Application__c)pageController.application.obj).Form_Progress__c );
                progressBar.setCurrentStep( pageController.currentStep );
                
                // field Sets per object
                this.progressBar.setFieldSetMap( pageController.FieldSetMap );
                
                // Object data for validations
                this.progressBar.setFormObjects( pageController.getFormObjects() );
                
                // Object Lists data for validation
                this.progressBar.setFormLists( pageController.getFormLists() );
                
                // Custom Validations
                this.progressBar.setCustomValidations(new Map<String,AR_ProgressBarHandler.CustomValidation>{
                    'supplier_code' => new AR_ProgressBarHandler.SupplierCodeValidation(),
                    'financials' => new AR_ProgressBarHandler.FinancialsValidation(),
                    'insurance' => new AR_ProgressBarHandler.InsuranceValidation(),
                    'supplier_info' => new AR_ProgressBarHandler.SupplierInfoValidation(),
                    'fixed_priced_rate_cards' => new AR_ProgressBarHandler.FixedPricedRateCardValidation(),
                    'expertise'=> new AR_ProgressBarHandler.AgencyExpertiseValidation(),
                    'agency_profile'=>new AR_ProgressBarHandler.AgencyProfileValidation(),
                    'general_information'=>new AR_ProgressBarHandler.GeneralInformationValidation()
                });
            }
        }
    }
    
    public AR_ProgressBarComponentController() {
    }
    
    public AR_ProgressBarHandler getProgressBar() {
        return this.progressBar;
    }
    
    public PageReference changeStep() {
        // save current step
        Integer currentStep = pageController.currentStep;
        Integer nextStep = Integer.valueOf(System.currentPageReference().getParameters().get('nextStep'));
        
        // reuse controller logic
        PageReference pr = pageController.changeStep(currentStep, nextStep);
        
        return pr;
    }
    
    public void checkStatus(Integer step) {
        try {
            progressBar.checkStep( step );
            system.debug(logginglevel.info, 'Updating Application progress...');
            String status = progressBar.getStatus();
            ar_Application__c app = new ar_Application__c(Id = pageController.application.getId(), Form_Progress__c = status);
            update app;
            system.debug(logginglevel.info, 'done! ' + app);
        } catch(Exception e) {
            system.debug(logginglevel.error, 'ERROR Updating Application Progress Bar Status: ' + e.getmessage());
        }
    }
}