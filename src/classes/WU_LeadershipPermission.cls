public with sharing class WU_LeadershipPermission {

    public WU_LeadershipPermission(ApexPages.StandardController controller) {   
            
        }
            public pageReference redirectPage(){
                 User usr = [SELECT Id,WU_Permission_set_Check__c  FROM User WHERE id=:userinfo.getuserid()];
                 if (usr.WU_Permission_set_Check__c){
                      Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+'Insufficient Privileges - You do not have the level of access necessary to perform the operation you requested.'));  
                      return null;
             
               }
                 else
                 {
                     PageReference p = new PageReference('/aA2/e?');
                     p.getParameters().put('nooverride','1');
                     p.setRedirect(true);
                      return p;
                 }
                  return null;
                }

}