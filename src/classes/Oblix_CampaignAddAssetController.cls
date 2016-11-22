public with sharing class Oblix_CampaignAddAssetController extends Oblix_SWOPparentController {
    
    public Oblix_AddAssetPageHelper helper { get; set; }

    public Boolean can_manage_asset{
        get{
            String pfy_sow_status = null;
            if (selected_project.Campaign_PFY__c != null) {
                pfy_sow_status = selected_project.Campaign_PFY__r.Financial_Year__r.SOW_Status__c;
            }
            return Oblix_PermissionHandler.canManageAssetBasket(selected_project.Financial_Year__r.SOW_Status__c, selected_project.Financial_Year__c, selected_project.Campaign_Status__c, pfy_sow_status);
        }
    }


    public Oblix_CampaignAddAssetController() {
        System.debug('### projectId: ' + ApexPages.currentPage().getParameters().get('projectId'));
        helper = new Oblix_AddAssetPageHelper(ApexPages.currentPage().getParameters().get('projectId'),
                                        ApexPages.currentPage().getParameters().get('assetId'));

        if (helper.map_campaign_for_calculator.keySet().size() == 1) {
            selected_project = helper.map_campaign_for_calculator.get(helper.projectId);
        }
    }


    public pageReference addAssetToBasket(){

        helper.addAssetToBasket();

        return null;
    }

    public pageReference updateAssetInBasket(){

        helper.updateAssetInBasket();

        return null;
    }


    
    public pageReference removeAssetFromBasket(){

        helper.removeAssetFromBasket();

        return null;
    }


    public pageReference finishWithBasket(){

        helper.finishWithBasket();
        //return new pageReference('/apex/oblix_sowmaindetail?sowId=' + campaignHelper.selectedProject.Financial_Year__c);
        PageReference campaignSummaryPage = Page.Oblix_CampaignSummary;
        campaignSummaryPage.getParameters().put('projectId', helper.projectId);
        campaignSummaryPage.setRedirect(True);
        return campaignSummaryPage;
    }
}