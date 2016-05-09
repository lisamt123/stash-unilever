/*****************************************************************************************
* @author       Shahin Movahedi
* @date         2016-01-06
* @description  Apex controller class for Oblix_CampaignSummary page
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Shahin Movahedi            2016-01-06          Created

******************************************************************************************/
public with sharing class Oblix_CampaignSummaryController extends Oblix_SWOPparentController {
    
    public Oblix_CampaignStageLogic stage_identifier{get;set;}
    public Oblix_CampaignStageLogic stage_identifier_pop_up {get;set;}
    public Map<String, String> mapTurnoverToSize;

    public String turn_over_size{
        get{
            return Oblix_Utils.getOblixSettingAttribute1ByValue(selected_project.Brand_Led_Growth__c);
        }
    }

    public Boolean can_edit_campaign{
        get{
            return Oblix_PermissionHandler.canManageCampaign(selected_sow.SOW_Status__c, selected_sow.Id, selected_project.Campaign_Status__c);
        }
    }
    public Boolean can_adjust_fee{
        get{
            return Oblix_PermissionHandler.canAdjustFee(selected_sow.SOW_Status__c, selected_sow.Id, selected_project.Campaign_Status__c);
        }
    }

    public Boolean can_manage_asset{
        get{
            return Oblix_PermissionHandler.canManageAssetBasket(selected_sow.SOW_Status__c, selected_sow.Id, selected_project.Campaign_Status__c);
        }
    }

    public String reportDeveloperName{
        get{
            return Oblix_Utils.SWOP_DASHBOARD_REPORT_ASSET_MIX_PER_CATEGORY;
        }
    }


    public String project_id{get;set;}
    public Oblix_SOW_Projects__c selected_project {get;set;}
    public List<Attachment> liso_attachments {get;set;}
    public List<Oblix_Project_Assets__c> liso_assets;

    public String last_updated {get; set;}
    public String p_start_date {get; set;}
    public String p_completion_date {get; set;}
    public String first_air_date {get; set;}
    public String prod_completion_date {get; set;}
    public String bet_first_release {get; set;}
    public String preview_date {get; set;}
    public String date_assets_bet {get; set;}
    public String start_tv_prod {get; set;}
    public String final_release {get; set;}
    public String live_date {get; set;}
    public String live_date_asset {get; set;}

    public String selected_asset_id {get;set;}
    public Decimal PercentToAdjust {get;set;}
    public Boolean is_enable_Adjust {get;set;}

    public Oblix_DashboardsHandler scoresDashboard {get; set;}
    public Integer totalAssets { get; set; }
    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  Oblix_CampaignSummaryController constructor
    ********************************************************************************/
    public Oblix_CampaignSummaryController() {
        is_enable_Adjust = false;

        last_updated ='';
        p_start_date ='';
        p_completion_date ='';
        first_air_date ='';
        prod_completion_date ='';
        bet_first_release ='';
        preview_date ='';
        date_assets_bet ='';
        start_tv_prod ='';
        final_release ='';
        live_date ='';
        live_date_asset ='';
        
        // get SOW and Campaign IDs from page parameters
        project_id = ApexPAges.currentPage().getParameters().get('projectId');
        
        // query the selected_project in scope from the super class
        selected_project = getCampaign(project_id, Oblix_Utils.getAllFieldsInFieldsSet('Oblix_SOW_Projects__c','Oblix_Campaign_Summary'), ', (SELECT OblixCountry__r.Name, Percentage__c FROM Marketing_SOW_Project_Splits__r)');
        
        if (NULL!=selected_project && NULL!=selected_project.Financial_Year__c){
            // query the selected sow in scope
            selected_sow = getSOW(selected_project.Financial_Year__c,new List<String>{'Name','OwnerId','SOW_Status__c', 'Approved_version__c'}, null);
        }

        if (NULL != selected_project && NULL!= selected_sow){
            // get related stage identifier for the given selected project Id
            stage_identifier = new Oblix_CampaignStageLogic(selected_project,can_edit_campaign, can_edit_campaign);
            //IR - do not move into getter!
            stage_identifier_pop_up = new Oblix_CampaignStageLogic(selected_project,can_edit_campaign, can_edit_campaign);
        }


        if(NULL != selected_project){
            if (NULL != selected_project.LastModifiedDate){
                last_updated = Oblix_Utils.toLocaleDate(selected_project.LastModifiedDate);
            }

            if (NULL != selected_project.Project_Start_Date__c){
                p_start_date = Oblix_Utils.toLocaleDate(selected_project.Project_Start_Date__c);
            }

            if (NULL != selected_project.Project_Completion_Date__c){
                p_completion_date = Oblix_Utils.toLocaleDate(selected_project.Project_Completion_Date__c);
            }

            if (NULL != selected_project.First_Air_Date__c){
                first_air_date = Oblix_Utils.toLocaleDate(selected_project.First_Air_Date__c);
            }

            if (NULL != selected_project.Production_Completion_Date__c){
                prod_completion_date = Oblix_Utils.toLocaleDate(selected_project.Production_Completion_Date__c);
            }

            if (NULL != selected_project.BET_first_release__c){
                bet_first_release = Oblix_Utils.toLocaleDate(selected_project.BET_first_release__c);
            }

            if (NULL != selected_project.Date_for_Assets_to_be_in_BET__c){
                date_assets_bet = Oblix_Utils.toLocaleDate(selected_project.Date_for_Assets_to_be_in_BET__c);
            }

            if (NULL != selected_project.Preview_Date__c){
                preview_date = Oblix_Utils.toLocaleDate(selected_project.Preview_Date__c);
            }

            if (NULL != selected_project.Start_of_TV_production__c){
                start_tv_prod = Oblix_Utils.toLocaleDate(selected_project.Start_of_TV_production__c);
            }

            if (NULL != selected_project.Final_release__c){
                final_release = Oblix_Utils.toLocaleDate(selected_project.Final_release__c);
            }

            if (NULL != selected_project.Live_Date__c){
                live_date = Oblix_Utils.toLocaleDate(selected_project.Live_Date__c);
            }

            if (NULL != selected_project.Live_date_Asset_delivery__c){
                live_date_asset = Oblix_Utils.toLocaleDate(selected_project.Live_date_Asset_delivery__c);
            }

            scoresDashboard = new Oblix_DashboardsHandler(Oblix_DashboardsHandler.Type.CAMPAIGN_ASSET_TYPES, selected_project.Id);
            this.totalAssets = scoresDashboard.totalAssets;
        }

    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  Oblix_CampaignSummaryController constructor
    ********************************************************************************/
    public List<Oblix_Project_Assets__c> getLiso_assets(){
        system.debug('## getting liso_assets - project_id: ' + project_id);
        //if (NULL==liso_assets){
            // get related assets if we have a project id
            if (NULL!=project_id){
                List<String> lis_asset_fields_to_query = Oblix_Utils.getAllFieldsInFieldsSet('Oblix_Project_Assets__c', 'Oblix_Campaign_Summary');
                String s_assets_query_string = 'SELECT ';
                s_assets_query_string += String.join(lis_asset_fields_to_query,',');
                s_assets_query_string += ' FROM Oblix_Project_Assets__c';
                s_assets_query_string += ' WHERE Agency_Projects__c = ' + '\'' + project_id + '\'';
                liso_assets = Database.query(s_assets_query_string);
                system.debug('## s_assets_query_string: ' + s_assets_query_string);

            }  
        //}
        system.debug('## liso_assets: ' + liso_assets);
        return liso_assets;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  delete the selected asset and refresh stage identifier 
    ********************************************************************************/
    public PageReference removeAsset(){
        // delete the seleted asset
        try{
            system.debug('## deleting asset: ' + selected_asset_id);
            if (NULL!=selected_asset_id){
                delete [SELECT Id FROM Oblix_Project_Assets__c WHERE Id=:selected_asset_id];

                // query the selected_project in scope from the super class
                selected_project = getCampaign(project_id, Oblix_Utils.getAllFieldsInFieldsSet('Oblix_SOW_Projects__c','Oblix_Campaign_Summary'), ', (SELECT OblixCountry__r.Name, Percentage__c FROM Marketing_SOW_Project_Splits__r)');

 
                // get related stage identifier for the given selected project Id
                stage_identifier = new Oblix_CampaignStageLogic(selected_project, can_edit, can_edit);
            }
        }
        catch (Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to delete asset'));
        }

        return null;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  redirect to add asset page
    ********************************************************************************/
    public pageReference addAssetAction() {
        Pagereference addAssetPage = Page.Oblix_CampaignAddAsset;
        addAssetPage.getParameters().put('projectId', project_id);
        addAssetPage.setRedirect(true);
        return addAssetPage;
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  redirect to add asset page
    ********************************************************************************/
    public pageReference viewAsset() {
        Pagereference addAssetPage = Page.Oblix_CampaignAddAsset;

        system.debug('project_id: ' + project_id + ' selected_asset_id: ' + selected_asset_id);
        addAssetPage.getParameters().put('projectId', project_id);
        addAssetPage.getParameters().put('assetId', selected_asset_id);
        addAssetPage.setRedirect(true);
        return addAssetPage;
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  delete campaign and redirect to sow main page
    ********************************************************************************/
    public pageReference deleteCampaign() {
        // delete the seleted campaign
        try{
            if (NULL!=selected_project){
                
                delete selected_project;

                Pagereference sow_page = Page.Oblix_SOWMainDetail;
                sow_page.getParameters().put('sowId', selected_sow.Id);
                sow_page.setRedirect(true);
                return sow_page;
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to delete campaign'));
                return null;
            }
        }
        catch (Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to delete campaign'));
            return null;
        }

    }

     /*******************************************************************************
    * @author       Jamal Rida
    * @date         2016-01-19
    * @description  AdjustFee
    ********************************************************************************/
    public PageReference AdjustFee(){
        selected_project.Percentage_of_Fee_for_this_FY__c = PercentToAdjust;
        selected_project.Value_To_BePaid_Manual_Override__c = true;

        selected_project.Completed_Stage_CFY__c = stage_identifier_pop_up.s_selected_completed_stage;
        selected_project.Projected_Stage_CFY__c = stage_identifier_pop_up.s_selected_projected_stage;

        system.debug('###PercentToAdjust : '+PercentToAdjust);
        system.debug('###selected_project.Percentage_of_Fee_for_this_FY__c : '+selected_project.Percentage_of_Fee_for_this_FY__c);
        update selected_project;
        
        /* Doesn't make sense
        // query the selected_project in scope from the super class
        selected_project = getCampaign(project_id, Oblix_Utils.getAllFieldsInFieldsSet('Oblix_SOW_Projects__c','Oblix_Campaign_Summary'), ', (SELECT OblixCountry__r.Name, Percentage__c FROM Marketing_SOW_Project_Splits__r)');
        system.debug('###selected_project.Value_to_be_paid_in_Current_FY__c : '+selected_project.Value_to_be_paid_in_Current_FY__c);
        stage_identifier = new Oblix_CampaignStageLogic(selected_project,Integer.valueof(PercentToAdjust), can_edit, can_edit);
        */

        PageReference meNewPage = Page.oblix_campaignsummary;
                 meNewPage.getParameters().put('projectId', selected_project.Id);
                 meNewPage.setRedirect(True);
           return meNewPage;
    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-03-10
    * @description  saves the current projected and completed stages and calcels 
                    the campaign
    ********************************************************************************/
    public PageReference cancelCampaign(){

        try{

            selected_project.Completed_Stage_CFY__c = stage_identifier_pop_up.s_selected_completed_stage;
            selected_project.Projected_Stage_CFY__c = stage_identifier_pop_up.s_selected_projected_stage;

            if ((stage_identifier_pop_up.b_manual_override_on && stage_identifier_pop_up.cancelCampaignManualPercent != selected_project.Percentage_of_Fee_for_this_FY__c) || 
                (!stage_identifier_pop_up.b_manual_override_on && stage_identifier_pop_up.cancelCampaignManualPercent != stage_identifier_pop_up.i_agency_Percentage_of_fees_this_year)) {
                
                selected_project.Value_To_BePaid_Manual_Override__c = true;
            }

            //US412 - allow decimals
            ////Cancellation % validation - must be natural number
            //if (stage_identifier_pop_up.cancelCampaignManualPercent != stage_identifier_pop_up.cancelCampaignManualPercent.intValue()) {
            //    throw new TypeException('Please enter a round number rather than decimal');
            //}
            System.debug('### stage_identifier_pop_up.cancelCampaignManualPercent' + stage_identifier_pop_up.cancelCampaignManualPercent);
            System.debug('### stage_identifier_pop_up.b_manual_override_on' + stage_identifier_pop_up.b_manual_override_on);
            System.debug('### stage_identifier_pop_up.i_agency_Percentage_of_fees_this_year' + stage_identifier_pop_up.i_agency_Percentage_of_fees_this_year);
            System.debug('### Percentage_of_Fee_for_this_FY__c' + selected_project.Percentage_of_Fee_for_this_FY__c);
            selected_project.Percentage_of_Fee_for_this_FY__c = stage_identifier_pop_up.cancelCampaignManualPercent;
            System.debug('### Percentage_of_Fee_for_this_FY__c' + selected_project.Percentage_of_Fee_for_this_FY__c);
            selected_project.Campaign_Status__c = Oblix_Utils.CAMPAIGN_STATUS_CANCELLED;
            selected_project.Name += '(' + Oblix_Utils.CAMPAIGN_STATUS_CANCELLED + ')';
            update selected_project;

            PageReference nextPage = Page.oblix_sowmaindetail;
            nextPage.getParameters().put('sowId', selected_project.Financial_Year__c);
            return nextPage;

        } catch (TypeException te) {

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, te.getMessage()));
            return null;

        } catch (Exception e){

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to cancel campaign'));
            return null;

        }
    }

     /******************************************************************************************
    * @author       makepositive
    * @date         2016-05-05
    * @description  Update Previous year campaign to sync required 
    *******************************************************************************************/
    public PageReference syncCampaign(){
        System.DEBUG('In Here');
        try{
            Oblix_SOW_Projects__c campaignToUpdate = new Oblix_SOW_Projects__c();
            campaignToUpdate = [SELECT ID, Sync_Status__c FROM Oblix_SOW_Projects__c WHERE Id =:selected_project.Campaign_PFY__c LIMIT 1];
            campaignToUpdate.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
            update campaignToUpdate;
        }catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not sync Campaign'));
            return null;
        }
        return null;
    }

    public PageReference refreshPopUpStageIdentifier() {
        stage_identifier_pop_up.sow_project_in_scope.Projected_Stage_CFY__c = stage_identifier.sow_project_in_scope.Projected_Stage_CFY__c;
        stage_identifier_pop_up.sow_project_in_scope.Completed_Stage_CFY__c = stage_identifier.sow_project_in_scope.Completed_Stage_CFY__c;
        stage_identifier_pop_up.initStages();
        return null;
    }

}