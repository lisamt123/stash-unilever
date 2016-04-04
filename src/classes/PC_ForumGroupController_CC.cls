/**
 * Controller for Forum Group page
 *
 * @author  Krzysztof Wasniowski <k.wasniowski@polsource.com>
 */
public with sharing class PC_ForumGroupController_CC
{
    /**
     * Holds user language
     */
    public String language {get; set;}
    /**
     * Holds current group ip
     */
    public String groupId {get; set;}
    /**
     * Holds PC Group details
     */
    public PC_Group__c pcGroup {get; set;}
    /**
     * Holds Chatter group details
     */
    public CollaborationGroup groupObj {get; set;}
    /**
     * List of related FAQ's
     */
    public List<PBS_FAQ_s__kav> faqList {get; set;}
    /**
     * List of related Wiki's
     */
    public List<PBS_Wiki__kav> wikiList {get; set;}
    /**
     * Class constructor
     */
    public PC_ForumGroupController_CC()
    {
        groupId  = ApexPages.currentPage().getParameters().containsKey('id') ? String.valueOf(ApexPages.currentPage().getParameters().get('id')) : null;
        faqList  = new List<PBS_FAQ_s__kav>();
        wikiList = new List<PBS_Wiki__kav>();
        language = UserInfo.getLanguage();
    }
    /**
     * Method loads all required data
     */
    public void loadData()
    {
        if (String.isBlank(groupId)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Group Id was not provided. Please return back to Forum page.'));
        } else {
            loadGroupData(groupId);
            getFaqArticles(pcGroup != null ? pcGroup.Name : null);
            getWikiArticles(pcGroup != null ? pcGroup.Name : null);
        }

        if (pcGroup == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Provided Group Id is not valid. Please return to Forum page.'));
        }
    }
    /**
     * Method return true if there are any error messages attached to current page
     *
     * @return Boolean
     */
    public Boolean getHasMessages()
    {
        return ApexPages.hasMessages(ApexPages.Severity.ERROR);
    }
    /**
     * Load details of specific PC Group and Chatter group
     *
     * @param String groupId PC Group id
     */
    public void loadGroupData(String groupId)
    {
        // query for PC_Group
        List<PC_Group__c> pcList = [
            SELECT
                Id,
                Name,
                Title__c,
                Background_Location__c,
                Chatter_Group_ID__c,
                Data_Categories__c,
                Image_ID__c,
                Order__c,
                Parent_Page__c,
                Published__c,
                Summary__c
            FROM
                PC_Group__c
            WHERE
                Id = :groupId
            AND
                Published__c = true
            Limit 1
        ];

        if (!pcList.isEmpty()) {
            pcGroup = pcList.get(0);
        }

        if(pcGroup != null && pcGroup.Chatter_Group_ID__c != null) {
            List<CollaborationGroup> groupList = [
                SELECT
                    AnnouncementId, CanHaveGuests, CollaborationType, CreatedById, CreatedDate, Description, FullPhotoUrl, GroupEmail, HasPrivateFieldsAccess, Id, InformationBody, InformationTitle, IsArchived, IsAutoArchiveDisabled, LastModifiedById, LastModifiedDate, MemberCount, Name, NetworkId, OwnerId, SmallPhotoUrl
                FROM
                    CollaborationGroup
                WHERE
                    id = :pcGroup.Chatter_Group_ID__c
                LIMIT 1
            ];

            if (!groupList.isEmpty()) {
                groupObj = groupList.get(0);
            }
        }
    }
    /**
     * Loads FAQ articles related to specific PC Group Name
     *
     * @param String PC Group name
     */
    public void getFaqArticles(String pcGroupName)
    {
        faqList = (List<PBS_FAQ_s__kav>) getArticles(pcGroupName, 'PBS_FAQ_s');
    }
    /**
     * Loads Wiki articles related to specific PC Group Name
     *
     * @param String PC Group name
     */
    public void getWikiArticles(String pcGroupName)
    {
        wikiList = (List<PBS_Wiki__kav>) getArticles(pcGroupName, 'PBS_Wiki');
    }
    /**
     * Generic method that loads articles of given type for specific PC Group name
     *
     * @param String PC Group name
     * @param String objectName Name of the articles object
     * @return List<sObject> List of related articles if found
     */
    private List<sObject> getArticles(String pcGroupName, string objectName)
    {
        List<sObject> result = new List<sObject>();
        if (!String.isBlank(pcGroupName)) {
            // language cannot be provided as param so need to encode whole query as string
            // this query need to be dynamic also because we are querying different types of objects based on the param name
            String query = '';
            query += ' SELECT';
                query += ' ParentId, ViewCount ';
            query += ' FROM ';
                query += ' ' + objectName + '__ViewStat ';
            query += ' WHERE ';
                query += ' parentId IN ( ';
                    query += ' SELECT ';
                        query += ' knowledgeArticleId ';
                    query += ' FROM ';
                        query += ' ' + objectName + '__kav ';
                    query += ' WHERE ';
                        query += ' language = \'' + language + '\'';
                    query += ' AND ';
                        query += ' PublishStatus = \'Online\' ';
                    query += ' AND ';
                        query += ' Group_Name__c = :pcGroupName';
                query += ' ) ';
            query += ' AND ';
                query += ' channel = \'AllChannels\' ';
            query += ' ORDER BY ';
                query += ' ViewCount DESC ';
            query += ' LIMIT 10 ';

            // get 10 most popular articles
            List<sObject> ranking = Database.Query(query);

            Set<String> topIds    = new Set<String>();
            for (sObject obj : ranking) {
                topIds.add(String.valueOf(obj.get('parentId')));
            }
            // if there is no 10 popular articles then add random x so we have 10 in total
            if (ranking.size() < 10) {
                query = '';
                query += ' SELECT';
                    query += ' knowledgeArticleId ';
                query += ' FROM ';
                    query += ' ' + objectName + '__kav ';
                query += ' WHERE ';
                    query += ' knowledgeArticleId != :topIds ';
                query += ' AND ';
                    query += ' PublishStatus = \'Online\' ';
                query += ' AND ';
                    query += ' language = \'' + language + '\' ';
                query += ' AND ';
                    query += ' IsLatestVersion = true ';
                query += ' AND ';
                    query += ' isOutOfDate = false ';
                query += ' AND ';
                    query += ' Group_Name__c = :pcGroupName';
                query += ' LIMIT ' + (10 - ranking.size());

                for(sObject obj : Database.Query(query)) {
                    topIds.add(String.valueOf(obj.get('knowledgeArticleId')));
                }
            }

            if (!topIds.isEmpty()) {
                query = '';
                query += ' SELECT';
                    query += ' Id, Title, knowledgeArticleId, UrlName, ArticleType ';
                query += ' FROM ';
                    query += ' ' + objectName + '__kav ';
                query += ' WHERE ';
                    query += ' knowledgeArticleId = :topIds ';
                query += ' AND ';
                    query += ' PublishStatus = \'Online\' ';
                query += ' AND ';
                    query += ' language = \'' + language + '\' ';
                query += ' AND ';
                    query += ' IsLatestVersion = true ';
                query += ' AND ';
                    query += ' isOutOfDate = false ';
                query += ' AND ';
                    query += ' Group_Name__c = :pcGroupName';

                List<sObject> articles = Database.query(query);

                Map<String, sObject> knowledgeArticleIdToArticle = new Map<String, sObject>();
                for (sObject article : articles) {
                    knowledgeArticleIdToArticle.put(String.valueOf(article.get('knowledgeArticleId')), article);
                }

                String knowledgeArticleId;
                for (sObject orderedObj : ranking) {
                    knowledgeArticleId = String.valueOf(orderedObj.get('ParentId'));
                    if (knowledgeArticleIdToArticle.containsKey(knowledgeArticleId)) {
                        result.add(knowledgeArticleIdToArticle.get(knowledgeArticleId));
                        knowledgeArticleIdToArticle.remove(knowledgeArticleId);
                    }
                }
                // add those that do not have ranking
                result.addAll(knowledgeArticleIdToArticle.values());
            }
        }

        return result;
    }
}