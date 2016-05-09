/**
 * Name:        -   aa_Agent_Report_util ()
 * @description -   This class is used to capture mandatory fields 
 * @Author      -   Aslesha R K     
 */


public with sharing class aa_Agent_Report_util {
    
    /*******************************************************************
    Purpose: This method check  Chaterposting 
    Parameters: List of aa_Agent_Report__c
    Returns: Void
    Throws [Exceptions]: 
    ********************************************************************/
    public static void create_Chatter_posting(List<aa_Agent_Report__c> listAgentNew , List<aa_Agent_Report__c>listAgentOld){
        String STATUS_VALUE_TO_POST_ON = 'Published (Public)';
        
        map<Id,aa_Agent_Report__c> oldmap = new map<Id,aa_Agent_Report__c>();
        
        for(aa_Agent_Report__c obj : listAgentOld){
            oldmap.put(obj.id,obj);
        }
        
        

        Set<String> Set_Unilever_Brand=new set<String>();
        Map<String,String> sendTochatterMap= new Map<String,String>();
        for(aa_Agent_Report__c report:listAgentNew){
            if(report.Status__c != oldmap.get(report.Id).Status__c) {
                if(AA_TheAgentSingleExecution.hasAlreadyDone()) {
                    return;
                }
                else {              
                    AA_TheAgentSingleExecution.setAlreadyDone();
                    //go                
                    if (report.Status__c == STATUS_VALUE_TO_POST_ON) {
                        // brand
                        if (report.Competitor_Brand__c != NULL) {
                           sendTochatterMap.put(report.Competitor_Brand__c,JSON.serialize(report));
                        }                
                        
                       //competitor
                        if (report.Competitor_Name__c != NULL) {                        
                           
                          sendTochatterMap.put(report.Competitor_Name__c,JSON.serialize(report));
                        }
                      
                        //retailer   
                        if (report.Retailer__c != NULL) {
                            
                           sendTochatterMap.put(report.Retailer__c,JSON.serialize(report));
                        }
                        
                        //country
                        if (report.Country__c != NULL) {
                            sendTochatterMap.put(report.Country__c,JSON.serialize(report));
                            
                        }
                        
                        //Unilever_Brand__c
                        if (report.Agent_App_Unilever_Brand__c != NULL) {
                            sendTochatterMap.put(report.Agent_App_Unilever_Brand__c,JSON.serialize(report));
                        }
                        
                        //Category
                        if (report.Category__c != NULL) {
                           sendTochatterMap.put(report.Category__c,JSON.serialize(report));
                        }
                        
                        //Topic
                        if (report.Topic__c != NULL) {
                            sendTochatterMap.put(report.Topic__c,JSON.serialize(report));                   
                        }
                        
                        system.debug('In chatter posting trigger value for cluster '+report.ClusterId__c+'value for country'+report.Country__c);
                        //Cluster   
                        if(report.ClusterId__c!=NULL && report.Country__c==NULL)
                        {        
                            sendTochatterMap.put(report.ClusterId__c,JSON.serialize(report));                    
                        }                    
                        //User Name
                        String CaretedbyName=userInfo.getUserName();
                        if (CaretedbyName != NULL) {
                            sendTochatterMap.put(userInfo.getUserId(),JSON.serialize(report));
                        }
              
                    }

                }
            } 
          }
          AA_theAgent_ChatterPost_FutureClass.CallSendToChatter(sendTochatterMap);
        
    }
    
}