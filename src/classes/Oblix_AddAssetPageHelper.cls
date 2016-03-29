public with sharing class Oblix_AddAssetPageHelper {


	public Id projectId {get; set;}
    public Id assetId {get; set;}
    public String assetMDMId {get; set;}
    public Map<Id, Oblix_SOW_Projects__c> map_campaign_for_calculator { get; set; }
	public Oblix_SOW_Projects__c project_in_scope { get; set; }
    public String selectedAssetName { get; set; }
    public String selectedAssetOtherName { get; set; }
    public String selectedAssetMDMId { get; set; }  
    public Integer selectedAssetQuantity { get; set; }
    public String selectedAssetNotes { get; set; } 

    public Map<String, Oblix_AssetOfferingWrapper.AssetWrapper> map_assets_in_basket {get;set;}
    
    public String map_assets_in_basket_json { get; set; } 
    public Long basket_total_fee {get;set;}
    public Integer total_fees_this_FY {get;set;}
    public Integer quantity_in_basket {get;set;}

    public List<String> list_reverese_order{get;set;}
    public List<String> list_order_added{get;set;}

    public String assetOtherNameLabel { 
        get {
            return Oblix_Utils.OTHER_ASSET_LABEL;
        } 
    }

    //Wrapper structure holding type, sub-category & option combinations
	public Oblix_AssetOfferingWrapper assetOfferingWrapper {
		get {
			Oblix_AssetOfferingWrapper assetOfferingWrapper = Oblix_AssetOfferingWrapper.getAssetOfferingWrapper();
			return assetOfferingWrapper;
		}
	}



    public Oblix_AddAssetPageHelper(Id projectIdParam, Id assetIdParam) {
		projectId = ApexPages.currentPage().getParameters().get('projectId');
        assetId   = ApexPages.currentPage().getParameters().get('assetId');
        assetMDMId = null;

        list_reverese_order = new List<String>();
		list_order_added = new List<String>();

        if (projectId == null) {
            map_assets_in_basket = new Map<String, Oblix_AssetOfferingWrapper.AssetWrapper>();
        } else {
        	//If Project ID specified - initialise basket from DB
            map_assets_in_basket = initialiseBasketFromDB(projectId);
			list_order_added.addAll(map_assets_in_basket.keySet());
			applySortToBasket(null);

            //Initiliase selected_project object required for calculator operations
            map_campaign_for_calculator = 
            	new Map<Id, Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)(
            		[SELECT 
            			Financial_Year__r.Financial_Year__c, 
            			Financial_Year__r.Name,
            			Brand_Led_Growth__c, 
            			Project_Scale_1__c, 
            			Project_Scale_2__c, 
            			Campaign_Idea__c,
            			Total_Value_Driver__c, 
            			ProjectTotalAssetscore__c,
            			Total_Project_Score__c, 
            			Percentage_of_Fee_for_this_FY__c,
            			Name, 
            			Campaign_Hub_Summary__c, 
            			OblixProjectSplitPercentage_Comment__c, 
            			(
            				SELECT 
	            				Id, 
	            				Name, 
	            				Project_Splits__c, 
	            				Percentage__c, 
	            				OblixCountry__r.Name 
	            			FROM 
	            				Marketing_SOW_Project_Splits__r
	            		), 
            			(
            				SELECT 
            					Location__c, 
            					Asset_Picklist__c, 
            					Asset_name__c, 
            					Quantity__c, 
            					Sub_Category__c, 
								Description__c,
            					Asset_Score__c 
            				FROM 
            					Agency_Project_Assets__r
            			) 
            			FROM 
            				Oblix_SOW_Projects__c 
            			WHERE Id = :projectId]
            	)
            );
            recalculateBasket();
        }
        map_assets_in_basket_json = JSON.serialize(map_assets_in_basket);

        //If page has to be initialised with a particular asset, retrieve it's MDM ID
        for (String mdmId : map_assets_in_basket.keySet()) {
        	Oblix_AssetOfferingWrapper.AssetWrapper asset = map_assets_in_basket.get(mdmId);
        	if (asset.asset_id == assetId) {
        		assetMDMId = mdmId;
        		break;
        	}
        }
	}


	public void finishWithBasket() {

        try {
    		Map<String, Oblix_Project_Assets__c> toInsert = new Map<String, Oblix_Project_Assets__c>();
    		Map<String, Oblix_Project_Assets__c> toUpdate = new Map<String, Oblix_Project_Assets__c>();
    		Map<String, Oblix_Project_Assets__c> toDelete = new Map<String, Oblix_Project_Assets__c>();

    		//Fetch all Campaign Assets from DB and arrange by MDM ID
    		Map<String, Oblix_Project_Assets__c> storedAssetsByMDMId = new Map<String, Oblix_Project_Assets__c>();
    		Set<String> storedAssetMDMIds = new Set<String>();

    		List<Oblix_Project_Assets__c> storedAssets = [SELECT Id, 
    															 Asset_name__c,
    															 Asset_Title__c,
    															 Agency_Projects__c,
    															 Asset_Score__c,
    															 Quantity__c,
    															 Additional_Description__c,
    															 Option_Name__c,
    															 Sub_Category__c,
    															 Asset_Type__c,
    															 Location__c,
    															 Description__c,
    															 mdm_id__c
    													  FROM 
    															Oblix_Project_Assets__c 
    													  WHERE 
    														 	Agency_Projects__c = :projectId];

    		for (Oblix_Project_Assets__c asset : storedAssets) {
    			storedAssetsByMDMId.put(asset.mdm_id__c, asset);
    		}
    		storedAssetMDMIds = storedAssetsByMDMId.keySet();

    		for (String mdmId : map_assets_in_basket.keySet()) {
    			Oblix_AssetOfferingWrapper.AssetWrapper basketAsset = map_assets_in_basket.get(mdmId);

    			//Need to create
    			if (!storedAssetMDMIds.contains(mdmId)) {
    				toInsert.put(mdmId, 
    							 Oblix_AssetOfferingWrapper.convertAssetWrapperToSObject(basketAsset)
    				);
    				storedAssetMDMIds.remove(mdmId);
    				continue;
    			}

    			//Need to update
    			if (storedAssetMDMIds.contains(mdmId)) {
    				Oblix_AssetOfferingWrapper.AssetWrapper storedAsset = Oblix_AssetOfferingWrapper.convertAssetToItemInBasket(storedAssetsByMDMId.get(mdmId));
    				
    				if (basketAsset.asset_name != storedAsset.asset_name ||
    						 basketAsset.other_name != storedAsset.other_name ||
    						 basketAsset.quantity_in_basket != storedAsset.quantity_in_basket ||
    						 basketAsset.other_description_info != storedAsset.other_description_info
    						) {

    					Oblix_Project_Assets__c storedAssetSObject = 
    						Oblix_AssetOfferingWrapper.convertAssetWrapperToSObject(basketAsset);
    					//Ensure asset sObject has correct SF ID to be updated by
    					if (storedAssetSObject.Id == null) {
    						storedAssetSObject.Id = storedAsset.asset_id;
    					}
    					toUpdate.put(mdmId, storedAssetSObject);
    				}

    				//Regardless of whether there are any changes or not,
    				//mark asset as 'processed' by removing it from storedAssetMDMIds
    				//and move on to the next item
    				storedAssetMDMIds.remove(mdmId);
    				continue;
    			}
    		}

    		//Need to delete
    		if (storedAssetMDMIds.size() > 0) {
    			for (String mdmId : storedAssetMDMIds) {
    				toDelete.put(mdmId, 
    							 storedAssetsByMDMId.get(mdmId)
    				);
    			}
    		}

    		insert toInsert.values();
    		update toUpdate.values();
    		delete toDelete.values();
        } catch (DmlException de) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to save basket state: ' + de.getDmlMessage(0)));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to finalise work with basket: ' + e.getMessage()));
        }

	}


	public void addAssetToBasket() {
        try {
    		Oblix_AssetOfferingWrapper.AssetWrapper asset_to_add_to_basket = 
    			Oblix_AssetOfferingWrapper.initialiseAssetWrapper(projectId,
    								   selectedAssetName,
    								   selectedAssetOtherName,
                                       selectedAssetMDMId, 
                                       selectedAssetQuantity, 
                                       selectedAssetNotes);


            //map_assets_in_basket = applySortToBasket(asset_to_add_to_basket);
            list_order_added.add(asset_to_add_to_basket.mdm_id);
            map_assets_in_basket.put(asset_to_add_to_basket.mdm_id, asset_to_add_to_basket);
            applySortToBasket(null);
            map_assets_in_basket_json = JSON.serialize(map_assets_in_basket);

            recalculateBasket();

    		futureAddItemToBasket(JSON.serialize(asset_to_add_to_basket));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to add asset to basket: ' + e.getMessage()));

            //Revert all changes to in-memory basket
            list_order_added.remove(list_order_added.size()-1);
            map_assets_in_basket.remove(selectedAssetMDMId);
            applySortToBasket(null);
            map_assets_in_basket_json = JSON.serialize(map_assets_in_basket);

            recalculateBasket();            
        }
	}


	public void updateAssetInBasket() {

        //Taking backup copy of the old asset values
        Oblix_AssetOfferingWrapper.AssetWrapper oldAsset = map_assets_in_basket.get(selectedAssetMDMId);

        try {
    		Oblix_AssetOfferingWrapper.AssetWrapper asset_to_update_in_basket = 
                Oblix_AssetOfferingWrapper.initialiseAssetWrapper(projectId,
    								   selectedAssetName,
    								   selectedAssetOtherName,
                                       selectedAssetMDMId, 
                                       selectedAssetQuantity, 
                                       selectedAssetNotes);

            map_assets_in_basket.put(asset_to_update_in_basket.mdm_id, asset_to_update_in_basket);
            map_assets_in_basket_json = JSON.serialize(map_assets_in_basket);

            recalculateBasket();

    		futureUpdateItemInBasket(JSON.serialize(asset_to_update_in_basket));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to update asset in basket: ' + e.getMessage()));

            //Revert all changes to in-memory basket
            map_assets_in_basket.put(selectedAssetMDMId, oldAsset);
            map_assets_in_basket_json = JSON.serialize(map_assets_in_basket);

            recalculateBasket();
        }
	}



	public void removeAssetFromBasket() {

        Oblix_AssetOfferingWrapper.AssetWrapper oldAsset = map_assets_in_basket.get(selectedAssetMDMId);

        try {
            Oblix_AssetOfferingWrapper.AssetWrapper removedItem = map_assets_in_basket.remove(selectedAssetMDMId);
            applySortToBasket(removedItem.mdm_id);
            
            map_assets_in_basket_json = JSON.serialize(map_assets_in_basket);

            recalculateBasket();

            futureRemoveItemFromBasket(JSON.serialize(removedItem));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to remove asset from the basket: ' + e.getMessage()));

            //Revert all changes to in-memory basket
            if (oldAsset != null) {
                map_assets_in_basket.put(selectedAssetMDMId, oldAsset);
                applySortToBasket(null);
                map_assets_in_basket_json = JSON.serialize(map_assets_in_basket);

                recalculateBasket();
            }
        }
	}



	public void recalculateBasket(){

        // total business driver score should already be calculated during campaign create process
        // make a call to the calculator class to retrieve the total campaign fees
        // recalculate totalCampaignScore and total campaign fees
        project_in_scope = map_campaign_for_calculator.get(projectId);
        Map<Id, Long> map_total_project_fee = Oblix_CalculatorLogic.getCampaignFee(
        	new Map<Id, Oblix_SOW_Projects__c>{projectId => map_campaign_for_calculator.get(projectId)}, 
        	map_assets_in_basket.values(), 
        	false, 
        	true, 
        	true
        );

        basket_total_fee = map_total_project_fee.get(projectId);
        if (basket_total_fee == null) {
            basket_total_fee = 0;
        }
        quantity_in_basket = 0;
        for (Oblix_AssetOfferingWrapper.AssetWrapper asset : map_assets_in_basket.values()) {
        	quantity_in_basket += asset.quantity_in_basket;
        }

        // calculate fees for this financial year depending on the percentage
        total_fees_this_FY = Oblix_CampaignStageLogic.calculateFeesForThisFY(project_in_scope.Percentage_of_Fee_for_this_FY__c, basket_total_fee);

    }


    /*******************************************************************************
    * @date         2016-03-13
    * @description  Need to use List<String> in order to maintain the order of items
                    being added to shopping basket. Map will automatically order the 
                    items by mdm_id 
    ********************************************************************************/
    private void applySortToBasket(String item_removed){
        
        List<String> list_temp_sort = new List<String>();
        list_reverese_order = new List<String>();
        list_temp_sort.addAll(list_order_added);
        list_order_added.clear();

        for (String item_to_add : list_temp_sort){
            if (item_removed != item_to_add){
                list_order_added.add(item_to_add);
            }
        }

        for (Integer l_index = list_order_added.size()-1; l_index >= 0; l_index --){
            list_reverese_order.add(list_order_added[l_index]);
        }
    }


	/*******************************************************************************
    * @date         2016-03-01
    * @description  future method to persist new basket item in DB layer
    ********************************************************************************/
	@future public static void futureAddItemToBasket(String serializedNewAssetWrapper) {
		//JSON.serialize(dt)
		Oblix_AssetOfferingWrapper.AssetWrapper newAssetWrapper = 
			(Oblix_AssetOfferingWrapper.AssetWrapper)JSON.deserialize(serializedNewAssetWrapper, 
																	  Oblix_AssetOfferingWrapper.AssetWrapper.class);
        List<Oblix_Project_Assets__c> existingAssets = [SELECT 
                                                        Id 
                                                    FROM 
                                                        Oblix_Project_Assets__c 
                                                    WHERE 
                                                        mdm_id__c = :newAssetWrapper.mdm_id
                                                    AND
                                                        Agency_Projects__c = :newAssetWrapper.campaign_id];
        if (existingAssets.size() == 0) {
            //No race condition took place so OK to insert new item
            List<Oblix_Project_Assets__c> assets = 
            Oblix_AssetOfferingWrapper.convertAssetWrappersToSObjects(new List<Oblix_AssetOfferingWrapper.AssetWrapper>{newAssetWrapper});

            insert assets;
        } else if (existingAssets.size() == 1) {
            //Race condition took place (most likely finishWithbasket() method has created 'missing' items before this future method has run) 
            //so need to update existing asset instead
            newAssetWrapper.asset_id = existingAssets[0].Id;
            List<Oblix_Project_Assets__c> assets = 
            Oblix_AssetOfferingWrapper.convertAssetWrappersToSObjects(new List<Oblix_AssetOfferingWrapper.AssetWrapper>{newAssetWrapper});

            update assets;
        } else {
            //Already more than one asset with the same MDM ID is linked to the project - do nothing
            return;
        }
	}


