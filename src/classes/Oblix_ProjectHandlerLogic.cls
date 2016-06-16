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
<<<<<<< HEAD
    public static Map<Id, String> retrieveCampaignHubSummary(List<Oblix_SOW_Projects__c> liso_campaigns_in_scope){
=======
    public static void retrieveCampaignForAdjustment(List<Oblix_SOW_Projects__c> list_projects, Boolean is_new){

        map_campaign_id_campaign_for_update = new Map<Id, Oblix_SOW_Projects__c>();
        //set_campaign_ids_with_related_splits_not_adding_up = new Set<Id>();
        Map<Id, Oblix_SOW_Projects__c> map_original_campaign = null;

        if (!is_new){
            map_original_campaign = new Map<Id, Oblix_SOW_Projects__c>(list_projects);
        }

        //Decimal total_percentage;
        for (Oblix_SOW_Projects__c campaign : [SELECT Financial_Year__c, Financial_Year__r.Financial_Year__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c,
            Total_Value_Driver__c, ProjectTotalAssetscore__c,Total_Project_Score__c, Name, Campaign_Hub_Summary__c, OblixProjectSplitPercentage_Comment__c,
            Name_Suffix__c, Name_Prefix__c, Unique_key__c
            , (SELECT Id, Name, Project_Splits__c, Percentage__c, OblixCountry__r.Name FROM Marketing_SOW_Project_Splits__r)
            , (SELECT Location__c, Asset_Picklist__c, Asset_name__c, Quantity__c, Sub_Category__c, Asset_Score__c, Asset_Type__c FROM Agency_Project_Assets__r) 
            FROM Oblix_SOW_Projects__c WHERE ID in :list_projects]){

            if (!is_new){
                setProjectBusinessDriverScoreValues(campaign,map_original_campaign);
            }

            // set campaign summary            
            adjustCampaignHubSummary(campaign);
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

    	Map<Id, String> mids_campaign_id_hub_summary_text = new Map<Id, String>();

        for (Oblix_SOW_Projects__c so_to_adjust: [SELECT Name, Campaign_Hub_Summary__c
        	, (SELECT Name, Project_Splits__c, Percentage__c, OblixCountry__r.Name FROM Marketing_SOW_Project_Splits__r) 
        	FROM Oblix_SOW_Projects__c WHERE Id =:liso_campaigns_in_scope]){

<<<<<<< HEAD
    		String s_summary = '';
    		for (Oblix_Marketing_SOW_Project_Splits__c project_splits : so_to_adjust.Marketing_SOW_Project_Splits__r)
    			s_summary += ', ' + project_splits.OblixCountry__r.Name + ' ' + project_splits.Percentage__c + '% ';
        	// remove the first comma and add to the map to be adjusted later
        	mids_campaign_id_hub_summary_text.put(so_to_adjust.Id, s_summary.substringAfter(','));   	
=======
            // depending on the number of splits set 
            // set Project_Scale_2__c  
            //adjustCampaignProjectScale(campaign);

            // build the map of campaigns
            map_campaign_id_campaign_for_update.put(campaign.Id, campaign);
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        }

        return mids_campaign_id_hub_summary_text;
    }

    private static void setProjectBusinessDriverScoreValues(Oblix_SOW_Projects__c campaign_to_adjust, Map<Id,Oblix_SOW_Projects__c> map_projects_with_new_values){

        if (NULL != map_projects_with_new_values && map_projects_with_new_values.containsKey(campaign_to_adjust.Id) 
            && NULL != map_projects_with_new_values.get(campaign_to_adjust.Id)){

            Oblix_SOW_Projects__c original_project = map_projects_with_new_values.get(campaign_to_adjust.Id);

            campaign_to_adjust.Project_Scale_1__c = original_project.Project_Scale_1__c;
            campaign_to_adjust.Project_Scale_2__c = original_project.Project_Scale_2__c;
            campaign_to_adjust.Campaign_Idea__c = original_project.Campaign_Idea__c;
            campaign_to_adjust.Brand_Led_Growth__c = original_project.Brand_Led_Growth__c;     
        }
    
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

<<<<<<< HEAD
    		so_project_to_adjust.Campaign_Hub_Summary__c = mids_campaign_id_hub_summary_text.get(so_project_to_adjust.Id);
    }

=======
            // check the parent id against the set with problems and add error if so
            // S.S. this is now handled only with Javascript
            //if (set_campaign_ids_with_related_splits_not_adding_up.contains(campaign_to_adjust.Id)){
 
            //    campaign_to_adjust.addError(prepopulated_campaign.OblixProjectSplitPercentage_Comment__c);
            //}

            // set the other campaign fields
            //campaign_to_adjust.OblixProjectSplitPercentage_Comment__c = prepopulated_campaign.OblixProjectSplitPercentage_Comment__c;
            //campaign_to_adjust.Project_Scale_2__c = prepopulated_campaign.Project_Scale_2__c;
            campaign_to_adjust.Campaign_Hub_Summary__c = prepopulated_campaign.Campaign_Hub_Summary__c;    
            campaign_to_adjust.Asset_Deliverables__c = prepopulated_campaign.Asset_Deliverables__c;


        }

        // set campaign name made up of prefix and suffix
        campaign_to_adjust.Name = buildCampaignName(campaign_to_adjust.Name_Prefix__c, campaign_to_adjust.Name_Suffix__c);

        //Populate campaign Unique Key in case Name changed, or Campaig was cloned and now belongs to another SOW.
        campaign_to_adjust.Unique_Key__c = campaign_to_adjust.Financial_Year__c+'_'+campaign_to_adjust.Name_Prefix__c;
        
        //system.debug('### adjusted campaign name prepopulated_campaign - prefix: '+ campaign_to_adjust.Name_Prefix__c 
        //    + ' - suffix: ' + campaign_to_adjust.Name_Suffix__c + ' - name: ' + campaign_to_adjust.Name);

        // set scores and fees - new way of setting
        // S.M. 2016-03-29 Had to rewrite this section to bypass sonar NPath complexity of 972 issue

        // Check the map and set value driver score
        setCampaignField(midd_project_business_drive_score,'Total_Value_Driver__c', campaign_to_adjust);
        
        // Check the map and set value driver score
        setCampaignField(midd_project_asset_total,'ProjectTotalAssetscore__c', campaign_to_adjust);

        // Check the map and set value driver score
        setCampaignField(midd_project_total_score,'Total_Project_Score__c', campaign_to_adjust);
        
        // Check the map and set value driver score
        setCampaignField(map_campaign_id_campaign_fee,'Total_Fees_for_Project__c', campaign_to_adjust);

        // Check the map and set value driver score
        setCampaignField(map_campaign_id_box_number,'Oblix_ProjectBoxNumber__c', campaign_to_adjust);

        // set scores and fees - old way of setting
        // S.M. 2016-03-29 Had to rewrite this section to bypass sonar NPath complexity of 972 issue

        //if (NULL != midd_project_business_drive_score && midd_project_business_drive_score.containsKey(campaign_to_adjust.Id)){

        //    campaign_to_adjust.Total_Value_Driver__c = midd_project_business_drive_score.get(campaign_to_adjust.Id);
        //}

        //if (NULL != midd_project_asset_total && midd_project_asset_total.containsKey(campaign_to_adjust.Id)){

        //    campaign_to_adjust.ProjectTotalAssetscore__c = midd_project_asset_total.get(campaign_to_adjust.Id);
        //}

        //if (NULL != midd_project_total_score && midd_project_total_score.containsKey(campaign_to_adjust.Id)){

        //    campaign_to_adjust.Total_Project_Score__c = midd_project_total_score.get(campaign_to_adjust.Id);
        //}

        //if (NULL != map_campaign_id_campaign_fee && map_campaign_id_campaign_fee.containsKey(campaign_to_adjust.Id)){

        //    campaign_to_adjust.Total_Fees_for_Project__c = map_campaign_id_campaign_fee.get(campaign_to_adjust.Id);
        //}

        //if (NULL != map_campaign_id_box_number && map_campaign_id_box_number.containsKey(campaign_to_adjust.Id)){

        //    campaign_to_adjust.Oblix_ProjectBoxNumber__c = map_campaign_id_box_number.get(campaign_to_adjust.Id);
        //}
    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-03-30
    * @description  To resolve Sonar issue around NPath complexity of 12500 creating
                    a method to check the map and assign to the correct field
    ********************************************************************************/
    private static void setCampaignField(Map<Id, Decimal> map_to_read, String field_to_assign, Oblix_SOW_Projects__c campaign_to_adjust ){
        if (NULL != map_to_read && map_to_read.containsKey(campaign_to_adjust.Id)){
            campaign_to_adjust.put(field_to_assign,map_to_read.get(campaign_to_adjust.Id));
        }
    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-05-07
    * @description  Build campaign name by combining prefix (provided by user)
                    and suffix (programatically generated)
    ********************************************************************************/
    public static String buildCampaignName(String prefx, String suffix){
        String campaign_name = '';

        if  (String.isEmpty(suffix)){
            campaign_name = prefx;
        }
        else{
            campaign_name = prefx + ' (' + suffix + ')';
        }

        return campaign_name;
    }
    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-03-30
    * @description  To resolve Sonar issue around NPath complexity of 12500 creating
                    a method to check the map and assign to the correct field
    ********************************************************************************/
    private static void setCampaignField(Map<Id, String> map_to_read, String field_to_assign, Oblix_SOW_Projects__c campaign_to_adjust ){
        if (NULL != map_to_read && map_to_read.containsKey(campaign_to_adjust.Id)){
            campaign_to_adjust.put(field_to_assign,map_to_read.get(campaign_to_adjust.Id));
        }
    }
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

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

<<<<<<< HEAD
                s_asset_deliverables +=  String.isNotBlank(project_asset.Location__c) 
                    ? ', ' + project_asset.Quantity__c + asset_separator + project_asset.Asset_Picklist__c + asset_separator + project_asset.Location__c + asset_separator + project_asset.Sub_Category__c
                    : ', ' + project_asset.Quantity__c + asset_separator + project_asset.Asset_Picklist__c + asset_separator + project_asset.Sub_Category__c;
            }
=======
    // S.M. 2016-05-20 as per requested by user, trigger should not be setting the dropdown value for 
    // geographical scale
    ///*******************************************************************************
    //* @author       Execloud ©
    //* @date         2016-03-04
    //* @description  set comment against parent campaign if the percentage does not add
    //                up to 100% otherwise clear out the comments
    //********************************************************************************/
    //private static void adjustCampaignProjectScale(Oblix_SOW_Projects__c campaign){
            
    //    if (NULL != campaign.Marketing_SOW_Project_Splits__r && campaign.Marketing_SOW_Project_Splits__r.size() >0){
    //        if (1 == campaign.Marketing_SOW_Project_Splits__r.size()){
    //            campaign.Project_Scale_2__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_HUB_PARENTERS_1');    
    //        }
    //        else if (2 == campaign.Marketing_SOW_Project_Splits__r.size()){
    //            campaign.Project_Scale_2__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_HUB_PARENTERS_2');    
    //        }
    //        else if (3 == campaign.Marketing_SOW_Project_Splits__r.size()){
    //            campaign.Project_Scale_2__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_HUB_PARENTERS_3');    
    //        }
    //        else if (4 == campaign.Marketing_SOW_Project_Splits__r.size()){
    //            campaign.Project_Scale_2__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_HUB_PARENTERS_4');    
    //        }
    //        else if (campaign.Marketing_SOW_Project_Splits__r.size() >= 5){
    //            campaign.Project_Scale_2__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_HUB_PARENTERS_5');    
    //        }
    //    }
    //    else{
    //        campaign.Project_Scale_2__c = '';
    //    }
    //}
    
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

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
<<<<<<< HEAD
    public static void adjustAssetDeliverables(Oblix_SOW_Projects__c so_project_to_adjust , Map<Id, String> mids_campaign_id_asset_deliverables_text){
=======
    private static void adjustAssetDeliverables(Oblix_SOW_Projects__c campaign_in_scope){

        String asset_separator = ' / ';
        String s_asset_deliverables = '';
        String assetCategoryRemovedExamples = '';

        for (Oblix_Project_Assets__c project_asset : campaign_in_scope.Agency_Project_Assets__r){
            
            
            assetCategoryRemovedExamples = '';

            if (NULL != project_asset.Asset_Type__c && project_asset.Asset_Type__c.contains(' - ')){
                assetCategoryRemovedExamples = project_asset.Asset_Type__c.split(' - ')[0];
            }

            s_asset_deliverables +=  String.isNotBlank(project_asset.Location__c) 
                ? ', ' + project_asset.Quantity__c + asset_separator + project_asset.Asset_name__c + asset_separator + project_asset.Location__c + asset_separator + assetCategoryRemovedExamples + asset_separator + project_asset.Sub_Category__c
                : ', ' + project_asset.Quantity__c + asset_separator + project_asset.Asset_name__c + asset_separator + assetCategoryRemovedExamples + asset_separator + project_asset.Sub_Category__c;
        }
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

        if (mids_campaign_id_asset_deliverables_text.containsKey(so_project_to_adjust.Id) 
            && NULL != mids_campaign_id_asset_deliverables_text.get(so_project_to_adjust.Id))

            so_project_to_adjust.Asset_Deliverables__c = mids_campaign_id_asset_deliverables_text.get(so_project_to_adjust.Id);
    }

}