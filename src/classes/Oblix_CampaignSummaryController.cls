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
    public Map<String, String> mapTurnoverToSize;

    public Id project_id{get;set;}
    public Oblix_SOW_Projects__c selected_project {get;set;}
    public List<Attachment> liso_attachments {get;set;}
    public List<Oblix_Project_Assets__c> liso_assets;

    public Id selected_asset_id {get;set;}

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  Oblix_CampaignSummaryController constructor
    ********************************************************************************/
    public Oblix_CampaignSummaryController() {
        
        // get SOW and Campaign IDs from page parameters
        project_id = ApexPAges.currentPage().getParameters().get('projectId');
        
        // query the selected_project in scope from the super class
        selected_project = getCampaign(project_id, Oblix_Utils.getAllFieldsInFieldsSet('Oblix_SOW_Projects__c','Oblix_Campaign_Summary'), ', (SELECT OblixCountry__r.Name, Percentage__c FROM Marketing_SOW_Project_Splits__r)');
        
        // query the selected sow in scope
        selected_sow = getSOW(selected_project.Financial_Year__c,new List<String>{'Name'}, null);

        // get related stage identifier for the given selected project Id
        stage_identifier = new Oblix_CampaignStageLogic(selected_project, true);

    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  return the map of turn over
    ********************************************************************************/
    public Map<String, String> getMapTurnoverToSize(){
        if (mapTurnoverToSize == NULL){

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
        }

        return mapTurnoverToSize;

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
                stage_identifier = new Oblix_CampaignStageLogic(selected_project, true);
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

}