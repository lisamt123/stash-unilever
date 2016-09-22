/**********************************************************************
Name:  KUN_ProfileTriggerHandler ()
Copyright  2016  Unilever
======================================================================
======================================================================
Purpose:  Trigger Helper Class                                                
To Handle the extendated Search Requirment & for Apex Sharing 
Rules                                 
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
****************************************************************************/
public with sharing class KUN_ProfileTriggerHandler {

    /*******************************************************************
    Purpose: This method before Insert 
    Parameters : newProfiles- List of profiles Updated
    ********************************************************************/     
    public void OnBeforeInsert(List<KUN_Profile__c> newProfiles)
    {
        system.debug('Profile Trigger On Before Insert');
                       
        for(KUN_Profile__c moProfile : newProfiles){        
          PopulateSearchableFields(moProfile ); 
        }
    }
    /*******************************************************************
    Purpose: This method after Insert of records 
    Parameters : newProfiles- List of profiles Updated
    ********************************************************************/
     public void OnAfterInsert(List<KUN_Profile__c> newProfiles)
     {
        // Create a new list of sharing objects for Job
        List<KUN_Profile__Share> Profileshare  = new List<KUN_Profile__Share>();
        
        // Declare variables for KUN Community Profile sharing with User for Edit 
        KUN_Profile__Share userShare;   

         for(KUN_Profile__c moProfile : newProfiles){        
            // Instantiate the sharing objects
            userShare = new KUN_Profile__Share ();
                        
            // Set the ID of record being shared
            userShare.ParentId = moProfile.Id;
             // Set the ID of user or group being granted access
            userShare.UserOrGroupId = moProfile.Unilever_Profile__c;           
            // Set the access level
            userShare.AccessLevel = 'edit';
            // Set the Apex sharing reason for KUN Profile 
            userShare.RowCause = Schema.KUN_Profile__Share.RowCause.KUN_Self_Update__c;
             // Add objects to list for insert
            Profileshare.add(userShare);
           } 
           // Insert sharing records and capture save result 
        // The false parameter allows for partial processing if multiple records are passed 
        // into the operation 
        Database.SaveResult[] lsr = Database.insert(Profileshare,false);
        
           
    }
  /*******************************************************************
    Purpose: This method before Insert 
    Parameters : newProfiles- List of profiles Updated
    ********************************************************************/
    public void OnBeforeUpdate( List<KUN_Profile__c> newProfiles)
    {
        system.debug('Profile Trigger On Before Update ');       
        for(KUN_Profile__c moProfile : newProfiles){        
            PopulateSearchableFields(moProfile );
        }
        //Update newProfiles ;
    }

   /*******************************************************************
    Code to update the Picklist value to Searchable Field to make it Searchable
    Parameters : numRecords- copy the fields in profile 
    ********************************************************************/
   private void PopulateSearchableFields(KUN_Profile__c moProfile){    
            moProfile.Capability_Searchable_Field__c      =     moProfile.Capability__c;
            moProfile.Cluster_Searchable_Field__c         =     moProfile.Cluster__c ;
            moProfile.E2E_Process_Searchable_Field__c     =     moProfile.E2E_Process__c;
            moProfile.Employee_Type_Searchable_Field__c   =     moProfile.Employee_Type__c;
            moProfile.KUN_Role_Type_Searchable_Field__c   =     moProfile.KUN_Role_Type__c ;
            moProfile.Organization_Searchable_Field__c    =     moProfile.Organization__c;
            moProfile.Position_Searchable_Field__c        =     moProfile.Position__c;
            moProfile.Profile_Id__c                       =     moProfile.Unilever_Profile__c ;
   }
   
   

}