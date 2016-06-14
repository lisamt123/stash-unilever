/****************************************************************************************************************************
@Author: Cognizant
@Name: IPM_MarketPerformaceController
@Created Date: 2016/02/16
@Description: 1) Used for the Getting 6.5 records associated with local rollouts of regional project in context. 
					   2) Validates data entered into 6.5 records and then saves to database.
@Version: 1.0
@Reference: IPM_MarketPerformance component in Project Document Section Editor Page
*/
public with sharing class IPM_MarketPerformaceController {

    public ID regionalProjectId{get;set;}
    public Boolean isEditableMarketPerfomance{get; set;}
    public List<IPM_MarketPerformance__c> lstMarketPerformaceData{get;set;}
    public Map<String, String> mapPerformanceIdFieldWithErrorStyleClass{get;set;}
    
    final String STYLECLASS_NAME_CONSTANT = 'misalignedField';
    final String CLASS_NAME_CONSTANT = IPM_MarketPerformaceController.class.getName();
    public String sErrorMessage=IPM_ConstantUtils.BLANK;
    public Boolean loadMessagePanel{get;set;}
    String queryString = IPM_ConstantUtils.BLANK;
    
    //Constructor
    public IPM_MarketPerformaceController(){
        mapPerformanceIdFieldWithErrorStyleClass = new Map<String,String>();
        Map<String,String> paramMap = Apexpages.currentpage().getparameters();
        if(paramMap != null && paramMap.containsKey(IPM_ConstantUtils.SF_ID)) 
        {
            regionalProjectId =  paramMap.get(IPM_ConstantUtils.SF_ID);
            
            /*When local rollouts are created at any stage, their DEFAULT financials are created after which 6.5 records are also created.
            For the regional project id in context, get 6.5 records assocaited with its local rollouts.*/
            queryString = IPM_Utils.getSOQLQueryFromFieldSet('UML_KeyMetrics','IPM_MarketPerformance__c',false);
            queryString += ' WHERE IPMProjectRollout__r.Regional_Project__c =:  regionalProjectId AND IPMProjectRollout__r.isActive__c=true ORDER BY IPMProjectRollout__r.Name LIMIT 10000';
            lstMarketPerformaceData = Database.Query(queryString); 
            
            prepareValidationHighlihtedStyleClassMap(lstMarketPerformaceData);
        }
        loadMessagePanel = false;
    }
        
    public void save(){
        sErrorMessage = IPM_ConstantUtils.BLANK;
        prepareValidationHighlihtedStyleClassMap(lstMarketPerformaceData);
        
        /*REQ02519 : Logic to check below validations on fields:-
        Innovation Volume Share (%) -  Can NOT be greater than 100% 
		Penetration (cum) (%) -  Can NOT be greater than 100% 
		Repeat Rate (cum) (%) - Can NOT be greater than 100% 
		Weighted Distribution (%) - Can NOT be greater than 100% */

        if(!lstMarketPerformaceData.isEmpty())
        {
            for(IPM_MarketPerformance__c marketPerformance : lstMarketPerformaceData)
            {
            		for(Schema.FieldSetMember fieldSetMember : SObjectType.IPM_MarketPerformance__c.FieldSets.Performance_Fields_To_Validate.getFields())
            		{
                    	if((Double)marketPerformance.get(fieldSetMember.getFieldPath()) > 100 )
                    	{
                        	mapPerformanceIdFieldWithErrorStyleClass.put(marketPerformance.Id + fieldSetMember.getFieldPath() , STYLECLASS_NAME_CONSTANT);
                        	if(!sErrorMessage.contains(fieldSetMember.getLabel()))
                        	sErrorMessage += fieldSetMember.getLabel() + IPM_ConstantUtils.IPM_SPACE + Label.IPM_6_5_Performance_Table_Fields_Can_not_be_greater_than_100;
                    	}
            		}   
            }
            
            if(String.IsBlank(sErrorMessage))
            {
                try{
                    update lstMarketPerformaceData;
                }catch(Exception ex){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME_CONSTANT,'Update Market Performance Data',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
                    loadMessagePanel = true;  
                }
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, sErrorMessage));
                loadMessagePanel = true;
            }
        }
    }
    
    //This method is used to prepare the map with key as all the fields which need to be displayed on UI and value as styleclass of the cell on the UI which is blank string initailly.
    private void prepareValidationHighlihtedStyleClassMap(List<IPM_MarketPerformance__c> lstMarketPerformaceData)
    {	
    	for(IPM_MarketPerformance__c marketPerformance : lstMarketPerformaceData)
        {
                for(Schema.FieldSetMember fieldSetMember : SObjectType.IPM_MarketPerformance__c.FieldSets.UML_KeyMetrics.getFields())
                {
                    mapPerformanceIdFieldWithErrorStyleClass.put(marketPerformance.Id+fieldSetMember.getFieldPath() , IPM_ConstantUtils.BLANK);
                }
        }
    }
}