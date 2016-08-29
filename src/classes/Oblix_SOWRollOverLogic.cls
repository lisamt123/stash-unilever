<<<<<<< HEAD
/*****************************************************************************************
* @author       Execloud ©
* @date         2016-04-25
* @description  Apex class contains the logic for rollover process and keeping the
*               campaigns and assets in sync
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Execloud ©             2016-04-25          Created
*
******************************************************************************************/
public with sharing class Oblix_SOWRollOverLogic {

    

    public Oblix_SOWRollOverLogic() {
        
    }

    private static final String SOW_OBJECT = 'Oblix_SOW_Projects__c';
    private static final String ASSET_OBJECT = 'Oblix_Project_Assets__c';

    private static final String ERROR_SETPROCESSINGFLAG = 'ERROR IN setProcessingFlag() - ';
    private static final String STACK_TRACE = ' - STACK TRACE: ';
    private static final String SELECT_SOQL = 'SELECT ';
    private static final String SOQL_AND = '\' AND ';
    //private static final String EXCLUDE_SYNC_STEP_SOQL = '\' AND Sync_Step__c <> \'';
    private static final String ORDER_BY_SOQL = '\' ORDER BY Id LIMIT ';
    private static final String RESULT_MSG_PREFIX = '\n\n\n to update: ';
    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Decides which function to call depending on the process_name
                    passed in value
    *********************************************************************/
    public static void processStep(Oblix_syncBatchJob.JobComponent job_component){

        //system.debug('## process step: ' + job_component);
        
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
        else if(Oblix_Utils.JOB_PROCESS_SET_PROCESSING_FLAG == job_component.process_name){
            is_success = setProcessingFlag(job_component);
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
        else if(Oblix_Utils.JOB_PROCESS_RECALCULATE_FEES_PFY == job_component.process_name){
            is_success = recalculateTotalPFYCampaignFeesUsingCFYcalculator(job_component);
        }
        else if(Oblix_Utils.JOB_PROCESS_SYNC_ASSETS == job_component.process_name){
            is_success = syncAssetsDuringTransitionPeriod(job_component);
        }
        

        // update the batch job component with the status
        Oblix_SyncBatchJob.sync_job.job_has_error = !is_success;

    }


    ///********************************************************************
    //* @author       Execloud ©
    //* @date         2016-05-04
    //* @description  Depending on the passed in object and attributes 
    //                set the status of sObject from A to B
    //*********************************************************************/
    //public static boolean setAttachmentClonedFlag(Oblix_syncBatchJob.JobComponent job_component){

    //    Boolean is_success = true;
    //    try{

    //        // job component attribute list
    //        //      attrib_1: sync status
    //        //      attrib_2: attachment_cloned value to be set true/false
    //        //      attrib_3: original sow status
    //        //##########################################################################################
    //        //  query the correct records in scope, set the status of the sync
    //        //##########################################################################################

    //        String query_string = 'SELECT Attachments_Cloned__c FROM Marketing_SOW__c WHERE Sync_Status__c =\'' + job_component.attrib_1; 
    //        query_string += '\' AND SOW_Status__c =  \'' + job_component.attrib_3 + '\'';
    //        query_string += ' AND Attachments_Cloned__c <>  ' + job_component.attrib_2 + ' ORDER BY Id LIMIT ' + job_component.query_limit; 
            


    //        Map<Id, Marketing_SOW__c> map_sows_update = new Map<Id, Marketing_SOW__c>();

    //        for (Marketing_SOW__c sow: database.query(query_string)){
    //            sow.Attachments_Cloned__c = Boolean.valueOf(job_component.attrib_2);
    //            map_sows_update.put(sow.Id, sow);
    //        }

    //        update map_sows_update.values();
            
    //    }
    //    catch(QueryException queryEx){  
    //        Oblix_SyncBatchJob.addEvent('ERROR IN setAttachmentClonedFlag() - ', queryEx.getMessage() + STACK_TRACE + queryEx.getStackTraceString());
    //        is_success = false;
    //    }
    //    catch(DmlException dmlEx){  
    //        Oblix_SyncBatchJob.addEvent('ERROR IN setAttachmentClonedFlag() - ', dmlEx.getMessage() + STACK_TRACE + dmlEx.getStackTraceString());
    //        is_success = false;
    //    }
    //    catch(Exception ex){  
    //        Oblix_SyncBatchJob.addEvent('ERROR IN setAttachmentClonedFlag() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
    //        is_success = false;
    //    }
    //    return is_success;   
    //}

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Depending on the passed in object and attributes 
                    set the status of sObject flag
    *********************************************************************/
    public static boolean setProcessingFlag(Oblix_syncBatchJob.JobComponent job_component){

        Boolean is_success = true;
        try{

            // job component attribute list
            //      attrib_1: sync status
            //      attrib_2: attachment_cloned/attribute updated? value to be set true/false
            //      attrib_3: original status
            //      attrib_4: object type
            //      attrib_5: field used for flag
            //      attrib_6: field used for checking sow status (either Financial_Year__r.SOW_Status__c or SOW_Status__c)
            //      
            //##########################################################################################
            //  query the correct records in scope, set the status of the sync
            //##########################################################################################

            String query_string = 'SELECT ' + job_component.attrib_5 + ' FROM ' + job_component.attrib_4 + ' WHERE Sync_Status__c =\'' + job_component.attrib_1; 
            
            if (NULL != job_component.attrib_6){
                query_string += SOQL_AND + job_component.attrib_6 + ' = \'' + job_component.attrib_3 + '\'';
            }
            else{
                query_string += '\'';
            }
            
            // depending on if the value is a boolean or string build the correct query string
            if (Oblix_SyncBatchJob.TRUE_VALUE == job_component.attrib_2 || Oblix_SyncBatchJob.FALSE_VALUE == job_component.attrib_2){
                query_string += ' AND ' + job_component.attrib_5 + ' <>  ' + job_component.attrib_2 + ' ORDER BY Id LIMIT ' + job_component.query_limit; 
            }
            else{
                query_string += ' AND ' + job_component.attrib_5 + ' <> \'' + job_component.attrib_2  + '\' ORDER BY Id LIMIT ' + job_component.query_limit; 
            }

            Oblix_SyncBatchJob.addEvent('INFO IN setProcessingFlag() - query_string: ' + query_string, NULL);

            Map<Id, sObject> map_objects_to_update = new Map<Id, sObject>((List<sObject>)(database.query(query_string)));

            setProcessingFlag(map_objects_to_update.values(), job_component.attrib_5, job_component.attrib_2);
            
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent(ERROR_SETPROCESSINGFLAG, ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;   
    }


    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Depending on the passed in object and attributes 
                    set the status of sObject flag
    *********************************************************************/
    public static boolean setProcessingFlag(List<sObject> list_objects_to_update, String field_to_update, String value_for_update ){

        Boolean is_success = true;
        try{


            Map<Id, sObject> map_objects_to_update = new Map<Id, sObject>();

            for (sObject obj: list_objects_to_update){

                // if the passed in value is in the form of TRUE/FALSE then set the value as a boolean instead of string
                if (Oblix_SyncBatchJob.TRUE_VALUE == value_for_update || Oblix_SyncBatchJob.FALSE_VALUE == value_for_update){
                    obj.put(field_to_update, Boolean.valueOf(value_for_update));
                }
                else
                {
                    obj.put(field_to_update, value_for_update);   
                }
                map_objects_to_update.put(obj.Id, obj);
            }

            update map_objects_to_update.values();
            
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent(ERROR_SETPROCESSINGFLAG, ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;   
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
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            //##########################################################################################
            //  query the correct records in scope, set the status of the sync, add to list and update
            //##########################################################################################

            // queries examples:
            // 
            // when at parent sow level and setting children campaign statuses
            // 1) SELECT Sync_Status__c FROM Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c  = 'Sync In Prgoress' 
            //      AND Sync_Status__c <> 'Sync In Prgoress'  ORDER BY Id LIMIT 1000
            
            // when at individual campaign level
            // 2) SELECT Sync_Status__c FROM Marketing_SOW__c WHERE Sync_Status__c  = 'Sync Requested'
            //      AND Sync_Status__c <> 'Sync In Prgoress'  ORDER BY Id LIMIT 1000


            String query_string = 'SELECT Sync_Status__c FROM '+ job_component.attrib_3 +' WHERE '+ job_component.attrib_4 +' =\'' + job_component.attrib_1; 
            query_string += '\' AND Sync_Status__c <> \'' + job_component.attrib_2 + ORDER_BY_SOQL + job_component.query_limit; 
            


            Map<Id, SObject> map_objects_update = new Map<Id, SObject>();
            Set<Id> set_original_ids = new Set<Id>();

            for (SObject obj: database.query(query_string)){
                obj.put('Sync_Status__c',job_component.attrib_2);
                map_objects_update.put(obj.Id, obj);
                set_original_ids.add(obj.Id);
            }

            //Oblix_SyncBatchJob.addEvent(' adjust status query: ' + query_string + '\nResult size: ' + map_objects_update.size(),NULL);

            // when sync is in progress, also make sure that the records being synced are "locked" by setting the status to "In Progress"
            
            if (String.isNotBlank(job_component.attrib_5)){
                String query_string2 = 'SELECT Sync_Status__c FROM '+ job_component.attrib_3 +' WHERE Sync_Status__c =\'' + job_component.attrib_1 
                    + SOQL_AND + job_component.attrib_5 +' in : set_original_ids AND Id NOT in: set_original_ids ' 
                    + ' ORDER BY Id LIMIT ' + job_component.query_limit; 
                for (SObject obj: database.query(query_string)){
                    obj.put('Sync_Status__c',job_component.attrib_2);
                    map_objects_update.put(obj.Id, obj);
                }
            }

            update map_objects_update.values();
            
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
        //  2.1- original_sow is (Approved) 
        //  2.2- cloned_sow - clone is (Live) 

        // 'initial sync'
        // 3- (Live) will then go through initiate rollover
        //  3.1- original_sow remains (Live) 
        //  3.2- cloned_sow - FY is incremented by +1 year - (Live)

        // 'taken care of by approval process
        // 4- (Live) will then go EOY approval
        //  4.1- original_sow is (Finalised) 
        //  4.2- cloned_sow remains (Live) 


        // 'version control2'
        // 4- (Live) will then go through initial approval
        //  4.1- original_sow is (Approved2) 
        //  4.2- cloned_sow - clone becomes (Live2) 

        if (Oblix_Utils.PROCESS_TYPE_INITIAL_APPROVAL == job_component.attrib_6){
            
            // this must be initial approval
            original_sow.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_APPROVED;
            cloned_sow.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_LIVE;
            cloned_sow.Initial_Approval_Complete__c = true;
            cloned_sow.SOW_Status__c = Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES;
        }
        else{
            // this must be initial rollover process
            Integer financial_year = Oblix_SOWHandlerLogic.getFinancialYear(original_sow);

            // increment financial year by +1 year
            financial_year ++;

            cloned_sow.Financial_Year__c = Oblix_Utils.FY_PREFIX + financial_year;
            cloned_sow.Initial_Approval_Complete__c = false;
            cloned_sow.SOW_Status__c = Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER;

            // clear out name suffix for sows being rolled over
            cloned_sow.Name_Suffix__c = '';

        }

    } 


    private static void setCampaignNameSuffix(Oblix_SOW_Projects__c original_campaign,Oblix_SOW_Projects__c cloned_campaign, Oblix_syncBatchJob.JobComponent job_component){

        // stages
        // 1- when campaign is created from scratch it has blank suffix
        
        // 'version control'
        // 2- it will then go through initial approval
        //  2.1- original_campaign is (Approved) 
        //  2.2- cloned_campaign - clone is (Live) 

        // 'initial sync'
        // 3- (Live) will then go through initiate rollover
        //  3.1- original_campaign remains (Live) 
        //  3.2- cloned_campaign - clone is (B/Fwd) 

        // 'taken care of by a trigger/flow
        // 4- (Live) will then go EOY approval
        //  4.1- original_campaign is (Finalised) 
        //  4.2- cloned_campaign remains (B/Fwd) 


        // 'version control'
        // 4- (B/Fwd) will then go through initial approval
        //  4.1- original_campaign is (Approved2) 
        //  4.2- cloned_campaign - clone becomes (Live2) 

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
    private static void setAllFieldsDuringSync(SObject original_object, SObject cloned_object
        , Map<String, Schema.SObjectField> map_name_and_field, Boolean should_update_stage){

        // copy over all fields from PFY to NFY campaigns 
        for (String field_name : map_name_and_field.keySet()){  

            Schema.SObjectField sf = map_name_and_field.get(field_name);
            String field_type = String.valueOf(sf.getDescribe().getType()).toUpperCase();
            Boolean is_editable = sf.getDescribe().isUpdateable();

            // don't overwrite campaign stage fields if campaign attributes are not changed
            if (('Projected_Stage_CFY__c' == field_name && !should_update_stage)
                ||
                ('Projected_Stage_PFY__c' == field_name && !should_update_stage)   
                ){
                cloned_object.put(field_name, (String) cloned_object.get(field_name));
            }
            else if(is_editable){

                //Oblix_SyncBatchJob.addEvent('INFO IN setAllFieldsOnCampaignsRollOver - field_type: ' + field_type + ' - field_name: ' 
                    //+ field_name,NULL);

                if('BOOLEAN' == field_type){
                    cloned_object.put(field_name, (Boolean) original_object.get(field_name));
                }
                else if('DOUBLE' == field_type || 'CURRENCY' == field_type || 'PERCENT' == field_type){
                    cloned_object.put(field_name, (Decimal) original_object.get(field_name));
                }
                else if('INTEGER' == field_type){
                    cloned_object.put(field_name, (Integer) original_object.get(field_name));
                }
                else if('REFERENCE' == field_type || 'ID' == field_type){
                    //cloned_object.put(field_name, (Id) original_object.get(field_name));
                    // Id and reference fields are handeled separately in the syncCampaign method, don't reset them here!
                    cloned_object.put(field_name, (Id) cloned_object.get(field_name));
                }
                else if('DATE' == field_type){
                    cloned_object.put(field_name, (Date) original_object.get(field_name));
                }
                else if('DATETIME' == field_type){
                    cloned_object.put(field_name, (Datetime) original_object.get(field_name));
                }
                else{
                    // 'STRING' , 'EMAIL' , 'TEXTAREA' , 'PICKLIST' , 'MULTIPICKLIST'
                    cloned_object.put(field_name, (String) original_object.get(field_name));
                }

                
            }
        }
    }


    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Set the financial fields on campaign from PFY to NFY
    *********************************************************************/
    private static void setFinancialFieldsOnCampaignsRollOver(Oblix_SOW_Projects__c original_campaign, Oblix_SOW_Projects__c cloned_campaign){

        // copy over the Progress Stage and box number to PFY
        cloned_campaign.Campaign_PFY__c = original_campaign.Id;


        // S.M. 2016-05-19 - in a scenario where actual campaign attributes haven't been updated but an asset has been added to PFY campaign, we don't want to
        // overwrite the chevron but should update other financial fields
        if (original_campaign.Campaign_Attributes_Updated__c){
            cloned_campaign.Projected_Stage_PFY__c = getUnionCurrentAndPastStages(original_campaign, 'Projected_Stage_CFY__c','Projected_Stage_PFY__c'); //original_campaign.Projected_Stage_CFY__c;
        }
        cloned_campaign.Completed_Stage_PFY__c = getUnionCurrentAndPastStages(original_campaign, 'Completed_Stage_CFY__c','Completed_Stage_PFY__c'); // original_campaign.Completed_Stage_CFY__c;
        
        cloned_campaign.Total_Project_Score_PFY__c = original_campaign.Total_Project_Score__c ;
        cloned_campaign.Fees_Paid_PFY__c = original_campaign.Value_to_be_paid_in_Current_FY__c;
        cloned_campaign.Fees_Total_PFY__c = original_campaign.Campaign_Total_Fees__c;

        cloned_campaign.Percentage_of_Fees_PFY__c = NULL != original_campaign.Percentage_of_Fees_PFY__c
            ? original_campaign.Percentage_of_Fee_for_this_FY__c + original_campaign.Percentage_of_Fees_PFY__c
            : original_campaign.Percentage_of_Fee_for_this_FY__c;
        
        // S.M. 2016-05-19 - in a scenario where actual campaign attributes haven't been updated but an asset has been added to PFY campaign, we don't want to
        // overwrite the chevron but should update other financial fields
        if (original_campaign.Campaign_Attributes_Updated__c){
            // select all projected stages by default when initiating rollover process
            cloned_campaign.Projected_Stage_CFY__c = getDeltaCurrentAndPastStages(cloned_campaign,'Projected_Stage_PFY__c');
        }

        // set the remaining value for this FY
        if (NULL != cloned_campaign.Percentage_of_Fees_PFY__c){
            cloned_campaign.Percentage_of_Fee_for_this_FY__c = 100 - cloned_campaign.Percentage_of_Fees_PFY__c;
        }else{
            cloned_campaign.Percentage_of_Fee_for_this_FY__c = 100;
        }

        cloned_campaign.Oblix_ProjectBoxNumber_PFY__c = original_campaign.Oblix_ProjectBoxNumber__c ;
    }

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  To maintain the logic for chevron, we need to combine the 
                    stages from CFY and PFY and stamp on PFY field of the following
                    financial year campaign - this is done for both completed and projected stage
    *********************************************************************/
    public static String getDeltaCurrentAndPastStages(Oblix_SOW_Projects__c cloned_campaign, String pfy_field){
       
        Set<String> set_delta = new Set<String>();
        String delta_stages = '';
        List<String> list_all_stages = new List<String>();
        List<String> list_stages_retrieved = new List<String>();
        String separator = ';';

        String result = '';

        // create a full list
        if (String.isNotBlank(Oblix_Utils.CAMPAIGN_STAGES_ALL)){

            list_all_stages = Oblix_Utils.CAMPAIGN_STAGES_ALL.split(separator);
            result += '\nlist_all_stages: ' + JSON.serialize(list_all_stages);
        }

        set_delta.addAll(list_all_stages);


        String past_stages = (String) cloned_campaign.get(pfy_field);
        result += '\npast_stages: ' + past_stages;
        // get completed stages for last year
        if (String.isNotBlank(past_stages)){

            list_stages_retrieved = past_stages.split(separator);
            result += '\nlist_stages_retrieved: ' + JSON.serialize(list_stages_retrieved);

            for (String stage_name: list_stages_retrieved){
                result += '\nstage_name: ' + stage_name;
                set_delta.remove(stage_name);
            }
        }

        // copy to a list to allow building ';' separated string
        List<String> list_delta_stages = new List<String>(); 
        list_delta_stages.addAll(set_delta);
        
        result += '\nlist_union_stages: ' + JSON.serialize(list_delta_stages);

        if (!list_delta_stages.isEmpty()){
            // build the semi-colon separated values to re-assign
            delta_stages = String.join(list_delta_stages, separator);
        }
        result += '\nunion_stages: ' + delta_stages;
        //system.debug(result);
        return delta_stages;
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
        //system.debug(result);
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
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            // clone sow:
            //      attrib_1: Original_SOW__c
            //      attrib_2: Cloned_SOW__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_6: Process type - initial approval

            // initial sync:
            //      attrib_1: SOW_PFY__c
            //      attrib_2: SOW_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_6: Process type - initial sync

            //Oblix_SyncBatchJob.addEvent(' Campaign to clone size: ' + list_campaigns_to_clone.size(),NULL);

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Marketing_SOW__c'),',');
            query_string += ' FROM  Marketing_SOW__c WHERE Sync_Status__c =\'' + job_component.attrib_3 + SOQL_AND + job_component.attrib_2 + ' = NULL ORDER BY Id LIMIT ' + job_component.query_limit; 
            
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

            Database.SaveResult[] list_database_save_result = Database.insert (list_sows_to_clone,false);
            
            is_success = processSaveResult(list_database_save_result,'Marketing_SOW__c',list_sows_to_clone);

            Set<Id> id_original_sows = map_original_id_original_campaign.keySet();
            String query_string2 = SELECT_SOQL + job_component.attrib_1 + ', ' + job_component.attrib_2 + ' FROM Marketing_SOW__c WHERE ' + job_component.attrib_1 + ' in :id_original_sows ';
            // initial sync result: SELECT SOW_NFY__c, SOW_PFY__c FROM Oblix_Project_Assets__c WHERE SOW_PFY__c in: id_original_sows
            // clone sow  result: SELECT Cloned_SOW__c, Original_SOW__c FROM Oblix_SOW_Projects__c WHERE Original_SOW__c in: id_original_sows

            // update the original SOWs with the id of cloned SOWs
            for (Marketing_SOW__c sow: database.query(query_string2)){
                //clon: map_original_id_original_campaign.get(sow.Original_SOW__c).Cloned_SOW__c = sow.Id;
                //sync: map_original_id_original_campaign.get(sow.SOW_PFY__c).NFY_SOW__c = sow.Id;
                map_original_id_original_campaign.get((Id) sow.get(job_component.attrib_1)).put(job_component.attrib_2,sow.Id);
            }

            if (is_success){
                update map_original_id_original_campaign.values();
            }
            
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneSOW() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;   
        
    }

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  builds a string of error message for a list Database.Error
    *********************************************************************/
    public static String buildErrorMessage(Database.Error[] errs){
        String errorMsg = '';
        // Operation failed, get all errors. What was the cause?                
        for(Database.Error err : errs){
           errorMsg = 'Status: ' + err.getStatusCode() + '\n';
           errorMsg +=  'Error: ' + err.getMessage() + '\n';
           errorMsg +=  'Field(s): ' + err.getFields() + '\n';

        }       
        return errorMsg;
    }


    /********************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  process list of save results
    *********************************************************************/
    public static Boolean processSaveResult(Database.SaveResult[] list_database_save_result, String object_type, List<sObject> records_to_process){

        Integer index_ref=0;
        Boolean is_success = true;

        Type t = Type.forName(object_type);

        for(Database.SaveResult ur : list_database_save_result){ 
            // found issue with saving the records
            if (!ur.isSuccess()){


                SObject original_record = (sObject) t.newInstance();
                original_record = records_to_process[index_ref];
                    
                Oblix_SyncBatchJob.addEvent('ERROR processing ' + object_type +' record with name: ' + original_record.get('Name') + ' \n' + buildErrorMessage(ur.getErrors()) + '\n\n' + JSON.serialize(original_record),NULL);
                is_success = false;
            }
            ++index_ref;
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
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            // clone campaign:
            //      attrib_1: Original_SOW__c
            //      attrib_2: Cloned_SOW__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_4: Cloned_Campaign__c
            //      attrib_5: Original_Campaign__c

            // initial sync:
            //      attrib_1: SOW_PFY__c
            //      attrib_2: SOW_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: Campaign_NFY__c
            //      attrib_5: Campaign_PFY__c

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject(SOW_OBJECT),',');
            query_string += ', (SELECT ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string += ' FROM  Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c =\'' + job_component.attrib_3 + SOQL_AND + job_component.attrib_4 + ' = NULL ORDER BY Id LIMIT ' + job_component.query_limit; 
            

            List<Oblix_SOW_Projects__c> list_campaigns_to_clone = new List<Oblix_SOW_Projects__c>();
            Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> map_original_id_splits_to_clone = new Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();
            List<Oblix_Marketing_SOW_Project_Splits__c> list_splits_to_clone = new List<Oblix_Marketing_SOW_Project_Splits__c>();

            Map<Id, Oblix_SOW_Projects__c> map_original_id_original_campaign = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string));


            for (Oblix_SOW_Projects__c campaign: map_original_id_original_campaign.values()){
                

                Oblix_SOW_Projects__c cloned_campaign = campaign.clone(false, true, false, false);
               
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

            //Oblix_SyncBatchJob.addEvent(' Campaign to clone size: ' + list_campaigns_to_clone.size(),NULL);
            //Oblix_SyncBatchJob.addEvent(' original size: ' + map_original_id_original_campaign.size(),NULL);


            //Oblix_SyncBatchJob.addEvent(' JSON to clone: ' + JSON.serialize(list_campaigns_to_clone),NULL);
            //Oblix_SyncBatchJob.addEvent(' JSON original: ' + JSON.serialize(map_original_id_original_campaign),NULL);


            Database.SaveResult[] list_database_save_result = Database.insert (list_campaigns_to_clone,false);
            
            is_success = processSaveResult(list_database_save_result,SOW_OBJECT,list_campaigns_to_clone);

            //Set<Id> id_original_campaigns = map_original_id_original_campaign.keySet();
            //String query_string2 = SELECT_SOQL + job_component.attrib_4 + ', ' + job_component.attrib_5 + ' FROM Oblix_SOW_Projects__c WHERE ' + job_component.attrib_5 + ' in :id_original_campaigns ';
            // initial sync result: SELECT Campaign_NFY__c, Campaign_PFY__c FROM Oblix_Project_Assets__c WHERE Campaign_PFY__c in: id_original_campaigns
            // clone campaign  result: SELECT Cloned_Campaign__c, Original_Campaign__c FROM Oblix_SOW_Projects__c WHERE Original_Campaign__c in: id_original_campaigns


            // update the original Campaigns with the id of cloned Campaigns and set the id on hub split records
            populateClonedRecordsWithIds(job_component.attrib_4,job_component.attrib_5,map_original_id_splits_to_clone, map_original_id_original_campaign,list_splits_to_clone);

            //for (Oblix_SOW_Projects__c campaign: database.query(query_string2)){
            //      // clone:   map_original_id_original_campaign.get(campaign.Original_Campaign__c).Cloned_Campaign__c = campaign.Id;
            //      // sync:    map_original_to_syncd_id.get(campaign.Campaign_PFY__c).Campaign_NFY__c = campaign.Id;

            //  map_original_id_original_campaign.get(job_component.attrib_5).put(job_component.attrib_4, campaign.Id);

            //  // adjust the parent Id of project split
            //  if (NULL != map_original_id_splits_to_clone && map_original_id_splits_to_clone.containsKey(campaign.Original_Campaign__c) 
            //      && NULL!= map_original_id_splits_to_clone.get(campaign.Original_Campaign__c) && map_original_id_splits_to_clone.get(campaign.Original_Campaign__c).size()>0){

            //      for (Oblix_Marketing_SOW_Project_Splits__c split_to_adjust: map_original_id_splits_to_clone.get(campaign.Original_Campaign__c)){
            //          split_to_adjust.Project_Splits__c = campaign.Id;
            //          list_splits_to_clone.add(split_to_adjust);
            //      }
            //  }
            //}

            if (is_success){
                update map_original_id_original_campaign.values();
            }

            // also clone the project splits
            if (!list_splits_to_clone.isEmpty() && is_success){
                insert list_splits_to_clone;
            }

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
        String query_string = SELECT_SOQL + clone_nfy_field + ', ' + original_pfy_field + ' FROM Oblix_SOW_Projects__c WHERE ' + original_pfy_field + ' <> NULL AND ' + original_pfy_field + ' in :id_original_campaigns ';
            
        // update the original Campaigns with the id of cloned Campaigns
        for (Oblix_SOW_Projects__c campaign: database.query(query_string)){
            // clone:   map_original_id_original_campaign.get(campaign.Original_Campaign__c).Cloned_Campaign__c = campaign.Id;
            // sync:    map_original_to_syncd_id.get(campaign.Campaign_PFY__c).Campaign_NFY__c = campaign.Id;

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
    * @description  this method recalculates campaign total fees by applying the 
                    calculator records of CFY - it can then work out the value paied in 
                    previous financial year using current FY calculator records to help
                    adjust value to be paid in current financial year

    *********************************************************************/
    public static boolean recalculateTotalPFYCampaignFeesUsingCFYcalculator(Oblix_syncBatchJob.JobComponent job_component){
        
        Boolean is_success = true;
        
        try{

            String result_msg = '';

            //##########################################################################################
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################
            // initial sync:
            //      attrib_1: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_2: 
            //      attrib_3: 
            //      attrib_4: 
            //      attrib_5: 
            //      attrib_6: 

            // step name is stamped on processed records to avoid reprocessing during the same batch job
            String step_name = 'recalculate campaign fees';

            String query_string = 'SELECT Total_Project_Score_PFY__c, Percentage_of_Fees_PFY__c, Fees_PFY_Total_By_CFY_Calculator__c, Fees_PFY_Paid_Using_CFY_Calc__c, Total_Value_Driver__c, ProjectTotalAssetscore__c ';
            query_string += ' ,Financial_Year__r.Financial_Year__c';
            query_string += ', (SELECT Project_Splits__r.Campaign_NFY__c, OblixCountry__r.Name, ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string += ' FROM  Oblix_SOW_Projects__c WHERE Sync_Status__c = \'' + job_component.attrib_1 + '\''; 
            
            // only get the cloned/NFY campaigns
            query_string += ' AND Financial_year__r.SOW_NFY__c = NULL AND Sync_Step__c <> \'' + step_name + ORDER_BY_SOQL + job_component.query_limit; 

            // OLD IMPLEMENTATION
            // only query the cloned campaigns here
            //query_string += ' AND Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER + EXCLUDE_SYNC_STEP_SOQL + step_name + ORDER_BY_SOQL + job_component.query_limit; 
            
            result_msg += '\nquery_string: ' + query_string;

            Map<Id, Oblix_SOW_Projects__c> map_ids_cloned_campaign = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string));
            Map<Id, Long> map_campaign_id_total_fee = Oblix_CalculatorLogic.getCampaignFee(map_ids_cloned_campaign, NULL,false,false, false, Oblix_Utils.TOTAL_PROJECT_SCORE_PFY_FILED);

            result_msg += '\n\nmap_ids_cloned_campaign size: ' + map_ids_cloned_campaign.size();

            for (Id campaign_id: map_ids_cloned_campaign.keySet()){

                Oblix_SOW_Projects__c campaign = map_ids_cloned_campaign.get(campaign_id);

                if (NULL != map_campaign_id_total_fee && map_campaign_id_total_fee.containsKey(campaign_id) 
                    && NULL != map_campaign_id_total_fee.get(campaign_id)){

                    // get total fees from the calculated map and assign to campaign
                    campaign.Fees_PFY_Total_By_CFY_Calculator__c = map_campaign_id_total_fee.get(campaign_id);

                    // calculate total fees paid in PFY by applying % paid last year
                    campaign.Fees_PFY_Paid_Using_CFY_Calc__c = campaign.Fees_PFY_Total_By_CFY_Calculator__c * campaign.Percentage_of_Fees_PFY__c / 100;


                }

                // set step name on processed campaign to avoid reprocessing it 
                campaign.Sync_Step__c = step_name;

            }
            result_msg += '\n\nmap_campaigns_to_update size: ' + map_ids_cloned_campaign.size();

            // update existing campaigns
            update map_ids_cloned_campaign.values();


            //Oblix_SyncBatchJob.addEvent('DEBUG IN recalculateTotalPFYCampaignFeesUsingCFYcalculator() - result_msg: ' + result_msg,NULL);


        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN recalculateTotalPFYCampaignFeesUsingCFYcalculator() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  
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

            String step_name = 'sync campaign';

            //##########################################################################################
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################
            // initial sync:
            //      attrib_1: SOW_NFY__c
            //      attrib_2: CAMPAIGN_PFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: 
            //      attrib_5: 
            //      attrib_6: Type of process
            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject(SOW_OBJECT),',');
            query_string += ', (SELECT Project_Splits__r.Campaign_NFY__c, ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string += ' FROM  Oblix_SOW_Projects__c WHERE Sync_Status__c = \'' + job_component.attrib_3 + '\''; 
            // check for NFY lookup to exclude cloned/NFY records
            query_string += ' AND Financial_Year__r.SOW_NFY__c <> NULL ';
            query_string += ' AND Sync_Step__c <> \''  + step_name +  ORDER_BY_SOQL + job_component.query_limit; 

            // check for sow status to exclude the cloned/NFY records - OLD IMPLEMENTATION
            //query_string += ' AND (Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES;
            //query_string += '\' OR Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_REJECTED_BY_AGENCY;
            //query_string += '\' OR Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_REJECTED_BY_UNILEVER;

            //// in case it is a superuser or admin making changes to the record during the approval process
            //query_string += '\' OR Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL; 
            //query_string += '\' OR Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_REJECTED_BY_UNILEVER 
            
            
            // get the matching cloned campaigns to perform the sync

            result_msg += '\n query1: ' + query_string;
            
            Map<Id, Oblix_SOW_Projects__c> map_original_ids_to_original = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string));
            Set<Id> set_original_ids = map_original_ids_to_original.keySet();

            result_msg += '\n query1 result rows: ' + set_original_ids.size() + ' - original campaign: ' + JSON.serialize(map_original_ids_to_original);

            String query_string2 = SELECT_SOQL;
            query_string2 += String.join(Oblix_Utils.getfieldsByObject(SOW_OBJECT),',');
            query_string2 += ', (SELECT Project_Splits__r.Campaign_NFY__c, ';
            query_string2 += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string2 += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string2 += ' FROM  Oblix_SOW_Projects__c WHERE Campaign_PFY__c in : set_original_ids'; 
            
            result_msg += '\n query2: ' + query_string2;

            Map<Id, Oblix_SOW_Projects__c> map_original_ids_to_cloned = new Map<Id,Oblix_SOW_Projects__c>();
            for (Oblix_SOW_Projects__c cloned_campaign: database.query(query_string2)){
                map_original_ids_to_cloned.put(cloned_campaign.Campaign_PFY__c,cloned_campaign );
            }

            result_msg += '\n query2 result rows: ' + map_original_ids_to_cloned.size() + ' - cloned campaign: ' + JSON.serialize(map_original_ids_to_cloned);

            // scenarios:
            //  1- PFY campaign is newly created: create a clone of the for the NFY
            //  2- PFY % projected is increased to 100% therefore need to remove from NFY 
            //  3- PFY and NFY are created but require syncing

            Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_delete = new Map<Id, Oblix_SOW_Projects__c>();
            Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_update = new Map<Id,Oblix_SOW_Projects__c>();
            List<Oblix_SOW_Projects__c> list_campaigns_to_clone = new List<Oblix_SOW_Projects__c>();
            Map<Id, Oblix_SOW_Projects__c> map_original_id_original_campaign = new Map<Id,Oblix_SOW_Projects__c>();

            // this map is used to copy over values from original to cloned campaigns
            Map<String, Schema.SObjectField> map_name_and_field = Oblix_Utils.fetchAllFieldsForObject(SOW_OBJECT);

            Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> map_original_id_splits_to_clone = new Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();

            // also need to sync all related non-campaign records
            List<Oblix_Marketing_SOW_Project_Splits__c> list_splits_to_clone = new List<Oblix_Marketing_SOW_Project_Splits__c>();
            Map<Id,Oblix_Marketing_SOW_Project_Splits__c> map_splits_to_delete = new Map<Id, Oblix_Marketing_SOW_Project_Splits__c>();



            for (Oblix_SOW_Projects__c campaign: map_original_ids_to_original.values()){
                result_msg += '\n\n\n **** campaign.Percentage_of_Fees_Paid_To_Date__c: ' + campaign.Percentage_of_Fees_Paid_To_Date__c 
                    + ' - campaign.Campaign_Status__c: ' + campaign.Campaign_Status__c + ' - campaign: ' + JSON.serialize(campaign);
                
                if(!map_original_ids_to_cloned.containsKey(campaign.id)
                    && 
                    (Integer.valueOf(campaign.Percentage_of_Fees_Paid_To_Date__c) < 100 && Oblix_Utils.CAMPAIGN_STATUS_CANCELLED != campaign.Campaign_Status__c)){
                    //  1- PFY campaign is newly created: create a clone of the for the NFY - if campaign is not cancelled and % is less than 100
                    
                    Oblix_SOW_Projects__c cloned_campaign = campaign.clone(false, true, false, false);
                    
                    map_original_id_original_campaign.put(campaign.Id, campaign);

                    // copy over the financial related fields from current_campaign to next_financial_year PFY fields
                    setFinancialFieldsOnCampaignsRollOver(campaign, cloned_campaign);

                    // manage the hub and splits
                    syncHubAndSplits(campaign, NULL, map_splits_to_delete, map_original_id_splits_to_clone);


                    cloned_campaign.put(job_component.attrib_2,campaign.Id);

                    // S.M. 2016-05-22 added a flag to replace the formula field due to platform issues
                    cloned_campaign.Is_B_Fwd_Campaign__c = true;

                    // set campaign suffix
                    setCampaignNameSuffix(campaign,cloned_campaign, job_component);

                    // reparent new campaign
                    cloned_campaign.Financial_Year__c = (Id) campaign.get(job_component.attrib_1);
                    // need to insert these
                    list_campaigns_to_clone.add(cloned_campaign);
                    
                    result_msg += '\n\n\n to clone: ' + cloned_campaign.name;

                }
                else if(
                    (Integer.valueOf(campaign.Percentage_of_Fees_Paid_To_Date__c) >= 100|| Oblix_Utils.CAMPAIGN_STATUS_CANCELLED == campaign.Campaign_Status__c)
                    &&
                    (NULL != map_original_ids_to_cloned && map_original_ids_to_cloned.containsKey(campaign.id))
                    ){
                    //  2- PFY % projected is increased to 100% or campaign got cancelled therefore need to remove from NFY 
                    
                    //// remove the link from the original campaign
                    //campaign.Campaign_NFY__c = NULL;
                    //map_campaigns_to_update.put(campaign.Id, campaign);

                        map_campaigns_to_delete.put(campaign.Campaign_NFY__c, map_original_ids_to_cloned.get(campaign.Id));
                        
                        result_msg += '\n\n\n to delete: ' + map_original_ids_to_cloned.get(campaign.Id).name; 
                    

                }
                else if(NULL != map_original_ids_to_cloned && map_original_ids_to_cloned.containsKey(campaign.id)){
                    //  3- PFY and NFY are created but require syncing

                    Oblix_SOW_Projects__c cloned_campaign = map_original_ids_to_cloned.get(campaign.id);


                    map_original_id_original_campaign.put(campaign.Id, campaign);

                    // sync all existing fields from CFY to NFY
                    setAllFieldsDuringSync(campaign, cloned_campaign,map_name_and_field, campaign.Campaign_Attributes_Updated__c);

                    // copy over the financial related fields from current_campaign to next_financial_year PFY fields
                    setFinancialFieldsOnCampaignsRollOver(campaign, cloned_campaign);

                    // manage the hub and splits
                    syncHubAndSplits(campaign, cloned_campaign, map_splits_to_delete, map_original_id_splits_to_clone);

                    // set campaign suffix
                    setCampaignNameSuffix(campaign,cloned_campaign, job_component);

                    map_campaigns_to_update.put(cloned_campaign.Id, cloned_campaign);
                    
                    result_msg += RESULT_MSG_PREFIX + cloned_campaign.name;

                }

                campaign.Sync_Step__c = step_name;
                map_campaigns_to_update.put(campaign.Id, campaign);

            }

            //result_msg += RESULT_MSG_PREFIX + map_campaigns_to_update.size() + ' - to clone: ' + list_campaigns_to_clone.size() 
            //    + ' - to delete: ' + map_campaigns_to_delete.size() + ' - splits to delete: ' + map_splits_to_delete.size()
            //    + ' - map_original_id_splits_to_clone: ' + map_original_id_splits_to_clone.size()
            //    + ' - splits to insert: ' + list_splits_to_clone.size();



            // insert new campaigns
            //if (!list_campaigns_to_clone.isEmpty()){
                insert list_campaigns_to_clone;
            //}


            // update the original Campaigns with the id of cloned Campaigns and set the id on hub split records
            populateClonedRecordsWithIds('Campaign_NFY__c','Campaign_PFY__c',map_original_id_splits_to_clone, map_original_id_original_campaign,list_splits_to_clone);

            result_msg += RESULT_MSG_PREFIX + map_campaigns_to_update.size() + ' - to clone: ' + list_campaigns_to_clone.size() 
                + ' - to delete: ' + map_campaigns_to_delete.size() + ' - splits to delete: ' + map_splits_to_delete.size()
                + ' - map_original_id_splits_to_clone: ' + map_original_id_splits_to_clone.size()
                + ' - splits to insert: ' + list_splits_to_clone.size()
                + ' - map_campaigns_to_update: ' + JSON.serialize(map_campaigns_to_update);

            Oblix_SyncBatchJob.addEvent('DEBUG IN syncCampaignDuringTransitionPeriod() - result_msg: ' + result_msg,NULL);

            // update the original campaigns NFY fields
            //if (!map_original_id_original_campaign.isEmpty()){
                update map_original_id_original_campaign.values();
            //}

            // update existing campaigns
            //if (!map_campaigns_to_update.isEmpty()){
                update map_campaigns_to_update.values();
            //}

            // insert new hub and splits
            //if (!list_splits_to_clone.isEmpty()){
                insert list_splits_to_clone;
            //}

            // S.M. Removing if statements to resolve sonar issues
            // delete the cloned campaigns which are 100%
            //if (!map_campaigns_to_delete.isEmpty()){
                delete map_campaigns_to_delete.values();
            //}

            // delete old hub and splits
            //if (!map_splits_to_delete.isEmpty()){
                delete map_splits_to_delete.values();
            //}


            Oblix_SyncBatchJob.addEvent('DEBUG IN syncCampaignDuringTransitionPeriod() - result_msg: ' + result_msg,NULL);


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

            if (NULL != original_split.Project_Splits__r.Campaign_NFY__c){
                // set the parent of campaign under NFY if the lookup is populated - in case of existing records
                cloned_split.Project_Splits__c = original_split.Project_Splits__r.Campaign_NFY__c;
            }

            map_original_id_splits_to_clone.get(original_split.Project_Splits__c).add(cloned_split);
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
            //      attrib_1: Original_Campaign__c
            //      attrib_2: Cloned_Campaign__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_4: Cloned_Asset__c
            //      attrib_5: Original_Asset__c

            // initial sync:
            //      attrib_1: Campaign_PFY__c
            //      attrib_2: Campaign_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: Asset_NFY__c
            //      attrib_5: Asset_PFY__c

            //##########################################################################################
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            String result_msg ='';

            result_msg += '\n\n\n started clonning assets';

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject(ASSET_OBJECT),',');
            query_string += ' FROM  Oblix_Project_Assets__c WHERE Agency_Projects__r.Sync_Status__c =\'' + job_component.attrib_3 + SOQL_AND + job_component.attrib_4 + ' = NULL '; 
            query_string += ' AND ' + job_component.attrib_2 + ' <> NULL ORDER BY Id LIMIT ' + job_component.query_limit; 

            result_msg += '\n\n\n query_string: ' + query_string;

            List<Oblix_Project_Assets__c> list_assets_to_clone = new List<Oblix_Project_Assets__c>();
            Map<Id, Oblix_Project_Assets__c> map_original_id_original_asset = new Map<Id,Oblix_Project_Assets__c>((List<Oblix_Project_Assets__c>)database.query(query_string));


            for (Oblix_Project_Assets__c asset: map_original_id_original_asset.values()){
                

                Oblix_Project_Assets__c cloned_asset = asset.clone(false, true, false, false);
                cloned_asset.put(job_component.attrib_5,asset.Id);
                // set the parent of new asset to be under the cloned campaign (cloned/NFY)
                cloned_asset.Agency_Projects__c = (Id) asset.get(job_component.attrib_2);
                cloned_asset.Campaign_ID__c = (String) asset.get(job_component.attrib_2);
                list_assets_to_clone.add(cloned_asset);
            }

            result_msg += '\n\n\n map_original_id_original_asset.size(): ' + map_original_id_original_asset.size();
            result_msg += '\n\n\n map_original_id_original_asset: ' + JSON.serialize(map_original_id_original_asset);
            result_msg += '\n\n\n list_assets_to_clone.size(): ' + list_assets_to_clone.size();
            result_msg += '\n\n\n list_assets_to_clone: ' + JSON.serialize(list_assets_to_clone);

            //Oblix_SyncBatchJob.addEvent('DEBUG IN cloneAssets() - result_msg: ' + result_msg,NULL);

            Database.SaveResult[] list_database_save_result = Database.insert (list_assets_to_clone,false);
            
            is_success = processSaveResult(list_database_save_result,ASSET_OBJECT,list_assets_to_clone);

            Set<Id> id_original_assets = map_original_id_original_asset.keySet();
            String query_string2 = SELECT_SOQL + job_component.attrib_4 + ', ' + job_component.attrib_5 + ' FROM Oblix_Project_Assets__c WHERE ' + job_component.attrib_5 + ' in :id_original_assets ';
            // initial sync result: SELECT Asset_NFY__c, Asset_PFY__c FROM Oblix_Project_Assets__c WHERE Asset_PFY__c in: id_original_assets
            // clone sow  result: SELECT Cloned_Asset__c, Original_Asset__c FROM Oblix_SOW_Projects__c WHERE Original_Asset__c in: id_original_assets

            // update the original SOWs with the id of cloned SOWs
            for (Oblix_Project_Assets__c asset: database.query(query_string2)){
                //clon: map_original_id_original_asset.get(asset.Original_Asset__c).Cloned_Asset__c = asset.Id;
                //sync: map_original_id_original_asset.get(asset.Asset_PFY__c).Asset_NFY__c = asset.Id;
                map_original_id_original_asset.get((Id) asset.get(job_component.attrib_5)).put(job_component.attrib_4,asset.Id);
            }

            if (is_success){
                update map_original_id_original_asset.values();
            }

        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAssets() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  


    }


    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  Need to sync the assets and add against the Campaign for NFY
                    there can be assets which changed quantity/added/removed
    ********************************************************************************/
    public static boolean syncAssetsDuringTransitionPeriod(Oblix_syncBatchJob.JobComponent job_component){
        
      Boolean is_success = true;
        try{


            //##########################################################################################
            //    query the correct records in scope, sync and add to list to insert
            //##########################################################################################
            //      attrib_1: Campaign_PFY__c
            //      attrib_2: Campaign_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: Asset_NFY__c
            //      attrib_5: Asset_PFY__c

            String result_msg ='';

            result_msg += '\n\n\n started syncAssetsDuringTransitionPeriod';

            String step_name = 'sync assets';

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject(ASSET_OBJECT),',');
            query_string += ' FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Sync_Status__c =\'' + job_component.attrib_3; 
            
            // exclude the NFY records
            query_string += '\' AND Agency_Projects__r.Financial_year__r.SOW_NFY__c <> NULL ';
            query_string += ' AND Agency_Projects__r.Sync_Step__c <> \'' + step_name + ORDER_BY_SOQL + job_component.query_limit; 

            // OLD IMPLEMENTATION
            //query_string += '\' AND (Agency_Projects__r.Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES ;
            //query_string += '\' OR Agency_Projects__r.Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_REJECTED_BY_AGENCY; 
            //query_string += '\' OR Agency_Projects__r.Financial_Year__r.SOW_Status__c =  \'' + Oblix_Utils.SOW_STATUS_REJECTED_BY_UNILEVER;
            //query_string +=  '\') AND Agency_Projects__r.Sync_Step__c <> \'' + step_name + ORDER_BY_SOQL + job_component.query_limit; 

            result_msg += '\n\n\n query_string: ' + query_string;

            Map<Id, Oblix_Project_Assets__c> map_original_ids_to_original = new Map<Id,Oblix_Project_Assets__c>();
            Set<Id> set_original_ids =  new Set<Id>();
            Set<Id> set_original_parent_ids = new Set<Id>();

            for (Oblix_Project_Assets__c asset : database.query(query_string)){
                map_original_ids_to_original.put(asset.Id, asset);
                set_original_ids.add(asset.Id);
                set_original_parent_ids.add(asset.Agency_Projects__c);
            }


            result_msg += '\n query1 result rows: ' + set_original_ids.size() + ' - set_original_parent_ids: ' + JSON.serialize(set_original_parent_ids);

            // get the NFY related records for the selected parent campaign Ids
            String query_string2 = SELECT_SOQL;
            query_string2 += String.join(Oblix_Utils.getfieldsByObject(ASSET_OBJECT),',');
            query_string2 += ' FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Campaign_PFY__c in: set_original_parent_ids ORDER BY Id '; 
            
            result_msg += '\n query2: ' + query_string2;

            Map<Id, Oblix_Project_Assets__c> map_original_ids_to_cloned = new Map<Id,Oblix_Project_Assets__c>();
            for (Oblix_Project_Assets__c cloned_asset: database.query(query_string2)){
                map_original_ids_to_cloned.put(cloned_asset.Asset_PFY__c,cloned_asset );
            }

            result_msg += '\n query2 result rows: ' + map_original_ids_to_cloned.size();



            Set<Id> set_cloned_campaign_pfy_ids = new Set<Id>();
            // get the NFY related records for the selected parent campaign Ids
            String query_string3 = 'SELECT Campaign_PFY__c FROM Oblix_SOW_Projects__c WHERE Campaign_PFY__c in: set_original_parent_ids ORDER BY Id '; 
            
            result_msg += '\n query3: ' + query_string3;
            for (Oblix_SOW_Projects__c cloned_campaign: database.query(query_string3)){
                set_cloned_campaign_pfy_ids.add(cloned_campaign.Campaign_PFY__c);
            }

            // scenarios:
            //  1- PFY asset is newly created: create a clone of it for the NFY
            //  2- PFY and NFY are created but require syncing - quantity changed
            //  3- PFY asset deleted therefore delete it from NFY 

            Map<Id, Oblix_Project_Assets__c> map_assets_to_delete = new Map<Id, Oblix_Project_Assets__c>();
            Map<Id, Oblix_Project_Assets__c> map_assets_to_update = new Map<Id,Oblix_Project_Assets__c>();
            List<Oblix_Project_Assets__c> list_assets_to_clone = new List<Oblix_Project_Assets__c>();

            // this map is used to copy over values from original to cloned assets
            Map<String, Schema.SObjectField> map_name_and_field = Oblix_Utils.fetchAllFieldsForObject(ASSET_OBJECT);


            for (Oblix_Project_Assets__c asset: map_original_ids_to_original.values()){
                result_msg += '\n\n\n **** asset.mdm_id: ' + asset.mdm_id__c 
                    + ' - asset.quantity: ' + asset.Quantity__c + ' - asset: ' + JSON.serialize(asset);
                
                // ensure the NFY Campaign exists - campaigns which are 100% or cancelled will not have a NFY record!
                if(!map_original_ids_to_cloned.containsKey(asset.id) && set_cloned_campaign_pfy_ids.contains(asset.Agency_Projects__c)){
                    //  1- PFY asset is newly created: create a clone of the for the NFY
                    

                    Oblix_Project_Assets__c cloned_asset = asset.clone(false, true, false, false);
                    cloned_asset.put(job_component.attrib_5,asset.Id);
                    // set the parent of new asset to be under the cloned campaign (cloned/NFY)
                    cloned_asset.Agency_Projects__c = (Id) asset.get(job_component.attrib_2);
                    cloned_asset.Campaign_ID__c = (String) asset.get(job_component.attrib_2);
                    list_assets_to_clone.add(cloned_asset);
                    
                    result_msg += '\n\n\n to clone - campaign_id ' + cloned_asset.Campaign_ID__c + ' - Agency_Projects__c: ' + cloned_asset.Agency_Projects__c;

                }
                else if(NULL != map_original_ids_to_cloned && map_original_ids_to_cloned.containsKey(asset.id)){
                    //  2- PFY and NFY are created but require syncing

                    Oblix_Project_Assets__c cloned_asset = map_original_ids_to_cloned.get(asset.id);

                    // sync all existing fields from CFY to NFY
                    setAllFieldsDuringSync(asset, cloned_asset,map_name_and_field,true);

                    // set the correct campaign id field as above would have overwritten it
                    cloned_asset.Campaign_ID__c = (String) asset.get(job_component.attrib_2);

                    map_assets_to_update.put(cloned_asset.Id, cloned_asset);
                    
                    result_msg += RESULT_MSG_PREFIX + cloned_asset.name;

                }

                asset.Sync_Step__c = step_name;
            }

            result_msg += RESULT_MSG_PREFIX + map_assets_to_update.size() + ' - to clone: ' + list_assets_to_clone.size() 
                + ' - to delete: ' + map_assets_to_delete.size();
            //Oblix_SyncBatchJob.addEvent('DEBUG IN syncAssetsDuringTransitionPeriod() - result_msg: ' + result_msg,NULL);

            insert list_assets_to_clone;

            // need to update original record and add the NFY lookups for newly created clones
            String query_string4 = SELECT_SOQL + job_component.attrib_4 + ', ' + job_component.attrib_5 + ' FROM Oblix_Project_Assets__c WHERE ' + job_component.attrib_5 + ' in :set_original_ids ';
            // initial sync result: SELECT Asset_NFY__c, Asset_PFY__c FROM Oblix_Project_Assets__c WHERE Asset_PFY__c in: set_original_ids

            // update the original SOWs with the id of cloned SOWs
            for (Oblix_Project_Assets__c asset: database.query(query_string4)){
                //sync: map_original_ids_to_original.get(asset.Asset_PFY__c).Asset_NFY__c = asset.Id;
                map_original_ids_to_original.get((Id) asset.get(job_component.attrib_5)).put(job_component.attrib_4,asset.Id);
            }

            update map_original_ids_to_original.values();

            // loop through NFY assets and if no match found in PFY collection then delete
            for (Oblix_Project_Assets__c asset: map_original_ids_to_cloned.values()){
                
                if (!map_original_ids_to_original.containsKey(asset.Asset_PFY__c)){
                    //  3- PFY asset deleted therefore delete it from NFY 
                    map_assets_to_delete.put(asset.Id, asset);
                }

            }

            

            result_msg += RESULT_MSG_PREFIX + map_assets_to_update.size() + ' - to clone: ' + list_assets_to_clone.size() 
                + ' - to delete: ' + map_assets_to_delete.size();


            delete map_assets_to_delete.values();

            update map_original_ids_to_original.values();

            update map_assets_to_update.values();
    

            //#################################################
            //  SET STEP NAME TO SYNC COMPLETE
            //#################################################
            List<Oblix_SOW_Projects__c> list_campaigns_to_set_processed_flag = [SELECT Sync_Step__c FROM Oblix_SOW_Projects__c WHERE Id in: set_original_parent_ids];
            setProcessingFlag(list_campaigns_to_set_processed_flag,Oblix_syncBatchJob.SYNC_STEP_FIELD, step_name );

            Oblix_SyncBatchJob.addEvent('DEBUG IN syncCampaignDuringTransitionPeriod() - result_msg: ' + result_msg,NULL);
            
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  


    }


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
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            Set<Id> processed_ids = Oblix_SyncBatchJob.sync_job.processed_non_campaign_ids;

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneNonCampaigns() - ' + processed_ids.size() + ' - processed_ids: ' + JSON.serialize(processed_ids),NULL);

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Marketing_Basics__c'),',');
            query_string += ' FROM  Marketing_Basics__c WHERE Oblix_SOWMarketing__r.Sync_Status__c =\'' + job_component.attrib_1 + '\' AND Id NOT in: processed_ids ORDER BY Id LIMIT ' + job_component.query_limit; 

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneNonCampaigns - query_string: ' + query_string,NULL);
            //system.debug(Oblix_SyncBatchJob.sync_job.process_result);

            
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

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneNonCampaigns() - ' + list_non_campaigns_to_clone.size() + ' - list_non_campaigns_to_clone: ' + JSON.serialize(list_non_campaigns_to_clone),NULL);

            insert list_non_campaigns_to_clone;
            
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
            //      attrib_1: Original_SOW__c
            //      attrib_2: Cloned_SOW__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_4: original status

            // initial sync:
            //      attrib_1: SOW_PFY__c
            //      attrib_2: SOW_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: original status
            //##########################################################################################
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            Set<Id> processed_ids = Oblix_SyncBatchJob.sync_job.processed_attachment_ids;

            String result_msg = '\n\n--- processing cloneAttachments ';
            result_msg += '\n\ncloneAttachments() - ' + processed_ids.size() + ' - processed_ids: ' + JSON.serialize(processed_ids);

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Attachment'),',');
            query_string += ' FROM  Attachment WHERE ParentId in (SELECT id from Marketing_SOW__c WHERE Sync_Status__c =\'' + job_component.attrib_3 + '\' AND Attachments_Cloned__c = false) AND Id NOT in: processed_ids ORDER BY ParentId LIMIT ' + job_component.query_limit; 


            Map<Id, Attachment> map_attachments_to_clone = new Map<Id, Attachment>();
            Set<Id> set_cloned_parent_id = new Set<Id>();

            for (Attachment attch: Database.query(query_string)){
                map_attachments_to_clone.put(attch.Id, attch);
                set_cloned_parent_id.add(attch.ParentId);
            }

            Map<Id, Marketing_SOW__c> map_parents_to_update = new Map<Id, Marketing_SOW__c>(
                (List<Marketing_SOW__c>)[SELECT Attachments_Cloned__c FROM Marketing_SOW__c WHERE Id in: set_cloned_parent_id]);

            String query_string2 = 'SELECT ' + job_component.attrib_1 + ', ' + job_component.attrib_2 + ' FROM Marketing_SOW__c WHERE Id in: set_cloned_parent_id ';
            Map<Id,Marketing_SOW__c> map_original_to_cloned = new Map<Id, Marketing_SOW__c>((List<Marketing_SOW__c>)
                (Database.query(query_string2)));

            result_msg += '\n\nmap_original_to_cloned() - ' + map_original_to_cloned.size() + ' - map_original_to_cloned: ' + JSON.serialize(map_original_to_cloned);

            List<Attachment> list_attachments_to_clone = new List<Attachment>();

            for (Attachment attch: map_attachments_to_clone.values()){
                

                Attachment cloned_attch = attch.clone(false, true, false, false);
                cloned_attch.ParentId = (Id) map_original_to_cloned.get(attch.ParentId).get(job_component.attrib_2);
    
                //Oblix_SyncBatchJob.addEvent('INFO IN cloneAttachments() - RECALCULATE PARENT: ' + (String) map_original_to_cloned.get(attch.ParentId).get(job_component.attrib_2),NULL);

                list_attachments_to_clone.add(cloned_attch);

                // add id to processed collection to avoid reprocessing
                Oblix_SyncBatchJob.sync_job.processed_attachment_ids.add(attch.Id);

            }

            result_msg += '\n\ncloneAttachments() - ' + list_attachments_to_clone.size() + ' - list_attachments_to_clone: ' + JSON.serialize(list_attachments_to_clone);
            Oblix_SyncBatchJob.addEvent(result_msg,NULL);


            Database.insert(list_attachments_to_clone, false);
            

        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAttachments() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success; 

    }

=======
/*****************************************************************************************
* @author       Execloud ©
* @date         2016-04-25
* @description  Apex class contains the logic for rollover process and keeping the
*               campaigns and assets in sync
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Execloud ©             2016-04-25          Created
*
******************************************************************************************/
public with sharing class Oblix_SOWRollOverLogic {

    

    public Oblix_SOWRollOverLogic() {
        
    }

    private static final String SOW_OBJECT = 'Oblix_SOW_Projects__c';
    private static final String ASSET_OBJECT = 'Oblix_Project_Assets__c';

    private static final String ERROR_SETPROCESSINGFLAG = 'ERROR IN setProcessingFlag() - ';
    private static final String STACK_TRACE = ' - STACK TRACE: ';
    private static final String SELECT_SOQL = 'SELECT ';
    private static final String SOQL_AND = '\' AND ';
    //private static final String EXCLUDE_SYNC_STEP_SOQL = '\' AND Sync_Step__c <> \'';
    private static final String ORDER_BY_SOQL = '\' ORDER BY Id LIMIT ';
    private static final String RESULT_MSG_PREFIX = '\n\n\n to update: ';
    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Decides which function to call depending on the process_name
                    passed in value
    *********************************************************************/
    public static void processStep(Oblix_syncBatchJob.JobComponent job_component){

        //system.debug('## process step: ' + job_component);
        
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
        else if(Oblix_Utils.JOB_PROCESS_SET_PROCESSING_FLAG == job_component.process_name){
            is_success = setProcessingFlag(job_component);
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
        else if(Oblix_Utils.JOB_PROCESS_RECALCULATE_FEES_PFY == job_component.process_name){
            is_success = recalculateTotalPFYCampaignFeesUsingCFYcalculator(job_component);
        }
        else if(Oblix_Utils.JOB_PROCESS_SYNC_ASSETS == job_component.process_name){
            is_success = syncAssetsDuringTransitionPeriod(job_component);
        }
        

        // update the batch job component with the status
        Oblix_SyncBatchJob.sync_job.job_has_error = !is_success;

    }


    ///********************************************************************
    //* @author       Execloud ©
    //* @date         2016-05-04
    //* @description  Depending on the passed in object and attributes 
    //                set the status of sObject from A to B
    //*********************************************************************/
    //public static boolean setAttachmentClonedFlag(Oblix_syncBatchJob.JobComponent job_component){

    //    Boolean is_success = true;
    //    try{

    //        // job component attribute list
    //        //      attrib_1: sync status
    //        //      attrib_2: attachment_cloned value to be set true/false
    //        //      attrib_3: original sow status
    //        //##########################################################################################
    //        //  query the correct records in scope, set the status of the sync
    //        //##########################################################################################

    //        String query_string = 'SELECT Attachments_Cloned__c FROM Marketing_SOW__c WHERE Sync_Status__c =\'' + job_component.attrib_1; 
    //        query_string += '\' AND SOW_Status__c =  \'' + job_component.attrib_3 + '\'';
    //        query_string += ' AND Attachments_Cloned__c <>  ' + job_component.attrib_2 + ' ORDER BY Id LIMIT ' + job_component.query_limit; 
            


    //        Map<Id, Marketing_SOW__c> map_sows_update = new Map<Id, Marketing_SOW__c>();

    //        for (Marketing_SOW__c sow: database.query(query_string)){
    //            sow.Attachments_Cloned__c = Boolean.valueOf(job_component.attrib_2);
    //            map_sows_update.put(sow.Id, sow);
    //        }

    //        update map_sows_update.values();
            
    //    }
    //    catch(QueryException queryEx){  
    //        Oblix_SyncBatchJob.addEvent('ERROR IN setAttachmentClonedFlag() - ', queryEx.getMessage() + STACK_TRACE + queryEx.getStackTraceString());
    //        is_success = false;
    //    }
    //    catch(DmlException dmlEx){  
    //        Oblix_SyncBatchJob.addEvent('ERROR IN setAttachmentClonedFlag() - ', dmlEx.getMessage() + STACK_TRACE + dmlEx.getStackTraceString());
    //        is_success = false;
    //    }
    //    catch(Exception ex){  
    //        Oblix_SyncBatchJob.addEvent('ERROR IN setAttachmentClonedFlag() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
    //        is_success = false;
    //    }
    //    return is_success;   
    //}

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Depending on the passed in object and attributes 
                    set the status of sObject flag
    *********************************************************************/
    public static boolean setProcessingFlag(Oblix_syncBatchJob.JobComponent job_component){

        Boolean is_success = true;
        try{

            // job component attribute list
            //      attrib_1: sync status
            //      attrib_2: attachment_cloned/attribute updated? value to be set true/false
            //      attrib_3: original status
            //      attrib_4: object type
            //      attrib_5: field used for flag
            //      attrib_6: field used for checking sow status (either Financial_Year__r.SOW_Status__c or SOW_Status__c)
            //      
            //##########################################################################################
            //  query the correct records in scope, set the status of the sync
            //##########################################################################################

            String query_string = 'SELECT ' + job_component.attrib_5 + ' FROM ' + job_component.attrib_4 + ' WHERE Sync_Status__c =\'' + job_component.attrib_1; 
            
            if (NULL != job_component.attrib_6){
                query_string += SOQL_AND + job_component.attrib_6 + ' = \'' + job_component.attrib_3 + '\'';
            }
            else{
                query_string += '\'';
            }
            
            // depending on if the value is a boolean or string build the correct query string
            if (Oblix_SyncBatchJob.TRUE_VALUE == job_component.attrib_2 || Oblix_SyncBatchJob.FALSE_VALUE == job_component.attrib_2){
                query_string += ' AND ' + job_component.attrib_5 + ' <>  ' + job_component.attrib_2 + ' ORDER BY Id LIMIT ' + job_component.query_limit; 
            }
            else{
                query_string += ' AND ' + job_component.attrib_5 + ' <> \'' + job_component.attrib_2  + '\' ORDER BY Id LIMIT ' + job_component.query_limit; 
            }

            Oblix_SyncBatchJob.addEvent('INFO IN setProcessingFlag() - query_string: ' + query_string, NULL);

            Map<Id, sObject> map_objects_to_update = new Map<Id, sObject>((List<sObject>)(database.query(query_string)));

            setProcessingFlag(map_objects_to_update.values(), job_component.attrib_5, job_component.attrib_2);
            
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent(ERROR_SETPROCESSINGFLAG, ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;   
    }


    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Depending on the passed in object and attributes 
                    set the status of sObject flag
    *********************************************************************/
    public static boolean setProcessingFlag(List<sObject> list_objects_to_update, String field_to_update, String value_for_update ){

        Boolean is_success = true;
        try{


            Map<Id, sObject> map_objects_to_update = new Map<Id, sObject>();

            for (sObject obj: list_objects_to_update){

                // if the passed in value is in the form of TRUE/FALSE then set the value as a boolean instead of string
                if (Oblix_SyncBatchJob.TRUE_VALUE == value_for_update || Oblix_SyncBatchJob.FALSE_VALUE == value_for_update){
                    obj.put(field_to_update, Boolean.valueOf(value_for_update));
                }
                else
                {
                    obj.put(field_to_update, value_for_update);   
                }
                map_objects_to_update.put(obj.Id, obj);
            }

            update map_objects_to_update.values();
            
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent(ERROR_SETPROCESSINGFLAG, ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;   
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
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            //##########################################################################################
            //  query the correct records in scope, set the status of the sync, add to list and update
            //##########################################################################################

            // queries examples:
            // 
            // when at parent sow level and setting children campaign statuses
            // 1) SELECT Sync_Status__c FROM Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c  = 'Sync In Prgoress' 
            //      AND Sync_Status__c <> 'Sync In Prgoress'  ORDER BY Id LIMIT 1000
            
            // when at individual campaign level
            // 2) SELECT Sync_Status__c FROM Marketing_SOW__c WHERE Sync_Status__c  = 'Sync Requested'
            //      AND Sync_Status__c <> 'Sync In Prgoress'  ORDER BY Id LIMIT 1000


            String query_string = 'SELECT Sync_Status__c FROM '+ job_component.attrib_3 +' WHERE '+ job_component.attrib_4 +' =\'' + job_component.attrib_1; 
            query_string += '\' AND Sync_Status__c <> \'' + job_component.attrib_2 + ORDER_BY_SOQL + job_component.query_limit; 
            


            Map<Id, SObject> map_objects_update = new Map<Id, SObject>();
            Set<Id> set_original_ids = new Set<Id>();

            for (SObject obj: database.query(query_string)){
                obj.put('Sync_Status__c',job_component.attrib_2);
                map_objects_update.put(obj.Id, obj);
                set_original_ids.add(obj.Id);
            }

            //Oblix_SyncBatchJob.addEvent(' adjust status query: ' + query_string + '\nResult size: ' + map_objects_update.size(),NULL);

            // when sync is in progress, also make sure that the records being synced are "locked" by setting the status to "In Progress"
            
            if (String.isNotBlank(job_component.attrib_5)){
                /*String query_string2 = 'SELECT Sync_Status__c FROM '+ job_component.attrib_3 +' WHERE Sync_Status__c =\'' + job_component.attrib_1 
                    + SOQL_AND + job_component.attrib_5 +' in : set_original_ids AND Id NOT in: set_original_ids ' 
                    + ' ORDER BY Id LIMIT ' + job_component.query_limit; */
                for (SObject obj: database.query(query_string)){
                    obj.put('Sync_Status__c',job_component.attrib_2);
                    map_objects_update.put(obj.Id, obj);
                }
            }

            update map_objects_update.values();
            
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
        //  2.1- original_sow is (Approved) 
        //  2.2- cloned_sow - clone is (Live) 

        // 'initial sync'
        // 3- (Live) will then go through initiate rollover
        //  3.1- original_sow remains (Live) 
        //  3.2- cloned_sow - FY is incremented by +1 year - (Live)

        // 'taken care of by approval process
        // 4- (Live) will then go EOY approval
        //  4.1- original_sow is (Finalised) 
        //  4.2- cloned_sow remains (Live) 


        // 'version control2'
        // 4- (Live) will then go through initial approval
        //  4.1- original_sow is (Approved2) 
        //  4.2- cloned_sow - clone becomes (Live2) 

        if (Oblix_Utils.PROCESS_TYPE_INITIAL_APPROVAL == job_component.attrib_6){
            
            // this must be initial approval
            original_sow.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_APPROVED;
            cloned_sow.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_LIVE;
            cloned_sow.Initial_Approval_Complete__c = true;
            cloned_sow.SOW_Status__c = Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES;
        }
        else{
            // this must be initial rollover process
            Integer financial_year = Oblix_SOWHandlerLogic.getFinancialYear(original_sow);

            // increment financial year by +1 year
            financial_year ++;

            cloned_sow.Financial_Year__c = Oblix_Utils.FY_PREFIX + financial_year;
            cloned_sow.Initial_Approval_Complete__c = false;
            cloned_sow.SOW_Status__c = Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER;

            // clear out name suffix for sows being rolled over
            cloned_sow.Name_Suffix__c = '';

        }

    } 


    private static void setCampaignNameSuffix(Oblix_SOW_Projects__c original_campaign,Oblix_SOW_Projects__c cloned_campaign, Oblix_syncBatchJob.JobComponent job_component){

        // stages
        // 1- when campaign is created from scratch it has blank suffix
        
        // 'version control'
        // 2- it will then go through initial approval
        //  2.1- original_campaign is (Approved) 
        //  2.2- cloned_campaign - clone is (Live) 

        // 'initial sync'
        // 3- (Live) will then go through initiate rollover
        //  3.1- original_campaign remains (Live) 
        //  3.2- cloned_campaign - clone is (B/Fwd) 

        // 'taken care of by a trigger/flow
        // 4- (Live) will then go EOY approval
        //  4.1- original_campaign is (Finalised) 
        //  4.2- cloned_campaign remains (B/Fwd) 


        // 'version control'
        // 4- (B/Fwd) will then go through initial approval
        //  4.1- original_campaign is (Approved2) 
        //  4.2- cloned_campaign - clone becomes (Live2) 

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
    private static void setAllFieldsDuringSync(SObject original_object, SObject cloned_object
        , Map<String, Schema.SObjectField> map_name_and_field, Boolean should_update_stage){

        // copy over all fields from PFY to NFY campaigns 
        for (String field_name : map_name_and_field.keySet()){  

            Schema.SObjectField sf = map_name_and_field.get(field_name);
            String field_type = String.valueOf(sf.getDescribe().getType()).toUpperCase();
            Boolean is_editable = sf.getDescribe().isUpdateable();

            // don't overwrite campaign stage fields if campaign attributes are not changed
            if (('Projected_Stage_CFY__c' == field_name && !should_update_stage)
                ||
                ('Projected_Stage_PFY__c' == field_name && !should_update_stage)   
                ){
                cloned_object.put(field_name, (String) cloned_object.get(field_name));
            }
            else if(is_editable){

                //Oblix_SyncBatchJob.addEvent('INFO IN setAllFieldsOnCampaignsRollOver - field_type: ' + field_type + ' - field_name: ' 
                    //+ field_name,NULL);

                if('BOOLEAN' == field_type){
                    cloned_object.put(field_name, (Boolean) original_object.get(field_name));
                }
                else if('DOUBLE' == field_type || 'CURRENCY' == field_type || 'PERCENT' == field_type){
                    cloned_object.put(field_name, (Decimal) original_object.get(field_name));
                }
                else if('INTEGER' == field_type){
                    cloned_object.put(field_name, (Integer) original_object.get(field_name));
                }
                else if('REFERENCE' == field_type || 'ID' == field_type){
                    //cloned_object.put(field_name, (Id) original_object.get(field_name));
                    // Id and reference fields are handeled separately in the syncCampaign method, don't reset them here!
                    cloned_object.put(field_name, (Id) cloned_object.get(field_name));
                }
                else if('DATE' == field_type){
                    cloned_object.put(field_name, (Date) original_object.get(field_name));
                }
                else if('DATETIME' == field_type){
                    cloned_object.put(field_name, (Datetime) original_object.get(field_name));
                }
                else{
                    // 'STRING' , 'EMAIL' , 'TEXTAREA' , 'PICKLIST' , 'MULTIPICKLIST'
                    cloned_object.put(field_name, (String) original_object.get(field_name));
                }

                
            }
        }
    }


    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  Set the financial fields on campaign from PFY to NFY
    *********************************************************************/
    private static void setFinancialFieldsOnCampaignsRollOver(Oblix_SOW_Projects__c original_campaign, Oblix_SOW_Projects__c cloned_campaign){

        // copy over the Progress Stage and box number to PFY
        cloned_campaign.Campaign_PFY__c = original_campaign.Id;


        // S.M. 2016-05-19 - in a scenario where actual campaign attributes haven't been updated but an asset has been added to PFY campaign, we don't want to
        // overwrite the chevron but should update other financial fields
        if (original_campaign.Campaign_Attributes_Updated__c){
            cloned_campaign.Projected_Stage_PFY__c = getUnionCurrentAndPastStages(original_campaign, 'Projected_Stage_CFY__c','Projected_Stage_PFY__c'); //original_campaign.Projected_Stage_CFY__c;
        }
        cloned_campaign.Completed_Stage_PFY__c = getUnionCurrentAndPastStages(original_campaign, 'Completed_Stage_CFY__c','Completed_Stage_PFY__c'); // original_campaign.Completed_Stage_CFY__c;
        
        cloned_campaign.Total_Project_Score_PFY__c = original_campaign.Total_Project_Score__c ;
        cloned_campaign.Fees_Paid_PFY__c = original_campaign.Value_to_be_paid_in_Current_FY__c;
        cloned_campaign.Fees_Total_PFY__c = original_campaign.Campaign_Total_Fees__c;

        cloned_campaign.Percentage_of_Fees_PFY__c = NULL != original_campaign.Percentage_of_Fees_PFY__c
            ? original_campaign.Percentage_of_Fee_for_this_FY__c + original_campaign.Percentage_of_Fees_PFY__c
            : original_campaign.Percentage_of_Fee_for_this_FY__c;
        
        // S.M. 2016-05-19 - in a scenario where actual campaign attributes haven't been updated but an asset has been added to PFY campaign, we don't want to
        // overwrite the chevron but should update other financial fields
        if (original_campaign.Campaign_Attributes_Updated__c){
            // select all projected stages by default when initiating rollover process
            cloned_campaign.Projected_Stage_CFY__c = getDeltaCurrentAndPastStages(cloned_campaign,'Projected_Stage_PFY__c');
        }

        // set the remaining value for this FY
        if (NULL != cloned_campaign.Percentage_of_Fees_PFY__c){
            cloned_campaign.Percentage_of_Fee_for_this_FY__c = 100 - cloned_campaign.Percentage_of_Fees_PFY__c;
        }else{
            cloned_campaign.Percentage_of_Fee_for_this_FY__c = 100;
        }

        cloned_campaign.Oblix_ProjectBoxNumber_PFY__c = original_campaign.Oblix_ProjectBoxNumber__c ;
    }

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-05-04
    * @description  To maintain the logic for chevron, we need to combine the 
                    stages from CFY and PFY and stamp on PFY field of the following
                    financial year campaign - this is done for both completed and projected stage
    *********************************************************************/
    public static String getDeltaCurrentAndPastStages(Oblix_SOW_Projects__c cloned_campaign, String pfy_field){
       
        Set<String> set_delta = new Set<String>();
        String delta_stages = '';
        List<String> list_all_stages = new List<String>();
        List<String> list_stages_retrieved = new List<String>();
        String separator = ';';

        String result = '';

        // create a full list
        if (String.isNotBlank(Oblix_Utils.CAMPAIGN_STAGES_ALL)){

            list_all_stages = Oblix_Utils.CAMPAIGN_STAGES_ALL.split(separator);
            result += '\nlist_all_stages: ' + JSON.serialize(list_all_stages);
        }

        set_delta.addAll(list_all_stages);


        String past_stages = (String) cloned_campaign.get(pfy_field);
        result += '\npast_stages: ' + past_stages;
        // get completed stages for last year
        if (String.isNotBlank(past_stages)){

            list_stages_retrieved = past_stages.split(separator);
            result += '\nlist_stages_retrieved: ' + JSON.serialize(list_stages_retrieved);

            for (String stage_name: list_stages_retrieved){
                result += '\nstage_name: ' + stage_name;
                set_delta.remove(stage_name);
            }
        }

        // copy to a list to allow building ';' separated string
        List<String> list_delta_stages = new List<String>(); 
        list_delta_stages.addAll(set_delta);
        
        result += '\nlist_union_stages: ' + JSON.serialize(list_delta_stages);

        if (!list_delta_stages.isEmpty()){
            // build the semi-colon separated values to re-assign
            delta_stages = String.join(list_delta_stages, separator);
        }
        result += '\nunion_stages: ' + delta_stages;
        //system.debug(result);
        return delta_stages;
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
        //system.debug(result);
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
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            // clone sow:
            //      attrib_1: Original_SOW__c
            //      attrib_2: Cloned_SOW__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_6: Process type - initial approval

            // initial sync:
            //      attrib_1: SOW_PFY__c
            //      attrib_2: SOW_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_6: Process type - initial sync

            //Oblix_SyncBatchJob.addEvent(' Campaign to clone size: ' + list_campaigns_to_clone.size(),NULL);

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Marketing_SOW__c'),',');
            query_string += ' FROM  Marketing_SOW__c WHERE Sync_Status__c =\'' + job_component.attrib_3 + SOQL_AND + job_component.attrib_2 + ' = NULL ORDER BY Id LIMIT ' + job_component.query_limit; 
            
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

            Database.SaveResult[] list_database_save_result = Database.insert (list_sows_to_clone,false);
            
            is_success = processSaveResult(list_database_save_result,'Marketing_SOW__c',list_sows_to_clone);

            Set<Id> id_original_sows = map_original_id_original_campaign.keySet();
            String query_string2 = SELECT_SOQL + job_component.attrib_1 + ', ' + job_component.attrib_2 + ' FROM Marketing_SOW__c WHERE ' + job_component.attrib_1 + ' in :id_original_sows ';
            // initial sync result: SELECT SOW_NFY__c, SOW_PFY__c FROM Oblix_Project_Assets__c WHERE SOW_PFY__c in: id_original_sows
            // clone sow  result: SELECT Cloned_SOW__c, Original_SOW__c FROM Oblix_SOW_Projects__c WHERE Original_SOW__c in: id_original_sows

            // update the original SOWs with the id of cloned SOWs
            for (Marketing_SOW__c sow: database.query(query_string2)){
                //clon: map_original_id_original_campaign.get(sow.Original_SOW__c).Cloned_SOW__c = sow.Id;
                //sync: map_original_id_original_campaign.get(sow.SOW_PFY__c).NFY_SOW__c = sow.Id;
                map_original_id_original_campaign.get((Id) sow.get(job_component.attrib_1)).put(job_component.attrib_2,sow.Id);
            }

            if (is_success){
                update map_original_id_original_campaign.values();
            }
            
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneSOW() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;   
        
    }

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  builds a string of error message for a list Database.Error
    *********************************************************************/
    public static String buildErrorMessage(Database.Error[] errs){
        String errorMsg = '';
        // Operation failed, get all errors. What was the cause?                
        for(Database.Error err : errs){
           errorMsg = 'Status: ' + err.getStatusCode() + '\n';
           errorMsg +=  'Error: ' + err.getMessage() + '\n';
           errorMsg +=  'Field(s): ' + err.getFields() + '\n';

        }       
        return errorMsg;
    }


    /********************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  process list of save results
    *********************************************************************/
    public static Boolean processSaveResult(Database.SaveResult[] list_database_save_result, String object_type, List<sObject> records_to_process){

        Integer index_ref=0;
        Boolean is_success = true;

        Type t = Type.forName(object_type);

        for(Database.SaveResult ur : list_database_save_result){ 
            // found issue with saving the records
            if (!ur.isSuccess()){


                SObject original_record = (sObject) t.newInstance();
                original_record = records_to_process[index_ref];
                    
                Oblix_SyncBatchJob.addEvent('ERROR processing ' + object_type +' record with name: ' + original_record.get('Name') + ' \n' + buildErrorMessage(ur.getErrors()) + '\n\n' + JSON.serialize(original_record),NULL);
                is_success = false;
            }
            ++index_ref;
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
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            // clone campaign:
            //      attrib_1: Original_SOW__c
            //      attrib_2: Cloned_SOW__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_4: Cloned_Campaign__c
            //      attrib_5: Original_Campaign__c

            // initial sync:
            //      attrib_1: SOW_PFY__c
            //      attrib_2: SOW_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: Campaign_NFY__c
            //      attrib_5: Campaign_PFY__c

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject(SOW_OBJECT),',');
            query_string += ', (SELECT ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string += ' FROM  Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c =\'' + job_component.attrib_3 + SOQL_AND + job_component.attrib_4 + ' = NULL ORDER BY Id LIMIT ' + job_component.query_limit; 
            

            List<Oblix_SOW_Projects__c> list_campaigns_to_clone = new List<Oblix_SOW_Projects__c>();
            Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> map_original_id_splits_to_clone = new Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();
            List<Oblix_Marketing_SOW_Project_Splits__c> list_splits_to_clone = new List<Oblix_Marketing_SOW_Project_Splits__c>();

            Map<Id, Oblix_SOW_Projects__c> map_original_id_original_campaign = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string));


            for (Oblix_SOW_Projects__c campaign: map_original_id_original_campaign.values()){
                

                Oblix_SOW_Projects__c cloned_campaign = campaign.clone(false, true, false, false);
               
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

            //Oblix_SyncBatchJob.addEvent(' Campaign to clone size: ' + list_campaigns_to_clone.size(),NULL);
            //Oblix_SyncBatchJob.addEvent(' original size: ' + map_original_id_original_campaign.size(),NULL);


            //Oblix_SyncBatchJob.addEvent(' JSON to clone: ' + JSON.serialize(list_campaigns_to_clone),NULL);
            //Oblix_SyncBatchJob.addEvent(' JSON original: ' + JSON.serialize(map_original_id_original_campaign),NULL);


            Database.SaveResult[] list_database_save_result = Database.insert (list_campaigns_to_clone,false);
            
            is_success = processSaveResult(list_database_save_result,SOW_OBJECT,list_campaigns_to_clone);

            //Set<Id> id_original_campaigns = map_original_id_original_campaign.keySet();
            //String query_string2 = SELECT_SOQL + job_component.attrib_4 + ', ' + job_component.attrib_5 + ' FROM Oblix_SOW_Projects__c WHERE ' + job_component.attrib_5 + ' in :id_original_campaigns ';
            // initial sync result: SELECT Campaign_NFY__c, Campaign_PFY__c FROM Oblix_Project_Assets__c WHERE Campaign_PFY__c in: id_original_campaigns
            // clone campaign  result: SELECT Cloned_Campaign__c, Original_Campaign__c FROM Oblix_SOW_Projects__c WHERE Original_Campaign__c in: id_original_campaigns


            // update the original Campaigns with the id of cloned Campaigns and set the id on hub split records
            populateClonedRecordsWithIds(job_component.attrib_4,job_component.attrib_5,map_original_id_splits_to_clone, map_original_id_original_campaign,list_splits_to_clone);

            //for (Oblix_SOW_Projects__c campaign: database.query(query_string2)){
            //      // clone:   map_original_id_original_campaign.get(campaign.Original_Campaign__c).Cloned_Campaign__c = campaign.Id;
            //      // sync:    map_original_to_syncd_id.get(campaign.Campaign_PFY__c).Campaign_NFY__c = campaign.Id;

            //  map_original_id_original_campaign.get(job_component.attrib_5).put(job_component.attrib_4, campaign.Id);

            //  // adjust the parent Id of project split
            //  if (NULL != map_original_id_splits_to_clone && map_original_id_splits_to_clone.containsKey(campaign.Original_Campaign__c) 
            //      && NULL!= map_original_id_splits_to_clone.get(campaign.Original_Campaign__c) && map_original_id_splits_to_clone.get(campaign.Original_Campaign__c).size()>0){

            //      for (Oblix_Marketing_SOW_Project_Splits__c split_to_adjust: map_original_id_splits_to_clone.get(campaign.Original_Campaign__c)){
            //          split_to_adjust.Project_Splits__c = campaign.Id;
            //          list_splits_to_clone.add(split_to_adjust);
            //      }
            //  }
            //}

            if (is_success){
                update map_original_id_original_campaign.values();
            }

            // also clone the project splits
            if (!list_splits_to_clone.isEmpty() && is_success){
                insert list_splits_to_clone;
            }

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
        String query_string = SELECT_SOQL + clone_nfy_field + ', ' + original_pfy_field + ' FROM Oblix_SOW_Projects__c WHERE ' + original_pfy_field + ' <> NULL AND ' + original_pfy_field + ' in :id_original_campaigns ';
            
        // update the original Campaigns with the id of cloned Campaigns
        for (Oblix_SOW_Projects__c campaign: database.query(query_string)){
            // clone:   map_original_id_original_campaign.get(campaign.Original_Campaign__c).Cloned_Campaign__c = campaign.Id;
            // sync:    map_original_to_syncd_id.get(campaign.Campaign_PFY__c).Campaign_NFY__c = campaign.Id;

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
    * @description  this method recalculates campaign total fees by applying the 
                    calculator records of CFY - it can then work out the value paied in 
                    previous financial year using current FY calculator records to help
                    adjust value to be paid in current financial year

    *********************************************************************/
    public static boolean recalculateTotalPFYCampaignFeesUsingCFYcalculator(Oblix_syncBatchJob.JobComponent job_component){
        
        Boolean is_success = true;
        
        try{

            String result_msg = '';

            //##########################################################################################
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################
            // initial sync:
            //      attrib_1: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_2: 
            //      attrib_3: 
            //      attrib_4: 
            //      attrib_5: 
            //      attrib_6: 

            // step name is stamped on processed records to avoid reprocessing during the same batch job
            String step_name = 'recalculate campaign fees';

            String query_string = 'SELECT Total_Project_Score_PFY__c, Percentage_of_Fees_PFY__c, Fees_PFY_Total_By_CFY_Calculator__c, Fees_PFY_Paid_Using_CFY_Calc__c, Total_Value_Driver__c, ProjectTotalAssetscore__c ';
            query_string += ' ,Financial_Year__r.Financial_Year__c';
            query_string += ', (SELECT Project_Splits__r.Campaign_NFY__c, OblixCountry__r.Name, ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string += ' FROM  Oblix_SOW_Projects__c WHERE Sync_Status__c = \'' + job_component.attrib_1 + '\''; 
            
            // only get the cloned/NFY campaigns
            query_string += ' AND Financial_year__r.SOW_NFY__c = NULL AND Sync_Step__c <> \'' + step_name + ORDER_BY_SOQL + job_component.query_limit; 

            // OLD IMPLEMENTATION
            // only query the cloned campaigns here
            //query_string += ' AND Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER + EXCLUDE_SYNC_STEP_SOQL + step_name + ORDER_BY_SOQL + job_component.query_limit; 
            
            result_msg += '\nquery_string: ' + query_string;

            Map<Id, Oblix_SOW_Projects__c> map_ids_cloned_campaign = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string));
            Map<Id, Long> map_campaign_id_total_fee = Oblix_CalculatorLogic.getCampaignFee(map_ids_cloned_campaign, NULL,false,false, false, Oblix_Utils.TOTAL_PROJECT_SCORE_PFY_FILED);

            result_msg += '\n\nmap_ids_cloned_campaign size: ' + map_ids_cloned_campaign.size();

            for (Id campaign_id: map_ids_cloned_campaign.keySet()){

                Oblix_SOW_Projects__c campaign = map_ids_cloned_campaign.get(campaign_id);

                if (NULL != map_campaign_id_total_fee && map_campaign_id_total_fee.containsKey(campaign_id) 
                    && NULL != map_campaign_id_total_fee.get(campaign_id)){

                    // get total fees from the calculated map and assign to campaign
                    campaign.Fees_PFY_Total_By_CFY_Calculator__c = map_campaign_id_total_fee.get(campaign_id);

                    // calculate total fees paid in PFY by applying % paid last year
                    campaign.Fees_PFY_Paid_Using_CFY_Calc__c = campaign.Fees_PFY_Total_By_CFY_Calculator__c * campaign.Percentage_of_Fees_PFY__c / 100;


                }

                // set step name on processed campaign to avoid reprocessing it 
                campaign.Sync_Step__c = step_name;

            }
            result_msg += '\n\nmap_campaigns_to_update size: ' + map_ids_cloned_campaign.size();

            // update existing campaigns
            update map_ids_cloned_campaign.values();


            //Oblix_SyncBatchJob.addEvent('DEBUG IN recalculateTotalPFYCampaignFeesUsingCFYcalculator() - result_msg: ' + result_msg,NULL);


        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN recalculateTotalPFYCampaignFeesUsingCFYcalculator() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  
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

            String step_name = 'sync campaign';

            //##########################################################################################
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################
            // initial sync:
            //      attrib_1: SOW_NFY__c
            //      attrib_2: CAMPAIGN_PFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: 
            //      attrib_5: 
            //      attrib_6: Type of process
            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject(SOW_OBJECT),',');
            query_string += ', (SELECT Project_Splits__r.Campaign_NFY__c, ';
            query_string += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string += ' FROM  Oblix_SOW_Projects__c WHERE Sync_Status__c = \'' + job_component.attrib_3 + '\''; 
            // check for NFY lookup to exclude cloned/NFY records
            query_string += ' AND Financial_Year__r.SOW_NFY__c <> NULL ';
            query_string += ' AND Sync_Step__c <> \''  + step_name +  ORDER_BY_SOQL + job_component.query_limit; 

            // check for sow status to exclude the cloned/NFY records - OLD IMPLEMENTATION
            //query_string += ' AND (Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES;
            //query_string += '\' OR Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_REJECTED_BY_AGENCY;
            //query_string += '\' OR Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_REJECTED_BY_UNILEVER;

            //// in case it is a superuser or admin making changes to the record during the approval process
            //query_string += '\' OR Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL; 
            //query_string += '\' OR Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_REJECTED_BY_UNILEVER 
            
            
            // get the matching cloned campaigns to perform the sync

            result_msg += '\n query1: ' + query_string;
            
            Map<Id, Oblix_SOW_Projects__c> map_original_ids_to_original = new Map<Id,Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)database.query(query_string));
            Set<Id> set_original_ids = map_original_ids_to_original.keySet();

            result_msg += '\n query1 result rows: ' + set_original_ids.size() + ' - original campaign: ' + JSON.serialize(map_original_ids_to_original);

            String query_string2 = SELECT_SOQL;
            query_string2 += String.join(Oblix_Utils.getfieldsByObject(SOW_OBJECT),',');
            query_string2 += ', (SELECT Project_Splits__r.Campaign_NFY__c, ';
            query_string2 += String.join(Oblix_Utils.getfieldsByObject('Oblix_Marketing_SOW_Project_Splits__c'),',');
            query_string2 += ' FROM Marketing_SOW_Project_Splits__r)';
            query_string2 += ' FROM  Oblix_SOW_Projects__c WHERE Campaign_PFY__c in : set_original_ids'; 
            
            result_msg += '\n query2: ' + query_string2;

            Map<Id, Oblix_SOW_Projects__c> map_original_ids_to_cloned = new Map<Id,Oblix_SOW_Projects__c>();
            for (Oblix_SOW_Projects__c cloned_campaign: database.query(query_string2)){
                map_original_ids_to_cloned.put(cloned_campaign.Campaign_PFY__c,cloned_campaign );
            }

            result_msg += '\n query2 result rows: ' + map_original_ids_to_cloned.size() + ' - cloned campaign: ' + JSON.serialize(map_original_ids_to_cloned);

            // scenarios:
            //  1- PFY campaign is newly created: create a clone of the for the NFY
            //  2- PFY % projected is increased to 100% therefore need to remove from NFY 
            //  3- PFY and NFY are created but require syncing

            Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_delete = new Map<Id, Oblix_SOW_Projects__c>();
            Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_update = new Map<Id,Oblix_SOW_Projects__c>();
            List<Oblix_SOW_Projects__c> list_campaigns_to_clone = new List<Oblix_SOW_Projects__c>();
            Map<Id, Oblix_SOW_Projects__c> map_original_id_original_campaign = new Map<Id,Oblix_SOW_Projects__c>();

            // this map is used to copy over values from original to cloned campaigns
            Map<String, Schema.SObjectField> map_name_and_field = Oblix_Utils.fetchAllFieldsForObject(SOW_OBJECT);

            Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> map_original_id_splits_to_clone = new Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();

            // also need to sync all related non-campaign records
            List<Oblix_Marketing_SOW_Project_Splits__c> list_splits_to_clone = new List<Oblix_Marketing_SOW_Project_Splits__c>();
            Map<Id,Oblix_Marketing_SOW_Project_Splits__c> map_splits_to_delete = new Map<Id, Oblix_Marketing_SOW_Project_Splits__c>();



            for (Oblix_SOW_Projects__c campaign: map_original_ids_to_original.values()){
                result_msg += '\n\n\n **** campaign.Percentage_of_Fees_Paid_To_Date__c: ' + campaign.Percentage_of_Fees_Paid_To_Date__c 
                    + ' - campaign.Campaign_Status__c: ' + campaign.Campaign_Status__c + ' - campaign: ' + JSON.serialize(campaign);
                
                if(!map_original_ids_to_cloned.containsKey(campaign.id)
                    && 
                    (Integer.valueOf(campaign.Percentage_of_Fees_Paid_To_Date__c) < 100 && Oblix_Utils.CAMPAIGN_STATUS_CANCELLED != campaign.Campaign_Status__c)){
                    //  1- PFY campaign is newly created: create a clone of the for the NFY - if campaign is not cancelled and % is less than 100
                    
                    Oblix_SOW_Projects__c cloned_campaign = campaign.clone(false, true, false, false);
                    
                    map_original_id_original_campaign.put(campaign.Id, campaign);

                    // copy over the financial related fields from current_campaign to next_financial_year PFY fields
                    setFinancialFieldsOnCampaignsRollOver(campaign, cloned_campaign);

                    // manage the hub and splits
                    syncHubAndSplits(campaign, NULL, map_splits_to_delete, map_original_id_splits_to_clone);


                    cloned_campaign.put(job_component.attrib_2,campaign.Id);

                    // S.M. 2016-05-22 added a flag to replace the formula field due to platform issues
                    cloned_campaign.Is_B_Fwd_Campaign__c = true;

                    // set campaign suffix
                    setCampaignNameSuffix(campaign,cloned_campaign, job_component);

                    // reparent new campaign
                    cloned_campaign.Financial_Year__c = (Id) campaign.get(job_component.attrib_1);
                    // need to insert these
                    list_campaigns_to_clone.add(cloned_campaign);
                    
                    result_msg += '\n\n\n to clone: ' + cloned_campaign.name;

                }
                else if(
                    (Integer.valueOf(campaign.Percentage_of_Fees_Paid_To_Date__c) >= 100|| Oblix_Utils.CAMPAIGN_STATUS_CANCELLED == campaign.Campaign_Status__c)
                    &&
                    (NULL != map_original_ids_to_cloned && map_original_ids_to_cloned.containsKey(campaign.id))
                    ){
                    //  2- PFY % projected is increased to 100% or campaign got cancelled therefore need to remove from NFY 
                    
                    //// remove the link from the original campaign
                    //campaign.Campaign_NFY__c = NULL;
                    //map_campaigns_to_update.put(campaign.Id, campaign);

                        map_campaigns_to_delete.put(campaign.Campaign_NFY__c, map_original_ids_to_cloned.get(campaign.Id));
                        
                        result_msg += '\n\n\n to delete: ' + map_original_ids_to_cloned.get(campaign.Id).name; 
                    

                }
                else if(NULL != map_original_ids_to_cloned && map_original_ids_to_cloned.containsKey(campaign.id)){
                    //  3- PFY and NFY are created but require syncing

                    Oblix_SOW_Projects__c cloned_campaign = map_original_ids_to_cloned.get(campaign.id);


                    map_original_id_original_campaign.put(campaign.Id, campaign);

                    // sync all existing fields from CFY to NFY
                    setAllFieldsDuringSync(campaign, cloned_campaign,map_name_and_field, campaign.Campaign_Attributes_Updated__c);

                    // copy over the financial related fields from current_campaign to next_financial_year PFY fields
                    setFinancialFieldsOnCampaignsRollOver(campaign, cloned_campaign);

                    // manage the hub and splits
                    syncHubAndSplits(campaign, cloned_campaign, map_splits_to_delete, map_original_id_splits_to_clone);

                    // set campaign suffix
                    setCampaignNameSuffix(campaign,cloned_campaign, job_component);

                    map_campaigns_to_update.put(cloned_campaign.Id, cloned_campaign);
                    
                    result_msg += RESULT_MSG_PREFIX + cloned_campaign.name;

                }

                campaign.Sync_Step__c = step_name;
                map_campaigns_to_update.put(campaign.Id, campaign);

            }

            //result_msg += RESULT_MSG_PREFIX + map_campaigns_to_update.size() + ' - to clone: ' + list_campaigns_to_clone.size() 
            //    + ' - to delete: ' + map_campaigns_to_delete.size() + ' - splits to delete: ' + map_splits_to_delete.size()
            //    + ' - map_original_id_splits_to_clone: ' + map_original_id_splits_to_clone.size()
            //    + ' - splits to insert: ' + list_splits_to_clone.size();



            // insert new campaigns
            //if (!list_campaigns_to_clone.isEmpty()){
                insert list_campaigns_to_clone;
            //}


            // update the original Campaigns with the id of cloned Campaigns and set the id on hub split records
            populateClonedRecordsWithIds('Campaign_NFY__c','Campaign_PFY__c',map_original_id_splits_to_clone, map_original_id_original_campaign,list_splits_to_clone);

            result_msg += RESULT_MSG_PREFIX + map_campaigns_to_update.size() + ' - to clone: ' + list_campaigns_to_clone.size() 
                + ' - to delete: ' + map_campaigns_to_delete.size() + ' - splits to delete: ' + map_splits_to_delete.size()
                + ' - map_original_id_splits_to_clone: ' + map_original_id_splits_to_clone.size()
                + ' - splits to insert: ' + list_splits_to_clone.size()
                + ' - map_campaigns_to_update: ' + JSON.serialize(map_campaigns_to_update);

            Oblix_SyncBatchJob.addEvent('DEBUG IN syncCampaignDuringTransitionPeriod() - result_msg: ' + result_msg,NULL);

            // update the original campaigns NFY fields
            //if (!map_original_id_original_campaign.isEmpty()){
                update map_original_id_original_campaign.values();
            //}

            // update existing campaigns
            //if (!map_campaigns_to_update.isEmpty()){
                update map_campaigns_to_update.values();
            //}

            // insert new hub and splits
            //if (!list_splits_to_clone.isEmpty()){
                insert list_splits_to_clone;
            //}

            // S.M. Removing if statements to resolve sonar issues
            // delete the cloned campaigns which are 100%
            //if (!map_campaigns_to_delete.isEmpty()){
                delete map_campaigns_to_delete.values();
            //}

            // delete old hub and splits
            //if (!map_splits_to_delete.isEmpty()){
                delete map_splits_to_delete.values();
            //}


            Oblix_SyncBatchJob.addEvent('DEBUG IN syncCampaignDuringTransitionPeriod() - result_msg: ' + result_msg,NULL);


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

            if (NULL != original_split.Project_Splits__r.Campaign_NFY__c){
                // set the parent of campaign under NFY if the lookup is populated - in case of existing records
                cloned_split.Project_Splits__c = original_split.Project_Splits__r.Campaign_NFY__c;
            }

            map_original_id_splits_to_clone.get(original_split.Project_Splits__c).add(cloned_split);
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
            //      attrib_1: Original_Campaign__c
            //      attrib_2: Cloned_Campaign__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_4: Cloned_Asset__c
            //      attrib_5: Original_Asset__c

            // initial sync:
            //      attrib_1: Campaign_PFY__c
            //      attrib_2: Campaign_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: Asset_NFY__c
            //      attrib_5: Asset_PFY__c

            //##########################################################################################
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            String result_msg ='';

            result_msg += '\n\n\n started clonning assets';

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject(ASSET_OBJECT),',');
            query_string += ' FROM  Oblix_Project_Assets__c WHERE Agency_Projects__r.Sync_Status__c =\'' + job_component.attrib_3 + SOQL_AND + job_component.attrib_4 + ' = NULL '; 
            query_string += ' AND ' + job_component.attrib_2 + ' <> NULL ORDER BY Id LIMIT ' + job_component.query_limit; 

            result_msg += '\n\n\n query_string: ' + query_string;

            List<Oblix_Project_Assets__c> list_assets_to_clone = new List<Oblix_Project_Assets__c>();
            Map<Id, Oblix_Project_Assets__c> map_original_id_original_asset = new Map<Id,Oblix_Project_Assets__c>((List<Oblix_Project_Assets__c>)database.query(query_string));


            for (Oblix_Project_Assets__c asset: map_original_id_original_asset.values()){
                

                Oblix_Project_Assets__c cloned_asset = asset.clone(false, true, false, false);
                cloned_asset.put(job_component.attrib_5,asset.Id);
                // set the parent of new asset to be under the cloned campaign (cloned/NFY)
                cloned_asset.Agency_Projects__c = (Id) asset.get(job_component.attrib_2);
                cloned_asset.Campaign_ID__c = (String) asset.get(job_component.attrib_2);
                list_assets_to_clone.add(cloned_asset);
            }

            result_msg += '\n\n\n map_original_id_original_asset.size(): ' + map_original_id_original_asset.size();
            result_msg += '\n\n\n map_original_id_original_asset: ' + JSON.serialize(map_original_id_original_asset);
            result_msg += '\n\n\n list_assets_to_clone.size(): ' + list_assets_to_clone.size();
            result_msg += '\n\n\n list_assets_to_clone: ' + JSON.serialize(list_assets_to_clone);

            //Oblix_SyncBatchJob.addEvent('DEBUG IN cloneAssets() - result_msg: ' + result_msg,NULL);

            Database.SaveResult[] list_database_save_result = Database.insert (list_assets_to_clone,false);
            
            is_success = processSaveResult(list_database_save_result,ASSET_OBJECT,list_assets_to_clone);

            Set<Id> id_original_assets = map_original_id_original_asset.keySet();
            String query_string2 = SELECT_SOQL + job_component.attrib_4 + ', ' + job_component.attrib_5 + ' FROM Oblix_Project_Assets__c WHERE ' + job_component.attrib_5 + ' in :id_original_assets ';
            // initial sync result: SELECT Asset_NFY__c, Asset_PFY__c FROM Oblix_Project_Assets__c WHERE Asset_PFY__c in: id_original_assets
            // clone sow  result: SELECT Cloned_Asset__c, Original_Asset__c FROM Oblix_SOW_Projects__c WHERE Original_Asset__c in: id_original_assets

            // update the original SOWs with the id of cloned SOWs
            for (Oblix_Project_Assets__c asset: database.query(query_string2)){
                //clon: map_original_id_original_asset.get(asset.Original_Asset__c).Cloned_Asset__c = asset.Id;
                //sync: map_original_id_original_asset.get(asset.Asset_PFY__c).Asset_NFY__c = asset.Id;
                map_original_id_original_asset.get((Id) asset.get(job_component.attrib_5)).put(job_component.attrib_4,asset.Id);
            }

            if (is_success){
                update map_original_id_original_asset.values();
            }

        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAssets() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  


    }


    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-04-25
    * @description  Need to sync the assets and add against the Campaign for NFY
                    there can be assets which changed quantity/added/removed
    ********************************************************************************/
    public static boolean syncAssetsDuringTransitionPeriod(Oblix_syncBatchJob.JobComponent job_component){
        
      Boolean is_success = true;
        try{


            //##########################################################################################
            //    query the correct records in scope, sync and add to list to insert
            //##########################################################################################
            //      attrib_1: Campaign_PFY__c
            //      attrib_2: Campaign_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: Asset_NFY__c
            //      attrib_5: Asset_PFY__c

            String result_msg ='';

            result_msg += '\n\n\n started syncAssetsDuringTransitionPeriod';

            String step_name = 'sync assets';

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject(ASSET_OBJECT),',');
            query_string += ' FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Sync_Status__c =\'' + job_component.attrib_3; 
            
            // exclude the NFY records
            query_string += '\' AND Agency_Projects__r.Financial_year__r.SOW_NFY__c <> NULL ';
            query_string += ' AND Agency_Projects__r.Sync_Step__c <> \'' + step_name + ORDER_BY_SOQL + job_component.query_limit; 

            // OLD IMPLEMENTATION
            //query_string += '\' AND (Agency_Projects__r.Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES ;
            //query_string += '\' OR Agency_Projects__r.Financial_Year__r.SOW_Status__c = \'' + Oblix_Utils.SOW_STATUS_REJECTED_BY_AGENCY; 
            //query_string += '\' OR Agency_Projects__r.Financial_Year__r.SOW_Status__c =  \'' + Oblix_Utils.SOW_STATUS_REJECTED_BY_UNILEVER;
            //query_string +=  '\') AND Agency_Projects__r.Sync_Step__c <> \'' + step_name + ORDER_BY_SOQL + job_component.query_limit; 

            result_msg += '\n\n\n query_string: ' + query_string;

            Map<Id, Oblix_Project_Assets__c> map_original_ids_to_original = new Map<Id,Oblix_Project_Assets__c>();
            Set<Id> set_original_ids =  new Set<Id>();
            Set<Id> set_original_parent_ids = new Set<Id>();

            for (Oblix_Project_Assets__c asset : database.query(query_string)){
                map_original_ids_to_original.put(asset.Id, asset);
                set_original_ids.add(asset.Id);
                set_original_parent_ids.add(asset.Agency_Projects__c);
            }


            result_msg += '\n query1 result rows: ' + set_original_ids.size() + ' - set_original_parent_ids: ' + JSON.serialize(set_original_parent_ids);

            // get the NFY related records for the selected parent campaign Ids
            String query_string2 = SELECT_SOQL;
            query_string2 += String.join(Oblix_Utils.getfieldsByObject(ASSET_OBJECT),',');
            query_string2 += ' FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Campaign_PFY__c in: set_original_parent_ids ORDER BY Id '; 
            
            result_msg += '\n query2: ' + query_string2;

            Map<Id, Oblix_Project_Assets__c> map_original_ids_to_cloned = new Map<Id,Oblix_Project_Assets__c>();
            for (Oblix_Project_Assets__c cloned_asset: database.query(query_string2)){
                map_original_ids_to_cloned.put(cloned_asset.Asset_PFY__c,cloned_asset );
            }

            result_msg += '\n query2 result rows: ' + map_original_ids_to_cloned.size();



            Set<Id> set_cloned_campaign_pfy_ids = new Set<Id>();
            // get the NFY related records for the selected parent campaign Ids
            String query_string3 = 'SELECT Campaign_PFY__c FROM Oblix_SOW_Projects__c WHERE Campaign_PFY__c in: set_original_parent_ids ORDER BY Id '; 
            
            result_msg += '\n query3: ' + query_string3;
            for (Oblix_SOW_Projects__c cloned_campaign: database.query(query_string3)){
                set_cloned_campaign_pfy_ids.add(cloned_campaign.Campaign_PFY__c);
            }

            // scenarios:
            //  1- PFY asset is newly created: create a clone of it for the NFY
            //  2- PFY and NFY are created but require syncing - quantity changed
            //  3- PFY asset deleted therefore delete it from NFY 

            Map<Id, Oblix_Project_Assets__c> map_assets_to_delete = new Map<Id, Oblix_Project_Assets__c>();
            Map<Id, Oblix_Project_Assets__c> map_assets_to_update = new Map<Id,Oblix_Project_Assets__c>();
            List<Oblix_Project_Assets__c> list_assets_to_clone = new List<Oblix_Project_Assets__c>();

            // this map is used to copy over values from original to cloned assets
            Map<String, Schema.SObjectField> map_name_and_field = Oblix_Utils.fetchAllFieldsForObject(ASSET_OBJECT);


            for (Oblix_Project_Assets__c asset: map_original_ids_to_original.values()){
                result_msg += '\n\n\n **** asset.mdm_id: ' + asset.mdm_id__c 
                    + ' - asset.quantity: ' + asset.Quantity__c + ' - asset: ' + JSON.serialize(asset);
                
                // ensure the NFY Campaign exists - campaigns which are 100% or cancelled will not have a NFY record!
                if(!map_original_ids_to_cloned.containsKey(asset.id) && set_cloned_campaign_pfy_ids.contains(asset.Agency_Projects__c)){
                    //  1- PFY asset is newly created: create a clone of the for the NFY
                    

                    Oblix_Project_Assets__c cloned_asset = asset.clone(false, true, false, false);
                    cloned_asset.put(job_component.attrib_5,asset.Id);
                    // set the parent of new asset to be under the cloned campaign (cloned/NFY)
                    cloned_asset.Agency_Projects__c = (Id) asset.get(job_component.attrib_2);
                    cloned_asset.Campaign_ID__c = (String) asset.get(job_component.attrib_2);
                    list_assets_to_clone.add(cloned_asset);
                    
                    result_msg += '\n\n\n to clone - campaign_id ' + cloned_asset.Campaign_ID__c + ' - Agency_Projects__c: ' + cloned_asset.Agency_Projects__c;

                }
                else if(NULL != map_original_ids_to_cloned && map_original_ids_to_cloned.containsKey(asset.id)){
                    //  2- PFY and NFY are created but require syncing

                    Oblix_Project_Assets__c cloned_asset = map_original_ids_to_cloned.get(asset.id);

                    // sync all existing fields from CFY to NFY
                    setAllFieldsDuringSync(asset, cloned_asset,map_name_and_field,true);

                    // set the correct campaign id field as above would have overwritten it
                    cloned_asset.Campaign_ID__c = (String) asset.get(job_component.attrib_2);

                    map_assets_to_update.put(cloned_asset.Id, cloned_asset);
                    
                    result_msg += RESULT_MSG_PREFIX + cloned_asset.name;

                }

                asset.Sync_Step__c = step_name;
            }

            result_msg += RESULT_MSG_PREFIX + map_assets_to_update.size() + ' - to clone: ' + list_assets_to_clone.size() 
                + ' - to delete: ' + map_assets_to_delete.size();
            //Oblix_SyncBatchJob.addEvent('DEBUG IN syncAssetsDuringTransitionPeriod() - result_msg: ' + result_msg,NULL);

            insert list_assets_to_clone;

            // need to update original record and add the NFY lookups for newly created clones
            String query_string4 = SELECT_SOQL + job_component.attrib_4 + ', ' + job_component.attrib_5 + ' FROM Oblix_Project_Assets__c WHERE ' + job_component.attrib_5 + ' in :set_original_ids ';
            // initial sync result: SELECT Asset_NFY__c, Asset_PFY__c FROM Oblix_Project_Assets__c WHERE Asset_PFY__c in: set_original_ids

            // update the original SOWs with the id of cloned SOWs
            for (Oblix_Project_Assets__c asset: database.query(query_string4)){
                //sync: map_original_ids_to_original.get(asset.Asset_PFY__c).Asset_NFY__c = asset.Id;
                map_original_ids_to_original.get((Id) asset.get(job_component.attrib_5)).put(job_component.attrib_4,asset.Id);
            }

            update map_original_ids_to_original.values();

            // loop through NFY assets and if no match found in PFY collection then delete
            for (Oblix_Project_Assets__c asset: map_original_ids_to_cloned.values()){
                
                if (!map_original_ids_to_original.containsKey(asset.Asset_PFY__c)){
                    //  3- PFY asset deleted therefore delete it from NFY 
                    map_assets_to_delete.put(asset.Id, asset);
                }

            }

            

            result_msg += RESULT_MSG_PREFIX + map_assets_to_update.size() + ' - to clone: ' + list_assets_to_clone.size() 
                + ' - to delete: ' + map_assets_to_delete.size();


            delete map_assets_to_delete.values();

            update map_original_ids_to_original.values();

            update map_assets_to_update.values();
    

            //#################################################
            //  SET STEP NAME TO SYNC COMPLETE
            //#################################################
            List<Oblix_SOW_Projects__c> list_campaigns_to_set_processed_flag = [SELECT Sync_Step__c FROM Oblix_SOW_Projects__c WHERE Id in: set_original_parent_ids];
            setProcessingFlag(list_campaigns_to_set_processed_flag,Oblix_syncBatchJob.SYNC_STEP_FIELD, step_name );

            Oblix_SyncBatchJob.addEvent('DEBUG IN syncCampaignDuringTransitionPeriod() - result_msg: ' + result_msg,NULL);
            
        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN syncAssets() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success;  


    }


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
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            Set<Id> processed_ids = Oblix_SyncBatchJob.sync_job.processed_non_campaign_ids;

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneNonCampaigns() - ' + processed_ids.size() + ' - processed_ids: ' + JSON.serialize(processed_ids),NULL);

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Marketing_Basics__c'),',');
            query_string += ' FROM  Marketing_Basics__c WHERE Oblix_SOWMarketing__r.Sync_Status__c =\'' + job_component.attrib_1 + '\' AND Id NOT in: processed_ids ORDER BY Id LIMIT ' + job_component.query_limit; 

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneNonCampaigns - query_string: ' + query_string,NULL);
            //system.debug(Oblix_SyncBatchJob.sync_job.process_result);

            
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

            //Oblix_SyncBatchJob.addEvent('INFO IN cloneNonCampaigns() - ' + list_non_campaigns_to_clone.size() + ' - list_non_campaigns_to_clone: ' + JSON.serialize(list_non_campaigns_to_clone),NULL);

            insert list_non_campaigns_to_clone;
            
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
            //      attrib_1: Original_SOW__c
            //      attrib_2: Cloned_SOW__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_4: original status

            // initial sync:
            //      attrib_1: SOW_PFY__c
            //      attrib_2: SOW_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: original status
            //##########################################################################################
            //  query the correct records in scope, clone and add to list to insert
            //##########################################################################################

            Set<Id> processed_ids = Oblix_SyncBatchJob.sync_job.processed_attachment_ids;

            String result_msg = '\n\n--- processing cloneAttachments ';
            result_msg += '\n\ncloneAttachments() - ' + processed_ids.size() + ' - processed_ids: ' + JSON.serialize(processed_ids);

            String query_string = SELECT_SOQL;
            query_string += String.join(Oblix_Utils.getfieldsByObject('Attachment'),',');
            query_string += ' FROM  Attachment WHERE ParentId in (SELECT id from Marketing_SOW__c WHERE Sync_Status__c =\'' + job_component.attrib_3 + '\' AND Attachments_Cloned__c = false) AND Id NOT in: processed_ids ORDER BY ParentId LIMIT ' + job_component.query_limit; 


            Map<Id, Attachment> map_attachments_to_clone = new Map<Id, Attachment>();
            Set<Id> set_cloned_parent_id = new Set<Id>();

            for (Attachment attch: Database.query(query_string)){
                map_attachments_to_clone.put(attch.Id, attch);
                set_cloned_parent_id.add(attch.ParentId);
            }

            //Map<Id, Marketing_SOW__c> map_parents_to_update = new Map<Id, Marketing_SOW__c>(
                //(List<Marketing_SOW__c>)[SELECT Attachments_Cloned__c FROM Marketing_SOW__c WHERE Id in: set_cloned_parent_id]);

            String query_string2 = 'SELECT ' + job_component.attrib_1 + ', ' + job_component.attrib_2 + ' FROM Marketing_SOW__c WHERE Id in: set_cloned_parent_id ';
            Map<Id,Marketing_SOW__c> map_original_to_cloned = new Map<Id, Marketing_SOW__c>((List<Marketing_SOW__c>)
                (Database.query(query_string2)));

            result_msg += '\n\nmap_original_to_cloned() - ' + map_original_to_cloned.size() + ' - map_original_to_cloned: ' + JSON.serialize(map_original_to_cloned);

            List<Attachment> list_attachments_to_clone = new List<Attachment>();

            for (Attachment attch: map_attachments_to_clone.values()){
                

                Attachment cloned_attch = attch.clone(false, true, false, false);
                cloned_attch.ParentId = (Id) map_original_to_cloned.get(attch.ParentId).get(job_component.attrib_2);
    
                //Oblix_SyncBatchJob.addEvent('INFO IN cloneAttachments() - RECALCULATE PARENT: ' + (String) map_original_to_cloned.get(attch.ParentId).get(job_component.attrib_2),NULL);

                list_attachments_to_clone.add(cloned_attch);

                // add id to processed collection to avoid reprocessing
                Oblix_SyncBatchJob.sync_job.processed_attachment_ids.add(attch.Id);

            }

            result_msg += '\n\ncloneAttachments() - ' + list_attachments_to_clone.size() + ' - list_attachments_to_clone: ' + JSON.serialize(list_attachments_to_clone);
            Oblix_SyncBatchJob.addEvent(result_msg,NULL);


            Database.insert(list_attachments_to_clone, false);
            

        }
        catch(Exception ex){  
            Oblix_SyncBatchJob.addEvent('ERROR IN cloneAttachments() - ', ex.getMessage() + STACK_TRACE + ex.getStackTraceString());
            is_success = false;
        }
        return is_success; 

    }

>>>>>>> develop
}