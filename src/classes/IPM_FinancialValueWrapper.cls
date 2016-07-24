/**
* @author       Cognizant
* @date         27/04/2015
* @description  Wrapper class used to display financials on the ipmFinancial Page and in the Gate Documents
*/
public class IPM_FinancialValueWrapper {
    public Integer index {get; set;} //index
    public Decimal value {get; set;} //decimal value
    public Decimal difference {get; set;} //difference (For Misalignment)
    public Decimal regionalValue {get; set;} //Regional Value (For Misalignment)
    public Decimal localValue {get; set;} //Local Value (For Misalignment)
    public Integer scale {get; set;} //decimal digits
    public Boolean isValueInvalid {get; set;} //if the value invalid
    public Boolean isGrossTOGRTIto {get; set;} //if the value invalid
    public Boolean isMinorValueInvalid {get; set;}// this is differentiate below red and yellow highlights.
    public String finextIdFieldSuffixKey {get; set;}
    public String redValidationErrorMessage {get; set;}  //Consolidated Error message for red validations
    public String yellowValidationErrorMessage {get; set;} //Consolidated Error message for yellow validations
    /*******************************************************************************************************
    * @description          Constructor
    * @param index          index
    * @param value          value
    * @param difference     difference
    * @return               NONE
    */
    public IPM_FinancialValueWrapper(Integer index, Decimal value, Decimal difference,String finextIdFieldSuffixKey, IPM_Financial__c currentFinancial, String currentTab){
        this.scale = 2;
        this.index = index;
        this.value = value.setScale(scale);
        this.difference = difference.setScale(scale);
        this.isValueInvalid = false;
        this.isMinorValueInvalid = false;
        this.isGrossTOGRTIto =false;
        this.redValidationErrorMessage = IPM_ConstantUtils.BLANK;
        this.yellowValidationErrorMessage = IPM_ConstantUtils.BLANK;
        String toFindStr ='';
        
        if(currentFinancial != null && currentFinancial.Financial_External_ID__c != null && finextIdFieldSuffixKey != null ){
        	toFindStr = finextIdFieldSuffixKey.replace(currentFinancial.Financial_External_ID__c+IPM_ConstantUtils.UNDERSCORE,IPM_ConstantUtils.BLANK);
        }
        
        
        if(isConsolidatedFinValueInvalid(currentFinancial,toFindStr,IPM_ConstantUtils.RED,currentTab)){
        	this.isValueInvalid = true;
        	this.redValidationErrorMessage = this.redValidationErrorMessage + Label.IPM_SVF_Please_check_your_MCO_financials;
        }
        else{
        	this.isValueInvalid = false;
        }
        
        if(isConsolidatedFinValueInvalid(currentFinancial,toFindStr,IPM_ConstantUtils.YELLOW,currentTab)){
        	this.isMinorValueInvalid = true;
        	this.yellowValidationErrorMessage = this.yellowValidationErrorMessage + Label.IPM_SVF_Please_check_your_MCO_financials;
        }
        else{
        	this.isMinorValueInvalid = false;
        }
        this.finextIdFieldSuffixKey = finextIdFieldSuffixKey;
    }
    
    /*******************************************************************************************************
    * @description          Constructor
    * @param index          index
    * @param value          value
    * @param difference     difference
    * @param scale          scale
    * @return               NONE
    */
    public IPM_FinancialValueWrapper(Integer index, Decimal value, Decimal difference, Integer scale,String finextIdFieldSuffixKey, IPM_Financial__c currentFinancial,String currentTab){
        this.scale = scale;
        this.index = index;
        this.value = value.setScale(scale);
        this.difference = difference.setScale(scale);
        this.isValueInvalid = false;
        this.isMinorValueInvalid = false;
        this.isGrossTOGRTIto =false;
        this.redValidationErrorMessage = IPM_ConstantUtils.BLANK;
        this.yellowValidationErrorMessage = IPM_ConstantUtils.BLANK;
        String toFindStr ='';
        
        if(currentFinancial != null && currentFinancial.Financial_External_ID__c != null && finextIdFieldSuffixKey != null ){
        	toFindStr = finextIdFieldSuffixKey.replace(currentFinancial.Financial_External_ID__c+IPM_ConstantUtils.UNDERSCORE,IPM_ConstantUtils.BLANK);
        }
        
        if(isConsolidatedFinValueInvalid(currentFinancial,toFindStr,IPM_ConstantUtils.RED,currentTab)){
        	this.isValueInvalid = true;
        	this.redValidationErrorMessage = this.redValidationErrorMessage + Label.IPM_SVF_Please_check_your_MCO_financials;
        }
        else{
        	this.isValueInvalid = false;
        }
        
        if(isConsolidatedFinValueInvalid(currentFinancial,toFindStr,IPM_ConstantUtils.YELLOW,currentTab)){
        	this.isMinorValueInvalid = true;
        	this.yellowValidationErrorMessage = this.yellowValidationErrorMessage + Label.IPM_SVF_Please_check_your_MCO_financials;
        }
        else{
        	this.isMinorValueInvalid = false;
        }
        this.finextIdFieldSuffixKey = finextIdFieldSuffixKey;
    }
    
