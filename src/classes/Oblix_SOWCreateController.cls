/*****************************************************************************************
* @author       Slavko Skular
* @date         2016-02-02
* @description  This class controls Oblix_SOWMain page
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Slavko Skular              2016-02-26          Created

******************************************************************************************/
public with sharing class Oblix_SOWCreateController extends Oblix_SWOPparentController{

	private static final String FIELD_SET_SOW_MAIN_DETAIL = 'oblix_sow_main_detail';
    private static final String OBJECT_SOW_TO_QUERY = 'marketing_sow__c';

    public Attachment pageAttachment {get; set;}

    // edit or create mode? - boolean is easier to use in VF page than enum
    //public Boolean isEdit {
    //    get{
    //        return selected_sow != null && selected_sow.Id != null;
    //    }
    //}
    public Boolean isEdit {get; private set;}

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-26
    * @description  constructor initializes the page mode to edit/create
    ********************************************************************************/
	public Oblix_SOWCreateController() {
		pageAttachment = new Attachment();

		String sow_id = ApexPAges.currentPage().getParameters().get('sowId');
		if(String.isEmpty(sow_id)){
			selected_sow = new Marketing_SOW__c();
            liso_attachments = new List<Attachment>();
            isEdit = false;
		} else {
			isEdit = true;
			selected_sow = getSOW(sow_id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);
            liso_attachments = getSOWAttachments(selected_sow.Id);
		}

	}

	/*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-26
    * @description  overrides parent class' checkUserHasPermissionToSOW method to 
    *               redirect only if there was a sow_id get parameter in url on page 
    *               load
    ********************************************************************************/
    public override PageReference checkUserHasPermissionToSOW(){

		if(isEdit){
			return super.checkUserHasPermissionToSOW();
		} else {
			return null;
		}

	}

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-26
    * @description  attaches a file to an existing SOW. If the page is in create mode,
    *               inserts a SOW first (on cancel it will be deleted)
    ********************************************************************************/
	public void uploadAttachment(){

        if(pageAttachment.body == null){

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No file selected. Select a file you would like to attach to this SOW.'));

        } else {

    		if(!isEdit){
    			saveSOW();
    		}

    		pageAttachment.OwnerId = UserInfo.getUserId();
            pageAttachment.ParentId = selected_sow.id;
            //IR - Comented out as far of DE330 defect fix
            //pageAttachment.IsPrivate = true;

            try{

            	insert pageAttachment;
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));
            	// clear blob data from viewstate
            	pageAttachment.body = null;
            	liso_attachments.add(pageAttachment);
            	// create new attachemnt instance for page upload
            	pageAttachment = new Attachment();

            } catch(DmlException e){
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading attachment:' + e.getMessage()));
            }
        }

	}

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-26
    * @description  overrides parent class' checkUserHasPermissionToSOW method to 
    *               redirect only if there was a sow_id get parameter in url on page 
    *               load
    ********************************************************************************/
    private Boolean saveSOW(){

        Boolean didSave = false;

        try{
            upsert selected_sow;
            didSave = true;
            //isEdit = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'SOW saved successfully'));
        } catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Error saving SOW: ' + e.getMessage()));
        }

        return didSave;

    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-26
    * @description  attempts to save SOW. redirects to main detail page on success,
    *               shows error message on failure
    ********************************************************************************/
    public PageReference saveAndClose(){

        if(saveSOW()){
            PageReference sowDetailPage = new PageReference('/apex/Oblix_SOWMainDetail?sowId='+ selected_sow.Id);
            sowDetailPage.setRedirect(true);
            return sowDetailPage;
        } else {
            return null;
        }

    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-26
    * @description  on cancel, delete SOW and related attachments. This is required
    *               because customer wants to be able to attach files to a SOW that
    *               was not yet saved, so it is saved as soon as first attachment is
    *               uploaded. possible change (if user will accept) is to change user
    *               journey to force save of SOW efore attachment upload.
    ********************************************************************************/
	public PageReference cancelAction(){

        Pagereference returnPage;

		if(!isEdit && selected_sow != null && selected_sow.Id != null){
            delete selected_sow;
            returnPage = Page.Oblix_SOWMain;
        } else {
            returnPage = Page.Oblix_SOWMainDetail;
            returnPage.getParameters().put('sowId', selected_sow.Id);
        }
        returnPage.setRedirect(True);
        return returnPage;

	}

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-26
    * @description  auto-populates small and big category fields when user selects
    *               a brand
    ********************************************************************************/
	public void getCategoryBrand(){

		List<MDO_CategoryBrands__c> categoryBrandList = [SELECT Id, product_Category_Id__r.Id, product_Category_Id__r.Name, 
															product_Category_Id__r.parent_L2__r.Id, product_Category_Id__r.parent_L2__r.Name 
            											FROM MDO_CategoryBrands__c WHERE brand_id__c =:selected_sow.OblixBrand__c];
        
        System.debug('numberOfCategoryBrands: ' + categoryBrandList.size());
        
        if(categoryBrandList.size() == 0){
            
            // no categories for this brand.
            selected_sow.BigOblixProductCategory__r = null;
            selected_sow.BigOblixProductCategory__c = null;
            selected_sow.SmallProductCategory__r = null;
            selected_sow.SmallProductCategory__c = null;
            
        } else {
            
            // one or more categories exist for this brand. If more than one, just select first from the list and leave
            // manual change to the user if needed
            selected_sow.BigOblixProductCategory__r = categoryBrandList[0].product_Category_Id__r.parent_L2__r;
            selected_sow.BigOblixProductCategory__c = categoryBrandList[0].product_Category_Id__r.parent_L2__c;
            selected_sow.SmallProductCategory__r = categoryBrandList[0].product_Category_Id__r;
            selected_sow.SmallProductCategory__c = categoryBrandList[0].product_Category_Id__c;
            
        }

	}

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-26
    * @description  manually create select options from field metadata. Required in
    *               order to replace the '--None--' with 'Financial Year' placeholder
    ********************************************************************************/
	public List<SelectOption> getFYSelectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('', 'Financial Year'));
        
        for( Schema.PicklistEntry f : Marketing_SOW__c.fields.Financial_Year__c.getDescribe().getPicklistValues()){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        return options;
        
    }

}