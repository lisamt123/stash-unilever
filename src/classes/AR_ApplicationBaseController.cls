public abstract with sharing class AR_ApplicationBaseController {
	public AR_SObjectHolder application {get;set;}  									// main object across all steps
	private Map<Integer, String> pagesOrder {											// pages to be displaued on each step //TODO Should be a map of integer, pagereference?
		get {
			return new Map<Integer,String> {
				1 => 'ar_suppliercode', 
				2 => 'ar_generalinformation',
				3 => 'ar_financials',
		        4 => 'ar_businessBreakdown',
		        5 => 'ar_geography',
		        6 => 'ar_insuranceTraderegsAndPolicy',
		        7 => 'ar_supplierinfo',
		        8 => 'ar_agencyExpAndExpertise',
		        9 => 'ar_unileverExperience',
		        10 => 'ar_agencyProfile',
		        11 => 'ar_rateCard',
		        12 => 'ar_fixedPriceRatecard'
			};
		}
		set;
	}				
	
	public Integer currentStep {get;set;}												// current step in the form
	private AR_ProgressBarComponentController progressBarController;					// for Controller Component comunication
	public Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap {get;set;} 	// field sets to be available on each step
	
	// for progress bar
	private Map<String,AR_SObjectHolder> formObjects;
	private Map<String,List<AR_SObjectHolder>> formLists;
	
	// constructor
	public AR_ApplicationBaseController() {
		this.application = new AR_SObjectHolder(new ar_Application__c());
		this.formObjects = new Map<String,AR_SObjectHolder>();
		this.formLists = new Map<String,List<AR_SObjectHolder>>();
		
		// get application id
		String x_CookieId = AR_SessionHandler.GetAgencyId();
		if(x_CookieId != null) {
			// basic application info needed across all steps
			ar_Application__c[] apps = [select id, form_progress__c, Status__c from ar_Application__c where id =:x_CookieId];
			if(!apps.isEmpty())
				this.application = new AR_SObjectHolder(apps[0]);
		} else {
			system.debug(logginglevel.warn, 'NO COOKIE found.');
		}
	}
	
	// to be called by <apex:page init={}/>
	public PageReference initPage() {
		system.debug(logginglevel.info, '### Initialising page...');
		
		system.debug('£££' + UserInfo.getUserType());
		
		if(this.application.getId() == null) {
			system.debug(logginglevel.warn, 'No Application Id found. Redirecting to home');
			return Page.AR_LandingPage;
		} else {
			String status = (String)this.application.obj.get('status__c');
			// only Incomplete or Rejected applications can be edited
			if(status != null)
			{
				if(!status.equalsIgnoreCase('Incomplete') && !status.equalsIgnoreCase('Rejected')) {
					system.debug(logginglevel.warn, 'Application is under approval process and cannot be edited.');
					return Page.ar_applicationthanks;
				}
			}
		}
		
		setCurrentStep();
		loadMyFieldSets();
		loadData();
		loadObjectsForProgressBar();
		
		return null;
	}
	
	private void setCurrentStep() {
		system.debug(logginglevel.info, '### Setting current step...');
		String url = System.currentPageReference().getUrl().toLowerCase();
		system.debug(logginglevel.info, 'Current page: ' + url);
		for(Integer step : pagesOrder.keySet()) {
			String page = pagesOrder.get(step);
			if(url.contains( page.toLowerCase() ))
				this.currentStep = step;
		}
		system.debug(logginglevel.info, 'Current step: ' + currentStep);
	}
	
	private virtual void loadData() {
		loadMyData();
	}
	
	// method to be called by all Save buttons in the form.
	public PageReference save() {
		doSave();
		return null;
	}
		
	// template method for saving process. It calls all methods involved in the correct order. Can be override by child controllers for particular situations
	public virtual boolean doSave() {
		try {
			//TODO save progress bar status and other minimum info
			saveMyData();
		} catch(Exception e) {
			system.debug(logginglevel.error, 'ERROR saving records on step ' + currentStep + ': ' + e.getMessage());
			return false;
		}
		return true;
	}
	
	public PageReference submitApplication() {
		system.debug(logginglevel.info, '### Submitting Application...');
		
		if(doSave()) {
		
			// progress bar
			progressBarController.checkStatus( currentStep );
			
			if(progressBarController.getProgressBar().getStatus() == progressBarController.getProgressBar().getCompleteStatus()) {
				try {
					// Create an approval request for the account
			        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
			        req1.setComments('Submitting Application for approval...');
			        req1.setObjectId(application.getId());
			        
			        // Submit the approval request for the account
			        Approval.ProcessResult result = Approval.process(req1);
			        
			        return Page.ar_applicationthanks; 
				} catch(Exception e) {
					system.debug(logginglevel.error, 'ERROR submitting Application for approval: ' + e.getmessage());
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Application could not be submitted due to an unexpected error.'));
					return null;
				}
			} else {
				system.debug(logginglevel.error, 'ERROR All steps must be completed');
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Application cannot be submitted. All steps of the form must be completed.'));
				return null;
			}
		}
		return null;
	}
	
	protected virtual void loadObjectsForProgressBar() {}
	
	// force chid controllers to query and save only their relevant data
	private abstract void loadMyFieldSets(); // each child controller will describe field sets relevant to its step
	private abstract void loadMyData(); // each child controller will query data relevant to its step (data and field sets)
	private abstract void saveMyData(); // each child controller will save data relevant to its step
	
	// redirects to specified step (based on pageOrder map on this controller)
	public PageReference changeStep(Integer previousStep, Integer stepNum) {
		system.debug(logginglevel.info, '### Changing step to ' + stepNum);
		
		// save data first
		if(doSave()) {
		
			// progress bar
			progressBarController.checkStatus( previousStep );
			
			if(pagesOrder.containsKey(stepNum)) {
				PageReference pr = new PageReference(Site.getPrefix() + '/' + pagesOrder.get(stepNum));
				pr.setRedirect(true);
				system.debug(logginglevel.info, 'Redirecting to ' + pr.getUrl());
				// update current step
				currentStep = stepNum;
				return pr;
			} else {
				system.debug(logginglevel.warn, 'NO Page found for step ' + stepNum);
				return null;
			}
		} else {
			return null;
		}
	}
	
	// redirects to the following step
	public PageReference nextStep() {
		return changeStep(currentStep, currentStep+1);
	}
	
	// redirects to the previous step
	public  PageReference previousStep() {
		return changeStep(currentStep, currentStep-1);
	}

	public boolean hasPreviousStep() {
		return currentStep > 1;
	}
	
	public boolean hasNextStep() {
		return currentStep < pagesOrder.size();
	}
	
	
	// ----------- PROGRESS BAR STUFF
	
	public AR_ProgressBarComponentController getProgressBarController() {
		return progressBarController;
	}
	
	public void setProgressBarController(AR_ProgressBarComponentController pbController) {
		progressBarController = pbController;
	}
	
	public AR_ApplicationBaseController getThis() { // update progress bar component controller to expect this new base controller as parameter
		return this;
	}
	
	public void addFormObject(String objName, AR_SObjectHolder obj) {
		if(this.formObjects == null) this.formObjects = new Map<String,AR_SObjectHolder>();
		this.formObjects.put(objName, obj);
	}
	
	public Map<String,AR_SObjectHolder> getFormObjects() {
		system.debug(logginglevel.info, 'FORM OBJECTS: ' + this.formObjects);
		return this.formObjects;
	}
	
	public void addFormList(String objName, List<AR_SObjectHolder> objs) {
		if(this.formLists == null) this.formLists = new Map<String,List<AR_SObjectHolder>>();
		this.formLists.put(objName, objs);
	}
	
	public Map<String,List<AR_SObjectHolder>> getFormLists() {
		system.debug(logginglevel.info, 'FORM LIST: ' + this.formLists);
		return this.formLists;
	}
}