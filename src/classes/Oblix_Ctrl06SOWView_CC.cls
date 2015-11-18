/**
    About
    -----
    Description: Class Oblix_Ctrl05SOWDetails_CC
    Created for: OBLIX Project
    Create date: 10/ 2015
    Created by Asmae ESSBAI
    Author : @Asmae
    Details
    -------

       Update History
    --------------
*/
public with sharing class Oblix_Ctrl06SOWView_CC {

    public Marketing_SOW__c selSow {get; set;}
    public id sowId {get; set;}
    public id projectId {get; set;}
    public List<Attachment> lstAttachements {get; set;}
    public List<Attachment> lstAttachementsToAdd {get; set;}
    public List<Attachment> AttachementToAdd {get; set;}
    public Attachment myDoc {get; set;}
    public list<note> notes {get; set;}
    //Projects to the Sow
    public List<Oblix_SOW_Projects__c> lstProjects {get; set;}
    // Ids of SOW projects
    // private set<id> setIdsProject;
    public string IdsProject {get; set;}
    public list<Oblix_Project_Assets__c> lstAssets {get; set;}
    public boolean isEdit {get; set;}
    public User userConnected {get; set;}
    public Oblix_SOW_Projects__c pr {get; set;}
    public string PrStatus {get; set;}
    public string PrStage {get; set;}
    public set<string> setRecordType  {get; set;}
    public Oblix_SOW_Projects__c SelectedProject {get; set;}
    public boolean isViewProject {get; set;}
    public List<Marketing_Basics__c> lstOtherItems  {get; set;}
    public string seriesProject {get; set;}
    public map<id, integer> mapApproved {get; set;}
    public List<CampaignNonCampaignItems> lstCampaignNonCampaign {get; set;}
    public note noteAsset {get; set;}

    //Thousand Block Part :
    public  limitWrapper[] thousandBlocks {get; set;}
    private final integer listLimit;
    public String selectedProjectId {get; set;}
    public Integer countOfUpdatesFeed {get; set;}
    public List<SelectOption> filesCountList {get; set;}
    //Selected count
    public String FileCount {get; set;}

    public List<Attachment> allFileList {get; set;}

    private static final Integer notesSize = 255;
    //achraf
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        } set;
    }



    public Oblix_Ctrl06SOWView_CC() {
        listLimit = 999;
        notes = new list<note>();
        noteAsset = new note();
        thousandBlocks = new List<limitWrapper>();
        lstProjects = new List<Oblix_SOW_Projects__c>();
        lstAttachements = new List<Attachment>();
        lstAttachementsToAdd = new List<Attachment>();
        myDoc = new Attachment();
        seriesProject = '';
        mapApproved = new map<id, integer>();
        if (projectId == null) SelectedProject = new Oblix_SOW_Projects__c();
        pr = new Oblix_SOW_Projects__c ();
        isEdit = false;
        //Initialize
        filesCountList = new List<SelectOption>() ;
        FileCount = '' ;
        allFileList = new List<Attachment>() ;

        //Adding values count list - you can change this according to your need
        for (Integer i = 1 ; i < 11 ; i++) {
            filesCountList.add(new SelectOption('' + i , '' + i)) ;
        }

        lstCampaignNonCampaign  = new List<CampaignNonCampaignItems>();
        init();
    }

    public void init() {

        Id idUser = UserInfo.getUserId();
        userConnected = [Select Name from User where Id = : idUser ];
        sowId = ApexPAges.currentPage().getParameters().get('sowId');
        projectId = ApexPAges.currentPage().getParameters().get('projectId');
        if (sowId == null) {
            selSow = new Marketing_SOW__c ();
        } else {
            selSow = [Select Id, Agency_Contact__r.name, Oblix_AgencyEstimate__c, Oblix_AgencyEstimate__r.name, OblixSOWOverallTotal__c, Unilever_Lead__r.name, CreatedById, CreatedBy.Name, Currency__c,
                      BigOblixProductCategory__r.Name, OblixBrand__r.Name, SmallProductCategory__r.Name,
                      LastModifiedById, FINAL_APPROVED_FEE_K__c, LastModifiedBy.Name, Financial_Year__c, BigOblixProductCategory__c,
                      Name, SmallProductCategory__c, OblixBrand__c, Marketing_Agency__c, LastModifiedDate, CreatedDate,
                      SOW_Status__c, BB_or_BD__c   from Marketing_SOW__c where Id = : sowId
                     ];
        }
        System.debug('###selSow : ' + selSow);
        if (projectId == null) SelectedProject = new Oblix_SOW_Projects__c();
        else
            SelectedProject = [Select Id, Name, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, OblixCountries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = :projectId];

        if (selSow != null && selSow.Id != null) {
            list<Marketing_SOW__c> childSow = new list<Marketing_SOW__c>();
            System.debug('###selSow.id : ' + selSow.id);
            childSow = [select id, OblixSOWOverallTotal__c from Marketing_SOW__c where MarketingSOWParent__c = :selSow.id  and Type_of_SOW__c = 'Baseline'  ];
            System.debug('###childSow : ' + childSow );
            if (childSow.size() > 0) {
                mapApproved.put(selSow.id, (integer)childSow[0].OblixSOWOverallTotal__c);
            } else {
                mapApproved.put(selSow.id, 0);
            }
            countOfUpdatesFeed = NumberOfSowChatterFeedItem(selSow.Id);
            lstAttachements = [Select Id, Name, ParentId, Parent.Name, CreatedBy.Name, CreatedDate from Attachment where ParentId = : selSow.Id];
            lstProjects = [Select Id, Name, Project_Finish_Date__c, Campaign_Status__c, Platform__c, Project_Stage__c, CreatedById, Total_Fees_for_Project__c, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, OblixCountries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where Financial_Year__c = : selSow.Id];
            lstOtherItems = [Select  m.Role_Title__c, m.RecordTypeId, m.Other_Activities__c, m.Oblix_SOWMarketing__c, m.OblixOtherItemFee__c, m.OblixCountry__c, m.No_of_Hours_Required__c, m.Name, m.LastModifiedById, m.Id, m.Financial_Year_old__c,
                             m.Financial_Year__c, m.FTE__c, m.Description__c, m.CreatedDate, m.CreatedById, m.Agency__c, m.Agency_Department__c, m.Activities__c From Marketing_Basics__c m
                             where Oblix_SOWMarketing__c = : selSow.Id]; // m.Discipline__c,
            notes = [ select body from note where parentId = :selSow.Id];
            if (!lstProjects.isEmpty()) {
                String campaign = 'Campaign';
                for (Oblix_SOW_Projects__c  project : lstProjects) {
                    CampaignNonCampaignItems dynamicInstance = new CampaignNonCampaignItems();
                    dynamicInstance.objName = campaign ;
                    dynamicInstance.objectDyn = (Oblix_SOW_Projects__c)project ;
                    lstCampaignNonCampaign.add(dynamicInstance);
                }
            }
            if (!lstOtherItems.isEmpty()) {
                String nonCampaign = 'Non Campaign';
                for (Marketing_Basics__c otherItem : lstOtherItems ) {
                    CampaignNonCampaignItems dynamicInstance = new CampaignNonCampaignItems();
                    dynamicInstance.objName = nonCampaign ;
                    dynamicInstance.objectDyn = (Marketing_Basics__c )otherItem ;
                    lstCampaignNonCampaign.add(dynamicInstance);
                }
            }
            string seriesbis = '';
            date d_projStart, d_prodCompletion, d_projEnd, d_firstAir, d_projCompletion ;
            string series = '';
            //date d1,d2;
            if (lstProjects.size() > 0)

                for (Oblix_SOW_Projects__c  pr : lstProjects) {

                    if (pr.Project_Start_Date__c != null) d_projStart = pr.Project_Start_Date__c.addMonths(-1);
                    else d_projStart  = date.newInstance(2015, 1, 1);
                    if (pr.Project_Finish_Date__c != null ) d_projEnd = pr.Project_Finish_Date__c.addMonths(-1);
                    else d_projEnd = date.newInstance(2015, 1, 1);

                    if (pr.Production_Completion_Date__c != null)d_prodCompletion = pr.Production_Completion_Date__c.addMonths(-1);
                    else d_prodCompletion = date.newInstance(2015, 1, 1);
                    if (pr.First_Air_Date__c != null) d_firstAir = pr.First_Air_Date__c.addMonths(-1);
                    else d_firstAir = date.newInstance(2015, 1, 1);
                    if (pr.Project_Completion_Date__c != null) d_projCompletion = pr.Project_Completion_Date__c.addMonths(-1);
                    else d_projCompletion = date.newInstance(2015, 1, 1);
                    String dateutc = 'Date.UTC(' ;
                    series = series + '{' +
                             '"unitName"' + ':"' + pr.name + '",' +
                             '"beginTimestamp"' + ':' + dateutc + d_projStart.year() + ',' + d_projStart.month() + ',' + d_projStart.day() + '),' +
                             '"x1Timestamp"' + ':' + dateutc + d_projCompletion.year() + ',' + d_projCompletion.month() + ',' + d_projCompletion.day() + '),' +
                             '"x2Timestamp"' + ':' + dateutc + d_firstAir.year() + ',' + d_firstAir.month() + ',' + d_firstAir.day() + '),' +
                             '"x3Timestamp"' + ':' + dateutc + d_prodCompletion.year() + ',' + d_prodCompletion.month() + ',' + d_prodCompletion.day() + '),' +
                             '"endTimestamp"' + ':' + dateutc + d_projEnd.year() + ',' + d_projEnd.month() + ',' + d_projEnd.day() + ')' +
                             +'}' + ',' ;
                }
            seriesProject = '[' + series.removeEnd(',') + ']';

        }
        if (!lstCampaignNonCampaign.isEmpty()) {
            getthousandBlocks(lstCampaignNonCampaign);

        }

    }

    public pageReference backAction() {
        return new pageReference('/apex/Oblix_VF05_SOWDetailsV');
    }
    public pageReference CreateProjectAction() {
        return new pageReference('/apex/Oblix_VF07_ProjectNew?projectId=' + projectId);
    }
    public pageReference SaveProjectAction() {
        return new pageReference('/apex/Oblix_VF06_SOWView?id=' + sowId);
    }
    public void EditAction() {
        isEdit = true;
    }

    /* Method used to save a New SOW
     * @return [Rerender the form]
     */
    public void SaveSOW() {
        string errorRequired = '';
        try {

            if (selSow.Name == null || selSow.Name == '') {
                errorRequired += ' Name';
            }
            if (selSow.BB_or_BD__c == null || selSow.BB_or_BD__c == '') {
                errorRequired = (errorRequired != '' ?  errorRequired + ', ' : '') + 'BB/BD';
                // errorRequired += (errorRequired.contains('Name') ? errorRequired+', ' : 'The following fields are required : ') + 'BB/BD';
            }
            if (selSow.Financial_Year__c == null || selSow.Financial_Year__c == '') {
                errorRequired = (errorRequired != '' ?  errorRequired + ', ' : '') + 'Financial Year';
                //errorRequired = ((errorRequired.contains('Name') || errorRequired.contains('BB')) ? errorRequired+', ' : 'The following fields are required : ') + 'Financial Year';
            }
            if (errorRequired != '') {
                errorRequired = 'The following fields are required : ' + errorRequired;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, errorRequired));
            } else {
                if (selSow != null && selSow.Id == null) {
                    insert selSow;
                    selSow = [Select Id, Agency_Contact__r.name, Oblix_AgencyEstimate__c, Oblix_AgencyEstimate__r.name, OblixSOWOverallTotal__c, Unilever_Lead__r.name, CreatedById, CreatedBy.Name, Currency__c,
                              BigOblixProductCategory__r.Name, OblixBrand__r.Name, SmallProductCategory__r.Name,
                              LastModifiedById, FINAL_APPROVED_FEE_K__c, LastModifiedBy.Name, Financial_Year__c, BigOblixProductCategory__c,
                              Name, SmallProductCategory__c, OblixBrand__c, Marketing_Agency__c, LastModifiedDate, CreatedDate,
                              SOW_Status__c, BB_or_BD__c   from Marketing_SOW__c where Id = : selSow.Id
                             ];
                     
                } else {
                    update selSow;
                    sowId = selSow.Id;
                    selSow = [Select Id, Agency_Contact__r.name, Oblix_AgencyEstimate__c, Oblix_AgencyEstimate__r.name, OblixSOWOverallTotal__c, Unilever_Lead__r.name, CreatedById, CreatedBy.Name, Currency__c,
                              BigOblixProductCategory__r.Name, OblixBrand__r.Name, SmallProductCategory__r.Name,
                              LastModifiedById, FINAL_APPROVED_FEE_K__c, LastModifiedBy.Name, Financial_Year__c, BigOblixProductCategory__c,
                              Name, SmallProductCategory__c, OblixBrand__c, Marketing_Agency__c, LastModifiedDate, CreatedDate,
                              SOW_Status__c, BB_or_BD__c   from Marketing_SOW__c where Id = : selSow.Id
                             ];
                }
                sowId = selSow.Id;
                list<Marketing_SOW__c> childSow = new list<Marketing_SOW__c>();
                        System.debug('###selSow.id : ' + selSow.id);
                        childSow = [select id, OblixSOWOverallTotal__c from Marketing_SOW__c where MarketingSOWParent__c = :selSow.id  and Type_of_SOW__c = 'Baseline'];
                        System.debug('###childSow : ' + childSow );
                        if (childSow.size() > 0) {
                            mapApproved.put(selSow.id, (integer)childSow[0].OblixSOWOverallTotal__c);
                        } else {
                            mapApproved.put(selSow.id, 0);
                        }
                if (!LstAttachementsToAdd.isEmpty()) {
                    for (Attachment att : lstAttachementsToAdd) {
                        att.parentId = selSow.id;
                    }
                    insert lstAttachementsToAdd;
                }
                System.debug('###NoteBody size: ' + String.valueOf(noteAsset.body.length()));
                if (noteAsset.body != null && noteAsset.id == null && noteAsset.body.length() <= notesSize) {
                    noteAsset.parentId =  selSow.id;
                    noteAsset.title = 'NoteII';
                    noteAsset.isPrivate = false;
                    insert noteAsset;
                    noteAsset = [select body from note where id = :noteAsset.id];
                    notes.add(noteAsset);
                    noteAsset = new note();
                } else if (noteAsset.body != null && noteAsset.id == null) {
                    throw new Oblix_Utils.CustomException('TOO_LONG_NOTE');
                }
                
            }
        } catch (Exception le) {

            if (le.getMessage().contains('DUPLICATE_VALUE')) {
                errorRequired += 'Duplicate Value Found with the same Name';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, errorRequired));
            }
            if (le.getMessage().contains('TOO_LONG_NOTE')) {
                errorRequired += 'Your note is too long. Max length is 255 characters.';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, errorRequired));
            }

            System.debug('The following exception has occurred: ' + le.getMessage());
        }
        isEdit = false;
    }



    private Integer NumberOfSowChatterFeedItem(Id sowFeedId) {
        Integer rows = [select count() from Marketing_SOW__Feed where ParentId = : sowFeedId ];
        return rows ;

    }



    /* Method used to redirect to the Selected Marketing sow View
     * @return [Redirection to the selected MS]
     */
    public PageReference msDetail() {
        PageReference  page = new PageReference('/apex/Oblix_VF10_nonCampaignView?MSid=' + selSow.id );
        page.setRedirect(True);
        return page;
    }

    /* Method used toupload the attachement
     * @return void
     */

    public void uploadeAttachment() {
        system.debug('==============saving name = ' + attachment.name);
        system.debug('==============saving desc = ' + attachment.description);
        system.debug('==============saving File= ' + attachment.body);

        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = selSow.id; // the record the file is attached to
        attachment.IsPrivate = true;
        try {
            insert attachment;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));

        } catch (DMLException e) {
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
    public void Cancel () {
        return;
    }


    /* Method used to redirect to the Selected Project View
     * @return [Redirection to the Project View Page]
     */
    public PageReference ViewProject() {

        PageReference page ;
        List<Marketing_Basics__c > x = [select id from Marketing_Basics__c where id = :selectedProjectId limit 1]  ;
        if ( x.isempty() )  {
            page  = new PageReference('/apex/Oblix_VF07_ProjectView?projectId=' + selectedProjectId);
        } else return null;


        page.setRedirect(True);
        return page;
    }
    /* Non campaign Added by Achraf */
    public PageReference createNonCamp() {
        PageReference ref = new PageReference('/apex/Oblix_VF09_nonCampaignEdit' + '?MSid=' + sowId); // id de Marketing_SOW__c au quel seront ajouté les new Marketing_Basics__c  records
        ref.setRedirect(true);
        return ref;
    }

    /* Method used to redirect to the Selected Project View
    * @return [Redirection to the Project View Page]
    */
    public PageReference AddProject() {
        return new PageReference('/apex/Oblix_VF08_ProjectEdit?sowId=' + selSow.Id);
    }

    //List of Projects Part
    /**************************************************************/
    /**
    * Method used to avoid Limit of Thousand Record by Repeat component
    * @return [List of Records by Block of Thousand ]
    */
    public limitWrapper[] getthousandBlocks(List<CampaignNonCampaignItems> lstCampaignNonCampaign) {
        //declare it above
        thousandBlocks = new List<limitWrapper>();

        integer counter = 0;
        integer loopCount = 0;
        list<CampaignNonCampaignItems> tmpProject = new list<CampaignNonCampaignItems>();
        for (Integer i = 0; i < lstCampaignNonCampaign.size(); i++) {
            if (counter < listLimit) {

                if (i != lstCampaignNonCampaign.size() - 1) {
                    tmpProject.add(lstCampaignNonCampaign.get(i));
                    counter++;
                } else {
                    tmpProject.add(lstCampaignNonCampaign.get(i));
                    counter++;
                    loopCount++;

                    thousandBlocks.add(new limitWrapper(tmpProject, loopCount));
                    return thousandBlocks;
                }

            } else {
                loopCount++;
                thousandBlocks.add(new limitWrapper(tmpProject, loopCount));
                tmpProject = new List<CampaignNonCampaignItems>();
                tmpProject.add(lstCampaignNonCampaign.get(i));
                counter = 0;
            }

        }

        if (thousandBlocks.size() == 0) {
            loopCount++;
            thousandBlocks.add(new limitWrapper(tmpProject, loopCount));
        }

        return thousandBlocks;
    }

    public PageReference uploadAttachment() {
        lstAttachementsToAdd.add(myDoc);
        return null;
    }

    /*
    *   Wrapper Class : Used to bypass the Limit of 1000 Record on a repeat
    */
    public class limitWrapper {
        public  List<CampaignNonCampaignItems>  lstProjects {get; set;}
        public integer blockNumber {get; set;}
        public limitWrapper(List<CampaignNonCampaignItems> projectRecords, integer i) {
            lstProjects = projectRecords;
            blockNumber = i;
        }

    }

    /* Add Attachment popup
    */
    public Pagereference SaveAttachments() {

        //Attachment a = new Attachment(parentId = accid, name=myfile.name, body = myfile.body);
        for (Attachment a : allFileList) {
            if (a.name != '' && a.name != '' && a.body != null)
                lstAttachementsToAdd.add(new Attachment(name = a.name, body = a.body)) ;
        }

        return null;
    }

    public PageReference ChangeCount() {
        allFileList.clear() ;
        //Adding multiple attachments instance
        for (Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)
            allFileList.add(new Attachment()) ;
        return null ;
    }
    /* Inner Class Used to have list of Campaign and non Campaign in the same list
     */

    public Class CampaignNonCampaignItems {
        public SObject objectDyn {get; set;}
        public String objName {get; set;}

        public CampaignNonCampaignItems() {
            this.objName = objName;
            this.objectDyn = objectDyn ;
        }
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
        }
    }
}