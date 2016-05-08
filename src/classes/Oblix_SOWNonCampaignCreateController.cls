public with sharing class Oblix_SOWNonCampaignCreateController extends Oblix_SWOPparentController {

    public Oblix_SOWNonCampaignPageHelper helper { get; set; }

    public Boolean can_manage_non_campaign{
        get{
            if(NULL == selected_sow){
                return Oblix_PermissionHandler.hasEditAccess(null);
            } else{
                return Oblix_PermissionHandler.canManageNonCampaign(selected_sow.SOW_Status__c, selected_sow.Id);
            }
        }
    }


    public Boolean is_agency_user {
        get {
            return Oblix_PermissionHandler.hasAG1permissionSet() || Oblix_PermissionHandler.hasAG2permissionSet();
        }
    }
    

    public String nonCampaignItemToAddJSON {get; set;}




    public Oblix_SOWNonCampaignCreateController() {

        String sowId = ApexPages.currentPage().getParameters().get('sowId');

        if (sowId != null && !String.isEmpty(sowId)) {
            selected_sow = getSOW(sowId, Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main_Detail'), null);
            helper = new Oblix_SOWNonCampaignPageHelper(selected_sow, ApexPages.currentPage().getParameters().get('preSelectedSection'));
        }

        system.debug('HELPER %% ' + helper);
    
    }


    public PageReference addToWorkList() {
        helper.addToWorkList(nonCampaignItemToAddJSON);

        return null;
    }

    public PageReference saveWorkList() {
        helper.saveWorkList();

        selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main_Detail'), null);

        return null;
    }

    public PageReference openActivityForUpdate() {
        helper.openItemForUpdate(true);

        return null;
    }

    public PageReference openResourceForUpdate() {
        helper.openItemForUpdate(false);

        return null;
    }


    public PageReference removeItem() {
        helper.removeItem();

        selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main_Detail'), null);

        return null;
    }


    public PageReference removeSection() {
        helper.removeSection();

        selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main_Detail'), null);

        return null;
    }


    public PageReference finishBasket(){
        PageReference campaignMainDetailPage = Page.oblix_sowmaindetail;
        campaignMainDetailPage.getParameters().put('sowId', selected_sow.Id);
        campaignMainDetailPage.setRedirect(True);
        return campaignMainDetailPage;
    }
    
}