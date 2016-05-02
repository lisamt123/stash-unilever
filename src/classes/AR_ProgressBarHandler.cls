global with sharing class AR_ProgressBarHandler {
    public List<Step> steps {get;set;}
    public Integer currentStep {get;set;}
    
    
    
    // FIELD SETS ORGANIZATION
    private static Map<Integer, List<String>> formLayout;
    
    /* 
        Each entry in the List must be of the form "Sobject_Name[#sub-type]:field_set_name"
    */
    static {
        formLayout = new Map<Integer, List<String>>();
        // step 1
        formLayout.put(1, new List<String>{
                'cv:supplier_code'
            }
        );
        // step 2
        formLayout.put(2, new List<String>{
                'ar_Application__c:ar_general_information'
                //'ar_Shareholder__c:shareholder', Validation no longer required
                //'cv:general_information' Validation no longer required
            }
        );
        // step 3
        formLayout.put(3, new List<String>{
                'ar_Financial__c:Financials',
                'cv:financials'
                //'ar_Competitor__c:financial' Validation not required
            }
        );
        // step 4
        formLayout.put(4, new List<String>{
                'ar_Revenue_Breakdown__c:agency_profile'
            }
        );
        // step 5
        formLayout.put(5, new List<String>{
                'ar_Geography__c:Geography_Table'
            }
        );
        // step 6
        formLayout.put(6, new List<String>{
                'ar_Insurance_and_Policy__c#Insurance:insurance'
                //'ar_Insurance_and_Policy__c#Trade:Trade_and_Regulatory_Bodies', Validation no longer required
                //'cv:insurance' Validation no longer required
            }
        );
        // step 7
        formLayout.put(7, new List<String>{
                //'ar_Supplier_Info__c:Supplier_Info', Validation no longer required
                //'cv:supplier_info' Validation no longer required
            }
        );
        // step 8
        formLayout.put(8, new List<String>{
                'ar_Experience__c:Agency_Exp'
                //'cv:expertise' Validation not required
            }
        );
        // step 9
        formLayout.put(9, new List<String>{
                'ar_Experience__c#ULExperience:experience',
                'ar_Experience__c#NonULExperience:experience'
            }
        );
        // step 10
        formLayout.put(10, new List<String>{
            'cv:agency_profile'
            }
        );
        // step 11
        formLayout.put(11, new List<String>{
            'ar_Rate_Card__c:Ratecard'
            }
        );
        // step 12
        formLayout.put(12, new List<String>{
            'cv:fixed_priced_rate_cards'
            }
        );
    }
            
    // Maps used for progress validation
    private Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap; // all field sets across the form, grouped by SObject their belong to
    private Map<String,AR_SObjectHolder> formObjects; // data completed in the form so far and it's stored in one SObject only
    private Map<String,List<AR_SObjectHolder>> formObjectLists; // data completed in the form so far and it's stored in many SObjects (multi-entry form)
    private Map<String,CustomValidation> customValidations;
    
    public static Integer TOTAL_STEPS = 12;
    
    public static String STATUS_COMPLETED = 'completed';
    public static String STATUS_UNFINISHED = 'unfinished';
    public static String STATUS_UNTOUCHED = 'untouched';
    public static String STATUS_CURRENT = 'current';
    
    
    // INNER CLASS to render Steps on progress bar
    global class Step implements Comparable {
        public Integer stepNumber {get;set;}
        public String status {get;private set;} 
        
        // initialise a step with its number and status
        public Step(Integer stepNumber, String status) {
            this.stepNumber = stepNumber;
            this.status = status;
        }
        
        // parse a string representantion of the step status, format is step_number:status_char
        public Step(String parse) {
            this.stepNumber = 0;
            setUntouched();
            
            if(parse != null) {
                String[] tokens = parse.split(':');
                this.stepNumber = Integer.valueOf(tokens[0]);
                this.status = parseStatus(tokens[1]);
            }
        }
        
        // status_char can be any of 'c' (completed) 'u' (unfinished) 't' (untouched)
        public String parseStatus(String status_char) {
            if(status_char == 'c') return AR_ProgressBarHandler.STATUS_COMPLETED;
            if(status_char == 'u') return AR_ProgressBarHandler.STATUS_UNFINISHED;
            return AR_ProgressBarHandler.STATUS_UNTOUCHED;
        }
        
        // used to sort lists of steps
        global Integer compareTo(Object compareTo) {
            Step stepToCompare = (Step)compareTo;
            if(this.stepNumber == stepToCompare.stepNumber) return 0;
            if(this.stepNumber > stepToCompare.stepNumber) return 1;
            return -1;
        }
        
        public void setStatus(String s) {
            this.status = s;
        }
        
        public void setUnfinished() {
            this.status = AR_ProgressBarHandler.STATUS_UNFINISHED; 
        }
        
        public void setUntouched() {
            this.status = AR_ProgressBarHandler.STATUS_UNTOUCHED; 
        }
        
        public void setCurrent() {
            this.status = AR_ProgressBarHandler.STATUS_CURRENT; 
        }
        
        public boolean getIsCompleted() {
            return this.status == AR_ProgressBarHandler.STATUS_COMPLETED;
        }
        
        public boolean getIsUnfinished() {
            return this.status == AR_ProgressBarHandler.STATUS_UNFINISHED;
        }
        
        public boolean getIsCurrent() {
            return this.status == AR_ProgressBarHandler.STATUS_CURRENT;
        }
        
        // translates the step status to string
        public String getStatus() {
            String sn = stepNumber + ':';
            String status = 't'; // untouched
            if(getIsCompleted()) status = 'c';
            if(getIsUnfinished()) status = 'u';
            return sn + status;
        }
        
        public String getStepLabel()
   		{
    	if(stepNumber == 1)
    	{
    		return System.Label.ar_stepOne;
    	}
    	
    	if(stepNumber == 2)
    	{
    		return System.Label.ar_stepTwo;
    	}
    	
    	if(stepNumber == 3)
    	{
    		return System.Label.ar_stepThree;
    	}
    	
    	
    	if(stepNumber == 4)
    	{
    		return System.Label.ar_stepFour;
    	}
    	
    	if(stepNumber == 5)
    	{
    		return System.Label.ar_stepFive;
    	}
    	
    	if(stepNumber == 6)
    	{
    		return System.Label.ar_stepSix;
    	}
    	
    	if(stepNumber == 7)
    	{
    		return System.Label.ar_stepSeven;
    	}
    	if(stepNumber == 8)
    	{
    		return System.Label.ar_stepEight;
    	}
    	if(stepNumber == 9)
    	{
    		return System.Label.ar_stepNine;
    	}
    	if(stepNumber == 10)
    	{
    		return System.Label.ar_stepTen;
    	}
    	if(stepNumber == 11)
    	{
    		return System.Label.ar_stepEleven;
    	}
    	if(stepNumber == 12)
    	{
    		return System.Label.ar_stepTwelve;
    	}
    	return 'none';
    	}
    }
    
    // ------------------------------------------------------ FINISH INNER CLASS --------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------------------------------------
    
    // @lastStatus A string with record of the last completed steps (1,c|2,u|4,t)
    public AR_ProgressBarHandler(String lastStatus) {
        this.formObjects = new Map<String,AR_SObjectHolder>();
        this.formObjectLists = new Map<String,List<AR_SObjectHolder>>();
        this.customValidations = new Map<String,CustomValidation>();
        
        loadSteps();
        loadLastStatus(lastStatus);
    }
    
    // load a pre-set amount of steps
    private void loadSteps() {
        this.steps = new List<Step>();
        for(Integer i=1; i <= TOTAL_STEPS ; i++) {
            this.steps.add(new Step(i, AR_ProgressBarHandler.STATUS_UNTOUCHED));
        }
    }
    
    // initialise the overall status of the Bar from a semi-colon separated string  
    private void loadLastStatus(String status) {
        system.debug(logginglevel.info, '### Loading last status of the form in Progress Bar: ' + status);
        if(status != null && status.trim() != '') {
            // transform status string into a list of steps
            List<Step> lastStatus = new List<Step>();
            for(String step : status.split(';')) {
                Step s = new Step(step); // at the moment, lastStatus contains record of completed steps only
                system.debug(logginglevel.info, '>>> Str_Step: ' + step + ' StepNbr: ' + s.stepNumber + ' Status: ' + s.status);
                lastStatus.add(s);
            }
            lastStatus.sort();
            
            for(Step s : this.steps) {
                for(Step lastS : lastStatus) {
                    if(s.stepNumber == lastS.stepNumber)
                        s.status = lastS.status;
                    if(s.stepNumber <= lastS.stepNumber)
                        break; // stop loop
                }
            }
        }
    }
    
    // translates overall status of the Bar to string
    public String getStatus() {
        system.debug(logginglevel.info, '### Getting progress bar status...');
        String status = '';
        for(Step s : steps) {
            if(s.getIsCompleted() || s.getIsUnfinished()) {
                status += s.getStatus() + ';';
            }
        }
        if(status.length() > 0)
            status = status.removeEnd(';');
            
        system.debug(logginglevel.info, 'Progress Bar status: ' + status);
        return status;
    }
    
    public String getCompleteStatus() {
        String str = '';
        for(Integer i=1; i <= TOTAL_STEPS ; i++) {
            Step s = new Step(i, AR_ProgressBarHandler.STATUS_COMPLETED);
            str += s.getStatus() + ';';
        }
        if(str.length() > 0)
            str = str.removeEnd(';');
        return str;
    }
    
    // progress Bar status is based on Field Sets displayed on each step
    public void setFieldSetMap(Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap) {
        this.fieldSetMap = fieldSetMap;
    }
    
    // Objects used across the form to store input data
    public void setFormObjects(Map<String,AR_SObjectHolder> objects) {
        this.formObjects = objects;
    }
    
    // List of Objects used across the form to store input data
    public void setFormLists(Map<String,List<AR_SObjectHolder>> lists) {
        this.formObjectLists = lists;
    }
    
    public void setCustomValidations(Map<String,CustomValidation> customValidations) {
        this.customValidations = customValidations;
    }
    
    public void setCurrentStep(Integer step) {
        system.debug(logginglevel.info, '### Setting Progress Bar\'s current step to ' + step);
        for(Step s : steps) {
            if(s.getIsCurrent())
                s.setUnfinished(); // TODO run check status
            if(s.stepNumber == step)
                s.setCurrent();
        }
    }
    
    // check status of all steps
    public String checkProgressBarStatus() {
        system.debug(logginglevel.info, '### Checking status of the Progress Bar...');
        
        String status = '';
        Integer unfinished = 0;
        Integer completed = 0;
            
        for(Step s : steps) {
            String stepStatus = checkStep(s.stepNumber);
            completed += stepStatus == AR_ProgressBarHandler.STATUS_COMPLETED ? 1 : 0;
            unfinished += stepStatus == AR_ProgressBarHandler.STATUS_UNFINISHED ? 1 : 0;
        }
        
        // RESULTS!
        if(completed ==  steps.size())
            status = AR_ProgressBarHandler.STATUS_COMPLETED;
        else
            if(unfinished > 0 || completed > 0)
                status = AR_ProgressBarHandler.STATUS_UNFINISHED;
            else
                status = AR_ProgressBarHandler.STATUS_UNTOUCHED;
                
        system.debug(logginglevel.info, 'PROGRESS BAR STATUS: ' + status);
        return status;
    }
    
    // check if all fields of a particular step are completed
    public String checkStep(Integer step) {
        system.debug(logginglevel.info, '### Checking status of STEP ' + step);
        String status = AR_ProgressBarHandler.STATUS_UNTOUCHED;
        
        // valid step?
        if(formLayout.containsKey(step)) {
            system.debug(logginglevel.info, 'Items to check: ' + formLayout.get(step).size());
            
            Integer unfinished = 0;
            Integer completed = 0;
            
            // loop through all field sets on step
            for(String section : formLayout.get(step)) {  // section is of the form "Sobject_Name[#sub-type]:field_set_name"
                String objName      = section.split(':')[0];
                String dataKey = objName;
                
                // some Sobjects are shared to pupulate different Tables (lists)
                // sub-types are used to differenciate which List has to be retrieved from formObjectsLists
                if(objName.contains('#')) { // sub-types (i.e. ar_Insurance_and_Policy__c#Insurance)
                    objName = objName.split('#')[0];
                }
                    
                String fieldSetName = section.split(':')[1].toLowerCase();
                String fsStatus = '';
                system.debug(logginglevel.info, 'Checking Obj: ' + objName + ' | Sub-Type: '+dataKey+' | FieldSet: ' + fieldSetName);
                
                // custom validations
                if(objName.equalsIgnoreCase('cv')) {
                    system.debug(logginglevel.info, 'Custom validation: ' + section);
                    if(customValidations.containsKey(fieldSetName)) {
                        CustomValidation cv = customValidations.get(fieldSetName);
                        fsStatus = cv.validate(formObjects, formObjectLists, fieldSetMap);
                    } else {
                        system.debug(logginglevel.warn, 'NO CUSTOM VALIDATION FOUND FOR "'+fieldSetName+'"');
                    }
                } else {
                
                    // get field set members
                    List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
                    if(fieldSetMap.containsKey( objName ) && fieldSetMap.get( objName ).get( fieldSetName ) != null) {
                        fieldSet = fieldSetMap.get( objName ).get( fieldSetName );
                    } else {
                        system.debug(logginglevel.warn, 'NO FIELD SET DEFINITION FOUND FOR "'+fieldSetName+'"');
                    }
                    
                    // Object validation
                    if(formObjects.containsKey(dataKey)) {
                        // get obj data
                        AR_SObjectHolder obj = formObjects.get( dataKey );
                        fsStatus = checkObjectData( obj, fieldSet);
                    } else
                        // List validation
                        if(formObjectLists.containsKey(dataKey)) {
                            List<AR_SObjectHolder> objList = formObjectLists.get( dataKey );
                            fsStatus = checkObjectListData( objList , fieldSet, 1);
                        } else {
                            system.debug(logginglevel.warn, 'NO DATA FOUND TO CHECK FOR "'+dataKey+'"');
                        }
                }
                    
                completed += fsStatus == AR_ProgressBarHandler.STATUS_COMPLETED ? 1 : 0;
                unfinished += fsStatus == AR_ProgressBarHandler.STATUS_UNFINISHED ? 1 : 0;
            }
            
            // RESULTS!
            if(completed ==  formLayout.get(step).size())
                status = AR_ProgressBarHandler.STATUS_COMPLETED;
            else
                if(unfinished > 0 || completed > 0)
                    status = AR_ProgressBarHandler.STATUS_UNFINISHED;
                else
                    status = AR_ProgressBarHandler.STATUS_UNTOUCHED;
            
        } else {
            system.debug(logginglevel.WARN, 'NO DETAILS FOUND FOR STEP ' + step);
            status = AR_ProgressBarHandler.STATUS_UNTOUCHED;
        }
        
        // update status
        steps.get(step-1).setStatus(status);
        
        system.debug(logginglevel.info, 'STATUS OF STEP ' + step + ' IS ' + status);
        return status;
    }
    
    // checks if the object has all specified fields completed
    public static String checkObjectData( AR_SObjectHolder objHolder, List<Schema.FieldSetMember> fieldList) {
        system.debug(logginglevel.info, '### Checking completion of obj ' + objHolder + ' in '+fieldList.size() + ' fields');
        
        String status = AR_ProgressBarHandler.STATUS_UNTOUCHED;
        Integer completed = 0;
        SObject obj = objHolder.obj;
        
        //change
        Integer tmp_NumberofExcludetFields = 0;
        String objName =  String.valueOf(obj.getSObjectType());
        List<AR_Excluded_Fields__c> tmp_mcs = AR_Excluded_Fields__c.getall().values();
        Map<String,Set<String>> tmp_ExcludeMap = new Map<String,Set<String>>();
        for(AR_Excluded_Fields__c f:tmp_mcs)
        {
        	if(!tmp_ExcludeMap.containsKey(f.ObjectName__c))
        	{
        		tmp_ExcludeMap.put(f.ObjectName__c,new Set<String>());
        	}
        	tmp_ExcludeMap.get(f.ObjectName__c).add(f.FieldName__c);
        }
        //change
        
        // loop over each field in the set
        for(Schema.FieldSetMember fsMember : fieldList) {
        	if(!tmp_ExcludeMap.containsKey(objName) ||(tmp_ExcludeMap.containsKey(objName) && !tmp_ExcludeMap.get(objName).contains(fsMember.getFieldPath())) )
        	{
	            String field = fsMember.getFieldPath();
	            boolean isCompleted = obj.get( field ) != null && String.valueOf( obj.get(field) ).stripHtmlTags().trim() != '';
	            
	            system.debug(logginglevel.info, 'Checking field: ' + field + ' | completed: ' + (obj.get( field ) != null) + ' | value: "'+obj.get(field)+'"');
	            
	            // has value?
	            if(isCompleted) completed++;
        	}
        	else
        	{
        		tmp_NumberofExcludetFields = tmp_NumberofExcludetFields + 1;
        	}
        }
        
        // RESULTS!
        //change 
        Integer FieldListSize = fieldList.size();
        if(tmp_ExcludeMap.containsKey(objName))
        {
        	FieldListSize = fieldList.size() - tmp_NumberofExcludetFields;
        }
        //change 
        if(completed == 0)
            status = AR_ProgressBarHandler.STATUS_UNTOUCHED;
        else 
            if(completed < FieldListSize)
                status = AR_ProgressBarHandler.STATUS_UNFINISHED;
            else
                status = AR_ProgressBarHandler.STATUS_COMPLETED;
                
        system.debug(logginglevel.info, 'STATUS of this Field Set is: ' + status);
        return status;
    }
    
    // checks if at least one object in the list has all specified fields completed
    private static String checkObjectListData( List<AR_SObjectHolder> objList, List<Schema.FieldSetMember> fieldList, Integer minimumRequired) {
        system.debug(logginglevel.info, '### Checking completion of list ' + objList + ' in '+fieldList.size() + ' fields - Minimum Required: ' + minimumRequired);
        
        String status = AR_ProgressBarHandler.STATUS_UNTOUCHED;
        Integer completed = 0;
        
        for(AR_SObjectHolder obj : objList) {
            status = checkObjectData( obj, fieldList);
            
            if(status == AR_ProgressBarHandler.STATUS_COMPLETED) {
                completed++;
            }
        }
        
        system.debug(logginglevel.info, 'Fields completed: ' + completed);
        
        if(completed >= minimumRequired)
            status = AR_ProgressBarHandler.STATUS_COMPLETED;
        else
            if(objList.size() > 0)
                status = AR_ProgressBarHandler.STATUS_UNFINISHED;
                
        system.debug(logginglevel.info, '*** LIST STATUS for this Field Set is: ' + status);
        return status;
    }
    
    // ----------------------------------------------------------------------------------------------------------------------------------------
    // ------------------------------------------------------- CUSTOM VALIDATION CLASS --------------------------------------------------------
    
    public abstract class CustomValidation {
        public abstract String validate(Map<String,AR_SObjectHolder> formObjects, Map<String,List<AR_SObjectHolder>> formObjectLists, Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap);
    }
    
    // supplier code (step 1)
    public class SupplierCodeValidation extends CustomValidation {
        public override String validate(Map<String,AR_SObjectHolder> formObjects, Map<String,List<AR_SObjectHolder>> formObjectLists, Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap) {
            system.debug(logginglevel.info, '### Validating Supplier Code...');
            String result = AR_ProgressBarHandler.STATUS_UNFINISHED;
            if(formObjects.containsKey('ar_Application__c')) {
                AR_SObjectHolder app = (AR_SObjectHolder)formObjects.get('ar_Application__c');
                system.debug(logginglevel.info, '>>> Application: ' + app);
                if(((ar_Application__c)app.obj).Agree_to_comply_Unilever_Supplier_Code__c == 'Yes')
                    result = AR_ProgressBarHandler.STATUS_COMPLETED;
            }
            system.debug(logginglevel.info, '>>> Result: ' + result);
            return result;
        }
    }
    // general information
    public class GeneralInformationValidation extends CustomValidation {
        public override String validate(Map<String,AR_SObjectHolder> formObjects, Map<String,List<AR_SObjectHolder>> formObjectLists, Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap) {
            system.debug(logginglevel.info, '### Validating General Information...');
            String result = AR_ProgressBarHandler.STATUS_UNFINISHED;
            if(formObjects.containsKey('ar_Application__c')) {
                AR_SObjectHolder app = (AR_SObjectHolder)formObjects.get('ar_Application__c');
                system.debug(logginglevel.info, '>>> General Information files:');
                Attachment att1 = app.getFiles().get('one');
                Attachment att2 = app.getFiles().get('two');
                system.debug(logginglevel.info, '>>> Stracture Chart Length (file1) ' + att1.id);
                system.debug(logginglevel.info, '>>> Industry Qualification Length (file2) ' + att2.id);
                if(att1.id != null)
                    result = AR_ProgressBarHandler.STATUS_COMPLETED;
            }
            system.debug(logginglevel.info, '>>> Result: ' + result);
            return result;
        }
    }
    // financials (step 3)
    public class FinancialsValidation extends CustomValidation {
        public override String validate(Map<String,AR_SObjectHolder> formObjects, Map<String,List<AR_SObjectHolder>> formObjectLists, Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap) {
            system.debug(logginglevel.info, '### Validating Financials...');
            String result = AR_ProgressBarHandler.STATUS_UNFINISHED;
            if(formObjects.containsKey('ar_Application__c')) {
                AR_SObjectHolder app = (AR_SObjectHolder)formObjects.get('ar_Application__c');
                system.debug(logginglevel.info, '>>> Application: ' + app);
                String val = ((ar_Application__c)app.obj).Length_of_client_relationship__c;
                if(val!= null && val != '')
                    result = AR_ProgressBarHandler.STATUS_COMPLETED;
            }
            system.debug(logginglevel.info, '>>> Result: ' + result);
            return result;
        }
    }
    // insurance (step 6)
    public class InsuranceValidation extends CustomValidation {
        public override String validate(Map<String,AR_SObjectHolder> formObjects, Map<String,List<AR_SObjectHolder>> formObjectLists, Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap) {
            system.debug(logginglevel.info, '### Validating Insurance...');
            String result = AR_ProgressBarHandler.STATUS_UNFINISHED;
            
            // Policies entries
            List<AR_SObjectHolder> policies = formObjectLists.get('ar_Insurance_and_Policy__c#Policy');
            String policiesStatus = AR_ProgressBarHandler.STATUS_UNFINISHED;
            if(policies != null) {
                Integer policiesCompleted = 0;
                for(AR_SObjectHolder policy : policies) {
                    system.debug(logginglevel.info, 'Policy: ' + policy.obj.get('Policy__c') + ' File length: ' + policy.getFiles().get('one'));
                    if(policy.getFiles().get('one').id != null)
                        policiesCompleted++;
                }
                system.debug(logginglevel.info, 'Policies completed: ' + policiesCompleted);
                if(policiesCompleted == policies.size())
                    policiesStatus = AR_ProgressBarHandler.STATUS_COMPLETED;
            }
            // Additional information
            String additionalInfoStatus = AR_ProgressBarHandler.STATUS_UNFINISHED;
            if(formObjects.containsKey('ar_Application__c')) {
                AR_SObjectHolder app = (AR_SObjectHolder)formObjects.get('ar_Application__c');
                system.debug(logginglevel.info, '>>> Application: ' + app);
                String val = ((ar_Application__c)app.obj).Additional_Information__c;
                if(val!= null && val.stripHtmlTags().trim() != '')
                    additionalInfoStatus = AR_ProgressBarHandler.STATUS_COMPLETED;
            }
            
            system.debug(logginglevel.info, '>>> policiesStatus: ' + policiesStatus);
            system.debug(logginglevel.info, '>>> additionalInfoStatus: ' + additionalInfoStatus);
            
            // final result
            if(policiesStatus == AR_ProgressBarHandler.STATUS_COMPLETED && additionalInfoStatus == AR_ProgressBarHandler.STATUS_COMPLETED)
                result = AR_ProgressBarHandler.STATUS_COMPLETED;
                
            system.debug(logginglevel.info, '>>> Result: ' + result);
            return result;
        }
    }
    // supplier info (step 7)
    public class SupplierInfoValidation extends CustomValidation {
        public override String validate(Map<String,AR_SObjectHolder> formObjects, Map<String,List<AR_SObjectHolder>> formObjectLists, Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap) {
            system.debug(logginglevel.info, '### Validating Supplier Info...');
            String result = AR_ProgressBarHandler.STATUS_UNFINISHED;
            if(formObjectLists.containsKey('ar_Supplier_Info__c')) {
                Integer files = 0; // one file per row
                for(AR_SObjectHolder holder : formObjectLists.get('ar_Supplier_Info__c')) {
                    Attachment att1 = holder.getFiles().get('one');
                    system.debug(logginglevel.info, '>>> Rates file Length (file1) ' + att1.id);
                    if(att1.id != null)
                        files++;
                }
                if(files == formObjectLists.get('ar_Supplier_Info__c').size())
                    result = AR_ProgressBarHandler.STATUS_COMPLETED;
            }
            system.debug(logginglevel.info, '>>> Result: ' + result);
            return result;
        }
    }
    // agency expertise
    public class AgencyExpertiseValidation extends CustomValidation {
        public override String validate(Map<String,AR_SObjectHolder> formObjects, Map<String,List<AR_SObjectHolder>> formObjectLists, Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap) {
            system.debug(logginglevel.info, '### Validating Agency Expertise...');
            String result = AR_ProgressBarHandler.STATUS_UNFINISHED;
            if(formObjects.containsKey('ar_Experience__c')) {
                AR_SObjectHolder exp = (AR_SObjectHolder)formObjects.get('ar_Experience__c');
                Attachment att1 = exp.getFiles().get('one');
                Attachment att2 = exp.getFiles().get('two');
                Attachment att3 = exp.getFiles().get('three');
                Attachment att4 = exp.getFiles().get('four');
                system.debug(logginglevel.info, '>>> Case studies file Length (file1) ' + att1.id);
                system.debug(logginglevel.info, '>>> Agency\'s design process file Length (file2) ' + att2.id);
                system.debug(logginglevel.info, '>>> Recent case studies file Length (file3) ' + att3.id);
                system.debug(logginglevel.info, '>>> Agency\'s view point file Length (file4) ' + att4.id);
                if(att1.id != null && att2.id != null && att3.id != null && att4.id != null)
                    result = AR_ProgressBarHandler.STATUS_COMPLETED;
            }
            system.debug(logginglevel.info, '>>> Result: ' + result);
            return result;
        }
    }
    // agency profile
    public class AgencyProfileValidation extends CustomValidation {
        public override String validate(Map<String,AR_SObjectHolder> formObjects, Map<String,List<AR_SObjectHolder>> formObjectLists, Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap) {
            system.debug(logginglevel.info, '### Validating Agency Profile...');
            String result = AR_ProgressBarHandler.STATUS_UNFINISHED;
            String applicationStatus = AR_ProgressBarHandler.STATUS_UNFINISHED;
            String projectStatus = AR_ProgressBarHandler.STATUS_UNFINISHED;
            // validation on application
            if(formObjects.containsKey('ar_Application__c')) {
                AR_SObjectHolder app = (AR_SObjectHolder)formObjects.get('ar_Application__c');
                Attachment att3 = app.getFiles().get('three');
                system.debug(logginglevel.info, '>>> Cover photo (file3) ' + att3.id);
                
                boolean isStrategicCapabilitiesOk = app.obj.get('Strategic_Capabilities__c') != null && String.valueOf(app.obj.get('Strategic_Capabilities__c')).stripHtmlTags().trim() != '';
                boolean isVimeoOk = app.obj.get('Vimeo_Link__c') != null && String.valueOf(app.obj.get('Vimeo_Link__c')).stripHtmlTags().trim() != '';
                boolean isExpertiseOk = app.obj.get('Agency_Expertise__c') != null && String.valueOf(app.obj.get('Agency_Expertise__c')).stripHtmlTags().trim() != '';
                boolean isAwardsOk = app.obj.get('Awards__c') != null && String.valueOf(app.obj.get('Awards__c')).stripHtmlTags().trim() != '';
                
                system.debug(logginglevel.info, '>>> isStrategicCapabilitiesOk: ' + isStrategicCapabilitiesOk);
                system.debug(logginglevel.info, '>>> isVimeoOk: ' + isVimeoOk);
                system.debug(logginglevel.info, '>>> isExpertiseOk: ' + isExpertiseOk);
                system.debug(logginglevel.info, '>>> isAwardsOk: ' + isAwardsOk);
                
                // projects
                // lists to validate
            	List<AR_SObjectHolder> projectRecords = formObjectLists.get('ar_Experience__c');
	            // fieldsets to validate
            	List<Schema.FieldSetMember> project_fieldMembers = fieldSetMap.get('ar_Experience__c').get('project');
                
				// validate project fieldset
            	if(projectRecords != null && project_fieldMembers != null) {
                	projectStatus = checkObjectListData( projectRecords, project_fieldMembers, 1); // minimum 1 project is required but all fields must be completed
                	
                	// validate project files. Only main image is required
                	Integer files = 0;
                	system.debug(logginglevel.info, 'Checking projects main images...');
                	for(AR_SObjectHolder holder : formObjectLists.get('ar_Experience__c')) {
	                    Attachment att1 = holder.getFiles().get('one');
	                    system.debug(logginglevel.info, '>>> Main project image (file1) ' + att1.id);
	                    if(att1.id != null)
	                        files++;
	                }
	                
	                // if all projects have all fields completed and main image uploaded
	                if(projectStatus == AR_ProgressBarHandler.STATUS_COMPLETED && files == projectRecords.size())
	                	projectStatus = AR_ProgressBarHandler.STATUS_COMPLETED;
	                else
	                	projectStatus = AR_ProgressBarHandler.STATUS_UNFINISHED;
            	}
 				system.debug(logginglevel.info, '>>> Project status: ' + projectStatus);
 				
                if(att3.id != null && isStrategicCapabilitiesOk && isVimeoOk && isExpertiseOk && isAwardsOk) {
                    applicationStatus = AR_ProgressBarHandler.STATUS_COMPLETED;
                }
                system.debug(logginglevel.info, '>>> Application status: ' + applicationStatus);
            }
            
            if(applicationStatus == AR_ProgressBarHandler.STATUS_COMPLETED && projectStatus == AR_ProgressBarHandler.STATUS_COMPLETED) {
                result = AR_ProgressBarHandler.STATUS_COMPLETED;
            }
            
            system.debug(logginglevel.info, '>>> Result: ' + result);
            return result;
        }
    }
    // fixed priced rate cards (step 12)
    public class FixedPricedRateCardValidation extends CustomValidation {
        public override String validate(Map<String,AR_SObjectHolder> formObjects, Map<String,List<AR_SObjectHolder>> formObjectLists, Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap) {
            system.debug(logginglevel.info, '### Validating Fixed Priced Rate Cards...');
            String result = AR_ProgressBarHandler.STATUS_UNFINISHED;
            // lists to validate
            List<AR_SObjectHolder> taskRecords = formObjectLists.get('ar_Fixed_Price_Rate_Card__c#Task');
            List<AR_SObjectHolder> artworkRecords = formObjectLists.get('ar_Fixed_Price_Rate_Card__c#Artwork');
            
            // fieldsets to validate
            List<Schema.FieldSetMember> task_fieldMembers = fieldSetMap.get('ar_Fixed_Price_Rate_Card__c').get('task_validation');
            List<Schema.FieldSetMember> artwork_fieldMembers = fieldSetMap.get('ar_Fixed_Price_Rate_Card__c').get('artwork_validation');
                
            // initialise validation results
            String taskStatus = AR_ProgressBarHandler.STATUS_UNFINISHED;
            String artworkStatus = AR_ProgressBarHandler.STATUS_UNFINISHED;
            String CountryStatus = AR_ProgressBarHandler.STATUS_UNFINISHED;
            
            // validate task fieldset
            if(taskRecords != null && task_fieldMembers != null)
                taskStatus = checkObjectListData( taskRecords, task_fieldMembers, taskRecords.size()); // All records in the list must be fully completed
                
            // validate artwork fieldset
            if(artworkRecords != null && artwork_fieldMembers != null)
                artworkStatus = checkObjectListData( artworkRecords, artwork_fieldMembers, artworkRecords.size()); // All records in the list must be fully completed
            
            // application validation
            if(formObjects.containsKey('ar_Fixed_Price_Rate_Card_Location__c')) {
                AR_SObjectHolder app = (AR_SObjectHolder)formObjects.get('ar_Fixed_Price_Rate_Card_Location__c');
                system.debug(logginglevel.info, '>>> Application: ' + app);
                String val = ((ar_Fixed_Price_Rate_Card_Location__c)app.obj).Rate_Card_Comments__c;
                String val2 = ((ar_Fixed_Price_Rate_Card_Location__c)app.obj).Country__c;
                String val3 = ((ar_Fixed_Price_Rate_Card_Location__c)app.obj).Name;
                if(val!= null && val != '' && val2!= null && val2 != '' && val3!= null && val3 != '')
                    CountryStatus = AR_ProgressBarHandler.STATUS_COMPLETED;
            }
             
            // final result
            if(taskStatus == AR_ProgressBarHandler.STATUS_COMPLETED && artworkStatus == AR_ProgressBarHandler.STATUS_COMPLETED && CountryStatus == AR_ProgressBarHandler.STATUS_COMPLETED)
                result = AR_ProgressBarHandler.STATUS_COMPLETED;
                
            system.debug(logginglevel.info, '>>> Result: ' + result);
            return result;
        }
    }
    
    
    // ------------------------------------------------------- CUSTOM VALIDATION CLASS --------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------------------------------------
}