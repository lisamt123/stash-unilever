trigger AA_theAgent_Chatter_Posting on aa_Agent_Report__c (before update) {
//trigger AA_theAgent_Chatter_Posting on aa_Agent_Report__c (after update) {
public static String STATUS_VALUE_TO_POST_ON = 'Published (Public)';

Set<String> Set_Unilever_Brand=new set<String>();

Map<String,String> sendTochatterMap= new Map<String,String>();
for(aa_Agent_Report__c report:Trigger.new){

        if(report.Status__c != Trigger.oldMap.get(report.Id).Status__c) {
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
                    
                    //Cluster   
                    if(report.ClusterId__c!=NULL && report.Country__c==NULL )
                    {        
                      //  aa_Country__c cc=[select Cluster_Id__c from aa_Country__c where Id=:report.Country__c];
                       // Id clusterId=cc.Cluster_Id__c;
                     //  system.debug('Clusteriddddddddddddddd==='+report.Country__r.Cluster_Id__c);
                        sendTochatterMap.put('Cluster_Id',JSON.serialize(report));                    
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