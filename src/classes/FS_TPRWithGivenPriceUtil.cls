/**********************************************************************
Purpose: Utility Class used to calculate TPR when Price is given.
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    12/Jul/2016     Draft                     
***********************************************************************/

/** Utility Class for TPR with Given Price:
*  @name FS_TPRWithGivenPriceUtil
*  @param N/A
*  @return N/A
*  @throws N/A
*/
public with sharing class FS_TPRWithGivenPriceUtil {

    /** Method to Calculate Price with Discount and with VAT:
    *  @name calculatePriceWithDiscountWithVAT
    *  @param OpportunityLineItem oppProd, Map<Id, PricebookEntry> priceBookEntryMap, Map<Id, Product2> product2Map, Map<Id, Opportunity> opportunityMap
    *  @return Double vat
    *  @throws N/A
    */
    public static Double calculatePriceWithDiscountWithVAT(OpportunityLineItem oppProd, 
                                                           Map<Id, Opportunity> opportunityMap, 
                                                           Map<Id, PricebookEntry> priceBookEntryMap,
                                                           Map<Id, Product2> product2Map) {
        Double price = 0;
        Double priceWithDiscountWithVat = 0;
		//this is a custom settings
		FS_casePiece__c cp = FS_casePiece__c.getOrgDefaults();
        if(opportunityMap.get(oppProd.OpportunityId).FS_casesPiece__c == cp.FS_Case__c) {
			price = priceBookEntryMap.get(oppProd.PricebookEntryId).UnitPrice;
		} else {
			price = priceBookEntryMap.get(oppProd.PricebookEntryId).UnitPrice / product2Map.get(oppProd.Product2Id).FS_ZSU__c;
		}                                                             
                                                               
		priceWithDiscountWithVat = (price * (1 + (oppProd.FS_vat__c / 100))) * (1 - (product2Map.get(oppProd.Product2Id).FS_temporaryTPR__c / 100));                                                               
            
        return priceWithDiscountWithVat;
    }
    
    /** Method to Calculate Value Added Tax:
    *  @name calculateVAT
    *  @param OpportunityLineItem oppProd, Map<Id, PricebookEntry> priceBookEntryMap, Map<Id, Product2> product2Map, Map<Id, Opportunity> opportunityMap
    *  @return Double vat
    *  @throws N/A
    */
    public static Double calculateVAT(OpportunityLineItem oppProd, Map<Id, PricebookEntry> priceBookEntryMap, Map<Id, Product2> product2Map) {
        Double vat = 0;
        
            
        FS_SalesOrgCode__c soc = FS_SalesOrgCode__c.getOrgDefaults();
        FSVATRU__c vatRU = FSVATRU__c.getOrgDefaults();
        FSVATUA__c vatUA = FSVATUA__c.getOrgDefaults();
        
        String firstLetter = priceBookEntryMap.get(oppProd.PricebookEntryId).FS_salesOrgCode__c.left(1);
        
        if(firstLetter == soc.FS_RU_Code__c) {
            
            if(product2Map.get(oppProd.Product2Id).FS_VATRU__c == 1) {
                
                vat = vatRU.FS_Value_1__c;
            } else if(product2Map.get(oppProd.Product2Id).FS_VATRU__c == 2) {                
                vat = vatRU.FS_Value_2__c;
            } else {
                vat = 0;
            }
        } else if(firstLetter == soc.FS_UA_Code__c) {
            
            if(product2Map.get(oppProd.Product2Id).FS_VATRU__c == 2) {                
                vat = vatUA.FS_Value_2__c;
            } else {
                vat = 0;
            }
        } else {
            vat = 0;
        }
        
        return vat;
    }
    
    /** Method to Calculate Value Necessary for TPR:
    *  @name calculateValueNecessaryTPR
    *  @param OpportunityLineItem oppProd, Map<Id, Product2> product2Map, Map<Id, Opportunity> opportunityMap
    *  @return Double tpr
    *  @throws N/A
    */
    public static Double calculateValueNecessaryTPR(OpportunityLineItem oppProd,
                                                   	Map<Id, Opportunity> opportunityMap, 
                                                    //Map<Id, PricebookEntry> priceBookEntryMap,
                                                    Map<Id, Product2> product2Map) {
        Double tpr = 0;
                                                        
        Double temporaryTPRDecimal = product2Map.get(oppProd.Product2Id).FS_temporaryTPR__c / 100;
        Double onInvoiceDecimal = opportunityMap.get(oppProd.OpportunityId).FS_onInvoice__c / 100;
        Double onOffnvoiceDecimal = opportunityMap.get(oppProd.OpportunityId).FS_offInvoice__c / 100;
        Double distributorMarkupDecimal = oppProd.FS_DistributorMarkup__c / 100;
            
        if(opportunityMap.get(oppProd.OpportunityId).FS_onInvoice__c > 0) {
        /*
        	((((1- temporary TPR % -(Wish Price per case with VAT /(1+ Distributors Mark Up ))
            /(Price List Price with VAT after temporary TPR /(1- temporary TPR % ))))/ PPR on-invoice )
            + temporary TPR % -1)/(1/PPR on-invoice -1)
         */            
                
            tpr = ((((1 - temporaryTPRDecimal - (oppProd.FS_valueNecessaryWithVAT__c / (1 + distributorMarkupDecimal)) 
                         / (oppProd.FS_Price1WithDiscountWithVAT__c 
                         / (1 - temporaryTPRDecimal)))) 
                         / onInvoiceDecimal)
                         + temporaryTPRDecimal - 1)
                         / (1 / onInvoiceDecimal - 1);
                
        } else if(opportunityMap.get(oppProd.OpportunityId).FS_onInvoice__c == 0) {
                
            /*
				1+((temporary TPR % - ( Wish Price per case with VAT 
				/( 1+ Distributors Mark Up ))/(Price List Price with VAT after temporary TPR 
				/(1- temporary TPR % ))))- temporary TPR % *2
			*/
                
            tpr = 1 + ((temporaryTPRDecimal - (oppProd.FS_valueNecessaryWithVAT__c
                        / (1 + distributorMarkupDecimal))
                        / (oppProd.FS_Price1WithDiscountWithVAT__c / (1 - temporaryTPRDecimal))))
                        - temporaryTPRDecimal * 2;
        } else {
            tpr = 0;
        }
        
        return tpr * 100;
    }
}