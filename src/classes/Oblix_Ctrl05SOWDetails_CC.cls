/**
    About
    -----
    Description: Class Oblix_Ctrl05SOWDetails_CC
    Created for: Oblix Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : used as a Global Page to View Statement of Work and make filters
                     New Sales on : Account, Opportunity
                     
            Functionnalities : 
                   
                            ==> Filter Sow Records by : Brand, Financial Year, Categories
                            ==> View selected Record
                            ==> Share it
                            ==> Create new SOW
                            ==> Approve it
                            ==> Folow it on Gantt project
    Update History
    --------------    
*/
public with sharing class Oblix_Ctrl05SOWDetails_CC {
    
    public Marketing_SOW__c selSow {get;set;}
    public String selectedSewId {get;set;}
    public List<Marketing_SOW__c> lstSowsMarketing {get;set;}
    
    //Thousand Block Part : 
    public  limitWrapper[] thousandBlocks {get;set;}
    private final integer listLimit;
    
    //Build Query where
     public String selectedBrand {get;set;}
     public String selectedFYear     {get;set;}
     public String selectedSmallCat {get;set;}
     public String selectedBigCat{get;set;}
     
     //Filters vars 
     public final List<Marketing_SOW__c> lstMarkCategoriesFilter = [Select Id, Name, SmallProductCategory__c, SmallProductCategory__r.Name, BigOblixProductCategory__c, BigOblixProductCategory__r.Name, OblixBrand__c, OblixBrand__r.Name from Marketing_SOW__c where RecordTypeId =:Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ParentSowMarketing') and  (SmallProductCategory__c != null or BigOblixProductCategory__c != null or OblixBrand__c != null)];
     public String WhereQuery {get; set;}
     
     //OverView Variables
     public String selectedSowId {get;set;}
     //Attachements to the Sow
     public List<Attachment> lstAttachements {get;set;}
     public list<note> notes {get;set;}
     //Projects to the Sow
     public List<Oblix_SOW_Projects__c> lstProjects {get;set;}
     // Gantt chart variables 
     public string seriesProject {get;set;}
     public User userConnected {get;set;}
     public map<id,decimal> mapApproved{get;set;}
     private String parentSOWRTID ='';
     //achraf
      public Attachment attachment {
          get {
              if (attachment == null)
                attachment = new Attachment();
              return attachment;
          }set;}
    
     
     public Oblix_Ctrl05SOWDetails_CC(){
        listLimit = 999;
        Id idUser = UserInfo.getUserId();
        userConnected = [Select Name from User where Id =: idUser ];
        selSow = new Marketing_SOW__c();
        mapApproved = new map<id,decimal>();
        lstAttachements = new List<Attachment>();
        lstProjects = new List<Oblix_SOW_Projects__c>();
        seriesProject = '';
        selectedBrand ='';
        selectedFYear ='';
        selectedSmallCat ='';
        selectedBigCat ='';
		parentSOWRTID  = Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ParentSowMarketing');
        init();
    }
    
     /**
     * Initialise the Query,
     * @param Sales_Id [Sales_Id]
     */      
      
    public void init(){
        WhereQuery = 'Select Id, Agency_Contact__c,OblixSOWOverallTotal__c,Currency__c , Unilever_Lead__c, CreatedById, CreatedBy.Name, LastModifiedById, FINAL_APPROVED_FEE_K__c, LastModifiedBy.Name, Financial_Year__c, BigOblixProductCategory__c, Name, SmallProductCategory__c, OblixBrand__c, OblixBrand__r.Name, Marketing_Agency__c, LastModifiedDate, CreatedDate, SOW_Status__c  from Marketing_SOW__c  where recordTypeId=\''+parentSOWRTID+'\'';
        runQuery();
    } 
    
    /**
     * Description : This method is used to construct values of a filter for : Small Category
     * @param  l lstof Brands
     */
    public List<SelectOption> getSmallCategory(){
        Map<Id, String> MapSmallCatIdToName = new Map<Id, String>();
        if(lstMarkCategoriesFilter.size()>0){
            for(Marketing_SOW__c mark : lstMarkCategoriesFilter){
                if(mark.SmallProductCategory__c != null){
                    if(!MapSmallCatIdToName.containsKey(mark.SmallProductCategory__c)) MapSmallCatIdToName.put(mark.SmallProductCategory__c, mark.SmallProductCategory__r.Name); 
                }
            }
        }
        System.debug('###MapSmallCatIdToName : '+MapSmallCatIdToName);
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-Small Category-'));
        if(MapSmallCatIdToName.keySet().size()>0){
            for(Id sowCat : MapSmallCatIdToName.keySet()){
                    if(MapSmallCatIdToName.get(sowCat) != null){
                        options.add(new SelectOption(sowCat,MapSmallCatIdToName.get(sowCat)));
                    }
            }
        }
        return options;
        
    }
    
    /**
     * Description : This method is used to construct values of a filter for : Big Category
     * @param  l lstof Brands
     */
    public List<SelectOption> getBigCategory(){
        Map<Id, String> MapBigCatIdToName = new Map<Id, String>();
        if(lstMarkCategoriesFilter.size()>0){
            for(Marketing_SOW__c mark : lstMarkCategoriesFilter){
                if(mark.BigOblixProductCategory__c != null){
                    if(!MapBigCatIdToName.containsKey(mark.BigOblixProductCategory__c)) MapBigCatIdToName.put(mark.BigOblixProductCategory__c, mark.BigOblixProductCategory__r.Name); 
                }
            }
        }
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-Big Category-'));
        if(MapBigCatIdToName.keySet().size()>0){
            for(Id sowCat : MapBigCatIdToName.keySet()){
                    if(MapBigCatIdToName.get(sowCat) != null){
                        options.add(new SelectOption(sowCat,MapBigCatIdToName.get(sowCat)));
                    }
            }
        }
        return options;
        
    }
    
    /**
     * Description : This method is used to construct values of a filter for : BRAND
     * @param  l lstof Brands
     */
     
     //loop through Ids and for each id we have the name : map constructed
    public List<SelectOption> getBrandItems() {
        Map<Id, String> MapBrandIdToName = new Map<Id, String>();
        if(lstMarkCategoriesFilter.size()>0){
            for(Marketing_SOW__c mark : lstMarkCategoriesFilter){
                if(mark.OblixBrand__c != null){
                    if(!MapBrandIdToName.containsKey(mark.OblixBrand__c)) MapBrandIdToName.put(mark.OblixBrand__c, mark.OblixBrand__r.Name);  
                }
            }
        }
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-Brand-'));
        if(MapBrandIdToName.keySet().size()>0){
            for(Id sowCat : MapBrandIdToName.keySet()){
                    if(MapBrandIdToName.get(sowCat) != null){
                        options.add(new SelectOption(sowCat,MapBrandIdToName.get(sowCat)));
                    }
            }
        }
        return options;
    }
    
    /**
     * Description : This method is used to construct values of a filter for : Financial Year
     * @param  l lstof SOW
     */
    public List<SelectOption> getFinancialYear() {
        
         List<SelectOption> options = new List<SelectOption>();
           Schema.DescribeFieldResult fieldResult = Marketing_SOW__c.Financial_Year__c.getDescribe();
           List<Schema.PicklistEntry> plentries = fieldResult.getPicklistValues();
            options.add(new SelectOption('','-Financial Year-'));    
           for( Schema.PicklistEntry f : plentries)
           {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
           return options;
    }
    
     /**
     * Build the Where part of the query as string.
     * @return [the Where part of the query as string] 
     */ 
    private List<String> buildQueryWhere()
    {
        List<String> lstQueryWhere = new List<String>();
        
        system.debug('###selectedBrand : '+selectedBrand);
        String strToAdd = esc(selectedBrand);
        if (strToAdd != null && strToAdd != '')
        {
            lstQueryWhere.add('OblixBrand__c = \'' + strToAdd + '\'');
        }
        system.debug('###selectedFYear: '+selectedFYear);
        strToAdd = esc(selectedFYear);
        if (strToAdd != null && strToAdd != '')
        {
            lstQueryWhere.add('Financial_Year__c = \'' + strToAdd + '\'');
        }
        system.debug('###selectedSmallCat: '+selectedSmallCat); 
        strToAdd = esc(selectedSmallCat);
        if (strToAdd != null && strToAdd != '')
        {
            lstQueryWhere.add('SmallProductCategory__c = \'' + strToAdd + '\'');
        }
        system.debug('###selectedBigCat: '+selectedBigCat);
        strToAdd = esc(selectedBigCat);
        if (strToAdd != null && strToAdd != '')
        {
            lstQueryWhere.add('BigOblixProductCategory__c = \'' + strToAdd + '\'');
        }
        
         
        return lstQueryWhere;
    }
    
      /**
     * When user clicked on Apply Filters:
     * @return [Rerender table with filtered results.] 
     */  
    public void applyFilters()
    {
        
        WhereQuery = 'Select Id, Agency_Contact__c,OblixSOWOverallTotal__c,Currency__c , Unilever_Lead__c, CreatedById, CreatedBy.Name, LastModifiedById, FINAL_APPROVED_FEE_K__c, LastModifiedBy.Name, Financial_Year__c, BigOblixProductCategory__c, Name, SmallProductCategory__c, OblixBrand__c, OblixBrand__r.Name, Marketing_Agency__c, LastModifiedDate, CreatedDate, SOW_Status__c  from Marketing_SOW__c  where recordType.name = \'Parent Sow Marketing\'';
        List<String> lstQueryWhere = buildQueryWhere();
        system.debug('###Sfdc lstQueryWhere :' + lstQueryWhere );
        if(lstQueryWhere.size() == 0){
            thousandBlocks = new List<limitWrapper>();
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,Oblix_Constants.SELECT_ONE_FILTER));
        }else{
            
            for (String andQuery : lstQueryWhere)
            {
                WhereQuery += ' AND ( ' + andQuery + ') ';
            }
        }
        runQuery();
        system.debug('Sfdc WhereQuery:' + WhereQuery);
        
    }
    
      /**
     * Run Query
     * @return [Rerendeer the Query filtered.] 
     */  
     public void runQuery() {
     
        try {
        
          List<Marketing_SOW__c >  lstMarketingSowTmp = Database.query(WhereQuery);
          System.debug('###lstMarketingSowTmp :'+lstMarketingSowTmp);
          getthousandBlocks(lstMarketingSowTmp);
          System.debug('###thousandBlocks :'+thousandBlocks);
       
        } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops, Error occured during query run!'));
        }
      
     }
      /**
     * Method used to avoid Limit of Thousand Record by Repeat component
     * @return [List of Records by Block of Thousand ] 
     */ 
    public limitWrapper[] getthousandBlocks(List<Marketing_SOW__c> lstSowsMarketingLocal)
    {   
        //declare it above
        thousandBlocks = new List<limitWrapper>();
        
        integer counter = 0;
        integer loopCount = 0;
        list<Marketing_SOW__c> tmpMarket = new list<Marketing_SOW__c>();
            for(Integer i=0;i< lstSowsMarketingLocal.size();i++)
            {
                if(counter < listLimit)
                {   
                    
                    if(i!=lstSowsMarketingLocal.size()-1){
                         tmpMarket.add(lstSowsMarketingLocal.get(i));
                         counter++;
                    }
                    else{
                         tmpMarket.add(lstSowsMarketingLocal.get(i));  
                         counter++;
                         loopCount++;
                      
                     thousandBlocks.add(new limitWrapper(tmpMarket,loopCount));
                      return thousandBlocks;
                    }
                   
                }
                else
                {   
                      loopCount++;
                        thousandBlocks.add(new limitWrapper(tmpMarket,loopCount));
                        tmpMarket = new List<Marketing_SOW__c>();
                        tmpMarket.add(lstSowsMarketingLocal.get(i));
                        counter = 0;
                }
                            
            }
        
        if(thousandBlocks.size() == 0)
        {
            loopCount++;
            thousandBlocks.add(new limitWrapper(tmpMarket,loopCount));
        }
        
        return thousandBlocks;
    }
    
    
    /**
     * Guard against SOQL injection
     */ 
    private String esc(String s) 
    {
        return s != null ? String.escapeSingleQuotes(s) : null;
    }
    
    
    public PageReference ViewSow(){
        
        return new PageReference('/'+selectedSowId);
    }
    
    public void RerenderSelectedSow(){
        System.debug('###selectedSewId : '+selectedSewId );
        if(selectedSewId != null && selectedSewId != ''){
            selSow = [Select Id, Agency_Contact__r.name,OblixSOWOverallTotal__c, Oblix_AgencyEstimate__c ,Oblix_AgencyEstimate__r.name,Unilever_Lead__r.name, CreatedById, CreatedBy.Name, Currency__c, 
                        BigOblixProductCategory__r.Name, OblixBrand__r.Name, SmallProductCategory__r.Name,
                        LastModifiedById, FINAL_APPROVED_FEE_K__c, LastModifiedBy.Name, Financial_Year__c, BigOblixProductCategory__c, 
                        Name, SmallProductCategory__c, OblixBrand__c, Marketing_Agency__c, LastModifiedDate, CreatedDate, 
                        SOW_Status__c, BB_or_BD__c   from Marketing_SOW__c where Id=: selectedSewId
                        ];
                System.debug('###selSow : '+selSow);
                
                if(selSow != null && selSow.Id != null){
                    list<Marketing_SOW__c> childSow = new list<Marketing_SOW__c>();
                    System.debug('###selSow.id : '+selSow.id);
                   childSow = [select id,OblixSOWOverallTotal__c from Marketing_SOW__c where MarketingSOWParent__c =:selSow.id  and Type_of_SOW__c = 'Baseline'  ];
                    System.debug('###childSow : '+childSow );
                    if(childSow.size()>0){ 
                       mapApproved.put(selSow.id,childSow[0].OblixSOWOverallTotal__c);
                    }else{
                        mapApproved.put(selSow.id,0.00);
                    }
                    lstAttachements = [Select Id, Name, Body, ParentId, Parent.Name from Attachment where ParentId =: selSow.Id];
                    lstProjects = [Select Id,Name, Project_Finish_Date__c, Project_Start_Date__c, Financial_Year__c,Production_Completion_Date__c,Project_Completion_Date__c,First_Air_Date__c from Oblix_SOW_Projects__c where Financial_Year__c =: selSow.Id];
                    notes = [ select body from note where parentId =:selSow.Id];
               }
                /*
                string seriesbis = '';
                date d_projStart, d_prodCompletion, d_projEnd,d_firstAir,d_projCompletion ;
                string series = '';
                date d1,d2;
                if(lstProjects.size() >0)
                
                for(Oblix_SOW_Projects__c  pr:lstProjects){
                   
                    if(pr.Project_Start_Date__c != null) d_projStart = pr.Project_Start_Date__c.addMonths(-1);
                    else d_projStart  = date.newInstance(2015,1,1);   
                    if(pr.Project_Finish_Date__c != null ) d_projEnd = pr.Project_Finish_Date__c.addMonths(-1);
                    else d_projEnd = date.newInstance(2015,1,1);  
                     
                    if(pr.Production_Completion_Date__c != null)d_prodCompletion = pr.Production_Completion_Date__c.addMonths(-1);
                    else d_prodCompletion = date.newInstance(2015,1,1);   
                    if(pr.First_Air_Date__c != null) d_firstAir = pr.First_Air_Date__c.addMonths(-1);
                    else d_firstAir = date.newInstance(2015,1,1);   
                    if(pr.Project_Completion_Date__c != null) d_projCompletion = pr.Project_Completion_Date__c.addMonths(-1);
                    else d_projCompletion = date.newInstance(2015,1,1);   
                   
                    series = series +'{'+
                            '"unitName"'+':"'+pr.name+'",'+
                            '"beginTimestamp"'+':'+'Date.UTC('+d_projStart.year()+','+d_projStart.month()+','+ d_projStart.day()+'),'+
                            '"x1Timestamp"'+':'+'Date.UTC('+d_projCompletion.year()+','+d_projCompletion.month()+','+ d_projCompletion.day()+'),'+
                            '"x2Timestamp"'+':'+'Date.UTC('+d_firstAir.year()+','+d_firstAir.month()+','+d_firstAir.day()+'),'+
                            '"x3Timestamp"'+':'+'Date.UTC('+d_prodCompletion.year()+','+d_prodCompletion.month()+','+ d_prodCompletion.day()+'),'+
                            '"endTimestamp"'+':'+'Date.UTC('+d_projEnd.year()+','+d_projEnd.month()+','+ d_projEnd.day()+')'+
                            +'}' + ',' ;            
                }
              seriesProject = '['+series.removeEnd(',')+']';*/
        }
    }
    /*
    * Related Actions
    */
    public void ViewAttachements(){
        System.debug('###selSow : '+selSow);
        if(selSow != null && selSow.Id != null){
            lstAttachements = [Select Id, Name, Body, ParentId,Parent.Name from Attachment where ParentId =: selSow.Id];
        }
    }
    public pageReference ViewAction(){
        return new pagereference('/apex/Oblix_VF06_SOWView?sowId='+selSow.Id);
    }
     public pageReference CreateSOWAction(){
        return new pagereference('/apex/Oblix_VF06_SOWView');
    }
    /*
    *   Wrapper Class : Used to bypass the Limit of 1000 Record on a repeat
    */
     public class limitWrapper
    {
        public  List<Marketing_SOW__c>  lstMarketingSows {get;set;}
        public integer blockNumber {get;set;}
        public limitWrapper(List<Marketing_SOW__c> markSowRecords, integer i)
        {
            lstMarketingSows = markSowRecords;
            blockNumber = i;
        }
        
    }
    
    //Achraf attachement 
    
    
    
    public void uploadeAttachment(){
        system.debug('==============saving name = '+attachment.name);
        system.debug('==============saving desc = '+attachment.description);
        system.debug('==============saving File= '+attachment.body);
        
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = selectedSewId; // the record the file is attached to
        attachment.IsPrivate = true;
        try {
                insert attachment;
            } catch (DMLException e) {
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
               //return null;
            } finally {
              lstAttachements.add(attachment );
              attachment = new Attachment();
               
        }
        

        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        //return null;
    }
    public void Cancel (){
        return;
    }
}