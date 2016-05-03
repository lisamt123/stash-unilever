/**********************************************************************
Name: WINatPOSDropDownController
Copyright © 2014 Unilever.
======================================================
==========================================================
Purpose: Apex controller to support retrive picklist values for 
Used in: WINatPOSNewCategory,WINatPOSNewBrand,WINatPOSNewAssetGroup,WINatPOSNewAsset VisualForce page
==========================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          10/12/2014      INITIAL DEVELOPMENT
***********************************************************************/
public with sharing class WINatPOSDropDownController {
    @TestVisible private SObject currentObject;
    @TestVisible private Asset__c currentAsset;
    @TestVisible private Brand_Master__c currentBrand;
    @TestVisible private Category__c currentCategory;
    @TestVisible private Asset_Group__c currentAssetGroup;
    @TestVisible private Category_Brands__c currentCategoryBrand;
	@TestVisible private String objectAPIName;
    public Boolean isRecordEditable{get;set;}
	public SelectOption[] selectedAgenciesEdit { get; set; }
	public SelectOption[] selectedAgenciesView { get; set; }
    public SelectOption[] allAgenciesEdit { get; set; }
    public SelectOption[] allAgenciesView { get; set; }
    public Boolean isCommunityUser { get; set; }
    /*****************************************************************************************
    Purpose: Constructor - Retrieves Asset field in case of a new File record is being created
             If the File record exists, it retrives the fields populated on the record
    Parameters: ApexPages StandardController
    Returns: Void
    Throws [Exceptions]: [optional]
    ******************************************************************************************/   
    public WINatPOSDropDownController(ApexPages.StandardController sc) {
        try{	
        	isCommunityUser = Network.getNetworkId() != null;
                this.currentObject=(SObject)sc.getRecord();
                objectAPIName=this.currentObject.getSObjectType().getDescribe().getName();
                if(objectAPIName == 'Asset__c'){
                	//sc.addFields(new List<String>{'Agency_Edit_Access_Text__c'});
                    this.currentAsset=(Asset__c)sc.getRecord();
                    if(this.currentAsset.id == null){
                       this.currentAsset.OwnerId=UserInfo.getUserId();
                    }else{
                        List<UserRecordAccess> recordAccessLst = [Select HasEditAccess,RecordId FROM UserRecordAccess where RecordId =:this.currentAsset.id AND UserId =: UserInfo.getUserId()];
                        if(!recordAccessLst.isEmpty()){
                            isRecordEditable = recordAccessLst.get(0).HasEditAccess;
                        }else{
                            isRecordEditable = false;
                        }
                    	Asset__c tmpCurrentAsset = [SELECT Agency_Edit_Access_Text__c, Agency_Read_Access_Text__c FROM Asset__c WHERE Id = :this.currentAsset.Id LIMIT 1];
                    	this.currentAsset.Agency_Edit_Access_Text__c = tmpCurrentAsset.Agency_Edit_Access_Text__c;
                    	this.currentAsset.Agency_Read_Access_Text__c = tmpCurrentAsset.Agency_Read_Access_Text__c;
                    }
                }else if(objectAPIName == 'Brand_Master__c'){
                    this.currentBrand=(Brand_Master__c)sc.getRecord();
                }else if(objectAPIName == 'Category__c'){
                    this.currentCategory=(Category__c)sc.getRecord();
                }else if(objectAPIName == 'Asset_Group__c'){
                    this.currentAssetGroup=(Asset_Group__c)sc.getRecord();
                    if(this.currentAssetGroup.id == null){
                        this.currentAssetGroup.OwnerId=UserInfo.getUserId();
                    }
                }else if(objectAPIName == 'Category_Brands__c'){
                    this.currentCategoryBrand=(Category_Brands__c)sc.getRecord();
                }
                system.debug(objectAPIName);
            
        }catch(Exception ex){
            //retrive object without OwnerId as it's a masterdetail relation
            system.debug('Exception Occured inside controller initialization WINatPOSDropDownController'+ex.getMessage());
            this.currentObject = (SObject)sc.getRecord();
        }
        system.debug(objectAPIName);
        if(objectAPIName == 'Category_Brands__c'){
            String prevPage=ApexPages.currentPage().getParameters().get('retURL');
            system.debug('check prevPage url :'+prevPage);
            String regexPattern='.*\\?id=(.+?)';
            try{
                Pattern logoPattern = Pattern.compile(regexPattern);
                Matcher logoMatcher=logoPattern.matcher(prevPage);
                Id parentRecordId=null;
            
                if(logoMatcher.matches() && logoMatcher.groupCount() == 1){
                    parentRecordId=Id.valueOf(logoMatcher.group(1));
                }
                system.debug(logoMatcher.groupCount());
                String parentRecordAPIName=parentRecordId.getSObjectType().getDescribe().getName();
                if(parentRecordAPIName =='Brand_Master__c'){
                    this.currentCategoryBrand.Brand__c=parentRecordId;
                }else if(parentRecordAPIName =='Category__c'){
                    this.currentCategoryBrand.Category__c=parentRecordId;
                }
            }catch(Exception ex){
                system.debug('Exception occurred while trying parsing parentRecordId for Category Brands'+ex.getMessage());
            }
            
        }
        //this case block handling scenario when asset is created under Asset Group
        if(objectAPIName == 'Asset__c'){
            String prevPage=ApexPages.currentPage().getParameters().get('retURL');
            system.debug('check prevPage url :'+prevPage);
            String regexPattern='.*\\?id=(.+?)';
            try{
                Pattern logoPattern = Pattern.compile(regexPattern);
                Matcher logoMatcher=logoPattern.matcher(prevPage);
                Id parentRecordId=null;
                //Populate fields from Asset Group when Asset is created under Asset Group
                if(logoMatcher.matches() && logoMatcher.groupCount() == 1){
                    parentRecordId=Id.valueOf(logoMatcher.group(1));
                    system.debug(logoMatcher.groupCount());
                    String parentRecordAPIName=parentRecordId.getSObjectType().getDescribe().getName();
                    //fields should be overwritten only if new asset is created
                    if(parentRecordAPIName =='Asset_Group__c' && sc.getId() == null){
                        system.debug('Asset fields will be populated from Asset Group');
                        Asset_Group__c tmpAssetGroup=[select id,Brand__c,Category__c,Market_Cluster__c,Type__c from Asset_Group__c where id=:parentRecordId limit 1];
                        if(tmpAssetGroup != null){
                            this.currentAsset.Asset_Group__c=tmpAssetGroup.id;
                            this.currentAsset.Brand__c=tmpAssetGroup.Brand__c;
                            this.currentAsset.Category__c=tmpAssetGroup.Category__c;
                            this.currentAsset.Market_Cluster__c=tmpAssetGroup.Market_Cluster__c;
                            this.currentAsset.POS_Asset_Type__c=tmpAssetGroup.Type__c;
                        }
                    }
                }
                
            }catch(Exception ex){
                system.debug('Exception occurred while trying parsing parentRecordId of Asset Group while creating new Asset'+ex.getMessage());
            }
            
        }
        
        
        selectedAgenciesEdit = new List<SelectOption>();
        selectedAgenciesView = new List<SelectOption>();
        allAgenciesEdit = new List<SelectOption>();
        allAgenciesView = new List<SelectOption>();
        
        List<Group> winAtPosPublicGroups = [SELECT Name, Id FROM Group WHERE Name like 'Win@POS%' ORDER BY Name];    
        
        
        for ( Group publicGroup : winAtPosPublicGroups ) {
        	if(this.currentAsset!= null && !String.isBlank(this.currentAsset.Agency_Edit_Access_Text__c) && this.currentAsset.Agency_Edit_Access_Text__c.contains(publicGroup.Name)){
        		selectedAgenciesEdit.add(new SelectOption(publicGroup.Id, publicGroup.Name));
        	}else{
            	allAgenciesEdit.add(new SelectOption(publicGroup.Id, publicGroup.Name));
        	}
        	
        	if(this.currentAsset!= null && !String.isBlank(this.currentAsset.Agency_Read_Access_Text__c) && this.currentAsset.Agency_Read_Access_Text__c.contains(publicGroup.Name)){
        		selectedAgenciesView.add(new SelectOption(publicGroup.Id, publicGroup.Name));
        	}else{
            	allAgenciesView.add(new SelectOption(publicGroup.Id, publicGroup.Name));
        	}
        }
    }
    
    /*******************************************************************
    Purpose: Method returns current object API Name
    Parameters: [optional]
    Returns: String
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public String getObjectAPIName(){
    	return objectAPIName;
    }
    
    /*******************************************************************
    Purpose: Method returns Owner Name of current record
    Parameters: [optional]
    Returns: String
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public String getOwnerName(){
        if(objectAPIName == 'Asset_Group__c' && this.currentAssetGroup != null && this.currentAssetGroup.id != null){
            
            Asset_Group__c tmpAssetGroup=[select OwnerId from Asset_Group__c where id =: this.currentAssetGroup.id limit 1];
            if(tmpAssetGroup != null && tmpAssetGroup.OwnerId != null){
                return [select Name from user where id =: tmpAssetGroup.OwnerId].get(0).Name;
            }
        }
        return '';
    }
    
    /*******************************************************************
    Purpose: Method return list of categries
    Parameters: [optional]
    Returns: List<selectOption>
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public List<selectOption> getCategories() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('', '- None - '));
         
        for (Category__c cat : [SELECT Id, Name FROM Category__c order by name asc limit 1000]) {
            options.add(new selectOption(cat.Id, cat.Name));
        }
            
        return options;
    }
    
    /*******************************************************************
    Purpose: Method return  list of brands 
    Parameters: [optional]
    Returns: List<selectOption>
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public List<selectOption> getBrands() {
         system.debug('rebuilding brands');
         List<selectOption> options = new List<selectOption>();
         
        options.add(new selectOption('', '- None -'));
        Id selectedCategoryId=null;
        Id currentBrandIdSelected=null;
        if(objectAPIName == 'Asset__c' && this.currentAsset.Category__c != null){
            selectedCategoryId=this.currentAsset.Category__c;
        }
        if(objectAPIName == 'Asset_Group__c' && this.currentAssetGroup.Category__c != null){
            selectedCategoryId=this.currentAssetGroup.Category__c;
        }
        if(selectedCategoryId != null){
            for(Category_Brands__c brand: [select Brand__r.Name,Brand__c from Category_Brands__c  where Category__c =:selectedCategoryId order by Brand__r.Name asc limit 1000]){
               options.add(new selectOption(brand.Brand__c, brand.Brand__r.Name));     
            }
            system.debug('check if list was reloaded '+options.size());
        }else{
            for (Brand_Master__c brand : [SELECT Id, Name FROM Brand_Master__c order by name asc limit 1000]) { 
                options.add(new selectOption(brand.Id, brand.Name)); 
            }  
        }
        
        return options;
    }
    
    /*******************************************************************
    Purpose: Method return  list of Asset Groups 
    Parameters: [optional]
    Returns: List<selectOption>
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public List<selectOption> getAssetGroups() {
         List<selectOption> options = new List<selectOption>();
         
         options.add(new selectOption('', '- None -')); 
         for (Asset_Group__c assetGroup : [SELECT Id, Name FROM Asset_Group__c order by name asc limit 1000]) { 
            options.add(new selectOption(assetGroup.Id, assetGroup.Name)); 
         }
         return options;
    }
    
    /*******************************************************************
    Purpose: Method return  list of Categories which don't have parent categories 
    Parameters: [optional]
    Returns: List<selectOption>
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public List<selectOption> getParentCategories() {
         List<selectOption> options = new List<selectOption>(); 
         
         options.add(new selectOption('', '- None - '));
         for (Category__c cat : [SELECT Id, Name FROM Category__c where Parent_Category__c = null order by name asc limit 1000]) {
             options.add(new selectOption(cat.Id, cat.Name));
         }
         return options;
    }
    
    /*****************************************************************************************
    Purpose: Sves Asset__c
    Parameters: [Exceptions]
    Returns: PageReference
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    public PageReference saveAsset() { 
    	
    	this.currentAsset.Agency_Edit_Access_Text__c = '';
    	this.currentAsset.Agency_Read_Access_Text__c = '';
    	
    	for(SelectOption option : selectedAgenciesEdit){
    		if(String.isBlank(this.currentAsset.Agency_Edit_Access_Text__c)){
    			this.currentAsset.Agency_Edit_Access_Text__c = option.getLabel();
    		}else if(!this.currentAsset.Agency_Edit_Access_Text__c.contains(option.getLabel())){
    			this.currentAsset.Agency_Edit_Access_Text__c += ';' + option.getLabel();
    		}
    	}
    	
    	for(SelectOption option : selectedAgenciesView){
    		if(String.isBlank(this.currentAsset.Agency_Read_Access_Text__c)){
    			this.currentAsset.Agency_Read_Access_Text__c = option.getLabel();
    		}else if(!this.currentAsset.Agency_Read_Access_Text__c.contains(option.getLabel())){
    			this.currentAsset.Agency_Read_Access_Text__c += ';' + option.getLabel();
    		}
    	}
    	
    	try{
    		upsert this.currentAsset;
    	}catch(Exception ex){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
    	}
    	
    	return new ApexPages.StandardController(this.currentAsset).view(); 
    }

}