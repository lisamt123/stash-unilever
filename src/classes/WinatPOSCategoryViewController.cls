/**********************************************************************
Name: WinatPOSCategoryViewController
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: class used to forward user to proper category page 
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          16/11/2014      INITIAL DEVELOPMENT
***********************************************************************/
public class WinatPOSCategoryViewController {
	public final String assetIdToView{get;set;}
    public final String refererFromApex{get;set;}
    public WinatPOSCategoryViewController(ApexPages.StandardController controller) {
        Category__c assetToView=(Category__c)controller.getRecord();
        assetIdToView=assetToView.id;
        refererFromApex=ApexPages.currentPage().getHeaders().get('Referer');
        system.debug('current Referer: '+refererFromApex);
    }
    
    public PageReference doAction(){
        PageReference pageRef = new PageReference('/apex/WinatPOSCategoryView?id='+assetIdToView);
    	if(refererFromApex != '' && refererFromApex != null){
            if(refererFromApex.toUpperCase().contains('WINATPOSHOMEPAGE')){
                pageRef= new PageReference(refererFromApex+'#/search/category/'+assetIdToView+'/');
                system.debug('asset detail set to internal WinAtPOS application +'+pageRef.getUrl());
            }
        }
        system.debug('check page url :'+pageRef.getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
}