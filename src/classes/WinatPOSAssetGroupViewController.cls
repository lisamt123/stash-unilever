/**********************************************************************
Name: WinatPOSAssetViewController
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class is forwarder to proper asset group detail view redirecting to internal administrator view
or WinAtPOS application detail view
application
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          13/11/2014     INITIAL DEVELOPMENT
**********************************************************************/
public class WinatPOSAssetGroupViewController {
  public final String assetGroupIdToView{get;set;}
    public final String refererFromApex{get;set;}
    public WinatPOSAssetGroupViewController(ApexPages.StandardController controller) {
        Asset_Group__c assetGroupToView=(Asset_Group__c)controller.getRecord();
        assetGroupIdToView=assetGroupToView.id;
        refererFromApex=ApexPages.currentPage().getHeaders().get('Referer');
        system.debug('current Referer: '+refererFromApex);
    }
    
    public PageReference doAction(){
        PageReference pageRef = new PageReference('/apex/WinatPOSAssetGroupView?id='+assetGroupIdToView);
      if(refererFromApex != '' && refererFromApex != null){
            if(refererFromApex.toUpperCase().contains('WINATPOSHOMEPAGE')){
                pageRef= new PageReference(refererFromApex+'#/detail/'+assetGroupIdToView);
                system.debug('asset group detail set to internal WinAtPOS application +'+pageRef.getUrl());
            }
        }
        system.debug('check page url :'+pageRef.getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
}