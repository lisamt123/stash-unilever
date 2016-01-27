/**
@Author Cognizant
@Name IPM_CountryTriggerHandler
@CreateDate 27/08/2015
@Description This class is used as Trigger Handler for the IPM_Project_Document_Section__c SObject.
@Version 1.0
@reference 
*/
public with sharing class IPM_CountryTriggerHandler {
    
    private boolean m_isExecuting = false;
    
    /****************************************************************************
    @Description : class Construstor
    @Params isExecuting: Boolean variable to avoid recursion
    *****************************************************************************/
    public IPM_CountryTriggerHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }
    
    /****************************************************************************
    @Description : Method which will be called in the Before insert event of IPM_Country__c SObject
    @Params newCountries: List of IPM_Country__c to be inserted
    *****************************************************************************/
    public void onBeforeInsert(IPM_Country__c[] newCountries) {
        // Interface Method
    }
    
    /****************************************************************************
    @Description : Method which will be called in the Before update event of IPM_Country__c SObject
    @Params newCountries: List of IPM_Country__c to be inserted
    @Params oldCountryMap: List of old IPM_Country__c which are updated
    *****************************************************************************/
    public void onBeforeUpdate(IPM_Country__c[] newCountries, Map<Id, IPM_Country__c> oldCountryMap) {
    	// Interface Method
    }
    
    /****************************************************************************
    @Description : Method which will be called in the Before delete event of IPM_Country__c SObject
    @Params newCountries: List of IPM_Country__c to be deleted
    *****************************************************************************/
    public void onBeforeDelete(IPM_Country__c[] newCountries) {
    	// Interface Method
    }
    
    /****************************************************************************
    @Description : Method which will be called in the After insert event of IPM_Country__c SObject
    @Params newCountries: List of IPM_Country__c to be inserted
    *****************************************************************************/
    public void onAfterInsert(IPM_Country__c[] newCountries) {
    	// Interface Method
    }
    
    /****************************************************************************
    @Description : Method which will be called in the After update event of IPM_Country__c SObject
    @Params newCountries: List of IPM_Country__c to be updated
    @Params oldCountryMap: List of old IPM_Country__c which are updated
    *****************************************************************************/
    public void onAfterUpdate(IPM_Country__c[] newCountries, Map<Id, IPM_Country__c> oldCountryMap) {
    	// Interface Method
    }
    
    /****************************************************************************
    @Description : Method which will be called in the After delete event of IPM_Country__c SObject
    @Params newCountries: List of IPM_Country__c to be deleted
    *****************************************************************************/
    public void onAfterDelete(IPM_Country__c[] newCountries) {
    	// Interface Method
    }
    
    /****************************************************************************
    @Description : Method which will be called in the After undelete event of IPM_Country__c SObject
    @Params newCountries: List of IPM_Country__c to be undeleted
    *****************************************************************************/
    public void onAfterUnDelete(IPM_Country__c[] newCountries) {
    	// Interface Method
    }
}