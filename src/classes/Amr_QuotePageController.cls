public with sharing class Amr_QuotePageController {
        
    public String savingId{get;set;}
    public List<Amr_Quote__c> quoteOldList{get;set;}
    public String IdValue{get;set;}
    public String IdDeleted{get;set;}
    public Boolean isEdit {get;set;}
    public Boolean isSave {get;set;}
    public boolean display{get;set;}
    
    
    public String localCurrency{get;set;}
    public String ppcLocalCurrency{get;set;}
    public String caLocalCurrency{get;set;}
    public String localEditCurrency{get;set;}
    public String ppcLocalEditCurrency{get;set;}
    public String caLocalEditCurrency{get;set;}
    
    public Integer localAmuont{get;set;}
    public Integer ppcLocalAmuont{get;set;}
    public Integer caLocalAmuont{get;set;} 
    public String localEditAmuont{get;set;}
    public String ppcLocalEditAmuont{get;set;}
    public String caLocalEditAmuont{get;set;}
    
    public decimal pcEuroAmount{get;set;}
    public decimal ppcEuroAmount{get;set;}
    public decimal caEuroAmount{get;set;}
    public decimal pcEuroAmountEdit{get;set;}
    public decimal ppcEuroAmountEdit{get;set;}
    public decimal caEuroAmountEdit{get;set;}
    
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
                }set;
    }
    
    public List<Amr_CurrencyConversionRate__c> currencyList {
      get{
            
                currencyList = Amr_CurrencyConversionRate__c.getall().values();     
                return currencyList ;
        }set;
    }
        
    public Amr_QuotePageController(){
      try{
            isSave = false;
           isEdit = false;
            display = true;
            
            savingId = ApexPages.currentPage().getParameters().get('id');
            system.debug('savingId========>'+savingId);
                    
            quoteOldList = [select Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           id from Amr_Quote__c where Saving__c = :savingId];
             system.debug('----------quote list'+quoteOldList);
                    
             Amr_Quote__c quoteObj = new Amr_Quote__c(Saving__c = savingId);
             quoteNewRow.add(quoteObj);
             
             }catch(Exception e){
                  system.debug('inside constructor===?');
             }
      }
      
    public void currecnyConversion(){
        
       // List<Amr_CurrencyConversionRate__c> currencyList = Amr_CurrencyConversionRate__c.getall().values();
        system.debug(localCurrency+'==========currency'+localAmuont);
        
        if(localCurrency!= null && localAmuont!=null){
            for(Amr_CurrencyConversionRate__c currencyObj:currencyList){
                if(currencyObj.Currency_Unit__c == localCurrency){
                    
                     pcEuroAmount = localAmuont * currencyObj.Currency_Unit_To_Euro__c;
                                                                                    
                }
            }
        }
    
    }
    
    public void ppcCurrecnyConversion(){
         system.debug(ppcLocalCurrency+'========ppc'+ppcLocalAmuont);
        if(ppcLocalCurrency!= null && ppcLocalAmuont!=null){
            for(Amr_CurrencyConversionRate__c currencyObj:currencyList){
                if(currencyObj.Currency_Unit__c == ppcLocalCurrency){
                    
                     ppcEuroAmount = ppcLocalAmuont * currencyObj.Currency_Unit_To_Euro__c;
                                                                                    
                }
            }
        }
    
    
    }
    
     public void caCurrecnyConversion(){
         system.debug(caLocalCurrency+'========ppc'+caLocalAmuont);
        if(caLocalCurrency!= null && caLocalAmuont!=null){
            for(Amr_CurrencyConversionRate__c currencyObj:currencyList){
                if(currencyObj.Currency_Unit__c == caLocalCurrency){
                    
                     caEuroAmount = caLocalAmuont * currencyObj.Currency_Unit_To_Euro__c;
                                                                                    
                }
            }
        }
    
    
    }
    
    
    public void pcEditCurrencyConversion(){
         system.debug(caLocalCurrency+'========ppc'+caLocalAmuont);
         Integer localEditAmuontInteger = Integer.valueOf(localEditAmuont);
        if(localEditCurrency!= null && localEditAmuontInteger!=null){
            for(Amr_CurrencyConversionRate__c currencyObj:currencyList){
                if(currencyObj.Currency_Unit__c == localEditCurrency){
                    
                     pcEuroAmountEdit = localEditAmuontInteger * currencyObj.Currency_Unit_To_Euro__c;
                                                                                    
                }
            }
        }
    
    }
    
    
    public void ppcEditCurrencyConversion(){
        
         Integer ppcLocalEditAmuontInteger = Integer.valueOf(ppcLocalEditAmuont);
        if(ppcLocalEditCurrency!= null && ppcLocalEditAmuontInteger !=null){
            for(Amr_CurrencyConversionRate__c currencyObj:currencyList){
                if(currencyObj.Currency_Unit__c == ppcLocalEditCurrency){
                    
                     ppcEuroAmountEdit = ppcLocalEditAmuontInteger * currencyObj.Currency_Unit_To_Euro__c;
                                                                                    
                }
            }
        }
    
    }
    
    
     public void caEditCurrencyConversion(){
     
     Integer caLocalEditAmuontInteger = Integer.valueOf(caLocalEditAmuont);
        if(caLocalEditCurrency!= null && caLocalEditAmuontInteger !=null){
            for(Amr_CurrencyConversionRate__c currencyObj:currencyList){
                if(currencyObj.Currency_Unit__c == caLocalEditCurrency){
                    
                     caEuroAmountEdit = caLocalEditAmuontInteger * currencyObj.Currency_Unit_To_Euro__c;
                                                                                    
                }
            }
        }
     
     }
    public PageReference addRowQuote(){
      system.debug('new Quote entered===>'+quoteNewRow);
        system.debug('new Quote entered===>'+document);
            
        if(validate(quoteNewRow,document)){
              
           /* List<Amr_CurrencyConversionRate__c> currencyList = Amr_CurrencyConversionRate__c.getall().values();
            system.debug('currency local======>'+quoteNewRow[0].PC_Costs_Local_Currency__c);
            
            for(Amr_CurrencyConversionRate__c currencyObj:currencyList){
                   system.debug(quoteNewRow[0].Local_Currency_of_PPC_Costs__c +'----comapre'+quoteNewRow[0].Local_Amount_of_PPC__c);
                    
                    if(quoteNewRow[0].Local_Currency_of_PC_Costs__c == currencyObj.Currency_Unit__c){            
                        quoteNewRow[0].PC_Costs_Euro_Amount__c = quoteNewRow[0].Local_Amount_of_PC__c * currencyObj.Currency_Unit_To_Euro__c;
                    }
                    
                    if(quoteNewRow[0].Local_Currency_of_PPC_Costs__c == currencyObj.Currency_Unit__c){ 
                        system.debug(quoteNewRow[0].Local_Currency_of_PPC_Costs__c+'===line65'+quoteNewRow[0].Local_Amount_of_PPC__c+'=='+currencyObj.Currency_Unit_To_Euro__c);        
                        quoteNewRow[0].PPC_Costs_Euro_Amount__c = quoteNewRow[0].Local_Amount_of_PPC__c * currencyObj.Currency_Unit_To_Euro__c;
                    }
                   
                    if(quoteNewRow[0].Local_Currency_of_CA_Costs__c == currencyObj.Currency_Unit__c){            
                        quoteNewRow[0].CA_Costs_Euro_Amount__c = quoteNewRow[0].Local_Amount_of_CA__c * currencyObj.Currency_Unit_To_Euro__c;
                    }
             }*/
             quoteNewRow[0].PC_Costs_Euro_Amount__c = pcEuroAmount;
             quoteNewRow[0].PPC_Costs_Euro_Amount__c = ppcEuroAmount;
             quoteNewRow[0].CA_Costs_Euro_Amount__c = caEuroAmount;
             insert quoteNewRow;
                    
             if(!uploadDocument(quoteNewRow)){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Record is saved successfully'));
             }
                    
             for(Amr_Quote__c quoteObj: quoteNewRow){
                      quoteOldList.add(quoteObj);
              }
         }
            
         quoteNewRow.clear();
         pcEuroAmount = null;
         ppcEuroAmount =  null;
         caEuroAmount = null;
         quoteNewRow.add(new Amr_Quote__c(Saving__c = savingId));
         return null;
      }
        
    public boolean validate(List<Amr_Quote__c> quoteNeedToValidated,Document document){
       
      boolean flag = false;
       
        for(Amr_Quote__c quoteObj:quoteNeedToValidated){
             if((quoteObj.Is_PC_part_of_the_Roster__c!= null || quoteObj.PC_name__c!= null || quoteObj.PC_Country__c!= null
               || quoteObj.Service_Company_Name__c!= null || quoteObj.Local_Currency_of_PC_Costs__c!=null || quoteObj.Local_Amount_of_PC__c!=null
               || quoteObj.Is_the_PPC_part_of_the_Roster__c!=null || quoteObj.PPC_Name__c!=null || quoteObj.PPC_Country__c !=null
               || quoteObj.Local_Currency_of_PPC_Costs__c!=null || QuoteObj.Local_Amount_of_PPC__c!=null || QuoteObj.Local_Amount_of_PPC__c!=null
               || QuoteObj.CA_Location__c!=null || QuoteObj.Local_Currency_of_CA_Costs__c!=null || QuoteObj.Local_Amount_of_CA__c!=null) && document.body!=null) {    
               
                flag = true;
            }else{
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter at least one value and one file to upload'));
               document.body = null;
               return false;
           }   
       }
     
        return flag;
    }
        
    public boolean uploadDocument(List<Amr_Quote__c> idsList){
      system.debug('id-------?>'+idsList);
        String parentId ;
            
        if(idsList.size()>0){
            parentId = idsList[0].Id;
            system.debug('=======>'+parentId);
        }
            
        if(document.body!=null){    
              
            system.debug(document+'--------document Body'+document.body +'lstQuoteToaddRow=='+quoteNewRow);
            List<Folder> FolderId = [SELECT Id,Name FROM Folder where name = 'Brief'];
            document.FolderId = FolderId[0].Id;
            insert document;
             
            FeedItem FI = new FeedItem();
            FI.ParentId = parentId;
            FI.Body = 'Attachment added';
            FI.ContentData = document.body;
            FI.ContentFileName = document.Name;
            insert FI;
  
            document = new document();
            
            if(document.id!=null && FI.id!=null){
                 document.body = null;
                 return true;
            }
         }
        
        return false;
    }
    
    public void SaveUpdatedData(){
        
        if(IdValue!=null){    
           isEdit  = false;
           isSave = true;
           display = false;
        }      
    }
    
    public void SaveNewData(){
        try{
             List<Amr_CurrencyConversionRate__c> currencyList = Amr_CurrencyConversionRate__c.getall().values();
             system.debug(IdValue+'updated list===========>'+quoteOldList);
            
             for(Amr_Quote__c QuoteObj: quoteOldList){
                 system.debug(QuoteObj.id+'id compare======='+IdValue);
                  if(QuoteObj.id == IdValue){
                      for(Amr_CurrencyConversionRate__c currencyObj:currencyList){
                           system.debug(QuoteObj.Local_Currency_of_PPC_Costs__c +'----comapre'+QuoteObj.Local_Amount_of_PPC__c);
                            if(QuoteObj.Local_Currency_of_PC_Costs__c == currencyObj.Currency_Unit__c){            
                                QuoteObj.PC_Costs_Euro_Amount__c = QuoteObj.Local_Amount_of_PC__c * currencyObj.Currency_Unit_To_Euro__c;
                            }
                            
                            if(QuoteObj.Local_Currency_of_PPC_Costs__c == currencyObj.Currency_Unit__c){ 
                                QuoteObj.PPC_Costs_Euro_Amount__c = QuoteObj.Local_Amount_of_PPC__c * currencyObj.Currency_Unit_To_Euro__c;
                            }
                           
                            if(QuoteObj.Local_Currency_of_CA_Costs__c == currencyObj.Currency_Unit__c){            
                                QuoteObj.CA_Costs_Euro_Amount__c = QuoteObj.Local_Amount_of_CA__c * currencyObj.Currency_Unit_To_Euro__c;
                            }
                       }
                  
                  }
             }
             
             upsert quoteOldList;
             isEdit  = true;
             isSave = false;
        }catch(Exception e){
                system.debug('inside Update Data===>');
        }
    }
    
    public void deleteQuote(){
      
       List<Amr_Quote__c> quoteToBeDeleted = new List<Amr_Quote__c >();
        
       integer index=0;
       integer indexNeedToRemove = 0;
       
       for(Amr_Quote__c quoteObj:quoteOldList ){
            index = index+1;
            if(quoteObj.id == IdDeleted){
               system.debug('===?'+index+'==index');
               system.debug('==index'+quoteOldList.get(index-1));
               indexNeedToRemove = index-1;
               quoteToBeDeleted.add(quoteObj);
            }
          
        }
        
        quoteOldList.remove(indexNeedToRemove);
        delete quoteToBeDeleted;
        
    }
}