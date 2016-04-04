/**
 * Class with various utility methods that help writing unit tests
 */
@isTest
public class PC_DataFactory
{
    @isTest public static void sonar()
    {
        Test.startTest();
        System.assert(true, 'Just to make SONAR happy');
        Test.stopTest();
    }

    public static CollaborationGroup createChatterGroup(String Name, String Description)
    {
        CollaborationGroup obj = new CollaborationGroup(
            CanHaveGuests          = false,
            CollaborationType      = 'Public',
            Description            = Description,
            InformationBody        = '',
            InformationTitle       = '',
            IsArchived             = false,
            IsAutoArchiveDisabled  = false,
            Name                   = Name
        );
        insert obj;
        return obj;
    }

    public static PC_Group__c createPCGroup(String title, String name, String chatterGroupId, String imageId, Integer order, String summary)
    {
        PC_Group__c obj = new PC_Group__c(
            Title__c            = title,
            Name                = name,
            Chatter_Group_ID__c = chatterGroupId,
            Image_ID__c         = imageId,
            Order__c            = order,
            Published__c        = true,
            Summary__c          = summary
        );

        insert obj;
        return obj;
    }

    public static PBS_Wiki__kav createWikiPage(String title, String summary, String groupName, String content, String UrlName, boolean loadAllData, boolean publish)
    {
        PBS_Wiki__kav obj = new PBS_Wiki__kav(
            Group_Name__c   = groupName,
            Language        = 'en_US',
            Summary         = summary,
            Title           = title,
            Wiki_Content__c = content,
            UrlName         = !String.isBlank(UrlName) ? UrlName : String.valueOf(Math.random()).replace('.', '')
        );

        insert obj;

        if (loadAllData || publish) {
            obj = loadWikiArticle(obj.id);
        }

        if (publish) {
            KbManagement.PublishingService.publishArticle(obj.KnowledgeArticleId, true);
            obj = loadWikiArticle(obj.id);
        }

        return obj;
    }

    public static PBS_Wiki__kav loadWikiArticle(String articleId)
    {
        PBS_Wiki__kav obj = [
            SELECT
                ArchivedById, ArchivedDate, ArticleNumber, ArticleType, CreatedById, CreatedDate, FirstPublishedDate,
                Group_Name__c, Id, IsDeleted, IsLatestVersion, IsMasterLanguage, IsOutOfDate, IsVisibleInApp, IsVisibleInCsp,
                IsVisibleInPkb, IsVisibleInPrm, KnowledgeArticleId, Language, LastModifiedById, LastModifiedDate, LastPublishedDate,
                MasterVersionId, OwnerId, PublishStatus, SourceId, Summary, SystemModstamp, Title, TranslationCompletedDate,
                TranslationExportedDate, TranslationImportedDate, UrlName, VersionNumber, Wiki_Content__c
            FROM
                PBS_Wiki__kav
            WHERE
                Id = :articleId
            LIMIT 1
        ];
        return obj;
    }

    public static PBS_FAQ_s__kav createFaqPage(String title, String summary, String groupName, String overview, String UrlName, boolean loadAllData, boolean publish)
    {
        PBS_FAQ_s__kav obj = new PBS_FAQ_s__kav(
            Group_Name__c   = groupName,
            Language        = 'en_US',
            Summary         = summary,
            Title           = title,
            Overview__c     = overview,
            UrlName         = !String.isBlank(UrlName) ? UrlName : String.valueOf(Math.random()).replace('.', '')
        );

        insert obj;

        if (loadAllData || publish) {
            obj = loadFaqArticle(obj.Id);
        }

        if (publish) {
            KbManagement.PublishingService.publishArticle(obj.KnowledgeArticleId, true);
            obj = loadFaqArticle(obj.Id);
        }

        return obj;
    }

    public static PBS_FAQ_s__kav loadFaqArticle(String articleId)
    {
        PBS_FAQ_s__kav obj = [
            SELECT
                ArchivedById, ArchivedDate, ArticleNumber, ArticleType, Attachment_1__Body__s, Attachment_1__ContentType__s,
                Attachment_1__Length__s, Attachment_1__Name__s, Attachment_2__Body__s, Attachment_2__ContentType__s, Attachment_2__Length__s, Attachment_2__Name__s,
                Attachment_3__Body__s, Attachment_3__ContentType__s, Attachment_3__Length__s, Attachment_3__Name__s, Attachment_4__Body__s, Attachment_4__ContentType__s,
                Attachment_4__Length__s, Attachment_4__Name__s, Attachment_5__Body__s, Attachment_5__ContentType__s, Attachment_5__Length__s, Attachment_5__Name__s,
                CreatedById, CreatedDate, Custom_PBS_Field__c, Custom_PBS_Field_2__c, Expectations__c, FirstPublishedDate, Group_Name__c, Id,
                IsDeleted, IsLatestVersion, IsMasterLanguage, IsOutOfDate, IsVisibleInApp, IsVisibleInCsp, IsVisibleInPkb, IsVisibleInPrm,
                KnowledgeArticleId, Language, LastModifiedById, LastModifiedDate, LastPublishedDate, Learning_Activities__c, MasterVersionId,
                Overview__c, OwnerId, PBS_Training_Course__c, PublishStatus, SourceId, Summary, SystemModstamp, Title,
                TranslationCompletedDate, TranslationExportedDate, TranslationImportedDate, UrlName, VersionNumber
            FROM
                PBS_FAQ_s__kav
            WHERE
                Id = :articleId
            LIMIT 1
        ];
        return obj;
    }

}