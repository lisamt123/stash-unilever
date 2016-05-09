public with sharing  class PBS_WikiController_CC{
public PBS_Wiki__kav objpbs {get;set;}
public string recordId {get;set;}
public PBS_WikiController_CC() 
    {
        recordId = apexpages.currentpage().getparameters().get('ID');
        objpbs  = [select articleType,articleNumber,CreatedById,CreatedBy.Name,owner.Name,LastModifiedDate,OwnerId,Wiki_Content__c,Related_Files__Body__s,Related_Files__Name__s,
                    Related_Files2__Body__s,Related_Files2__Name__s,
Related_Files3__Body__s,Related_Files3__Name__s,
Related_Files4__Body__s,Related_Files4__Name__s,
Related_Files5__Body__s,Related_Files5__Name__s, KnowledgeArticleId,Group_Name__c,p.Title, p.PublishStatus, p.Id, Related_Articles__c From PBS_Wiki__kav p Where PublishStatus='Online' 
              and Id =: recordId ];   

         
     }
}