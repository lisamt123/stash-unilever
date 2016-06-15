/**********************************************************************
Name: DMS_PostChatter_Schedule
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class that run every day to send to the Sellers the info about his performance of sell. If 15 days pass and they're
still without 'Invoices'. A post on Chatter will mention the seller informing about that.
====================================================== 
======================================================
History 

VERSION AUTHOR DATE DETAIL Description
1.0     CHACL  25/05/2016  INITIAL DEVELOPMENT.
***********************************************************************/
global class DMS_PostChatter_Schedule implements Schedulable, Database.AllowsCallouts
{
    
    private String sessionId;
    private static Network community;
    private static Map<String, String> mapUsers = new Map<String, String>();    
    private static Map<String, String> customSetting = new Map<String, String>();
    
    static {
       
       List<DMS_DatasetId__c> customList = DMS_DatasetId__c.getAll().values();
        for(DMS_DatasetId__c values : customList) {
            customSetting.put(values.name, values.ID__c);   
        }
    }
    
    public DMS_PostChatter_Schedule() 
     {
        this(UserInfo.getSessionId());
     }
    
    
     public DMS_PostChatter_Schedule(String vSessionId) 
     {
        this.sessionId = vSessionId;
     }
   
    /*******************************************************************
    * Purpose: Execute the batch calling the RestAPI to retrieve the data 
    * from the Sellers without invoices.
    * Parameters: AccountId
    * Returns: void 
    ********************************************************************/
    global void execute(SchedulableContext sc) 
    {
         postChatter(sessionId);
        
    } 
    
    @future(callout=true)
    public static void postChatter(String mySession) {

        try {
			getIdCommunity();
            DMS_WaveRestCall.getRecords(customSetting.get('ECO'),customSetting.get('Impacted'), mySession); //call the method 
        	
            for(DMS_WaveRestCall.Records waveRecord :  DMS_WaveRestCall.listRecords) 
            {
                mapUsers.put(waveRecord.Account_Owner, waveRecord.DistributorCode);    
            }

            Map<Id, Set<String>> mapUserGroupId = new Map<Id, Set<String>>(getMapUserGroupId(mapUsers)); //Separete the UserId by GroupMember that he's part

            for(Id vId : mapUserGroupId.keySet()) {
                String groupId = vId;
                String mentionIds;
                for(String vStrings : mapUserGroupId.get(vId)) 
                {
                    mentionIds += vStrings;           
                }          
                //Post on chatter for the specific group/user the message with @mention, and the link of the report.
                DMS_ConnectApiHelper.postFeedItemWithMentions(community.Id, groupId, Label.DMS_Hello + formatString(mentionIds) + Label.DMS_CommunityMSG + ' ' + Label.DMS_WaveDashboard); 
                }
            } 
            catch (Exception e) 
            {
                System.debug(DMS_GlobalConstants.exceptionPostChatter + e.getMessage());
            }
        
    }
    
    private static void getIdCommunity() {
        community = [SELECT Id FROM Network WHERE UrlPathPrefix = 'dms'][0];
    }
    
    /*******************************************************************
    * Purpose: Return the list of Groups that the user is part.
    * Parameters: List with Users from the Wave DataSet
    * Returns: The list with the MemberId and the Group that he is part to be mentioned on his group.
    ********************************************************************/
    private static Map<Id, Set<String>> getMapUserGroupId(Map<String, String> mapIdUsers) 
    {
        Set<String> listMembers = new Set<String>(); 
        Map<Id, Set<String>> vMap = new Map<Id, Set<String>>();
        
        try {

            List<CollaborationGroupMember> tempList = [SELECT Id, MemberId, CollaborationGroupId FROM CollaborationGroupMember Where MemberId =: mapIdUsers.keySet()];
            system.debug('tempList:'+ tempList);
            for(CollaborationGroupMember collabMember : tempList) 
            { 
                if(vMap.containsKey(collabMember.CollaborationGroupId)) 
                {
                    vMap.get(collabMember.CollaborationGroupId).add(insertMentionedUser(String.valueOf(collabMember.MemberId)));
                } 
                else 
                {
                    listMembers = new Set<String>();        
                    listMembers.add(insertMentionedUser(String.valueOf(collabMember.MemberId)));
                    vMap.put(collabMember.CollaborationGroupId, listMembers);
                }            
            }
          } 
        catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.EXCEPTION_MESSAGE + e.getMessage());
        }
        return vMap;
    }
    
    /*******************************************************************
    * Purpose: Insert the Id of the Users.
    * Parameters: Id of the User.
    * Returns: The Id of the User mentioned e.g: {0U9130000000LVq}
    ********************************************************************/
    private static String insertMentionedUser(String Id) 
    {
        String userMentioned = null;
        try {
            if(Id != 'null') 
            {
                userMentioned = ' ' + '{' + Id + '}' + ' ';
            }        
        }
        catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.EXCEPTION_MESSAGE + e.getMessage());
        }
        return userMentioned;

    }
    
    /*******************************************************************
    * Purpose: Remove the null values.
    * Parameters: The String (Id) from the User
    * Returns: The String formated.
    ********************************************************************/
    private static String formatString(String vString) 
    {
        try {
            
            vString = vString.replace('null', ' ');
        }
        catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.EXCEPTION_MESSAGE + e.getMessage());
        }
        return vString;
    }
    
}