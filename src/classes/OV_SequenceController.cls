/**********************************************************************
Name: OV_SequenceController
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class/service for calculating sort order for shelfs
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             01/09/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_SequenceController {
	public String urlToRedirect{get;set;}
	public OV_SequenceController(ApexPages.StandardController standardController) {
        sObject obj = (sObject)standardController.getRecord();

        String recordType = ApexPages.currentPage().getParameters().get('RecordType');
        String returnURL = ApexPages.currentPage().getParameters().get('retURL');
        String ent = ApexPages.currentPage().getParameters().get('ent');

        Schema.DescribeSObjectResult objectDesc = obj.getSObjectType().getDescribe();
        String url = objectDesc.getKeyPrefix()+'/e?retURL='+returnURL+'&RecordType='+recordType+'&ent='+ent+'&nooverride=1';
        Decimal sortOrder = 1;
        OV_Fields_Ids__c customSettings = OV_Fields_Ids__c.getInstance();

        if(objectDesc.getName() == 'OV_Shelf__c' && customSettings.Shelf_Sort_Order__c != null){
        	List<OV_Shelf__c> shelfs = [SELECT Id, Sort_Order__c FROM OV_Shelf__c WHERE RecordTypeId=:recordType ORDER BY Sort_Order__c DESC LIMIT 1];
        	if( !shelfs.isEmpty() ){
        		sortOrder = shelfs[0].Sort_Order__c+1;
        	}
            url += '&'+customSettings.Shelf_Sort_Order__c+'='+sortOrder;
    	}

    	urlToRedirect = url;
    }

    public PageReference init(){
    	pagereference redirect = new PageReference('/'+this.urlToRedirect);
		redirect.setRedirect(true);
		return redirect;
    }
}