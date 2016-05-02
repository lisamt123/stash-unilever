/**
* @author:Cognizant
* @date:06/05/2015
* @description:Trigger Handler for the IPM_Project_Resource__c SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public with sharing class IPM_ProjectResourceHandler implements ITrigger{   
     
    //Select list which should contain only the owners in the team
    private list<IPM_Project_Resource__c> newPRListWithOwners = new list<IPM_Project_Resource__c>();
    IPM_ProjectResourceTriggerHandler handler = new IPM_ProjectResourceTriggerHandler();
    
    //@description:Constructor
    public IPM_ProjectResourceHandler (){
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    /**
    * @description:bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
        //This method has been included as the class implements the ITrigger interface    
         if(Trigger.isUpdate){
            map<id,IPM_Project_Resource__c>newResourceMap=(map<id,IPM_Project_Resource__c>)trigger.newmap;
            map<id,IPM_Project_Resource__c>oldResourceMap=(map<id,IPM_Project_Resource__c>)trigger.oldmap;            
            handler.onBeforeUpdate(newResourceMap, oldResourceMap);
        }
      else if(Trigger.isDelete){
            handler.onBeforeDelete((List<IPM_Project_Resource__c>)Trigger.old);
        	Map<Id,IPM_Project__c> updatedProjMap = new Map<Id,IPM_Project__c>();
    	
    		for(IPM_Project_Resource__c eachResource:(List<IPM_Project_Resource__c>)Trigger.old)
            {
            	if(eachResource.IPM_Role_Type__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE  && eachResource.IPM_Project_Role_Owner__c)
            	{
            		IPM_Project__c project = new IPM_Project__c(Id=eachResource.IPM_Project__c,IPM_Finance_Lead__c=null);
            		updatedProjMap.put(project.id,project);
            	}
            }
           update updatedProjMap.values();
        }
    }




    /**
    * @description:bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
    	
    	if(Trigger.isInsert  || Trigger.isUpdate){
    	Map<Id,IPM_Project__c> updatedProjMap = new Map<Id,IPM_Project__c>();
    	for(IPM_Project_Resource__c eachResource:(List<IPM_Project_Resource__c>)Trigger.new)
           {
            	if(eachResource.IPM_Role_Type__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE  && eachResource.IPM_Project_Role_Owner__c)
            	{
            		IPM_Project__c project = new IPM_Project__c(Id=eachResource.IPM_Project__c);
            		project.IPM_Finance_Lead__c = eachResource.IPM_User__c;
            		updatedProjMap.put(project.id,project);
            	}
           }
           
           update updatedProjMap.values();
    	}     
        
        //IPM EcoDesign Related Changes
        IPM_ProjectResourceTriggerHandler handler = new IPM_ProjectResourceTriggerHandler();
        if(Trigger.isDelete ){
        	map<id,IPM_Project_Resource__c>oldResourceMap=(map<id,IPM_Project_Resource__c>)trigger.oldmap;
        	handler.setSyncProjectAftInsertDelete(oldResourceMap.values());
        }
        else if(Trigger.isInsert){
        	map<id,IPM_Project_Resource__c>newResourceMap=(map<id,IPM_Project_Resource__c>)trigger.newmap;
        	handler.setSyncProjectAftInsertDelete(newResourceMap.values());
        }
        else if(Trigger.isUpdate){
        	map<id,IPM_Project_Resource__c>newResourceMap=(map<id,IPM_Project_Resource__c>)trigger.newmap;
            map<id,IPM_Project_Resource__c>oldResourceMap=(map<id,IPM_Project_Resource__c>)trigger.oldmap;            
            
            handler.setSyncProjectAftUpdate(oldResourceMap,newResourceMap);
        }
        
        //IPM BET related changes.
        map<id, set<IPM_Project_Resource__c>> mapProjResources = new map<id, set<IPM_Project_Resource__c>>();
        if(trigger.isInsert || trigger.isUpdate){
            for(IPM_Project_Resource__c pr :(list<IPM_Project_Resource__c>) Trigger.new){
                if(mapProjResources.isEmpty() || !mapProjResources.containsKey(pr.IPM_Project__c)){
                    set<IPM_Project_Resource__c> temp = new set<IPM_Project_Resource__c>();
                    temp.add(pr);
                    mapProjResources.put(pr.IPM_Project__c, temp);
                }
                else if(!mapProjResources.isEmpty() && mapProjResources.containsKey(pr.id)){
                    mapProjResources.get(pr.IPM_Project__c).add(pr);    
                } 
            }
            if(!mapProjResources.isEmpty()){
                IPM_BETHelper.sendRolloutMemberBETAccessRequest(mapProjResources);  
            }
        }
        if(Trigger.isInsert){
            handler.onAfterInsert((List<IPM_Project_Resource__c>)Trigger.new);
       }
       
       //@@ Data Sharing
       if(Trigger.isDelete ){            
            handler.OnAfterDelete((List<IPM_Project_Resource__c>)Trigger.old);
       }
       //@@Data Sharing
    }
    /**
    * @description:beforeInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record 
    */
    public void beforeInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:beforeUpdate
    * This method is called iteratively for each record to be update during a BEFORE
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void beforeUpdate(SObject oldSo, SObject so){   
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){      
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterInsert(SObject so){
        
        IPM_Project_Resource__c eachPResource = (IPM_Project_Resource__c)so;
        if(eachPResource.IPM_Project_Role_Owner__c) {
            newPRListWithOwners.add(eachPResource);
        }
    }
    /**
    * @description:afterUpdate
    * This method is called iteratively for each record to be update during a AFTER
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void afterUpdate(SObject oldSo, SObject so) {
        
        IPM_Project_Resource__c oldPR = (IPM_Project_Resource__c)oldSo;
        IPM_Project_Resource__c eachPResource = (IPM_Project_Resource__c)so;

        if(eachPResource.IPM_Project_Role_Owner__c && 
            (eachPResource.IPM_User__c != oldPR.IPM_User__c || eachPResource.IPM_Project_Role_Owner__c != oldPR.IPM_Project_Role_Owner__c)) {
            //check if owner is changed then add it
            newPRListWithOwners.add(eachPResource);
        }
    }
    /**
    * @description:afterDelete
    * This method is called iteratively for each record to be delete during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterDelete(SObject oldSo){
      //This method has been included as the class implements the ITrigger interface
        IPM_Project_Resource__c projRes = (IPM_Project_Resource__c)oldSo;
        IPM_TaskHelper.assignUserToTask(new Set<Id>{projRes.IPM_Project__c});
    }
    
    /**
    * @description:andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
        
        if(newPRListWithOwners != null && !newPRListWithOwners.isEmpty()) { // run only once and when newPRListWithOwners is more than 0
            IPM_TaskHelper.reAssignFunctionalWiseTasks(newPRListWithOwners);//reassign the tasks basing on the functional areas.
        }
        if(Trigger.isInsert && Trigger.isAfter) {
            IPM_WithoutSharingHelper.autoFollowTeamMembers(Trigger.new); //also make the team member follow the project if they hasnt' before.
        }
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
       
        ExceptionLoggingHelper.insertLogRecordList();
    }

}