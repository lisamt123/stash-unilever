/**
     * Controller for Group Home page
     *
     * @author  Krzysztof Wasniowski <k.wasniowski@polsource.com>
     */
    public with sharing class PBS_LibraryController_CC
    {
        public String searchstring { get; set; }        
        private static final string STR_AND = ' AND ';
        private static final string STR_TITLE = 'Title';
        public Integer getSearchCount {get;set;}
    
        /**
         * Holds user language
         */
        public String language {get; set;}
     
        public String groupNameSearch{get; set;}
                
        /**
         * Map of knowledgeArtileId to stats
         */
        public Map<String, Decimal> ranking {get; set;}        
        public Map<String, String> groupnameMap{get; set;}
        public Map<String, String> groupnameMap1{get; set;}
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
                if ( sortField != STR_TITLE && sortField != 'Summary' && sortField != 'lastPublishedDate' ) {
                    sortField = STR_TITLE;
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
        public List<KnowledgeArticleVersion> PbsArticleSearchList {get;set;}
        public List<KnowledgeArticleVersion> PbsArticleSearchList1{get;set;}
        
        /**
         * Class constructor
         */
        public PBS_LibraryController_CC() {
            sortField = STR_TITLE;
            sortDir   = 'ASC';
            language  = UserInfo.getLanguage();
            ranking   = new Map<String, Decimal>();
            groupnameMap = new Map<String, String>();
            groupnameMap1 = new Map<String, String>();
            PbsArticleSearchList = new List<KnowledgeArticleVersion>();
            PbsArticleSearchList1 = new List<KnowledgeArticleVersion>();
            //getPbsArticleList();
            pbsKnowledgeArticleList();
            
            
        }
        /**
         * Return list of knowledge articles
         *
         * @return List<KnowledgeArticleVersion> Returns list of KnowledgeArticleVersion objects
         */
        //public List<KnowledgeArticleVersion> getPbsArticleList()
        public List<KnowledgeArticleVersion> pbsKnowledgeArticleList()
        {                  
                String query = getQuery(false);
                query += ' ORDER BY ' + sortField + ' ' + sortDir + (sortField != 'Title' ? ', Title ASC' : '');
                query += ' LIMIT ' + this.rowsPerPage;
                query += ' OFFSET ' + ((this.currentPage - 1) * this.rowsPerPage);
                system.debug('Query ->>'+query);
                PbsArticleSearchList = Database.query(query);
                String idStrings = '(\'';
                for(KnowledgeArticleVersion xKAV : PbsArticleSearchList){                    
                    idStrings += xKAV.Id+ '\',\'';
                }
                idStrings = idStrings.substring(0,idStrings.length()-2); 
                idStrings += ')';                
                
                String QueryPBS_WIKI = 'Select Id,Group_Name__c FROM PBS_Wiki__kav where PublishStatus=\'Online\'';
                       
                if(PbsArticleSearchList.size()>0){
                       QueryPBS_WIKI += ' AND Id in' +idStrings;
                
                if((groupNameSearch !=''  && groupNameSearch != null) &&  groupNameSearch != 'All'){
                   QueryPBS_WIKI += ' AND Group_Name__c=\''+groupNameSearch+'\' ';
              }
                    
                System.debug('QueryPBS_WIK====>'+ QueryPBS_WIKI);
                    
                groupnameMap1.clear(); 
                   
                for(PBS_Wiki__kav xWIKI: Database.query(QueryPBS_WIKI)){
                        System.debug('xWIKI--->'+xWIKI.Group_Name__c);                      
                        xWIKI.Group_Name__c = xWIKI.Group_Name__c==null ? '':xWIKI.Group_Name__c;
                        groupnameMap.put(xWIKI.Id,xWIKI.Group_Name__c);
                      groupnameMap1.put(xWIKI.Id,xWIKI.Group_Name__c);  
                    }
                   System.debug('groupnameMap--->'+groupnameMap);
                   System.debug('groupnameMap1--->'+groupnameMap1); 
                }
               
                 PbsArticleSearchList1.clear();
         for(KnowledgeArticleVersion  list1: PbsArticleSearchList){
         if(groupnameMap1.containsKey(list1.id)){
           PbsArticleSearchList1 .add(list1);
         }    
         }
                 PbsArticleSearchList.clear();
               PbsArticleSearchList.addAll(PbsArticleSearchList1);
                // load stats 
                getPbsArticleStats(PbsArticleSearchList);
                return PbsArticleSearchList;         
        }
        
        Set<Id> setKnowledgeId = new Set<Id>();      
        
        public Pagereference getPbsArticleSearchList()
        {  
           String searchQueryCount;  
           String pageUrl = ApexPages.currentPage().GetURL();
            
           if ((searchstring == null || searchstring == '' ) && !pageUrl.toLowerCase().contains('planwiki'))
           {
             PageReference pageRef = new PageReference('/apex/pbs_library');
             pageRef.setRedirect(true);       
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Search term must be longer than one character'));
             return pageRef ;
           } 
           if((searchstring == null || searchstring == '' ) && pageUrl.toLowerCase().contains('planwiki')){
              PageReference pageRef = new PageReference('/apex/pbs_planwiki');
              pageRef.setRedirect(true);        
              //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Search term must be longer than one character'));
              pbsKnowledgeArticleList();
              return null ;                      
          } 
           if(searchstring != null && searchstring != '' && this.currentPage > 1){
             this.currentPage = 1;
          }  
            //String searchQueryCount = 'FIND \'' + searchstring + '*\' IN ALL FIELDS RETURNING PBS_Wiki__kav(Id,KnowledgeArticleId WHERE PublishStatus=\'Online\' AND Language=\'en_US\'';
            //searchQueryCount += ' ORDER BY ' + sortField + ' ' + sortDir + (sortField != STR_TITLE ? ', Title ASC' : '') + ')';
            searchQueryCount = 'FIND \'' + searchstring + '*\' IN ALL FIELDS RETURNING PBS_Wiki__kav(Id,KnowledgeArticleId,Group_Name__c WHERE PublishStatus=\'Online\'';
            searchQueryCount += ' AND Language=\''+language+'\'';
            if(groupNameSearch!='All'){
                searchQueryCount += ' AND Group_Name__c=\''+groupNameSearch+'\' ';
            }
            searchQueryCount += ' ORDER BY ' + sortField + ' ' + sortDir + (sortField != STR_TITLE ? ', Title ASC' : '') +')' ;
             system.debug('***searchQueryCount******'+searchQueryCount);
            List<List<sObject>> searchCountList = search.query(searchQueryCount);
             
           
            List<PBS_Wiki__kav> lstPbsWikiCount = searchCountList [0];      
            getSearchCount  =  lstPbsWikiCount.size();
                           system.debug('*******getSearchCount  '+getSearchCount  );                     
            String searchQuery = 'FIND \'' + searchstring + '*\' IN ALL FIELDS RETURNING PBS_Wiki__kav(Id,KnowledgeArticleId,Group_Name__c WHERE PublishStatus=\'Online\'';
            searchQuery+= ' AND Language=\''+language+'\'';
            if(groupNameSearch!='All'){
                searchQuery+= ' AND Group_Name__c=\''+groupNameSearch+'\' ';
            }
            searchQuery += ' ORDER BY ' + sortField + ' ' + sortDir + (sortField != STR_TITLE ? ', Title ASC' : '')  ;
            searchQuery += ' LIMIT ' + this.rowsPerPage;
            searchQuery += ' OFFSET ' + ((this.currentPage - 1) * this.rowsPerPage)+')';
            
           
              system.debug('*******searchQuery'+searchQuery);   
            List<List<sObject>> searchList = search.query(searchQuery);
            
            List<PBS_Wiki__kav> lstPbsWiki = searchList[0];    
           
           setKnowledgeId = new Set<ID>();
         
            for(PBS_Wiki__kav objPbsWiki : lstPbsWiki){
                system.debug('*******objPbsWiki '+objPbsWiki );
                setKnowledgeId.add(objPbsWiki.KnowledgeArticleId);
                objPbsWiki.Group_Name__c = objPbsWiki.Group_Name__c==null ? '':objPbsWiki.Group_Name__c;
                groupnameMap.put(objPbsWiki.Id,objPbsWiki.Group_Name__c);
            
            }
            String newQuery = getQuery();
              system.debug('*******newQuery '+newQuery  );
           PbsArticleSearchList = new List<KnowledgeArticleVersion> ();
           List<KnowledgeArticleVersion> PbsArticleSearchListnew1 = new List<KnowledgeArticleVersion> ();
           PbsArticleSearchListnew1 =Database.query(newQuery);
            
            // load stats
            for(KnowledgeArticleVersion obj : PbsArticleSearchListnew1){
             system.debug('*******obj '+obj );
                if(setKnowledgeId.contains(obj.KnowledgeArticleId)){
                    PbsArticleSearchList.add(obj);
                }
            }
            getPbsArticleStats(PbsArticleSearchList);
            
            return null;
        }
        
         /**
         * Returns query used to fetch data
         *
         * @param Boolean count True to return count query, false to return data query
         * @return String query string
         */
        private String getQuery()
        {        
                String idString = '(\'';
                for (Id thisId : setKnowledgeId) {
                    idString += thisId + '\',\'';
                }
                idString = idString.substring(0,idString.length()-2); 
                idString += ')';

                String query = '';
                query += ' SELECT ';
                query += ' ArchivedById, ArchivedDate, ArticleNumber, ArticleType, CreatedById, CreatedDate, ';
                query += ' FirstPublishedDate, Id, IsDeleted, IsLatestVersion, IsMasterLanguage, IsOutOfDate, ';
                query += ' IsVisibleInApp, IsVisibleInCsp, IsVisibleInPkb, IsVisibleInPrm, KnowledgeArticleId, ';
                query += ' Language, LastModifiedById, LastModifiedDate, LastPublishedDate, MasterVersionId, OwnerId, ';
                query += ' PublishStatus, SourceId, Summary, SystemModstamp, Title, TranslationCompletedDate, ';
                query += ' TranslationExportedDate, TranslationImportedDate, UrlName, VersionNumber ';
               
            
            query += ' FROM ';
                query += ' KnowledgeArticleVersion ';
            query += ' WHERE ';
            
            query += ' language = \'' + language + '\'';
      
            query += STR_AND;
                query += ' PublishStatus = \'Online\' ';
            query += STR_AND;
                query += ' ArticleType IN (\'PBS_Wiki__kav\') ';
            
            if(!setKnowledgeId.isEmpty())  {  
                query += STR_AND;
                query += ' KnowledgeArticleId IN '+idString;
            }
                
            if (!String.isBlank(filterArticleType)) {
                query += ' AND ArticleType = \'' + String.escapeSingleQuotes(filterArticleType) + '\' ';
            }
            return query;
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
            
            if(getSearchCount  != null)
             result = Integer.valueOf(
                Math.ceil(
                    Double.valueOf(getSearchCount) / Double.valueOf(this.rowsPerPage)
                )
            );            
            result = result == 0 ? 1 : result;
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
            String pageUrl = ApexPages.currentPage().GetURL();
             
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
        
            if(pageUrl.toLowerCase().contains('planwiki')){
            
                query += ' ArticleType IN ( \'PBS_Wiki__kav\') ';
            }
            else{
                
              
                query += ' ArticleType IN (\'PBS_FAQ_s__kav\', \'PBS_Wiki__kav\') ';
            }

            if (!String.isBlank(filterArticleType)) {
                query += ' AND ArticleType = \'' + String.escapeSingleQuotes(filterArticleType) + '\' ';
            }
            
            /*
            if (!String.isBlank(searchstring)) {
                //query += ' AND ( ArticleType Like  \'%' + String.escapeSingleQuotes(searchstring) + '%\'';
                query += ' AND ( Title Like  \'%' + String.escapeSingleQuotes(searchstring) + '%\' ';
                
                query += ' OR Summary Like  \'%' + String.escapeSingleQuotes(searchstring) + '%\' )';
                
            }
            */

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
        
            if(getSearchCount == null )
            return currentPage * rowsPerPage < getResultSize();
            else
            return currentPage * rowsPerPage < getSearchCount;
            
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
         
          
            if(getResultSize() > this.currentPage * rowsPerPage && (searchstring == '' || searchstring == null )) {
                this.currentPage = this.currentPage + 1;
            }
            if(getSearchCount  > this.currentPage * rowsPerPage){
                 this.currentPage = this.currentPage + 1;
            }
            getPbsArticleSearchListSearch();
            
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
            getPbsArticleSearchListSearch();
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
            getPbsArticleSearchListSearch();
            return null;
        }

    
          public Pagereference getPbsArticleSearchListSearch()
        {        
            String searchQuery = '';
            if(searchstring  != null && searchstring  != '')  {                            
            searchQuery = 'FIND \'' + searchstring + '*\' IN ALL FIELDS RETURNING PBS_Wiki__kav(Id,KnowledgeArticleId,Group_Name__c WHERE PublishStatus=\'Online\'';
            searchQuery += ' AND Language=\''+language+'\'';
            if(groupNameSearch!='All'){
                searchQuery += ' AND Group_Name__c=\''+groupNameSearch+'\' ';
            }
            searchQuery += ' ORDER BY ' + sortField + ' ' + sortDir + (sortField != STR_TITLE ? ', Title ASC' : '');
            searchQuery += ' LIMIT ' + this.rowsPerPage;
            searchQuery += ' OFFSET ' + ((this.currentPage - 1) * this.rowsPerPage) + ')';
            
            
            List<List<sObject>> searchList = search.query(searchQuery);
              system.debug('*******searchQuery'+searchQuery);    
            List<PBS_Wiki__kav> lstPbsWiki = searchList[0];               
                
           
           setKnowledgeId = new Set<ID>();
         
            for(PBS_Wiki__kav objPbsWiki : lstPbsWiki){
                 system.debug('*******objPbsWiki '+objPbsWiki );
                setKnowledgeId.add(objPbsWiki.KnowledgeArticleId);
                objPbsWiki.Group_Name__c = objPbsWiki.Group_Name__c==null ? '':objPbsWiki.Group_Name__c;
                groupnameMap.put(objPbsWiki.Id,objPbsWiki.Group_Name__c);
            
            }
           String newQuery = getQuery();
           system.debug('*******newQuery '+newQuery  );
           PbsArticleSearchList = new List<KnowledgeArticleVersion> ();
           List<KnowledgeArticleVersion> PbsArticleSearchListnew1 = new List<KnowledgeArticleVersion> ();
           PbsArticleSearchListnew1 =Database.query(newQuery);
            
            // load stats
            for(KnowledgeArticleVersion obj : PbsArticleSearchListnew1){
             system.debug('*******obj '+obj );
                if(setKnowledgeId.contains(obj.KnowledgeArticleId)){
                    PbsArticleSearchList.add(obj);
                    
                }
            }  
                /*         
        PbsArticleSearchList1.clear();
        for(KnowledgeArticleVersion  list1: PbsArticleSearchList){
            PbsArticleSearchList1 .add(list1);
        }              
                */
            getPbsArticleStats(PbsArticleSearchList);
            }
            else{            
                pbsKnowledgeArticleList();
            }
            
            return null;
        }
        
        public List<SelectOption> getlanguages()
        {
        
            
           List<SelectOption> options = new List<SelectOption>();
                
           Schema.DescribeFieldResult fieldResult = KnowledgeArticleVersion.Language.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry f : ple)
           {
              options.add(new SelectOption(f.getValue() ,f.getLabel()));
           }
             
           return options;
        }
        


}