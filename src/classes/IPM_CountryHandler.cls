/**
   @Author Cognizant
   @Name IPM_CountryHandler
   @CreateDate 28/08/2015
   @Description This class is used as Trigger Handler for the IPM_Country SObject.
   @Version 1.0
   @reference TriggerFactory class
  */
public with sharing class IPM_CountryHandler implements ITrigger{   
    
    @TestVisible  private static final String INSERT_EVENT = 'Insert';
    @TestVisible  private static final String DELETE_EVENT = 'Delete';
    @TestVisible  private static final String UPDATE_EVENT = 'Update';  

    /***********************************************************************************************************************************
    * Constructor
    *
    * This constructor will insert the record in the Exception log if error occoured.
    * 
    */
    
    public IPM_CountryHandler() 
    {       
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    
    /***********************************************************************************************************************************
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    * In this we are updating owner id, IPM_Category_Text__c.
    */
    public void bulkBefore()
    {
        Set<Id> localRolloutIdSet = new Set<Id>();
        Map<Id,IPM_Project_Rollout__c> localRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        
        if(trigger.isDelete)
        {    
            //For Updating the MarketType field of project from Countries
            IPM_ProjectCountryDetails.updateProjectMarketType((List<IPM_Country__c>) trigger.old, true);
            
             //Delete the assessments for the deleted countries
            IPM_AssesmentHandler_Helper.deleteAssociatedAssesments((List<IPM_Country__c>) trigger.old);
        }
        
        //@@ Design Review - Data Sharing - Updating the Ownerid to Project Ownerid (Queue)
        if(trigger.isInsert)
        {
            map<id,id>ownerProjectIdMap=new map<id,id>();
            map<id,string>projectCategoryMap=new map<id,string>();
            for(IPM_Country__c c:(List<IPM_Country__c>)Trigger.New)
            { 
                
                if(c.IPM_Project__c != null)
                {
                    ownerProjectIdMap.put(c.IPM_Project__c,c.IPM_Project__r.ownerid);
                    projectCategoryMap.put(c.IPM_Project__c,c.IPM_Project__r.IPM_Category_Text__c);
                }
                else if(c.IPM_Regional_Project__c != null)
                {
                    ownerProjectIdMap.put(c.IPM_Regional_Project__c,c.IPM_Regional_Project__r.ownerid);
                    projectCategoryMap.put(c.IPM_Regional_Project__c,c.IPM_Regional_Project__r.IPM_Category_Text__c);
                }
                else if(c.IPM_Local_Project__c != null)
                {
                    ownerProjectIdMap.put(c.IPM_Local_Project__c,c.IPM_Local_Project__r.ownerid);
                    projectCategoryMap.put(c.IPM_Local_Project__c,c.IPM_Local_Project__r.IPM_Category_Text__c);
                }
            }
            if(!ownerProjectIdMap.isEmpty())
            {
                     for(IPM_Project__c proj: [SELECT id, ownerid, IPM_Category_Text__c FROM IPM_Project__c WHERE id IN:ownerProjectIdMap.Keyset()])
                     {
                        for(IPM_Country__c c:(List<IPM_Country__c>)Trigger.New)
                        {
                            if((c.IPM_Project__c!=null && c.IPM_Project__c==proj.id) || 
                                (c.IPM_Regional_Project__c!=null && c.IPM_Regional_Project__c==proj.id) || 
                                (c.IPM_Local_Project__c!=null && c.IPM_Local_Project__c==proj.id))
                                {
                                c.ownerid = proj.ownerid;
                                c.IPM_Small_C_shr__c = proj.IPM_Category_Text__c; 
                            }
                            
                        }
                     }    
            }           
            
            //check if the inserted country is an EI country by refering the master sata stored in custom setting IPM_USLP_Countries
            IPM_ProjectCountryDetails.checkIsEICountry((List<IPM_Country__c>) trigger.New);
            
            //populate the association time stamp on insert of regional original project
            IPM_ProjectCountryDetails.setProjAssociationTimestamp((List<IPM_Country__c>) trigger.New,null,INSERT_EVENT);
        }
        
        if(trigger.isUpdate)
        {
            //check if the inserted country is an EI country by refering the master sata stored in custom setting IPM_USLP_Countries
            IPM_ProjectCountryDetails.checkIsEICountry((List<IPM_Country__c>) trigger.New);
            
            //populate the association time stamp on updation of regional or Local project on country
            IPM_ProjectCountryDetails.setProjAssociationTimestamp((List<IPM_Country__c>) trigger.New,(Map<Id,IPM_Country__c>) trigger.oldMap,UPDATE_EVENT);
        }
        
    }

    /***********************************************************************************************************************************
    * bulkAfter
    *
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps after execution of the trigger.
    * In this method we update the MarketType field of project from Countries.
    * update sync flag on regional/Local projects populated on the country records
    * delete assessments of all the countries made inactive. 
    */
    public void bulkAfter()
    {
        List<IPM_Country__c> countryForProjList=new List<IPM_Country__c>();  //List of Countries Added in Rollouts
        Set<Id> countryListIds=new Set<Id>(); //Country Id's
        Set<Id> projectIdSet =new Set<Id>(); //Country Id's
        Set<Id> rolloutIdSet =new Set<Id>(); //Country Id's
        Map<Id,IPM_Project_Rollout__c> deleteRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        List<IPM_Country__c> countriesMadeInactive = new List<IPM_Country__c>();
        Map<Id, IPM_Country__c> oldCountriesMap = new Map<Id, IPM_Country__c>(); 
        
        if(trigger.isInsert)
        {
            for(IPM_Country__c c:(List<IPM_Country__c>)Trigger.New)
            {
                countryListIds.add(c.Id);
                if(c.IPM_Project__c != null)
                {
                    projectIdSet.add(c.IPM_Project__c);
                }
                if(c.IPM_Regional_Project__c != null)
                {
                    projectIdSet.add(c.IPM_Regional_Project__c);
                }
                if(c.IPM_Local_Project__c != null)
                {
                    projectIdSet.add(c.IPM_Local_Project__c);
                }
               
            }
            
            countryForProjList=[SELECT Id,Name, MDO_Geography__c, Country_Code__c,Country_Name__c,Geography__c,Local_Rollout__c,Market_Cluster_Code__c,
                                Market_Cluster_Name__c,MCO_Code__c,MCO_Name__c,Project_Country__c,IPM_Project__c, IPM_Project__r.IPM_Market_Type__c, IPM_Regional_Project__c,
                                IPM_Regional_Project__r.IPM_Market_Type__c, IPM_Local_Project__c, IPM_Local_Project__r.IPM_Market_Type__c, Geography__r.Market_Type__c 
                                FROM IPM_Country__c 
                                WHERE Id in:countryListIds LIMIT 50000];
            
            if(countryForProjList!=null && !countryForProjList.isEmpty())
            {
                //For Updating the MarketType field of project from Countries 
                IPM_ProjectCountryDetails.updateProjectMarketType(countryForProjList, false);

            }
            
            //Update the sync flag on global projects populated on the country records.
            //When countries get created only the global project field gets populated on them.
            IPM_ProjectCountryDetails.setSyncProjAftInsert((List<IPM_Country__c>)Trigger.New);
                
            //notify project Lead R&D resource as to what countries have been inserted for the project
            IPM_ProjectCountryDetails.notifyLeadRnD((List<IPM_Country__c>) Trigger.New,INSERT_EVENT);
            

            //check if there is atleast one assessment per EI country of the project and check the flag existsAtLeastOneAssmntPerEICountry if yes
            if(projectIdSet != null && !projectIdSet.isEmpty())
            {
                IPM_ProjectCountryDetails.checkAtLeastOneAssmntPerEICountry(projectIdSet);
            }

           
       }
        
        if(trigger.isUpdate)
        {
            countryListIds=new Set<Id>();
            oldCountriesMap = ((Map<Id,IPM_Country__c>)Trigger.OldMap);
            projectIdSet.clear();
            for(IPM_Country__c coun:(List<IPM_Country__c>)Trigger.New)
            {
                if(!String.isBlank(coun.IPM_Regional_Project__c))
                {
                    countryListIds.add(coun.Id);
                }
                if(coun.IPM_Project__c != null)
                {
                    projectIdSet.add(coun.IPM_Project__c);
                }
                if(coun.IPM_Regional_Project__c != null)
                {
                    projectIdSet.add(coun.IPM_Regional_Project__c);
                }
                if(coun.IPM_Local_Project__c != null)
                {
                    projectIdSet.add(coun.IPM_Local_Project__c);
                }
                
                //find list of all countries that have been made inactive
                if(coun.isActive__c != oldCountriesMap.get(coun.Id).isActive__c && coun.isActive__c == false )
                {
                	countriesMadeInactive.add(coun);
                }
            }
            
            for(IPM_Country__c oldCountry:(List<IPM_Country__c>)Trigger.Old)
            {
                if(oldCountry.Local_Rollout__c !=null)
                {
                    rolloutIdSet.add(oldCountry.Local_Rollout__c);
                }
            }
            
            countryForProjList=[SELECT Id,Name,MDO_Geography__c,Country_Code__c,Country_Name__c,Local_Rollout__c,Market_Cluster_Code__c,
                Market_Cluster_Name__c,MCO_Code__c,MCO_Name__c,Project_Country__c,IPM_Project__c, IPM_Project__r.IPM_Market_Type__c, IPM_Regional_Project__c,
                IPM_Regional_Project__r.IPM_Market_Type__c, IPM_Local_Project__c, IPM_Local_Project__r.IPM_Market_Type__c 
                FROM IPM_Country__c 
                WHERE Id in:countryListIds LIMIT 50000];
                
            //For Updating the MarketType field of project from Countries         
            if(countryForProjList!=null && !countryForProjList.isEmpty())
            {
                IPM_ProjectCountryDetails.updateProjectMarketType(countryForProjList, false);
            } 
            
            //Update the sync flag on regional/Local projects populated on the country records.
            //When countries get Updated, Normally Regional & Local field should get populated on them.
            IPM_ProjectCountryDetails.setSyncProjAftUpdate((Map<Id,IPM_Country__c>)Trigger.oldMap,(List<IPM_Country__c>)Trigger.New); 
            //check if there is atleast one assessment per EI country of the project and check the flag existsAtLeastOneAssmntPerEICountry if yes
            if(projectIdSet != null && !projectIdSet.isEmpty())
            {
                IPM_ProjectCountryDetails.checkAtLeastOneAssmntPerEICountry(projectIdSet);
            }
            
            //delete assessments of all the countries made inactive. Bcoz being made inactive is as good as the country being deleted
            if(countriesMadeInactive != null && !countriesMadeInactive.isEmpty())
            {
            	IPM_AssesmentHandler_Helper.deleteAssociatedAssesments(countriesMadeInactive);
            }
        }
        
        if(trigger.isDelete)
        {
            //find the project Ids of all the deleted countries
            for(IPM_Country__c cntry:(List<IPM_Country__c>)Trigger.old)
            {
                if(cntry.IPM_Project__c != null)
                {
                    projectIdSet.add(cntry.IPM_Project__c);
                }
                if(cntry.IPM_Regional_Project__c != null)
                {
                    projectIdSet.add(cntry.IPM_Regional_Project__c);
                }
                
                if(cntry.IPM_Local_Project__c != null)
                {
                    projectIdSet.add(cntry.IPM_Local_Project__c);
                }
            }
            
            //Set sync project Flag on the projects from which country has been deleted
            IPM_ProjectCountryDetails.setSyncProjectAftDelete((List<IPM_Country__c>) trigger.old);
            
            //notify project Lead R&D (if it exists) as to what countries have been deleted for the project
            //nonetheless all users are able to see the chatter feed
            IPM_ProjectCountryDetails.notifyLeadRnD((List<IPM_Country__c>) trigger.old,DELETE_EVENT);
            
            //check if there is atleast one assessment per EI country of the project and check the flag existsAtLeastOneAssmntPerEICountry if yes
            if(projectIdSet != null && !projectIdSet.isEmpty())
            {
                IPM_ProjectCountryDetails.checkAtLeastOneAssmntPerEICountry(projectIdSet);
            } 
        }
        
        // Validate if there are any rollouts which dont have any countries under them, if yes delete those Rollouts.
        if(!rolloutIdSet.isEmpty())
        {
            List<IPM_Project_Rollout__c> associatedRollouts = [Select Id,(Select Id from IPM_Countries_Local__r) from IPM_Project_Rollout__c where Id in :rolloutIdSet];
            if(!associatedRollouts.isEmpty())
            {
                for(IPM_Project_Rollout__c associatedRollout :  associatedRollouts)
                {
                    if(associatedRollout.IPM_Countries_Local__r ==null || associatedRollout.IPM_Countries_Local__r.isEmpty())
                    {
                        deleteRolloutMap.put(associatedRollout.Id,associatedRollout);
                    }
                }
            }
        }
        
        if(!deleteRolloutMap.isEmpty())
        {
            Map<Id,IPM_Project_Rollout__c> finalDeleteRollout = new Map<Id,IPM_Project_Rollout__c>();
            Map<Id,IPM_Project_Rollout__c> finalUpdateRollout = new Map<Id,IPM_Project_Rollout__c>();
             
            List<IPM_Project_Rollout__c> deleteRolloutList = [Select Id from IPM_Project_Rollout__c where Id in :deleteRolloutMap.keySet() AND isActive__c = true];
            for(IPM_Project_Rollout__c deleteRollout : deleteRolloutList)
            {
                if(deleteRollout.IPM_CharterApproved__c)
                { 
                    deleteRollout.isActive__c = false; 
                    finalUpdateRollout.put(deleteRollout.Id,deleteRollout);
                }
                else
                {
                    finalDeleteRollout.put(deleteRollout.Id,deleteRollout);
                }    
            }
            
            if(!finalUpdateRollout.isEmpty())
            {
                update finalUpdateRollout.values();
            }
            
            if(!finalDeleteRollout.isEmpty())
            {
                delete finalDeleteRollout.values();
            }
        }
    }
    
     /***********************************************************************************************************************************
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    
    public void beforeInsert(SObject so)
    {
    	//This method has been included as the class implements the ITrigger interface
    }
    
    /***********************************************************************************************************************************
    * bulkUpdate
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {  
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * beforeDelete
    *
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so)
    { 
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * after insert
    *
    * This method is called iteratively for each record after deletion 
    * trigger.
    */
    
    public void afterInsert(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
    }
    
     
    /**
    * after update
    *
    * This method is called iteratively for each record after deletion 
    * trigger.
    */
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
    }
    
     
    /**
    * after delete
    *
    * This method is called iteratively for each record after deletion 
    * trigger.
    */
    
    public void afterDelete(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
    }

    /**
    * andFinally
    *
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally()
    {
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
    }
}