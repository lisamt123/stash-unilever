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

	public static final String STACK_TRACE = ' - STACK TRACE: ';

	public static final String SELECT_SOQL = 'SELECT ';


    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Decides which function to call depending on the process_name
                    passed in value
    *********************************************************************/
    public static void processStep(Oblix_syncBatchJob.JobComponent job_component){

    	system.debug('## process step: ' + job_component);
        
        Boolean is_success = true;

         // call the relevant job component method depeding on the attribute
        if (Oblix_Utils.JOB_PROCESS_SET_STATUS == job_component.process_name){
            is_success = adjustStatus(job_component);
        }
        else if(Oblix_Utils.JOB_PROCESS_CLONE_SOW == job_component.process_name){
            is_success = cloneSOWs(job_component);
        }
        else if(Oblix_Utils.JOB_PROCESS_CLONE_NON_CAMPAIGN == job_component.process_name){
            is_success = cloneNonCampaigns(job_component);
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
        else if(Oblix_Utils.JOB_PROCESS_SYNC_ADJUST_CAMPAIGN == job_component.process_name){
            is_success = syncCampaignDuringTransitionPeriod(job_component);
        }
        

        // update the batch job component with the status
        Oblix_SyncBatchJob.sync_job.job_has_error = !is_success;

    }

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Depending on the passed in object and attributes 
    				set the status of sObject from A to B
    *********************************************************************/
	public static boolean adjustStatus(Oblix_syncBatchJob.JobComponent job_component){
		// set the status of the given SOW/Campaigns/Assets

        Boolean is_success = true;
        try{

            // job component attribute list
            // 		attrib_1: initial status
            // 		attrib_2: status to be
            // 		attrib_3: sObject type
            // 		attrib_4: field to use for checking sync
            // 		attrib_5: field to use for locking campaign of next FY

            //##########################################################################################
            //	query the correct records in scope, set the status of the sync, add to list and update
            //##########################################################################################

            // queries examples:
            // 
            // when at parent sow level and setting children campaign statuses
            // 1) SELECT Sync_Status__c FROM Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c  = 'Sync In Prgoress' 
            //		AND Sync_Status__c <> 'Sync In Prgoress'  ORDER BY Id LIMIT 1000
            
            // when at individual campaign level
            // 2) SELECT Sync_Status__c FROM Marketing_SOW__c WHERE Sync_Status__c  = 'Sync Requested'
            //		AND Sync_Status__c <> 'Sync In Prgoress'  ORDER BY Id LIMIT 1000


            String query_string = 'SELECT Sync_Status__c FROM '+ job_component.attrib_3 +' WHERE '+ job_component.attrib_4 +' =\'' + job_component.attrib_1; 
        	query_string += '\' AND Sync_Status__c <> \'' + job_component.attrib_2 + '\' ORDER BY Id LIMIT ' + job_component.query_limit; 
            


            Map<Id, SObject> map_objects_update = new Map<Id, SObject>();
            Set<Id> set_original_ids = new Set<Id>();

            for (SObject obj: database.query(query_string)){
                obj.put('Sync_Status__c',job_component.attrib_2);
                map_objects_update.put(obj.Id, obj);
                set_original_ids.add(obj.Id);
            }

            Oblix_SyncBatchJob.addEvent(' adjust status query: ' + query_string + '\nResult size: ' + map_objects_update.size(),NULL);

            // when sync is in progress, also make sure that the records being synced are "locked" by setting the status to "In Progress"
            
            if (String.isNotBlank(job_component.attrib_5)){
	            String query_string2 = 'SELECT Sync_Status__c FROM '+ job_component.attrib_3 +' WHERE Sync_Status__c =\'' + job_component.attrib_1 
	            	+ '\' AND '+ job_component.attrib_5 +' in : set_original_ids AND Id NOT in: set_original_ids ' 
	            	+ ' ORDER BY Id LIMIT ' + job_component.query_limit; 
	            for (SObject obj: database.query(query_string)){
	                obj.put('Sync_Status__c',job_component.attrib_2);
                	map_objects_update.put(obj.Id, obj);
	            }
	        }

            update map_objects_update.values();
            
        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN adjustStatus() - ', queryEx.getMessage() + STACK_TRACE + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN adjustStatus() - ', dmlEx.getMessage() + STACK_TRACE + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN adjustStatus() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;   
	}


	private static void setSowNameSuffixAndFinancialYear(Marketing_SOW__c original_sow,Marketing_SOW__c cloned_sow, Oblix_syncBatchJob.JobComponent job_component){

		// stages
		// 1- when sow is created from scratch it has blank suffix
		
		// 'version control'
		// 2- it will then go through initial approval
		//	2.1- original_sow is (Approved) 
		//	2.2- cloned_sow - clone is (Live) 

		// 'initial sync'
		// 3- (Live) will then go through initiate rollover
		//	3.1- original_sow remains (Live) 
		//	3.2- cloned_sow - FY is incremented by +1 year - (Live)

		// 'taken care of by approval process
		// 4- (Live) will then go EOY approval
		//	4.1- original_sow is (Finalised) 
		//	4.2- cloned_sow remains (Live) 


		// 'version control2'
		// 4- (Live) will then go through initial approval
		//	4.1- original_sow is (Approved2) 
		//	4.2- cloned_sow - clone becomes (Live2) 

		if (Oblix_Utils.PROCESS_TYPE_INITIAL_APPROVAL == job_component.attrib_6){
			
			// this must be initial approval
			original_sow.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_APPROVED;
			cloned_sow.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_LIVE;
			cloned_sow.Initial_Approval_Complete__c = true;
		}
		else{
			// this must be initial rollover process
			Integer financial_year = Oblix_SOWHandlerLogic.getFinancialYear(original_sow);

			// increment financial year by +1 year
			financial_year ++;

			cloned_sow.Financial_Year__c = Oblix_Utils.FY_PREFIX + financial_year;
			cloned_sow.Initial_Approval_Complete__c = false;

		}

	} 


	private static void setCampaignNameSuffix(Oblix_SOW_Projects__c original_campaign,Oblix_SOW_Projects__c cloned_campaign, Oblix_syncBatchJob.JobComponent job_component){

		// stages
		// 1- when campaign is created from scratch it has blank suffix
		
		// 'version control'
		// 2- it will then go through initial approval
		//	2.1- original_campaign is (Approved) 
		//	2.2- cloned_campaign - clone is (Live) 

		// 'initial sync'
		// 3- (Live) will then go through initiate rollover
		//	3.1- original_campaign remains (Live) 
		//	3.2- cloned_campaign - clone is (B/Fwd) 

		// 'taken care of by a trigger/flow
		// 4- (Live) will then go EOY approval
		//	4.1- original_campaign is (Finalised) 
		//	4.2- cloned_campaign remains (B/Fwd) 


		// 'version control'
		// 4- (B/Fwd) will then go through initial approval
		//	4.1- original_campaign is (Approved2) 
		//	4.2- cloned_campaign - clone becomes (Live2) 

		if (Oblix_Utils.PROCESS_TYPE_INITIAL_APPROVAL == job_component.attrib_6){
			// this must be initial approval
			Integer cycle_number = NULL != original_campaign.Name_Suffix_Cycle_Number__c 
				? Integer.valueOf(original_campaign.Name_Suffix_Cycle_Number__c) + 1
				: 1;

			original_campaign.Name_Suffix_Cycle_Number__c = cycle_number;
			cloned_campaign.Name_Suffix_Cycle_Number__c = cycle_number;

			if (cycle_number > 1){
				original_campaign.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_APPROVED + cycle_number; 
				cloned_campaign.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_LIVE + cycle_number; 
			}
			else{
				original_campaign.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_APPROVED;
				cloned_campaign.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_LIVE;
			}

		}
		else{
			// this must be roll-over
			Integer cycle_number = Integer.valueOf(original_campaign.Name_Suffix_Cycle_Number__c);
			cloned_campaign.Name_Suffix_Cycle_Number__c = cycle_number;

			if (cycle_number > 1){
				cloned_campaign.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_BFW + cycle_number; 
			}
			else{
				cloned_campaign.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_BFW; 
			}
		}

	} 

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Set all the fields on campaign from PFY to NFY
    *********************************************************************/
	private static void setAllFieldsOnCampaignsRollOver(Oblix_SOW_Projects__c original_campaign, Oblix_SOW_Projects__c cloned_campaign
		, Map<String, Schema.SObjectField> map_name_and_field){

        // copy over all fields from PFY to NFY campaigns - unless excluded by the set
        Set<String> set_fields_to_exclude = new Set<String>{'Id', 'CreatedBy','CreatedDate','LastModifiedBy','LastModifiedDate'};
		
		for (String field_name : map_name_and_field.keySet()){	

            Schema.SObjectField sf = map_name_and_field.get(field_name);
            String field_type = String.valueOf(sf.getDescribe().getType()).toUpperCase();
            Boolean is_createable = sf.getDescribe().isCreateable();

            if (is_createable){

            	if ('STRING' == field_type || 'EMAIL' == field_type){
	        		cloned_campaign.put(field_name, (String) original_campaign.get(field_name));
            	}
            	else if('BOOLEAN' == field_type){
	        		cloned_campaign.put(field_name, (Boolean) original_campaign.get(field_name));
            	}
            	else if('DOUBLE' == field_type || 'CURRENCY' == field_type){
	        		cloned_campaign.put(field_name, (Decimal) original_campaign.get(field_name));
            	}
            	else if('INTEGER' == field_type){
	        		cloned_campaign.put(field_name, (Integer) original_campaign.get(field_name));
            	}
            	
            }
		}
	}


    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Set the financial fields on campaign from PFY to NFY
    *********************************************************************/
	private static void setFinancialFieldsOnCampaignsRollOver(Oblix_SOW_Projects__c original_campaign, Oblix_SOW_Projects__c cloned_campaign, Boolean is_new_clone){

        // copy over the Progress Stage and box number to PFY
        cloned_campaign.Campaign_PFY__c = original_campaign.Id;
        cloned_campaign.Completed_Stage_PFY__c = getUnionCurrentAndPastStages(original_campaign, 'Completed_Stage_CFY__c','Completed_Stage_PFY__c'); // original_campaign.Completed_Stage_CFY__c;
        cloned_campaign.Projected_Stage_PFY__c = getUnionCurrentAndPastStages(original_campaign, 'Projected_Stage_CFY__c','Projected_Stage_PFY__c'); //original_campaign.Projected_Stage_CFY__c;
        cloned_campaign.Total_Project_Score_PFY__c = original_campaign.Total_Project_Score__c ;
        
        if (is_new_clone){
	        // select all projected stages by default when initiating rollover process
        	cloned_campaign.Projected_Stage_CFY__c = Oblix_Utils.CAMPAIGN_STAGES_ALL;
        }
        // set the remaining value for this FY
        cloned_campaign.Percentage_of_Fee_for_this_FY__c = 100 - original_campaign.Percentage_of_Fees_PFY__c;

        cloned_campaign.Box_Number_PFY__c = original_campaign.Oblix_ProjectBoxNumber__c ;
	}

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  To maintain the logic for chevron, we need to combine the 
    				stages from CFY and PFY and stamp on PFY field of the following
    				financial year campaign - this is done for both completed and projected stage
    *********************************************************************/
	public static String getUnionCurrentAndPastStages(Oblix_SOW_Projects__c original_campaign, String cfy_field, String pfy_field){
		
		Set<String> set_union = new Set<String>();
		String union_stages = '';
		List<String> list_stages_retrieved = new List<String>();
		String separator = ';';

		String result = '';

		String current_stages = (String) original_campaign.get(cfy_field);
		result += '\ncurrent_stages: ' + current_stages;

		// get completed current_stages for this year
		if (String.isNotBlank(current_stages)){

			list_stages_retrieved = current_stages.split(separator);
			result += '\nlist_stages_retrieved: ' + JSON.serialize(list_stages_retrieved);

			for (String stage_name: list_stages_retrieved){
				result += '\nstage_name: ' + stage_name;
				set_union.add(stage_name);
			}
		}

		String past_stages = (String) original_campaign.get(pfy_field);
		result += '\npast_stages: ' + past_stages;
		// get completed stages for last year
		if (String.isNotBlank(past_stages)){

			list_stages_retrieved = past_stages.split(separator);
			result += '\nlist_stages_retrieved: ' + JSON.serialize(list_stages_retrieved);

			for (String stage_name: list_stages_retrieved){
				result += '\nstage_name: ' + stage_name;
				set_union.add(stage_name);
			}
		}

		// copy to a list to allow building ';' separated string
		List<String> list_union_stages = new List<String>(); 
		list_union_stages.addAll(set_union);
		
		result += '\nlist_union_stages: ' + JSON.serialize(list_union_stages);

		if (!list_union_stages.isEmpty()){
			// build the semi-colon separated values to re-assign
			union_stages = String.join(list_union_stages, separator);
		}
		result += '\nunion_stages: ' + union_stages;
		system.debug(result);
		return union_stages;

	}

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
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
			//Oblix_SyncBatchJob.addEvent(' Campaign to clone size: ' + list_campaigns_to_clone.size(),NULL);

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Marketing_SOW__c'),',');
            query_string += ' FROM  Marketing_SOW__c WHERE Sync_Status__c =\'' + job_component.attrib_3 + '\' AND ' + job_component.attrib_2 + ' = NULL ORDER BY Id LIMIT ' + job_component.query_limit; 
            
            List<Marketing_SOW__c> list_sows_to_clone = new List<Marketing_SOW__c>();
            Map<Id, Marketing_SOW__c> map_original_id_original_campaign = new Map<Id,Marketing_SOW__c>((List<Marketing_SOW__c>)database.query(query_string));

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneSOW(): ' + map_original_id_original_campaign.size(), NULL);

            for (Marketing_SOW__c sow: map_original_id_original_campaign.values()){
        		
            	//Oblix_SyncBatchJob.addEvent('INFO IN looping sow(): ' + JSON.serialize(sow), NULL);

        		Marketing_SOW__c cloned_sow = sow.clone(false, true, false, false);
                
                setSowNameSuffixAndFinancialYear(sow, cloned_sow,job_component);

        		cloned_sow.put(job_component.attrib_1, sow.Id);
                //cloned_sow.Original_SOW__c = sow.Id;


                // only original SOW should have clone in progress
                // the new record can be unlocked
                cloned_sow.Sync_Status__c = NULL;
                list_sows_to_clone.add(cloned_sow);
            }
        	//Oblix_SyncBatchJob.addEvent('INFO IN list_sows_to_clone: ' + JSON.serialize(list_sows_to_clone), NULL);

            insert list_sows_to_clone;

			Set<Id> id_original_sows = map_original_id_original_campaign.keySet();
            String query_string2 = SELECT_SOQL + job_component.attrib_1 + ', ' + job_component.attrib_2 + ' FROM Marketing_SOW__c WHERE ' + job_component.attrib_1 + ' in :id_original_sows ';
            // initial sync result: SELECT SOW_NFY__c, SOW_PFY__c FROM Oblix_Project_Assets__c WHERE SOW_PFY__c in: id_original_sows
            // clone sow  result: SELECT Cloned_SOW__c, Original_SOW__c FROM Oblix_SOW_Projects__c WHERE Original_SOW__c in: id_original_sows

            // update the original SOWs with the id of cloned SOWs
            for (Marketing_SOW__c sow: database.query(query_string2)){
            	//clon:	map_original_id_original_campaign.get(sow.Original_SOW__c).Cloned_SOW__c = sow.Id;
            	//sync: map_original_id_original_campaign.get(sow.SOW_PFY__c).NFY_SOW__c = sow.Id;
            	map_original_id_original_campaign.get((Id) sow.get(job_component.attrib_1)).put(job_component.attrib_2,sow.Id);
            }

            update map_original_id_original_campaign.values();
            
        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneSOW() - ', queryEx.getMessage() + STACK_TRACE + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneSOW() - ', dmlEx.getMessage() + STACK_TRACE + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneSOW() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
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
            // 		attrib_1: Original_SOW__c
            // 		attrib_2: Cloned_SOW__c
            // 		attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            // 		attrib_4: Cloned_Campaign__c
            // 		attrib_5: Original_Campaign__c

			// initial sync:
            // 		attrib_1: SOW_PFY__c
            // 		attrib_2: SOW_NFY__c
            // 		attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            // 		attrib_4: Campaign_NFY__c
            // 		attrib_5: Campaign_PFY__c

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_SOW_Projects__c'),',');
            query_string += ', (SELECT ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string += ' FROM  Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c =\'' + job_component.attrib_3 + '\' AND ' + job_component.attrib_4 + ' = NULL ORDER BY Id LIMIT ' + job_component.query_limit; 
            

            List<Oblix_SOW_Projects__c> list_campaigns_to_clone = new List<Oblix_SOW_Projects__c>();
            Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> map_original_id_splits_to_clone = new Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();
            List<Oblix_Marketing_SOW_Project_Splits__c> list_splits_to_clone = new List<Oblix_Marketing_SOW_Project_Splits__c>();

            Map<Id, Oblix_SOW_Projects__c> map_original_id_original_campaign = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string));


            for (Oblix_SOW_Projects__c campaign: map_original_id_original_campaign.values()){
        		

        		Oblix_SOW_Projects__c cloned_campaign = campaign.clone(false, true, false, false);
                // TEMP SET THE CLONED NAME
        		//cloned_campaign.Name += 'CLONED';
        		// set the parent of new campaign to be under the cloned sow (cloned/NFY)
        		cloned_campaign.Financial_Year__c = (Id) campaign.get(job_component.attrib_2);
				
	            // set campaign suffix
	            setCampaignNameSuffix(campaign,cloned_campaign, job_component);

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

			Oblix_SyncBatchJob.addEvent(' Campaign to clone size: ' + list_campaigns_to_clone.size(),NULL);
			Oblix_SyncBatchJob.addEvent(' original size: ' + map_original_id_original_campaign.size(),NULL);


			Oblix_SyncBatchJob.addEvent(' JSON to clone: ' + JSON.serialize(list_campaigns_to_clone),NULL);
			Oblix_SyncBatchJob.addEvent(' JSON original: ' + JSON.serialize(map_original_id_original_campaign),NULL);


            insert list_campaigns_to_clone;

            //Set<Id> id_original_campaigns = map_original_id_original_campaign.keySet();
            //String query_string2 = SELECT_SOQL + job_component.attrib_4 + ', ' + job_component.attrib_5 + ' FROM Oblix_SOW_Projects__c WHERE ' + job_component.attrib_5 + ' in :id_original_campaigns ';
            // initial sync result: SELECT Campaign_NFY__c, Campaign_PFY__c FROM Oblix_Project_Assets__c WHERE Campaign_PFY__c in: id_original_campaigns
            // clone campaign  result: SELECT Cloned_Campaign__c, Original_Campaign__c FROM Oblix_SOW_Projects__c WHERE Original_Campaign__c in: id_original_campaigns


            // update the original Campaigns with the id of cloned Campaigns and set the id on hub split records
            populateClonedRecordsWithIds(job_component.attrib_4,job_component.attrib_5,map_original_id_splits_to_clone, map_original_id_original_campaign,list_splits_to_clone);

			//for (Oblix_SOW_Projects__c campaign: database.query(query_string2)){
			//		// clone: 	map_original_id_original_campaign.get(campaign.Original_Campaign__c).Cloned_Campaign__c = campaign.Id;
			//		// sync: 	map_original_to_syncd_id.get(campaign.Campaign_PFY__c).Campaign_NFY__c = campaign.Id;

			//	map_original_id_original_campaign.get(job_component.attrib_5).put(job_component.attrib_4, campaign.Id);

			//	// adjust the parent Id of project split
			//	if (NULL != map_original_id_splits_to_clone && map_original_id_splits_to_clone.containsKey(campaign.Original_Campaign__c) 
			//		&& NULL!= map_original_id_splits_to_clone.get(campaign.Original_Campaign__c) && map_original_id_splits_to_clone.get(campaign.Original_Campaign__c).size()>0){

			//		for (Oblix_Marketing_SOW_Project_Splits__c split_to_adjust: map_original_id_splits_to_clone.get(campaign.Original_Campaign__c)){
			//    		split_to_adjust.Project_Splits__c = campaign.Id;
			//    		list_splits_to_clone.add(split_to_adjust);
			//		}
			//	}
			//}

            update map_original_id_original_campaign.values();

            // also clone the project splits
            if (!list_splits_to_clone.isEmpty()){
            	insert list_splits_to_clone;
            }

        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneCampaigns() - ', queryEx.getMessage() + STACK_TRACE + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneCampaigns() - ', dmlEx.getMessage() + STACK_TRACE + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneCampaigns() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  


	}

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Set the lookup fields for original and related hub and splits
    *********************************************************************/
	private static void populateClonedRecordsWithIds(String clone_nfy_field, String original_pfy_field 
		,Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> map_original_id_splits_to_clone, Map<Id, Oblix_SOW_Projects__c> map_original_id_original_campaign
		,List<Oblix_Marketing_SOW_Project_Splits__c> list_splits_to_clone){

		Set<Id> id_original_campaigns = map_original_id_original_campaign.keySet();
        String query_string = SELECT_SOQL + clone_nfy_field + ', ' + original_pfy_field + ' FROM Oblix_SOW_Projects__c WHERE ' + original_pfy_field + ' in :id_original_campaigns ';
            
        // update the original Campaigns with the id of cloned Campaigns
        for (Oblix_SOW_Projects__c campaign: database.query(query_string)){
 			// clone: 	map_original_id_original_campaign.get(campaign.Original_Campaign__c).Cloned_Campaign__c = campaign.Id;
 			// sync: 	map_original_to_syncd_id.get(campaign.Campaign_PFY__c).Campaign_NFY__c = campaign.Id;

 			Id original_id = (Id) campaign.get(original_pfy_field);

        	map_original_id_original_campaign.get((Id) campaign.get(original_pfy_field)).put(clone_nfy_field, campaign.Id);

        	// adjust the parent Id of project split
        	if (NULL != map_original_id_splits_to_clone && map_original_id_splits_to_clone.containsKey(original_id) 
        		&& NULL!= map_original_id_splits_to_clone.get(original_id) && map_original_id_splits_to_clone.get(original_id).size()>0){

        		for (Oblix_Marketing_SOW_Project_Splits__c split_to_adjust: map_original_id_splits_to_clone.get(original_id)){
            		split_to_adjust.Project_Splits__c = campaign.Id;
            		list_splits_to_clone.add(split_to_adjust);
        		}
        	}
        }

	}

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Sync Campaign 
			        - Adjust attributes for Campaigns from Orig-NFY - delete and recreate Hub&Splits - if required -
			        - copy over the calculator fees and box number to PFY
			        - copy the chevron box info to NFY
			        - If the % complete is equal 100% then need to delete the NFY related campaign

    *********************************************************************/
	public static boolean syncCampaignDuringTransitionPeriod(Oblix_syncBatchJob.JobComponent job_component){

  
        Boolean is_success = true;
        
        try{

        	String result_msg = '';

            //##########################################################################################
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################
			// initial sync:
            // 		attrib_1: SOW_NFY__c
            // 		attrib_2: CAMPAIGN_PFY__c
            // 		attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            // 		attrib_4: 
            // 		attrib_5: 
            // 		attrib_6: Type of process
            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_SOW_Projects__c'),',');
            query_string += ', (SELECT Project_Splits__r.Campaign_NFY__c, ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string += ' FROM  Oblix_SOW_Projects__c WHERE Sync_Status__c = \'' + job_component.attrib_3 + '\' ORDER BY Id LIMIT ' + job_component.query_limit; 
            
            // AND Campaign_NFY__c = NULL OR (Campaign_NFY__c != NULL AND Percentage_of_Fee_for_this_FY__c == 100.00) 

            // get the matching cloned campaigns to perform the sync

            result_msg += '\n query1: ' + query_string;
            
            Map<Id, Oblix_SOW_Projects__c> map_original_ids_to_original = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string));
            Set<Id> set_original_ids = map_original_ids_to_original.keySet();

            result_msg += '\n query1 result rows: ' + set_original_ids.size();

            String query_string2 = SELECT_SOQL;
            query_string2 += String.join(Oblix_Utils.getfieldsByObject('Oblix_SOW_Projects__c'),',');
            query_string2 += ', (SELECT Project_Splits__r.Campaign_NFY__c, ';
            query_string2 += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string2 += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string2 += ' FROM  Oblix_SOW_Projects__c WHERE Campaign_PFY__c in : set_original_ids ORDER BY Id LIMIT ' + job_component.query_limit; 
            
            result_msg += '\n query2: ' + query_string2;

            Map<Id, Oblix_SOW_Projects__c> map_original_ids_to_cloned = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string2));

            result_msg += '\n query2 result rows: ' + map_original_ids_to_cloned.size();

            // scenarios:
            //	1- PFY campaign is newly created: create a clone of the for the NFY
            //	2- PFY % projected is increased to 100% therefore need to remove from NFY 
            //	3- PFY and NFY are created but require syncing

            Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_delete = new Map<Id, Oblix_SOW_Projects__c>();
            Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_update = new Map<Id,Oblix_SOW_Projects__c>();
            List<Oblix_SOW_Projects__c> list_campaigns_to_clone = new List<Oblix_SOW_Projects__c>();
			Map<Id, Oblix_SOW_Projects__c> map_original_id_original_campaign = new Map<Id,Oblix_SOW_Projects__c>();

			// this map is used to copy over values from original to cloned campaigns
			Map<String, Schema.SObjectField> map_name_and_field = Oblix_Utils.fetchAllFieldsForObject('Oblix_SOW_Projects__c');

            Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> map_original_id_splits_to_clone = new Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();

            // also need to sync all related non-campaign records
            List<Oblix_Marketing_SOW_Project_Splits__c> list_splits_to_clone = new List<Oblix_Marketing_SOW_Project_Splits__c>();
			Map<Id,Oblix_Marketing_SOW_Project_Splits__c> map_splits_to_delete = new Map<Id, Oblix_Marketing_SOW_Project_Splits__c>();



            for (Oblix_SOW_Projects__c campaign: map_original_ids_to_original.values()){
            	result_msg += '\n\n\n **** campaign.Percentage_of_Fee_for_this_FY__c: ' + campaign.Percentage_of_Fee_for_this_FY__c 
            		+ ' - campaign.Campaign_Status__c: ' + campaign.Campaign_Status__c + ' - campaign: ' + JSON.serialize(campaign);
                
                if(!map_original_ids_to_cloned.containsKey(campaign.id)
                	&& 
                	(Integer.valueOf(campaign.Percentage_of_Fee_for_this_FY__c) < 100 && Oblix_Utils.CAMPAIGN_STATUS_CANCELLED != campaign.Campaign_Status__c)){
	            	//	1- PFY campaign is newly created: create a clone of the for the NFY - if campaign is not cancelled and % is less than 100
                    
                    Oblix_SOW_Projects__c cloned_campaign = campaign.clone(false, true, false, false);
                    
					map_original_id_original_campaign.put(campaign.Id, campaign);

					// copy over the financial related fields from current_campaign to next_financial_year PFY fields
					setFinancialFieldsOnCampaignsRollOver(campaign, cloned_campaign,true);

					// manage the hub and splits
					syncHubAndSplits(campaign, NULL, map_splits_to_delete, map_original_id_splits_to_clone);


        			cloned_campaign.put(job_component.attrib_2,campaign.Id);

		            // set campaign suffix
		            setCampaignNameSuffix(campaign,cloned_campaign, job_component);

		            // reparent new campaign
        			cloned_campaign.Financial_Year__c = (Id) campaign.get(job_component.attrib_1);
					// need to insert these
					list_campaigns_to_clone.add(cloned_campaign);
            		
            		result_msg += '\n\n\n to clone: ' + cloned_campaign.name;

				}
				else if(
					(100 == Integer.valueOf(campaign.Percentage_of_Fee_for_this_FY__c) || Oblix_Utils.CAMPAIGN_STATUS_CANCELLED == campaign.Campaign_Status__c)
					&&
					(NULL != map_original_ids_to_cloned && map_original_ids_to_cloned.containsKey(campaign.id))
					){
		            //	2- PFY % projected is increased to 100% or campaign got cancelled therefore need to remove from NFY 
                    
                    // remove the link from the original campaign
                    campaign.Campaign_NFY__c = NULL;
                    map_campaigns_to_update.put(campaign.Id, campaign);

                    // add the cloned campaign to a collection to delete
                    if (map_original_ids_to_cloned.containsKey(campaign.Id)){
                    	map_campaigns_to_delete.put(campaign.Campaign_NFY__c, map_original_ids_to_cloned.get(campaign.Id));
            			
            			result_msg += '\n\n\n to delete: ' + map_original_ids_to_cloned.get(campaign.Id).name;
                    
                    }

				}
				else if(NULL != map_original_ids_to_cloned && map_original_ids_to_cloned.containsKey(campaign.id)){
		            //	3- PFY and NFY are created but require syncing

		            Oblix_SOW_Projects__c cloned_campaign = map_original_ids_to_cloned.get(campaign.id);


					map_original_id_original_campaign.put(campaign.Id, campaign);

		            // sync all existing fields from CFY to NFY
		            setAllFieldsOnCampaignsRollOver(campaign, cloned_campaign,map_name_and_field);

					// copy over the financial related fields from current_campaign to next_financial_year PFY fields
					setFinancialFieldsOnCampaignsRollOver(campaign, cloned_campaign,false);

					// manage the hub and splits
					syncHubAndSplits(campaign, cloned_campaign, map_splits_to_delete, map_original_id_splits_to_clone);

		            // set campaign suffix
		            setCampaignNameSuffix(campaign,cloned_campaign, job_component);

                    map_campaigns_to_update.put(cloned_campaign.Id, cloned_campaign);
        			
        			result_msg += '\n\n\n to update: ' + cloned_campaign.name;

				}

            }

            // insert new campaigns
            if (!list_campaigns_to_clone.isEmpty()){
            	insert list_campaigns_to_clone;
            }


            // update the original Campaigns with the id of cloned Campaigns and set the id on hub split records
            populateClonedRecordsWithIds('Campaign_NFY__c','Campaign_PFY__c',map_original_id_splits_to_clone, map_original_id_original_campaign,list_splits_to_clone);

			result_msg += '\n\n\n to update: ' + map_campaigns_to_update.size() + ' - to clone: ' + list_campaigns_to_clone.size() 
				+ ' - to delete: ' + map_campaigns_to_delete.size() + ' - splits to delete: ' + map_splits_to_delete.size()
				+ ' - map_original_id_splits_to_clone: ' + map_original_id_splits_to_clone.size()
				+ ' - splits to insert: ' + list_splits_to_clone.size();

            // delete the cloned campaigns which are 100%
            if (!map_campaigns_to_delete.isEmpty()){
            	delete map_campaigns_to_delete.values();
            }

            // update the original campaigns NFY fields
            if (!map_original_id_original_campaign.isEmpty()){
            	update map_original_id_original_campaign.values();
            }

            // update existing campaigns
            if (!map_campaigns_to_update.isEmpty()){
            	update map_campaigns_to_update.values();
            }

            // delete old hub and splits
            if (!map_splits_to_delete.isEmpty()){
            	delete map_splits_to_delete.values();
            }

            // insert new hub and splits
            if (!list_splits_to_clone.isEmpty()){
            	insert list_splits_to_clone;
            }

			Oblix_SyncBatchJob.addEvent('DEBUG IN syncCampaignDuringTransitionPeriod() - result_msg: ' + result_msg,NULL);


        }catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN syncCampaignDuringTransitionPeriod() - ', queryEx.getMessage() + STACK_TRACE + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN syncCampaignDuringTransitionPeriod() - ', dmlEx.getMessage() + STACK_TRACE + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN syncCampaignDuringTransitionPeriod() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  
    }


    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  To keep project splits in sync between 2 FYs, we simply
    				delete cloned splits from NFY, clone original splits and
    				copy under NFY
    *********************************************************************/
	private static void syncHubAndSplits(Oblix_SOW_Projects__c original_campaign, Oblix_SOW_Projects__c cloned_campaign
		, Map<Id,Oblix_Marketing_SOW_Project_Splits__c> map_splits_to_delete, Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> map_original_id_splits_to_clone){

		if (NULL != cloned_campaign && cloned_campaign.Marketing_SOW_Project_Splits__r.size() >0){
	        // delete the old project splits
	        for (Oblix_Marketing_SOW_Project_Splits__c cloned_split: cloned_campaign.Marketing_SOW_Project_Splits__r){
	            
	            map_splits_to_delete.put(cloned_split.Id, cloned_split);
	        }
		}
			
		// clone the original project splits		
        for (Oblix_Marketing_SOW_Project_Splits__c original_split: original_campaign.Marketing_SOW_Project_Splits__r){
            

            if (!map_original_id_splits_to_clone.containsKey(original_split.Project_Splits__c)){
        		map_original_id_splits_to_clone.put(original_split.Project_Splits__c, new List<Oblix_Marketing_SOW_Project_Splits__c>());
        	}        
        	
        	Oblix_Marketing_SOW_Project_Splits__c cloned_split = original_split.clone(false, true, false, false);
        	map_original_id_splits_to_clone.get(original_split.Project_Splits__c).add(cloned_split);

        	if (NULL != original_split.Project_Splits__r.Campaign_NFY__c){
	            // set the parent of campaign under NFY if the lookup is populated - in case of existing records
	            cloned_split.Project_Splits__c = original_split.Project_Splits__r.Campaign_NFY__c;
	        }
        }  

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
            // 		attrib_1: Original_Campaign__c
            // 		attrib_2: Cloned_Campaign__c
            // 		attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            // 		attrib_4: Cloned_Asset__c
            // 		attrib_5: Original_Asset__c

			// initial sync:
            // 		attrib_1: Campaign_PFY__c
            // 		attrib_2: Campaign_NFY__c
            // 		attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            // 		attrib_4: Asset_NFY__c
            // 		attrib_5: Asset_PFY__c

            //##########################################################################################
            //	query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            String result_msg ='';

			result_msg += '\n\n\n started clonning assets';

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Project_Assets__c'),',');
            query_string += ' FROM  Oblix_Project_Assets__c WHERE Agency_Projects__r.Sync_Status__c =\'' + job_component.attrib_3 + '\' AND ' + job_component.attrib_4 + ' = NULL '; 
            query_string += ' AND ' + job_component.attrib_2 + ' <> NULL ORDER BY Id LIMIT ' + job_component.query_limit; 

			result_msg += '\n\n\n query_string: ' + query_string;

            List<Oblix_Project_Assets__c> list_assets_to_clone = new List<Oblix_Project_Assets__c>();
            Map<Id, Oblix_Project_Assets__c> map_original_id_original_campaign = new Map<Id,Oblix_Project_Assets__c>((List<Oblix_Project_Assets__c>)database.query(query_string));


            for (Oblix_Project_Assets__c asset: map_original_id_original_campaign.values()){
        		

        		Oblix_Project_Assets__c cloned_asset = asset.clone(false, true, false, false);
        		cloned_asset.put(job_component.attrib_5,asset.Id);
        		// set the parent of new asset to be under the cloned campaign (cloned/NFY)
        		cloned_asset.Agency_Projects__c = (Id) asset.get(job_component.attrib_2);
        		cloned_asset.Campaign_ID__c = (String) asset.get(job_component.attrib_2);
                list_assets_to_clone.add(cloned_asset);
            }

			result_msg += '\n\n\n map_original_id_original_campaign.size(): ' + map_original_id_original_campaign.size();
			result_msg += '\n\n\n map_original_id_original_campaign: ' + JSON.serialize(map_original_id_original_campaign);
			result_msg += '\n\n\n list_assets_to_clone.size(): ' + list_assets_to_clone.size();
			result_msg += '\n\n\n list_assets_to_clone: ' + JSON.serialize(list_assets_to_clone);

			Oblix_SyncBatchJob.addEvent('DEBUG IN cloneAssets() - result_msg: ' + result_msg,NULL);

            insert list_assets_to_clone;

            Set<Id> id_original_assets = map_original_id_original_campaign.keySet();
            String query_string2 = SELECT_SOQL + job_component.attrib_4 + ', ' + job_component.attrib_5 + ' FROM Oblix_Project_Assets__c WHERE ' + job_component.attrib_5 + ' in :id_original_assets ';
            // initial sync result: SELECT Asset_NFY__c, Asset_PFY__c FROM Oblix_Project_Assets__c WHERE Asset_PFY__c in: id_original_assets
            // clone sow  result: SELECT Cloned_Asset__c, Original_Asset__c FROM Oblix_SOW_Projects__c WHERE Original_Asset__c in: id_original_assets

            // update the original SOWs with the id of cloned SOWs
            for (Oblix_Project_Assets__c asset: database.query(query_string2)){
            	//clon:	map_original_id_original_campaign.get(asset.Original_Asset__c).Cloned_Asset__c = asset.Id;
            	//sync: map_original_id_original_campaign.get(asset.Asset_PFY__c).Asset_NFY__c = asset.Id;
            	map_original_id_original_campaign.get((Id) asset.get(job_component.attrib_5)).put(job_component.attrib_4,asset.Id);
            }

            update map_original_id_original_campaign.values();

        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAssets() - ', queryEx.getMessage() + STACK_TRACE + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAssets() - ', dmlEx.getMessage() + STACK_TRACE + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAssets() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
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
	//public static boolean syncAssetsDuringTransitionPeriod(Oblix_syncBatchJob.JobComponent job_component){
		
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
 //           Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', queryEx.getMessage() + STACK_TRACE + queryEx.getStackTraceString());
 //           is_success = false;
 //       }
 //       catch(DmlException dmlEx){  
 //           Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', dmlEx.getMessage() + STACK_TRACE + dmlEx.getStackTraceString());
 //           is_success = false;
 //       }
 //       catch(Exception ex){  
 //           Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
 //           is_success = false;
 //       }
 //       return is_success;  


	//}


	private Static String buildNewNonCampaignKey(Marketing_Basics__c non_camp_to_adjust){

		String new_key = '';
		// check the key make sure it has min 18 char then replace the first 18 chars with the id of the new parent
		// e.g. <start>a6KM00000008RceMAE<end>Brand BookAustriaCreativeCopywriter
		if (String.isNotEmpty(non_camp_to_adjust.Non_Campaign_Key__c) && non_camp_to_adjust.Non_Campaign_Key__c.length() > 18){

			new_key =  String.valueOf(non_camp_to_adjust.Oblix_SOWMarketing__c) + non_camp_to_adjust.Non_Campaign_Key__c.substring(18);
		}
		return new_key;
	}


    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-05-07
    * @description  For the selected SOWs copy over the non-campaigns to the bew
    				SOW
    ********************************************************************************/
	public static boolean cloneNonCampaigns(Oblix_syncBatchJob.JobComponent job_component){

		Boolean is_success = true;
        try{

            //##########################################################################################
            //	query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            Set<Id> processed_ids = Oblix_SyncBatchJob.sync_job.processed_non_campaign_ids;

            Oblix_SyncBatchJob.addEvent('INFO IN cloneNonCampaigns() - ' + processed_ids.size() + ' - processed_ids: ' + JSON.serialize(processed_ids),NULL);

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Marketing_Basics__c'),',');
            query_string += ' FROM  Marketing_Basics__c WHERE Oblix_SOWMarketing__r.Sync_Status__c =\'' + job_component.attrib_1 + '\' AND Id NOT in: processed_ids ORDER BY Id LIMIT ' + job_component.query_limit; 

            Oblix_SyncBatchJob.addEvent('INFO IN cloneNonCampaigns - query_string: ' + query_string,NULL);
            system.debug(Oblix_SyncBatchJob.sync_job.process_result);

            
            Map<Id, Marketing_Basics__c> map_non_campaigns_to_clone = new Map<Id, Marketing_Basics__c>();
            Set<Id> set_cloned_parent_id = new Set<Id>();

            for (Marketing_Basics__c non_camp: Database.query(query_string)){
            	map_non_campaigns_to_clone.put(non_camp.Id, non_camp);
            	set_cloned_parent_id.add(non_camp.Oblix_SOWMarketing__c);
            }


            // get the parent SOW and the cloned SOW to allow setting correct parents
            Map<Id,Marketing_SOW__c> map_original_to_cloned = new Map<Id, Marketing_SOW__c>((List<Marketing_SOW__c>)
            	([SELECT Original_SOW__c, Cloned_SOW__c FROM Marketing_SOW__c WHERE Id in: set_cloned_parent_id ]));

            List<Marketing_Basics__c> list_non_campaigns_to_clone = new List<Marketing_Basics__c>();

            for (Marketing_Basics__c non_camp: map_non_campaigns_to_clone.values()){
        		

        		Marketing_Basics__c cloned_non_camp = non_camp.clone(false, true, false, false);
        		cloned_non_camp.Oblix_SOWMarketing__c = map_original_to_cloned.get(non_camp.Oblix_SOWMarketing__c).Cloned_SOW__c;

        		// set the new key for the non campaign
        		cloned_non_camp.Non_Campaign_Key__c = buildNewNonCampaignKey(cloned_non_camp);
                list_non_campaigns_to_clone.add(cloned_non_camp);

                // add id to processed collection to avoid reprocessing
                Oblix_SyncBatchJob.sync_job.processed_non_campaign_ids.add(non_camp.Id);

            }

            Oblix_SyncBatchJob.addEvent('INFO IN cloneNonCampaigns() - ' + list_non_campaigns_to_clone.size() + ' - list_non_campaigns_to_clone: ' + JSON.serialize(list_non_campaigns_to_clone),NULL);

            insert list_non_campaigns_to_clone;
            
        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneNonCampaigns() - ', queryEx.getMessage() + STACK_TRACE + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneNonCampaigns() - ', dmlEx.getMessage() + STACK_TRACE + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneNonCampaigns() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success; 

	}


    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  For the selected SOWs copy over the attachments to the new SOW
    ********************************************************************************/
	public static boolean cloneAttachments(Oblix_syncBatchJob.JobComponent job_component){

		Boolean is_success = true;
        try{

            // clone sow:
            // 		attrib_1: Original_SOW__c
            // 		attrib_2: Cloned_SOW__c
            // 		attrib_3: JOB_STATUS_CLONE_IN_PROGRESS

			// initial sync:
            // 		attrib_1: SOW_PFY__c
            // 		attrib_2: SOW_NFY__c
            // 		attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //##########################################################################################
            //	query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            Set<Id> processed_ids = Oblix_SyncBatchJob.sync_job.processed_attachment_ids;

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneAttachments() - ' + processed_ids.size() + ' - processed_ids: ' + JSON.serialize(processed_ids),NULL);

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Attachment'),',');
            query_string += ' FROM  Attachment WHERE ParentId in (SELECT id from Marketing_SOW__c WHERE Sync_Status__c =\'' + job_component.attrib_3 + '\') AND Id NOT in: processed_ids ORDER BY ParentId LIMIT ' + job_component.query_limit; 


            Map<Id, Attachment> map_attachments_to_clone = new Map<Id, Attachment>();
            Set<Id> set_cloned_parent_id = new Set<Id>();

            for (Attachment attch: Database.query(query_string)){
            	map_attachments_to_clone.put(attch.Id, attch);
            	set_cloned_parent_id.add(attch.ParentId);
            }


            String query_string2 = 'SELECT ' + job_component.attrib_1 + ', ' + job_component.attrib_2 + ' FROM Marketing_SOW__c WHERE Id in: set_cloned_parent_id ';
            Map<Id,Marketing_SOW__c> map_original_to_cloned = new Map<Id, Marketing_SOW__c>((List<Marketing_SOW__c>)
            	(Database.query(query_string2)));

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneAttachments() - ' + map_original_to_cloned.size() + ' - map_original_to_cloned: ' + JSON.serialize(map_original_to_cloned),NULL);

            List<Attachment> list_attachments_to_clone = new List<Attachment>();

            for (Attachment attch: map_attachments_to_clone.values()){
        		

        		Attachment cloned_attch = attch.clone(false, true, false, false);
        		cloned_attch.ParentId = (Id) map_original_to_cloned.get(attch.ParentId).get(job_component.attrib_2);
	
	            //Oblix_SyncBatchJob.addEvent('INFO IN cloneAttachments() - RECALCULATE PARENT: ' + (String) map_original_to_cloned.get(attch.ParentId).get(job_component.attrib_2),NULL);

                list_attachments_to_clone.add(cloned_attch);

                // add id to processed collection to avoid reprocessing
                Oblix_SyncBatchJob.sync_job.processed_attachment_ids.add(attch.Id);

            }

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneAttachments() - ' + list_attachments_to_clone.size() + ' - list_attachments_to_clone: ' + JSON.serialize(list_attachments_to_clone),NULL);

            Database.insert(list_attachments_to_clone, false);
            
        }
        catch(QueryException queryEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAttachments() - ', queryEx.getMessage() + STACK_TRACE + queryEx.getStackTraceString());
            is_success = false;
        }
        catch(DmlException dmlEx){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAttachments() - ', dmlEx.getMessage() + STACK_TRACE + dmlEx.getStackTraceString());
            is_success = false;
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAttachments() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success; 

	}

}