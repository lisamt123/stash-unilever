/**
  @author:Cognizant
  @name :IPM_MilestoneHandler
  @CreateDate :06/05/2015
  @description:Trigger Handler for the IPM_Milestone SObject. This class implements the ITrigger
  interface to help ensure the trigger code is bulkified and all in one place.
  @Version :1.0
  @reference :Project Initiation and Phase Change
*/
public with sharing class IPM_MilestoneHandler implements ITrigger{   
   
    //@description:Constructor
    public IPM_MilestoneHandler (){
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    
    Set<Id> lstProjectIds = new Set<Id>();// Set of Project Ids 
    Map<Id,IPM_Project__c> ipmProjects = new Map<Id,IPM_Project__c>();//Map of IPM Project Id and IPM Project
    Map<id,IPM_Project__c> eligibleProjectMapForCopyOver = new Map<id,IPM_Project__c>();//Map of IPM Project Id and IPM Project
    Map<Id,IPM_Milestone__c> eligibleMilestoneMapForCopyOver = new Map<Id,IPM_Milestone__c>();//Map of IPM Milestone Id and IPM Milestone
    
    /**
    * @description:bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore()
    {
        Map<Id,IPM_Bosscard__c> ipmBosscards = new Map<Id,IPM_Bosscard__c>();
        
        List<Id> lstbosscardIds=new List<Id>();
        
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            List<IPM_Milestone__c> incomingMilestoneList = (List<IPM_Milestone__c>)Trigger.new;
            
            for (IPM_Milestone__c recentUpsertedMilestone : incomingMilestoneList) 
            {
                if(recentUpsertedMilestone.IPM_Project__c != null)
                {
                    lstProjectIds.add(recentUpsertedMilestone.IPM_Project__c);
                }
            }
            if(!lstProjectIds.isEmpty())
            {
                String projectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,true);
                String projectWhereClause = ' WHERE id IN : lstProjectIds LIMIT 50000';
                projectQuery = projectQuery + projectWhereClause;
                ipmProjects = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(projectQuery));
            }
            
            if(ipmProjects!=null && !ipmProjects.isEmpty())
            {
                for(IPM_Project__c proj:ipmProjects.values()){
                    if(proj.IPM_Bosscard__c != null){
                        lstbosscardIds.add(proj.IPM_Bosscard__c);
                    }
                }
                
                if(!lstbosscardIds.isEmpty()){
                    ipmBosscards=new Map<Id,IPM_Bosscard__c>([SELECT Id,IPM_Bosscord_Approval_Date__c FROM IPM_Bosscard__c WHERE id IN : lstbosscardIds LIMIT 50000]);
                }
            }
            
            for (IPM_Milestone__c updMilestone : (List<IPM_Milestone__c>)Trigger.new) 
            {
                if(updMilestone.IPM_Project__c != null){
                    if(ipmProjects.containsKey(updMilestone.IPM_Project__c)){
                        updMilestone.IPM_Project_Started_Date__c = ipmProjects.get(updMilestone.IPM_Project__c).CreatedDate.date();
                        if(ipmProjects.get(updMilestone.IPM_Project__c).IPM_Bosscard__c != null){
                            if(ipmBosscards.containsKey(ipmProjects.get(updMilestone.IPM_Project__c).IPM_Bosscard__c )){
                                updMilestone.IPM_Bosscord_Approval_Date__c=ipmBosscards.get(ipmProjects.get(updMilestone.IPM_Project__c).IPM_Bosscard__c ).IPM_Bosscord_Approval_Date__c;
                            }
                        }
                    }
                }
            }
            
        } 
        //IPM BET related changes: Start
        //Call IPM BET Helper class method to update Release Status Missed flags on IPM Project
        if(Trigger.isUpdate){
            map<id,list<IPM_Milestone__c>> mapProjectBETMS = new map<id,list<IPM_Milestone__c>>();
            for(IPM_Milestone__c ms : (List<IPM_MileStone__c>)trigger.new){
                IPM_Milestone__c oldms=(IPM_Milestone__c)Trigger.oldMap.get(ms.Id);
                if(ms.BET_Status_Check_Trigger__c && !oldms.BET_Status_Check_Trigger__c ){
                    ms.BET_Status_Check_Trigger__c = false;
                    if(!mapProjectBETMS.containskey(ms.IPM_Project__c)){
                        mapProjectBETMS.put(ms.IPM_Project__c, new list<IPM_Milestone__c>{ms});
                    }
                    else{
                        mapProjectBETMS.get(ms.IPM_Project__c).add(ms);   
                    }    
                }
            }
            if(!mapProjectBETMS.isEmpty()){
                IPM_BETHelper.updateBETMilestoneMissOnProject(mapProjectBETMS);
            }
            //IPM BET related changes: End
        }
        
    }
    
    /**
    * @description:bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
       
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            List<IPM_Milestone__c> incomingMilestoneList = (List<IPM_Milestone__c>)Trigger.new;
            Map<Id,IPM_Milestone__c> oldMilestoneMap = null; 
            
            if(Trigger.isUpdate)
            {
                oldMilestoneMap = (Map<Id,IPM_Milestone__c>)Trigger.oldMap;
            }
            
            for (IPM_Milestone__c recentUpsertedMilestone : incomingMilestoneList) 
            {
                if(recentUpsertedMilestone.IPM_Project__c != null)
                {
                    lstProjectIds.add(recentUpsertedMilestone.IPM_Project__c);
                }
            }
            
            if(!lstProjectIds.isEmpty())
            {
                String projectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,true);
                String projectWhereClause = ' WHERE id IN : lstProjectIds LIMIT 50000';
                projectQuery = projectQuery + projectWhereClause;
                ipmProjects = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(projectQuery));
            }
            
            if(!incomingMilestoneList.isEmpty())
            {
                for (IPM_Milestone__c incomingMilestone :  incomingMilestoneList)
                {
                    IPM_Milestone__c oldMilestone =  null;
                    if(Trigger.isUpdate)
                    {   
                        oldMilestone = oldMilestoneMap.get(incomingMilestone.Id);
                    }
                    
                   if(incomingMilestone.IPM_Project__c != null && incomingMilestone.IPM_Planned_Date__c !=null &&  
                        (Trigger.isInsert || ( Trigger.isUpdate && incomingMilestone.IPM_Planned_Date__c != oldMilestone.IPM_Planned_Date__c ) ) && 
                        incomingMilestone.IPM_Type_of_Milestone__c == IPM_ConstantUtils.STANDARD && ipmProjects.containsKey(incomingMilestone.IPM_Project__c) )
                   { 
                        if(ipmProjects!=null && !ipmProjects.isEmpty())
                        {
                            eligibleProjectMapForCopyOver.put(incomingMilestone.IPM_Project__c,ipmProjects.get(incomingMilestone.IPM_Project__c));
                            eligibleMilestoneMapForCopyOver.put(incomingMilestone.Id,incomingMilestone); 
                        }
                   }
                }
            }
            /* Map with all the projects related to updated milestones */           
            if(!eligibleMilestoneMapForCopyOver.isEmpty())
            {    
                IPM_MilestoneHelper.CopyMilestones(eligibleProjectMapForCopyOver,eligibleMilestoneMapForCopyOver);
            }
            
        } 
    }
    /**
    * @description:beforeInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void beforeInsert(SObject so)
    {
        IPM_Milestone__c newMilestone = (IPM_Milestone__c)so;
        IPM_MilestoneHelper.prepareCustomMilestoneName(newMilestone,ipmProjects);
             
        if(newMilestone.IPM_Project__c !=null && ipmProjects.containsKey(newMilestone.IPM_Project__c) && newMilestone.IPM_type_of_Milestone__c != null && newMilestone.IPM_type_of_Milestone__c == IPM_ConstantUtils.STANDARD)
        {
          IPM_Project__c associatedProject = ipmProjects.get(newMilestone.IPM_Project__c);
          newMilestone.ExternalField__c = associatedProject.IPM_Project_Name__c + IPM_ConstantUtils.HYPHEN_DELIMITER + newMilestone.IPM_Name__c + IPM_ConstantUtils.HYPHEN_DELIMITER + newMilestone.IPM_Phase__c + '-'+ newMilestone.IPM_Project_Type__c;
          
          if(newMilestone.IPM_Planned_Date__c !=null)
          {
              newMilestone.IPM_Due_Date__c = newMilestone.IPM_Planned_Date__c;
          }
        } 
    }
    /**
    * @description:beforeUpdate
    * This method is called iteratively for each record to be update during a BEFORE
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void beforeUpdate(SObject oldSo, SObject so)
    {   
        IPM_Milestone__c newMilestone = (IPM_Milestone__c)so;
        IPM_MilestoneHelper.prepareCustomMilestoneName(newMilestone,ipmProjects);
        if(newMilestone.IPM_Project__c !=null && ipmProjects.containsKey(newMilestone.IPM_Project__c) && newMilestone.IPM_type_of_Milestone__c != null && newMilestone.IPM_type_of_Milestone__c == IPM_ConstantUtils.STANDARD)
        {
          IPM_Project__c associatedProject = ipmProjects.get(newMilestone.IPM_Project__c);
          newMilestone.ExternalField__c = associatedProject.IPM_Project_Name__c + IPM_ConstantUtils.HYPHEN_DELIMITER + newMilestone.IPM_Name__c + IPM_ConstantUtils.HYPHEN_DELIMITER + newMilestone.IPM_Phase__c + '-'+ newMilestone.IPM_Project_Type__c;   
          
          newMilestone.IPM_Due_Date__c = newMilestone.IPM_Planned_Date__c;          
        } 
        
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
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterUpdate
    * This method is called iteratively for each record to be update during a AFTER
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void afterUpdate(SObject oldSo, SObject so){    
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterDelete
    * This method is called iteratively for each record to be delete during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
    }
}