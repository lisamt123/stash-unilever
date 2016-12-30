/**
	@Author - alok.b.pandey@accenture.com
	@Name - UL_ProductTypeHandler 
	@CreateDate - 16-11-2016
	@Description - This class is to update ProductType field on Product record.
	@Version - 1.0
	@reference - UL_Product_Part_Trigger Trigger
	*/ 
	Public with sharing Class UL_ProductTypeHandler{
    
		/**
		@Author - alok.b.pandey@accenture.com
		@method name - productType
		@CreateDate - 16-11-2016
		@Description - This method is to update ProductType field on Product record.
		@Param - List of ProductPart
		@Version - 1.0
		@reference - NR
		*/
	    Public static void updateProductType(List<ACCL__Product_Part__c> productPartList){
	        try{
	            Set<Id> productIdSet = new Set<Id>();
	            
	            for(ACCL__Product_Part__c productPart: productPartList){
	                productIdSet.add(productPart.ACCL__Parent_Product__c);               
	            }
	        
	        
	        	List<ACCL__Product__c> updateProductList = new List<ACCL__Product__c>();
	            for(ACCL__Product__c product: [SELECT id,ACCL__Product_Type__c FROM ACCL__Product__c 
	                                                WHERE Id IN: productIdSet AND  ACCL__Product__c.ACCL__Product_Template__r.UL_Product_Type_Update__c = true 
	                                                LIMIT: (LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]){
	                product.ACCL__Product_Type__c = UL_Utility.BOM_PRODUCT;
	                updateProductList.add(product);
	            }
	            
		        if(!updateProductList.isEmpty()){    
		        	update updateProductList;
		        }
		        
		    }catch(Exception ex){
		     	UL_Utility.logError(ex, UserInfo.getUserId());
		    }
	    }
}