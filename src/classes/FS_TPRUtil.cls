/**********************************************************************
Purpose: Utility Class used to calculate TPR.
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    12/Jul/2016     Draft                     
***********************************************************************/

/** Utility Class for TPR:
*  @name FS_TPRUtil
*  @param N/A
*  @return N/A
*  @throws N/A
*/
public with sharing class FS_TPRUtil {

    /** Method to Calculate Additional Discount Value:
    *  @name calculateAdditionalDiscount
    *  @param OpportunityLineItem oppProd, Map<Id, Opportunity> opportunityMap
    *  @return Double additionalDiscount
    *  @throws N/A
    */
    public static Double calculateAdditionalDiscount(OpportunityLineItem oppProd, Map<Id, Opportunity> opportunityMap) {        
        
        Double additionalDiscount = 0;
                
        if(!opportunityMap.get(oppProd.OpportunityId).FS_prePaid__c && !opportunityMap.get(oppProd.OpportunityId).FS_selfCollection__c) {
            //0%
            additionalDiscount = 0;
        } else if(!opportunityMap.get(oppProd.OpportunityId).FS_prePaid__c && opportunityMap.get(oppProd.OpportunityId).FS_selfCollection__c) {
            //1%
            //additionalDiscount = 0.01;             
            additionalDiscount = 1;  
        } else if(opportunityMap.get(oppProd.OpportunityId).FS_prePaid__c && !opportunityMap.get(oppProd.OpportunityId).FS_selfCollection__c) {
            //2%
            //additionalDiscount = 0.02;
            additionalDiscount = 2;
        } else {
            //3%
            //additionalDiscount = 0.03;
            additionalDiscount = 3;
        }            
             
        return additionalDiscount;
    }
    
    /** Method to Calculate Gross Sales Value:
    *  @name calculateGSV
    *  @param OpportunityLineItem oppProd, Map<Id, Opportunity> opportunityMap, Map<Id, Product2> product2Map, Map<Id, PricebookEntry> priceBookEntryMap
    *  @return Double gsv
    *  @throws N/A
    */
    public static Double calculateGSV(OpportunityLineItem oppProd, Map<Id, Opportunity> opportunityMap, Map<Id, Product2> product2Map, Map<Id, PricebookEntry> priceBookEntryMap) {
        Double gsv = 0;
            
        //this is a custom settings
        FS_casePiece__c cp = FS_casePiece__c.getOrgDefaults();
        
        if(opportunityMap.get(oppProd.OpportunityId).FS_casesPiece__c == cp.FS_Case__c) {
            //gsv = oppProd.Quantity * oppProd.ListPrice;
            gsv = oppProd.Quantity * priceBookEntryMap.get(oppProd.PricebookEntryId).UnitPrice;
        } else {
            
            gsv = oppProd.Quantity * (priceBookEntryMap.get(oppProd.PricebookEntryId).UnitPrice / product2Map.get(oppProd.Product2Id).FS_ZSU__c);
            //gsv = oppProd.Quantity * (oppProd.ListPrice / oppProd.Product2.FS_ZSU__c);
        }            
  
        return gsv;
    }
    
    /** Method to Calculate Net Income Value:
    *  @name calculateNIV
    *  @param OpportunityLineItem oppProd, Map<Id, Product2> product2Map, Map<Id, Opportunity> opportunityMap
    *  @return Double niv
    *  @throws N/A
    */
    public static Double calculateNIV(OpportunityLineItem oppProd, Map<Id, Product2> product2Map, Map<Id, Opportunity> opportunityMap) {
        Double niv = 0;
        //Id distId = oppProd.FS_distributor__c;        
        
        Double temporaryTPRDecimal = product2Map.get(oppProd.Product2Id).FS_temporaryTPR__c / 100;
        Double onInvoiceDecimal = opportunityMap.get(oppProd.OpportunityId).FS_onInvoice__c / 100;
                
        niv = (oppProd.FS_grossSalesValue__c - oppProd.FS_temporaryPriceReduction__c - (oppProd.FS_grossSalesValue__c * temporaryTPRDecimal)) * (1 - onInvoiceDecimal);
        
        /*
        niv = oppProd.FS_grossSalesValue__c * (1 - (product2Map.get(oppProd.Product2Id).FS_temporaryTPR__c / 100) - (oppProd.FS_totalTPRPercentage__c / 100)) 
            				* (1 - (opportunityMap.get(oppProd.OpportunityId).FS_onInvoice__c / 100));        
        */
        
        return niv;
    }
    
    /** Method to Calculate Temporary Price Reduction value:
    *  @name calculateTPR
    *  @param OpportunityLineItem oppProd
    *  @return Double tpr
    *  @throws N/A
    */
    public static Double calculateTPR(OpportunityLineItem oppProd) {

        Double tpr = 0;
        tpr = (oppProd.FS_totalTPRPercentage__c / 100) * oppProd.FS_grossSalesValue__c;  
 
        return tpr;
    }

    /** Method to Calculate Turnover value:
    *  @name calculateTurnOver
    *  @param OpportunityLineItem oppProd, Map<Id, Opportunity> opportunityMap
    *  @return Double turnOver
    *  @throws N/A
    */
    public static Double calculateTurnOver(OpportunityLineItem oppProd, Map<Id, Opportunity> opportunityMap) {
        Double turnOver = 0;
   
        turnOver = oppProd.FS_netInvoiceValue__c * (1 - (opportunityMap.get(oppProd.OpportunityId).FS_offInvoice__c / 100));
        return turnOver;
    }

    /** Method to Calculate Product Cost value:
    *  @name calculatePC
    *  @param OpportunityLineItem oppProd, Map<Id, Product2> product2Map, Map<Id, Opportunity> opportunityMap
    *  @return Double pc
    *  @throws N/A
    */
    public static Double calculatePC(OpportunityLineItem oppProd, Map<Id, Product2> product2Map, Map<Id, Opportunity> opportunityMap) {
        Double pc = 0;
        
        //this is a custom settings
        FS_casePiece__c cp = FS_casePiece__c.getOrgDefaults();
        
        if(opportunityMap.get(oppProd.OpportunityId).FS_casesPiece__c == cp.FS_Case__c) {
        
            //pc = oppProd.Quantity * product2Map.get(oppProd.Product2Id).FS_stdPerUnit__c;            
            pc = oppProd.Quantity * product2Map.get(oppProd.Product2Id).FS_stdPerUnit__c * product2Map.get(oppProd.Product2Id).FS_ZSU__c;            
        } else {
            
            //pc = oppProd.Quantity * (product2Map.get(oppProd.Product2Id).FS_stdPerUnit__c / product2Map.get(oppProd.Product2Id).FS_ZSU__c);
            pc = oppProd.Quantity * product2Map.get(oppProd.Product2Id).FS_stdPerUnit__c;
        }
        
        return pc;
    }
    
    /** Method to Calculate Supply Cost value:
    *  @name calculateSC
    *  @param OpportunityLineItem oppProd, Map<Id, Opportunity> opportunityMap
    *  @return Double sc
    *  @throws N/A
    */
    public static Double calculateSC(OpportunityLineItem oppProd, Map<Id, Opportunity> opportunityMap) {
        Double sc = 0;

        sc = (opportunityMap.get(oppProd.OpportunityId).FS_supplyCost__c / 100) * oppProd.FS_turnover__c;
        
        return sc;
    }
    
    /** Method to Calculate Gross Margin when TPR is Zero value:
    *  @name calculateGMWithTPREqualsZero
    *  @param OpportunityLineItem oppProd, Map<Id, Product2> product2Map, Map<Id, Opportunity> opportunityMap
    *  @return Double gm
    *  @throws N/A
    */
    public static Double calculateGMWithTPREqualsZero(OpportunityLineItem oppProd, Map<Id, Product2> product2Map, Map<Id, Opportunity> opportunityMap) {
        Double gm = 0;
        
        Double temporaryTPRDecimal = product2Map.get(oppProd.Product2Id).FS_temporaryTPR__c / 100;
        Double onInvoiceDecimal = opportunityMap.get(oppProd.OpportunityId).FS_onInvoice__c / 100;
        Double offnvoiceDecimal = opportunityMap.get(oppProd.OpportunityId).FS_offInvoice__c / 100;
        Double scDecimal = opportunityMap.get(oppProd.OpportunityId).FS_supplyCost__c / 100;
        
        /*
        Formula:
        ((((GSV*(1 – temporary TPR ))*(1-PPR on-invoice)) *(1-PPR off-invoice))   - PC – SC)
        ------------------------------------------------------------------------------------
        ((((GSV*(1 – temporary TPR ))*(1-PPR on-invoice)) *(1-PPR off-invoice)))
        */
        
        /* Correct Formula
         GM when TPR = 0% = (GSV * (1 - temporary discount) * (1 - on invoice) 
							- GSV * (1 - temporary discount) * (1 - on invoice) * off invoice)
							- PC - Supply Cost * (GSV * (1 - temporary discount) * (1 - on invoice) 
							- GSV * (1 - temporary discount) * (1 - on invoice) * off invoice)
							/
							(GSV * (1 - temporary discount) * (1 - on invoice) 
							- GSV * (1 - temporary discount) * (1 - on invoice) * off invoice)

		*/
        Double sc = (opportunityMap.get(oppProd.OpportunityId).FS_supplyCost__c / 100);
        
        gm = ((oppProd.FS_grossSalesValue__c * (1 - temporaryTPRDecimal) * (1 - onInvoiceDecimal)
              	- oppProd.FS_grossSalesValue__c * (1 - temporaryTPRDecimal) * (1 - onInvoiceDecimal) * offnvoiceDecimal)
             	- oppProd.FS_productCost__c - scDecimal * (oppProd.FS_grossSalesValue__c * (1 - temporaryTPRDecimal)
                * (1 - onInvoiceDecimal) - oppProd.FS_grossSalesValue__c * (1 - temporaryTPRDecimal) 
                * (1 - onInvoiceDecimal) * offnvoiceDecimal))
             /
             (oppProd.FS_grossSalesValue__c * (1 - temporaryTPRDecimal) * (1 - onInvoiceDecimal) 
                - oppProd.FS_grossSalesValue__c * (1 - temporaryTPRDecimal) * (1 - onInvoiceDecimal) * offnvoiceDecimal);
        
        /*        
        gm = ((((oppProd.FS_grossSalesValue__c * (1 - temporaryTPRDecimal)) 
                * (1 - onInvoiceDecimal))
               * (1 - offnvoiceDecimal))
              - oppProd.FS_productCost__c - oppProd.FS_supplyCost__c)              
              
            / 
            (((oppProd.FS_grossSalesValue__c * (1 - temporaryTPRDecimal))
              * (1 - onInvoiceDecimal))
             * (1 - offnvoiceDecimal));
        */
        System.debug('gm FS_grossSalesValue__c: ' + oppProd.FS_grossSalesValue__c);
        System.debug('gm temporaryTPRDecimal: ' + temporaryTPRDecimal);
        System.debug('gm onInvoiceDecimal: ' + onInvoiceDecimal);
        System.debug('gm offnvoiceDecimal: ' + offnvoiceDecimal);
        System.debug('gm FS_productCost__c: ' + oppProd.FS_productCost__c);
        System.debug('gm FS_supplyCost__c: ' + oppProd.FS_supplyCost__c);
        
        return gm * 100;
    }
}