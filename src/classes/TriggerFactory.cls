/**
 * Class TriggerFactory
 *
 * Used to instantiate and execute Trigger Handlers associated with sObjects.
 */
public with sharing class TriggerFactory
{
    /**
     * Public static method to create and execute a trigger handler
     *
     * Arguments:   Schema.sObjectType soType - Object type to process (SObject.sObjectType)
     *
     * Throws a TriggerException if no handler has been coded.
     */
    public static void createHandler(Schema.sObjectType soType)
    {
        // Get a handler appropriate to the object being processed
        ITrigger handler = getHandler(soType);
        
        // Make sure we have a handler registered, new handlers must be registered in the getHandler method.
        if (handler == null)
        {
            throw new TriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }
        
        // Execute the handler to fulfil the trigger
        execute(handler);
    }
    
    /**
     * private static method to control the execution of the handler
     *
     * Arguments:   ITrigger handler - A Trigger Handler to execute
     */ 
    private static void execute(ITrigger handler)
    {
        // Before Trigger
        if (Trigger.isBefore)
        {
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore();
            
            // Iterate through the records to be deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeDelete(so);
                }
            }
            // Iterate through the records to be inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.beforeInsert(so);
                }
            }
            // Iterate through the records to be updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        else
        {
            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter();
            
            // Iterate through the records deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterDelete(so);
                }
            }
            // Iterate through the records inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.afterInsert(so);
                }
            }
            // Iterate through the records updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        
        // Perform any post processing
        handler.andFinally();
    }
    
    /**
     * private static method to get the appropriate handler for the object type.
     * Modify this method to add any additional handlers.
     *
     * Arguments:   Schema.sObjectType soType - Object type tolocate (SObject.sObjectType)
     *
     * Returns:     ITrigger - A trigger handler if one exists or null.
     */
    private static ITrigger getHandler(Schema.sObjectType soType)
    {
        if (soType == FAU_Participant__c.sObjectType)
        {
            return new FAU_ParticipantHandler();
        }

        if (soType == FAU_Program__c.sObjectType) 
        {
            return new FAU_ProgramHandler();
        }       

        if (soType == Oblix_SOW_Projects__c.sObjectType){
            return new Oblix_ProjectHandler();

        }if (soType == Oblix_Marketing_SOW_Project_Splits__c.sObjectType){
            return new Oblix_SplitHandler(); 

        }if (soType == Marketing_SOW__c.sObjectType){
            return new Oblix_SOWHandler(); 

        }if (soType == Oblix_Project_Assets__c.sObjectType){
            return new Oblix_AssetHandler(); 

        }if (soType == Oblix_User_Permission__c.sObjectType){
            return new Oblix_UserPermissionHandler();
            
        }
		
        if (soType == FAU_Webinar_Participant__c.sObjectType)
        {
            return new FAU_Webinar_ParticipantHandler();
        }   
        
        if (soType == FAU_Module__c.sObjectType)
        {
            return new FAU_ModuleHandler();
        }   
        if (soType == FAU_Milestone__c.sObjectType)
        {
            return new FAU_MilestoneHandler();
        }
        if (soType == FAU_Webinar__c.sObjectType){
            return new FAU_WebinarHandler();
        } 
        
       if (soType == IPM_User_Profile__c.sObjectType){
            return new IPM_UserProfileHandler();
        }
        if (soType == IPM_Company_Card__c.sObjectType){
            return new IPM_CompanyCardHandler();
        }
        
        if (soType == IPM_Country__c.sObjectType){
            return new IPM_CountryHandler();
        }
        if (soType == IPM_Project_Resource__c.sObjectType){
           return new IPM_ProjectResourceHandler();
           
        }
        if (soType == IPM_Project_Document__c.sObjectType){
            return new IPM_ProjectDocumentHandler();
        }
         if (soType == IPM_Project_Document_Section_Content__c.sObjectType){
            return new IPM_ProjectDocumentSectionContentHandler();
        }        
       if (soType == IPM_Milestone__c.sObjectType){
            return new IPM_MilestoneHandler();
        }
        if (soType == IPM_Task__c.sObjectType){
            return new IPM_TaskHandler();
        }
        if (soType == IPM_Project__c.sObjectType){
            return new IPM_ProjectHandler();
        }
        if (soType == IPM_Financial__c.sObjectType){
            return new IPM_FinancialHandler();
        }
        if (soType == IPM_Financial_Year__c.sObjectType){
            return new IPM_FinancialYearHandler();
        }
        if (soType == IPM_Project_Rollout__c.sObjectType){
            return new IPM_ProjectRolloutHandler();
        }
        if (soType == IPM_Assessment__c.sObjectType){
            return new IPM_AssesmentHandler();
        }
		if (soType == Core_Approval_Details__c.sObjectType){
            return new Core_CA_LineItem_Handler();
        }
		 if (soType == CFC_Attendee__c.sObjectType){
            return new CFC_Attendee_Handler();
        } 
         if (soType == VEP_Visitor__c.sObjectType)
        {
            return new VEP_Visitor_TriggerHandler();
        }
        if (soType == AF_Agency_Estimate__c.sObjectType)
        {
            return new AF_Agency_EstimateHandler();
        }
        if (soType == AF_Bonus_Results__c.sObjectType)
        {
            return new AF_Bonus_ResultsHandler();
        }
        if (soType == AF_Bonus_Threshold__c.sObjectType)
        {
            return new AF_Bonus_ThresholdHandler();
        }
        if (soType == AF_Brand_Estimate__c.sObjectType)
        {
            return new AF_Brand_EstimateHandler();
        }
        if (soType == AF_Currency__c.sObjectType)
        {
            return new AF_CurrencyHandler();
        }
        if (soType == AF_OOPS_Actual__c.sObjectType)
        {
            return new AF_OOPSActualHandler();
        }
        if (soType == AF_OOPS_Estimate__c.sObjectType)
        {
           return new AF_OOPSEstimateHandler();
        }
        if (soType == AF_Sub_Result__c.sObjectType)
        {
            return new AF_SubResultHandler();
        }
        if (soType == AF_Bonus_Matrix__c.sObjectType)
        {
            return new AF_Bonus_MatrixHandler();
        }
        if (soType == AF_PO_Report__c.sObjectType)
        {
            return new AF_PO_ReportHandler();
        }
        return null;
    }

}