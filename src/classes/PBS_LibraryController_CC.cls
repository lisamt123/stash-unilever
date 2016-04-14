/**
 * Controller for Group Home page
 *
 * @author  Krzysztof Wasniowski <k.wasniowski@polsource.com>
 */
public with sharing class PBS_LibraryController_CC
{
    /**
     * Holds user language
     */
    public String language {get; set;}
    /**
     * Map of knowledgeArtileId to stats
     */
    public Map<String, Decimal> ranking {get; set;}
    /**
     * Current article type filter value
     */
    public String filterArticleType {
        get { return filterArticleType; }
        set {
            filterArticleType = value;
            // make sure that value provided is valid
            if ( filterArticleType != 'PBS_FAQ_s__kav' && filterArticleType != 'PBS_Wiki__kav' ) {
                filterArticleType = '';
            }
        }
    }
    /**
     * Holds name of the sort field
     */
    public String sortField {
        get { return sortField; }
        set {
            sortField = value;
            // make sure that value provided is valid
            if ( sortField != 'Title' && sortField != 'Summary' && sortField != 'lastPublishedDate' ) {
                sortField = 'Title';
            }
        }
    }
    /**
     * Holds name of the sort direction
     */
    public String sortDir  {
        get { return sortDir; }
        set {
            sortDir = value;
            // make sure that value provided is valid
            if ( sortDir != 'ASC' && sortDir != 'DESC' ) {
                sortDir = 'ASC';
            }
        }
    }
    /**
     * Curent page
     */
    public Integer currentPage = 1;
    /**
     * Number of rows per page
     */
    public Integer rowsPerPage = 10;
    /**
     * Class constructor
     */
    public PBS_LibraryController_CC() {
        sortField = 'Title';
        sortDir   = 'ASC';
        language  = UserInfo.getLanguage();
        ranking   = new Map<String, Decimal>();
    }
    /**
     * Return list of knowledge articles
     *
     * @return List<KnowledgeArticleVersion> Returns list of KnowledgeArticleVersion objects
     */
    public List<KnowledgeArticleVersion> getPbsArticleList()
    {
        String query = getQuery(false);
        query += ' ORDER BY ' + sortField + ' ' + sortDir + (sortField != 'Title' ? ', Title ASC' : '');
        query += ' LIMIT ' + this.rowsPerPage;
        query += ' OFFSET ' + ((this.currentPage - 1) * this.rowsPerPage);

        List<KnowledgeArticleVersion> result = Database.query(query);

        // load stats
        getPbsArticleStats(result);

        return result;
    }
    /**
     * Returns number of available pages
     *
     * @return Integer
     */
    public Integer getNumberOfPages()
    {
        Integer result = Integer.valueOf(
            Math.ceil(
                Double.valueOf(getResultSize()) / Double.valueOf(this.rowsPerPage)
            )
        );
        result         = result == 0 ? 1 : result;
        return result;
    }
    /**
     * Returns nnumber of records matching criteria (excluding limit condition)
     *
     * @return Integer
     */
    public Integer getResultSize()
    {
        return Database.countQuery(getQuery(true));
    }
    /**
     * Returns query used to fetch data
     *
     * @param Boolean count True to return count query, false to return data query
     * @return String query string
     */
    private String getQuery(Boolean count)
    {
        String query = '';
        query += ' SELECT ';
        if (count) {
            query += ' count() ';
        } else {
            query += ' ArchivedById, ArchivedDate, ArticleNumber, ArticleType, CreatedById, CreatedDate, ';
            query += ' FirstPublishedDate, Id, IsDeleted, IsLatestVersion, IsMasterLanguage, IsOutOfDate, ';
            query += ' IsVisibleInApp, IsVisibleInCsp, IsVisibleInPkb, IsVisibleInPrm, KnowledgeArticleId, ';
            query += ' Language, LastModifiedById, LastModifiedDate, LastPublishedDate, MasterVersionId, OwnerId, ';
            query += ' PublishStatus, SourceId, Summary, SystemModstamp, Title, TranslationCompletedDate, ';
            query += ' TranslationExportedDate, TranslationImportedDate, UrlName, VersionNumber ';
            //query += ' Id,KnowledgeArticleId, ArticleType, Title, UrlName, publishStatus, ';
            //query += ' LastPublishedDate, LastModifiedById, Summary ';
        }
         query += ' FROM ';
            query += ' KnowledgeArticleVersion ';
        query += ' WHERE ';
            query += ' language = \'' + language + '\'';
        query += ' AND ';
            query += ' PublishStatus = \'Online\' ';
        query += ' AND ';
            query += ' ArticleType IN (\'PBS_FAQ_s__kav\', \'PBS_Wiki__kav\') ';

        if (!String.isBlank(filterArticleType)) {
            query += ' AND ArticleType = \'' + String.escapeSingleQuotes(filterArticleType) + '\' ';
        }

        return query;
    }

    public List<SelectOption> getArticleTypeFilterOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','All'));
        options.add(new SelectOption('PBS_FAQ_s__kav','PBS FAQ'));
        options.add(new SelectOption('PBS_Wiki__kav','PBS Wiki'));
        return options;
    }
    /**
     * Builds map of stats for given list of KnowledgeArticleVersion oject list
     *
     * @param List<KnowledgeArticleVersion> articleList
     */
    @TestVisible
    private void getPbsArticleStats(List<KnowledgeArticleVersion> articleList)
    {
        // reset ranking
        ranking.clear();

        if (!articleList.isEmpty()) {
            // Build KnowledgeArticleId set
            Set<String> ids = new Set<String>();
            for (KnowledgeArticleVersion obj : articleList) {
                ids.add(obj.KnowledgeArticleId);
            }

            // load stats for given articles
            for(KnowledgeArticleVoteStat obj : [SELECT ParentId, NormalizedScore FROM KnowledgeArticleVoteStat WHERE ParentId IN :ids AND Channel = 'AllChannels']) {
                ranking.put(obj.ParentId, obj.NormalizedScore);
            }

            // make sure there are no gaps in the map
            for (String KnowledgeArticleId : ids) {
                if (!ranking.containsKey(KnowledgeArticleId)) {
                    ranking.put(KnowledgeArticleId, 0);
                }
            }
        }
    }
    /**
     * Returns whether we need to see previous button or not
     *
     * @return Boolean
     */
    public boolean getHasPrevious() {
        return currentPage > 1;
    }
    /**
     * Returns whether we need to see next button or not
     *
     * @return Boolean
     */
    public boolean getHasNext() {
        return currentPage * rowsPerPage < getResultSize();
    }
    /**
     * Returns current page number
     *
     * @return Integer
     */
    public Integer getCurrentPageNumber() {
        return this.currentPage;
    }
    /**
     * action for next click
     *
     * @return PageReference
     */
    public PageReference next() {
        if(getResultSize() > this.currentPage * rowsPerPage) {
            this.currentPage = this.currentPage + 1;
        }
        return null;
    }
    /**
     * action for previous click
     *
     * @return PageReference
     */
    public PageReference previous() {
        if(this.currentPage > 1) {
            this.currentPage = this.currentPage - 1;
        }
        return null;
    }
    /**
     * Action called to update sorting. This also refreshes page to 1
     *
     * @return PageReference
     */
    public PageReference sortData()
    {
        this.currentPage = 1;
        return null;
    }

}