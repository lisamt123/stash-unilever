public with sharing class Amr_AcceptedQuoteController {
 /*   
    public List<Amr_Quote__c> quoteOldList {
      get{
             if(quoteOldList == null)
                    quoteOldList = new List<Amr_Quote__c>();     
                return quoteOldList;
        }set;
    }
    
     public  Document document {
      get {
                  if (document == null)
                  document = new Document();
                  return document;
                }set;
    }
    
     public String lstcov{
      get{
            lstcov = JSON.serialize(Amr_CurrencyConversionRate__c.getAll().values());
            return lstcov;
        }set;
     }    
    
    public Amr_Quote__c QuoteObj{get;set;}
    String quoteId{get;set;}
    String savingId{get;set;}
    
    public Amr_AcceptedQuoteController(){
        
        quoteId = ApexPages.currentPage().getParameters().get('id');
        savingId = ApexPages.currentPage().getParameters().get('idSave');
        
        if(quoteId !=null){
            quoteOldList = [select id,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PPC_only_Local_Am__c,
                               Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_Editors_name__c,
                               Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_props_wardrobe__c,
                               Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Saving_Type__c,PC_Appraisal_Time_Management__c,PC_Appraisal_Cost_Management__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Output_Quality__c,
                               PPC_Appraisal_Time_Management__c,PPC_Appraisal_Cost_Management__c,PPC_Appraisal_Process_Management__c,PPC_Appraisal_Output_Quality__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Cost_Management__c,
                               CA_Appraisal_Process_Management__c,Folder__c,CA_Appraisal_Output_Quality__c,Is_Accepted__c  from Amr_Quote__c where id = :quoteId ];
        }
       
        if(quoteOldList.size()>0){
          QuoteObj = quoteOldList[0];
        }
        
    }
    
    public void UpdateQuote(){
      
      try{
         
         if(validate(QuoteObj,document)){
             upsert QuoteObj; 
             if(document.body!= null){
                 if(!uploadDocument(QuoteObj)){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Record is saved successfully'));
                 }
             }else{
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Record is saved successfully'));
             }
         }
         
          
      }catch(Exception e){
         system.debug('Upsert of Quote Object Failed');
      }
    
    }
    
     public boolean validate(Amr_Quote__c quoteUpdated,Document document){
        
         boolean flag = false;
     
         if(quoteUpdated.Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c !=null &&  quoteUpdated.Saving_Type__c !=null){    
                flag = true;
         }else{
               system.debug('inside null values========>');
              
                   if(quoteUpdated.Accepted_Final_Cost_PC_only_Currency__c == null || quoteUpdated.Accepted_Final_Cost_PC_only_Local_Amo__c == null){
                       system.debug('inside null values========>1');
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter "Accepted Final Cost - PC only (Currency)" and "Accepted Final Cost - PC only (Local Amount)"'));
                   }
                   if(quoteUpdated.Accepted_Final_Cost_PPC_only_Currency__c == null || quoteUpdated.Accepted_Final_Cost_PPC_only_Local_Am__c == null){
                      system.debug('inside null values========>2');
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please "enter Accepted Final Cost - PPC only (Currency)" and "Accepted Final Cost - PPC only (Local Amount)"'));
                   }
                   if(quoteUpdated.Accepted_Final_Cost_CA_only_Currency__c == null || quoteUpdated.Accepted_Final_Cost_CA_Local_Amount__c == null){
                      system.debug('inside null values========>3');
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter "Accepted Final Cost - CA only (Currency)" and "Accepted Final Cost - CA only (Local Amount)"'));
                   }
                   
                   if(quoteUpdated.Saving_Type__c == null ){
                      system.debug('inside null values========>4');
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter "What type of Savings is this?"'));
                   }
                   
                   if(document.body !=null){
                      if(quoteUpdated.Folder__c == null){
                      
                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select "Folder"'));
                      }
                   
                   
                   }
                   return false;
              
             
         }   
      
        return flag;
    }
    
    public boolean uploadDocument(Amr_Quote__c Quote){
      
        String parentId ;
            
        if(Quote !=null){
            parentId = Quote.Id;
            system.debug('=======>'+parentId);
        }
            
        if(document.body!=null){    
              
            system.debug(document+'--------document Body'+document.body);
            List<Folder> FolderId = [SELECT Id,Name FROM Folder where name = 'Brief'];
            document.FolderId = FolderId[0].Id;
            insert document;
             
            FeedItem FI = new FeedItem();
            FI.ParentId = parentId;
            FI.Body = 'Attachment added';
            FI.ContentData = document.body;
            FI.ContentFileName = document.Name;
            FI.ContentFileName = document.Name +'*'+Quote.Folder__c;
            insert FI;
  
            document = new document();
            
            if(document.id!=null && FI.id!=null){
                 document.body = null;
                 return true;
            }
         }
        
        return false;
    }
   
    public PageReference Cancel(){
        PageReference redirectPage = new PageReference('/apex/Amr_SavingQuote');
        redirectPage.setRedirect(true);
        redirectPage.getParameters().put('id',savingId);
        return redirectPage;
    }
    
    */
}