<<<<<<< HEAD
public with sharing class Oblix_SOWMainDetailController extends Oblix_SOWMainDetalControllerExt {

    // attributes are contained in the parent Oblix_SOWMainDetalControllerExt class

    //public void getSyncRequestedFromParameter(){
    //    if (NULL!=ApexPAges.currentPage().getParameters().get('sync_requested')){
    //        is_sync_requested = true;
    //    }
    //    else
    //    {
    //        is_sync_requested = false;
    //    }
    //}

    public Oblix_SOWMainDetailController() {

        //is_sync_requested = false;
        //getSyncRequestedFromParameter();
        // S.M. 2016-05-21 get the latest full page refreh datetime. Used for the sow page messages logic 
        pageLastRefreshed = Datetime.now();
        getSOW();
        pageAttachment = new Attachment();
        map_att_locale = new Map <Id, String>();
        last_updated = '';
        uploadedAtt = ApexPAges.currentPage().getParameters().get('att');
        is_sync_requested = false;

        if (selected_sow != null && selected_sow.Id != null) {
            liso_attachments = getSOWAttachments(selected_sow.Id);
            
            li_campaign_and_non_campaign_items = new List<Oblix_SOWMainDetalControllerExt.CampaignNonCampaignItems>();
            
            
            // Fix to resolve SOQL 101 Issue
            
            /*

            // get campaigns
            for(Oblix_SOW_Projects__c campaign : [SELECT Campaign_PFY__r.Sync_Status__c,Id, Name, OblixRegion__c, Selected_Countries__c, First_3_selected_countries__c, Campaign_Status__c, Total_Fees_for_Project__c, Value_to_be_paid_in_Current_FY__c, 
                Projected_Stage_CFY__c, Completed_Stage_CFY__c, Projected_Stage_PFY__c, Completed_Stage_PFY__c, Value_To_BePaid_Manual_Override__c, Campaign_Total_Fees__c, Percentage_of_Fee_for_this_FY__c, 
                Sync_Required_NFY__c, Stage_Projected_CFY__c, Stage_Completed_CFY__c, Campaign_PFY__c, Percentage_of_Fees_PFY__c, Fees_PFY_Paid_Using_CFY_Calc__c  
                FROM Oblix_SOW_Projects__c 
                WHERE Financial_Year__c = :selected_sow.Id LIMIT 500]){
                li_campaign_and_non_campaign_items.add(new Oblix_SOWMainDetalControllerExt.CampaignNonCampaignItems('Campaign', campaign, can_edit));
                
            } */
            
            // Fix Starts Here
            
            Boolean canEdit = can_edit;
            
             // get campaigns
            for(Oblix_SOW_Projects__c campaign : [SELECT Campaign_PFY__r.Sync_Status__c,Id, Name, OblixRegion__c, Selected_Countries__c, First_3_selected_countries__c, Campaign_Status__c, Total_Fees_for_Project__c, Value_to_be_paid_in_Current_FY__c, 
                Projected_Stage_CFY__c, Completed_Stage_CFY__c, Projected_Stage_PFY__c, Completed_Stage_PFY__c, Value_To_BePaid_Manual_Override__c, Campaign_Total_Fees__c, Percentage_of_Fee_for_this_FY__c, 
                Sync_Required_NFY__c, Stage_Projected_CFY__c, Stage_Completed_CFY__c, Campaign_PFY__c, Percentage_of_Fees_PFY__c, Fees_PFY_Paid_Using_CFY_Calc__c  
                FROM Oblix_SOW_Projects__c 
                WHERE Financial_Year__c = :selected_sow.Id LIMIT 500]){
                li_campaign_and_non_campaign_items.add(new Oblix_SOWMainDetalControllerExt.CampaignNonCampaignItems('Campaign', campaign, canEdit));
             }
            
            // Ends Here

            hasCampaigns = !li_campaign_and_non_campaign_items.isEmpty();

            // get non-campaigns
            /*for(Marketing_Basics__c nonCampaign : [SELECT Id, Name, OblixCountry__r.Name, OblixOtherItemFee__c FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c = : selected_sow.Id LIMIT 500]){
                li_campaign_and_non_campaign_items.add(new CampaignNonCampaignItems('Non Campaign', nonCampaign, can_edit));
            }*/

            Map<String, Oblix_BasketSectionWrapper> nonCampItemSections = Oblix_SOWNonCampaignPageHelper.initBasketSections(selected_sow.Id);
            for (Oblix_BasketSectionWrapper sectionWrapper : nonCampItemSections.values()) {
                li_campaign_and_non_campaign_items.add(new Oblix_SOWMainDetalControllerExt.CampaignNonCampaignItems('Non Campaign', sectionWrapper));
            }
            
            // get attachments
            liso_attachments = getSOWAttachments(selected_sow.Id);

            if(!liso_attachments.isEmpty()){
                for(Attachment att:liso_attachments){
                    map_att_locale.put(att.Id, date.valueof(att.CreatedDate).format());
                }
            }

            last_updated = Oblix_Utils.toLocaleDate(selected_sow.LastModifiedDate);

            scoresFYFeeDashboard = new Oblix_DashboardsHandler(Oblix_DashboardsHandler.Type.SOW_SCORES_FY_FEE, selected_sow.Id);
            scoresFullFeeDashboard = new Oblix_DashboardsHandler(Oblix_DashboardsHandler.Type.SOW_SCORES_FULL_FEE, selected_sow.Id);

            checkIsSyncRequestedOnChildrenCampaign();

        }
        
    }

    public void checkIsSyncRequestedOnChildrenCampaign(){


        try{
            if ([SELECT count() FROM Oblix_SOW_Projects__c WHERE Financial_Year__c =:selected_sow.SOW_PFY__c AND Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED] > 0){
                is_sync_requested = true;
            }
            else
            {
                is_sync_requested = false;
            }

        }catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not fetch campaign sync status'));
            
        }
    }

    public PageReference getSOW(){
        String sow_id = ApexPAges.currentPage().getParameters().get('sowId');
        selected_sow = getSOW(sow_id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL), NULL);
        return null;
    }

    public PageReference deleteAction(){

        PageReference sow_details_page = Page.oblix_sowmain;

        try{
            // Campaign Splits and SWOP Campaigns have master-detail so the related records will be deleted also
            Database.DeleteResult delete_result_main_campaign = Database.delete(selected_sow, true);

        // not a DML exception
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'You are not allowed to delete this SOW'));
            return null;
        }

        return sow_details_page;
    }


    /*******************************************************************************
    * @author       Ignacio Llorca
    * @date         2016-04-25
    * @description  Slavko's method to attach a file to an existing SOW. If the page is in create mode,
    *               inserts a SOW first (on cancel it will be deleted). Migrated to Main Detail page.
    ********************************************************************************/
    public PageReference uploadAttachment(){

        PageReference uploadedAtt = new PageReference('/apex/oblix_sowmaindetail?sowId=' + selected_sow.Id + '&att=true');
        uploadedAtt.setRedirect(true);

        if(pageAttachment.body == null){

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No file selected. Select a file you would like to attach to this SOW.'));
            return null;
        } else {

            pageAttachment.OwnerId = UserInfo.getUserId();
            pageAttachment.ParentId = selected_sow.id;
            if(String.isEmpty(pageAttachment.ContentType)){
                pageAttachment.ContentType = 'SOW';
            }
            //IR - Comented out as far of DE330 defect fix
            //pageAttachment.IsPrivate = true;

            try{

                insert pageAttachment;
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));
                // clear blob data from viewstate
                pageAttachment.body = null;
                List<Attachment> insertedAtt = [SELECT Id, Name, CreatedDate, Createdby.Name, Description 
                                                FROM Attachment WHERE Id =: pageAttachment.Id limit 1];
                if(!insertedAtt.isEmpty())
                    liso_attachments.add(insertedAtt[0]);
                // create new attachemnt instance for page upload
                map_att_locale = new Map<Id, String>();
                for(Attachment att:liso_attachments){
                    map_att_locale.put(att.Id, date.valueof(att.CreatedDate).format());
                }
                pageAttachment = new Attachment();
                return uploadedAtt;
            } catch(DmlException e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'There was an error while uploading the attachment. '));
                return null;
            }
        }

    }

    /*******************************************************************************
    * @author       Ignacio Llorca
    * @date         2016-02-26
    * @description  deletes a single attachment attached to this SOW
    ********************************************************************************/
    public PageReference deleteAtt(){
        PageReference uploadedAtt = new PageReference('/apex/oblix_sowmaindetail?sowId=' + selected_sow.Id + '&att=true');
        uploadedAtt.setRedirect(true);

        if(deleteAttachmentId != null){
            try{
                delete new Attachment(Id = deleteAttachmentId);
                liso_attachments = getSOWAttachments(selected_sow.Id);
                return uploadedAtt;
            } catch (DmlException e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'You do not have permission to delete this attachment'));
                return null;
            }
        }
        return uploadedAtt;
    }

    /*******************************************************************************
    * @author       makepositive
    * @date         2016-05-05
    * @description  sets  SOW.Sync_Status__c to "Sync Requested"
    ********************************************************************************/
    public PageReference initiateRollOver(){
        System.DEBUG('In Here');
        selected_sow.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
        try{
            update selected_sow;
        }catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not initiate roll over'));
            return null;
        }
        return null;
    }

    /******************************************************************************************
    * @author       makepositive
    * @date         2016-05-05
    * @description  If no campaign Id is passed in - syncs all the child campaigns that have "Sync Required" to "Sync Reqeusted"
    *               If campaign Id is passed in - only that single campaign is set to sync required 
    *******************************************************************************************/
    public PageReference syncCampaigns(){
        System.DEBUG('In Here');
        System.DEBUG(campaignIDSync);
        PageReference sow_sync_requested = Page.Oblix_SOWMainDetail;
        sow_sync_requested.setRedirect(true);
        //sow_sync_requested.getParameters().put('sync_requested', 'true');
        sow_sync_requested.getParameters().put('sowId', selected_sow.Id);

        List<Oblix_SOW_Projects__c> campaignsToUpdate = new List<Oblix_SOW_Projects__c>();
        if(campaignIDSync == null){
            for(Oblix_SOW_Projects__c eachCampaign : [SELECT Id, Sync_Status__c 
                                                        FROM Oblix_SOW_Projects__c 
                                                        WHERE Financial_Year__c =:selected_sow.SOW_PFY__c 
                                                        AND Sync_Status__c = :Oblix_Utils.JOB_STATUS_SYNC_REQUIRED
                                                        LIMIT 1000]){
                eachCampaign.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
                campaignsToUpdate.add(eachCampaign);
            }
        }else{
            for(Oblix_SOW_Projects__c eachCampaign : [SELECT Id, Sync_Status__c 
                                                    FROM Oblix_SOW_Projects__c 
                                                    WHERE Id =:campaignIDSync 
                                                    AND Sync_Status__c = :Oblix_Utils.JOB_STATUS_SYNC_REQUIRED
                                                    LIMIT 1]){
                eachCampaign.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
                campaignsToUpdate.add(eachCampaign);
            }            
        }
        try{

            update campaignsToUpdate;
            campaignIDSync = null;
        }catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not update related Campaigns'));
            return null;
        }
        return sow_sync_requested;
    }

    /******************************************************************************************
    * @author       makepositive
    * @date         2016-05-05
    * @description  If min 1 campaign is sync required then send true otherwise false
    *******************************************************************************************/
    public Boolean shouldSyncAllCampaigns{

        get{
            Boolean sync_required = false;

            try{
                if ([SELECT count() FROM Oblix_SOW_Projects__c WHERE Financial_Year__c =:selected_sow.SOW_PFY__c AND Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUIRED] > 0){
                    sync_required = true;
                }
                else
                {
                    sync_required = false;
                }

                return sync_required;
            }catch (DmlException e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not fetch campaign sync status'));
                return sync_required;
            }
        }
    }



    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-09
    * @description  reject SOW with mandatory comments
    ********************************************************************************/
    public PageReference rejectSOW(){

        // get sow approval record - there can be only one (?)
        List<ProcessInstanceWorkitem> workItems = [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :selected_sow.Id];
        // S.M 20160209 adding checks and removing else to fix sonar issue
        if(NULL!=workItems && workItems.size() == 1){

            ProcessInstanceWorkitem wi = workItems[0];

            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
            pwr.setComments(sowRejectComments);
            pwr.setAction('Reject');
            pwr.setWorkitemId(wi.Id);
            system.debug('## selected_sow.Id: ' + selected_sow.Id + 'pwr: ' + JSON.serializePretty(pwr) + ' WorkItem: ' + wi.Id);
            Approval.ProcessResult result =  Approval.process(pwr);

            if(result.isSuccess()){
                // reload SOW to get new sow status
                selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);
            }

        }
        //} else {

        //    // there should be only one work item for a given object.
        // refactoring: add error message?

        //}

        PageReference ref = new PageReference('/apex/oblix_sowmain');
        return ref;

    }
    
