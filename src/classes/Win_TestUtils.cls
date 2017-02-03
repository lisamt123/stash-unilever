/*************************************************************** 
    Name: Win_TestUtils
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Testing utility class
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  31/01/2017  Initial Dev     First version
***************************************************************/
public with sharing class Win_TestUtils {

	/*
     * Create some assignment records
     */
	public static List<Win_Local_Assignment__c> createRecords(Integer i) {
    	List<Win_Local_Assignment__c> res = new List<Win_Local_Assignment__c>();
    	for(Integer j = 0; j < i; j++){
    		res.add(createRecord(j));
    	}
        return res;
    }

    /*
     * Create a single testing method
     */
    public static Win_Local_Assignment__c createRecord(Integer i) {
		return new Win_Local_Assignment__c(Device_Id__c = 'SimpleTestAccoun' + i, 
        	Local_Id__c = 'oneoneone'  + i, Salesforce_Id__c = 'accentureone' + i);
    }

    /*
     * Create a list of TQUploadRequestItem for tetsing BatchDml option
     */
    public static List<Win_UploadRequestItem> createTQUploadRequestItemList(Integer i){
    	List<Win_UploadRequestItem> res = new List<Win_UploadRequestItem>();
    	
    	for(Integer j = 0; j < i; j++){
    		res.add(new Win_UploadRequestItem(
                'Contact', 'Local_Id_'+j,
                '{"Id" : "Local_Id_'+j+'", "Name" : "Name'+j+'", "LastName": "Surname'+j+'", "AccountId" : "Local_Id"}'
            ));
    	}
    	return res;
    }

    /*
     * Create a list of TQUploadRequestItem for tetsing BatchDml option
     */
    public static List<Win_UploadRequestItem> createTQUploadRequestItemList(List<SObject> objList, String objectType, String params) {
    	List<Win_UploadRequestItem> res = new List<Win_UploadRequestItem>();
    	
    	for(SObject o : objList){
    		res.add(new Win_UploadRequestItem(
                objectType, String.valueOf(o.get('Id')),
                '{"Id" : "' + o.get('Id') + '", '+ params +'}'
            ));
    	}
    	return res;
    }

    /*
     * Create tracked configurations
     */
    public static void createTrackedObjConfigCustomSetting(){
        list<Win_Tracked_Object_Config__c> trackedObjConfigList = new list<Win_Tracked_Object_Config__c>();
        
        Win_Tracked_Object_Config__c t1TrackedObjConfig1 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig1.Active__c = true;
        t1TrackedObjConfig1.ClientApp_ID__c = 'TquilaONE';
        t1TrackedObjConfig1.Custom_Index_List__c = '';
        t1TrackedObjConfig1.Displayable__c = true;
        t1TrackedObjConfig1.Fieldset_Name_List__c = '';
        t1TrackedObjConfig1.Layout_Needed__c = false;
        t1TrackedObjConfig1.List_Header_Fieldset__c = '';
        t1TrackedObjConfig1.Max_Records_Before_Full_Sync__c = 1000;
        t1TrackedObjConfig1.Name = 'Account';
        t1TrackedObjConfig1.Object_Api_Name__c = 'Account';
        t1TrackedObjConfig1.Order_By__c = '';
        t1TrackedObjConfig1.Where__c = 'Name like \'%TquilaONE%\'';
        trackedObjConfigList.add(t1TrackedObjConfig1);
        
        Win_Tracked_Object_Config__c t1TrackedObjConfig2 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig2.Active__c = true;
        t1TrackedObjConfig2.ClientApp_ID__c = 'TquilaONE';
        t1TrackedObjConfig2.Custom_Index_List__c = '';
        t1TrackedObjConfig2.Displayable__c = true;
        t1TrackedObjConfig2.Fieldset_Name_List__c = '';
        t1TrackedObjConfig2.Layout_Needed__c = false;
        t1TrackedObjConfig2.List_Header_Fieldset__c = '';
        t1TrackedObjConfig2.Max_Records_Before_Full_Sync__c = 1000;
        t1TrackedObjConfig2.Name = 'Case';
        t1TrackedObjConfig2.Object_Api_Name__c = 'Case';
        t1TrackedObjConfig2.Order_By__c = '';
        t1TrackedObjConfig2.Where__c = '';
        trackedObjConfigList.add(t1TrackedObjConfig2);
        
        Win_Tracked_Object_Config__c t1TrackedObjConfig4 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig4.Active__c = true;
        t1TrackedObjConfig4.ClientApp_ID__c = 'TquilaONE';
        t1TrackedObjConfig4.Custom_Index_List__c = '';
        t1TrackedObjConfig4.Displayable__c = false;
        t1TrackedObjConfig4.Fieldset_Name_List__c = '';
        t1TrackedObjConfig4.Layout_Needed__c = false;
        t1TrackedObjConfig4.List_Header_Fieldset__c = '';
        t1TrackedObjConfig4.Max_Records_Before_Full_Sync__c = 1000;
        t1TrackedObjConfig4.Name = 'FeedItem';
        t1TrackedObjConfig4.Object_Api_Name__c = 'FeedItem';
        t1TrackedObjConfig4.Order_By__c = '';
        t1TrackedObjConfig4.Where__c = '';
        trackedObjConfigList.add(t1TrackedObjConfig4);
        
        Win_Tracked_Object_Config__c t1TrackedObjConfig5 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig5.Active__c = true;
        t1TrackedObjConfig5.ClientApp_ID__c = 'TquilaONE';
        t1TrackedObjConfig5.Custom_Index_List__c = '';
        t1TrackedObjConfig5.Displayable__c = false;
        t1TrackedObjConfig5.Fieldset_Name_List__c = 'dummyFieldSet';
        t1TrackedObjConfig5.Layout_Needed__c = false;
        t1TrackedObjConfig5.List_Header_Fieldset__c = '';
        t1TrackedObjConfig5.Max_Records_Before_Full_Sync__c = 1000;
        t1TrackedObjConfig5.Name = 'FeedComment';
        t1TrackedObjConfig5.Object_Api_Name__c = 'FeedComment';
        t1TrackedObjConfig5.Order_By__c = '';
        t1TrackedObjConfig5.Where__c = '';
        trackedObjConfigList.add(t1TrackedObjConfig5);
        
        insert trackedObjConfigList;
    }

    /*
     * Prepare the custom settings
     *
     */
    public static list<Win_Tracked_Object_Config__c> createTrackedObjConfigCustomSettings() {
        list<Win_Tracked_Object_Config__c> trackedObjConfigList = new list<Win_Tracked_Object_Config__c>();
        
        Win_Tracked_Object_Config__c t1TrackedObjConfig1 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig1.Active__c = true;
        t1TrackedObjConfig1.ClientApp_ID__c = 'TquilaONE';
        t1TrackedObjConfig1.Custom_Index_List__c = '';
        t1TrackedObjConfig1.Displayable__c = true;
        t1TrackedObjConfig1.Fieldset_Name_List__c = '';
        t1TrackedObjConfig1.Layout_Needed__c = false;
        t1TrackedObjConfig1.List_Header_Fieldset__c = '';
        t1TrackedObjConfig1.Max_Records_Before_Full_Sync__c = 1000;
        t1TrackedObjConfig1.Name = 'Account';
        t1TrackedObjConfig1.Object_Api_Name__c = 'Account';
        t1TrackedObjConfig1.Order_By__c = '';
        t1TrackedObjConfig1.Where__c = 'Name like \'%TquilaONE%\'';
        trackedObjConfigList.add(t1TrackedObjConfig1);
        
        Win_Tracked_Object_Config__c t1TrackedObjConfig2 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig2.Active__c = true;
        t1TrackedObjConfig2.ClientApp_ID__c = 'TquilaONE';
        t1TrackedObjConfig2.Custom_Index_List__c = '';
        t1TrackedObjConfig2.Displayable__c = true;
        t1TrackedObjConfig2.Fieldset_Name_List__c = '';
        t1TrackedObjConfig2.Layout_Needed__c = false;
        t1TrackedObjConfig2.List_Header_Fieldset__c = '';
        t1TrackedObjConfig2.Max_Records_Before_Full_Sync__c = 1000;
        t1TrackedObjConfig2.Name = 'Case';
        t1TrackedObjConfig2.Object_Api_Name__c = 'Case';
        t1TrackedObjConfig2.Order_By__c = '';
        t1TrackedObjConfig2.Where__c = '';
        trackedObjConfigList.add(t1TrackedObjConfig2);
        
        Win_Tracked_Object_Config__c t1TrackedObjConfig3 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig3.Active__c = true;
        t1TrackedObjConfig3.ClientApp_ID__c = 'TquilaONE';
        t1TrackedObjConfig3.Custom_Index_List__c = '';
        t1TrackedObjConfig3.Displayable__c = true;
        t1TrackedObjConfig3.Fieldset_Name_List__c = '';
        t1TrackedObjConfig3.Layout_Needed__c = false;
        t1TrackedObjConfig3.List_Header_Fieldset__c = '';
        t1TrackedObjConfig3.Max_Records_Before_Full_Sync__c = 1000;
        t1TrackedObjConfig3.Name = 'Order';
        t1TrackedObjConfig3.Object_Api_Name__c = 'Order__c';
        t1TrackedObjConfig3.Order_By__c = '';
        t1TrackedObjConfig3.Where__c = '';
        trackedObjConfigList.add(t1TrackedObjConfig3);
        
        Win_Tracked_Object_Config__c t1TrackedObjConfig4 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig4.Active__c = true;
        t1TrackedObjConfig4.ClientApp_ID__c = 'TquilaONE';
        t1TrackedObjConfig4.Custom_Index_List__c = '';
        t1TrackedObjConfig4.Displayable__c = false;
        t1TrackedObjConfig4.Fieldset_Name_List__c = '';
        t1TrackedObjConfig4.Layout_Needed__c = false;
        t1TrackedObjConfig4.List_Header_Fieldset__c = '';
        t1TrackedObjConfig4.Max_Records_Before_Full_Sync__c = 1000;
        t1TrackedObjConfig4.Name = 'FeedItem';
        t1TrackedObjConfig4.Object_Api_Name__c = 'FeedItem';
        t1TrackedObjConfig4.Order_By__c = '';
        t1TrackedObjConfig4.Where__c = '';
        trackedObjConfigList.add(t1TrackedObjConfig4);
        
        Win_Tracked_Object_Config__c t1TrackedObjConfig5 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig5.Active__c = true;
        t1TrackedObjConfig5.ClientApp_ID__c = 'TquilaONE';
        t1TrackedObjConfig5.Custom_Index_List__c = '';
        t1TrackedObjConfig5.Displayable__c = false;
        t1TrackedObjConfig5.Fieldset_Name_List__c = 'dummyFieldSet';
        t1TrackedObjConfig5.Layout_Needed__c = false;
        t1TrackedObjConfig5.List_Header_Fieldset__c = '';
        t1TrackedObjConfig5.Max_Records_Before_Full_Sync__c = 1000;
        t1TrackedObjConfig5.Name = 'FeedComment';
        t1TrackedObjConfig5.Object_Api_Name__c = 'FeedComment';
        t1TrackedObjConfig5.Order_By__c = '';
        t1TrackedObjConfig5.Where__c = '';
        trackedObjConfigList.add(t1TrackedObjConfig5);
        
        return trackedObjConfigList;
    }

}