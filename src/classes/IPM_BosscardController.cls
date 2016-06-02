/******************************************** 
*@Author:Cognizant
*@Date:October 2014
*@Description : To create a BOSSCARD 
*Referring in page ipm_Bosscard page 
* This class has been declared as Gloabl as it contains RemoteAction method.
*********************************************/
Global with sharing class IPM_BosscardController {
    //*@Description: bosscard for inserting a new bosscard
    public IPM_Bosscard__c bosscard {get; set;}
    //*@Description: listofProjectName for quering the list and display as auto suggestion.
    public set<string> listofProjectName{get; set;}
    //*@Description: isSave to understand whether the save button is clicked on the BOSSCARD
    public Boolean isSave {get; set;}
    //*@Description: selBrand to capture the selected Brand on the BOSSCARD screen
    public String selBrand {get; set;}
    //*@Description: selBrandPos to capture the selected Brand positioning on the BOSSCARD screen
    public String selBrandPos {get; set;}
    //*@Description: selCat to capture the selected Category on the BOSSCARD screen
    public String selCat {get; set;}
    //*@Description: isAccept to understand whether the BOSSCARD is accepted or not
    public Boolean isAccept {get; set;}
    //*@Description: expectedTLD to capture selected TLD on the BOSSCARD screen
    public String expectedTLD {get;set;}
    //@Description: isNameMandatory to render an error message when name is not entered.
    public Boolean isNameMandatory{get;set;}
    //@Description: bossId to capture the current bosscard ID.
    public String bossId{get;set;}
    //*@Description: bosscardId to capture the current bosscard ID.
    public String bosscardId{get;set;}
    //*@Description: pdfRecord to query the BOSSCARD details and use it in the pdf
    // public IPM_Bosscard__c pdfRecord {get; set;}
    //*@Description: IdGenerated is for rendering the Change Status button based on conditions.
    public Boolean IdGenerated{get;set;}
    //*@Description: BossCUrl_ID is used to hold the data when we click on upload image 
    public string BossCUrl_ID{get;set;}
    //*@Description: initialised is used to hold the data when we click on upload image 
    public Boolean initialised{get; set;}
    //*@Description: isContainSpecialChars to throw an error if special characters are allowed
    public Boolean isContainSpecialChars{get;set;}
    //*@Description: imgurl to store the image URL.
    public string imgurl{get;set;}
    //*@Description: Status to store the status of the BOSSCARD.
    public string Status{get; set;}
    //@Description: isEditable to identify whether the BOSSCARD can be editable or not
    public boolean isEditable{get;set;}
    //*@Description: isPL to identify whether the logged in user is PL
    public boolean isPL{get;set;}
    //*@Description: gotopage used for page navigation
    public boolean gotopage{get;set;}
    //*@Description: selectedCompany used to get the selected company from BOSSCARD Screen
    public id selectedCompany{get;set;}
    //*@Description: lstCompany stores the list of company cards associated by the logged in user.
    public list<selectoption>lstCompany{get;set;}
    //*@Description: isDuplicateBoss used to show the error message when the current entered name already exist.
    public boolean isDuplicateBoss{get;set;}
    //*@Description: REType contains the recordy type of the company card record type.
    public string REType{get;set;}
    //*@Description: CompanyType contains the company card type.
    public String CompanyType{get;set;}
    //*@Description: saveMsg shows the BOSSCARD Save message.
    public Boolean saveMsg{get;set;}
    //*@Description:check export pdf
    public Boolean exportPDFBooln{get;set;}
    //*@Description:company card mandatory
    public boolean company_Booln{get;set;}
    //*@Description:category mandatory
    public boolean category_Booln{get;set;}
    //*@Description:geo scope
    @TestVisible private string geoScope_STR{get;set;}
    //To remove duplicate string literals
    public integer bossMaxLength{get;set;}//bosscard max length
    public static final String IPM_BOSSCARDCONTROLLER_STR = IPM_BosscardController.class.getName();//get class name
    public boolean isSkipBosscard{get;set;}//checking for skip bosscard access
    public boolean isBosscardEdit{get;set;}////checking for bosscard edit access 
    public boolean isBossCSaved{get;set;}//checking for save method
    public boolean isClickToUpload{get;set;}//checking to no image uploaded
    public boolean isAddApprover{get;set;}//checking to add approver
    public string changeBossStatusCCS{get;set;}//Change status CSS
    public boolean isBosscardNameBlank{get;set;}//is bosscard name is blank
    public boolean isNoSuccessMsg{get;set;}//hide successful message
    public boolean defaultTrue{get;set;}//default true value
    /**************************************************************************************
    *@Description :Constructor to read the information from the page paramaters , 
    *To Auto suggest the names and bind the field information
    ***************************************************************************************/
    public IPM_BosscardController (ApexPages.StandardController controller){
        // call utility class to save having to do this multiple times in multiple places
        IPM_IECompatible.ieFix();
        initialise();
        
    }
    @Testvisible private void initialise(){
        isPL=false;
        company_Booln=false;
        isBossCSaved=true;
        category_Booln=false;
        isDuplicateBoss=false;
        isSkipBosscard=false;
        isBosscardEdit=false;
        isAddApprover=false;
        gotopage=true;
        defaultTrue=true;
        isNameMandatory=false;
        isClickToUpload=false;
        isBosscardNameBlank=true;
        isNoSuccessMsg=false;
        BossCUrl_ID=IPM_ConstantUtils.BLANK;
        changeBossStatusCCS=IPM_ConstantUtils.BLANK;
        bossMaxLength=integer.valueof(system.label.IPM_Bosscard_Maxlength);
        initialised=false;
        isContainSpecialChars=false;
        exportPDFBooln=false;
        geoScope_STR=IPM_ConstantUtils.BLANK;
        imgurl=System.Label.IPM_image;
        bosscardId = ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
        BossCUrl_ID=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
        if(string.isBlank(BossCUrl_ID)){
            isEditable=true;
        }
        IdGenerated=false;
        if (string.isBlank(bosscardId)){
            bosscard = new IPM_Bosscard__c();
        } 
        else{
            bossId=bosscardId ;
            bosscard = IPM_SoqlUtilities.getBosscardMap(bosscardId).get(bosscardId);
            selectedCompany=bosscard.IPM_Company_Card__c;
            selCat= bosscard.IPM_Category__c;
            selBrandPos=bosscard.IPM_Brand_Positioning__c;
            Status=Bosscard.IPM_Bosscard_Status__c;
            geoScope_STR= bosscard.IPM_Region_Shr__c;
            expectedTLD=bosscard.IPM_Target_Launch_Date__c;
            
        }
        
        
        isSave=false; 
        isAccept=false;
        getIpmuserType();
        getAllcompanycard();
        getCategory();
        getBrandPos();
        renderedConditions();
    } 
    
    
    /********************************************************************************
    *@Description :Values for Target Launch Period
    *@return:List of options.
    *********************************************************************************/
    public List<SelectOption> getListOfQuarter() {
        Date currentDate = system.today();
        Map<Integer, Integer> currQuarterMap = new Map<Integer, Integer>{1 => 1, 
            2  => 1,
            3  => 1,
            4  => 2,
            5  => 2,
            6  => 2,
            7  => 3,
            8  => 3,
            9  => 3,
            10 => 4,
            11 => 4,
            12 => 4};
        try{
            List<SelectOption> options = new List<SelectOption>();
            for(Integer eachYear=currentDate.year(); eachYear <= currentDate.year()+20;eachYear++) {
                for(Integer eachQuarter=1; eachQuarter <= 4;eachQuarter++) {
                    if(eachYear == currentDate.year() 
                       && eachQuarter<currQuarterMap.get(currentDate.month())) {
                           continue;
                       }
                       else {
                           options.add(new SelectOption(IPM_ConstantUtils.IPM_Q+eachQuarter+IPM_ConstantUtils.IPM_SPACE+eachYear,IPM_ConstantUtils.IPM_Q+eachQuarter+IPM_ConstantUtils.IPM_SPACE+eachYear));
                       }
                }
            }
            return options;
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BOSSCARDCONTROLLER_STR,IPM_ConstantUtils.IPM_BOSS_QUARTER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
            return null;
        }
    }
    
    /********************************************************************************
    *@Description :For Getting List of Brand Positionings
    *@Param: NA
    *@return:List of brand Positionings.
    *********************************************************************************/
    public List<SelectOption> getBrandPos(){
        try{
            List<Selectoption> optns=new List<Selectoption>();
            Set<Selectoption> optnBP=new Set<Selectoption>();
            List<MDO_BrandPositions__c> userBrandPos = new List<MDO_BrandPositions__c>();
            string catName=IPM_ConstantUtils.BLANK;
            set<string>UniqueBrandP=new set<string>();
            catName=selCat;
            optnBP.add(new Selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_SelectBrandPosition));
            if(String.isNotBlank(CatName) && String.isNotBlank(geoScope_STR))
            {
                String Query_STR=IPM_ConstantUtils.BLANK;
                Query_STR='SELECT brand_position_id__r.Name FROM MDO_BrandPositions__c WHERE status__c=\''+string.escapeSingleQuotes(ipm_constantutils.BRANDPOSITION_STATUS_ACTIVE) +'\' and brand_position_id__r.status__c=\''+string.escapeSingleQuotes(ipm_constantutils.BRANDPOSITION_STATUS_ACTIVE) +'\' and product_category_id__r.parent_id__r.name=\''+ string.escapeSingleQuotes(catName) +'\' ';
                if(REType.contains(IPM_ConstantUtils.COMPANY_CARD_REGIONAL)){
                   Query_STR+=' and geo_id__r.parent_L4__r.name=:geoScope_STR ';
                }
                else if(REType.contains(IPM_ConstantUtils.CC_RECORD_TYPE_LOCAL)){
                    List<String>uniqueCountryList=geoScope_STR.split(IPM_ConstantUtils.SEMICOLON); // variable used in query below NO SONAR
                    Query_STR+=' and geo_id__r.Name IN:uniqueCountryList '; 
                }
                Query_STR+=' LIMIT 1000';
                userBrandPos=database.query(Query_STR);
            }
            if(!userBrandPos.isEmpty()){
                for(MDO_BrandPositions__c u:userBrandPos){
                    if(!UniqueBrandP.Contains(u.brand_position_id__r.Name)){
                        optnBP.add(new Selectoption(u.brand_position_id__r.Name ,u.brand_position_id__r.Name));
                        UniqueBrandP.add(u.brand_position_id__r.Name);
                    }
                        
                } 
            }
            optns.addAll(optnBP);
            return optns;
        }
        catch(Exception ex) {   
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BOSSCARDCONTROLLER_STR,IPM_ConstantUtils.IPM_BOSS_BRANDPOS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
            return null;
        }
    }
    
    
    
    /********************************************************************************
    *@Description :For Getting List of Categories
    *@return:List
    *********************************************************************************/
    public List<SelectOption> getCategory(){   
        try{
            List<IPM_Company_Card__c> userCat=new List<IPM_Company_Card__c>();
            if(String.isNotBlank(selectedCompany) && selectedCompany!=null){
                userCat=[SELECT id, IPM_Managed_category__c,RecordType.Name,IPM_TxtGeographical_Scope__c FROM IPM_Company_Card__c WHERE
                         Id=:selectedCompany and IPM_Managed_category__c !=null limit 1];
                if(!userCat.isEmpty() && userCat[0].RecordType.Name!=null)
                {
                    REType=userCat[0].RecordType.Name;
                    geoScope_STR=userCat[0].IPM_TxtGeographical_Scope__c;
                }
                if(REType!=null && REType.length() > 0)
                {
                    if(REType.contains(IPM_ConstantUtils.COMPANY_CARD_GLOBAL)){
                        CompanyType=IPM_ConstantUtils.COMPANY_CARD_GLOBAL;
                        
                    }
                    else if(REType.contains(IPM_ConstantUtils.COMPANY_CARD_REGIONAL)){
                        CompanyType=IPM_ConstantUtils.COMPANY_CARD_REGIONAL;
                    }
                    else {
                        CompanyType=IPM_ConstantUtils.COMPANY_CARD_LOCAL;
                    }
                }
                
            }
            integer countCat=0;
            integer conInt=1;
            string  catName=null;
            List<Selectoption> optns=new List<Selectoption>(); 
            Set<Selectoption> cateSet=new Set<Selectoption>();          
            cateSet.add(new Selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_SelectCategory));
            if(!userCat.isEmpty()){
                String[] splitCatString = userCat[0].IPM_Managed_category__c.split(IPM_ConstantUtils.Delimiter);
                for(string catg:splitCatString){
                    cateSet.add(new Selectoption(catg,catg));
                    countCat++;
                    catName=catg;
                }   
            }
            if(countCat==conInt){
                selCat=catName;
            }
            optns.addAll(cateSet);
            return optns;
        }
        catch(Exception ex){ 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BOSSCARDCONTROLLER_STR,IPM_ConstantUtils.IPM_BOSS_CATEGORY,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
            return null;
        }
        
    }
    
    /********************************************************************************
    *@Description :For Getting List of company cards
    *@return:List
    *********************************************************************************/
    public List<SelectOption> getAllcompanycard(){
        integer countCC=0;
        string ccId=IPM_ConstantUtils.BLANK;
        integer conInt=1;
        list<IPM_Company_Card__c>bpUserCCList=new list<IPM_Company_Card__c>();
        Set<id>holdCCidSet=new Set<id>();
        lstCompany= new List<SelectOption>();
        
        lstCompany.add(new selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_SelectCompanyCard));
        List<IPM_User_Profile__c> ipmcompanycard;
        try{
            ipmcompanycard=[SELECT ID,IPM_Company_Card__c,IPM_Central_Team__c,IPM_User_Function__c,IPM_Company_Card__r.name FROM
                            IPM_User_Profile__c WHERE IPM_User__c=:userinfo.getuserid()
                            and  IPM_Company_Card__c <>null and IPM_Company_Card__r.name!=null 
                            order by IPM_Company_Card__r.name ASC LIMIT 1000]; 
            bpUserCCList=[SELECT id,Name FROM IPM_Company_Card__c WHERE IPM_Business_Partner__c=:userinfo.getuserid() Order By name ASC LIMIT 1000];
        }
        
        Catch(Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BOSSCARDCONTROLLER_STR,IPM_ConstantUtils.IPM_BOSS_COMPANYC,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
        }
        if(!ipmcompanycard.isEmpty()){
            for(IPM_User_Profile__c pro:ipmcompanycard){
                lstCompany.add(new selectoption(pro.IPM_Company_Card__c,pro.IPM_Company_Card__r.name));
                holdCCidSet.add(pro.IPM_Company_Card__c);
                countCC++;
                ccId=pro.IPM_Company_Card__c;
                if(pro.IPM_User_Function__c.equals(IPM_ConstantUtils.TEAM_PROJECT_LEADER) ||
                        pro.IPM_Central_Team__c){
                        isPL=true;
                        gotopage=true;
                }
                
            }
        }
        if(!bpUserCCList.isEmpty()){
                
            for(IPM_Company_Card__c cc:bpUserCCList){
                if(!holdCCidSet.contains(cc.id)){
                    lstCompany.add(new selectoption(cc.id,cc.name));
                    countCC++;
                    ccId=cc.id;
                    isPL=true;
                    gotopage=true;
                }
            }
        }
        //if logged in user has only one user profile
        if(countCC==conInt){
                selectedCompany=ccId;
        }
        return lstCompany;
    }  
    
    
    /********************************************************************************
    *@Description :For Saving the Bosscard
    *@return:null
    *********************************************************************************/
    public void save(){
        Boolean validBossName_Booln=false;
        Boolean validBossComp=false;
        Boolean validBossCat=false;
        Boolean isUniqueBosscard=false;
        if(bosscard.IPM_BosscardName__c!=null && Pattern.matches(IPM_ConstantUtils.IPM_BOSSCARD_PATTERN,bosscard.IPM_BosscardName__c)){
            validBossName_Booln=false;
        }else{
            validBossName_Booln=true;
        }
        if(string.isBlank(selectedCompany)){
            company_Booln=true;
            validBossComp=true;
        }else{
            company_Booln=false;
            validBossComp=false;
        }
        if(string.isBlank(selCat)){
            category_Booln=true;
            validBossCat=true;
        }
        else{
            category_Booln=false;
            validBossCat=false;
        }
        if(!validBossName_Booln && bosscard.IPM_BosscardName__c!=null){
            isUniqueBosscard=IPM_WithoutShareController.duplicateBosscardList(bosscard.Id,bosscard.IPM_BosscardName__c);
        }
        if(isUniqueBosscard){
            isDuplicateBoss=true;
        }else{
            isDuplicateBoss=false;
        }
        if(String.isNotBlank(bosscard.IPM_BosscardName__c) || bosscard.IPM_BosscardName__c!=null){
            isNameMandatory=false;    
        }
        //If project name is null show warning message
        if(String.isBlank(bosscard.IPM_BosscardName__c) || bosscard.IPM_BosscardName__c==null){
            isNameMandatory=true;
            isDuplicateBoss=false;
            isContainSpecialChars=false;             
        }
        else if(validBossName_Booln) {
            isNameMandatory=false;
            isDuplicateBoss=false;
            isContainSpecialChars=true;
        }
        else if(isUniqueBosscard){
            isDuplicateBoss=true;
        }
        else if(validBossComp){
            company_Booln=true;
        }
        else if(validBossCat){
            category_Booln=true;
        }
                          
        else {
           splitSaveMethod();
         }       
    }
    
    /********************************************************************************
    *@Description :Download as PDF when Bossacard is approved
    *@return:Returns to IPM_ExportBosscardPDF page 
    *********************************************************************************/
    public pagereference PDFAfterApproved(){
        if(exportPDFBooln){
            save();
        }
        PageReference url = null;
        url = Page.IPM_ExportBosscardPDF;
        url.setRedirect(false);
        bosscardData(bosscard.Id);
        
        return url;
    }    
    
    
    
    
    
    
    /********************************************************************************
    *@Description :For Exporting Bosscard Data in PDF
    *@Param: BOSSCARD ID
    *********************************************************************************/
    public void bosscardData(Id bId){
        Apexpages.currentPage().getHeaders().put(IPM_ConstantUtils.IPM_BOSS_PDF_CONTENT, IPM_ConstantUtils.IPM_BOSS_PDF_FILENAME+Bosscard.IPM_BosscardName__c+IPM_ConstantUtils.BOSSCARD_PDF_FORMAT+system.today().format()+IPM_ConstantUtils.IPM_BOSS_PDF_FORMAT);
    }
    public void showMsg() {
        if(String.isBlank(bossId)|| bossId == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.IPM_BOSSCARDErrorMsg));
        }
    }
    
    
    
    /********************************************************************************
    *@Description :On click of Skip this method gets excuted
    *@return:On click of Cancel the control should go to a different page. 
    *********************************************************************************/
    @remoteaction
    Global static id  DeleteBosscard(string bosscardToSkip){
        IPM_Bosscard__c ipmBosscard = new IPM_Bosscard__c();
        ipmBosscard.id=bosscardToSkip;
        ipmBosscard.IPM_isBosscardSkipped__c=true;
        
        IPM_Project__c ipmProject=new IPM_Project__c();
        try {
            update ipmBosscard;
            // Insert the project.
            ipmProject.IPM_Project_Leader__c=userinfo.getuserid();
            insert ipmProject; //Need to insert only one project
            
            return ipmProject.id;
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BOSSCARDCONTROLLER_STR,IPM_ConstantUtils.IPM_BOSS_DELETEBOSSC,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);                                   
            return null;
        }
        
    } 
    
    /********************************************************************************
    *@Description :Get user type with access permission
    *@return:On click of Cancel the control should go to a different page. 
    *********************************************************************************/
    public void getIpmuserType(){
        list<IPM_Bosscard__c >lstBooslCreatedBy;
        
        if(!String.isBlank(BossCUrl_ID) || BossCUrl_ID!=null){
            try {
                lstBooslCreatedBy=[SELECT name FROM IPM_Bosscard__c WHERE id=:BossCUrl_ID and 
                                   CreatedBy.ID=:UserInfo.getUserId() LIMIT 1];
            }
            catch (Exception ex) {
                
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BOSSCARDCONTROLLER_STR,IPM_ConstantUtils.IPM_BOSS_USERTYPE,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
            }
            if(lstBooslCreatedBy.isEmpty()){
                isEditable=false;
                isPL=false;
                gotopage=false;
                
            }else{
                isEditable=true;
            }
        }
        
    } 
    
    /********************************************************************************
    *@Description :For Saving the Bosscard
    *@return:List
    *********************************************************************************/
    public void splitSaveMethod(){
        isContainSpecialChars=false;
        Integer count=0;
        if(bosscard.IPM_Assumptions__c!=null && bosscard.IPM_Assumptions__c.trim().length()>15){
            count++;
        }
        if(bosscard.IPM_Background__c!=null && bosscard.IPM_Background__c.trim().length()>15){
            count++;
        }
        if(bosscard.IPM_Constraints__c!=null && bosscard.IPM_Constraints__c.trim().length()>15){
            count++;
        }
        if(bosscard.IPM_Consumer_Need__c!=null && bosscard.IPM_Consumer_Need__c.trim().length()>15){
            count++;
        }
        if(bosscard.IPM_Deliverables__c!=null && bosscard.IPM_Deliverables__c.trim().length()>15){
            count++;
        }
        if(bosscard.IPM_Potential_Business_Opportunity__c!=null && bosscard.IPM_Potential_Business_Opportunity__c.trim().length()>15){
            count++;
        }
        if(bosscard.IPM_Resources__c!=null && bosscard.IPM_Resources__c.trim().length()>15){
            count++;
        } 
        if(bosscard.IPM_Scope__c!=null && bosscard.IPM_Scope__c.trim().length()>15){
            count++;
        }
        if(bosscard.IPM_Sustainibility__c!=null && bosscard.IPM_Sustainibility__c.trim().length()>15){
            count++;
        }
        bosscard.IPM_Filled_In_Percent__c=Math.round((Decimal.valueOf(count)/9.0)*100);
        list<IPM_Bosscard__c>Bossupdatedlst=new list<IPM_Bosscard__c>();
        Bossupdatedlst=new list<IPM_Bosscard__c>();
        isNameMandatory=false;
        isSave=true;      
        bosscard.IPM_Brand__c=selBrand;
        bosscard.IPM_Category__c=selCat;
        bosscard.IPM_Brand_Positioning__c=selBrandPos;
        bosscard.IPM_Target_Launch_Date__c=expectedTLD;
        bosscard.IPM_Is_Archived__c=false;
        bosscard.IPM_Company_Card__c=selectedCompany;
        bosscard.IPMBosscard_Span__c=CompanyType;
        bosscard.IPM_Region_Shr__c=geoScope_STR;
        
        if(String.isNotBlank(BossCUrl_ID))
        {
            bosscard.id=BossCUrl_ID;
        }
        if(String.isNotBlank(bosscard.id))
        {
            Bossupdatedlst.add(bossCard);
            try{
                update bossCard;
            }
            catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BOSSCARDCONTROLLER_STR,IPM_ConstantUtils.IPM_BOSS_SAVE,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);    
            }   
            category_Booln=false;
            company_Booln=false;
            isSave=true; 
            isAccept=false;
            saveMsg=true;
            isDuplicateBoss=false;
            if(!isNoSuccessMsg){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_Record_Insert_Success));
            }
            isNoSuccessMsg=false;
            
                  
        }
        
    }
    
    
    /********************************************************************************
    *@Description : For hidding the save message.
    *********************************************************************************/  
    public void hideSaveMsg() {
        saveMsg=false;
    }
    
    /********************************************************************************
        *@Description : For retriveing the catgeories
        *********************************************************************************/  
    public void searchprojectpahse(){
        getCategory();
        getBrandPos();
    }
    
    /********************************************************************************
    *@Description : For retriveing the Brand postioning.
    *********************************************************************************/
    public void getBrandposition(){
        getbrandPos();
    }
    /********************************************************************************
    *@Description : remove approver
    *********************************************************************************/
    public void removeApprover(){
        IPM_Bosscard__c removeApprov=new IPM_Bosscard__c();
        bosscard.IPM_Gate_Keeper__c=null;
        removeApprov.IPM_Gate_Keeper__c=bosscard.IPM_Gate_Keeper__c;
        removeApprov.id=bosscard.id;
        try{
            update removeApprov;
            isAddApprover=true;
        }
        catch(Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BOSSCARDCONTROLLER_STR,IPM_ConstantUtils.IPM_BOSS_REAMOVEAPPR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
            
        }
        
    }
    /********************************************************************************
    *@Description : remove bosscard logo
    *********************************************************************************/
    public void removeBosscardLogo(){
        IPM_Bosscard__c removeLogo=new IPM_Bosscard__c();
        bosscard.IPM_Bosscard_Logo__c=IPM_ConstantUtils.BLANK;
        bosscard.IPM_Bosscard_Logo_Id__c=IPM_ConstantUtils.BLANK;
        removeLogo.IPM_Bosscard_Logo__c=bosscard.IPM_Bosscard_Logo__c;
        removeLogo.IPM_Bosscard_Logo_Id__c=bosscard.IPM_Bosscard_Logo_Id__c;
        removeLogo.id=bosscard.id;
        try{
            update removeLogo;
            isClickToUpload=true;
        }
        catch(Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BOSSCARDCONTROLLER_STR,IPM_ConstantUtils.IPM_BOSS_REMOVELOGO,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
            
        }
        
    }
    /********************************************************************************
    *@Description : cancel bosscard
    *********************************************************************************/
    public pagereference cancelBosscard(){
        PageReference pg = Page.IPM_HomePage;
        if(bosscard.IPM_IsSaved__c){
            return pg;
        }
        else{
            try{
                delete bosscard;
                return pg;
            }
            catch(Exception ex) {
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BOSSCARDCONTROLLER_STR,IPM_ConstantUtils.IPM_BOSS_CANCEL,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
                return pg;
            }
        }
    }
    /********************************************************************************
    *@Description :check rendered conditions
    *@Param: NA
    *@return:Void.
    *********************************************************************************/
    
    public void renderedConditions(){
        if(bosscard.IPM_Bosscard_Status__c.equals(IPM_ConstantUtils.IPM_BOSS_INPROGRESS) && isEditable && isPL){
            isSkipBosscard=true;
        }
        if(bosscard.IPM_Is_Accepted__c || bosscard.IPM_Bosscard_Status__c.equals(IPM_ConstantUtils.IPM_BOSS_NOT_APPROVED) || !isEditable){
            isBosscardEdit=true;
        }
        if(bosscard.IPM_Bosscard_Logo_Id__c==null){
            isClickToUpload=true;
        }
        if(isEditable && bosscard.IPM_Gate_Keeper__c==null){
            isAddApprover=true; 
        }
        if(bosscard.IPM_Bosscard_Status__c.equals(IPM_ConstantUtils.IPM_BOSS_DISCARD)){
            changeBossStatusCCS=IPM_ConstantUtils.IPM_BOSS_CSS_STOPPED;
        }
        if(bosscard.IPM_Bosscard_Status__c.equals(IPM_ConstantUtils.IPM_BOSS_INPROGRESS) || bosscard.IPM_Bosscard_Status__c.equals(IPM_ConstantUtils.IPM_BOSS_NOT_APPROVED)){
            changeBossStatusCCS=IPM_ConstantUtils.IPM_BOSS_CSS_STATUS;
        }
        if(bosscard.IPM_Bosscard_Status__c.equals(IPM_ConstantUtils.IPM_BOSS_APPROVED)){
            changeBossStatusCCS=IPM_ConstantUtils.IPM_BOSS_CSS_COMPLETED;
        }
        
    }
    
    /********************************************************************************
    *@Description :check duplicate bosscard name
    *@Param: NA
    *@return:Void.
    *********************************************************************************/
    
    public void searchDuplicateBosscard(){
        listofprojectname=new set<String>();
        listofprojectname=IPM_WithoutShareController.allBosscardList(bosscardId,bosscard.IPM_BosscardName__c);
        if(listofprojectname.isEmpty()){
                isBosscardNameBlank=true;
        }
        else{
        isBosscardNameBlank = false;
        }
        
    }
    /********************************************************************************
    *@Description :hide bosscard suggetion names
    *@Param: NA
    *@return:Void.
    *********************************************************************************/
    public void hideBosscardSuggetion(){
        isBosscardNameBlank=true;
    }
}