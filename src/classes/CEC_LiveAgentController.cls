/**********************************************************************
Name:  CEC_LiveAgentController
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: Contains methods for Love agent related functionalities                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Goverdhan S.       Jan-2016      INITIAL DEVELOPMENT   

***********************************************************************/
public with sharing class CEC_LiveAgentController{
    public string chatKey;
    public string surveyId;
    
    // class constructor
    public CEC_LiveAgentController(){
        chatKey = ApexPages.currentPage().getParameters().get('chatKey');
    }
    
    
    public PageReference takeSurvey(){
                
        // Fetch survey id from custom settings
        if(!test.isRunningTest()){
            surveyId = cec_Org_Settings__c.getOrgDefaults().LiveChatQuestionaireId__c;
        }
        
        // if survey id is not blank, redirect to survey page
        if(surveyId != null && surveyId != ''){
            PageReference reference=new PageReference('http://survey.clicktools.com/go?iv='+surveyId+'&q2='+chatKey);
            reference.setRedirect(true);
            return reference;
        }else{ // if survey id is null, display error message
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Survey is currently unavailable.');
            ApexPages.addMessage(myMsg);
            return null;
        }        
    }
}