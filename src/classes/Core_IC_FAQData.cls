/*
  Class Name: Core_IC_FAQData
  Author : Mindtree
  Date: 4 August 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: get FAQ values for FAQ page data
*/
global with sharing class Core_IC_FAQData {

    /*******************************************************************************************************
    * @description This method get the wrapper data and send to the baseService application.
    * @param 
    * @return Core_IC_WrapperUtility.FAQResponse wrapper
    */     
    global static Core_IC_WrapperUtility.FAQResponse GetFAQValues() {
       Core_IC_WrapperUtility.FAQResponse objFAQResponseResponse = new Core_IC_WrapperUtility.FAQResponse();
       try{
            objFAQResponseResponse = processFAQValues();
            objFAQResponseResponse.message=Core_IC_AppConstants.RESPONSE_SUCCESS_MSG;
            objFAQResponseResponse.statusCode=Core_IC_AppConstants.RESPONSE_SUCCESS_CODE;
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_FAQData : GetFAQValues method ', ex);
       }    
       return objFAQResponseResponse;
    }
    
    /*******************************************************************************************************
    * @description This method gets the FAQ values as wrapper data.
    * @param  
    * @return Core_IC_WrapperUtility.FAQResponse wrapper
    */  
    private static Core_IC_WrapperUtility.FAQResponse processFAQValues(){
       Core_IC_WrapperUtility.FAQResponse objFAQResponseResponse = new Core_IC_WrapperUtility.FAQResponse(); 
       List<Core_IC_WrapperUtility.FAQ> lstFaq=new List<Core_IC_WrapperUtility.FAQ>();
       try{
            Map<String,Core_IC_FAQ__c> mapFAQ=Core_IC_FAQ__c.getAll();
            for(String faq:mapFAQ.keyset()){
                Core_IC_WrapperUtility.FAQ objFAQ=new Core_IC_WrapperUtility.FAQ();
                objFAQ.Question=Core_IC_FAQ__c.getinstance(faq).Title__c;
                objFAQ.Answer=Core_IC_FAQ__c.getinstance(faq).Description__c;
                lstFaq.add(objFAQ);
            }
            /*String strQ;
            String strA;
            for(integer i=1;i<=Core_IC_FAQ__c.getinstance('No of FAQs').Number__c;i++){
                Core_IC_WrapperUtility.FAQ faq=new Core_IC_WrapperUtility.FAQ();
                strQ='FAQ'+i;
                strA='ANS'+i;
                faq.Question=Core_IC_FAQ__c.getinstance(strQ).QA__c;
                faq.Answer=Core_IC_FAQ__c.getinstance(strA).QA__c;
                lstFaq.add(faq);
            }*/
            objFAQResponseResponse.FAQ=lstFaq;
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_FAQData : processFAQValues method ', ex);
       }   
       
       return objFAQResponseResponse;
    }
    
}