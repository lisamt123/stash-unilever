/**
* @author       Cognizant
* @date         27/04/2015
* @description  Wrapper class used to display financials on the ipmFinancial Page and in the Gate Documents
*/
public class IPM_FinancialValueWrapper {
    public Integer index {get; set;} //index
    public Decimal value {get; set;} //decimal value
    public Decimal difference {get; set;} //difference (For Misalignment)
    public Decimal globalValue {get;set;}
    public Decimal regionalValue {get; set;} //Regional Value (For Misalignment)
    public Decimal localValue {get; set;} //Local Value (For Misalignment)
    public Integer scale {get; set;} //decimal digits
    public Boolean isValueInvalid {get; set;} //if the value invalid
    public Boolean isGrossTOGRTIto {get; set;} //if the value invalid
    public Boolean isMinorValueInvalid {get; set;}// this is differentiate below red and yellow highlights.
    public String finextIdFieldSuffixKey {get; set;}
    public String redValidationErrorMessage {get; set;}  //Consolidated Error message for red validations
    public String yellowValidationErrorMessage {get; set;} //Consolidated Error message for yellow validations
    
    public String topFinATLabel {get;set;}
    public String bottomFinATLabel {get;set;}
    public Decimal topFinValue{get;set;}
    public Decimal bottomFinValue {get;set;}
   
    /*******************************************************************************************************
    * @description          Constructor
    * @param index          index
    * @param value          value
    * @param difference     difference
    * @return               NONE
    */

	public IPM_FinancialValueWrapper(IPM_Financial_Year__c finYear, IPM_Project__c project, String fieldSuffix, String fieldLiteral, Integer scale, IPM_Financial__c currentFinancial,String currentTab){
        this.scale = scale;
        this.index = Integer.valueOf(finYear.Year__c);
        this.value = (((Decimal) finYear.get(fieldLiteral + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX))).setScale(scale);
        this.globalValue = ((Decimal)finYear.get(fieldLiteral + IPM_ConstantUtils.IPMGLOBAL + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(scale);
        this.regionalValue = ((Decimal)finYear.get(fieldLiteral + IPM_ConstantUtils.IPMREGIONAL + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(scale);
        this.localValue = ((Decimal)finYear.get(fieldLiteral + IPM_ConstantUtils.IPMLOCAL + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(scale);
        this.difference = ((Decimal)finYear.get(fieldLiteral + IPM_ConstantUtils.IPMDIFFERENCE + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(scale);
        this.isValueInvalid = false;
        this.isMinorValueInvalid = false;
        this.isGrossTOGRTIto =false;
        this.redValidationErrorMessage = IPM_ConstantUtils.BLANK;
        this.yellowValidationErrorMessage = IPM_ConstantUtils.BLANK;
        String finextIdFieldSuffixKey = (finYear.External_Id__c+fieldLiteral).removeEnd(IPM_ConstantUtils.UNDERSCORE);
        String toFindStr ='';
        
        if(currentFinancial != null && currentFinancial.Financial_External_ID__c != null && finextIdFieldSuffixKey != null ){
        	toFindStr = finextIdFieldSuffixKey.replace(currentFinancial.Financial_External_ID__c+IPM_ConstantUtils.UNDERSCORE,IPM_ConstantUtils.BLANK);
        }
        
        if(project!= null && currentTab != null && currentFinancial != null && isConsolidatedFinValueInvalid(currentFinancial,toFindStr,IPM_ConstantUtils.RED,currentTab,project.IPMProject_Span__c)){
        	this.isValueInvalid = true;
        	this.redValidationErrorMessage = this.redValidationErrorMessage + Label.IPM_SVF_Please_check_your_MCO_financials;
        }
        else{
        	this.isValueInvalid = false;
        }
        
        if(project!= null && currentTab != null && currentFinancial != null && isConsolidatedFinValueInvalid(currentFinancial,toFindStr,IPM_ConstantUtils.YELLOW,currentTab,project.IPMProject_Span__c)){
        	this.isMinorValueInvalid = true;
        	this.yellowValidationErrorMessage = this.yellowValidationErrorMessage + Label.IPM_SVF_Please_check_your_MCO_financials;
        }
        else{
        	this.isMinorValueInvalid = false;
        }
        this.finextIdFieldSuffixKey = finextIdFieldSuffixKey;
        
        if(currentFinancial != null && currentFinancial.Local_Project__c != null){
        	if(currentFinancial.Regional_Project__c == null){
	        	this.topFinATLabel = Label.IPM_AT_GLOBAL_LEVEL;
	        	this.topFinValue = globalValue;
	        }
	        if(currentFinancial.Regional_Project__c != null){
	        	this.topFinATLabel = Label.IPM_AT_REGIONAL_LEVEL;
	        	this.topFinValue = regionalValue;
	        }
	        this.bottomFinATLabel = Label.IPM_AT_LOCAL_LEVEL;
        	this.bottomFinValue = localValue;
        }
        
    }
    
    //============================================================================================================================================================
    
   
    
    /*******************************************************************************************************
    * @description   Method to check if the consolidated financial year value has any red or yellow soft validation
    * @param currentFinancial
    * @param toFindStr
    * @param cellValidationType
    * @param currentTab
    ********************************************************************************************************/
    public boolean isConsolidatedFinValueInvalid(IPM_Financial__c currentFinancial, String toFindStr,String cellValidationType, String currentTab, String projSpan){

    	if(currentFinancial != null && String.isNotBlank(toFindStr) &&
    	   currentFinancial.Financial_External_ID__c != null &&
    	   currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE) && 
    	   currentTab != null &&
    	   currentTab.equalsIgnoreCase(IPM_ConstantUtils.TAB_MYVIEW_NAME)){
		   		//for red validations
			   if(cellValidationType!= null && cellValidationType.equalsIgnoreCase(IPM_ConstantUtils.RED) &&
			   	  currentFinancial.get(IPM_ConstantUtils.FIELD_RED_VALIDATION_CELLS+projSpan+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) != null && 
	    	      ((String) currentFinancial.get(IPM_ConstantUtils.FIELD_RED_VALIDATION_CELLS+projSpan+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).contains(toFindStr)){
				  return true;
			   }
			   //for Yellow validations
			   else if(cellValidationType!= null && cellValidationType.equalsIgnoreCase(IPM_ConstantUtils.YELLOW) &&
			   	  currentFinancial.get(IPM_ConstantUtils.FIELD_YELLOW_VALIDATION_CELLS+projSpan+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) != null && 
	    	      ((String) currentFinancial.get(IPM_ConstantUtils.FIELD_YELLOW_VALIDATION_CELLS+projSpan+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).contains(toFindStr)){
				  return true;
			   
			   }
			   
			   else{
			   	return false;
			   }
			   
    	}
    	
    	else{
		   	return false;
		}
    	
    }
    
    
    
}