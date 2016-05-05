/*****************************************************************************************
* @author       Shahin Movahedi
* @date         2015-12-23
* @description  This class contains handler logic used by Oblix_ProjectHandler trigger handler
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Shahin Movahedi            2015-12-23          Created

******************************************************************************************/
public with sharing class Oblix_ProjectHandlerLogic {
	
    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2015-12-23
    * @description  This method returns Campaign_Hub_Summary__c text field on the parents
    				in scope for which the Marketing_SOW_Project_Splits__r have been
    				updated. 
    ********************************************************************************/
    public static Map<Id, String> retrieveCampaignHubSummary(List<Oblix_SOW_Projects__c> liso_campaigns_in_scope){

    	Map<Id, String> mids_campaign_id_hub_summary_text = new Map<Id, String>();

        for (Oblix_SOW_Projects__c so_to_adjust: [SELECT Name, Campaign_Hub_Summary__c
        	, (SELECT Name, Project_Splits__c, Percentage__c, OblixCountry__r.Name FROM Marketing_SOW_Project_Splits__r) 
        	FROM Oblix_SOW_Projects__c WHERE Id =:liso_campaigns_in_scope]){

    		String s_summary = '';
    		for (Oblix_Marketing_SOW_Project_Splits__c project_splits : so_to_adjust.Marketing_SOW_Project_Splits__r)
    			s_summary += ', ' + project_splits.OblixCountry__r.Name + ' ' + project_splits.Percentage__c + '% ';
        	// remove the first comma and add to the map to be adjusted later
        	mids_campaign_id_hub_summary_text.put(so_to_adjust.Id, s_summary.substringAfter(','));   	
        }

        return mids_campaign_id_hub_summary_text;
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2015-12-23
    * @description  Adjust campaign summary text for the parent Oblix_SOW_Projects__c
    				records by getting the value from the map passed in
    ********************************************************************************/
    public static void adjustCampaignHubSummary(Oblix_SOW_Projects__c so_project_to_adjust , Map<Id, String> mids_campaign_id_hub_summary_text){

    	if (mids_campaign_id_hub_summary_text.containsKey(so_project_to_adjust.Id) 
    		&& NULL != mids_campaign_id_hub_summary_text.get(so_project_to_adjust.Id))

    		so_project_to_adjust.Campaign_Hub_Summary__c = mids_campaign_id_hub_summary_text.get(so_project_to_adjust.Id);
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2015-12-23
    * @description  This method returns assest deliverables text field on the parents
                    in scope for which the Agency_Project_Assets__r have been
                    updated. 
    ********************************************************************************/
    public static Map<Id, String> retrieveAssetDeliverables(List<Oblix_SOW_Projects__c> liso_campaigns_in_scope){

        String asset_separator = ' / ';
        Map<Id, String> mids_campaign_id_asset_deliverables_text = new Map<Id, String>();

        for (Oblix_SOW_Projects__c so_to_adjust: [SELECT Name, Asset_Deliverables__c
            , (SELECT Location__c, Asset_Picklist__c, Asset_name__c, Quantity__c, Sub_Category__c FROM Agency_Project_Assets__r) 
            FROM Oblix_SOW_Projects__c WHERE Id =:liso_campaigns_in_scope]){

            String s_asset_deliverables = '';
            for (Oblix_Project_Assets__c project_asset : so_to_adjust.Agency_Project_Assets__r){

                s_asset_deliverables +=  String.isNotBlank(project_asset.Location__c) 
                    ? ', ' + project_asset.Quantity__c + asset_separator + project_asset.Asset_Picklist__c + asset_separator + project_asset.Location__c + asset_separator + project_asset.Sub_Category__c
                    : ', ' + project_asset.Quantity__c + asset_separator + project_asset.Asset_Picklist__c + asset_separator + project_asset.Sub_Category__c;
            }

            // remove the first comma and add to the map to be adjusted later
            mids_campaign_id_asset_deliverables_text.put(so_to_adjust.Id, s_asset_deliverables.substringAfter(','));      
        }

        return mids_campaign_id_asset_deliverables_text;
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2015-12-23
    * @description  Adjust asset deliverables text for the parent Oblix_SOW_Projects__c
                    records by getting the value from the map passed in
    ********************************************************************************/
    public static void adjustAssetDeliverables(Oblix_SOW_Projects__c so_project_to_adjust , Map<Id, String> mids_campaign_id_asset_deliverables_text){

        if (mids_campaign_id_asset_deliverables_text.containsKey(so_project_to_adjust.Id) 
            && NULL != mids_campaign_id_asset_deliverables_text.get(so_project_to_adjust.Id))

            so_project_to_adjust.Asset_Deliverables__c = mids_campaign_id_asset_deliverables_text.get(so_project_to_adjust.Id);
    }

}