=======
public with sharing class Oblix_SOWMainDetailController extends Oblix_SOWMainDetalControllerExt {

    // attributes are contained in the parent Oblix_SOWMainDetalControllerExt class

    //public void getSyncRequestedFromParameter(){
    //    if (NULL!=ApexPAges.currentPage().getParameters().get('sync_requested')){
    //        is_sync_requested = true;
    //    }
    //    else
    //    {
    //        is_sync_requested = false;
    //    }
    //}
    public Database.DeleteResult delete_result_main_campaign;
    public Oblix_SOWMainDetailController() {

        //is_sync_requested = false;
        //getSyncRequestedFromParameter();
        // S.M. 2016-05-21 get the latest full page refreh datetime. Used for the sow page messages logic 
        pageLastRefreshed = Datetime.now();
        getSOW();
        pageAttachment = new Attachment();
        map_att_locale = new Map <Id, String>();
        last_updated = '';
        uploadedAtt = ApexPAges.currentPage().getParameters().get('att');
        is_sync_requested = false;

        if (selected_sow != null && selected_sow.Id != null) {
            liso_attachments = getSOWAttachments(selected_sow.Id);
            
            li_campaign_and_non_campaign_items = new List<Oblix_SOWMainDetalControllerExt.CampaignNonCampaignItems>();
            

           // Fix to resolve SOQL 101 Issue
            
            /*

            // get campaigns
            for(Oblix_SOW_Projects__c campaign : [SELECT Campaign_PFY__r.Sync_Status__c,Id, Name, OblixRegion__c, Selected_Countries__c, First_3_selected_countries__c, Campaign_Status__c, Total_Fees_for_Project__c, Value_to_be_paid_in_Current_FY__c, 
                Projected_Stage_CFY__c, Completed_Stage_CFY__c, Projected_Stage_PFY__c, Completed_Stage_PFY__c, Value_To_BePaid_Manual_Override__c, Campaign_Total_Fees__c, Percentage_of_Fee_for_this_FY__c, 
                Sync_Required_NFY__c, Stage_Projected_CFY__c, Stage_Completed_CFY__c, Campaign_PFY__c, Percentage_of_Fees_PFY__c, Fees_PFY_Paid_Using_CFY_Calc__c  
                FROM Oblix_SOW_Projects__c 
                WHERE Financial_Year__c = :selected_sow.Id LIMIT 500]){
                li_campaign_and_non_campaign_items.add(new Oblix_SOWMainDetalControllerExt.CampaignNonCampaignItems('Campaign', campaign, can_edit));
                
            } */
            
            // Fix Starts Here
            
            Boolean canEdit = can_edit;
            
             // get campaigns
            for(Oblix_SOW_Projects__c campaign : [SELECT Campaign_PFY__r.Sync_Status__c,Id, Name, OblixRegion__c, Selected_Countries__c, First_3_selected_countries__c, Campaign_Status__c, Total_Fees_for_Project__c, Value_to_be_paid_in_Current_FY__c, 
                Projected_Stage_CFY__c, Completed_Stage_CFY__c, Projected_Stage_PFY__c, Completed_Stage_PFY__c, Value_To_BePaid_Manual_Override__c, Campaign_Total_Fees__c, Percentage_of_Fee_for_this_FY__c, 
                Sync_Required_NFY__c, Stage_Projected_CFY__c, Stage_Completed_CFY__c, Campaign_PFY__c, Percentage_of_Fees_PFY__c, Fees_PFY_Paid_Using_CFY_Calc__c  
                FROM Oblix_SOW_Projects__c 
                WHERE Financial_Year__c = :selected_sow.Id LIMIT 500]){
                li_campaign_and_non_campaign_items.add(new Oblix_SOWMainDetalControllerExt.CampaignNonCampaignItems('Campaign', campaign, canEdit));
             }
            
            // Ends Here

            hasCampaigns = !li_campaign_and_non_campaign_items.isEmpty();

            // get non-campaigns
            /*for(Marketing_Basics__c nonCampaign : [SELECT Id, Name, OblixCountry__r.Name, OblixOtherItemFee__c FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c = : selected_sow.Id LIMIT 500]){
                li_campaign_and_non_campaign_items.add(new CampaignNonCampaignItems('Non Campaign', nonCampaign, can_edit));
            }*/

            Map<String, Oblix_BasketSectionWrapper> nonCampItemSections = Oblix_SOWNonCampaignPageHelper.initBasketSections(selected_sow.Id);
            for (Oblix_BasketSectionWrapper sectionWrapper : nonCampItemSections.values()) {
                li_campaign_and_non_campaign_items.add(new Oblix_SOWMainDetalControllerExt.CampaignNonCampaignItems('Non Campaign', sectionWrapper));
            }
            
            // get attachments
            liso_attachments = getSOWAttachments(selected_sow.Id);

            if(!liso_attachments.isEmpty()){
                for(Attachment att:liso_attachments){
                    map_att_locale.put(att.Id, date.valueof(att.CreatedDate).format());
                }
            }

            last_updated = Oblix_Utils.toLocaleDate(selected_sow.LastModifiedDate);

            scoresFYFeeDashboard = new Oblix_DashboardsHandler(Oblix_DashboardsHandler.Type.SOW_SCORES_FY_FEE, selected_sow.Id);
            scoresFullFeeDashboard = new Oblix_DashboardsHandler(Oblix_DashboardsHandler.Type.SOW_SCORES_FULL_FEE, selected_sow.Id);

            checkIsSyncRequestedOnChildrenCampaign();

        }
        
    }

    public void checkIsSyncRequestedOnChildrenCampaign(){


        try{
            if ([SELECT count() FROM Oblix_SOW_Projects__c WHERE Financial_Year__c =:selected_sow.SOW_PFY__c AND Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED] > 0){
                is_sync_requested = true;
            }
            else
            {
                is_sync_requested = false;
            }

        }catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not fetch campaign sync status'));
            
        }
    }

    public PageReference getSOW(){
        String sow_id = ApexPAges.currentPage().getParameters().get('sowId');
        selected_sow = getSOW(sow_id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL), NULL);
        return null;
    }

    public PageReference deleteAction(){
        PageReference sow_details_page = Page.oblix_sowmain;

        try{
            // Campaign Splits and SWOP Campaigns have master-detail so the related records will be deleted also
            delete_result_main_campaign = Database.delete(selected_sow, true);

        // not a DML exception
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'You are not allowed to delete this SOW'));
            return null;
        }

        return sow_details_page;
    }


    /*******************************************************************************
    * @author       Ignacio Llorca
    * @date         2016-04-25
    * @description  Slavko's method to attach a file to an existing SOW. If the page is in create mode,
    *               inserts a SOW first (on cancel it will be deleted). Migrated to Main Detail page.
    ********************************************************************************/
    public PageReference uploadAttachment(){

        PageReference uploadedAtt = new PageReference('/apex/oblix_sowmaindetail?sowId=' + selected_sow.Id + '&att=true');
        uploadedAtt.setRedirect(true);

        if(pageAttachment.body == null){

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No file selected. Select a file you would like to attach to this SOW.'));
            return null;
        } else {

            pageAttachment.OwnerId = UserInfo.getUserId();
            pageAttachment.ParentId = selected_sow.id;
            if(String.isEmpty(pageAttachment.ContentType)){
                pageAttachment.ContentType = 'SOW';
            }
            //IR - Comented out as far of DE330 defect fix
            //pageAttachment.IsPrivate = true;

            try{

                insert pageAttachment;
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));
                // clear blob data from viewstate
                pageAttachment.body = null;
                List<Attachment> insertedAtt = [SELECT Id, Name, CreatedDate, Createdby.Name, Description 
                                                FROM Attachment WHERE Id =: pageAttachment.Id limit 1];
                if(!insertedAtt.isEmpty())
                    liso_attachments.add(insertedAtt[0]);
                // create new attachemnt instance for page upload
                map_att_locale = new Map<Id, String>();
                for(Attachment att:liso_attachments){
                    map_att_locale.put(att.Id, date.valueof(att.CreatedDate).format());
                }
                pageAttachment = new Attachment();
                return uploadedAtt;
            } catch(DmlException e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'There was an error while uploading the attachment. '));
                return null;
            }
        }

    }

    /*******************************************************************************
    * @author       Ignacio Llorca
    * @date         2016-02-26
    * @description  deletes a single attachment attached to this SOW
    ********************************************************************************/
    public PageReference deleteAtt(){
        PageReference uploadedAtt = new PageReference('/apex/oblix_sowmaindetail?sowId=' + selected_sow.Id + '&att=true');
        uploadedAtt.setRedirect(true);

        if(deleteAttachmentId != null){
            try{
                delete new Attachment(Id = deleteAttachmentId);
                liso_attachments = getSOWAttachments(selected_sow.Id);
                return uploadedAtt;
            } catch (DmlException e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'You do not have permission to delete this attachment'));
                return null;
            }
        }
        return uploadedAtt;
    }

    /*******************************************************************************
    * @author       makepositive
    * @date         2016-05-05
    * @description  sets  SOW.Sync_Status__c to "Sync Requested"
    ********************************************************************************/
    public PageReference initiateRollOver(){
        System.DEBUG('In Here');
        selected_sow.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
        try{
            update selected_sow;
        }catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not initiate roll over'));
            return null;
        }
        return null;
    }

    /******************************************************************************************
    * @author       makepositive
    * @date         2016-05-05
    * @description  If no campaign Id is passed in - syncs all the child campaigns that have "Sync Required" to "Sync Reqeusted"
    *               If campaign Id is passed in - only that single campaign is set to sync required 
    *******************************************************************************************/
    public PageReference syncCampaigns(){
        System.DEBUG('In Here');
        System.DEBUG(campaignIDSync);
        PageReference sow_sync_requested = Page.Oblix_SOWMainDetail;
        sow_sync_requested.setRedirect(true);
        //sow_sync_requested.getParameters().put('sync_requested', 'true');
        sow_sync_requested.getParameters().put('sowId', selected_sow.Id);

        List<Oblix_SOW_Projects__c> campaignsToUpdate = new List<Oblix_SOW_Projects__c>();
        if(campaignIDSync == null){
            for(Oblix_SOW_Projects__c eachCampaign : [SELECT Id, Sync_Status__c,Campaign_PFY__r.sync_status__c
                                                        FROM Oblix_SOW_Projects__c 
                                                        WHERE Financial_Year__c =:selected_sow.SOW_PFY__c 
                                                        AND Sync_Status__c = :Oblix_Utils.JOB_STATUS_SYNC_REQUIRED
                                                        LIMIT 1000]){
                eachCampaign.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
                campaignsToUpdate.add(eachCampaign);
            }
        }else{
            for(Oblix_SOW_Projects__c eachCampaign : [SELECT Id, Sync_Status__c,Campaign_PFY__r.sync_status__c
                                                    FROM Oblix_SOW_Projects__c 
                                                    WHERE Id =:campaignIDSync 
                                                    AND Sync_Status__c = :Oblix_Utils.JOB_STATUS_SYNC_REQUIRED
                                                    LIMIT 1]){
                eachCampaign.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
                campaignsToUpdate.add(eachCampaign);
            }            
        }
        try{

            update campaignsToUpdate;
            
            campaignIDSync = null;
        }catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not update related Campaigns'));
            return null;
        }
        return sow_sync_requested;
    }

    /******************************************************************************************
    * @author       makepositive
    * @date         2016-05-05
    * @description  If min 1 campaign is sync required then send true otherwise false
    *******************************************************************************************/
    public Boolean shouldSyncAllCampaigns{

        get{
            Boolean sync_required = false;

            try{
                if ([SELECT count() FROM Oblix_SOW_Projects__c WHERE Financial_Year__c =:selected_sow.SOW_PFY__c AND Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUIRED] > 0){
                    sync_required = true;
                }
                else
                {
                    sync_required = false;
                }

                return sync_required;
            }catch (DmlException e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not fetch campaign sync status'));
                return sync_required;
            }
        }
    }



    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-09
    * @description  reject SOW with mandatory comments
    ********************************************************************************/
    public PageReference rejectSOW(){

        // get sow approval record - there can be only one (?)
        List<ProcessInstanceWorkitem> workItems = [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :selected_sow.Id];
        // S.M 20160209 adding checks and removing else to fix sonar issue
        if(NULL!=workItems && workItems.size() == 1){

            ProcessInstanceWorkitem wi = workItems[0];

            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
            pwr.setComments(sowRejectComments);
            pwr.setAction('Reject');
            pwr.setWorkitemId(wi.Id);
            system.debug('## selected_sow.Id: ' + selected_sow.Id + 'pwr: ' + JSON.serializePretty(pwr) + ' WorkItem: ' + wi.Id);
            Approval.ProcessResult result =  Approval.process(pwr);

            if(result.isSuccess()){
                // reload SOW to get new sow status
                selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);
            }

        }
        //} else {

        //    // there should be only one work item for a given object.
        // refactoring: add error message?

        //}

        PageReference ref = new PageReference('/apex/oblix_sowmain');
        return ref;

    }
    
>>>>>>> develop
}