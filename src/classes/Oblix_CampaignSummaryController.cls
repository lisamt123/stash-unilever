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
public with sharing class Oblix_CampaignSummaryController {
    
    public Oblix_CampaignStageLogic stage_identifier {get;set;}
    public Map<String, String> mapTurnoverToSize {get;set;}
    public Id project_id{get;set;}
    public Oblix_SOW_Projects__c selected_project {get;set;}
    public List<Attachment> liso_attachments {get;set;}
    public List<Oblix_Project_Assets__c> liso_assets;

    public Id selected_asset_id {get;set;}

    private Id sow_id;
    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  Oblix_CampaignSummaryController constructor
    ********************************************************************************/
    public Oblix_CampaignSummaryController() {
        mapTurnoverToSize = new Map<String, String>(); 
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess10, 'S');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnover1020, 'S/M');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess2030, 'M');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess3040, 'M/L');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove40, 'L');
            
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_Less100, 'S');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_100_200, 'S/M');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnover200_300, 'M');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess300_400, 'M/L');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove400, 'L');
            system.Debug('###mapTurnoverToSize : '+mapTurnoverToSize );
        // get SOW and Campaign IDs from page parameters
        project_id = ApexPAges.currentPage().getParameters().get('projectId');
        sow_id = ApexPages.currentPage().getParameters().get('sowId');
        
        List<String> lis_fields_to_query = Oblix_Utils.getAllFieldsInFieldsSet('Oblix_SOW_Projects__c', 'Oblix_Campaign_Summary');

        // build SOQL for querying campaign fields
        String s_query_string = 'SELECT ';
        s_query_string += String.join(lis_fields_to_query,',');

        // get related project splits
        s_query_string += ', (SELECT OblixCountry__r.Name, Percentage__c FROM Marketing_SOW_Project_Splits__r)';

        s_query_string += ' FROM Oblix_SOW_Projects__c';
        s_query_string += ' WHERE Id = ' + '\'' + project_id + '\'';

        // query the campaign in scope
        List<Oblix_SOW_Projects__c> liso_campaign;
        if (NULL!=project_id)
        	liso_campaign = Database.query(s_query_string);
    	
        // get related attachments if we have a project id
        if (NULL!=project_id)
            liso_attachments = [SELECT name FROM Attachment WHERE ParentId =: project_id];

        

        // depending on the string parameter initialise Oblix_CampaignStageLogic
        if (NULL != liso_campaign && !liso_campaign.isEmpty()){
            selected_project = liso_campaign[0];
            System.debug('###selected_project  : '+selected_project );
            stage_identifier = new Oblix_CampaignStageLogic(selected_project, true);
        }
        else if (NULL!=project_id)
            stage_identifier = new Oblix_CampaignStageLogic(project_id, true);
        else if (NULL!=sow_id)
            stage_identifier = new Oblix_CampaignStageLogic(sow_id);
        else
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Inavlid campaign or sow passed in to the page'));
    }

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

    public PageReference removeAsset(){
        // delete the seleted asset
        try{
            system.debug('## deleting asset: ' + selected_asset_id);
            if (NULL!=selected_asset_id){
                delete [SELECT Id FROM Oblix_Project_Assets__c WHERE Id=:selected_asset_id];
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Inavlid campaign or sow passed in to the page'));
            }
        }
        catch (Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to delete asset'));
        }

        return null;
    }

    public pageReference addAssetAction() {
        Pagereference addAssetPage = Page.Oblix_CampaignAddAsset;
        addAssetPage.getParameters().put('projectId', project_id);
        addAssetPage.setRedirect(true);
        return addAssetPage;
    }

    public Pagereference exitSwop(){
        return Oblix_Utils.exitSwop();
    }

}