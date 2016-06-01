/**********************************************************************
Name: DMS_ConnectApiHelper_CC
ConfigureOpportunity() Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Helper class that makes it easier to do common operations with the classes in the ConnectApi namespace.
====================================================== 
======================================================
History 

VERSION AUTHOR DATE DETAIL Description
1.0 	CHACL  25/05/2016  INITIAL DEVELOPMENT.
***********************************************************************/
global class DMS_ConnectApiHelper_CC 
{
    
    public class InvalidParameterException extends Exception {}
    
    public static ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions) 
    {
        
        return postFeedItemWithSpecialFormatting(communityId, subjectId, textWithMentions, 'textWithMentions');
    }
    
    private static ConnectApi.FeedElement postFeedItemWithSpecialFormatting(String communityId, String subjectId, String formattedText, String textParameterName) 
    {
        ConnectApi.FeedItemInput input;
        try{
            ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
            messageInput.messageSegments = getMessageSegmentInputs(formattedText);
            
            input = new ConnectApi.FeedItemInput();
            input.body = messageInput;
            input.subjectId = subjectId;
        }catch(Exception e){
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_API_HELPER_SEGMENT_SPECIAL_FORMATTING + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        
        return ConnectApi.ChatterFeeds.postFeedElement(communityId, input);
    }
    
    public static List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText) 
    {
        List<ConnectApi.MessageSegmentInput> messageSegmentInputs;
        try{
            if (inputText == null) 
            {
                throw new InvalidParameterException(DMS_GlobalConstants.MSG_PARAMETER_NOT_NULL);
            }
            
            messageSegmentInputs = new List<ConnectApi.MessageSegmentInput>();
            Integer strPos = 0;
            // The pattern for matching mentions, markup begin/end tags, and inline images.
            // The first group matches a 15 or 18 character ID surrounded by {}: 
            //   (\\{[a-zA-Z0-9]{15}\\}|\\{[a-zA-Z0-9]{18}\\})
            // The second/third groups match beginning/ending HTML tags: (<[a-zA-Z]*>)|(</[a-zA-Z]*>)
            // The fourth group matches a 15 or 18 character content document ID preceded by "img:", 
            //    optionally followed by a string (not containing '}'), and surrounded by {}: 
            //    (\\{img:(069[a-zA-Z0-9]{12,15})(:[\\s\\S]*?)?\\})
            Pattern globalPattern = Pattern.compile('(\\{[a-zA-Z0-9]{15}\\}|\\{[a-zA-Z0-9]{18}\\})|(<[a-zA-Z]*>)|(</[a-zA-Z]*>)|(\\{img:(069[a-zA-Z0-9]{12,15})(:[\\s\\S]*?)?\\})');
            Matcher globalMatcher = globalPattern.matcher(inputText);
            
            while (globalMatcher.find()) 
            {
                String textSegment = inputText.substring(strPos, globalMatcher.start());
                String matchingText = globalMatcher.group();
                if (matchingText.startsWith('{')) 
                {
                    // Add a segment for any accumulated text (which includes unsupported HTML tags).
                    addTextSegment(messageSegmentInputs, textSegment); 
                    
                    // Strip off the { and }.
                    String innerMatchedText = matchingText.substring(1, matchingText.length() - 1);
                    
                    // This is a mention id.
                    ConnectApi.MentionSegmentInput mentionSegmentInput = makeMentionSegmentInput(innerMatchedText);
                    messageSegmentInputs.add(mentionSegmentInput);
                    strPos = globalMatcher.end();
                }
            }
            
            // Take care of any text that comes after the last match.
            if (strPos < inputText.length()) 
            {
                String trailingText = inputText.substring(strPos, inputText.length());
                addTextSegment(messageSegmentInputs, trailingText);
            }
        }catch(Exception e){
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_API_HELPER_SEGMENT_INPUTS + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        return messageSegmentInputs;
    }
    
    private static void addTextSegment(List<ConnectApi.MessageSegmentInput> messageSegmentInputs, String text) 
    {
        try{
            if (text != null && text.length() > 0) {
                ConnectApi.TextSegmentInput textSegmentInput = makeTextSegmentInput(text);
                messageSegmentInputs.add(textSegmentInput);
            }
        }catch(Exception e){
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_API_HELPER_TEXT_SEGMENT + e.getCause() + e.getMessage() + e.getLineNumber());
        }
    }
    
    private static ConnectApi.TextSegmentInput makeTextSegmentInput(String text) 
    {   
        ConnectApi.TextSegmentInput textSegment;
        try{
        textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = text;
        }catch(Exception e){
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_API_HELPER_TEXT_SEGMENT_INPUT + e.getCause() + e.getMessage() + e.getLineNumber());    
            }
        return textSegment;
    }
    
    private static ConnectApi.MentionSegmentInput makeMentionSegmentInput(String mentionId) 
    {	
        ConnectApi.MentionSegmentInput mentionSegment;
        try{
        mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = mentionId;
        }catch(Exception e){
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_API_HELPER_MENTIONS_SEGMENT_INPUT + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        return mentionSegment;
    }    
}