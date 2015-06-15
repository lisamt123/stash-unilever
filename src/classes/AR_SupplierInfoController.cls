/*
	Unilever

	Class Name: AR_SupplierInfoController

	Created by: Marc Saelzler | 2013-09-15

	Description: Controller for the page AR_SupplierInfo.

	Timeline
	Date 					| Name 				| Description
	2013-09-15 17:44 (CET)	| Marc Saelzler 	| Initial development.
*/
public with sharing class AR_SupplierInfoController extends AR_ApplicationBaseController
{
	// Includes the sobject handler for AR_Supplier_Info__c.
	public AR_SObjectHolder supplierInfoObject { get; set; }
	public AR_SObjectHolder[] supplierInfoObjectList { get; set; }
	
	// The constructor. It declarates variables and prepopulates information, if necessary.
	public AR_SupplierInfoController()
	{
		supplierInfoObject = new AR_SObjectHolder(getCleanSupplierInfoObject());
		supplierInfoObjectList = new List<AR_SObjectHolder>();
	}
	
	// This method does query data of AR_Supplier_Info__c and Attachment after the controller has been initialized.
	public void loadMyData()
	{
		AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
		
		Set<String> tmp_FieldsSupplierInfoObjectList = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Supplier_Info__c'));
		
		if(tmp_FieldsSupplierInfoObjectList != null)
		{
			supplierInfoObjectList = tmp_DataHandler.SelectSupplierInfoObjectList(tmp_FieldsSupplierInfoObjectList);
		}
	}
	
	protected override void loadObjectsForProgressBar() {
		addFormList('ar_Supplier_Info__c', supplierInfoObjectList);
	}
	
	// This method saves AR_Application__c, upserts or removes AR_Supplier_Info__c and inserts Attachments after a click on next/back/save or a step change has happened.
	public void saveMyData()
	{
		List<AR_SObjectHolder> tmp_newCleanList = new List<AR_SObjectHolder> ();
		
		List<ar_Supplier_Info__c> tmp_objListUpsert = new List<ar_Supplier_Info__c>();
		List<ar_Supplier_Info__c> tmp_objListDelete = new List<ar_Supplier_Info__c>();
		
		for(AR_SObjectHolder obj : SupplierInfoObjectList)
		{
			if(obj.getId() != null && obj.getIsDeleted())
			{
				tmp_objListDelete.add((ar_Supplier_Info__c) obj.obj);
			}
			else if(obj.getIsDeleted() != true)
			{
				tmp_objListUpsert.add((ar_Supplier_Info__c) obj.obj);
				tmp_newCleanList.add(obj);
			}
			
		}
		
		System.Debug('#tmp_objListUpsert: ' + tmp_objListUpsert);
		
		upsert tmp_objListUpsert;
		delete tmp_objListDelete;
		
		SupplierInfoObjectList = tmp_newCleanList;
		
		List<Attachment> tmp_attachmentstoUpsert = new List<Attachment>();
		
		for(AR_SObjectHolder obj : SupplierInfoObjectList)
		{
			obj.setAllFilesParentIds();
			
			if(!obj.getFilesasList().isempty())
			{
				tmp_attachmentstoUpsert.addall(obj.getFilesasList());
			}
		}
		
		if(!tmp_attachmentstoUpsert.isempty())
		{
			upsert tmp_attachmentstoUpsert;
		}
		
		tmp_attachmentstoUpsert.clear();
		
		for(AR_SObjectHolder obj:SupplierInfoObjectList)
		{
			obj.SetAllBodystoNull();
		}
	}
	
	// This method loads the field set for AR_Supplier_Info__c after the controler has been initialized.
	private void loadMyFieldSets()
	{
		fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
		fieldSetMap.put('ar_Supplier_Info__c', AR_MetaDataHandler.GetAllSupplierInfoFieldsets());
	}
	
	// This method adds a row to the list of AR_Supplier_Info__c after a click on add row has happened.
	public PageReference addNewSupplierInfoObject()
	{
		supplierInfoObjectList.add(supplierInfoObject);
		supplierInfoObject = new AR_SObjectHolder(getCleanSupplierInfoObject());
	  	
	  	saveMyData();
	  	
		return null;
	}
	
	// This method gives a clean record of ar_Supplier_Info__c.
	private ar_Supplier_Info__c getCleanSupplierInfoObject()
	{
		return new ar_Supplier_Info__c(Application__c = (Id) application.getId());
	}
}