    /*******************************************************************************************************
    * @description          Constructor
    * @param index          index
    * @param value          value
    * @param RegionalValue  RegionalValue for misalignment
    * @param LocalValue     LocalValue for misalignment
    * @param scale          scale
    */
    public IPM_FinancialValueWrapper(Integer index, Decimal value, Decimal regionalValue, Decimal localValue, Decimal difference, Integer scale,String finextIdFieldSuffixKey, IPM_Financial__c currentFinancial,String currentTab){
        this.scale = scale;
        this.index = index;
        this.value = value.setScale(scale);
        this.regionalValue = RegionalValue.setScale(scale);
        this.localValue = LocalValue.setScale(scale);
        this.difference = difference.setScale(scale);
        this.isValueInvalid = false;
        this.isMinorValueInvalid = false;
        this.isGrossTOGRTIto =false;
        this.redValidationErrorMessage = IPM_ConstantUtils.BLANK;
        this.yellowValidationErrorMessage = IPM_ConstantUtils.BLANK;
        String toFindStr ='';
        
        if(currentFinancial != null && currentFinancial.Financial_External_ID__c != null && finextIdFieldSuffixKey != null ){
        	toFindStr = finextIdFieldSuffixKey.replace(currentFinancial.Financial_External_ID__c+IPM_ConstantUtils.UNDERSCORE,IPM_ConstantUtils.BLANK);
        }
        
        if(isConsolidatedFinValueInvalid(currentFinancial,toFindStr,IPM_ConstantUtils.RED,currentTab)){
        	this.isValueInvalid = true;
        	this.redValidationErrorMessage = this.redValidationErrorMessage + Label.IPM_SVF_Please_check_your_MCO_financials;
        }
        else{
        	this.isValueInvalid = false;
        }
        
        if(isConsolidatedFinValueInvalid(currentFinancial,toFindStr,IPM_ConstantUtils.YELLOW,currentTab)){
        	this.isMinorValueInvalid = true;
        	this.yellowValidationErrorMessage = this.yellowValidationErrorMessage + Label.IPM_SVF_Please_check_your_MCO_financials;
        }
        else{
        	this.isMinorValueInvalid = false;
        }
        this.finextIdFieldSuffixKey = finextIdFieldSuffixKey;
    }
    
    /*******************************************************************************************************
    * @description          Constructor
    * @param index          index
    * @param value          value
    * @param RegionalValue  RegionalValue for misalignment
    * @param LocalValue     LocalValue for misalignment
    * @param scale          scale
    */
    public IPM_FinancialValueWrapper(Integer index, Decimal value, Decimal regionalValue, Decimal localValue, Decimal difference,String finextIdFieldSuffixKey, IPM_Financial__c currentFinancial,String currentTab){
        this.scale = 2;
        this.index = index;
        this.value = value.setScale(scale);
        this.regionalValue = RegionalValue.setScale(scale);
        this.localValue = LocalValue.setScale(scale);
        this.difference = difference.setScale(scale);
        this.isValueInvalid = false;
        this.isMinorValueInvalid = false;
        this.isGrossTOGRTIto =false;
        this.redValidationErrorMessage = IPM_ConstantUtils.BLANK;
        this.yellowValidationErrorMessage = IPM_ConstantUtils.BLANK;
        
        String toFindStr = finextIdFieldSuffixKey.replace(currentFinancial.Financial_External_ID__c+IPM_ConstantUtils.UNDERSCORE,IPM_ConstantUtils.BLANK);
        
        if(isConsolidatedFinValueInvalid(currentFinancial,toFindStr,IPM_ConstantUtils.RED,currentTab)){
        	this.isValueInvalid = true;
        	this.redValidationErrorMessage = this.redValidationErrorMessage + Label.IPM_SVF_Please_check_your_MCO_financials;
        }
        else{
        	this.isValueInvalid = false;
        }
        
        if(isConsolidatedFinValueInvalid(currentFinancial,toFindStr,IPM_ConstantUtils.YELLOW,currentTab)){
        	this.isMinorValueInvalid = true;
        	this.yellowValidationErrorMessage = this.yellowValidationErrorMessage + Label.IPM_SVF_Please_check_your_MCO_financials;
        }
        else{
        	this.isMinorValueInvalid = false;
        }
        this.finextIdFieldSuffixKey = finextIdFieldSuffixKey;
    }
    
    /*******************************************************************************************************
    * @description   Method to check if the consolidated financial year value has any red or yellow soft validation
    * @param currentFinancial
    * @param toFindStr
    * @param cellValidationType
    * @param currentTab
    ********************************************************************************************************/
    public boolean isConsolidatedFinValueInvalid(IPM_Financial__c currentFinancial, String toFindStr,String cellValidationType, String currentTab){

    	if(currentFinancial != null && String.isNotBlank(toFindStr) &&
    	   currentFinancial.Financial_External_ID__c != null &&
    	   currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE) && 
    	   currentTab != null &&
    	   currentTab.equalsIgnoreCase(IPM_ConstantUtils.TAB_MYVIEW_NAME)){
		   		//for red validations
			   if(cellValidationType!= null && cellValidationType.equalsIgnoreCase(IPM_ConstantUtils.RED) &&
			   	  currentFinancial.Red_Validation_Cells__c != null && 
	    	      currentFinancial.Red_Validation_Cells__c.contains(toFindStr)){
			   	  System.debug('currentTab==>'+currentTab);
				  System.debug('isConsolidatedFinValueInvalid==>'+cellValidationType);
				  return true;
			   }
			   //for Yellow validations
			   else if(cellValidationType!= null && cellValidationType.equalsIgnoreCase(IPM_ConstantUtils.YELLOW) &&
			   	  currentFinancial.Yellow_Validation_Cells__c != null && 
	    	      currentFinancial.Yellow_Validation_Cells__c.contains(toFindStr)){
	    	      System.debug('currentTab==>'+currentTab);
				  System.debug('isConsolidatedFinValueInvalid==>'+cellValidationType);
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