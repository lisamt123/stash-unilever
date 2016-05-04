/*****************************************************************************************
* @author       Execloud ©
* @date         2016-04-25
* @description  Apex class contains the logic for rollover process and keeping the
*				campaigns and assets in sync
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Execloud ©            	2016-04-25          Created
*
******************************************************************************************/
public with sharing class Oblix_SOWRollOverLogic {
	

	public Oblix_SOWRollOverLogic() {
		
	}


    /********************************************************************
    * @author       Execloud ©
    * @date         2014-07-11
    * @description  Decides which function to call depending on the process_name
                    passed in value
    *********************************************************************/
    public static void processStep(Oblix_syncBatchJob.JobComponent job_component){

    	system.debug('## process step: ' + job_component);
        
        Boolean is_success = true;

         // Processing product SKU step
        if (Oblix_Utils.JOB_PROCESS_SET_STATUS == job_component.process_name){
            is_success = adjustStatus(job_component);
        }
        else if(Oblix_Utils.JOB_PROCESS_CLONE_SOW == job_component.process_name){
            is_success = cloneSOWs(job_component);
        }
        else if(Oblix_Utils.JOB_PROCESS_CLONE_ATTACHMENTS == job_component.process_name){
            is_success = cloneAttachments(job_component);
        }
        else if(Oblix_Utils.JOB_PROCESS_CLONE_CAMPAIGN == job_component.process_name){
            is_success = cloneCampaigns(job_component);
        }
        else if(Oblix_Utils.JOB_PROCESS_CLONE_ASSETS == job_component.process_name){
            is_success = cloneAssets(job_component);
        }
        //else if(Oblix_Utils.JOB_PROCESS_SYNC_ASSETS == job_component.process_name){
        //    is_success = syncAssets(job_component);
        //}
        //else if(Oblix_Utils.JOB_PROCESS_SYNC_CAMPAIGN == job_component.process_name){
        //    is_success = initialSyncCampaign(job_component);
        //}
        

        
        //else if(SHL_Util.JOB_PROCESS_PRODUCT_SKU_UPSERT == jobComponent.interface_function__c){
        //    is_success = processProductSKUAlignment(jobComponent);
        //}
        //else if(SHL_Util.JOB_PROCESS_PRODUCT_ACTIVE == jobComponent.interface_function__c){
        //    is_success = processProductActiveFlag(jobComponent);
        //}

        //// update the job component with the status
        //updateJobComponentStatus(jobComponent,is_success);

        // update the batch job component with the status
        Oblix_SyncBatchJob.sync_job.job_has_error = !is_success;

    }

    /********************************************************************
    * @author       Execloud ©
    * @date         2014-07-11
    * @description  Depending on the passed in object and attributes 
    				set the status of sObject from A to B
    *********************************************************************/
	public static boolean adjustStatus(Oblix_syncBatchJob.JobComponent job_component){
		// set the status of the given SOW/Campaigns/Assets

        Boolean is_success = true;
        try{


            //##########################################################################################
            //	query the correct records in scope, set the status of the sync, add to list and update
            //##########################################################################################

            String query_string = 'SELECT Sync_Status__c FROM '+ job_component.attrib_3 +' WHERE Sync_Status__c =\'' + job_component.attrib_1 + '\' ORDER BY Id LIMIT ' + job_component.query_limit; 
            
            List<SObject> list_objects_update = new List<SObject>();
            Set<Id> set_original_ids = new Set<Id>();

            for (SObject obj: database.query(query_string)){
                obj.put('Sync_Status__c',job_component.attrib_2);
                list_objects_update.add(obj);
                set_original_ids.add(obj.Id);
            }

            // when sync is in progress, also make sure that the records being synced are "locked" by setting the status to "In Progress"
            if (String.isNotBlank(job_component.attrib_2)){
	            String query_string2 = 'SELECT Sync_Status__c FROM '+ job_component.attrib_3 +' WHERE Sync_Status__c =\'' + job_component.attrib_1 + '\' AND '+ job_component.attrib_4 +' in : set_original_ids ORDER BY Id LIMIT ' + job_component.query_limit; 
	            for (SObject obj: database.query(query_string)){
	                obj.put('Sync_Status__c',job_component.attrib_2);
	                list_objects_update.add(obj);
	            }
	        }

            update list_objects_update;
            
        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN adjustStatus() - ', queryEx.getMessage() + ' - STACK TRACE: ' + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN adjustStatus() - ', dmlEx.getMessage() + ' - STACK TRACE: ' + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN adjustStatus() - ', ex.getMessage() + ' - STACK TRACE: ' + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;   
	}

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  Need to sync the assets and add against the Campaign for NFY
    				also set NFY and PFY on the asset - it is also used for cloning
    				asset during approval process, depending on the 5 attributes 
    				passed to the method the query and logic changes
    ********************************************************************************/
	public static boolean syncAssetsDuringTransitionPeriod(Oblix_syncBatchJob.JobComponent job_component){
		
		Boolean is_success = true;
        try{

        	return is_success;
        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', queryEx.getMessage() + ' - STACK TRACE: ' + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', dmlEx.getMessage() + ' - STACK TRACE: ' + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', ex.getMessage() + ' - STACK TRACE: ' + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  


	}

    /********************************************************************
    * @author       Execloud ©
    * @date         2014-07-11
    * @description  Sync Campaign 
			        - Adjust attributes for Campaigns from Orig-NFY - delete and recreate Hub&Splits - if required -
			        - copy over the calculator fees and box number to PFY
			        - copy the chevron box info to NFY
			        - If the % complete is equal 100% then need to delete the NFY related campaign

    *********************************************************************/
	public static boolean syncCampaignDuringTransitionPeriod(Oblix_syncBatchJob.JobComponent job_component){

  
        Boolean is_success = true;
        
        try{


            //##########################################################################################
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            String query_string = 'SELECT ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_SOW_Projects__c'),',');
            query_string += ', (SELECT ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string += ' FROM  Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c =\'' + job_component.attrib_1 + '\' AND Campaign_NFY__c = NULL OR (Campaign_NFY__c != NULL AND Percentage_of_Fee_for_this_FY__c == 100.00) ORDER BY Id LIMIT ' + job_component.query_limit; 
            

            List<Oblix_SOW_Projects__c> list_campaigns_to_clone = new List<Oblix_SOW_Projects__c>();
            Set<Id> set_campaigns_to_delete = new Set<Id>();
            Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> map_original_id_splits_to_clone = new Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();
            List<Oblix_Marketing_SOW_Project_Splits__c> list_splits_to_clone = new List<Oblix_Marketing_SOW_Project_Splits__c>();

            Map<Id, Oblix_SOW_Projects__c> map_original_to_cloned_id = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string));

            for (Oblix_SOW_Projects__c campaign: map_original_to_cloned_id.values()){
                //Remove all the campaigns that have been completed
                if(campaign.Campaign_NFY__c != NULL && Integer.valueOf(campaign.Percentage_of_Fee_for_this_FY__c) == 100){
                    set_campaigns_to_delete.add(campaign.Campaign_NFY__c);
                    //Remove all the related hub splits
                    campaign.Marketing_SOW_Project_Splits__r.clear();
                }else {

                    Oblix_SOW_Projects__c cloned_campaign = campaign.clone(false, true, false, false);
                    // TEMP SET THE CLONED NAME
                    cloned_campaign.Name += 'CLONED';

                    // copy over the Progress Stage and box number to PFY
                    cloned_campaign.Campaign_PFY__c = campaign.Id;
                    cloned_campaign.Completed_Stage_PFY__c = campaign.Completed_Stage__c;
                    cloned_campaign.Projected_Stage_PFY__c = campaign.Projected_Stage__c;
                    cloned_campaign.Total_Project_Score_PFY__c = campaign.Total_Project_Score__c ;
                    cloned_campaign.Box_Number_PFY__c = campaign.Oblix_ProjectBoxNumber__c ;


                    list_campaigns_to_clone.add(cloned_campaign);
                }
                // get the project splits
                for (Oblix_Marketing_SOW_Project_Splits__c split: campaign.Marketing_SOW_Project_Splits__r){
                    
                    if (!map_original_id_splits_to_clone.containsKey(split.Project_Splits__c))
                        map_original_id_splits_to_clone.put(split.Project_Splits__c, new List<Oblix_Marketing_SOW_Project_Splits__c>());

                    Oblix_Marketing_SOW_Project_Splits__c cloned_split = split.clone(false, true, false, false);
                    map_original_id_splits_to_clone.get(split.Project_Splits__c).add(cloned_split);
                    
                }
            }

        }catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN initialSyncCampaign() - ', queryEx.getMessage() + ' - STACK TRACE: ' + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN initialSyncCampaign() - ', dmlEx.getMessage() + ' - STACK TRACE: ' + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN initialSyncCampaign() - ', ex.getMessage() + ' - STACK TRACE: ' + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  
    }


    /********************************************************************
    * @author       Execloud ©
    * @date         2014-07-11
    * @description  Clone SOW - normally called during intial approval
    				Sync SOW - when the user initiates the rollover process
    				this method needs to also populate Cloned_SOW and Original_SOW, SOW_PFY__c, SOW_NFY__c 
    				depending on the passed in job component attributes
    				look up fields to allow traceablity
    *********************************************************************/
	public static boolean cloneSOWs(Oblix_syncBatchJob.JobComponent job_component){

		Boolean is_success = true;
        try{


            //##########################################################################################
            //	query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            // clone sow:
            // 		attrib_1: Original_SOW__c
            // 		attrib_2: Cloned_SOW__c
            // 		attrib_3: JOB_STATUS_CLONE_IN_PROGRESS

			// initial sync:
            // 		attrib_1: SOW_PFY__c
            // 		attrib_2: SOW_NFY__c
            // 		attrib_3: JOB_STATUS_SYNC_IN_PROGRESS

            String query_string = 'SELECT ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Marketing_SOW__c'),',');
            query_string += ' FROM  Marketing_SOW__c WHERE Sync_Status__c =\'' + job_component.attrib_3 + '\' AND ' + job_component.attrib_2 + ' = NULL ORDER BY Id LIMIT ' + job_component.query_limit; 
            
            List<Marketing_SOW__c> list_sows_to_clone = new List<Marketing_SOW__c>();
            Map<Id, Marketing_SOW__c> map_original_to_cloned_id = new Map<Id,Marketing_SOW__c>((List<Marketing_SOW__c>)database.query(query_string));


            for (Marketing_SOW__c sow: map_original_to_cloned_id.values()){
        		

        		Marketing_SOW__c cloned_sow = sow.clone(false, true, false, false);
                // TEMP SET THE CLONED NAME
        		cloned_sow.Name += 'CLONED';

        		cloned_sow.put(job_component.attrib_1, sow.Id);
                //cloned_sow.Original_SOW__c = sow.Id;

                list_sows_to_clone.add(cloned_sow);
            }

            insert list_sows_to_clone;

			Set<Id> id_original_sows = map_original_to_cloned_id.keySet();
            String query_string2 = 'SELECT ' + job_component.attrib_1 + ', ' + job_component.attrib_2 + ' FROM Marketing_SOW__c WHERE ' + job_component.attrib_1 + 'in :id_original_sows ';
            // initial sync result: SELECT SOW_NFY__c, SOW_PFY__c FROM Oblix_Project_Assets__c WHERE SOW_PFY__c in: id_original_sows
            // clone sow  result: SELECT Cloned_SOW__c, Original_SOW__c FROM Oblix_SOW_Projects__c WHERE Original_SOW__c in: id_original_sows

            // update the original SOWs with the id of cloned SOWs
            for (Marketing_SOW__c sow: database.query(query_string2)){
            	//clon:	map_original_to_cloned_id.get(sow.Original_SOW__c).Cloned_SOW__c = sow.Id;
            	//sync: map_original_to_cloned_id.get(sow.SOW_PFY__c).NFY_SOW__c = sow.Id;
            	map_original_to_cloned_id.get(job_component.attrib_1).put(job_component.attrib_2,sow.Id);
            }

            update map_original_to_cloned_id.values();
            
        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneSOW() - ', queryEx.getMessage() + ' - STACK TRACE: ' + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneSOW() - ', dmlEx.getMessage() + ' - STACK TRACE: ' + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneSOW() - ', ex.getMessage() + ' - STACK TRACE: ' + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;   
		
	}

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  Need to clone the campaigns and add against the SOW of NFY 
    				this method could be called either during the initial approval phase
    				or when user initiates the rollover process
    				also set Original_Campaign, Cloned_Campaign, Campaign_PFY__c, Campaign_NFY__c fields
    ********************************************************************************/
	public static boolean cloneCampaigns(Oblix_syncBatchJob.JobComponent job_component){
		
		Boolean is_success = true;
        try{


            //##########################################################################################
            //	query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            // clone campaign:
            // 		attrib_1: Financial_Year__r.Original_SOW__c
            // 		attrib_2: Financial_Year__r.Cloned_SOW__c
            // 		attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            // 		attrib_4: Cloned_Campaign__c
            // 		attrib_5: Original_Campaign__c

			// initial sync:
            // 		attrib_1: Financial_Year__r.SOW_PFY__c
            // 		attrib_2: Financial_Year__r.SOW_NFY__c
            // 		attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            // 		attrib_4: Campaign_NFY__c
            // 		attrib_5: Campaign_PFY__c

            String query_string = 'SELECT ' + job_component.attrib_1 + ', ' +  job_component.attrib_2 + ', ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_SOW_Projects__c'),',');
            query_string += ', (SELECT ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string += ' FROM  Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c =\'' + job_component.attrib_3 + '\' AND ' + job_component.attrib_4 + ' = NULL ORDER BY Id LIMIT ' + job_component.query_limit; 
            

            List<Oblix_SOW_Projects__c> list_campaigns_to_clone = new List<Oblix_SOW_Projects__c>();
            Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> map_original_id_splits_to_clone = new Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();
            List<Oblix_Marketing_SOW_Project_Splits__c> list_splits_to_clone = new List<Oblix_Marketing_SOW_Project_Splits__c>();

            Map<Id, Oblix_SOW_Projects__c> map_original_to_cloned_id = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string));


            for (Oblix_SOW_Projects__c campaign: map_original_to_cloned_id.values()){
        		

        		Oblix_SOW_Projects__c cloned_campaign = campaign.clone(false, true, false, false);
                // TEMP SET THE CLONED NAME
        		cloned_campaign.Name += 'CLONED';
        		// set the parent of new campaign to be under the cloned sow (cloned/NFY)
        		cloned_campaign.Financial_Year__c = (Id) campaign.get(job_component.attrib_2);

        		cloned_campaign.put(job_component.attrib_5,campaign.Id);
                list_campaigns_to_clone.add(cloned_campaign);

                // get the project splits
                for (Oblix_Marketing_SOW_Project_Splits__c split: campaign.Marketing_SOW_Project_Splits__r){
                	
                	if (!map_original_id_splits_to_clone.containsKey(split.Project_Splits__c))
                		map_original_id_splits_to_clone.put(split.Project_Splits__c, new List<Oblix_Marketing_SOW_Project_Splits__c>());

                	Oblix_Marketing_SOW_Project_Splits__c cloned_split = split.clone(false, true, false, false);
                	map_original_id_splits_to_clone.get(split.Project_Splits__c).add(cloned_split);
                	
                }
            }

            insert list_campaigns_to_clone;

            Set<Id> id_original_campaigns = map_original_to_cloned_id.keySet();
            String query_string2 = 'SELECT ' + job_component.attrib_4 + ', ' + job_component.attrib_5 + ' FROM Oblix_SOW_Projects__c WHERE ' + job_component.attrib_5 + 'in :id_original_campaigns ';
            // initial sync result: SELECT Campaign_NFY__c, Campaign_PFY__c FROM Oblix_Project_Assets__c WHERE Campaign_PFY__c in: id_original_campaigns
            // clone campaign  result: SELECT Cloned_Campaign__c, Original_Campaign__c FROM Oblix_SOW_Projects__c WHERE Original_Campaign__c in: id_original_campaigns

            // update the original Campaigns with the id of cloned Campaigns
            for (Oblix_SOW_Projects__c campaign: database.query(query_string2)){
	 			// clone: 	map_original_to_cloned_id.get(campaign.Original_Campaign__c).Cloned_Campaign__c = campaign.Id;
	 			// sync: 	map_original_to_syncd_id.get(campaign.Campaign_PFY__c).Campaign_NFY__c = campaign.Id;

            	map_original_to_cloned_id.get(job_component.attrib_5).put(job_component.attrib_4, campaign.Id);

            	// adjust the parent Id of project split
            	if (NULL != map_original_id_splits_to_clone && map_original_id_splits_to_clone.containsKey(campaign.Original_Campaign__c) 
            		&& NULL!= map_original_id_splits_to_clone.get(campaign.Original_Campaign__c) && map_original_id_splits_to_clone.get(campaign.Original_Campaign__c).size()>0){

            		for (Oblix_Marketing_SOW_Project_Splits__c split_to_adjust: map_original_id_splits_to_clone.get(campaign.Original_Campaign__c)){
	            		split_to_adjust.Project_Splits__c = campaign.Id;
	            		list_splits_to_clone.add(split_to_adjust);
            		}
            	}
            }

            update map_original_to_cloned_id.values();

            // also clone the project splits
            if (!list_splits_to_clone.isEmpty()){
            	insert list_splits_to_clone;
            }



            
        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneCampaigns() - ', queryEx.getMessage() + ' - STACK TRACE: ' + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneCampaigns() - ', dmlEx.getMessage() + ' - STACK TRACE: ' + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneCampaigns() - ', ex.getMessage() + ' - STACK TRACE: ' + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  


	}


    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  Need to clone the assets and add against the Campaign
    				also set Original_Campaign and Cloned_Campaign Ids 
    ********************************************************************************/
	public static boolean cloneAssets(Oblix_syncBatchJob.JobComponent job_component){
		
		Boolean is_success = true;
        try{

            // clone assets:
            // 		attrib_1: Agency_Projects__r.Original_Campaign__c
            // 		attrib_2: Agency_Projects__r.Cloned_Campaign__c
            // 		attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            // 		attrib_4: Cloned_Asset__c
            // 		attrib_5: Original_Asset__c

			// initial sync:
            // 		attrib_1: Agency_Projects__r.Campaign_PFY__c
            // 		attrib_2: Agency_Projects__r.Campaign_NFY__c
            // 		attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            // 		attrib_4: Asset_NFY__c
            // 		attrib_5: Asset_PFY__c

            //##########################################################################################
            //	query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            String query_string = 'SELECT ' + job_component.attrib_1 + ', ' +  job_component.attrib_2 + ', ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Project_Assets__c'),',');
            query_string += ' FROM  Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =\'' + job_component.attrib_1 + '\' AND ' + job_component.attrib_4 + ' = NULL ORDER BY Id LIMIT ' + job_component.query_limit; 
            
            List<Oblix_Project_Assets__c> list_assets_to_clone = new List<Oblix_Project_Assets__c>();
            Map<Id, Oblix_Project_Assets__c> map_original_to_cloned_id = new Map<Id,Oblix_Project_Assets__c>((List<Oblix_Project_Assets__c>)database.query(query_string));


            for (Oblix_Project_Assets__c asset: map_original_to_cloned_id.values()){
        		

        		Oblix_Project_Assets__c cloned_asset = asset.clone(false, true, false, false);
        		cloned_asset.put(job_component.attrib_5,asset.Id);
        		// set the parent of new asset to be under the cloned campaign (cloned/NFY)
        		cloned_asset.Agency_Projects__c = (Id) asset.get(job_component.attrib_2);

                list_assets_to_clone.add(cloned_asset);
            }

            insert list_assets_to_clone;

            Set<Id> id_original_assets = map_original_to_cloned_id.keySet();
            String query_string2 = 'SELECT ' + job_component.attrib_4 + ', ' + job_component.attrib_5 + ' FROM Oblix_Project_Assets__c WHERE ' + job_component.attrib_5 + 'in :id_original_assets ';
            // initial sync result: SELECT Asset_NFY__c, Asset_PFY__c FROM Oblix_Project_Assets__c WHERE Asset_PFY__c in: id_original_assets
            // clone sow  result: SELECT Cloned_Asset__c, Original_Asset__c FROM Oblix_SOW_Projects__c WHERE Original_Asset__c in: id_original_assets

            // update the original SOWs with the id of cloned SOWs
            for (Oblix_Project_Assets__c asset: database.query(query_string2)){
            	//clon:	map_original_to_cloned_id.get(asset.Original_Asset__c).Cloned_Asset__c = asset.Id;
            	//sync: map_original_to_cloned_id.get(asset.Asset_PFY__c).Asset_NFY__c = asset.Id;
            	map_original_to_cloned_id.get(job_component.attrib_5).put(job_component.attrib_4,asset.Id);
            }

            update map_original_to_cloned_id.values();

        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAssets() - ', queryEx.getMessage() + ' - STACK TRACE: ' + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAssets() - ', dmlEx.getMessage() + ' - STACK TRACE: ' + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAssets() - ', ex.getMessage() + ' - STACK TRACE: ' + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  


	}


 //   /*******************************************************************************
 //   * @author       Execloud ©
 //   * @date         2016-04-25
 //   * @description  Need to sync the assets and add against the Campaign for NFY
 //   				also set NFY and PFY on the asset
 //   ********************************************************************************/
	//public static boolean syncAssets(Oblix_syncBatchJob.JobComponent job_component){
		
	//	Boolean is_success = true;
 //       try{


 //           //##########################################################################################
 //           //	query the correct records in scope, sync and add to list to insert
 //           //##########################################################################################

 //           String query_string = 'SELECT Agency_Projects__r.Campaign_PFY__c, Agency_Projects__r.Campaign_NFY__c, ';
 //           query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Project_Assets__c'),',');
 //           query_string += ' FROM  Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =\'' + job_component.attrib_1 + '\' AND Asset_NFY__c = NULL ORDER BY Id LIMIT ' + job_component.query_limit; 
            
 //           List<Oblix_Project_Assets__c> list_assets_to_sync = new List<Oblix_Project_Assets__c>();
 //           Map<Id, Oblix_Project_Assets__c> map_original_to_syncd_id = new Map<Id,Oblix_Project_Assets__c>((List<Oblix_Project_Assets__c>)database.query(query_string));


 //           for (Oblix_Project_Assets__c asset: map_original_to_syncd_id.values()){
        		

 //       		Oblix_Project_Assets__c sync_asset = asset.clone(false, true, false, false);
 //               sync_asset.Asset_PFY__c = asset.Id;
 //               sync_asset.Agency_Projects__c = asset.Agency_Projects__r.Campaign_NFY__c;

 //               list_assets_to_sync.add(sync_asset);
 //           }

 //           insert list_assets_to_sync;

 //           // update the original Assets with the id of syncd Assets
 //           for (Oblix_Project_Assets__c asset: [SELECT Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Asset_PFY__c in: map_original_to_syncd_id.keySet()]){
 //           	map_original_to_syncd_id.get(asset.Asset_PFY__c).Asset_NFY__c = asset.Id;
 //           }

 //           update map_original_to_syncd_id.values();


            
 //       }
 //       catch(QueryException queryEx){  
 //           Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', queryEx.getMessage() + ' - STACK TRACE: ' + queryEx.getStackTraceString());
 //           is_success = false;
 //       }
 //       catch(DmlException dmlEx){  
 //           Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', dmlEx.getMessage() + ' - STACK TRACE: ' + dmlEx.getStackTraceString());
 //           is_success = false;
 //       }
 //       catch(Exception ex){  
 //           Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', ex.getMessage() + ' - STACK TRACE: ' + ex.getStackTraceString());
 //           is_success = false;
 //       }
 //       return is_success;  


	//}



    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  For the selected SOWs create a clone of the record, adjust the sharings
    				and copy over the attachments
    ********************************************************************************/
	public static boolean cloneAttachments(Oblix_syncBatchJob.JobComponent job_component){

		Boolean is_success = true;
        try{

            //##########################################################################################
            //	query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            Set<Id> processed_ids = Oblix_SyncBatchJob.sync_job.processed_attachment_ids;

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneAttachments() - ' + processed_ids.size() + ' - processed_ids: ' + JSON.serialize(processed_ids),NULL);

            String query_string = 'SELECT ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Attachment'),',');
            query_string += ' FROM  Attachment WHERE ParentId in (SELECT id from Marketing_SOW__c WHERE Sync_Status__c =\'' + job_component.attrib_1 + '\') AND Id NOT in: processed_ids ORDER BY ParentId LIMIT ' + job_component.query_limit; 

            Map<Id,Marketing_SOW__c> map_original_to_cloned = new Map<Id, Marketing_SOW__c>((List<Marketing_SOW__c>)
            	([SELECT Original_SOW__c, Cloned_SOW__c FROM Marketing_SOW__c WHERE Sync_Status__c =: job_component.attrib_1 ORDER BY ID LIMIT: job_component.query_limit ]));


            List<Attachment> list_attachments_to_clone = new List<Attachment>();

            for (Attachment attch: database.query(query_string)){
        		

        		Attachment cloned_attc = attch.clone(false, true, false, false);
        		cloned_attc.ParentId = map_original_to_cloned.get(attch.ParentId).Cloned_SOW__c;

                list_attachments_to_clone.add(cloned_attc);

                // add id to processed collection to avoid reprocessing
                Oblix_SyncBatchJob.sync_job.processed_attachment_ids.add(attch.Id);

            }

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneAttachments() - ' + list_attachments_to_clone.size() + ' - list_attachments_to_clone: ' + JSON.serialize(list_attachments_to_clone),NULL);

            insert list_attachments_to_clone;
            
        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAttachments() - ', queryEx.getMessage() + ' - STACK TRACE: ' + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAttachments() - ', dmlEx.getMessage() + ' - STACK TRACE: ' + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAttachments() - ', ex.getMessage() + ' - STACK TRACE: ' + ex.getStackTraceString());
            is_success = false;
        }
        return is_success; 

	}

}