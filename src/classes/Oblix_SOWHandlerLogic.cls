/*****************************************************************************************
* @author       Shahin Movahedi
* @date         2015-12-25
* @description  This class contains handler logic used by Oblix_SOWHandler trigger
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Shahin Movahedi            2015-12-25          Created

******************************************************************************************/
public with sharing class Oblix_SOWHandlerLogic {
	
    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2015-12-25
    * @description  This method retrieves big and small categories for sows in scope
    				builds a map containing SOW.Id and related brand
    ********************************************************************************/
    public static Map<Id, MDO_CategoryBrands__c> retrieveBrandCategoriesForSOW(List<Marketing_SOW__c> liso_sows_in_scope, Map<Id,Marketing_SOW__c> midso_old_sows_in_scope ){

    	Map<Id, MDO_CategoryBrands__c> mids_campaign_id_category_brand = new Map<Id, MDO_CategoryBrands__c>();
    	Map<Id,Id> midid_brand_to_sow_ids = new Map<Id,Id>();

    	// for the SOWs in scope find selected oblix brand - this will be used to
    	// retrieve big and small product categories to populate
		for(Marketing_SOW__c so_to_adjust : liso_sows_in_scope){
			
			// if it was passed in from beforeInsert, there will be no oldMap
			// 		only need to add the id if there is value in the lookup
			// if it was passed in from beforeUpdate
			//		check the before and after values only need to process if different
			if (
				(NULL == midso_old_sows_in_scope && NULL != so_to_adjust.OblixBrand__c)
				||
				(NULL != midso_old_sows_in_scope 
					&& midso_old_sows_in_scope.containsKey(so_to_adjust.Id) 
					&& so_to_adjust.OblixBrand__c != midso_old_sows_in_scope.get(so_to_adjust.Id).OblixBrand__c
				))

				midid_brand_to_sow_ids.put(so_to_adjust.OblixBrand__c,so_to_adjust.Id);
		}

		for (MDO_CategoryBrands__c so_category_brand : [SELECT Brand_Id__c, Product_Category_Id__r.Parent_L2__c, Product_Category_Id__c
												FROM MDO_CategoryBrands__c WHERE Brand_Id__c IN : midid_brand_to_sow_ids.KeySet()]){
			// build a map of sow.id and the related category brand junction object which also contains the big&small brand details
			mids_campaign_id_category_brand.put(midid_brand_to_sow_ids.get(so_category_brand.Brand_Id__c), so_category_brand);
		}
	
		system.debug('## liso_sows_in_scope: ' + liso_sows_in_scope  + ' - mids_campaign_id_category_brand: ' + mids_campaign_id_category_brand + '\n\n idid_brand_to_sow_ids: ' + midid_brand_to_sow_ids + '\n\n midso_old_sows_in_scope: ' + midso_old_sows_in_scope + '\n\n liso_sows_in_scope: ' + liso_sows_in_scope);

        return mids_campaign_id_category_brand;
    }

	
    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2015-12-25
    * @description  This method sets big & small product categories for SOW in scope
    ********************************************************************************/
    public static void adjustBrandCategoriesForSOW(Marketing_SOW__c so_to_adjust, Map<Id, MDO_CategoryBrands__c> mids_campaign_id_category_brand){

        system.debug('## inside adjustBrandCategoriesForSOW - so_to_adjust: ' + so_to_adjust + ' - mids_campaign_id_category_brand: '  + mids_campaign_id_category_brand);

            // check the map to ensure it contains the required MDO_CategoryBrands__c before trying to assign
            if (mids_campaign_id_category_brand.containsKey(so_to_adjust.Id)){

                system.debug('## inside adjustBrandCategoriesForSOW - so_to_adjust: ' + so_to_adjust + ' - mids_campaign_id_category_brand: ' 
                    + mids_campaign_id_category_brand + ' - so_to_adjust.BigOblixProductCategory__c: ' + so_to_adjust.BigOblixProductCategory__c 
                    + ' - so_to_adjust.SmallProductCategory__c: ' + so_to_adjust.SmallProductCategory__c);
              
                so_to_adjust.BigOblixProductCategory__c = mids_campaign_id_category_brand.get(so_to_adjust.Id).Product_Category_Id__r.Parent_L2__c;
                so_to_adjust.SmallProductCategory__c = so_to_adjust.SmallProductCategory__c = mids_campaign_id_category_brand.get(so_to_adjust.Id).Product_Category_Id__c;
            }
    	
    }

}