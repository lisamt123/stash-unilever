public with sharing class PBS_WikiFeedbackViewController_CC{
    
    public List<PBS_Wiki_Feeback__c> lstPBSWikiFeedback {get;set;}
    
    //Constructor
    // fetching article title and showing warning if ID does not exit
    public PBS_WikiFeedbackViewController_CC(){
        
        lstPBSWikiFeedback = new List<PBS_Wiki_Feeback__c>();
        String strWikiId = ApexPages.currentPage().getParameters().get('id');
        
        if(strWikiId == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'KnowledgeArticleId is not found.'));
            return;
        }
        lstPBSWikiFeedback = getPbsFeedbacklist(strWikiId);
        
        if(lstPBSWikiFeedback.isEmpty() || lstPBSWikiFeedback == null){
             List<PBS_Wiki__kav>  lstwiki = new  List<PBS_Wiki__kav>();
             lstwiki = [SELECT Title FROM PBS_Wiki__kav p WHERE Id =: strWikiId LIMIT 1];
            if(!lstwiki.isEmpty() && lstwiki != null)
            {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'No feedback is present for ' + lstwiki[0].title + ' article. '));
             return;
            }
        }
    }
    
    
    //Get all Feedback record by using knowledge articleid
    public List<PBS_Wiki_Feeback__c> getPbsFeedbacklist(String strWikiId){
        return [Select Wiki_Feedback__c,Wiki_Name__c ,
                     CreatedDate, CreatedBy.Name 
                From PBS_Wiki_Feeback__c
                Where Wiki_ID__c = :strWikiId order by createddate];
        
    }
}