/**********************************************************************
Name: WinatPOSBrandViewController
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: class used to forward user to proper brand page 
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          16/11/2014      INITIAL DEVELOPMENT
***********************************************************************/
public class WinatPOSBrandViewController {
	public final String brandIdToView{get;set;}
    public final String refererFromApex{get;set;}
    public WinatPOSBrandViewController(ApexPages.StandardController controller) {
        Brand_Master__c brandToView=(Brand_Master__c)controller.getRecord();
        brandIdToView=brandToView.id;
        refererFromApex=ApexPages.currentPage().getHeaders().get('Referer');
        system.debug('current Referer: '+refererFromApex);
    }
    
    public PageReference doAction(){
        PageReference pageRef = new PageReference('/apex/WinAtPOSBrandView?id='+brandIdToView);
    	if(refererFromApex != '' && refererFromApex != null){
            if(refererFromApex.toUpperCase().contains('WINATPOSHOMEPAGE')){
                pageRef= new PageReference(refererFromApex+'#/search/brand/'+brandIdToView+'/');
                system.debug('brand detail set to internal WinAtPOS application +'+pageRef.getUrl());
            }
        }
        system.debug('check page url :'+pageRef.getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
}