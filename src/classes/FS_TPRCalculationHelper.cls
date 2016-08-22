/**********************************************************************
Purpose: Helper Class used to calculate TPR.
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    12/Jul/2016     Draft                     
***********************************************************************/

/** Helper Class for TPR Calculation:
*  @name FS_TPRCalculationHelper
*  @param N/A
*  @return N/A
*  @throws N/A
*/
public class FS_TPRCalculationHelper {

    public static void calculateTPR(List<OpportunityLineItem> oppProdList, boolean isUpdate) {
    	
        List<OpportunityLineItem> finalOppProdList = new List<OpportunityLineItem>();
        
        //Query Opportunity Entries
        Set<Id> opportunityIdList = new Set<Id>();
		for(OpportunityLineItem oli : oppProdList) {
            opportunityIdList.add(oli.OpportunityId);
        }
        
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([SELECT ID, 
                                                                            FS_supplyCost__c,
                                                                            FS_casesPiece__c,
                                                                            FS_offInvoice__c,
                                                                            FS_onInvoice__c,
                                                                            FS_selfCollection__c, 
                                                                            FS_prePaid__c, 
                                                                            FS_distributor__c
                                           								FROM Opportunity
                                           								WHERE Id IN : opportunityIdList]);
        		
        //Query Pricebook Entries
        Set<Id> PricebookEntryIdList = new Set<Id>();
        for(OpportunityLineItem oli : oppProdList) {
            PricebookEntryIdList.add(oli.PricebookEntryId);            
        }
        
        Map<Id, PricebookEntry> priceBookEntryMap = new Map<Id, PricebookEntry>([SELECT Id, 
                                                                                 		FS_salesOrgCode__c, 
                                                                                 		FS_VAT__c,
                                                                                 		UnitPrice
                                                                                 FROM PricebookEntry
                                                                                 WHERE Id IN : PricebookEntryIdList]);
        //Query Product Entries
        Set<Id> ProductIdList = new Set<Id>();
        for(OpportunityLineItem oli : oppProdList) {
            ProductIdList.add(oli.Product2Id);
        }
        
        Map<Id, Product2> product2Map = new Map<Id, Product2>([SELECT Id, 
                                                                   FS_temporaryTPR__c, 
                                                                   FS_stdPerUnit__c, 
                                                                   FS_ZSU__c,
                                                               	   FS_VATRU__c,
                                                               	   FS_VATUA__c
                                                   			   FROM Product2
                                                  			   WHERE Id IN : ProductIdList]);
        
        for(OpportunityLineItem oppProd : oppProdList) {
            
            try {
                
                //if(oppProd.FS_tprPercent__c  != null) {
                if(isUpdate) {
                
                    //Calculate Additional Discount
                    oppProd.FS_additionalDiscount__c = FS_TPRUtil.calculateAdditionalDiscount(oppProd, opportunityMap);
                    
                    //Calculate Total TPR %            
                    oppProd.FS_totalTPRPercentage__c = oppProd.FS_tprPercent__c + oppProd.FS_additionalDiscount__c;
                    
                    //Calculate GSV
                    oppProd.FS_grossSalesValue__c = FS_TPRUtil.calculateGSV(oppProd, opportunityMap, product2Map, priceBookEntryMap);
                    
                    //Calculate TPR
                    oppProd.FS_temporaryPriceReduction__c = FS_TPRUtil.calculateTPR(oppProd);
                    
                    //Calculate NIV
                    oppProd.FS_netInvoiceValue__c = FS_TPRUtil.calculateNIV(oppProd, product2Map, opportunityMap);
                    
                    //Calculate TurnOver
                    oppProd.FS_turnover__c = FS_TPRUtil.calculateTurnOver(oppProd, opportunityMap);
                    
                    //Calculate PC
                    oppProd.FS_productCost__c = FS_TPRUtil.calculatePC(oppProd, product2Map, opportunityMap);
                    
                    //Calculate SC
                    oppProd.FS_supplyCost__c = FS_TPRUtil.calculateSC(oppProd, opportunityMap);
                    
                    //Calculate SCC
                    oppProd.FS_supplyCostChain__c = oppProd.FS_productCost__c + oppProd.FS_supplyCost__c;
                    
                    //Calculate GP
                    oppProd.FS_grossProfit__c = oppProd.FS_turnover__c - oppProd.FS_supplyCostChain__c;
                    
                    //Calculate GM
                    oppProd.FS_grossMargin__c = (oppProd.FS_grossProfit__c / oppProd.FS_turnover__c) * 100;
                    
                    //Calculate GM when TPR = 0%
                    oppProd.FS_gmWhenTPREqualsZero__c = FS_TPRUtil.calculateGMWithTPREqualsZero(oppProd, product2Map, opportunityMap);
                    
                    if(oppProd.FS_valueNecessaryWithVAT__c !=null || oppProd.FS_DistributorMarkup__c !=null) {
                        calculateTPRWithGivenPriceUtil(oppProd, opportunityMap, priceBookEntryMap, product2Map);    
                    }                
                    
                    finalOppProdList.add(oppProd);
            	}
                
            } catch(Exception e) {
            System.debug( 'The following exception has occurred: '+e.getMessage() );
            ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 
                                                  'FS_TPRCalculationHelper', 
                                                  'calculateTPR', 
                                                  e.getMessage(), 
                                                  e, null, null, null, 
                                                  0,'Food Solution');
        	}            
        }        
    }
    
    private static void calculateTPRWithGivenPriceUtil(OpportunityLineItem oppProd, 
                                                           Map<Id, Opportunity> opportunityMap, 
                                                           Map<Id, PricebookEntry> priceBookEntryMap,
                                                           Map<Id, Product2> product2Map) {        
        
        //Calculate VAT
        oppProd.FS_vat__c = FS_TPRWithGivenPriceUtil.calculateVAT(oppProd, priceBookEntryMap, product2Map);
        
        //Calculate Price1 with Discount with VAT
        oppProd.FS_Price1WithDiscountWithVAT__c = FS_TPRWithGivenPriceUtil.calculatePriceWithDiscountWithVAT(oppProd, opportunityMap, priceBookEntryMap, product2Map);
        
        //Calculate Necessary TPR
        oppProd.FS_necessaryTPR__c = FS_TPRWithGivenPriceUtil.calculateValueNecessaryTPR(oppProd, opportunityMap, product2Map);
    }
}