/**********************************************************************
Name: WinatPOSAssetViewController
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class is forwarder to proper asset detail view redirecting to internal administrator view
or WinAtPOS application detail view
application
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          06/11/2014     INITIAL DEVELOPMENT
**********************************************************************/

public with sharing class WinatPOSAssetViewController {
    public final String assetIdToView{get;set;}
    public final String refererFromApex{get;set;}
    public WinatPOSAssetViewController(ApexPages.StandardController controller) {
        Asset__c assetToView=(Asset__c)controller.getRecord();
        assetIdToView=assetToView.id;
        refererFromApex=ApexPages.currentPage().getHeaders().get('Referer');
        system.debug('current Referer: '+refererFromApex);
    }
    
    public PageReference doAction(){
        PageReference pageRef = new PageReference('/apex/WinatPOSAssetView?id='+assetIdToView);
      if(refererFromApex != '' && refererFromApex != null){
            if(refererFromApex.toUpperCase().contains('WINATPOSHOMEPAGE')){
                pageRef= new PageReference(refererFromApex+'#/detail/'+assetIdToView);
                system.debug('asset detail set to internal WinAtPOS application +'+pageRef.getUrl());
            }
        }
        system.debug('check page url :'+pageRef.getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }

}