public class Amr_QuotePageController {
        
        public String savingId{get;set;}
        public List<Amr_Quote__c> quoteOldList{get;set;}
        
        public List<Amr_Quote__c> quoteNewRow{
        get{
             if(quoteNewRow == null)
                    quoteNewRow = new List<Amr_Quote__c>();     
                return quoteNewRow;
        }set;
    }
        
        public  Document document {
        get {
          if (document == null)
             document = new Document();
             return document;
        }
        set;
   }
        
        public Amr_QuotePageController(){
                
                savingId = ApexPages.currentPage().getParameters().get('id');
            system.debug('savingId========>'+savingId);
            
            quoteOldList = [select Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                   Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PC_Costs_Euro_Amount__c,
                                   Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                   Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,
                                   PPC_Costs_Euro_Amount__c,CA_Additional_agency_Name__c,CA_Location__c,
                                   Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,CA_Costs_Euro_Amount__c,
                                   Total_Costs__c from Amr_Quote__c where Saving__c = :savingId];
            system.debug('----------quote list'+quoteOldList);
            
            Amr_Quote__c quoteObj = new Amr_Quote__c(Saving__c = savingId);
            quoteNewRow.add(quoteObj);
        }
        
        public PageReference addRowQuote(){
                system.debug('new Quote entered===>'+quoteNewRow);
            system.debug('new Quote entered===>'+document);
            insert quoteNewRow;
            for(Amr_Quote__c quoteObj: quoteNewRow){
              quoteOldList.add(quoteObj);
            }
            
            quoteNewRow.clear();
        quoteNewRow.add(new Amr_Quote__c(Saving__c = savingId));
            return null;
        }
        
}