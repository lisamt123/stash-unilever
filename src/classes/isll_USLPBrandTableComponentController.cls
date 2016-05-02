/**********************************************************************
 Name:  isll_USLPBrandTableComponentController
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:Manages USLP brand table component                                                         
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     07/08/2013        INITIAL DEVELOPMENT         Story id:USLL-127  	
 
***********************************************************************/
public with sharing class isll_USLPBrandTableComponentController {
	public Brand_USLP_Progress__c newBrand {get;set;}
	public boolean isEditMode {get;set;}
	public boolean showEditMode {get;set;}
	public Brand_USLP_Progress__c uslpToEdit {get;set;}
	private boolean refreshBrandUSLP;
	private Map<id, Brand_USLP_Progress__c> brandIDMap = new Map<id, Brand_USLP_Progress__c>();
	
	public static final string MISSING_BRAND_NAME = 'Missing Brand Name';
	public static final string BRAND_LOGO_NEEDED = 'Brand logo is needed';
	public static final string ERROR_ADDING_BRAND = 'Error adding brand';
	public static final string UP_TABLE = 'Up';
	public static final string DOWN_TABLE = 'Down';
	
 
	/*******************************************************************
	   Purpose:  The constructor                                                  
	********************************************************************/
	public isll_USLPBrandTableComponentController(){
		newBrand = new Brand_USLP_Progress__c();
		refreshBrandUSLP = true;
		showEditMode = false;
	}
	
	
	/*******************************************************************
	   Purpose:  the attachment which stores the brands logo                                                       
	   Returns: Attachment -                                                        
	********************************************************************/
	public Attachment attachment {
	  get {
	      if (attachment == null)
	        attachment = new Attachment();
	      return attachment;
	    }
	  set;
  	}
  
  	/*******************************************************************
	   Purpose:  Returns a list of Brand USLP Progress records                                                       
	   Returns: Brand_USLP_Progress__c -                                                        
	********************************************************************/
	public List<Brand_USLP_Progress__c> allBrandUSLP{
		get{
			if(refreshBrandUSLP){ 
				allBrandUSLP  =  [select id, Name, Activating_In_Market__c, Case_Study__c, Brand_Centre_Link__c, 
						Defined_USLP_Ambition__c, Order_Number__c, Started__c,
						(SELECT Id FROM Attachments LIMIT 1) 
					from Brand_USLP_Progress__c ORDER BY  Order_Number__c ASC ];
				brandIDMap = new Map<id, Brand_USLP_Progress__c>();
				for(Brand_USLP_Progress__c aUSLP : allBrandUSLP){
					brandIDMap.put(aUSLP.id, aUSLP);
				}
				
			}
			system.debug('the table: '+allBrandUSLP);
			return allBrandUSLP;
			
		}
		set;
	}
	
	/*******************************************************************
	   Purpose: Removes a brand from the table                                                       
	   Returns: PageReference - where to navigate to next                                                     
	********************************************************************/
	public PageReference removeFromTable(){
			Id brandUSLPToDelete  =  ApexPages.currentPage().getParameters().get('brandUSLPId');
			delete  new Brand_USLP_Progress__c (id = brandUSLPToDelete);
			return null;
		
	}
	
	/*******************************************************************
	   Purpose: adds a brand to the table                                                       
	   Returns: PageReference - where to navigate to next                                                     
	********************************************************************/
	public PageReference addNewBrandUSLP(){
			system.debug('newBrand: '+newBrand);
			boolean validationFailure = false;
			
			system.debug('newBrand name: '+newBrand.Name);
			if(String.isEmpty(newBrand.Name)){
				validationFailure = true;
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, MISSING_BRAND_NAME));
			}
			
			if(null == newBrand.id  && (null == attachment || String.isEmpty(attachment.Name))){
				validationFailure = true;
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, BRAND_LOGO_NEEDED));
			}
			
			if(validationFailure){
				return null;
			}
			
			Savepoint sp = Database.setSavepoint();
			try{
				if(null == newBrand.id){
					newBrand.Order_Number__c = allBrandUSLP.size();
				}
				upsert newBrand;
				system.debug('the attachment: '+attachment);
				if(null != newBrand.id && (null != attachment && String.isNotEmpty(attachment.Name))){
					//new attachment, so delete old one and add new one	
					if(null != newBrand.Attachments && newBrand.Attachments.size() > 0){
						delete newBrand.Attachments[0];
					}
					
					if(String.isNotEmpty(attachment.Name)){
						attachment.OwnerId = UserInfo.getUserId();
				    	attachment.ParentId = newBrand.id;
				    	insert attachment;
					}
				}
				
			}
			catch (DMLException e){
				Database.rollback(sp);
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ERROR_ADDING_BRAND));
			}
			finally{
				newBrand = new Brand_USLP_Progress__c(); 
				attachment = new Attachment();
				showEditMode = false;
			}
    	
		return null;
	
	}
	
	/*******************************************************************
	   Purpose: returns the pageReference used to navigate back                                                     
	   Returns: PageReference - the url of the previous page                                                    
	********************************************************************/
	public PageReference goBack(){	
		PageReference returnPage =  new PageReference(ApexPages.currentPage().getParameters().get('returnPage'));
		returnPage.setRedirect(true);
		
		return returnPage;
	}
	
	/*******************************************************************
	   Purpose: updates the brands list                                                   
	   Returns: PageReference - where to go next                                             
	********************************************************************/
	public PageReference updateUSLPBrands(){	
		refreshBrandUSLP = false;
		update allBrandUSLP;
		refreshBrandUSLP = true;
		return null;
	}
	
	/*******************************************************************
	   Purpose: used to reOrder the brand table                                           
	********************************************************************/
	public PageReference reArrangeTable(){
		String action =  ApexPages.currentPage().getParameters().get('action'); 
		ID brandToMove = ApexPages.currentPage().getParameters().get('brandToMove'); 

		system.debug('brandToMove: '+brandToMove);
			system.debug('action: '+action);
		refreshBrandUSLP = false;

			//minus 1 from the order number and add one to the element above (i-1)
			integer counter = 0;
			for(Brand_USLP_Progress__c aBrand : allBrandUSLP){
				if(aBrand.id == brandToMove){
					if(action == UP_TABLE){
						if(aBrand.Order_Number__c != 0){
							aBrand.Order_Number__c = aBrand.Order_Number__c - 1;
							allBrandUSLP[counter - 1].Order_Number__c = allBrandUSLP[counter - 1].Order_Number__c + 1;
						}
					}
					else if(action == DOWN_TABLE){
						if(aBrand.Order_Number__c != allBrandUSLP.size() - 1){
							aBrand.Order_Number__c = aBrand.Order_Number__c + 1;
							allBrandUSLP[counter + 1].Order_Number__c = allBrandUSLP[counter + 1].Order_Number__c - 1;
						}
					}
					break;
				}
				counter++;
			}
			
		
		update allBrandUSLP;
		refreshBrandUSLP = true;
		
		return null;
		
	}
	
	public Boolean isEditable
	{
		get;
		set;
	}
	
	public Boolean getShowEditLink()
	{
		if(isEditable == null)
		{
			isEditable = false;
		}
		
		Boolean res = isEditable && isll_Utility.isCurrentUserAdmin();
		return res;
	}
	
	public void hideShowEditDialog(){
		showEditMode = !showEditMode;
		newBrand = brandIDMap.get(ApexPages.currentPage().getParameters().get('uslpToEditId'));
	}
	
	public PageReference updateBrand(){	
		return null;
	}

	
	
}