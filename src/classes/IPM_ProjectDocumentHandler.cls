/***************************************************************************************************
    * Class IPM_ProjectDocumentHandler
    * Trigger Handler for the IPM_Project_Document__c SObject. This class implements the ITrigger
    * interface to help ensure the trigger code is bulkified and all in one place.
****************************************************************************************************/
public with sharing class IPM_ProjectDocumentHandler implements ITrigger{   
    
    // Constructor
    public IPM_ProjectDocumentHandler() {
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    
    /**
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
        //This method has been included as the class implements the ITrigger interface      
    }
    
    public void bulkAfter()
    {    
        Set<id> projset_pro = new Set<id>();
        Map<id,date> docmap_pro = new Map<id,date>();
        Map<id,string> IpmGate_pro_map = new Map<id,string>();
        Map<id,IPM_Milestone__c > updateMileMap = new Map<id,IPM_Milestone__c >();
        if(trigger.isUpdate)
        {
            // To chatter when document status is changed
            IPM_ChatterFeedHelper.postChatterIfDocumentStatusChanged((List<IPM_Project_Document__c>)Trigger.new,(List<IPM_Project_Document__c>)Trigger.old);
        }
        
       	for(IPM_Project_Document__c projectDoc : (List<IPM_Project_Document__c>)trigger.new)
        {
    		if(projectDoc.IPM_GateDocuments__c != null && projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED)
            {
	       		IPM_Project_Document__c oldProjectDoc = null;
            
	       		if(Trigger.isUpdate)
        {
   					oldProjectDoc = (IPM_Project_Document__c)Trigger.OldMap.get(projectDoc.Id);
                        }
        
        
        
	       		if(Trigger.isInsert || (Trigger.isUpdate && projectDoc.IPM_Document_Status__c != oldProjectDoc.IPM_Document_Status__c) )
        {
	       			projset_pro.add(projectDoc.IPM_Project__c);
	           		IpmGate_pro_map.put(projectDoc.IPM_Project__c,projectDoc.IPM_GateDocuments__c);	
	       			
	       			if(projectDoc.IPM_Proposed_Date__c != null)
           {
               
		           		docmap_pro.put(projectDoc.IPM_Project__c ,projectDoc.IPM_Proposed_Date__c);
           }
		           	else
           {
		           		docmap_pro.put(projectDoc.IPM_Project__c ,system.today());	
           }
        }
        
                                                                      
        
            }
        }
    
        // Proposed
        map<id,IPM_Milestone__c> miles_Pro_Map = new map<id,IPM_Milestone__c>([SELECT id,IPM_Type_of_Milestone__c,IPM_Type_of_gate__c,IPM_Completed_On__c,
                                                                          IPM_Project__c FROM IPM_Milestone__c WHERE IPM_Project__c in : projset_pro 
                                                                          AND IPM_Type_of_Milestone__c =: IPM_ConstantUtils.STANDARD LIMIT 50000]);
    
        for(IPM_Milestone__c milestoneObj : miles_Pro_Map.values())
        {
            if(IpmGate_pro_map.containskey(milestoneObj.IPM_Project__c) && milestoneObj.IPM_Type_of_gate__c == IpmGate_pro_map.get(milestoneObj.IPM_Project__c) )
            {
                milestoneObj.IPM_Proposed_Date__c = docmap_pro.get(milestoneObj.IPM_Project__c);
                updateMileMap.put(milestoneObj.id,milestoneObj);
            }
        }
        
        if(!updateMileMap.isEmpty())
        {
            update UpdateMileMap.values(); // Not including try , catch as when the transaction is failed roll back is handled at other class
        }  
    }
    
    public void beforeInsert(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
        IPM_Project_Document__c newProjectDocument =  (IPM_Project_Document__c)so;
        if( !String.isBlank(newProjectDocument.IPM_GateDocuments__c) )
        {
            newProjectDocument.IPM_Project_Document_External_Id__c = newProjectDocument.IPM_Project__c + newProjectDocument.IPM_GateDocuments__c;
            if(!Test.isRunningTest() && !String.isBlank(newProjectDocument.IPM_Project_External_Id__c)){
                string projectExtID=newProjectDocument.IPM_Project_External_Id__c.substring(0,newProjectDocument.IPM_Project_External_Id__c.length()-1);
                newProjectDocument.External_Id__c= projectExtID+newProjectDocument.IPM_Document_Order__c;
            }
        }
        else
        {
            newProjectDocument.addError(system.label.IPM_DocumentNotAssociated);       
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){   
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * beforeDelete
    *
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){    
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterUpdate(SObject oldSo, SObject so){    
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * andFinally
    *
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
    }
}