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
    
    /**
     * Posts a feed item with @-mentions using an @-mention formatting syntax.
     * 
     * @param communityId Use either the ID of a community, 'internal', or null.
     * @param subjectId The parent of the post. Can be a user ID, a group ID, or a record ID.
     * @param textWithMentions The text of the post. You can @-mention a user or group by using
     *                         the syntax {ID}, for example: 'Hello {005x0000000URNP}, have you
     *                         seen the group {0F9x00000000D7m}?' Links and hashtags will be
     *                         automatically parsed if provided.
     * @return The posted feed item.
     */
    public static ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions) 
    {

        return postFeedItemWithSpecialFormatting(communityId, subjectId, textWithMentions, 'textWithMentions');
    }

    private static ConnectApi.FeedElement postFeedItemWithSpecialFormatting(String communityId, String subjectId, String formattedText, String textParameterName) 
    {
        if (formattedText == null || formattedText.trim().length() == 0) 
        {
            throw new InvalidParameterException(textParameterName + DMS_GlobalConstants.MSG_PARAMETER_NOT_EMPTY);
        }
        
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = getMessageSegmentInputs(formattedText);

        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.body = messageInput;
        input.subjectId = subjectId;
        
        return ConnectApi.ChatterFeeds.postFeedElement(communityId, input);
    }

    public static List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText) 
    {
        if (inputText == null) 
        {
            throw new InvalidParameterException(DMS_GlobalConstants.MSG_PARAMETER_NOT_NULL);
        }

        List<ConnectApi.MessageSegmentInput> messageSegmentInputs = new List<ConnectApi.MessageSegmentInput>();
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

        return messageSegmentInputs;
    }

    private static void addTextSegment(List<ConnectApi.MessageSegmentInput> messageSegmentInputs, String text) 
    {
        if (text != null && text.length() > 0) {
            ConnectApi.TextSegmentInput textSegmentInput = makeTextSegmentInput(text);
            messageSegmentInputs.add(textSegmentInput);
        }
    }

    private static ConnectApi.TextSegmentInput makeTextSegmentInput(String text) 
    {
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = text;
        return textSegment;
    }
    
    private static ConnectApi.MentionSegmentInput makeMentionSegmentInput(String mentionId) 
    {
        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = mentionId;
        return mentionSegment;
    }    
}