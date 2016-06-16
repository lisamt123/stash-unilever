/*****************************************************************************************
* @author       Slavko Skular
* @date         2016-02-02
* @description  This class controls Oblix_SOWMain page
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Slavko Skular              2016-02-02          Created

******************************************************************************************/

public with sharing class Oblix_SowMainController extends Oblix_SWOPparentController{

    public String selectedSowId {get; set;}
    public Boolean can_create_sow {
        get{
            return Oblix_PermissionHandler.canCreateSOW();
        }
    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-02
    * @description  top link on the page exists SWOP app
    ********************************************************************************/
    public Pagereference redirectToSOWDetailPage() {
        
        Pagereference meNewPage = Page.Oblix_SOWMainDetail;
        meNewPage.getParameters().put('sowId', selectedSowId);
        return meNewPage;

    }

    









/***
    About
    -----
    Description: Class Oblix_SowMainController
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
//public with sharing class Oblix_SowMainController extends Oblix_SWOPparentController{

















    public Set<String> attachmentsToRemove {get; set;}
    public Marketing_SOW__c selSow {get; set;}
    public String selectedSewId {get; set;}
    public List<Marketing_SOW__c> lstSowsMarketing {get; set;}

    //Thousand Block Part :
    public  limitWrapper[] thousandBlocks {get; set;}
    private final integer listLimit;

    //Build Query where
    public String selectedBrand {get; set;}
    public String selectedFYear     {get; set;}
    public String selectedSmallCat {get; set;}
    public String selectedBigCat {get; set;}

    //Filters vars
    public final List<Marketing_SOW__c> lstMarkCategoriesFilter = [Select Id, Name, SmallProductCategory__c, SmallProductCategory__r.Name, BigOblixProductCategory__c, BigOblixProductCategory__r.Name, OblixBrand__c, OblixBrand__r.Name from Marketing_SOW__c where RecordTypeId = :Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ParentSowMarketing') and  (SmallProductCategory__c != null or BigOblixProductCategory__c != null or OblixBrand__c != null)];
    public String WhereQuery {get; set;}

    //OverView Variables
    //public String selectedSowId {get; set;}
    //Attachements to the Sow
    public List<Attachment> lstAttachements {get; set;}
    public list<note> notes {get; set;}
    //Projects to the Sow
    public List<Oblix_SOW_Projects__c> lstProjects {get; set;}
    // Gantt chart variables
    public string seriesProject {get; set;}
    public User userConnected {get; set;}
    public map<id, integer> mapApproved {get; set;}
    private String parentSOWRTID = '';
    //achraf
    public Attachment attachment {
        get {
            if (attachment == null){
                attachment = new Attachment();              
            }
            return attachment;
        } set;
    }

    public String attachmentToRemove {get; set;}
    
    public static PageReference reportFolderURL {
        get{
            
            if(reportFolderURL == null){
                
                List<Folder> reportFolderIdList = [SELECT Id FROM Folder WHERE Name =: Oblix_Constants.SWOPReportFolder];
                if(!reportFolderIdList.isEmpty()){
                    reportFolderURL = new PageReference('/' + reportFolderIdList[0].Id);
                }
                
            }
            
            return reportFolderURL;
            
        } set;
    }
    
    public PageReference forwardToReportFolder(){
        return reportFolderURL;
    }


<<<<<<< HEAD
    public Oblix_SowMainController() {
        attachmentToRemove = 'tet';
        listLimit = 999;
        Id idUser = UserInfo.getUserId();
        userConnected = [Select Name from User where Id = : idUser ];
        selSow = new Marketing_SOW__c();
        mapApproved = new map<id, integer>();
        lstAttachements = new List<Attachment>();
        attachmentsToRemove = new Set<String>();
        lstProjects = new List<Oblix_SOW_Projects__c>();
        seriesProject = '';
        selectedBrand = '';
        selectedFYear = '';
        selectedSmallCat = '';
        selectedBigCat = '';
        parentSOWRTID  = Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ParentSowMarketing');
        init();
    }

    /**
    * Initialise the Query,
    * @param Sales_Id [Sales_Id]
    */

    public void init() {
        WhereQuery = 'Select Id, Agency_Contact__c,OblixTotalOtherItemsFees__c,Oblix_AgencyEstimate__r.name,Oblix_AgencyEstimate__c ,OblixSOWOverallTotal__c,Oblix_Current_FY_Total__c,Total_Campaigns_This_FY__c,Currency__c , Unilever_Lead__c, CreatedById, CreatedBy.Name, LastModifiedById, FINAL_APPROVED_FEE_K__c, LastModifiedBy.Name, Financial_Year__c, BigOblixProductCategory__c, Name, SmallProductCategory__c, OblixBrand__c, OblixBrand__r.Name, Marketing_Agency__c, LastModifiedDate, CreatedDate, SOW_Status__c  from Marketing_SOW__c ';
        runQuery();
    }

    /**
     * Description : This method is used to construct values of a filter for : Small Category
     * @param  l lstof Brands
     */
    public List<SelectOption> getSmallCategory() {
        Map<Id, String> MapSmallCatIdToName = new Map<Id, String>();
        if (!lstMarkCategoriesFilter.isEmpty()) {
            for (Marketing_SOW__c mark : lstMarkCategoriesFilter) {
                if (mark.SmallProductCategory__c != null) {
                    if (!MapSmallCatIdToName.containsKey(mark.SmallProductCategory__c)){
                        MapSmallCatIdToName.put(mark.SmallProductCategory__c, mark.SmallProductCategory__r.Name);   
                    }
                }
            }
        }
        System.debug('###MapSmallCatIdToName : ' + MapSmallCatIdToName);
        List<SelectOption> options = new List<SelectOption>();
        if (!MapSmallCatIdToName.keySet().isEmpty()) {
            for (Id sowCat : MapSmallCatIdToName.keySet()) {
                if (MapSmallCatIdToName.get(sowCat) != null) {
                    options.add(new SelectOption(sowCat, MapSmallCatIdToName.get(sowCat)));
                }
            }
        }
        return Oblix_Utils.setFirstValue('-Small Category-', Oblix_Utils.selectOptionSortByLabel(options));

    }

    /**
     * Description : This method is used to construct values of a filter for : Big Category
     * @param  l lstof Brands
     */
    public List<SelectOption> getBigCategory() {
        Map<Id, String> MapBigCatIdToName = new Map<Id, String>();
        if (!lstMarkCategoriesFilter.isEmpty()) {
            for (Marketing_SOW__c mark : lstMarkCategoriesFilter) {
                if (mark.BigOblixProductCategory__c != null) {
                    if (!MapBigCatIdToName.containsKey(mark.BigOblixProductCategory__c)){
                        MapBigCatIdToName.put(mark.BigOblixProductCategory__c, mark.BigOblixProductCategory__r.Name);
                    }
                }
            }
        }
        List<SelectOption> options = new List<SelectOption>();
        if (!MapBigCatIdToName.keySet().isEmpty()) {
            for (Id sowCat : MapBigCatIdToName.keySet()) {
                if (MapBigCatIdToName.get(sowCat) != null) {
                    options.add(new SelectOption(sowCat, MapBigCatIdToName.get(sowCat)));
                }
            }
        }
        return Oblix_Utils.setFirstValue('-Big Category-', Oblix_Utils.selectOptionSortByLabel(options));

    }
    /**
     * Description : This method is used to construct values of a filter for : BRAND
     * @param  l lstof Brands
     */

    //loop through Ids and for each id we have the name : map constructed
    public List<SelectOption> getBrandItems() {
        Map<Id, String> MapBrandIdToName = new Map<Id, String>();
        if (!lstMarkCategoriesFilter.isEmpty()) {
            for (Marketing_SOW__c mark : lstMarkCategoriesFilter) {
                if (mark.OblixBrand__c != null) {
                    if (!MapBrandIdToName.containsKey(mark.OblixBrand__c)) MapBrandIdToName.put(mark.OblixBrand__c, mark.OblixBrand__r.Name);
                }
            }
        }
        List<SelectOption> options = new List<SelectOption>();
        if (!MapBrandIdToName.keySet().isEmpty()) {
            for (Id sowCat : MapBrandIdToName.keySet()) {
                if (MapBrandIdToName.get(sowCat) != null) {
                    options.add(new SelectOption(sowCat, MapBrandIdToName.get(sowCat)));
                }
            }
        }
        return Oblix_Utils.setFirstValue('-Brand-', Oblix_Utils.selectOptionSortByLabel(options));
    }

    /**
     * Description : This method is used to construct values of a filter for : Financial Year
     * @param  l lstof SOW
     */
    public List<SelectOption> getFinancialYear() {

        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Marketing_SOW__c.Financial_Year__c.getDescribe();
        List<Schema.PicklistEntry> plentries = fieldResult.getPicklistValues();
        for ( Schema.PicklistEntry f : plentries) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return Oblix_Utils.setFirstValue('-Financial Year-', Oblix_Utils.selectOptionSortByLabel(options));
    }

    /**
    * Build the Where part of the query as string.
    * @return [the Where part of the query as string]
    */
    private List<String> buildQueryWhere() {
        List<String> lstQueryWhere = new List<String>();

        system.debug('###selectedBrand : ' + selectedBrand);
        String strToAdd = esc(selectedBrand);
        if (strToAdd != null && strToAdd != '') {
            lstQueryWhere.add('OblixBrand__c = \'' + strToAdd + '\'');
        }
        system.debug('###selectedFYear: ' + selectedFYear);
        strToAdd = esc(selectedFYear);
        if (strToAdd != null && strToAdd != '') {
            lstQueryWhere.add('Financial_Year__c = \'' + strToAdd + '\'');
        }
        system.debug('###selectedSmallCat: ' + selectedSmallCat);
        strToAdd = esc(selectedSmallCat);
        if (strToAdd != null && strToAdd != '') {
            lstQueryWhere.add('SmallProductCategory__c = \'' + strToAdd + '\'');
        }
        system.debug('###selectedBigCat: ' + selectedBigCat);
        strToAdd = esc(selectedBigCat);
        if (strToAdd != null && strToAdd != '') {
            lstQueryWhere.add('BigOblixProductCategory__c = \'' + strToAdd + '\'');
        }


        return lstQueryWhere;
    }

    /**
    *   When user clicks on Show All:
    *   @return [Rerender table with filtered results.]
    */
    public void clearFilters(){

        selectedSmallCat = '';
        selectedBigCat = '';
        selectedBrand = '';
        selectedFYear = '';

        applyFilters();
    }

    /**
    * When user clicked on Apply Filters:
    * @return [Rerender table with filtered results.]
    */
    public void applyFilters() {

        WhereQuery = 'Select Id, Agency_Contact__c,Oblix_AgencyEstimate__r.name , OblixTotalOtherItemsFees__c, Oblix_AgencyEstimate__c,OblixSOWOverallTotal__c,Total_Campaigns_This_FY__c, Oblix_Current_FY_Total__c,Currency__c , Unilever_Lead__c, CreatedById, CreatedBy.Name, LastModifiedById, FINAL_APPROVED_FEE_K__c, LastModifiedBy.Name, Financial_Year__c, BigOblixProductCategory__c, Name, SmallProductCategory__c, OblixBrand__c, OblixBrand__r.Name, Marketing_Agency__c, LastModifiedDate, CreatedDate, SOW_Status__c  from Marketing_SOW__c ';
        List<String> lstQueryWhere = buildQueryWhere();
        system.debug('###Sfdc lstQueryWhere :' + lstQueryWhere );
        if (lstQueryWhere.isEmpty()) {
            thousandBlocks = new List<limitWrapper>();
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,Oblix_Constants.SELECT_ONE_FILTER));
        } else {

            for (String andQuery : lstQueryWhere) {
                WhereQuery += ' AND ( ' + andQuery + ') ';
=======
        //List<String> fields = Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main');
        List<String> fields = new List<String>{'Id', 'Name', 'Brand_Name__c', 'SmallProductCategory__r.Name', 'Agency_Name__c', 'LastModifiedDate', 'SOW_Status__c', 'Oblix_Current_FY_Total__c', 'Approved_version__c'};
        String soqlString = buildSOQLquery(fields, 'Marketing_SOW__c', null, null, 'LastModifiedDate DESC', null);
        
        for(List<Marketing_SOW__c> sowList: Database.query(soqlString)){
            //sowLists.add(sowList);
            List<SOWWrapper> sowWrapperList = new List<SOWWrapper>();
            for(Marketing_SOW__c sow : sowList){
                SOWWrapper w = new SOWWrapper(sow, Oblix_PermissionHandler.canSeeFinancialField(sow.SOW_Status__c, sow.Approved_version__c), Oblix_Utils.toLocaleDate(sow.LastModifiedDate));
                sowWrapperList.add(w);
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
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
            System.debug('###lstMarketingSowTmp :' + lstMarketingSowTmp);
            getthousandBlocks(lstMarketingSowTmp);
            System.debug('###thousandBlocks :' + thousandBlocks);

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops, Error occured during query run!'));
        }

    }
    /**
    * Method used to avoid Limit of Thousand Record by Repeat component
    * @return [List of Records by Block of Thousand ]
    */
    public limitWrapper[] getthousandBlocks(List<Marketing_SOW__c> lstSowsMarketingLocal) {
        //declare it above
        thousandBlocks = new List<limitWrapper>();

        integer counter = 0;
        integer loopCount = 0;
        list<Marketing_SOW__c> tmpMarket = new list<Marketing_SOW__c>();
        for (Integer i = 0; i < lstSowsMarketingLocal.size(); i++) {
            if (counter < listLimit) {

                if (i != lstSowsMarketingLocal.size() - 1) {
                    tmpMarket.add(lstSowsMarketingLocal.get(i));
                    counter++;
                } else {
                    tmpMarket.add(lstSowsMarketingLocal.get(i));
                    counter++;
                    loopCount++;

<<<<<<< HEAD
                    thousandBlocks.add(new limitWrapper(tmpMarket, loopCount));
                    return thousandBlocks;
                }

            } else {
                loopCount++;
                thousandBlocks.add(new limitWrapper(tmpMarket, loopCount));
                tmpMarket = new List<Marketing_SOW__c>();
                tmpMarket.add(lstSowsMarketingLocal.get(i));
                counter = 0;
            }

        }

        if (thousandBlocks.isEmpty()) {
            loopCount++;
            thousandBlocks.add(new limitWrapper(tmpMarket, loopCount));
        }

        return thousandBlocks;
    }


    /**
     * Guard against SOQL injection
     */
    private String esc(String s) {
        return s != null ? String.escapeSingleQuotes(s) : null;
    }

    /*
    @discription : redirect to Sow
    */
    public PageReference ViewSow() {

        return new PageReference('/' + selectedSowId);
    }

    /*
    * Related Actions
    */
    public void ViewAttachements() {
        System.debug('###selSow : ' + selSow);
        if (selSow != null && selSow.Id != null) {
            lstAttachements = [Select Id, Name, Body, ParentId, Parent.Name, CreatedById, CreatedBy.Name, CreatedDate from Attachment where ParentId = : selSow.Id];
        }
    }
    public pageReference ViewAction() {
        Pagereference meNewPage = Page.Oblix_VF06_SOWView;
        meNewPage.getParameters().put('sowId', selSow.Id);
        return meNewPage;
    }
    public pageReference CreateSOWAction() {
        PageReference mypageViewSow = Page.Oblix_SOWCreate;
        return mypageViewSow;
    }
    /*
    @Description   Wrapper Class : Used to bypass the Limit of 1000 Record on a repeat
    */
    public class limitWrapper {
        public  List<Marketing_SOW__c>  lstMarketingSows {get; set;}
        public integer blockNumber {get; set;}
        public limitWrapper(List<Marketing_SOW__c> markSowRecords, integer i) {
            lstMarketingSows = markSowRecords;
            blockNumber = i;
        }

    }

    //Achraf attachement


   /*
   @Description: Used to upload Attachement
   */
    public void uploadeAttachment() {
        system.debug('==============saving name = ' + attachment.name);
        system.debug('==============saving desc = ' + attachment.description);
        system.debug('==============saving File= ' + attachment.body);

        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = selectedSewId; // the record the file is attached to
        attachment.IsPrivate = true;
        try {
            insert attachment;
            attachment= [Select Id, Name, ParentId, Parent.Name, CreatedBy.Name, CreatedDate from Attachment where Id = : attachment.Id];
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading attachment'));
            //return null;
        } finally {
            if (attachment.Id != null) {
                attachment.Body = null;
                lstAttachements.add(attachment );
                attachment = new Attachment();
            }
        }
    }
    
    
     /*
   @Description: Cancel Method
   */
    public void Cancel () {
        return;
    }


    //remove attachment
    @RemoteAction
    public static void removeAttachments(List<String> attachmentsToRemove) {
        if (!attachmentsToRemove.isEmpty()) {
            try {
                delete [SELECT Id FROM Attachment WHERE Id IN :attachmentsToRemove];
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error removing attachment'));
            }
=======
    public Oblix_SowMainController(){
        
    }

    

    public class SOWWrapper {
        public Marketing_SOW__c sow {get; set;}
        public Boolean disaplyFinancialData {get; set;}
        public String localeDate {get; set;}

        SOWWrapper(Marketing_SOW__c pSow, Boolean pDisplayFinancialData, String plocaleDate){
            sow = pSow;
            disaplyFinancialData = pDisplayFinancialData;
            localeDate = plocaleDate;
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        }
    }
}