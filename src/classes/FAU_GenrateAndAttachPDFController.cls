public with sharing class FAU_GenrateAndAttachPDFController {
    
    public Id programId {get;set;}
    public FAU_GenrateAndAttachPDFController(ApexPages.StandardController controller) {
        programId = apexpages.currentpage().getparameters().get('id');
    }
    
   /*******************************************************************
   Purpose:  To attach grenerated Biography PDF.                                                        
   Parameters: Id of Program
   Returns: Boolean Success Message
   Throws [Exceptions]: Might throw exception if insertion of attachment fails.                                                      
  ********************************************************************/
    public PageReference attach(){
       PageReference pagePdf = Page.FAU_Participant_Biography_Doc;
       pagePdf.getParameters().put('Id', programId);
       Blob pdfPageBlob;
       if(!test.isrunningtest())
           pdfPageBlob = pagePdf.getContentAsPDF();
       
       /*List<Attachment> attList = [Select Id From Attachment Where ParentId = :programId Limit 50000];
       
       
       Attachment a = new Attachment();
       a.Body = pdfPageBlob;
       a.ParentID = programId;
       a.Name = 'Biography' + '.pdf';
       a.Description = 'Biography of Participants';
       
       try{
           //delete attList;
           //insert a;
       }
       
       catch(DMLException e){
           system.debug('???'+e);
       }*/
       
       PageReference returnURL = new PageReference('/apex/FAU_Participant_Biography_Doc?Id='+programId);
       return returnURL;
       
    }

}