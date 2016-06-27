public with sharing  class PBS_WikiFeedBackController_CC{
    public String feedback{ get; set; }
    public list<PBS_Wiki__kav> objwiki {get;set;}
    public string recordId {get;set;}
    public string  strThanks {get;set;}

    // fetching article title and showing warning if id does not exit
    public PBS_WikiFeedBackController_CC()      
    { 
      
              
            recordId = apexpages.currentpage().getparameters().get('ID');   
           // String strThanks = 'Thank you for deciding to contribute to PlanWiki.' + '\n'+ 'PlanWiki is a user created document so your contribution is very much encouraged.Have some feedback? Like to add to this Wiki? Like to make a correction? Like to request a new Wiki?Let us know in the window above!';
          
        
            if(recordId == null)
             {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Knowledge Article Id not found'));
               return;
             }
            objwiki = [SELECT p.Title FROM PBS_Wiki__kav p WHERE Id =: recordId LIMIT 1];
            
           if( objwiki.isempty()){  
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Knowledge Article Id not found'));
               recordId =null;
               return;
             }
          
    } 
    
    // saving the details into the object
    public PageReference save() 
    {   
        PageReference newPage;
        try{
            PBS_Wiki_Feeback__c objFeedback = new PBS_Wiki_Feeback__c ();
            if(feedback ==''){
              throw new FeedbackException('Please enter feedback');
        }
        else if(feedback!=''){
        objFeedback.Wiki_Id__c = recordId ;
        for(PBS_Wiki__kav wikikav :objwiki){
        objFeedback.Wiki_Name__c =wikikav.Title;
        }
        objFeedback.Wiki_Feedback__c=feedback;
        insert objFeedback;
        newPage = new PageReference('/apex/PBS_Wiki?ID=' + recordId);
        newPage.setRedirect(true);
        }
        
        }catch(FeedbackException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getmessage()));
            return null;
            //newPage = new PageReference('/apex/feed1?ID=' + recordId);
          //newPage.setRedirect(true);
          
        }
        catch(Exception e){
          e.getmessage();
          return null;
          //newPage = new PageReference('/apex/PBS_Wiki_Feedback?ID=' + recordId);
          //newPage.setRedirect(true);
          
        }
           return newPage;   
     
     }
    
    //Cancel button click - it will lead to pbs wiki page
    public PageReference cancel() 
    {
     PageReference newPage = new PageReference('/apex/PBS_Wiki?ID=' + recordId);
     newPage.setRedirect(true);
     return newpage;
    }
    public class FeedbackException extends Exception {}

}