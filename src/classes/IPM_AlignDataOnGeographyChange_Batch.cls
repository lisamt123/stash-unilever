/*****************************************************************************************************************************
* This is the class to align the data with the country geography changes
* This class is without sharing as a batch job to be run by an admin for data alignment,access level should not be the issue
******************************************************************************************************************************/
public without sharing   class IPM_AlignDataOnGeographyChange_Batch implements Database.Stateful,Database.Batchable<sObject>
{

    List<String> applicableGKMs = New List<String>{'GKM1','GKM2','GKM3','GKM4'}; 
    
    Set<String> impactedCountryIds = new Set<String>();  
    
     
    //Map to hold MCO short names 
    Map<String,IPM_MCO_Short_Names__c> mapMCOCodeToShortName =  IPM_MCO_Short_Names__c.getAll();  
 
    public Database.QueryLocator start(Database.BatchableContext batchContext)       
    {
        // returns country and associated data for project records  
        return Database.getQueryLocator([ Select Id from  IPM_Project__c  where IPM_ProjectGKM__c IN :applicableGKMs  limit  50000]) ;    
    }

    public void execute(Database.BatchableContext batchContext ,List<IPM_Project__c> geoImpactedProjects)    
    {
        
        Map<Id,IPM_Country__c> countryMap = new  Map<Id,IPM_Country__c>(); 
        

		Map<Id,IPM_Project__c> projectMap = new   Map<Id,IPM_Project__c>(geoImpactedProjects);
        
        //list to hold the country records associated with a project , they will be further operated on to identify the geography  change
        List<IPM_Country__c> countryList = [Select Id,isActive__c,MCO_Name__c, Local_Rollout__r.IPM_CharterApproved__c,Local_Rollout__r.IPM_Project__c,Local_Rollout__r.Regional_Rollout__c, Local_Rollout__r.Regional_Project__c, Local_Rollout__c, IPM_Project__c, MDO_Geography__r.mdm_Id__c, MCO_Code__c,Market_Cluster_Code__c, IPM_Project__r.IPM_Project_Name__c, IPM_Regional_Project__r.IPM_ProjectGKM__c, IPM_Regional_Project__c, Local_Rollout__r.MCO__c,  Local_Rollout__r.MCO_Name__c,
        IPM_Rollout_Status__c ,  Local_Rollout__r.KeyMCO__c,IPM_Regional_Project__r.IPM_Target_Launch_Dates__c,IPM_Project__r.IPM_Target_Launch_Dates__c,
        Local_Rollout__r.Regional_Rollout__r.IPM_Rollout_Project__c , Local_Rollout__r.name, Local_Rollout__r.IPM_Rollout_Project__c, Country_Code__c,Local_Rollout__r.Project_Sustainability_Period__c,Local_Rollout__r.Target_Launch_Date__c,IPM_Regional_Project__r.IPM_Project_Name__c   From IPM_Country__c  Where    Local_Rollout__c !=Null  AND 
       (IPM_Project__c IN : projectMap.keySet() OR  IPM_Regional_Project__c IN :   projectMap.keySet() ) ]; 
       
        Map<Id,IPM_Country__c> countryListDeepCloneMap = new  Map<Id,IPM_Country__c>([Select Id,isActive__c,MCO_Name__c, Local_Rollout__r.IPM_CharterApproved__c,Local_Rollout__r.IPM_Project__c,Local_Rollout__r.Regional_Rollout__c, Local_Rollout__r.Regional_Project__c, Local_Rollout__c, IPM_Project__c, MDO_Geography__r.mdm_Id__c, MCO_Code__c,Market_Cluster_Code__c, IPM_Project__r.IPM_Project_Name__c, IPM_Regional_Project__r.IPM_ProjectGKM__c, IPM_Regional_Project__c, Local_Rollout__r.IPM_Rollout_Span__c,
        Local_Rollout__r.Global_Regional_Finance_Leader_Email__c, Local_Rollout__r.IPM_Company_Card__c, Local_Rollout__r.IPM_Regional_PL_Text__c, Local_Rollout__r.IPM_Regional_Rollout_Status__c, Local_Rollout__r.IPM_Rollout_Gatekeeper__c, Local_Rollout__r.isActive__c,  Local_Rollout__r.IPM_Local_Rollout_Status__c, Local_Rollout__r.Market_Cluster_Name__c, Local_Rollout__r.Market_Cluster__c, Local_Rollout__r.MCO_Name__c, Local_Rollout__r.Regional_Project_Span__c, Local_Rollout__r.Regional_Project_Sustainability_Period__c, Local_Rollout__r.Regional_Rollout_External_Id__c, Local_Rollout__r.Regional_Rollout_Phase__c, Local_Rollout__r.IPM_Regional_PL__c, Local_Rollout__r.MCO__c, Local_Rollout__r.IPM_Rollout_Type__c , Local_Rollout__r.IPM_Brand__c,Local_Rollout__r.Type__c,Local_Rollout__r.IPM_StoppedByProject__c,Local_Rollout__r.IPM_Status__c,Local_Rollout__r.IPM_Small_C__c,Local_Rollout__r.IPM_ShowAtRegional__c,Local_Rollout__r.IPM_ShowAtGlobal__c,Local_Rollout__r.IPM_ShowAtLocal__c,
        IPM_Rollout_Status__c ,  Local_Rollout__r.KeyMCO__c,IPM_Regional_Project__r.IPM_Target_Launch_Dates__c,IPM_Project__r.IPM_Target_Launch_Dates__c,
        Local_Rollout__r.Regional_Rollout__r.IPM_Rollout_Project__c , Local_Rollout__r.name, Local_Rollout__r.IPM_Rollout_Project__c, Country_Code__c,Local_Rollout__r.Project_Sustainability_Period__c,Local_Rollout__r.Target_Launch_Date__c,IPM_Regional_Project__r.IPM_Project_Name__c   From IPM_Country__c  Where    Local_Rollout__c !=Null  AND  
       (IPM_Project__c IN : projectMap.keySet() OR  IPM_Regional_Project__c IN :   projectMap.keySet() ) ]);
        
        //Map of rollouts whose name need updation
        Map<String,IPM_Project_Rollout__c>  mcoCodeToRolloutMap = new Map<String,IPM_Project_Rollout__c>();
        
        //Map of rollouts which  are going to be either created or updated on country mco change 
        Map<String,IPM_Project_Rollout__c>  mcoCodeToRolloutUpsertMap = new Map<String,IPM_Project_Rollout__c>(); 
        
        //Map of rollouts which  are going to be either created or updated on country mco change 
        Map<String,IPM_Project_Rollout__c>  mcoCodeToDeepClonedRolloutUpsertMap = new Map<String,IPM_Project_Rollout__c>(); 
        
        //rollout to parent project TLD Map, this is to set the TLD of rollout if they are being newly created
        Map<String,Date> rollourExtIdToParentProjTLDMap = new Map<String,Date>(); 
        
        //This is to update the country rollout association 
        Map<Id,IPM_Country__c> updateCountryRolloutAssoMap = new  Map<Id,IPM_Country__c>();

        //Map holding new and old Rollout  External IDs
        Map<String,String>  financialChangeExtIdMap = new Map<String,string>();

        //Financials which need updation on rollouts change
        List<IPM_Financial__c> changeFinancialsExtId= new List<IPM_Financial__c>(); 

        //Financials  years which need updation on financial change
        List<IPM_Financial_Year__c> changeFinancialYearExtId= new List<IPM_Financial_Year__c>();
        
        //Id's of local rollouts being operated 
        Set<Id> countryAssoLocalRollouts = new Set<Id>(); 
        
        //ExternalId's of local rollouts either newly created or already existing 
        Set<String>  countryAssoLocalRolloutsExtIds = new Set<String>();
        
        //project which needs name updation on account of rollout name change 
        List<IPM_project__c> updatedNameProjects = new  List<IPM_project__c>();

        //milestones which needs name updation on account of project name change
        List<IPM_Milestone__c> toBeUpdatedMiles = New List<IPM_Milestone__c>();

        //tasks which needs name updation on account of project name change
        List<IPM_Task__c> toBeUpdatedTasks = new  List<IPM_Task__c>();

        //project document which needs name updation on account of project name change
        List<IPM_Project_Document__c> toBeUpdatedDocuments = new  List<IPM_Project_Document__c>();

        //Project document sections  which needs name updation on account of document name change
        List<IPM_Project_Document_Section__c> toBeUpdatedDocSections = New List<IPM_Project_Document_Section__c>();
            
        //local project Ids to collect the related records
        Set<Id> localProjectIds = new  Set<Id>();
		
		Map<String,String>  newToOldExtIdMap = new  Map<String,String>();
    
        SavePoint setDbPointer = Database.SetSavePoint();
        
        try
        {
            for(IPM_Country__c ipmCountry : countryList)  
            {
                
                countryAssoLocalRollouts.add(ipmCountry.Local_Rollout__c);
                
                if(ipmCountry.MCO_Code__c!=null && mapMCOCodeToShortName.ContainsKey(ipmCountry.MCO_Code__c) && ipmCountry.Local_Rollout__r.name!=null && ((!ipmCountry.Local_Rollout__r.name.endsWith(IPM_ConstantUtils.UNDERSCORE+mapMCOCodeToShortName.get(ipmCountry.MCO_Code__c).Short_Name__c) && ipmCountry.IPM_Rollout_Status__c !=IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE ) || (!ipmCountry.Local_Rollout__r.name.endsWith(IPM_ConstantUtils.UNDERSCORE+ipmCountry.Country_Code__c) && ipmCountry.IPM_Rollout_Status__c == IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE ) || ipmCountry.MCO_Code__c != ipmCountry.Local_Rollout__r.MCO__c || ipmCountry.MCO_Name__c!=ipmCountry.Local_Rollout__r.MCO_Name__c ))
                { 
                    
                    countryMap.put(ipmCountry.Id, ipmCountry);  

					impactedCountryIds.add(ipmCountry.Id);
                    
                    String shortName = mapMCOCodeToShortName.get(ipmCountry.MCO_Code__c).Short_Name__c;
                    
                    String rolloutName = ipmCountry.IPM_Rollout_Status__c == IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE ? ipmCountry.Local_Rollout__r.name.substringBeforeLast(IPM_ConstantUtils.UNDERSCORE)+IPM_ConstantUtils.UNDERSCORE+ipmCountry.Country_Code__c :ipmCountry.Local_Rollout__r.name.substringBeforeLast(IPM_ConstantUtils.UNDERSCORE)+IPM_ConstantUtils.UNDERSCORE+shortName;
                
                    String rolloutExternalId = ipmCountry.IPM_Rollout_Status__c == IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE ? ipmCountry.Local_Rollout__r.IPM_Rollout_Project__c.substringBeforeLast(IPM_ConstantUtils.UNDERSCORE)+IPM_ConstantUtils.UNDERSCORE+ipmCountry.Country_Code__c : ipmCountry.Local_Rollout__r.IPM_Rollout_Project__c.substringBeforeLast(IPM_ConstantUtils.UNDERSCORE)+IPM_ConstantUtils.UNDERSCORE+shortName;
                    
                    countryAssoLocalRolloutsExtIds.add(rolloutExternalId);
                    
                    Date newRolloutTLD =  ipmCountry.IPM_Regional_Project__r.IPM_Target_Launch_Dates__c !=null ?  ipmCountry.IPM_Regional_Project__r.IPM_Target_Launch_Dates__c : ipmCountry.IPM_Project__r.IPM_Target_Launch_Dates__c ;
                    
                    rollourExtIdToParentProjTLDMap.put(rolloutExternalId,newRolloutTLD);

                    if(ipmCountry.MCO_Code__c == ipmCountry.Local_Rollout__r.MCO__c || ipmCountry.IPM_Rollout_Status__c ==IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE) 
                    {
                        
                        financialChangeExtIdMap.put(ipmCountry.Local_Rollout__r.IPM_Rollout_Project__c,rolloutExternalId);
                        
                        mcoCodeToRolloutMap.put(ipmCountry.Local_Rollout__c,new IPM_Project_Rollout__c(MCO__c=ipmCountry.MCO_Code__c,MCO_Name__c=ipmCountry.MCO_Name__c,name=rolloutName,IPM_Rollout_Project__c=
                        
                        rolloutExternalId,Id=ipmCountry.Local_Rollout__c) );  
						
						//if mco  rename conflicts with existing one , the country will be reparented , the old parent mco will result into duplicate error and later would be inactivated/deleted 
						IPM_Country__c ipmNewCountry = new IPM_Country__c();
                            
						ipmNewCountry.Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c=rolloutExternalId);
						
						ipmNewCountry.Project_Country__c =  rolloutName.substringBeforeLast(IPM_ConstantUtils.UNDERSCORE) + IPM_ConstantUtils.UNDERSCORE + ipmCountry.Country_Code__c;
						
						ipmNewCountry.Id =ipmCountry.Id;
						
						ipmNewCountry.IsActive__c = ipmCountry.isActive__c ;
						
						updateCountryRolloutAssoMap.put(ipmCountry.Id,ipmNewCountry); 

                    } 
                    else
                    {
                        IPM_Project_Rollout__c deepClonedRollout = countryListDeepCloneMap.get(ipmCountry.Id).Local_Rollout__r.clone(false, true, false, false);
                        
						newToOldExtIdMap.put(rolloutExternalId,deepClonedRollout.IPM_Rollout_Project__c);
						
						deepClonedRollout.name=rolloutName;
                        
                        deepClonedRollout.IPM_Rollout_Project__c=rolloutExternalId;
                        
                        deepClonedRollout.MCO__c =ipmCountry.MCO_Code__c;
                        
                        deepClonedRollout.MCO_Name__c =ipmCountry.MCO_Name__c; 
                        
                        deepClonedRollout.Local_Project__c =null;
                        
                        deepClonedRollout.IPM_Regional_PL__c=null;   
                        
                        deepClonedRollout.IPM_Regional_PL_Text__c=null; 
                        
                        deepClonedRollout.IPM_CharterFinancial__c=null; 
                        
                        deepClonedRollout.IPM_CharterApproved__c=false;
                        
                        deepClonedRollout.Finance_Member__c=null; 
                        
                        deepClonedRollout.Target_Launch_Date__c=ipmCountry.Local_Rollout__r.Target_Launch_Date__c;
                        
                        mcoCodeToDeepClonedRolloutUpsertMap.put(rolloutExternalId,deepClonedRollout);
                        
                        IPM_Project_Rollout__c clonedRollout = ipmCountry.Local_Rollout__r.clone(false, false, false, false);
                        
                         //updating rollout name and external id , not required when there is only change in mco code of the country and no change in the short name.Like country moved to middle America from central America,short name not updated but country geo changed and so as the mco code and mdm id of geo
                        if(ipmCountry.Local_Rollout__r.name!=null && ((!ipmCountry.Local_Rollout__r.name.endsWith(IPM_ConstantUtils.UNDERSCORE+mapMCOCodeToShortName.get(ipmCountry.MCO_Code__c).Short_Name__c) && ipmCountry.IPM_Rollout_Status__c !=IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE ) || (!ipmCountry.Local_Rollout__r.name.endsWith(IPM_ConstantUtils.UNDERSCORE+ipmCountry.Country_Code__c) && ipmCountry.IPM_Rollout_Status__c == IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE )))
                        {
                            
                            clonedRollout.name=rolloutName;
                        
                            clonedRollout.IPM_Rollout_Project__c=rolloutExternalId;
                            
                            IPM_Country__c ipmNewCountry = new IPM_Country__c();
							
							ipmNewCountry.Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c=rolloutExternalId);
							
							ipmNewCountry.Project_Country__c =  rolloutName.substringBeforeLast(IPM_ConstantUtils.UNDERSCORE) + IPM_ConstantUtils.UNDERSCORE + ipmCountry.Country_Code__c;
							
							ipmNewCountry.Id =ipmCountry.Id;
                            
                            ipmNewCountry.IsActive__c = ipmCountry.isActive__c ;
							
							updateCountryRolloutAssoMap.put(ipmCountry.Id,ipmNewCountry);
						}
						
                        clonedRollout.MCO__c =ipmCountry.MCO_Code__c;
                        
                        clonedRollout.MCO_Name__c =ipmCountry.MCO_Name__c;
                        
                        mcoCodeToRolloutUpsertMap.put(rolloutExternalId,clonedRollout);
                    }

                }
                
            }

            if(mcoCodeToRolloutMap.values()!= Null && !mcoCodeToRolloutMap.isEmpty())
            {
                mcoCodeToRolloutMap.remove(null);
                
			    //During renaming ,countries can be reparented,the renaming of rollout may result into an error as the same name rollout may already exist,in this scenario the errorneous rollout would be later inactivated,deleted,but the country should get reparented,so no transaction  failure should occur in this scenario.  
                
				Database.update(mcoCodeToRolloutMap.values(),false) ;
				
            } 

            Set<String> existingRollouts = new Set<String>();
			
			Set<String> toBeUpdatedFinIds = new Set<String>();
			
			//Set<String> toBeReferencedFinIds = new Set<String>();
			
            Map<String,String> newOldExtMap = new Map<String,string>();
            
            Map<String ,ID> finExtIdToParentRegRolloutMap = new Map<String ,ID>(); 

            
            if(mcoCodeToRolloutUpsertMap.values()!= Null && !mcoCodeToRolloutUpsertMap.isEmpty())
            {
               
                
                for(IPM_Project_Rollout__c rollout :[ Select IPM_Rollout_Project__c from  IPM_Project_Rollout__c where IPM_Rollout_Project__c IN: mcoCodeToRolloutUpsertMap.keyset()])
                {
                    existingRollouts.add(rollout.IPM_Rollout_Project__c);
                }
                
                for( String extId : mcoCodeToRolloutUpsertMap.keyset())
                {
                    if(!existingRollouts.Contains(extId))
                    {
                        
                        if(mcoCodeToRolloutUpsertMap.get(extId).KeyMCO__c)
						{
							toBeUpdatedFinIds.add(extId);
						}
						else
						{
							toBeUpdatedFinIds.add(extId.substringBeforeLast(IPM_ConstantUtils.UNDERSCORE)+'_NONKEY');
						}
						
						mcoCodeToDeepClonedRolloutUpsertMap.get(extId).Target_Launch_Date__c= rollourExtIdToParentProjTLDMap.get(extId);
                        
                        mcoCodeToRolloutUpsertMap.put(extId,mcoCodeToDeepClonedRolloutUpsertMap.get(extId));
                    }
					
                }
				
				for( String extId :newToOldExtIdMap.keyset())
				{
					if(mcoCodeToRolloutUpsertMap.get(extId).KeyMCO__c)
					{
						//toBeReferencedFinIds.add(extId);
						newOldExtMap.put(extId,newToOldExtIdMap.get(extId));
					}
					else
					{ 
						//toBeReferencedFinIds.add(extId.substringBeforeLast(IPM_ConstantUtils.UNDERSCORE)+'_NONKEY');
						newOldExtMap.put(extId.substringBeforeLast(IPM_ConstantUtils.UNDERSCORE)+'_NONKEY',newToOldExtIdMap.get(extId).substringBeforeLast(IPM_ConstantUtils.UNDERSCORE)+'_NONKEY');

                    }
                    
                }
                
                for(IPM_Financial__c fin : [Select id ,Financial_External_ID__c,IPM_Project_Rollout__c from  IPM_Financial__c where Financial_External_ID__c IN : newOldExtMap.values()])
                {
                    finExtIdToParentRegRolloutMap.put(fin.Financial_External_ID__c,fin.IPM_Project_Rollout__c);
                }
                
				upsert  mcoCodeToRolloutUpsertMap.values() IPM_Rollout_Project__c ;
               
            } 

            if( !updateCountryRolloutAssoMap.isEmpty())
            {
                for(IPM_Country__c ipmCoun : updateCountryRolloutAssoMap.values())
                {
                    if(!existingRollouts.Contains(ipmCoun.Local_Rollout__r.IPM_Rollout_Project__c))
                    {
                        ipmCoun.Local_Rollout_Charter__c =null;
                        
                        ipmCoun.IPM_CharterApproved__c=false;
                    }
                    
                }
                
                update updateCountryRolloutAssoMap.values();  
            }
            
            for(IPM_Financial__c  defaultLocalFin :[Select Id,Financial_External_ID__c ,IPM_Key_Financial__c ,(Select Id, External_Id__c,Financial_External_Id__c from IPM_Financial_Years__r) from IPM_Financial__c where Financial_External_ID__c IN : financialChangeExtIdMap.keyset()  AND IPM_Key_Financial__c=true ])
            {
                String extId = financialChangeExtIdMap.get(defaultLocalFin.Financial_External_ID__c);
                
                for(IPM_Financial_Year__c finYear : defaultLocalFin.IPM_Financial_Years__r) 
                {
                    finYear.External_Id__c= finYear.External_Id__c.replace(finYear.Financial_External_Id__c, extId);
                    
                    changeFinancialYearExtId.add(finYear);
                }
                
                defaultLocalFin.Financial_External_ID__c = extId;
                
                changeFinancialsExtId.add(defaultLocalFin );     
            }


            if( !changeFinancialsExTId.isEmpty()) 
            {
                update changeFinancialsExtId;
            } 

            if( !changeFinancialYearExtId.isEmpty())
            {
                update changeFinancialYearExtId; 
                
            } 

            //Rollouts to be deleted if all the countries are removed
            List<IPM_Project_Rollout__c> toBeDeletedRollouts = new List<IPM_Project_Rollout__c>();

            //Charter approved or the ones with project created can not be deleted , so clearing out  charter flag and project look up so as to make them eligible for deletion
            List<IPM_Project_Rollout__c> toBeUpdatedRollouts = new List<IPM_Project_Rollout__c>();

            //List of projects to be marked as legacy
            List<IPM_Project__c>  toBeMarkedLegacy = new List<IPM_Project__c>();
            
            //Querying over local rollouts to find out the ones without any country
            List<IPM_Project_Rollout__c> localRolloutsList =[ Select Id,Local_Project__c , (Select Id from IPM_Countries_Local__r ), isActive__c , IPM_CharterApproved__c from ipm_project_rollout__c where  IPM_Rollout_Span__c='Local' AND (Id IN  : countryAssoLocalRollouts OR IPM_Rollout_Project__c IN  : countryAssoLocalRolloutsExtIds) limit 50000];
            
            for(IPM_Project_Rollout__c rollout :localRolloutsList )
            {
                if(rollout.IPM_Countries_Local__r.isEmpty())
                {
                    if(rollout.IPM_CharterApproved__c)
                    {
                        rollout.isActive__c=false;  
                    
                        toBeUpdatedRollouts.add(rollout);
                    }
                    else
                    {                        
                        toBeDeletedRollouts.add(rollout);                    
                    }

                    if(rollout.Local_Project__c!=null) 
                    {
                        toBeMarkedLegacy.add(new IPM_Project__c(Id=rollout.Local_Project__c,IPM_Project_Status__c='Legacy',Is_Archieved__c=true,IPM_Parent_Project__c=null,IPM_Project_Rollout__c=null) );
                    }
                    
                }
                
            }
                
            if(!toBeUpdatedRollouts.isEmpty())
            {
                update toBeUpdatedRollouts; 
            }

            if(!toBeDeletedRollouts.isEmpty())
            {
                delete toBeDeletedRollouts;                 
            }

            if(!toBeMarkedLegacy.isEmpty())
            {
                update toBeMarkedLegacy;
            }
            
            for(IPM_Project_Rollout__c rlout :[Select Id ,name, Local_Project__c,Local_Project__r.name  from  IPM_Project_Rollout__c where IPM_Rollout_Span__c='Local' AND ( Id IN  : countryAssoLocalRollouts OR IPM_Rollout_Project__c IN  : countryAssoLocalRolloutsExtIds ) limit 50000])
            {
                 if(rlout.name!=null && rlout.Local_Project__r.name!=null && rlout.name!= rlout.Local_Project__r.name ) 
                 {
                     updatedNameProjects.add(new IPM_project__c(Id=rlout.Local_Project__c,name=rlout.name,IPM_Project_Name__c=rlout.name));
                     
                     localProjectIds.add(rlout.Local_Project__c);
                 }

            }
                
            if(!updatedNameProjects.isEmpty())
            {
                update updatedNameProjects;
            }

            List<IPM_project__c> updatedProjectRelationshipsData = [Select Id , name , ( Select Id,name, ExternalField__c, IPM_Project__r.Name from Tasks__r ),(Select Id,name,IPM_Project_Name__c from IPM_Milestones__r) , ( Select Id,name,IPM_Project__r.Name from Project_Documents__r  ) from IPM_project__c where Id IN : localProjectIds limit 50000 ] ;


            for(IPM_project__c relationalData : updatedProjectRelationshipsData )
            {
                
                for(IPM_Milestone__c milestone: relationalData.IPM_Milestones__r)
                {
                    if(!milestone.Name.substringBefore(IPM_ConstantUtils.HYPHEN_DELIMITER).equals(milestone.IPM_Project_Name__c))
                    {
                        milestone.Name = milestone.Name.replace(milestone.Name.substringBefore(IPM_ConstantUtils.HYPHEN_DELIMITER), milestone.IPM_Project_Name__c);
                        
                        toBeUpdatedMiles.add(milestone);
                    }
                    
                }
                
                for(IPM_Task__c task: relationalData.Tasks__r)
                {
                    if(!task.Name.substringBefore(IPM_ConstantUtils.HYPHEN_DELIMITER).equals(task.IPM_Project__r.Name))
                    {
                        task.ExternalField__c = task.ExternalField__c.replace(task.Name.substringBefore(IPM_ConstantUtils.HYPHEN_DELIMITER), task.IPM_Project__r.Name);
                        
                        task.Name = task.Name.replace(task.Name.substringBefore(IPM_ConstantUtils.HYPHEN_DELIMITER), task.IPM_Project__r.Name);
                        
                        toBeUpdatedTasks.add(task);
                    }   
                }
                
                for(IPM_Project_Document__c projDoc: relationalData.Project_Documents__r)
                {
                    if(!projDoc.Name.substringBefore(IPM_ConstantUtils.HYPHEN_DELIMITER).equals(projDoc.IPM_Project__r.Name))
                    {
                        projDoc.Name = projDoc.Name.replace(projDoc.Name.substringBefore(IPM_ConstantUtils.HYPHEN_DELIMITER), projDoc.IPM_Project__r.Name);
                        
                        toBeUpdatedDocuments.add(projDoc);
                    }   
                }
                
            }

            if(!toBeUpdatedMiles.isEmpty()) 
            {
                update  toBeUpdatedMiles;
            }

            if(!toBeUpdatedTasks.isEmpty())
            {
                update toBeUpdatedTasks;
            }

            if(!toBeUpdatedDocuments.isEmpty())  
            {
                update toBeUpdatedDocuments;
            }

            for(IPM_Project_Document_Section__c proDocSec: [Select Id, Name, IPM_Project_Document__r.IPM_Project__r.Name From IPM_Project_Document_Section__c Where IPM_Project_Document__r.IPM_Project__c IN : localProjectIds])
            {
                if(!proDocSec.Name.substringBefore(IPM_ConstantUtils.HYPHEN_DELIMITER).equals(proDocSec.IPM_Project_Document__r.IPM_Project__r.Name))
                {
                    proDocSec.Name = proDocSec.Name.replace(proDocSec.Name.substringBefore(IPM_ConstantUtils.HYPHEN_DELIMITER), proDocSec.IPM_Project_Document__r.IPM_Project__r.Name); 
                    
                    toBeUpdatedDocSections.add(proDocSec);
                }   
            } 

            if(!toBeUpdatedDocSections.isEmpty())
            {                
                update toBeUpdatedDocSections;   
            }
			
			Map<Id,IPM_Financial__c> toBeupdateFin = new Map<Id,IPM_Financial__c>();
			
			for(IPM_Financial__c financial : [Select Id,Financial_External_ID__c,IPM_Project_Rollout__c,IPM_Key_Financial__c from IPM_Financial__c where Financial_External_ID__c IN :toBeUpdatedFinIds] )
			{
				if(financial.IPM_Project_Rollout__c==null)
				{
					financial.IPM_Project_Rollout__c = finExtIdToParentRegRolloutMap.get(newOldExtMap.get(financial.Financial_External_ID__c));
				}
				
                toBeupdateFin.put(financial.Id,financial);  
			}
			
			
			if(!toBeupdateFin.isEmpty())
			{
					update toBeupdateFin.values();
			}
			
        List<IPM_Country__c> lstUpdateCountry = new List<IPM_Country__c>();

        for(IPM_Country__c ipmCountry :[Select Id, isActive__c, Local_Rollout__r.Local_Project__c, Local_Rollout__c,IPM_Project__c,IPM_Regional_Project__c,IPM_Local_Project__c from IPM_Country__c where ID IN :countryMap.keyset() ])
        {
            ipmCountry.isActive__c = countryMap.get(ipmCountry.Id).isActive__c;
			ipmCountry.IPM_Local_Project__c = ipmCountry.Local_Rollout__r.Local_Project__c;
            lstUpdateCountry.add(ipmCountry);
        }
        
        if(!lstUpdateCountry.isEmpty())
        {
            update lstUpdateCountry;
        }
      
        }
       
        
        catch(Exception ex)
        {
            Database.Rollback(setDbPointer);
            
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'IPM_AlignDataOnGeographyChange_Batch','Execute',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
        }

    }

    public  void finish(Database.BatchableContext batchContext)  
    {
        
        Set<String> impactedLocalRolloutIds = new Set<String>(); 
        
        Set<String> impactedProjIds = new Set<String>(); 
        
        for(IPM_Country__c ipmCountry :[Select Id, isActive__c,  Local_Rollout__c,IPM_Project__c,IPM_Regional_Project__c,IPM_Local_Project__c from IPM_Country__c where ID IN :impactedCountryIds ])
        {
            impactedLocalRolloutIds.add(ipmCountry.Local_Rollout__c);
            
            impactedProjIds.addAll(new Set<String> {ipmCountry.IPM_Project__c,ipmCountry.IPM_Regional_Project__c,ipmCountry.IPM_Local_Project__c});
           
        }
      
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {UserInfo.getUserEmail()}; 
            
        mail.setToAddresses(toAddresses);
        
        mail.setSubject( 'Impacted Countries , Projects And Local Rollouts');  
        
        String plainTextBody = 'Impacted Countries: '+String.join(new List<String> (impactedCountryIds), ';') + ' Impacted Projects: '+String.join(new List<String> (impactedProjIds), ';') + 'Prime Focus :: Impacted Local Rollouts: '+String.join(new List<String> (impactedLocalRolloutIds), ';');
        
        mail.setPlainTextBody(plainTextBody); 
        
        //sends an email for job status, after the job is completed. 
        IPM_Utils.sendApexJobStatusMail(batchContext); 
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
        
    } 


}