public class Amr_QuoteFinalController{
  /*      
    public String savingId{get;set;}
    public List<Amr_Quote__c> quoteOldList{get;set;}
    public String IdValue{get;set;}
    public Boolean isEdit {get;set;}
    public Boolean isSave {get;set;}
    public boolean display{get;set;}
    public String IdDeleted{get;set;}
    public String appraisalId{get;set;}
    public String PCTimeManagement{get;set;}
    public String PCCostManagement{get;set;}
    public Amr_Quote__c appraisalQuote{get;set;}
    public boolean displayAppraisal{get;set;}
    
    public List<Amr_Quote__c> quoteNewRow{
      get{
             if(quoteNewRow == null)
                    quoteNewRow = new List<Amr_Quote__c>();     
                return quoteNewRow;
        }set;
    }
    
    public String lstcov {
      get{
            lstcov = JSON.serialize(Amr_CurrencyConversionRate__c.getAll().values());
            return lstcov;
        }set;
    }    
    
    public  Document document {
      get {
                  if (document == null)
                  document = new Document();
                  return document;
                }set;
    }
    
    public List<Amr_Quote__c> acceptedQuotelst{
        get {
                  if (acceptedQuotelst == null)
                  acceptedQuotelst = new List<Amr_Quote__c>();
                  return acceptedQuotelst;
                }set;
    }
    
    public Amr_Quote__c acceptedQuote{get;set;}
    
    public string userId{get;set;}
    public Amr_QuoteFinalController(){
      try{
            isSave = false;
            isEdit = false;
            display = true;
            displayAppraisal = false;
            savingId = ApexPages.currentPage().getParameters().get('id');
            system.debug('savingId========>'+savingId);
            userId = userinfo.getuserid();  
            
            List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_CAP order by Assignee.name];
            boolean flag = false;
            for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
                 if(userId == permissionObj.Assignee.id){
                   
                    flag = true;
                    system.debug('inside cap User===>');
                    break;
                 }
             } 
            
            if(flag == true){
                quoteOldList = [select Quote_Number__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,Is_Accepted__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           Total_Cost__c,id,Folder__c from Amr_Quote__c where Saving__c = :savingId ORDER BY Quote_Number__c];
               system.debug('inside cap list'+quoteOldList);
            }else{    
                quoteOldList = [select Quote_Number__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,Is_Accepted__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           Total_Cost__c,id from Amr_Quote__c where Saving__c = :savingId AND (CreatedById = :userId OR LastModifiedById = :userId )ORDER BY Quote_Number__c];
               system.debug('----------quote list'+quoteOldList);
             }  
                  
             Amr_Quote__c quoteObj = new Amr_Quote__c(Saving__c = savingId);
             quoteNewRow.add(quoteObj);
             
             acceptedQuotelst = [select Quote_Number__c,id,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PPC_only_Local_Am__c,
                               Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_Editors_name__c,
                               Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_props_wardrobe__c,
                               Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Saving_Type__c,PC_Appraisal_Time_Management__c,PC_Appraisal_Cost_Management__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Output_Quality__c,
                               PPC_Appraisal_Time_Management__c,PPC_Appraisal_Cost_Management__c,PPC_Appraisal_Process_Management__c,PPC_Appraisal_Output_Quality__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Cost_Management__c,
                               CA_Appraisal_Process_Management__c,Folder__c,CA_Appraisal_Output_Quality__c,Is_Accepted__c  from Amr_Quote__c where Is_Accepted__c = true AND Saving__c = :savingId];
             
             if(acceptedQuotelst.size()>0){
                acceptedQuote = acceptedQuotelst[0];
             }
             
             system.debug('size'+acceptedQuote);
             }catch(Exception e){
                  system.debug('inside constructor===?');
             }
      }
        
    public PageReference addRowQuote(){
        system.debug('new Quote entered===>'+quoteNewRow);
        system.debug('new Quote entered===>'+document+'=======>'+quoteOldList.size());
          
        system.debug('new Row'+quoteNewRow.size());
        
        if(validate(quoteNewRow,document)){
             system.debug('22222'+ quoteNewRow);
             system.debug('22222'+ document);
             insert quoteNewRow;
             
             List<String> ids = new List<String>();
             
             for(Amr_Quote__c quote:quoteNewRow){
                ids.add(quote.id);
             }
             
             quoteNewRow = [select Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,Is_Accepted__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           Total_Cost__c,id,Folder__c,Quote_Number__c from Amr_Quote__c where id in :ids ];
             
             if(quoteOldList.size()<=0){
                quoteNewRow[0].Is_Accepted__c = true;
                quoteNewRow[0].Quote_Number__c = 1;
                quoteNewRow[0].Accepted_Final_Cost_PC_only_Currency__c = quoteNewRow[0].Local_Currency_of_PC_Costs__c;
                quoteNewRow[0].Accepted_Final_Cost_PC_only_Local_Amo__c = quoteNewRow[0].Local_Amount_of_PC__c;
                quoteNewRow[0].Accepted_Final_Cost_PC_Euro_Amou__c = String.ValueOf(quoteNewRow[0].PC_Costs_Euro_Amount__c);
                
                quoteNewRow[0].Accepted_Final_Cost_PPC_only_Currency__c = quoteNewRow[0].Local_Currency_of_PPC_Costs__c;
                quoteNewRow[0].Accepted_Final_Cost_PPC_only_Local_Am__c = quoteNewRow[0].Local_Amount_of_PPC__c;
                quoteNewRow[0].Accepted_Final_Cost_PPC_Euro_Amount__c = quoteNewRow[0].PPC_Costs_Euro_Amount__c;
                
                quoteNewRow[0].Accepted_Final_Cost_CA_only_Currency__c = quoteNewRow[0].Local_Currency_of_CA_Costs__c;
                quoteNewRow[0].Accepted_Final_Cost_CA_Local_Amount__c = quoteNewRow[0].Local_Amount_of_CA__c;
                quoteNewRow[0].Accepted_Final_Cost_CA_Euro_Amount__c = String.ValueOf(quoteNewRow[0].CA_Costs_Euro_Amount__c);
                
                system.debug('===total cost'+quoteNewRow[0].Total_Cost__c);
                quoteNewRow[0].Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c = quoteNewRow[0].Total_Cost__c;
                system.debug('inside accepted===>'+quoteNewRow[0].Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c);
                system.debug('=======>'+quoteNewRow[0]);
                update quoteNewRow;
             }else{
                 quoteNewRow[0].Quote_Number__c = quoteOldList.size()+1;
                 update quoteNewRow;
             }
            
             
             acceptedQuotelst = [select Quote_Number__c,id,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PPC_only_Local_Am__c,
                               Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_Editors_name__c,
                               Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_props_wardrobe__c,
                               Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Saving_Type__c,PC_Appraisal_Time_Management__c,PC_Appraisal_Cost_Management__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Output_Quality__c,
                               PPC_Appraisal_Time_Management__c,PPC_Appraisal_Cost_Management__c,PPC_Appraisal_Process_Management__c,PPC_Appraisal_Output_Quality__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Cost_Management__c,
                               CA_Appraisal_Process_Management__c,Folder__c,CA_Appraisal_Output_Quality__c,Is_Accepted__c  from Amr_Quote__c where Is_Accepted__c = true AND Saving__c = :savingId];
             
             if(acceptedQuotelst.size()>0){
                acceptedQuote = acceptedQuotelst[0];
             }
             
                    
             if(!uploadDocument(quoteNewRow)){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,Label.Amr_Success_ReportSaved));
             }
                    
             for(Amr_Quote__c quoteObj: quoteNewRow){
                      quoteOldList.add(quoteObj);
              }
         }
            
         quoteNewRow.clear();
         quoteNewRow.add(new Amr_Quote__c(Saving__c = savingId));
         return null;
      }
        
    public boolean validate(List<Amr_Quote__c> quoteNeedToValidated,Document document){
       
        boolean flag = false;
        system.debug('inside Validate'+quoteNeedToValidated+document.body);
        for(Amr_Quote__c quoteObjNew : quoteNeedToValidated){
            system.debug('quote inside validate===>'+quoteNeedToValidated.size());
          if((quoteObjNew.Saving__c != null || quoteObjNew.Local_Amount_of_PC__c!=null
               || quoteObjNew.Is_the_PPC_part_of_the_Roster__c!=null || quoteObjNew.PPC_Name__c!=null || quoteObjNew.PPC_Country__c !=null
               || quoteObjNew.Local_Currency_of_PPC_Costs__c!=null || quoteObjNew.Local_Amount_of_PPC__c!=null || quoteObjNew.Local_Amount_of_PPC__c!=null
               || quoteObjNew.CA_Location__c!=null || quoteObjNew.Local_Currency_of_CA_Costs__c!=null || quoteObjNew.Local_Amount_of_CA__c!=null ||
               quoteObjNew.PC_name__c != null || quoteObjNew.PC_Country__c!= null
               || quoteObjNew.Service_Company_Name__c != null || quoteObjNew.Local_Currency_of_PC_Costs__c !=null )&& document.body!=null) {    
               
                flag = true;
            }else{
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, Label.Amr_Error_FileUpload));
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
          
            FI.ContentFileName = document.Name +'*'+idsList[0].Folder__c;
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
             
             system.debug(IdValue+'updated list===========>'+quoteOldList);

             String id;
             Integer countAccept = 0;
             
             for(Amr_Quote__c QuoteObj: quoteOldList){
                 system.debug(QuoteObj.id+'id compare======='+IdValue);
                  if(QuoteObj.id == IdValue && QuoteObj.Is_Accepted__c == true){
                        
                        QuoteObj.Accepted_Final_Cost_PC_only_Currency__c = QuoteObj.Local_Currency_of_PC_Costs__c;
                        QuoteObj.Accepted_Final_Cost_PC_only_Local_Amo__c = QuoteObj.Local_Amount_of_PC__c;
                        QuoteObj.Accepted_Final_Cost_PC_Euro_Amou__c = String.ValueOf(QuoteObj.PC_Costs_Euro_Amount__c);
                        
                        QuoteObj.Accepted_Final_Cost_PPC_only_Currency__c = QuoteObj.Local_Currency_of_PPC_Costs__c;
                        QuoteObj.Accepted_Final_Cost_PPC_only_Local_Am__c = QuoteObj.Local_Amount_of_PPC__c;
                        QuoteObj.Accepted_Final_Cost_PPC_Euro_Amount__c =QuoteObj.PPC_Costs_Euro_Amount__c;
                        
                        QuoteObj.Accepted_Final_Cost_CA_only_Currency__c = QuoteObj.Local_Currency_of_CA_Costs__c;
                        QuoteObj.Accepted_Final_Cost_CA_Local_Amount__c = QuoteObj.Local_Amount_of_CA__c;
                        QuoteObj.Accepted_Final_Cost_CA_Euro_Amount__c = String.ValueOf(QuoteObj.CA_Costs_Euro_Amount__c);
                        
                        QuoteObj.Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c = QuoteObj.Total_Cost__c;
                        
                        
                  }
                  
                 if(QuoteObj.Is_Accepted__c == true){
                    QuoteObj.Quote_Number__c = 1;
                    id = QuoteObj.id;
                    countAccept = 1;
                 }
                  

             }
              
              integer i;
              
              if(countAccept == 1){
                  i = 2;
              }else{
                  i = 1;
              }
              
              for(Amr_Quote__c QuoteObj: quoteOldList){
                if(id != QuoteObj.id){
                    QuoteObj.Quote_Number__c = i;
                    i = i + 1;
                }
              
              }

             upsert quoteOldList;
             
             List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_CAP order by Assignee.name];
             boolean flag = false;
             
             for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
                 if(userId == permissionObj.Assignee.id){
                   
                    flag = true;
                    system.debug('inside cap User===>');
                    break;
                 }
              } 
            
             if(flag == true){
                quoteOldList = [select Quote_Number__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,Is_Accepted__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           Total_Cost__c,id from Amr_Quote__c where Saving__c = :savingId ORDER BY Quote_Number__c];
               system.debug('inside cap list'+quoteOldList);
            }else{    
                quoteOldList = [select Quote_Number__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,Is_Accepted__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           Total_Cost__c,id from Amr_Quote__c where Saving__c = :savingId AND (CreatedById = :userId OR LastModifiedById = :userId )ORDER BY Quote_Number__c];
               system.debug('----------quote list'+quoteOldList);
             }       
             
             acceptedQuotelst = [select Quote_Number__c,id,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PPC_only_Local_Am__c,
                               Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_Editors_name__c,
                               Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_props_wardrobe__c,
                               Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Saving_Type__c,PC_Appraisal_Time_Management__c,PC_Appraisal_Cost_Management__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Output_Quality__c,
                               PPC_Appraisal_Time_Management__c,PPC_Appraisal_Cost_Management__c,PPC_Appraisal_Process_Management__c,PPC_Appraisal_Output_Quality__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Cost_Management__c,
                               CA_Appraisal_Process_Management__c,Folder__c,CA_Appraisal_Output_Quality__c,Is_Accepted__c  from Amr_Quote__c where Is_Accepted__c = true AND Saving__c = :savingId];
             if(acceptedQuotelst.size()>0){
                acceptedQuote = acceptedQuotelst[0];
             }
             
             isEdit  = true;
             isSave = false;
        }catch(Exception e){
                system.debug('inside Update Data===>');
        }
    }
    
    
     public void deleteQuote(){
       try{
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
            acceptedQuote = new Amr_Quote__c();
            delete quoteToBeDeleted;
        
       }catch(Exception e){
          system.debug('delete Exception');
       }
       
    }
    
    public void UpdateAcceptedQuote(){
        try{
            update acceptedQuote;
            
        }catch(Exception e){
                
            system.debug('delete Exception');
        }
    }
    
    public List<SelectOption> getAppraisalRating(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','1'));
        options.add(new SelectOption('2','2'));
        options.add(new SelectOption('3','3'));
        options.add(new SelectOption('4','4'));
        options.add(new SelectOption('5','5')); 
        return options;
    }
    
   
    
    public PageReference displayAppraisal(){
       displayAppraisal = true;
       appraisalQuote = [select PC_Appraisal_Time_Management__c,PC_Appraisal_Cost_Management__c,PC_Appraisal_Process_Management__c,
                                               PC_Appraisal_Output_Quality__c,PPC_Appraisal_Time_Management__c,PPC_Appraisal_Cost_Management__c,
                                               PPC_Appraisal_Process_Management__c,PPC_Appraisal_Output_Quality__c,CA_Appraisal_Time_Management__c,
                                               CA_Appraisal_Cost_Management__c,CA_Appraisal_Process_Management__c,CA_Appraisal_Output_Quality__c
                                               from Amr_Quote__c where id = :appraisalId ];
             PCTimeManagement = appraisalQuote.PC_Appraisal_Time_Management__c;
             PCCostManagement = appraisalQuote.PC_Appraisal_Cost_Management__c;
       system.debug('sisplay appraisla===>'+displayAppraisal);
       return null;
    }
    
    public void saveAppraisal(){
         try{
             system.debug('appraisal'+appraisalId);
             appraisalQuote = [select PC_Appraisal_Time_Management__c,PC_Appraisal_Cost_Management__c,PC_Appraisal_Process_Management__c,
                                               PC_Appraisal_Output_Quality__c,PPC_Appraisal_Time_Management__c,PPC_Appraisal_Cost_Management__c,
                                               PPC_Appraisal_Process_Management__c,PPC_Appraisal_Output_Quality__c,CA_Appraisal_Time_Management__c,
                                               CA_Appraisal_Cost_Management__c,CA_Appraisal_Process_Management__c,CA_Appraisal_Output_Quality__c
                                               from Amr_Quote__c where id = :appraisalId ];
            if(appraisalQuote != null){
                   appraisalQuote.PC_Appraisal_Time_Management__c =  PCTimeManagement;
                   appraisalQuote.PC_Appraisal_Cost_Management__c =  PCCostManagement;
            }
            update appraisalQuote;
            displayAppraisal = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Appraisal saved Sucessfully'));
         }catch(Exception e){
           system.debug('exception inside save appraisal');
         
         }
    }
   */     
}