/*******************************************************************************
    * @date         2016-03-01
    * @description  future method to update item in basket. If item was added to basket during the lifetime of a pageview,
    *				then in-memory basket asset wrapper won't have asset SF ID which needs to be queried separately.
    *				If query does not return any results, that means that future remove method got executed before future add
    *				method. This discrepancy will be resolved during basket finalisation stage.
    ********************************************************************************/
	@future public static void futureUpdateItemInBasket(String serializedAssetWrapper) {
		//JSON.serialize(dt)
		Oblix_AssetOfferingWrapper.AssetWrapper assetWrapper = 
			(Oblix_AssetOfferingWrapper.AssetWrapper)JSON.deserialize(serializedAssetWrapper, 
																	  Oblix_AssetOfferingWrapper.AssetWrapper.class);
		if (assetWrapper.asset_id == NULL) {
			//If asset wrapper is to be updated and does not contain asset SF Id,
			//find matching Oblix_Project_Assets__c using combination of Camapign ID and MDM ID
			List<Oblix_Project_Assets__c> assets = [SELECT 
														Id 
													FROM 
														Oblix_Project_Assets__c 
													WHERE 
														mdm_id__c = :assetWrapper.mdm_id
													AND
														Agency_Projects__c = :assetWrapper.campaign_id];
			if (assets.size() == 1) {
				assetWrapper.asset_id = assets[0].Id;
			} else {
				//If no matching assets exist, something went out of sync during future method invocation,
				//it will be taken care off during basket finalisation step
				return;
			}
		}
		List<Oblix_Project_Assets__c> assets = 
			Oblix_AssetOfferingWrapper.convertAssetWrappersToSObjects(new List<Oblix_AssetOfferingWrapper.AssetWrapper>{assetWrapper});

		update assets;
	}


	/*******************************************************************************
    * @date         2016-03-01
    * @description  future method to remove item from basket. If item was added to basket during the lifetime of a pageview,
    *				then in-memory basket asset wrapper won't have asset SF ID which needs to be queried separately.
    *				If query does not return any results, that means that future remove method got executed before future add
    *				method. This discrepancy will be resolved during basket finalisation stage.
    ********************************************************************************/
	@future public static void futureRemoveItemFromBasket(String serializedAssetWrapper) {
		//JSON.serialize(dt)
		Oblix_AssetOfferingWrapper.AssetWrapper assetWrapper = 
			(Oblix_AssetOfferingWrapper.AssetWrapper)JSON.deserialize(serializedAssetWrapper, 
																	  Oblix_AssetOfferingWrapper.AssetWrapper.class);
		if (assetWrapper.asset_id == NULL) {
			//If asset wrapper is to be removed and does not contain asset SF Id,
			//find matching Oblix_Project_Assets__c using combination of Camapign ID and MDM ID
			List<Oblix_Project_Assets__c> assets = [SELECT 
														Id 
													FROM 
														Oblix_Project_Assets__c 
													WHERE 
														mdm_id__c = :assetWrapper.mdm_id
													AND
														Agency_Projects__c = :assetWrapper.campaign_id];
			if (assets.size() == 1) {
				assetWrapper.asset_id = assets[0].Id;
			} else {
				//If no matching assets exist, something went out of sync during future method invocation,
				//it will be taken care off during basket finalisation step
				return;
			}
		}
		List<Oblix_Project_Assets__c> assets = 
			Oblix_AssetOfferingWrapper.convertAssetWrappersToSObjects(new List<Oblix_AssetOfferingWrapper.AssetWrapper>{assetWrapper});

		delete assets;
	}

	public static Map<String, Oblix_AssetOfferingWrapper.AssetWrapper> initialiseBasketFromDB(Id campaignId) {
		List<Oblix_Project_Assets__c> storedAssets = [SELECT Id, 
															 Asset_name__c,
															 Asset_Title__c,
															 Agency_Projects__c,
															 Asset_Score__c,
															 Quantity__c,
															 Additional_Description__c,
															 Option_Name__c,
															 Sub_Category__c,
															 Asset_Type__c,
															 Location__c,
															 Description__c,
															 mdm_id__c
													  FROM 
															Oblix_Project_Assets__c 
													  WHERE 
														 	Agency_Projects__c = :campaignId];
		System.debug('### storedAssets: ' + storedAssets);

		List<Oblix_AssetOfferingWrapper.AssetWrapper> storedAssetWrappers = 
			Oblix_AssetOfferingWrapper.convertAssetsToItemsInBasket(storedAssets);

		System.debug('### storedAssetWrappers: ' + storedAssetWrappers);

		Map<String, Oblix_AssetOfferingWrapper.AssetWrapper> itemsInBasketMap = 
			new Map<String, Oblix_AssetOfferingWrapper.AssetWrapper>();

		for (Oblix_AssetOfferingWrapper.AssetWrapper assetWrapper : storedAssetWrappers) {
			itemsInBasketMap.put(assetWrapper.mdm_id, assetWrapper);
		}

		return itemsInBasketMap;
	}

}