/*****************************************************************************************
* @author       Execloud ©
* @date         2016-01-06
* @description  Apex wrapper class used to build the structure of assets offered by Unilever
*				in the form of type/sub-category/option/asset name 
*               portion of sample JSON added below to help understand the structure:

{  
   "map_asset_type_wrapper":{  
      "Audio Visual":{  
         "type_name":"Audio Visual",
         "type_description":"Full creative development ",
         "sub_category_items_count":6,
         "map_sub_categories":{  
            "Adaptations and Reedits":{  
               "type_index":4,
               "sub_category_name":"Adaptations and Reedits",
               "option_items_count":5,
               "map_asset_options":{  
                  "Option 1":{  
                     "type_index":4,
                     "sub_category_index":5,
                     "option_name":"Option 1",
                     "option_description":"Simple editing of script (for radio)",
                     "map_asset_names":{  
                        "Film Re-edit":{  
                           "type_name":"Audio Visual",
                           "type_index":4,
                           "sub_category_name":"Adaptations and Reedits",
                           "sub_category_index":5,
                           "point_score":50.0,
                           "option_name":"Option 1",
                           "option_index":4,
                           "index":6,
                           "asset_name":"Film Re-edit"
                        },
                        "Other":{  
                           "type_name":"Audio Visual",
                           "type_index":4,
                           "sub_category_name":"Adaptations and Reedits",
                           "sub_category_index":5,
                           "point_score":50.0,
                           "option_name":"Option 1",
                           "option_index":4,
                           "index":5,
                           "asset_name":"Other"
                        }
                     },
                     "index":4,
                     "asset_names_count":7
                  },
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Execloud ©            	2016-02-15          Created
*
******************************************************************************************/
public with sharing class Oblix_AssetOfferingWrapper {
	
    // top level wrapper which will contain Type/Subgroup/option/asset structure
    public Map<String, AssetTypeWrapper> map_asset_type_wrapper {get;set;}
    public List<String> list_asset_types_in_order {get;set;}
    //private static Id wrapper_campaign_id;

    //public static Map<String, AssetWrapper> map_of_mdm_id_to_asset;// = new Map<String, AssetWrapper>();
    ////public Map<String, AssetWrapper> map_mdm_id_to_asset;
    //public static Oblix_AssetOfferingWrapper asset_offering;// = new Oblix_AssetOfferingWrapper();
    ////public Oblix_AssetOfferingWrapper asset_offering_instance;
    ////public Oblix_AssetOfferingWrapper asset_offering_instance;


    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  Check org cache, return Oblix_AssetOfferingWrapper if the record
                    already exists in the cache, otherwise instanciate by querying 
                    asset scoring records, building a new instance, setting the cache
                    and returning the object
    ********************************************************************************/
    public static Oblix_AssetOfferingWrapper getAssetOfferingWrapper(){
            // check the instance variable asset_offering and return if already set
            
            List<Asset_Scoring__c> oblix_asset_scoring;

            // temp
            //Cache.Org.put('local.Oblix.AssetScoring', '');

            if (NULL != Oblix_Utils.asset_offering){
                system.debug('## getting values static');
                return Oblix_Utils.asset_offering;
            }

            //check in the cache first
            if (Cache.Org.contains('local.Oblix.AssetScoring') && '' != Cache.Org.get('local.Oblix.AssetScoring')){
                system.debug('## getting values from cache');
                oblix_asset_scoring = (List<Asset_Scoring__c>) Cache.Org.get('local.Oblix.AssetScoring');
            }
            else{ 
                system.debug('## setting values to cache');
                // get box range record types only
                String soql_query = 'SELECT Type__c, Sub_Category__c, Asset_Option__c, Asset_name__c, Point_Score__c ';
                soql_query += ' ,Asset_Option_Description__c, Sub_Category_Description__c, mdm_id__c, Is_Active__c ';
                soql_query += ' FROM Asset_Scoring__c ORDER BY Layout_Order__c';

                system.debug('##soql_query: '+soql_query);
                oblix_asset_scoring = Database.query(soql_query);
//IR                Cache.Org.put('local.Oblix.AssetScoring', oblix_asset_scoring);
            }

            Oblix_Utils.asset_offering = new Oblix_AssetOfferingWrapper(oblix_asset_scoring);
            return Oblix_Utils.asset_offering;

    }
    public Oblix_AssetOfferingWrapper(){}
    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  for a given mdm_id key, get asset wrapper object
    ********************************************************************************/
    //public static AssetWrapper getAssetByMDMId(String mdm_id){

    //    AssetWrapper asset_wrapper_to_return;

    //    if (map_mdm_to_asset.containsKey(mdm_id)){
    //        asset_wrapper_to_return = map_mdm_to_asset.get(mdm_id);
    //    }

    //    return asset_wrapper_to_return;
    //}


    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  for a given mdm_id key, get asset wrapper object
    ********************************************************************************/
    public static AssetWrapper getAssetWrapperByMDMId(String mdm_id){

        AssetWrapper asset_wrapper_to_return = new AssetWrapper();
        
        // if the static variable does not exist
        // then call it to initialise
        if (NULL == Oblix_Utils.asset_offering){
            getAssetOfferingWrapper();
        }

        //system.debug('##map_mdm_id_to_asset: ' + map_mdm_id_to_asset);
        if (NULL != Oblix_Utils.map_of_mdm_id_to_asset && Oblix_Utils.map_of_mdm_id_to_asset.containsKey(mdm_id)){
            asset_wrapper_to_return = Oblix_Utils.map_of_mdm_id_to_asset.get(mdm_id);
        }

        return asset_wrapper_to_return;
    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  Constructor which accepts a list of Asset_Scoring__c and campaign_id and builds
                    map_asset_type_wrapper structure based on the passed in records
    ********************************************************************************/
    public Oblix_AssetOfferingWrapper(List<Asset_Scoring__c>  asset_scorings, Id campaign_id){
        this(asset_scorings);
        setCampaignId(campaign_id);
    }

    private void setCampaignId(Id campaign_id){
        Oblix_Utils.wrapper_campaign_id = campaign_id;
    }
    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  Constructor which accepts a list of Asset_Scoring__c and builds
                    map_asset_type_wrapper structure based on the passed in records
    ********************************************************************************/
    public Oblix_AssetOfferingWrapper(List<Asset_Scoring__c>  asset_scorings) {


        map_asset_type_wrapper = new Map<String, AssetTypeWrapper>();
        list_asset_types_in_order = new List<String>();
        //map_mdm_id_to_asset = new Map<String, AssetWrapper>();

        // can identify each item by a unique index number
        Integer index = 0;

        for (Asset_Scoring__c asset: asset_scorings){

            // if the item is not already added to the map, use index 0 and call the lower level constructor
            // and increment the index of asset_type items
            if (!map_asset_type_wrapper.containsKey(asset.Type__c)){
                map_asset_type_wrapper.put(asset.Type__c, new AssetTypeWrapper(asset, index));
                list_asset_types_in_order.add(asset.Type__c);
                index++;
            }
            // for the given item in the map call the .add method in the top level tier of the structure to build up
            // tier 1 (type)
            map_asset_type_wrapper.get(asset.Type__c).add(asset);

        }
	}

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  convert a retrieved list of Oblix_Project_Assets__c records into
                    corresponding AssetWrapper records for basket section
    ********************************************************************************/
    public static AssetWrapper convertAssetToItemInBasket(Oblix_Project_Assets__c asset){

        AssetWrapper newBasketItem = new AssetWrapper();

        // if the static variable does not exist
        // then call it to initialise
        if (NULL == Oblix_Utils.asset_offering){
            getAssetOfferingWrapper();
        }

        // initialise 
        // loop through the stored assets and return list of asset wrapper
        
        if (NULL != Oblix_Utils.map_of_mdm_id_to_asset && Oblix_Utils.map_of_mdm_id_to_asset.containsKey(asset.mdm_id__c) 
                && NULL != Oblix_Utils.map_of_mdm_id_to_asset.get(asset.mdm_id__c)) {

            newBasketItem = Oblix_Utils.map_of_mdm_id_to_asset.get(asset.mdm_id__c).clone();
            
            newBasketItem.asset_name = asset.Asset_name__c; // confirm which one should be used? Asset_Title__c vs. Asset_Name__c ? which one?
            newBasketItem.other_name = asset.Location__c;
            newBasketItem.campaign_id = asset.Agency_Projects__c;
            newBasketItem.asset_id = asset.Id;
            newBasketItem.point_score = asset.Asset_Score__c;
            newBasketItem.quantity_in_basket = asset.Quantity__c.intValue();
            newBasketItem.other_description_info = asset.Additional_Description__c;
            newBasketItem.description = asset.Description__c;
        }

        return newBasketItem;
    }


    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  convert a retrieved list of Oblix_Project_Assets__c records into
                    corresponding AssetWrapper records for basket section
    ********************************************************************************/
    public static List<AssetWrapper> convertAssetsToItemsInBasket(List<Oblix_Project_Assets__c> stored_assets){

        List<AssetWrapper> li_asset_wrapper = new List<AssetWrapper>();

        // if the static variable does not exist
        // then call it to initialise
        if (NULL == Oblix_Utils.asset_offering){
            getAssetOfferingWrapper();
        }

        // initialise 
        // loop through the stored assets and return list of asset wrapper
        for (Oblix_Project_Assets__c asset : stored_assets){
            if (NULL != Oblix_Utils.map_of_mdm_id_to_asset && Oblix_Utils.map_of_mdm_id_to_asset.containsKey(asset.mdm_id__c) 
                    && NULL != Oblix_Utils.map_of_mdm_id_to_asset.get(asset.mdm_id__c)) {
                
                AssetWrapper newBasketItem = convertAssetToItemInBasket(asset);

                li_asset_wrapper.add(newBasketItem);
            }

        }
        return li_asset_wrapper;
    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  convert a retrieved list of AssetWrapper records into
                    corresponding Oblix_Project_Assets__c records for storage
    ********************************************************************************/
    public static Oblix_Project_Assets__c convertAssetWrapperToSObject(AssetWrapper assetWrapper){

            
        Oblix_Project_Assets__c newAsset = new Oblix_Project_Assets__c();
        
        newAsset.Asset_Name__c = assetWrapper.asset_name; // confirm which one should be used? Asset_Title__c vs. Asset_Name__c ? which one?
        newAsset.Location__c = assetWrapper.other_name;
        newAsset.Agency_Projects__c = assetWrapper.campaign_id;
        newAsset.Campaign_Id__c = assetWrapper.campaign_id; //Used by Duplicate Management Rule
        newAsset.Id = assetWrapper.asset_id;
        newAsset.Asset_Score__c = assetWrapper.point_score;
        newAsset.Quantity__c = assetWrapper.quantity_in_basket;
        newAsset.Additional_Description__c = assetWrapper.other_description_info;


        newAsset.Option_Name__c = assetWrapper.option_name;
        newAsset.Sub_Category__c  = assetWrapper.sub_category_name;
        newAsset.Asset_Type__c = assetWrapper.type_name;
        newAsset.mdm_id__c = assetWrapper.mdm_id;
        newAsset.Description__c = assetWrapper.description;


        return newAsset;
    }


    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  convert a retrieved list of AssetWrapper records into
                    corresponding Oblix_Project_Assets__c records for storage
    ********************************************************************************/
    public static List<Oblix_Project_Assets__c> convertAssetWrappersToSObjects(List<AssetWrapper> assetWrappers){

        List<Oblix_Project_Assets__c> li_asset_sobject = new List<Oblix_Project_Assets__c>();

        // initialise 
        // loop through the stored assets and return list of asset wrapper
        for (AssetWrapper assetWrapper : assetWrappers){
            
            Oblix_Project_Assets__c newAsset = convertAssetWrapperToSObject(assetWrapper);
            li_asset_sobject.add(newAsset);

        }
        return li_asset_sobject;
    }

    public static AssetWrapper initialiseAssetWrapper(Id campaignId, String assetName, String otherName, String mdmdId, Integer quantity, String notes) {

        System.debug('## otherName: ' + otherName);
        AssetWrapper assetWrapper = getAssetWrapperByMDMId(mdmdId);
        assetWrapper.campaign_id = campaignId;
        assetWrapper.asset_name = assetName;
        assetWrapper.other_name = otherName.trim();
        assetWrapper.quantity_in_basket = quantity;
        assetWrapper.other_description_info = notes;
        assetWrapper.mdm_id = mdmdId;

        return assetWrapper;
    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  Wrapper class to build AssetType structure 
    ********************************************************************************/
    public class AssetTypeWrapper{

        public String type_name {get;set;}
        public Integer index {get;set;}

        public Map<String, AssetSubCategoryWrapper> map_sub_categories {get;set;}
        public Map<String, Set<String>> map_type_subCategoriesSet { get;set; }
        public List<String> list_sub_categories_in_order {get;set;}

        public Integer total_visible_children_count {get;set;}
        public Boolean is_visible {get;set;}
        
        private Integer sub_category_items_count;


        /*******************************************************************************
        * @author       Execloud ©
        * @date         2016-02-17
        * @description  Constructor which accepts Asset_Scoring__c and respective index
                        of the top tier (Type)
        ********************************************************************************/
        public AssetTypeWrapper( Asset_Scoring__c asset_score, Integer index){
            this.type_name = asset_score.Type__c;
            
            this.index = index;
            sub_category_items_count = 0;
            map_sub_categories = new Map<String, AssetSubCategoryWrapper>(); 
            map_type_subCategoriesSet = new  Map<String, Set<String>>(); 
            list_sub_categories_in_order = new List<String>();

            total_visible_children_count = 0;
            is_visible = false; 

        }

        /*******************************************************************************
        * @author       Execloud ©
        * @date         2016-02-17
        * @description  builds map_sub_categories map for sub-category items
        ********************************************************************************/
        public void add(Asset_Scoring__c asset_score){
            
            // if the item is not already added to the map, use index 0 and call the lower level constructor
            // and increment the index of sub-category items by 1
            if (!map_sub_categories.containsKey(asset_score.Sub_Category__c)){
                map_sub_categories.put(asset_score.Sub_Category__c, new AssetSubCategoryWrapper(asset_score, index, sub_category_items_count));
                list_sub_categories_in_order.add(asset_score.Sub_Category__c);
                sub_category_items_count++;
            }

            if(map_type_subCategoriesSet != null && !map_type_subCategoriesSet.containsKey(asset_score.Type__c)){
                map_type_subCategoriesSet.put(asset_score.Type__c, new Set<String>());
                map_type_subCategoriesSet.get(asset_score.Type__c).add(asset_score.Sub_Category__c);
            }else{
                map_type_subCategoriesSet.get(asset_score.Type__c).add(asset_score.Sub_Category__c);
            }

            // for the given item in the map call the .add method of the sub-category tier of the structure to build up
            // tier 2 (sub-categories)
            map_sub_categories.get(asset_score.Sub_Category__c).add(asset_score); 

            if (asset_score.Is_Active__c) {
                total_visible_children_count += 1;
                if (total_visible_children_count > 0 && !is_visible) {
                    is_visible = true;
                }
            }
        }
    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  Wrapper class to build Sub-Category structure 
    ********************************************************************************/
    public class AssetSubCategoryWrapper{

        public String sub_category_name {get;set;}
        public Integer index {get;set;}
        public Integer type_index {get;set;}
        public String sub_category_description {get;set;}

        public Map<String, AssetOptionWrapper> map_asset_options {get;set;}
        public Map<String, Set<String>> map_subcategories_options_set {get; set;}
        public List<String> list_asset_options_in_order {get;set;}

        public Integer total_visible_children_count {get;set;}
        public Boolean is_visible {get;set;}

        
        private Integer option_items_count;

        /*******************************************************************************
        * @author       Execloud ©
        * @date         2016-02-17
        * @description  Constructor which accepts Asset_Scoring__c and the index of
                        the 2 tiers (type/sub-category)
        ********************************************************************************/
        public AssetSubCategoryWrapper( Asset_Scoring__c asset_score, Integer type_index, Integer index){
            map_asset_options = new Map<String, AssetOptionWrapper>();
            map_subcategories_options_set = new Map<String, Set<String>>();
            list_asset_options_in_order = new List<String>();
            this.sub_category_name = asset_score.Sub_Category__c;
            this.sub_category_description = asset_score.Sub_Category_Description__c;
            this.type_index = type_index;
            this.index = index;
            
            option_items_count = 0;

            total_visible_children_count = 0;
            is_visible = false;
        }

        /*******************************************************************************
        * @author       Execloud ©
        * @date         2016-02-17
        * @description  builds map_asset_options map for asset_option items
        ********************************************************************************/
        public void add(Asset_Scoring__c asset_score){
            
            // if the item is not already added to the map, use index 0 and call the lower level constructor
            // and increment the index of asset_option items
            if (!map_asset_options.containsKey(asset_score.Asset_Option__c)){
                map_asset_options.put(asset_score.Asset_Option__c, new AssetOptionWrapper(asset_score, type_index, index, option_items_count));
                list_asset_options_in_order.add(asset_score.Asset_Option__c);
                option_items_count++;
            }

            if(map_subcategories_options_set != null && !map_subcategories_options_set.containsKey(asset_score.Sub_Category__c)){
                map_subcategories_options_set.put(asset_score.Sub_Category__c, new Set<String>());
                map_subcategories_options_set.get(asset_score.Sub_Category__c).add(asset_score.Asset_Option__c);
            }else{
                map_subcategories_options_set.get(asset_score.Sub_Category__c).add(asset_score.Asset_Option__c);
            }

            // for the given item in the map call the .add method of the asset_option tier of the structure to build up
            // tier 3 (asset_option)
            map_asset_options.get(asset_score.Asset_Option__c).add(asset_score);

            if (asset_score.Is_Active__c) {
                total_visible_children_count += 1;
                if (total_visible_children_count > 0 && !is_visible) {
                    is_visible = true;
                }
            }
        }

    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  Wrapper class to build Asset Option structure 
    ********************************************************************************/
    public class AssetOptionWrapper{

        public String option_name {get;set;}
        public String option_description {get;set;}
        public Integer index {get;set;}

        public Integer type_index {get;set;}
        public Integer sub_category_index {get;set;}

        public Integer total_visible_children_count {get;set;}
        public Boolean is_visible {get;set;}

        public Map<String,AssetWrapper> map_asset_names {get;set;}
        public Map<String, Map<String, String>> map_index_trail_for_picklist_map { get; set; }
        public List<String> list_asset_names_in_order {get;set;}
        //public Map<String, List<SelectOption>> map_index_trail_for_select_option {get; set;}
        
        
        private Integer asset_names_count;


        /*******************************************************************************
        * @author       Execloud ©
        * @date         2016-02-17
        * @description  Constructor which accepts Asset_Scoring__c and the index of
                        the 3 tiers (type/sub-category/option)
        ********************************************************************************/
        public AssetOptionWrapper( Asset_Scoring__c asset_score, Integer type_index, Integer sub_category_index, Integer index ){
            this.option_name = asset_score.Asset_Option__c;
            this.option_description = asset_score.Asset_Option_Description__c;
            
            this.type_index = type_index;
            this.sub_category_index = sub_category_index;
            this.index = index;

            map_asset_names = new Map<String, AssetWrapper>();
            //map_index_trail_for_select_option = new Map<String, List<SelectOption>>();
            map_index_trail_for_picklist_map = new Map<String, Map<String,String>>();
            list_asset_names_in_order = new List<String>();
            asset_names_count = 0;

            total_visible_children_count = 0;
            is_visible = false;
        }

        /*******************************************************************************
        * @author       Execloud ©
        * @date         2016-02-17
        * @description  builds map_asset_names map for asset_name items
        ********************************************************************************/
        public void add(Asset_Scoring__c asset_score){

            // if the item is not already added to the map, use index 0 and call the lower level constructor
            // and increment the index of asset_name items
            map_asset_names.put(asset_score.Asset_name__c, new AssetWrapper(asset_score, type_index, sub_category_index, index, asset_names_count));
            list_asset_names_in_order.add(asset_score.Asset_name__c);
            String index_trail_key = buildTrailKey();

            //if (!map_index_trail_for_select_option.containsKey(index_trail_key)){
            //    map_index_trail_for_select_option.put(index_trail_key, new List<SelectOption>());
            //}

            if (!map_index_trail_for_picklist_map.containsKey(index_trail_key)){
                map_index_trail_for_picklist_map.put(index_trail_key, new Map<String,String>());
            }

            
            //map_index_trail_for_select_option.get(index_trail_key).add(new SelectOption(asset_score.mdm_id__c, asset_score.Asset_name__c));
            map_index_trail_for_picklist_map.get(index_trail_key).put(asset_score.mdm_id__c,asset_score.Asset_name__c);
            asset_names_count++;

            if (asset_score.Is_Active__c) {
                total_visible_children_count += 1;
                if (total_visible_children_count > 0 && !is_visible) {
                    is_visible = true;
                }
            }
        }

        private String buildTrailKey(){
            return this.type_index+ '_' + this.sub_category_index + '_' + this.index;
        }

    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-02-17
    * @description  Wrapper class to build Asset Name structure - to help find the position
                    of each asset item with respect to 4 tiers (Type/Sub_Category/Option/Asset_Name)
                    each instance of this class will contain the position index and name of the structure tree
    ********************************************************************************/
    public class AssetWrapper{

        public Double point_score {get;set;}
        public String asset_name {get;set;}
        public String other_name {get;set;}
        public String option_name {get;set;}
        public String sub_category_name {get;set;}
        public String type_name {get;set;}
        public Integer quantity_in_basket {get;set;}
        public String other_description_info {get;set;}
        public String mdm_id {get;set;}
        public String description {get;set;}
        public Boolean is_active {get;set;}

        public Integer type_index {get;set;}
        public Integer sub_category_index {get;set;}
        public Integer option_index {get;set;}
        public Integer index {get;set;}
        public Id campaign_id {get;set;}
        public Id asset_id {get;set;}

        public AssetWrapper(){}

        /*******************************************************************************
        * @author       Execloud ©
        * @date         2016-02-17
        * @description  Constructor which accepts Asset_Scoring__c and the index of
                        the 4 tiers (type/sub-category/option/asset name)
        ********************************************************************************/
        public AssetWrapper( Asset_Scoring__c asset_score, Integer type_index, Integer sub_category_index, Integer option_index, Integer index, Id asset_id, Id campaign_id){
            
            this(asset_score, type_index, sub_category_index, option_index, index);

            this.campaign_id = campaign_id;
            
            this.asset_id = asset_id;
        }

        /*******************************************************************************
        * @author       Execloud ©
        * @date         2016-02-17
        * @description  Constructor which accepts Asset_Scoring__c and the index of
                        the 4 tiers (type/sub-category/option/asset name)
        ********************************************************************************/
        public AssetWrapper( Asset_Scoring__c asset_score, Integer type_index, Integer sub_category_index, Integer option_index, Integer index, Id asset_id){
            
            this(asset_score, type_index, sub_category_index, option_index, index);
            setCampaignId(campaign_id);            

        }

        private void setCampaignId(Id campaign_id){
            // if campaign_id is set at the parent class then set it here
            if (NULL != Oblix_Utils.wrapper_campaign_id){
                this.campaign_id = Oblix_Utils.wrapper_campaign_id;
            }
        }
        /*******************************************************************************
        * @author       Execloud ©
        * @date         2016-02-17
        * @description  Constructor which accepts Asset_Scoring__c and the index of
                        the 4 tiers (type/sub-category/option/asset name)
        ********************************************************************************/
        public AssetWrapper( Asset_Scoring__c asset_score, Integer type_index, Integer sub_category_index, Integer option_index, Integer index){

            this.point_score = asset_score.Point_Score__c;
            this.asset_name = asset_score.Asset_name__c; 
            this.option_name = asset_score.Asset_Option__c;
            this.sub_category_name = asset_score.Sub_Category__c;
            this.type_name = asset_score.Type__c;
            this.mdm_id = asset_score.mdm_id__c;
            this.description = asset_score.Asset_Option_Description__c;
            this.type_index = type_index;
            this.sub_category_index = sub_category_index;
            this.option_index = option_index;
            this.index = index;
            this.is_active = asset_score.Is_Active__c;
            

            setCampaignId(campaign_id);
            

            buildTheMapOfMDMDandAssets();
            
        }
        
        public Decimal getPointScoreForQuantity(){
            return point_Score * quantity_in_basket;
        }

        private void buildTheMapOfMDMDandAssets(){
            if (NULL == Oblix_Utils.map_of_mdm_id_to_asset){
                Oblix_Utils.map_of_mdm_id_to_asset = new Map<String, AssetWrapper>();
            }

            // we need to get access to map_of_mdm_id_to_asset map which exists at the top level of Oblix_AssetOfferingWrapper
            Oblix_Utils.map_of_mdm_id_to_asset.put(this.mdm_id, this);
        }

    }


}