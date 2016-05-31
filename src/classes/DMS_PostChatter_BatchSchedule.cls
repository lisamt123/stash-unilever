/**********************************************************************
Name: DMS_PostChatter_BatchSchedule
ConfigureOpportunity() Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class that run every day to send to the Sellers the info about his performance of sell. If 15 days pass and they're
still without 'Invoices'. A post on Chatter will mention the seller informing about that.
====================================================== 
======================================================
History 

VERSION AUTHOR DATE DETAIL Description
1.0 	CHACL  25/05/2016  INITIAL DEVELOPMENT.
***********************************************************************/
global class DMS_PostChatter_BatchSchedule implements Schedulable, Database.AllowsCallouts
{
    
    private DMS_WaveRestCall_CC waveCall = null;
    private Map<String, String> mapUsers = null;
    private List<DMS_WaveRestCall_CC.Records> listRecords = null;
    
    /*******************************************************************
    * Purpose: Execute the batch calling the RestAPI to retrieve the data 
    * from the Sellers without invoices.
    * Parameters: AccountId
    * Returns: void 
	********************************************************************/
    global void execute(SchedulableContext sc) 
    {
        try {
            waveCall = new DMS_WaveRestCall_CC();
            listRecords = new List<DMS_WaveRestCall_CC.Records>();
            this.mapUsers = new Map<String, String>();
            
            listRecords = waveCall.getRecords('0Fb19000000A42BCAS','0Fb19000000A3xaCAC'); //call the method 
            
            for(DMS_WaveRestCall_CC.Records waveRecord : listRecords) 
            {
                this.mapUsers.put(waveRecord.Account_Owner, waveRecord.DistributorCode);    
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
                DMS_ConnectApiHelper_CC.postFeedItemWithMentions(DMS_GlobalConstants.ID_COMMUNITY, groupId, Label.DMS_Hello + this.formatString(mentionIds) + Label.DMS_CommunityMSG + Label.DMS_WaveDashboard); 
            }
            // Por favor, accede a su  Informe de Clientes no Compradores en el siguiente enlace: <link para a aba de Wave Dashboards com o relatório de Clientes no compradores >
        } 
        catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.exceptionMsg + e.getMessage());
        }
    }
    
    /*******************************************************************
    * Purpose: Return the list of Groups that the user is part.
    * Parameters: List with Users from the Wave DataSet
    * Returns: The list with the MemberId and the Group that he is part to be mentioned on his group.
    ********************************************************************/
    public Map<Id, Set<String>> getMapUserGroupId(Map<String, String> mapIdUsers) 
    {
        Set<String> listMembers = new Set<String>(); 
        Map<Id, Set<String>> vMap = new Map<Id, Set<String>>();
        
        try {

            List<CollaborationGroupMember> tempList = [SELECT Id, MemberId, CollaborationGroupId FROM CollaborationGroupMember Where MemberId =: mapIdUsers.keySet()];
            
            for(CollaborationGroupMember collabMember : tempList) 
            { 
                if(vMap.containsKey(collabMember.CollaborationGroupId)) 
                {
                    vMap.get(collabMember.CollaborationGroupId).add(this.insertMentionedUser(String.valueOf(collabMember.MemberId)));
                } 
                else 
                {
                    listMembers = new Set<String>();		
                    listMembers.add(this.insertMentionedUser(String.valueOf(collabMember.MemberId)));
                    vMap.put(collabMember.CollaborationGroupId, listMembers);
                }            
            }
          } 
        catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.exceptionMsg + e.getMessage());
        }
        return vMap;
    }
    
    /*******************************************************************
    * Purpose: Insert the Id of the Users.
    * Parameters: Id of the User.
    * Returns: The Id of the User mentioned e.g: {0U9130000000LVq}
    ********************************************************************/
    public String insertMentionedUser(String Id) 
    {
        String userMentioned = null;
        try {
            if(Id != null || Id != DMS_GlobalConstants.VALUE_NULL) 
            {
                userMentioned = DMS_GlobalConstants.VALUE_BLANK + DMS_GlobalConstants.VALUE_CURLY_BRACKET_OPEN + Id + DMS_GlobalConstants.VALUE_CURLY_BRACKET_CLOSE + DMS_GlobalConstants.VALUE_BLANK;
            }        
        }
        catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.exceptionMsg + e.getMessage());
        }
        return userMentioned;

    }
    
    /*******************************************************************
    * Purpose: Remove the null values.
    * Parameters: The String (Id) from the User
    * Returns: The String formated.
    ********************************************************************/
    public String formatString(String vString) 
    {
        try {
            
            vString = vString.replace(DMS_GlobalConstants.VALUE_NULL, DMS_GlobalConstants.VALUE_BLANK);
        }
        catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.exceptionMsg + e.getMessage());
        }
        return vString;
    }
    
}