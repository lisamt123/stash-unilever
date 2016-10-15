/************************************************************************************************************
 Name: UID_StockCoverTriggerHelperRankingQueue() 
 Copyright © 2016 Salesforce 
 ============================================================================================================ 
 ============================================================================================================ 
 Purpose: 
 1. Set the ranking value in Stocked Product Summary.
 ============================================================================================================ 
 ============================================================================================================ 
 History 
 --------------------------------------------------------- 
 VERSION    AUTHOR      DATE            DETAIL Description 
 1.0        Barcenas	16/05/2015 :    INITIAL DEVELOPMENT for Stocked Product Summary Ranking Calculation
 ************************************************************************************************************/
public with sharing class UID_StockCoverTriggerHelperRankingQueue implements Queueable{
    
    //wrapper class that will hold the stocked product summary that have same value of data 
    public class rankingEntry{
            public Decimal totalInvoice{get;set;}
            public String secondarySalesKey{get;set;}
        }
	    
    public Set<Id> stockedProdIds;
    
    public UID_StockCoverTriggerHelperRankingQueue(Set<Id> stockedProdIds ) {
        this.stockedProdIds = stockedProdIds;
    }
    
	
	public void execute (QueueableContext context){
		Map<string,rankingEntry> totalSecondaryInvoiceMap;    	
    	String secondarySalesMapKey;
    	    	
    	List <UID_Stocked_Product_Summary__c> stockDetails = new List <UID_Stocked_Product_Summary__c>();
          
		Map<Id, List<UID_Stocked_Product_Summary__c>> stockedProdToStockedProdSumMap = new  Map<Id, List<UID_Stocked_Product_Summary__c>>();
		
		//loop on all the included Stocked Product Summary and put the value on the map per Stocked Product Id
		for (UID_Stocked_Product_Summary__c sPS : [
											        SELECT Id, 
                                                		UID_Material_ID__c, 
                                                		UID_Stocked_Product__r.UID_Distributor__c,  
                                                		UID_Stocked_Product__r.UID_Report_Date__c,
                                                		UID_Summarized_Invoice_Value__c,
                                                		UID_Stock_Product_Summary_Ranking__c
											        FROM UID_Stocked_Product_Summary__c
											        WHERE UID_Stocked_Product__c IN :stockedProdIds
											        ORDER BY UID_Stocked_Product__c
											        ]) {
											        	
			    List<UID_Stocked_Product_Summary__c> sPSList = stockedProdToStockedProdSumMap.get(sPS.UID_Stocked_Product__c);
			    if (sPSList == null) {
			        sPSList = new List<UID_Stocked_Product_Summary__c>();
			        stockedProdToStockedProdSumMap.put(sPS.UID_Stocked_Product__c, sPSList);
			    }
			    sPSList.add(sPS);
			    stockDetails.add(sPS);
			}	
  		//loop on all the included Stocked Product and call the ranking per stocked product.
  		for(Id sPid : stockedProdToStockedProdSumMap.keyset()){
  			totalSecondaryInvoiceMap = new Map<string,rankingEntry>();
  			for(UID_Stocked_Product_Summary__c sPS: stockedProdToStockedProdSumMap.get(sPid)){
  				secondarySalesMapKey = sPS.UID_Material_ID__c + sPS.UID_Stocked_Product__r.UID_Distributor__c + UID_StockProductUtility.getReportMonth(sPS.UID_Stocked_Product__r.UID_Report_Date__c, 0);
	          	rankingEntry rankingEntryRec = new rankingEntry();
	            rankingEntryRec.secondarySalesKey = secondarySalesMapKey; 
	            rankingEntryRec.totalInvoice = sPS.UID_Summarized_Invoice_Value__c;
	            totalSecondaryInvoiceMap.put(secondarySalesMapKey, rankingEntryRec); 
  			}
  			//rank list of stocked product summary per stocked product
  			calculateSummarizedInvoiceRanking(totalSecondaryInvoiceMap, stockDetails);
  		}
          
          update stockDetails;
    
	}
	
	/******************************************************************* 
    Purpose: Summarized the Invoice Value for UID Order Product for BR1.4
    Parameters: 
            Map<string,rankingEntry>
    Returns: none
    ********************************************************************/  
    public static void calculateSummarizedInvoiceRanking(Map<string,rankingEntry> totalSecondaryInvoiceMap, List <UID_Stocked_Product_Summary__c> stockDetails){
    	 
        	Map<string,integer> totalSecondaryRankingMap = new Map<string,integer>();
            Map<Decimal,List<String>> rankToNameMap = new Map<Decimal,List<String>>();
            
            //populate the values of the map with the sales map key combination
            for(rankingEntry entry : totalSecondaryInvoiceMap.values()){
                 List<String> temp = (rankToNameMap.containsKey(entry.totalInvoice))
                 					? rankToNameMap.get(entry.totalInvoice)
                 					: new List<String>();
                
                temp.add(entry.secondarySalesKey);
                rankToNameMap.put(entry.totalInvoice, temp);
             }
            
            list<decimal> ranksList = new list<decimal>();
            list<decimal> descendingList = new list<decimal>();
            
            ranksList.addAll(rankToNameMap.keySet());
        
            //sort the value
            ranksList.sort();
            //sorting to descending order
            for(Integer i = ranksList.size()-1; i>=0;i--){
                descendingList.add(ranksList.get(i)); 
            }
            
            Integer totalSecondaryRankingMapCounter = 1;
            
            for(Decimal rank : descendingList){
                List<String> thisEntryMapList = rankToNameMap.get(rank);
                //rank the value of the list 
                for(String thisEntryString : thisEntryMapList ){   
                    totalSecondaryRankingMap.put(thisEntryString,totalSecondaryRankingMapCounter);
                    totalSecondaryRankingMapCounter +=1;
                }
            }
            
            for (UID_Stocked_Product_Summary__c sd2 : stockDetails) {
                String secondarySalesMapKey2 = sd2.UID_Material_ID__c + sd2.UID_Stocked_Product__r.UID_Distributor__c + UID_StockProductUtility.getReportMonth(sd2.UID_Stocked_Product__r.UID_Report_Date__c, 0);
                if(totalSecondaryRankingMap.containsKey(secondarySalesMapKey2)){
                    sd2.UID_Stock_Product_Summary_Ranking__c = totalSecondaryRankingMap.get(secondarySalesMapKey2);
                }
            }
            
    }
}