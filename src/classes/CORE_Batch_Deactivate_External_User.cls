/**
* Class Name: CORE_Batch_Deactivate_External_User 
* Date: 12/6/2014
* Requirement/Project Name: Unilever Salesforce Engagement
* Requirement/Description: Batch to deactivate Chatter External user when
*    1.    Not a member of any Chatter Groups.
*    2.    LastLoginDate in the User record is < CurrentDate()-{External User Inactivity Days in the ExternalBatch data set in the custom setting – see above} i.e. User has not logged in since last XX days.
*/

global class CORE_Batch_Deactivate_External_User implements Database.Batchable<SObject>{
    
    /**  
    *       The following method returns list of user in a batch 
    * 
    *       @param Database.BatchableContext 
    *       @return Database.getQueryLocator(List of user)
    *       @throws exception-none 
    */
    global Database.QueryLocator start (Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id,Name,LastLoginDate FROM User WHERE User_License__c = \'Chatter External\' AND UserType = \'CsnOnly\' AND IsActive = true');
    }
    
    /** 
    *       The following method have logic to be performed for the batch of users 
    * 
    *       @param Database.BatchableContext BC,List<user> 
    *       @return No - No return values. 
    *       @throws exception-none 
    */
    global void execute(Database.BatchableContext BC,List<sObject> scope){ 
        try { 
            List<user> lstUser=scope;
            List<user> lstUserInactive=new List<user>();
            List<ID> lstUserId=new List<ID>();
            
            for(User ObjUser : lstUser){
                lstUserId.add(ObjUser.Id);
            }
            
            List<CollaborationGroupMember> listUser=[SELECT MemberId FROM CollaborationGroupMember where MemberId in :lstUserId];
            Set<ID> setMemberId=new Set<ID>(); 
            for(CollaborationGroupMember member :listUser){ 
                setMemberId.add(member.MemberId);
            }
    
            
            for(user objUser : lstUser){
                decimal decDayDiff=CORE_CHATTER_USER_ADMINISTRATION__c.getInstance('BatchExternalUserInfo').External_User_Inactivity_Days__c + 1;
                
                if(objUser.LastLoginDate!=null) decDayDiff=objUser.LastLoginDate.date().daysBetween(System.now().date());
    
                  System.debug('!!!! decDayDiff '+decDayDiff);
                  
                  if(!setMemberId.contains(objUser.id) || decDayDiff>=CORE_CHATTER_USER_ADMINISTRATION__c.getInstance('BatchExternalUserInfo').External_User_Inactivity_Days__c){
                    objUser.IsActive=false;
                    lstUserInactive.add(objUser);
                    System.debug('^^^^ First method');
                 }
                
            }
            
            if(lstUserInactive.size()>0) update lstUserInactive;
            
        }catch(Exception ex) {}
    } 
    
    /** 
    *       The following method have the logic to be performed once the batch is executed 
    * 
    *       @param Database.BatchableContext 
    *       @return No - No return values. 
    *       @throws exception-none 
    */
    global void finish(Database.BatchableContext BC){
        DateTime dt = System.now().addMinutes(-40);
        List<user> lstUserInactive=[SELECT Id,Name FROM User WHERE User_License__c = 'Chatter External' AND UserType = 'CsnOnly' AND IsActive = false AND LastModifiedDate>=:dt ];
        List<FeedItem> lstFdItem=new List<FeedItem>();
        String strName='';
        String strNextLine='\n';
        String strFirstLine='Following users have been deactivated on '+System.now()+' as part of User Administration Batch:';
        
        List<String> lstStrFeedList = new List<String>();
        
        if(lstUserInactive.size()>0){ 
            for(User ObjUser:lstUserInactive){ 
                strName=strName+ObjUser.Name+strNextLine;

                if(strName.length()>4000){
                    lstStrFeedList.add(strName);
                    strName='';
                }
            }
            lstStrFeedList.add(strName);
            System.debug('***** lstStrFeedList ' + lstStrFeedList.size() + '   ' + lstStrFeedList);
        }
        
        String strBody='';
        String strGroupIds=CORE_CHATTER_USER_ADMINISTRATION__c.getInstance('BatchExternalUserInfo').Chatter_Group_Id__c; 
        if(strGroupIds!=null && strGroupIds!=''){
            String[] lstGroupIds= strGroupIds.Split(',');
            
            for(String strGpId :lstGroupIds) {
                for(String strN : lstStrFeedList){
                    strBody=strFirstLine+strNextLine+strN;

                    FeedItem fdItem=new FeedItem(Type='TextPost',Body=strBody,ParentId=strGpId);
                    lstFdItem.add(fdItem);
                }
            }
            if(lstFdItem.size()>0) insert lstFdItem;
        }
    }
}