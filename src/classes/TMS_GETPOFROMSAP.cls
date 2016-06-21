public with sharing class TMS_GETPOFROMSAP{
    public static string testdoc;
    public TMS_GETPOFROMSAP(TMS_Documentvalidation_CC controller) {
        
		  testdoc = System.currentPageReference().getParameters().get('testdoc');
    }
    public TMS_GETPOFROMSAP(TMS_dispatchScreen_CC controller) {
		  testdoc = System.currentPageReference().getParameters().get('testdoc');
    }


    @RemoteAction
    public static Map<String, Object> retrievePO(String type, List<String> fields, Map<String, Object> criteria) {
         
       
        // Retrieve using the standard retrieve
        Map<String, Object> result = RemoteObjectController.retrieve(type, fields, criteria);
        
        // Add in the total record count for the current user. Needed for pagination
        Integer numOwnedAccts = [
            SELECT Count() 
            FROM TMS_PO__c WHERE Truck_Entry_Checklist__r.Id=:testdoc
        ];
        
        // Create a new map since the result map is read-only
        Map<String, Object> customResult = 
            new Map<String, Object> {'TotalRecordCount'=> numOwnedAccts};
        customResult.putAll(result);
        
        return customResult;
    }
}