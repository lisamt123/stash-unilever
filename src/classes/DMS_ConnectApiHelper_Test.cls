@IsTest(SeeAllData=true)
public class DMS_ConnectApiHelper_Test {

    
    @IsTest(SeeAllData=true)
    static void testInvalidMentionType() {
        Boolean exceptionThrown = false;
        try {
            DMS_ConnectApiHelper_CC.postFeedItemWithMentions(null, 'me', '{001x00000000D7m}'); // not a group or user id
        }
        catch (ConnectApi.ConnectApiException e) {
            System.assertEquals('Only user and group IDs may be used in inline mentions.', e.getMessage());
            exceptionThrown = true;
        }
        System.assert(exceptionThrown);
    }
    
    @IsTest(SeeAllData=true)
    static void testEmptyString() {
        List<ConnectApi.MessageSegmentInput> segments = DMS_ConnectAPiHelper_CC.getMessageSegmentInputs('');
        System.assertEquals(0, segments.size());
    }

    @IsTest(SeeAllData=true)
    static void testNoMentions() {
        String text = 'hey there';
        List<ConnectApi.MessageSegmentInput> segments = DMS_ConnectAPiHelper_CC.getMessageSegmentInputs(text);
        
        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.TextSegmentInput);
        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        System.assertEquals(text, textSegment.text);
    }

    @IsTest(SeeAllData=true)
    static void testMentionOnly() {
        String mentionId = '005x0000000URNP';
        String text = '{' + mentionId + '}';
        List<ConnectApi.MessageSegmentInput> segments = DMS_ConnectAPiHelper_CC.getMessageSegmentInputs(text);
        
        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MentionSegmentInput);
        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
        System.assertEquals(mentionId, mentionSegment.id);
    }
    
}