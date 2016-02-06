public with sharing class CEC_LiveAgentController{
    public case newcase;
    public string chatKey {get; set;}
    public id caseId {get; set;}
    
    public CEC_LiveAgentController(){
        newcase = new case();
        chatKey = ApexPages.currentPage().getParameters().get('chatKey');
    }
    
    
    public PageReference takeSurvey(){
        string surveyId = cec_Org_Settings__c.getOrgDefaults().LiveChatQuestionaireId__c;
        PageReference reference=new PageReference('http://survey.clicktools.com/go?iv='+surveyId);
        reference.setRedirect(true);
        return reference;
    }
}