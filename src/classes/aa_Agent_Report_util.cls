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

        //Set<String> Set_Unilever_Brand=new set<String>();
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
                        
                        Map<String,String> map1 = addTosendChatter(report);   
                        sendTochatterMap = map1;            
                      
              
                    }

                }
            } 
          }
          AA_theAgent_ChatterPost_FutureClass.CallSendToChatter(sendTochatterMap);
        
    }
    public static Map<String,String> addTosendChatter(aa_Agent_Report__c report)
    {
                       Map<String,String> sendTochatterMap= new Map<String,String>();
                       // brand
                        if (String.isNotEmpty(report.Competitor_Brand__c)) {
                           sendTochatterMap.put(report.Competitor_Brand__c,JSON.serialize(report));
                        }                        
                       //competitor
                        if (String.isNotEmpty(report.Competitor_Name__c)) {                        
                            sendTochatterMap.put(report.Competitor_Name__c,JSON.serialize(report));
                        }                      
                        //retailer   
                        if (String.isNotEmpty(report.Retailer__c)) {
                            sendTochatterMap.put(report.Retailer__c,JSON.serialize(report));
                        }                        
                        //country
                        if (String.isNotEmpty(report.Country__c)) {
                            sendTochatterMap.put(report.Country__c,JSON.serialize(report));
                        }                        
                        //Unilever_Brand__c
                        if (String.isNotEmpty(report.Agent_App_Unilever_Brand__c)) {
                            sendTochatterMap.put(report.Agent_App_Unilever_Brand__c,JSON.serialize(report));
                        }                                                
                        //Category
                        if (String.isNotEmpty(report.Category__c)) {
                           sendTochatterMap.put(report.Category__c,JSON.serialize(report));
                        }                                                
                        //Topic
                        if (String.isNotEmpty(report.Topic__c)) {
                            sendTochatterMap.put(report.Topic__c,JSON.serialize(report));                   
                        }                                             
                        //Cluster   
                        if(String.isNotEmpty(report.ClusterId__c)){
                            sendTochatterMap.put(report.ClusterId__c,JSON.serialize(report));                    
                        }                    
                        //User Name
                        String CaretedbyName=userInfo.getUserName();
                        if (String.isNotEmpty(CaretedbyName)) {
                            sendTochatterMap.put(userInfo.getUserId(),JSON.serialize(report));
                        }
                        return sendTochatterMap;
    }
}