public with sharing class AddAssetController extends Oblix_SWOPparentController {
    
    public AddAssetPageHelper helper { get; set; }


    public AddAssetController() {
    	System.debug('### projectId: ' + ApexPages.currentPage().getParameters().get('projectId'));
    	helper = new AddAssetPageHelper(ApexPages.currentPage().getParameters().get('projectId'),
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