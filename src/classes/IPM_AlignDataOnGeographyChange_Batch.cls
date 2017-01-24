/*****************************************************************************************************************************
* This is the class to align the data with the country geography changes
* This class is without sharing as a batch job to be run by an admin for data alignment,access level should not be the issue
******************************************************************************************************************************/
public without sharing   class IPM_AlignDataOnGeographyChange_Batch implements Database.Batchable<sObject>
{

    List<String> applicableGKMs = New List<String>{'GKM1','GKM2','GKM3','GKM4'};
     
    //Map to hold MCO short names 
    Map<String,IPM_MCO_Short_Names__c> mapMCOCodeToShortName =  IPM_MCO_Short_Names__c.getAll();
 
    public Database.QueryLocator start(Database.BatchableContext BC)      
    {
        // returns country and associated data for project records 
        return Database.getQueryLocator([ Select Id from  IPM_Project__c  where IPM_ProjectGKM__c IN :applicableGKMs   limit  50000]) ;
    }

    public void execute(Database.BatchableContext BC ,List<IPM_Project__c> geoImpactedProjects) 
    {
        
        Map<Id,IPM_Project__c> projectMap = new   Map<Id,IPM_Project__c>(geoImpactedProjects);
        
        //list to hold the country records associated with a project , they will be further operated on to identify the geography  change
        List<IPM_Country__c> countryList = [Select Id,MCO_Name__c, Local_Rollout__r.IPM_CharterApproved__c,Local_Rollout__r.IPM_Project__c,Local_Rollout__r.Regional_Rollout__c, Local_Rollout__r.Regional_Project__c, Local_Rollout__c, IPM_Project__c, MDO_Geography__r.mdm_Id__c, MCO_Code__c,Market_Cluster_Code__c, IPM_Project__r.IPM_Project_Name__c, IPM_Regional_Project__r.IPM_ProjectGKM__c, IPM_Regional_Project__c, Local_Rollout__r.MCO__c,  
        IPM_Rollout_Status__c ,  Local_Rollout__r.KeyMCO__c,IPM_Regional_Project__r.IPM_Target_Launch_Dates__c,IPM_Project__r.IPM_Target_Launch_Dates__c,
        Local_Rollout__r.Regional_Rollout__r.IPM_Rollout_Project__c , Local_Rollout__r.name, Local_Rollout__r.IPM_Rollout_Project__c, Country_Code__c,Local_Rollout__r.Project_Sustainability_Period__c,Local_Rollout__r.Target_Launch_Date__c,IPM_Regional_Project__r.IPM_Project_Name__c   From IPM_Country__c  Where    Local_Rollout__c !=Null  AND 
       (IPM_Project__c IN : projectMap.keySet() OR  IPM_Regional_Project__c IN :   projectMap.keySet() ) ];
        
        //Map of rollouts whose name need updation
        Map<String,IPM_Project_Rollout__c>  mcoCodeToRolloutMap = new Map<String,IPM_Project_Rollout__c>();
        
        //Map of rollouts which  are going to be either created or updated on country mco change
        Map<String,IPM_Project_Rollout__c>  mcoCodeToRolloutUpsertMap = new Map<String,IPM_Project_Rollout__c>(); 
        
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
    
        SavePoint SP = Database.SetSavePoint();
        
        try
        {
            for(IPM_Country__c ipmCountry : countryList)  
            {
                countryAssoLocalRollouts.add(ipmCountry.Local_Rollout__c);
                
                if(ipmCountry.MCO_Code__c!=null&&mapMCOCodeToShortName.ContainsKey(ipmCountry.MCO_Code__c) &&(ipmCountry.Local_Rollout__r.name!=null && !ipmCountry.Local_Rollout__r.name.endsWith('_'+mapMCOCodeToShortName.get(ipmCountry.MCO_Code__c).Short_Name__c)))
                {
                    String shortName = mapMCOCodeToShortName.get(ipmCountry.MCO_Code__c).Short_Name__c;
                    
                    String rolloutName = ipmCountry.IPM_Rollout_Status__c=='Seperate' ? ipmCountry.Local_Rollout__r.name.substringBeforeLast('_')+'_'+ipmCountry.Country_Code__c :ipmCountry.Local_Rollout__r.name.substringBeforeLast('_')+'_'+shortName;
                
                    String rolloutExternalId = ipmCountry.IPM_Rollout_Status__c=='Seperate' ? ipmCountry.Local_Rollout__r.IPM_Rollout_Project__c.substringBeforeLast('_')+'_'+ipmCountry.Country_Code__c : ipmCountry.Local_Rollout__r.IPM_Rollout_Project__c.substringBeforeLast('_')+'_'+shortName;
                    countryAssoLocalRolloutsExtIds.add(rolloutExternalId);
                    
                    Date newRolloutTLD =  ipmCountry.IPM_Regional_Project__r.IPM_Target_Launch_Dates__c !=null ?  ipmCountry.IPM_Regional_Project__r.IPM_Target_Launch_Dates__c : ipmCountry.IPM_Project__r.IPM_Target_Launch_Dates__c ;
                    
                    rollourExtIdToParentProjTLDMap.put(rolloutExternalId,newRolloutTLD);

                    if(ipmCountry.MCO_Code__c==ipmCountry.Local_Rollout__r.MCO__c || ipmCountry.IPM_Rollout_Status__c=='Seperate') 
                    {
                        
                        financialChangeExtIdMap.put(ipmCountry.Local_Rollout__r.IPM_Rollout_Project__c,rolloutExternalId);
                        
                        mcoCodeToRolloutMap.put(ipmCountry.Local_Rollout__c,new IPM_Project_Rollout__c(MCO_Name__c=ipmCountry.MCO_Name__c,name=rolloutName,IPM_Rollout_Project__c=
                        
                        rolloutExternalId,Id=ipmCountry.Local_Rollout__c) );

                    } 
                    else 
                    {
                        IPM_Project_Rollout__c clonedRollout = ipmCountry.Local_Rollout__r.clone(false, false, false, false);
                        
                        clonedRollout.name=rolloutName;
                        
                        clonedRollout.IPM_Rollout_Project__c=rolloutExternalId;
                        
                        clonedRollout.MCO__c =ipmCountry.MCO_Code__c;
                        
                        clonedRollout.MCO_Name__c =ipmCountry.MCO_Name__c;
                        
                        clonedRollout.Target_Launch_Date__c=ipmCountry.Local_Rollout__r.Target_Launch_Date__c;
                    
                        mcoCodeToRolloutUpsertMap.put(rolloutExternalId,clonedRollout);
                        

                        IPM_Country__c ipmNewCountry = new IPM_Country__c();
                        
                        ipmNewCountry.Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c=rolloutExternalId);
                        
                        ipmNewCountry.Project_Country__c =  rolloutName.substringBeforeLast('_') + '_' + ipmCountry.Country_Code__c;
                        
                        ipmNewCountry.Id =ipmCountry.Id;
                        
                        updateCountryRolloutAssoMap.put(ipmCountry.Id,ipmNewCountry);
                    }

                }
                
            }

            if(mcoCodeToRolloutMap.values()!= Null && !mcoCodeToRolloutMap.isEmpty())
            {
                mcoCodeToRolloutMap.remove(null);
                
                update  mcoCodeToRolloutMap.values() ;
            } 

            if(mcoCodeToRolloutUpsertMap.values()!= Null && !mcoCodeToRolloutUpsertMap.isEmpty())
            {
                Set<String> existingRollouts = new Set<String>();
                
                for(IPM_Project_Rollout__c rollout :[ Select IPM_Rollout_Project__c from  IPM_Project_Rollout__c where IPM_Rollout_Project__c IN: mcoCodeToRolloutUpsertMap.keyset()])
                {
                    existingRollouts.add(rollout.IPM_Rollout_Project__c);
                }
                
                for( String extId : mcoCodeToRolloutUpsertMap.keyset())
                {
                    if(!existingRollouts.Contains(extId))
                    {
                        mcoCodeToRolloutUpsertMap.get(extId).Target_Launch_Date__c= rollourExtIdToParentProjTLDMap.get(extId);
                    }
                }
                
                upsert  mcoCodeToRolloutUpsertMap.values() IPM_Rollout_Project__c ;
            } 

            if( !updateCountryRolloutAssoMap.isEmpty())
            {
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
                        toBeMarkedLegacy.add(new IPM_Project__c(Id=rollout.Local_Project__c,IPM_Project_Status__c='Legacy',IPM_Parent_Project__c=null) );
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
                    if(!milestone.Name.substringBefore('-').equals(milestone.IPM_Project_Name__c))
                    {
                        milestone.Name = milestone.Name.replace(milestone.Name.substringBefore('-'), milestone.IPM_Project_Name__c);
                        
                        toBeUpdatedMiles.add(milestone);
                    }
                    
                }
                
                for(IPM_Task__c task: relationalData.Tasks__r)
                {
                    if(!task.Name.substringBefore('-').equals(task.IPM_Project__r.Name))
                    {
                        task.ExternalField__c = task.ExternalField__c.replace(task.Name.substringBefore('-'), task.IPM_Project__r.Name);
                        
                        task.Name = task.Name.replace(task.Name.substringBefore('-'), task.IPM_Project__r.Name);
                        
                        toBeUpdatedTasks.add(task);
                    }   
                }
                
                for(IPM_Project_Document__c projDoc: relationalData.Project_Documents__r)
                {
                    if(!projDoc.Name.substringBefore('-').equals(projDoc.IPM_Project__r.Name))
                    {
                        projDoc.Name = projDoc.Name.replace(projDoc.Name.substringBefore('-'), projDoc.IPM_Project__r.Name);
                        
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
                if(!proDocSec.Name.substringBefore('-').equals(proDocSec.IPM_Project_Document__r.IPM_Project__r.Name))
                {
                    proDocSec.Name = proDocSec.Name.replace(proDocSec.Name.substringBefore('-'), proDocSec.IPM_Project_Document__r.IPM_Project__r.Name); 
                    toBeUpdatedDocSections.add(proDocSec);
                }   
            } 

            if(!toBeUpdatedDocSections.isEmpty())
            {                
                update toBeUpdatedDocSections;   
            }
       
        }
        
        catch(Exception ex)
        {
            Database.Rollback(SP);
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'IPM_AlignDataOnGeographyChange_Batch','Execute',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
        }

    }

    public  void finish(Database.BatchableContext BC) 
    {
        //sends an email for job status, after the job is completed. 
        IPM_Utils.sendApexJobStatusMail(BC);         
    }


}