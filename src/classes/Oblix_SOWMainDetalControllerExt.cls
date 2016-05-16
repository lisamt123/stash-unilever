public with sharing virtual class Oblix_SOWMainDetalControllerExt extends Oblix_SWOPparentController {

	// controller attribute to ease passing of comment text from vf page to controller
    public String sowSubmitComments {get; set;}
    public String sowApproveComments {get; set;}
    public String sowRejectComments {get; set;}
    public String uploadedAtt {get; set;}
    public String last_updated {get; set;}
    public Attachment pageAttachment {get; set;}
    public Map <Id, String> map_att_locale {get; set;}
    public Oblix_DashboardsHandler scoresFYFeeDashboard {get; set;}
    public Oblix_DashboardsHandler scoresFullFeeDashboard {get; set;}

    public List<CampaignNonCampaignItems> li_campaign_and_non_campaign_items {get; set;}

    public Id campaignIDSync { get; set; }

    public Boolean can_delete_sow{
        get{
            return Oblix_PermissionHandler.canDeleteSOW(selected_sow.SOW_Status__c, selected_sow.Id);
        }
    }

    public Boolean can_delete_attachment{
        get{
            return Oblix_PermissionHandler.canDeleteAttachment(selected_sow.SOW_Status__c);
        }
    }

    public Boolean can_add_attachment{
        get{
            return Oblix_PermissionHandler.canAddNewAttachment(selected_sow.SOW_Status__c);
        }
    }

    public Boolean can_manage_campaign{
        get{
            return Oblix_PermissionHandler.canManageCampaign(selected_sow.SOW_Status__c, selected_sow.Id, null);
        }
    }

    public Boolean can_manage_non_campaign{
        get{
            return Oblix_PermissionHandler.canManageNonCampaign(selected_sow.SOW_Status__c, selected_sow.Id);
        }
    }

    public Boolean sow_approvers_defined{
        get{
            // until the agency users are live, agency approvers aren't mandatory
            return selected_sow.Unilever_SOW_Approver_Name__c != null || Oblix_PermissionHandler.isSystemAdmin() || Oblix_PermissionHandler.hasSuperUserpermissionSet();// && selected_sow.Agency_SOW_Approver_Name__c != null;
            //Blank Unilever approver is taken care of inside submitForApproval() method so can proceed if SystemAdmin or SuperUser
        }
    }

    public Boolean can_submit_for_approval{
        get{
            return Oblix_PermissionHandler.canSubmitForApproval(selected_sow.SOW_Status__c,selected_sow.SOW_PFY__r.SOW_Status__c, selected_sow.Sync_Status__c);
        }
    }

    public Boolean can_reject_sow{
        get{
            return Oblix_PermissionHandler.canRejectSOW(selected_sow.SOW_Status__c, selected_sow.Id);
        }
    }

    public Boolean can_approve_sow{
        get{
            return Oblix_PermissionHandler.canApproveSOW(selected_sow.SOW_Status__c, selected_sow.Id);
        }
    }

    public Boolean show_submit{
        get{

            Boolean is_sole_editor = Oblix_PermissionHandler.isOnlyBrandCatEditor(selected_sow.OblixBrand__c, selected_sow.SmallProductCategory__c, UserInfo.getUserId());
            Boolean is_with_ul2 = (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_REJECTED_BY_AGENCY) || (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_REJECTED_BY_UNILEVER) || (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER );

            return can_submit_for_approval && ( !( Oblix_PermissionHandler.hasUL1permissionSet() && is_with_ul2) || is_sole_editor);
        }
    }

    public Boolean isAgencyApproval{
        get{
            return selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL;
        }
    }

    //Hide Submit for approval button if the Financial year hasn't been updated
    public Boolean submitForApprovalFX{
        get{
            //Date fxDate = null;
            Oblix_FX_Change__c orgFY = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
            Integer sowFY = Oblix_SOWHandlerLogic.getFinancialYear(selected_sow);
            
            if(orgFY != null && orgFY.Financial_Year__c != null && sowFY != null && 
                orgFY.Financial_Year__c >= sowFY){
                return false;
            }else{
                return true;
            }
    }set;}
    
    //Hide Submit for approval button if the Financial year hasn't been updated
    public Boolean isFXApprovedForFY{
        get{
            Oblix_FX_Change__c orgFY = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
            Integer sowFY = Oblix_SOWHandlerLogic.getFinancialYear(selected_sow);
            
            if(orgFY != null && orgFY.Financial_Year__c != null && sowFY != null && 
                orgFY.Financial_Year__c >= sowFY){
                return true;
            }else{
                return false;
            }
    }set;}

    public Boolean canSeeDashboard{
        get{
            return Oblix_PermissionHandler.canSeeDashboards();
        }
    }

    public Boolean hasCampaigns {get; set;}



	public Oblix_SOWMainDetalControllerExt() {
		
	}

	/*******************************************************************
        Purpose: Inner Class Used to have list of Campaign and non Campaign in the same list
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    public class CampaignNonCampaignItems {
        public SObject dynamic_object {get;set;}
        public String s_object_type {get;set;}
        public Oblix_CampaignStageLogic stage_identifier {get;set;}
        public String sectionKey {get;set;}
        public String name {get;set;}
        public Decimal cost {get;set;}

        public CampaignNonCampaignItems(String object_type, SObject campaign_non_campaign, Boolean can_edit) {
            
            s_object_type = object_type;
            dynamic_object = campaign_non_campaign;

            // initialise StageIdentifier if it is a campaign type
            if ('Campaign' == object_type){
                //system.debug('##campaign_non_campaign: ' + campaign_non_campaign);
                stage_identifier = new Oblix_CampaignStageLogic((Oblix_SOW_Projects__c) campaign_non_campaign, can_edit,can_edit);
            }
        }

        public CampaignNonCampaignItems(String object_type, Oblix_BasketSectionWrapper nonCampaignSectionWrapper) {
            
            s_object_type = object_type;

            sectionKey = nonCampaignSectionWrapper.key;
            name = nonCampaignSectionWrapper.name;
            cost = nonCampaignSectionWrapper.totalValue;

        }
    }

}