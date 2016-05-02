public with sharing class OV_NewShelfTileController {
	public OV_Shelf_Tile__c record{get;set;}

	public OV_NewShelfTileController(ApexPages.StandardController standardController) {
		record = (OV_Shelf_Tile__c)standardController.getRecord();
	}

	public void calculateSortOrder(){
		if(record.Shelf__c != null){
			List<OV_Shelf_Tile__c> shelfTiles = [SELECT Id, Sort_Order__c FROM OV_Shelf_Tile__c WHERE Shelf__c =:record.Shelf__c ORDER BY Sort_Order__c DESC LIMIT 1];
			if( !shelfTiles.isEmpty() ){
				record.Sort_Order__c = shelfTiles[0].Sort_Order__c+1;
			}else{
				record.Sort_Order__c = 1;
			}
		}
	}
}