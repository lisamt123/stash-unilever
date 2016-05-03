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
        if(trigger.isUpdate)
        {
            // To chatter when document status is changed
            IPM_ChatterFeedHelper.postChatterIfDocumentStatusChanged((List<IPM_Project_Document__c>)Trigger.new,(List<IPM_Project_Document__c>)Trigger.old);
        }
        
        String[] fieldNames = new String[] {IPM_Utils.IPM_Approval_Date};
        List<IPM_Milestone__c>  updatedMilestone = new List<IPM_Milestone__c>();
        IPM_Project_Document__c oldIpmProjectDocument = new IPM_Project_Document__c();  
        List<Id> lstProjectId=new List<Id>();    
        for (IPM_Project_Document__c recentIpmProjectDocument : (List<IPM_Project_Document__c>)Trigger.new) 
        {
            if(recentIpmProjectDocument!= null)
            {
                if(recentIpmProjectDocument.Id!= null)
                {
                    if(Trigger.old!=null)
                    {
                        if(Trigger.oldMap.get(recentIpmProjectDocument.Id)!= null)
                        {
                            oldIpmProjectDocument = (IPM_Project_Document__c)Trigger.oldMap.get(recentIpmProjectDocument.Id);
                        }
                    }
                }
            }
            for (String ipmApprovalDate : fieldNames) 
            {
                if (recentIpmProjectDocument.get(ipmApprovalDate) != oldIpmProjectDocument.get(ipmApprovalDate)) 
                {
                    if(recentIpmProjectDocument.get(IPM_Utils.IPM_Project)!= null)
                    {
                        lstProjectId.add(recentIpmProjectDocument.IPM_Project__c);
                    }
                }
            }
        }
            
        if(!lstProjectId.isEmpty())
        {
            List<IPM_Milestone__c> milestones = [SELECT Id,IPM_Project__c,IPM_Completed_On__c 
                                                    FROM IPM_Milestone__c WHERE IPM_Project__c IN : lstProjectId 
                                                    AND IPM_Type_of_gate__c =: IPM_ConstantUtils.FIELD_SUFFIX_CHARTER LIMIT 50000];
            for(IPM_Project_Document__c rIpmPDocument : (List<IPM_Project_Document__c>)Trigger.new)
            {
                if(rIpmPDocument.IPM_Project__c != null)
                {
                    for(IPM_Milestone__c milestone:milestones)
                    {
                        if(milestone.IPM_Project__c == rIpmPDocument.IPM_Project__c)
                        {
                            milestone.IPM_Completed_On__c = rIpmPDocument.IPM_Approval_Date__c;
                            milestone.IPM_Completed__c = true;
                            updatedMilestone.add(milestone);
                        }
                    }
                }
            }
        }     
        
        if(!updatedMilestone.isEmpty())
        {
            update updatedMilestone; // Not including try , catch as when the transaction is failed roll back is handled at other class  
        }
        
        set<id> projset = new set<id>();
        set<id> projset_pro= new set<id>();
        map<id,date> docmap = new map<id,date>();
        map<id,date> docmap_pro = new map<id,date>();
        map<id,string> IpmGate_map = new map<id,string>();
        map<id,string> IpmGate_pro_map = new map<id,string>();
        
        for(IPM_Project_Document__c ipd : (List<IPM_Project_Document__c>)trigger.new)
        {
           if(ipd.IPM_GateDocuments__c != null && ipd.IPM_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED && ipd.IPM_Project__c != null)
           {
               projset.add(ipd.IPM_Project__c);
               IpmGate_map.put(ipd.IPM_Project__c,ipd.IPM_GateDocuments__c );
           }
           if(ipd.IPM_Project__c != null && ipd.IPM_Approval_Date__c != null)
           {
               docmap.put(ipd.IPM_Project__c ,ipd.IPM_Approval_Date__c);
               
           }// Proposed
           if(ipd.IPM_GateDocuments__c != null && ipd.IPM_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED && ipd.IPM_Project__c != null)
           {
               projset_pro.add(ipd.IPM_Project__c);
               IpmGate_pro_map.put(ipd.IPM_Project__c,ipd.IPM_GateDocuments__c );
           }
           if(ipd.IPM_Project__c != null && ipd.IPM_Proposed_Date__c!= null)
           {
               docmap_pro.put(ipd.IPM_Project__c ,ipd.IPM_Proposed_Date__c);
           }
        }
        
        map<id,IPM_Milestone__c> miles_Map = new map<id,IPM_Milestone__c>([SELECT id,IPM_Type_of_Milestone__c,IPM_Type_of_gate__c,IPM_Completed_On__c,
                                                                      IPM_Project__c FROM IPM_Milestone__c WHERE IPM_Project__c in : projset 
                                                                      AND IPM_Type_of_Milestone__c =: IPM_ConstantUtils.STANDARD LIMIT 50000]);
                                                                      
        map<id,IPM_Milestone__c > UpdateMileMap = new map<id,IPM_Milestone__c >();
        
        for(IPM_Milestone__c M : miles_Map.values())
        {
            if(M.IPM_Project__c != null && IpmGate_map.containskey(M.IPM_Project__c) && M.IPM_Type_of_gate__c == IpmGate_map.get(M.IPM_Project__c)
            && docmap.containskey(M.IPM_Project__c ) && docmap.get(M.IPM_Project__c ) != null)
            {
                M.IPM_Completed_On__c = docmap.get(M.IPM_Project__c );
                UpdateMileMap.put(M.id,M);
            }
        }
    
        // Proposed
        map<id,IPM_Milestone__c> miles_Pro_Map = new map<id,IPM_Milestone__c>([SELECT id,IPM_Type_of_Milestone__c,IPM_Type_of_gate__c,IPM_Completed_On__c,
                                                                          IPM_Project__c FROM IPM_Milestone__c WHERE IPM_Project__c in : projset_pro 
                                                                          AND IPM_Type_of_Milestone__c =: IPM_ConstantUtils.STANDARD LIMIT 50000]);
    
        for(IPM_Milestone__c M : miles_Pro_Map.values())
        {
            if(M.IPM_Project__c != null && IpmGate_pro_map.containskey(M.IPM_Project__c) && M.IPM_Type_of_gate__c == IpmGate_pro_map.get(M.IPM_Project__c)
            && docmap_pro.containskey(M.IPM_Project__c ) && docmap_pro.get(M.IPM_Project__c ) != null)
            {
                M.IPM_Proposed_Date__c = docmap_pro.get(M.IPM_Project__c );
                UpdateMileMap.put(M.id,M);
            }
        }
        
        if(UpdateMileMap != null && !UpdateMileMap.isEmpty())
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