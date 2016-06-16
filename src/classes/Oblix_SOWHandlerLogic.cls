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
	
	//	system.debug('## liso_sows_in_scope: ' + liso_sows_in_scope  + ' - mids_campaign_id_category_brand: ' + mids_campaign_id_category_brand + '\n\n idid_brand_to_sow_ids: ' + midid_brand_to_sow_ids + '\n\n midso_old_sows_in_scope: ' + midso_old_sows_in_scope + '\n\n liso_sows_in_scope: ' + liso_sows_in_scope);

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
                so_to_adjust.SmallProductCategory__c = mids_campaign_id_category_brand.get(so_to_adjust.Id).Product_Category_Id__c;
            }
    	
    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-04
    * @description  This method gets approvers for the brand-BigC combination, and
                    populates the unilever and agency approvers maps passed in by
                    reference
    ********************************************************************************/
    public static void retrieveBrandCategoryApprovers(List<Marketing_SOW__c> newSOWs, Map<String, Set<Id>> brandCatKey_unileverApproverIds_map, Map<String, Set<Id>> brandCatKey_agencyApproverIds_map){

        // get approvers for categories of SOWs in scope
        Set<Id> bigCIds = new Set<Id>();
        Set<Id> brandIds = new Set<Id>();
        for(Marketing_SOW__c sow : newSOWs){
            bigCIds.add(sow.SmallProductCategory__c);
            brandIds.add(sow.OblixBrand__c);
        }
        List<Oblix_User_Permission__c> userPermissions = [SELECT Id, CategoryBrand_id__r.Brand_id__c, CategoryBrand_id__r.Product_Category_Id__c, User_id__c, RecordTypeId
                                                            FROM Oblix_User_Permission__c 
                                                            WHERE CategoryBrand_id__r.Brand_id__c IN :brandIds 
                                                                AND CategoryBrand_id__r.Product_Category_Id__c IN :bigCIds 
                                                                AND Level_of_Access__c = :Oblix_Utils.USER_PERMISSION_APPROVER
                                                                AND User_id__r.IsActive = true];

        // build a map of brandId_bigcategoryId as keys and list of approver ids as values, which we will use to populate approver fields on SOWs
        for(Oblix_User_Permission__c up : userPermissions){
            String brandCatKey = up.CategoryBrand_id__r.Brand_id__c + '_' + up.CategoryBrand_id__r.Product_Category_Id__c;
            if(up.RecordTypeId == Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER){
                // S.M. 20160209 - sonar issue resolved by avoid checking == false and use ! instead
                if(!brandCatKey_unileverApproverIds_map.containsKey(brandCatKey)){
                    Set<Id> approverIds = new Set<Id>();
                    brandCatKey_unileverApproverIds_map.put(brandCatKey, approverIds);
                }
                brandCatKey_unileverApproverIds_map.get(brandCatKey).add(up.User_id__c);
            } else if (up.RecordTypeId == Oblix_Utils.RT_USER_PERMISSION_AGENCY_USER){
                // S.M. 20160209 - sonar issue resolved by avoid checking == false and use ! instead
                if(!brandCatKey_agencyApproverIds_map.containsKey(brandCatKey)){
                    Set<Id> approverIds = new Set<Id>();
                    brandCatKey_agencyApproverIds_map.put(brandCatKey, approverIds);
                }
                brandCatKey_agencyApproverIds_map.get(brandCatKey).add(up.User_id__c);
            }
        }

    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-11
    * @description  This method gets user permission setting for a given brand and 
                    category
    ********************************************************************************/
    public static Map<String, List<Oblix_User_Permission__c>> retrieveUserPermissions(List<Marketing_SOW__c> newSOWs){
        Map<String, List<Oblix_User_Permission__c>> brandCatKey_UserIds_map = new Map<String, List<Oblix_User_Permission__c>>();

        // get approvers for categories of SOWs in scope
        Set<Id> bigCIds = new Set<Id>();
        Set<Id> brandIds = new Set<Id>();
        for(Marketing_SOW__c sow : newSOWs){
            bigCIds.add(sow.SmallProductCategory__c);
            brandIds.add(sow.OblixBrand__c);
        }
        
<<<<<<< HEAD
        List<Oblix_User_Permission__c> userPermissions = [SELECT Id, CategoryBrand_id__r.Brand_id__c, CategoryBrand_id__r.Product_Category_Id__c, User_id__c, RecordTypeId, Level_of_Access__c
=======
        List<Oblix_User_Permission__c> userPermissions = [SELECT Id, CategoryBrand_id__r.Brand_id__c, CategoryBrand_id__r.Product_Category_Id__c, User_id__c, RecordTypeId, Level_of_Access__c,
                                                                User_id__r.Contact.AccountId, User_id__r.IsActive
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
                                                            FROM Oblix_User_Permission__c 
                                                            WHERE CategoryBrand_id__r.Brand_id__c IN :brandIds 
                                                                AND CategoryBrand_id__r.Product_Category_Id__c IN :bigCIds
                                                                AND User_id__r.IsActive = TRUE];

        // build a map of brandId_bigcategoryId as keys and list of approver ids as values, which we will use to populate approver fields on SOWs
        for(Oblix_User_Permission__c up : userPermissions){
            String brandCatKey = up.CategoryBrand_id__r.Brand_id__c + '_' + up.CategoryBrand_id__r.Product_Category_Id__c;
            // S.M. 20160209 - sonar issue resolved by avoid checking == false and use ! instead
            if(!brandCatKey_UserIds_map.containsKey(brandCatKey)){
                List<Oblix_User_Permission__c> approvers = new List<Oblix_User_Permission__c>();
                brandCatKey_UserIds_map.put(brandCatKey, approvers);
            }
            brandCatKey_UserIds_map.get(brandCatKey).add(up);
        }

        return brandCatKey_UserIds_map;
    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-11
    * @description  This method gets creates sharings for a sow based on
                    user permissions
    ********************************************************************************/
    public static List<Marketing_SOW__Share> adjustSharing(Marketing_SOW__c sow, Map<String, List<Oblix_User_Permission__c>> brandCatKey_UserIds_map){

        List<Marketing_SOW__Share> sharesToInsert = new List<Marketing_SOW__Share>();

        if(String.isNotEmpty(sow.OblixBrand__c) && String.isNotEmpty(sow.SmallProductCategory__c)){

            String brandCatKey = sow.OblixBrand__c + '_' + sow.SmallProductCategory__c;

            if(brandCatKey_UserIds_map.containsKey(brandCatKey)){

                for(Oblix_User_Permission__c userPermission : brandCatKey_UserIds_map.get(brandCatKey)){

<<<<<<< HEAD
                    if(sow.OwnerId != userPermission.User_id__c){
=======
                    if(sow.OwnerId != userPermission.User_id__c && userPermission.User_id__r.IsActive &&
                        ( (userPermission.RecordTypeId == Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER) 
                            || 
                          (userPermission.RecordTypeId == Oblix_Utils.RT_USER_PERMISSION_AGENCY_USER && userPermission.User_id__r.Contact.AccountId == sow.Oblix_AgencyEstimate__c) )){
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

                        Marketing_SOW__Share ms = new Marketing_SOW__Share();
                        ms.ParentId = sow.Id;
                        ms.UserOrGroupId =  userPermission.User_id__c;
                        ms.RowCause = Schema.Marketing_SOW__Share.RowCause.MANUAL;
                        // S.S. 02.06.2016. - requirement to add attachments require to have edit access to SOWs, and edit needs to be prevented through VF and
                        // Oblix_PermissionHandler class
                        //ms.AccessLevel = userPermission.Level_of_Access__c == Oblix_Utils.USER_PERMISSION_READ_ONLY ? 'Read' : 'Edit';
                        ms.AccessLevel = 'Edit';
                        sharesToInsert.add(ms);

                    }

                }

            }

        }

        return sharesToInsert;

    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-11
    * @description  This method deletes all sharing in the system for a given record
    ********************************************************************************/
    public static void deleteAllManualSharing(List<Marketing_SOW__c> liso_sow){

        List<Marketing_SOW__Share> sowShares = [SELECT Id from Marketing_SOW__Share WHERE ParentId IN :liso_sow AND RowCause = :Schema.Marketing_SOW__Share.RowCause.MANUAL];

        delete sowShares;

    }


    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-07
    * @description  This method sets Unilever and agency approvers. Requires both
                    Brand and Big Category fields to be populated. Expects that there
                    is at least one approver for brand-category defined.
    ********************************************************************************/
    public static Boolean setSOWApprovers(Marketing_SOW__c sow, Map<String, Set<Id>> brandCatKey_unileverApproverIds_map, Map<String, Set<Id>> brandCatKey_agencyApproverIds_map){

        Boolean isChanged = false;

        // populate approvers on SOWs. Currently only one approver is populated, but the system allows as many as there are approver fields on SOW
        if(String.isNotEmpty(sow.OblixBrand__c) && String.isNotEmpty(sow.SmallProductCategory__c)){
            String brandCatKey = sow.OblixBrand__c + '_' + sow.SmallProductCategory__c;

            if(brandCatKey_unileverApproverIds_map != null && brandCatKey_unileverApproverIds_map.containsKey(brandCatKey)){
                Set<Id> unileverApprovers = brandCatKey_unileverApproverIds_map.get(brandCatKey);
                // change only if needed
                // S.M. 20160209 - sonar issue resolved by avoid checking == false and use ! instead
                if(!unileverApprovers.contains(sow.Unilever_SOW_Approver_Name__c)){
                    isChanged = true;
                    sow.Unilever_SOW_Approver_Name__c = unileverApprovers.iterator().next();
                }
                // to be uncommented if more than one user will be able to approve:
                // if(unileverApprovers.iterator().hasNext()) sow.Unilever_SOW_Approver_Name_2__c = unileverApprovers.iterator().next();
            } else if(sow.Unilever_SOW_Approver_Name__c != null){
                // if no approvers are defined, clear the current approver value
                isChanged = true;
                sow.Unilever_SOW_Approver_Name__c = null;
            }

            if(brandCatKey_agencyApproverIds_map != null && brandCatKey_agencyApproverIds_map.containsKey(brandCatKey)){
                Set<Id> agencyApprovers = brandCatKey_agencyApproverIds_map.get(brandCatKey);
                // change only if needed
                // S.M. 20160209 - sonar issue resolved by avoid checking == false and use ! instead
                if(!agencyApprovers.contains(sow.Agency_SOW_Approver_Name__c)){
                    isChanged = true;
                    sow.Agency_SOW_Approver_Name__c = agencyApprovers.iterator().next();
                }
                // to be uncommented if more than one user will be able to approve:
                // if(agencyApprovers.iterator().hasNext()) sow.Agency_SOW_Approver_Name_2__c = agencyApprovers.iterator().next();
            } else if(sow.Agency_SOW_Approver_Name__c != null){
                // if no approvers are defined, clear the current approver value
                isChanged = true;
                sow.Agency_SOW_Approver_Name__c = null;
            }

        }
        
        return isChanged;

    }


<<<<<<< HEAD
=======
    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-07
    * @description  Build SOW name by combining the prefix and suffix of SOW name
    ********************************************************************************/
    public static void setSOWname(Marketing_SOW__c sow){
              
        Integer financial_year = getFinancialYear(sow);

        if (String.isEmpty(sow.Name_Suffix__c)){
            sow.Name = sow.Name_Prefix__c + Oblix_Utils.FY_SEPARATOR + financial_year;
        }
        else{
            sow.Name = sow.Name_Prefix__c + Oblix_Utils.FY_SEPARATOR + financial_year + ' (' + sow.Name_Suffix__c + ')';
        }  
    }

    public static Integer getFinancialYear(Marketing_SOW__c sow){
        Integer financial_year =  System.Today().year();

        if (String.isNotEmpty(sow.Financial_Year__c)){    
            financial_year = Integer.valueOf(sow.Financial_Year__c.subStringAfter(Oblix_Utils.FY_PREFIX)); 
        }
        return financial_year;

    }
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
}