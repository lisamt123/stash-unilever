/****************************************************************************************************************************************
    * @Author : Cognizant
    * @Name ChatterUtils
    * @CreatedDate 9-10-2015
    * @Version 1.0
    * @Description This class facilitates the operation of posting a chatter feed. Uses the new version method and bulkified method(s)
******************************************************************************/


public with sharing class IPM_ChatterUtils {

    /****************************************************************************
    @Description : post a feed Item for the project with @mention
    @Params subjectIdSet:  Id of the records for which the FeedItem is to be posted
    @Params subjectIdMessageMap : Map of Record Id and the ChatterText
    @Params subjectIdMentionIdSetMap : Map of record Id and the User Id, who is to be mentioned in the post
    *****************************************************************************/
    public static final String CLASS_NAME = IPM_ChatterUtils.class.getName();
    public static void postChatterFeedWithMention(Set<Id> subjectIdSet, Map<Id, String> subjectIdMessageMap, Map<Id,Set<Id>> subjectIdMentionIdSetMap){

        //bulk post to Project feeds
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
    
        //loop over each record
        for(Id subjectId : subjectIdSet){
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

            //add @mention tags if any
            if(subjectIdMentionIdSetMap != null && !subjectIdMentionIdSetMap.isEmpty() && subjectIdMentionIdSetMap.get(subjectId) != null){
            	
            	if(subjectIdMessageMap.get(subjectId).contains(System.Label.IPM_TLD_Misaligned)){
                	ConnectApi.TextSegmentInput textSegmentInputTLDAttentionMsg = new ConnectApi.TextSegmentInput();
                    textSegmentInputTLDAttentionMsg.text = Label.IPM_AttentionMsg+IPM_ConstantUtils.IPM_SPACE;
                    messageBodyInput.messageSegments.add(textSegmentInputTLDAttentionMsg);
                }
                		
                for(Id mentionId: subjectIdMentionIdSetMap.get(subjectId)){
                        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                        mentionSegmentInput.id = mentionId;
                        messageBodyInput.messageSegments.add(mentionSegmentInput);
                        
                        ConnectApi.TextSegmentInput textSegmentInputComma = new ConnectApi.TextSegmentInput();
                        textSegmentInputComma.text = IPM_ConstantUtils.COMMA + IPM_ConstantUtils.IPM_SPACE;
                        messageBodyInput.messageSegments.add(textSegmentInputComma);
                }
            }
            
            //add the messages to be posted
            if(subjectIdMessageMap != null && !subjectIdMessageMap.isEmpty() && subjectIdMessageMap.get(subjectId) != null){
                textSegmentInput.text = subjectIdMessageMap.get(subjectId);
                messageBodyInput.messageSegments.add(textSegmentInput);
            }
            
            
            //set the visibility of the post
            feedItemInput.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;
            //set the body
            feedItemInput.body = messageBodyInput;
            //set Feed Element type
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            //set record id for the feed
            feedItemInput.subjectId = subjectId;
            
            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
            batchInputs.add(batchInput);
        }
        try{
            ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,'postChatterFeedWithMention',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);    
        }
        
    }
    
}