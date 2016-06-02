/*************************************************************************************************
*@Author:Cognizant
*@Created Date:15/03/2016
*@Description:this class is used to take input's from Finance/CMI/PD/DPL/Cental Team/Business Partner user
*for market performance break down.this is editable on Market Ready phase.Market performance data is coming
*from capability phase of regional rollout project.
**************************************************************************************************/

public with sharing class IPM_PerformanceBreakdownController {
    public IPM_MarketPerformance__c marketperformance{get;set;}//get info of market performance record
    public String projectId {get;set;}//hold project id from page url
    public IPM_Project__c project;//hold project info
    public List<IPM_MarketPerformanceBreakdown__c> marketPerformanceBreakdownList{get;set;}//hold list of market performance breakdown records
    public String marketPerString;//hold market performance id
    public decimal decMultFactor = 1.00;//decimal place value
    public decimal exRate{get;set;}//hold exchange rate value
    public map<string,decimal> mapCurrency;//map of country code and exchange rate     
    public boolean appliedRate = false;//check if other currency is selected
    public static set<string>avoidConversionSet=new set<String>{'WeightedDistribution__c','RelativePricetoMarket__c'};//set of fields name where no need to apply currency conversion
    public set<string>scaleSet=new set<string>{'MediaSpend__c'};//set of fields to set default decimal place
    public Set<string>greaterThanSet{get;set;}//set of fields name where user has entered more than 100 %
    public String sMisalignmentMsg{get;set;} //hold misaligned message
    public string period_STR{get;set;} //hold period api name
    private List<String> mktPerFldList = new List<String>();//list of fields api name
    public List<String>misAlignedList{get;set;}//hold misaligned fields name
    public Map<string,string> mapWithRecordNCell{get;set;}// map with record and field
    public boolean isgreaterThan{get;set;}//check if values are greater than 100
    private final string CLASS_NAME=IPM_PerformanceBreakdownController.class.getName();//get class name
    public boolean isMisaligned{get;set;}//check for misaligned value
    /**************************************************************************************
    *@Description :Constructor to read the information from the page paramaters , 
    *get project details based on page url parameter.
    *display market performance data and market performance break down data.
    ***************************************************************************************/
    public IPM_PerformanceBreakdownController() {   
	    Map<String,String> paramMap = Apexpages.currentpage().getparameters();
	    period_STR=IPM_ConstantUtils.PERFORMANCE_PERIOD;
        greaterThanSet=new Set<string>();
        isgreaterThan=false;
        marketPerformanceBreakdownList=new List<IPM_MarketPerformanceBreakdown__c>();
        mapWithRecordNCell=new Map<string,string>();
	    if(paramMap != null && paramMap.containsKey(IPM_ConstantUtils.SF_ID)) {
	        projectId =  paramMap.get(IPM_ConstantUtils.SF_ID);
	        list<IPM_Project__c>projectDetails=new list<IPM_Project__c>();
	        projectDetails=[Select id, Name,IPM_Project_Name__c From IPM_Project__c Where id =:projectId Limit 1];
	        if(!projectDetails.isEmpty()){
	        	project =projectDetails[0];	
	        	loadMarketPerformanceBreakDown();
	        }
	        
	    }
    } 
    /**************************************************************************************
    *@Description :getting call from constructor.
    *display market performance data and market performance break down data.
    ***************************************************************************************/
    public void loadMarketPerformanceBreakDown() { 
        Set<String> financialYearExternalIdSet = new Set<String>();
        Map<String,IPM_Financial_Year__c> financialYearMap = IPM_Utils.getRelatedY1InnovationYear(new Set<String>{project.Name});
        for(IPM_Financial_Year__c financialYear : financialYearMap.values()) {
            financialYearExternalIdSet.add(financialYear.Id);
        }
        if(!financialYearExternalIdSet.isEmpty()) {
            String marketPerformantceQueryStr =  IPM_Utils.getSOQLQueryFromFieldSet('UML_Breakdown','IPM_MarketPerformance__c',false);
            marketPerformantceQueryStr += ' WHERE IPMFinancialYear__c IN: financialYearExternalIdSet LIMIT 1';
            List<IPM_MarketPerformance__c> marketperformanceList = Database.query(marketPerformantceQueryStr);
            if(!marketperformanceList.isEmpty()) {
                // Get the Market Performance Record for the local project
                marketperformance = marketperformanceList[0];
                marketPerString = marketperformance.Id;
                // Get existing associated Market Performance Breakdown records for the  marketperformance record.
                String marketPerformantceBrkQueryStr =  IPM_Utils.getSOQLQueryFromFieldSet('UML_KeyMetrics','IPM_MarketPerformanceBreakdown__c',false);
                marketPerformantceBrkQueryStr += ' WHERE MarketPerformance__c =: marketPerString';
                //Apending Order By clause
                marketPerformantceBrkQueryStr += ' order by Sequence__c';        
                // Again fetch the final Breakdown list.
                 
                marketPerformanceBreakdownList = database.query(marketPerformantceBrkQueryStr);
                checkMisalignments();
            }
        }
        if(marketPerformanceBreakdownList!=null && !marketPerformanceBreakdownList.isEmpty()){
        	fieldMoreThanValue();
        }
        
    }
    /**************************************************************************************
    *@Description :Map of record id's and field name with css class,this is used to show table
    *cell as red color.
    *Return:Null
    ***************************************************************************************/
    public void fieldMoreThanValue(){
    	for(IPM_MarketPerformanceBreakdown__c mktPer : marketPerformanceBreakdownList)
	        {
	        	for(Schema.FieldSetMember fieldSetMember : SObjectType.IPM_MarketPerformanceBreakdown__c.FieldSets.UML_KeyMetrics.getFields())
	            {
	            	mapWithRecordNCell.put(mktPer.Id+fieldSetMember.getFieldPath() , '');
	            }
	        }
    }
    /**************************************************************************************
    *@Description :get all currency code list along with exchange rate.
    *Return:List of SelectOption
    ***************************************************************************************/
    public List<SelectOption> getItems() {
        list<IPM_Exchange_Rate__c> lstCurrency = [SELECT Currency_Code__c,Exchange_Rate__c FROM IPM_Exchange_Rate__c order by Currency_Code__c limit 10000];
        List<SelectOption> options = new List<SelectOption>();
        mapCurrency = new map<string,decimal>();
        //populate picklist with currency codes
        for(IPM_Exchange_Rate__c curr: lstCurrency){
            options.add(new SelectOption(curr.Currency_Code__c,curr.Currency_Code__c));
            mapCurrency.put(curr.Currency_Code__c, curr.Exchange_Rate__c);
        }
        return options;
    }
    /**************************************************************************************
    *@Description :set firt selected currency code as EURO on page load
    *Return:null
    ***************************************************************************************/ 
    public String selectedCurrency {
        get {
           if(selectedCurrency==null){
            selectedCurrency=IPM_ConstantUtils.EURO;
           }
           return selectedCurrency;
        }
    set; 
    }
    /**************************************************************************************
    *@Description :save 13 periods break dowm data from UI. validation is checked while saving
    *the records.misAligned is checked while saving the records.before saving the records again
    *system is converting user input values as EURO.
    ***************************************************************************************/
    public PageReference saveRecords() {
        greaterThanSet.clear();
        isgreaterThan=false;
        //get market performance breakdown data
        for(IPM_MarketPerformanceBreakdown__c mktPer:marketPerformanceBreakdownList){
            for(Schema.FieldSetMember fieldSetMember : SObjectType.IPM_MarketPerformanceBreakdown__c.FieldSets.Performance_Fields_To_Validate.getFields())
                {
                      if((Double)mktPer.get(fieldSetMember.getFieldPath()) > 100 )
                      {
                          mapWithRecordNCell.put(mktPer.id+fieldSetMember.getFieldPath(),IPM_ConstantUtils.MISALIGNED_CSS);
		                  greaterThanSet.add(fieldSetMember.getLabel()+IPM_ConstantUtils.Colon+System.label.IPM_Can_not_be_greater );
		            	  isgreaterThan=true; 
                      }
                }   
            
            
         }
        if(!isgreaterThan){
	        //if user has selected currency change then below code will execute
	        fieldMoreThanValue();
	        if(appliedRate) {
	        	List<IPM_MarketPerformanceBreakdown__c> mktPerBrkdownTempList = new List<IPM_MarketPerformanceBreakdown__c>(marketPerformanceBreakdownList);
	            marketPerformanceBreakdownList.clear();     
	            for(IPM_MarketPerformanceBreakdown__c mktPer : mktPerBrkdownTempList) {
	                IPM_MarketPerformanceBreakdown__c mktPerTemp = new IPM_MarketPerformanceBreakdown__c();
	                mktPerTemp = mktPer;
	                for(String mktFld : mktPerFldList) {
	                    integer scale=2;
	                    if(scaleSet.contains(mktFld)){
	                        scale=1;
	                    }
	                    if(mktPer.get(mktFld)!=null){
	                    	decimal fieldvalue=(Double)mktPer.get(mktFld) / decMultFactor;
	                    	mktPerTemp.put(mktFld,fieldvalue.setScale(scale));	
	                    }
	                }  
	                marketPerformanceBreakdownList.add(mktPerTemp);     
	            }
	        
	        }
	        try{
		        update marketPerformanceBreakdownList;//if validation successful then save the records
		        applyRate();
		        checkMisalignments();
	        }catch(Exception ex){
	        	isgreaterThan=true; 
                greaterThanSet.add(Label.IPM_PLEASE_CONTACT_ADMINISTRATOR);
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,'saveRecords',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
            } 
        }
        return null;
    }
    
    /**************************************************************************************
    *@Description :system is converting user input values from EURO to any other currency.
    ***************************************************************************************/
    public pageReference applyRate(){
        if (selectedCurrency!=null){
            if (mapCurrency.containsKey(selectedCurrency)){
                exrate = mapCurrency.get(selectedCurrency);
                decMultFactor = exrate; 
            }else{
                decMultFactor = 1; 
                exrate = 1;
            }
            
            //Again query database so that conversion should not be applicable to the updated values
            String marketPerformantceBrkQueryStr =  IPM_Utils.getSOQLQueryFromFieldSet('UML_KeyMetrics','IPM_MarketPerformanceBreakdown__c',false);
            marketPerformantceBrkQueryStr += ' WHERE MarketPerformance__c =: marketPerString  order by Sequence__c';
            
            marketPerformanceBreakdownList = database.query(marketPerformantceBrkQueryStr);
            mktPerFldList = getSOQLQueryFromFieldSetList('UML_KeyMetrics','IPM_MarketPerformanceBreakdown__c',false);
            List<IPM_MarketPerformanceBreakdown__c> mktPerBrkdownTempList = new List<IPM_MarketPerformanceBreakdown__c>(marketPerformanceBreakdownList);
            marketPerformanceBreakdownList.clear();
            for(IPM_MarketPerformanceBreakdown__c mktPer : mktPerBrkdownTempList) {
                IPM_MarketPerformanceBreakdown__c mktPerTemp = new IPM_MarketPerformanceBreakdown__c();
                mktPerTemp = mktPer;
                for(String mktFld : mktPerFldList){
                    integer scale=2;
                    if(scaleSet.contains(mktFld)){
                        scale=1;
                    } 
                    if(mktPer.get(mktFld)!=null){
                    	decimal fieldvalue=(Double)mktPer.get(mktFld) * decMultFactor;
	                    mktPerTemp.put(mktFld,fieldvalue.setScale(scale));	 
                    }
                    
                }   
                marketPerformanceBreakdownList.add(mktPerTemp);     
            }
        }
        appliedRate = true;
        return null;
    }
    
   /**************************************************************************************
    *@Description :get all fields name from IPM_MarketPerformanceBreakdown__c object
    ***************************************************************************************/
    public static List<String> getSOQLQueryFromFieldSetList(String fieldSetName,String fieldSetSobjectName,boolean excludePercentageFlds) {
       
        List<String> fieldNamesList = new List<String>();
        Map<String,Schema.SobjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.FieldSet targetFieldSetObject = null;
        if(globalDescribeMap.containsKey(fieldSetSobjectName)) {
            Schema.DescribeSObjectResult sobjectDescResult = globalDescribeMap.get(fieldSetSobjectName).getDescribe(); 
            Map<String, Schema.FieldSet> associatedFieldSetMap = sobjectDescResult.fieldSets.getMap();
            if(associatedFieldSetMap.containsKey(fieldSetName)) {
                targetFieldSetObject = associatedFieldSetMap.get(fieldSetName); 
                
            }
        }
        if(targetFieldSetObject != null) {
            for(Schema.FieldSetMember targetField : targetFieldSetObject.getFields()) {
                if(targetField.getFieldPath() != IPM_ConstantUtils.SF_ID && ((targetField.getType() == Schema.DisplayType.Percent && excludePercentageFlds)|| targetField.getType() == Schema.DisplayType.Double) && !avoidConversionSet.contains(targetField.getFieldPath())) {
                    fieldNamesList.add(targetField.getFieldPath());
                }
            }
        }   
        return fieldNamesList;
    }
    /**************************************************************************************
    *@Description :misAligned is checked while saving the records
    ***************************************************************************************/
    public void checkMisalignments(){
        String sOriginalMsg = system.label.IPM_Total_add_up_periods + IPM_ConstantUtils.IPM_SPACE;
        sMisalignmentMsg = IPM_ConstantUtils.BLANK;
        isMisaligned=false;
        misAlignedList=new List<String>();
        for( IPM_MarketPerformance__c ipmMarketperformance : [Select Id, IPM_Gross_Turnover__c, AggregateGrossTurnover__c,
                                                                                                  IPM_Gross_BMI__c, AggregateGrossAP__c,
                                                                                              IPM_Gross_PBI__c, AggregateGrossPBO__c,
                                                                                                  MediaSpend__c, AggregateMediaSpend__c
                                                                                                 from IPM_MarketPerformance__c where Id =: marketperformance.Id Limit 1] )
        { 
            //check if sum of gross turnover value is greater than aggregate gross turnover 
            if(ipmMarketperformance.IPM_Gross_Turnover__c <> ipmMarketperformance.AggregateGrossTurnover__c){
                sMisalignmentMsg +=  sOriginalMsg +  Schema.sObjectType.IPM_MarketPerformance__c.fields.IPM_Gross_Turnover__c.getLabel()  + IPM_ConstantUtils.Colon+ ipmMarketperformance.AggregateGrossTurnover__c + IPM_ConstantUtils.BREAKELINE;
                misAlignedList.add(sOriginalMsg +  Schema.sObjectType.IPM_MarketPerformance__c.fields.IPM_Gross_Turnover__c.getLabel()  + IPM_ConstantUtils.Colon+ ipmMarketperformance.AggregateGrossTurnover__c);
                
            } 
            //check if sum of gross BMI value is greater than aggregate gross BMI   
            if(ipmMarketperformance.IPM_Gross_BMI__c <> ipmMarketperformance.AggregateGrossAP__c){
                sMisalignmentMsg += sOriginalMsg +Schema.sObjectType.IPM_MarketPerformance__c.fields.IPM_Gross_BMI__c.getLabel() + IPM_ConstantUtils.Colon + ipmMarketperformance.AggregateGrossAP__c + IPM_ConstantUtils.BREAKELINE;
                misAlignedList.add(sOriginalMsg +Schema.sObjectType.IPM_MarketPerformance__c.fields.IPM_Gross_BMI__c.getLabel() + IPM_ConstantUtils.Colon + ipmMarketperformance.AggregateGrossAP__c);
                
            } 
            //check if sum of gross PBI value is greater than aggregate gross PBI    
            if(ipmMarketperformance.IPM_Gross_PBI__c <> ipmMarketperformance.AggregateGrossPBO__c){
                sMisalignmentMsg += sOriginalMsg + Schema.sObjectType.IPM_MarketPerformance__c.fields.IPM_Gross_PBI__c.getLabel() + IPM_ConstantUtils.Colon + ipmMarketperformance.AggregateGrossPBO__c + IPM_ConstantUtils.BREAKELINE;
                misAlignedList.add(sOriginalMsg + Schema.sObjectType.IPM_MarketPerformance__c.fields.IPM_Gross_PBI__c.getLabel() + IPM_ConstantUtils.Colon + ipmMarketperformance.AggregateGrossPBO__c);
                
            }
            //check if sum of media spend value is greater than aggregate media spend 
            if(ipmMarketperformance.MediaSpend__c <> ipmMarketperformance.AggregateMediaSpend__c){
                sMisalignmentMsg += sOriginalMsg + Schema.sObjectType.IPM_MarketPerformance__c.fields.MediaSpend__c.getLabel() + IPM_ConstantUtils.Colon + ipmMarketperformance.AggregateMediaSpend__c + IPM_ConstantUtils.BREAKELINE;
                misAlignedList.add(sOriginalMsg + Schema.sObjectType.IPM_MarketPerformance__c.fields.MediaSpend__c.getLabel() + IPM_ConstantUtils.Colon + ipmMarketperformance.AggregateMediaSpend__c);
                
            } 
             
        } 
        if(!misAlignedList.isEmpty()){
        	isMisaligned=true;
        }    

        
    }
}