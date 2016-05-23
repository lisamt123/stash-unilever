/**********************************************************************
Name:  CEC_CaseInlineController()
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the controller class for CEC_CaseInline Vf page                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0       Koti           Jan-2015      INITIAL DEVELOPMENT   

************************************************************************/


global with sharing class CEC_CaseInlineController{
    
    /* Case object */
    public case caseRecord {get; set;}
    
    /* Reason Id */
    public String reasonId {get; set;}
    
    /* Old Reason Id Value - To maintain state between old and new Reason id */
    public String oldReasonId {get;set;}
    
    /* Reason name */
    public String reasonName {get; set;}
    
    /* Product Id */
    public String productId {get; set;}
    
    /* Old Product Id - To maintain state between old and new product id */
    public String oldProductId {get; set;}
    
    /* Product name */
    public String productName {get; set;}
    
    /* Product Status */
    public String productStatus {get; set;}
    
    /* Product Last Manufacturing Date */
    public String productMFD {get; set;}
    
    public String userWarning {get; set;}
    
    /* to decide whether to display missing information section or not */
    public boolean missingInfoSectionDisplay {get; set;}    
    
    /* to maintain product category */
    public String productCategory{get; set;}
    
    /* to maintain date of manufacture */
    public String dateOfManufacture{get; set;}
    
    /* to decide whether the product category is enabled or disabled */
    public boolean isProductCategoryEnabled {get; set;}    
    
    /* reason hierarchy */
    public String reasonHierarchy {get; set;}
    
    /* product hierarchy */
    public String productHierarchy {get; set;}
    
    /* Popup Alert related variables */
    public Boolean popupAlertCheck {get;set;}
    public String popupAlertMsg {get;set;}
    
    /* Popup Questionnaire related variables */
    public Boolean questionnaireAlertCheck {get;set;}
    
    /*Variable to display Country and Verbetim message if account is populated*/
    public Boolean isEmptyCountryVerbatimCheck {get;set;}
    
    /*  Related Issues */
    public List<RelatedIssue> relatedIssues {get; set;}
    public List<RelatedIssue> fiveRelatedIssues {get; set;}
    public Boolean displayMore{get;set;}
    
    /* List to maintain matching Product knowledge articles*/
    public List<cec_Product_Information__kav> matchingProductArticlesList {get; set;}
    
    /* List to maintain matching Product knowledge articles for TO*/
    public List<TO_Product_Information__kav> matchingTOProductArticlesList {get; set;}
    
    /* List to maintain matching Reason knowledge articles*/
    public List<cec_Reason_Information__kav> matchingReasonArticlesList {get; set;}
    
    /* List to maintain matching Reason knowledge articles*/
    public List<KnowledgeArticleWrapper> knowledgeWrapperList {get; set;}
    
    /* Inner class */
    /* This class is a wrapper class for the knowledge articles */
    public class KnowledgeArticleWrapper{
        
        /* article id*/
        public String articleId{ get; set; }
        
        public String knowledgeArticleId{ get; set; }
        
        /* Reference to reason article */
        public cec_Reason_Information__kav reasonArticle{ get; set; }
        
        /* Reference to product article */
        public cec_Product_Information__kav productArticle{ get; set; }
        
        /* Reference to product article */
        public TO_Product_Information__kav TOProductArticle{ get; set; }
        
        /* flag to indicate whether article is selected */
        public boolean isSelected{ get; set; }
        
        /* article type */
        public String articleType{ get; set; }
        
        /* article subject */
        public String subject{ get; set; }
        
        /* constructor */
        public KnowledgeArticleWrapper(){}
        
    }
    
    /* Selected Article */
    public String selectedArticleId {get;set;}
    
    public String selectedCountryCode {get;set;}
    
    /* constructor */
    public CEC_CaseInlineController(ApexPages.StandardController controller) {
        
        caseRecord = (case) controller.getRecord();
        if (caseRecord.Id != null) {
            /* caseRecord = [Select Id, CaseNumber,Reason_Code__c,Parent.CaseNumber,ParentId, Reason_Code__r.Name,Status, CEC_Product__c, CEC_Product__r.Name,CEC_Product__r.Global_CPG_Code__c,
isFormKnown__c, isVariantKnown__c, isPacksizeKnown__c,Case_product_category__c, Production_Code__c, DayCode__c,CEC_Product__r.Global_CPG_Code__r.L2_Product_Category__c,
Date_of_Manufacture_str__c,Subject,Description,Market__c From case Where Id = :caseRecord.Id];*/
            
            caseRecord = [Select Id, CaseNumber,Reason_Code__c,Parent.CaseNumber,ParentId, Reason_Code__r.Name,Status, CEC_Product__c, CEC_Product__r.Name, CEC_Product__r.Global_CPG_Code__c, CEC_Product__r.Product_Name_Other__c,
                          isFormKnown__c, isVariantKnown__c, isPacksizeKnown__c,Case_product_category__c, Production_Code__c, DayCode__c,CEC_Product__r.Global_CPG_Code__r.L2_Product_Category__c,
                          Date_of_Manufacture_str__c,Subject,Description,Market__c,Country_Name__c,Country__c,Country__r.Country__r.ISO_3166_1_Code__c,CEC_Product_Hierarchy__c,Case_Market_Tag__c, AccountId From case Where Id = :caseRecord.Id];
            
            selectedCountryCode = caseRecord.Country__r.Country__r.ISO_3166_1_Code__c;
            
            oldReasonId = reasonId = caseRecord.Reason_Code__c;
            reasonName = caseRecord.Reason_Code__r.Name;
            oldProductId = productId = caseRecord.CEC_Product__c;
            productName = caseRecord.CEC_Product__r.Product_Name_Other__c;
            
            /*-- Populate the isEmptyCountryVerbatimCheck --*/
            if(caseRecord.AccountId != null && (caseRecord.Country__c == null || String.isEmpty(caseRecord.Subject)) && caseRecord.Status != 'New'){
                isEmptyCountryVerbatimCheck = true;
            }
            else{
                isEmptyCountryVerbatimCheck = false;
            }
            /*---- On loading page to display Reason Hierarchy -----
*/
            String level1Desc = '', level2Desc = '';
            popupAlertMsg = '';
            if (reasonId != null && reasonId != ''){
                List<mdm_Reason_Code__c> rObjList = [select name from mdm_Reason_Code__c where id = :reasonId ];
                if (rObjList != null && rObjList.size() > 0 && rObjList[0].name != null){
                    reasonName = rObjList[0].name;
                }
            }
            
            if (productId != null && productId != ''){
              List<mdm_Case_Product__c> pObjList = [select name, Product_Name_Other__c, Product_Status__c, Last_Sold_Manufactured__c from mdm_Case_Product__c where id = :productId ];
                if (pObjList != null && pObjList.size() > 0 && pObjList[0].name != null){
                    productName = pObjList[0].Product_Name_Other__c;
                    productStatus = pObjList[0].Product_Status__c.toLowerCase();
                    productMFD = pObjList[0].Last_Sold_Manufactured__c ;
                }
            }
            
            if (reasonId != null && reasonId != ''){
                List<mdm_Reason_Code__c> reasonCodeObjList = [ select id, L1_Desc__c, L2_Desc__c from mdm_Reason_Code__c where Id =:  reasonId ];
                if (reasonCodeObjList != null && reasonCodeObjList.size() > 0 && reasonCodeObjList[0] != null ){
                    if (reasonCodeObjList[0].L1_Desc__c != null && reasonCodeObjList[0].L1_Desc__c != null){
                        level1Desc = reasonCodeObjList[0].L1_Desc__c;
                    }
                    if (reasonCodeObjList[0].L2_Desc__c != null && reasonCodeObjList[0].L2_Desc__c != null){
                        level2Desc = reasonCodeObjList[0].L2_Desc__c;
                    }
                    
                    reasonHierarchy = level1Desc + ' ' +  level2Desc ;
                }
                
            }
            
            /*---- On loading page to display Product Hierarchy -----
*/
            if (reasonId != null && reasonId != ''){
                mdm_Reason_Code__c rObj = [select name from mdm_Reason_Code__c where id = :reasonId ];
                if (rObj != null && rObj.name != null){
                    reasonName = rObj.name;
                }
            }
            System.debug('reasonName =' + reasonName );
            
            System.debug('productId =' + productId );
            if (productId != null && productId != ''){
                mdm_Case_Product__c pObj = [select name, Product_Name_Other__c from mdm_Case_Product__c where id = :productId ];
                System.debug('pObj =' + pObj );
                if (pObj != null && pObj.name != null){
                    productName = pObj.Product_Name_Other__c;
                }
                
                //isProductCategoryEnabled = false;
                
            }
            System.debug('productName =' + productName );
            
            
            List<mdm_Case_Product__c> productObj = [select id, Consumer_Product_Descriptor_Local_Lang__c,Global_CPG_Code__r.Corp_Prod_Grouping_Name__c,Brand__c,Consumer_Product_Descriptor_no_size__c from mdm_Case_Product__c where Id = :productId ];
            System.debug('productObj =' + productObj+'caseRecord.isFormKnown__c'+caseRecord.isFormKnown__c+'    caseRecord.isVariantKnown__c'+caseRecord.isVariantKnown__c+' caseRecord.isPacksizeKnown__c'+caseRecord.isPacksizeKnown__c);
            if (productObj.size()>0 && productObj != null && productObj[0] != null){
                
                if(!caseRecord.isFormKnown__c) { //If Form is false
                    isProductCategoryEnabled = true;
                    productHierarchy = productObj[0].Brand__c;
                    if (caseRecord.Case_product_category__c !=null && caseRecord.Case_product_category__c != ''){
                        if(productHierarchy==null){
                            productHierarchy='';
                        }
                        productHierarchy =  productHierarchy + ' ' + caseRecord.Case_product_category__c;
                        System.debug('Form PH>>>>>>>>> =' + productHierarchy );
                    }
                }
                else if(!caseRecord.isVariantKnown__c){ //if Variant is false
                    productHierarchy = productObj[0].Global_CPG_Code__r.Corp_Prod_Grouping_Name__c;
                    System.debug('Variant PH>>>>>>>>> =' + productHierarchy );
                    
                }else if(!caseRecord.isPacksizeKnown__c){ //if Pack size is false
                    productHierarchy = productObj[0].Consumer_Product_Descriptor_no_size__c;
                    System.debug('Pack size PH>>>>>>>>> =' + productHierarchy );
                    
                }else {
                    productHierarchy = productObj[0].Consumer_Product_Descriptor_Local_Lang__c;
                    System.debug('All are true PH>>>>>>>>> =' + productHierarchy);
                    
                }
            }  
            //Related Issue
            relatedIssues = new List<RelatedIssue>();
            fiveRelatedIssues = new List<RelatedIssue>();
            if (caseRecord.ParentId == null) {
                // Add this case - it is the primary
                relatedIssues.add(new RelatedIssue('Primary', caseRecord,caseRecord.Parent.CaseNumber));
                // Retrieve child cases
                for (Case cc : [Select CaseNumber,ParentId,Status,Parent.CaseNumber, Subject, CEC_Product__c,CEC_Product__r.Name,Case_product_category__c, Reason_Code__c,Reason_Code__r.Name, Description From Case Where ParentId = :caseRecord.Id order by CaseNumber]) {
                    relatedIssues.add(new RelatedIssue('Additional', cc,cc.Parent.CaseNumber));
                }
            } else {
                // Add the parent case
                Case pc = [Select CaseNumber, ParentId,Subject,Status,Parent.CaseNumber, CEC_Product__c,CEC_Product__r.Name,Case_product_category__c, Reason_Code__c,Reason_Code__r.Name, Description From Case Where Id = :caseRecord.ParentId];
                relatedIssues.add(new RelatedIssue('Primary', pc,pc.Parent.CaseNumber));
                // Then add all the children of the parent          
                for (Case cc : [Select CaseNumber, Subject,Status, ParentId,Parent.CaseNumber,CEC_Product__c,CEC_Product__r.Name,Case_product_category__c, Reason_Code__c,Reason_Code__r.Name, Description From Case Where ParentId = :caseRecord.ParentId order by CaseNumber]) {
                    relatedIssues.add(new RelatedIssue('Additional', cc,cc.Parent.CaseNumber));
                }
            }
            
            for(integer relatedCase=0;relatedCase<5 && relatedIssues.size()>relatedCase;relatedCase++){
                fiveRelatedIssues.add(relatedIssues[relatedCase]);
            }
            if(relatedIssues.size()>5){
                displayMore=true;
            } else{
                displayMore=false;
            }
            
        }
        /* making 'missing info' section hidden as default */        
        missingInfoSectionDisplay = false;
        
        isProductCategoryEnabled = false;
        
        /*---- On loading page to search and display Knowledge Articles ----- */
        knowledgeWrapperList = new List<KnowledgeArticleWrapper>();
        
        searchMatchingReasonKnowledgeArticles();
        searchMatchingProductKnowledgeArticles();
        
        
    }
    
    
    
    //RelatedCase
    public void getAllRecords(){
        fiveRelatedIssues=relatedIssues;
        displayMore=false;
    }
    
    public Boolean isCountryPopulated {get;set;}
    
    //Record type Spam
    public PageReference selectQuickcode() {
        isCountryPopulated = false;
        try{
            if(caseRecord.Country__c != null){
                isCountryPopulated = true;
                update caseRecord;
            }
        }catch(Exception e){
            System.debug('Case not updated');
        }
        return null;      
    }
    
    /**
This method toggles the display of 'Missing information' section
*/
    public void toggleMissingInfoDisplay(){
        System.debug('in toggleMissingInfoDisplay....................');
        if (missingInfoSectionDisplay){
            missingInfoSectionDisplay = false;
        }else{
            missingInfoSectionDisplay = true;
            if(!caseRecord.isFormKnown__c){
                isProductCategoryEnabled = true;
            }else{
                isProductCategoryEnabled = false;
            }
        }
        
        /*maintaining reason name on screen */   
        if (reasonId != null && reasonId != ''){
            mdm_Reason_Code__c rObj = [select name from mdm_Reason_Code__c where id = :reasonId ];
            if (rObj != null){
                reasonName = rObj.name;
            }
            
        }
        
        /*maintaining product name on screen */   
        if (productId != null && productId != ''){
            mdm_Case_Product__c pObj = [select name from mdm_Case_Product__c where id = :productId ];
            if (pObj != null && pObj.name != null){
                productName = pObj.name;
            }
            
        }
        System.debug('missingInfoSectionDisplay = ....................' + missingInfoSectionDisplay );
    }
    
    /**
This method updates the details based on check / uncheck of FORM checkbox
*/
    public void updateFormAvailabilityDetails(){
        
        if (!caseRecord.isFormKnown__c){
            isProductCategoryEnabled = true;
            
            /*if form is missing, loading product hierarchy */
            if (!caseRecord.isFormKnown__c){
                if (productId != null && productId != ''){
                    mdm_Case_Product__c productObj = [select id, Brand__c from mdm_Case_Product__c where Id = :productId ];
                    if (productObj != null && productObj.Brand__c!= null){
                        productHierarchy = productObj.Brand__c;
                    }
                    if (caseRecord.Case_product_category__c !=null && caseRecord.Case_product_category__c != ''){
                        if(productHierarchy==null){
                            productHierarchy='';
                        }
                        productHierarchy =  productHierarchy + ' ' + caseRecord.Case_product_category__c ;
                    }
                }
            } 
        }else{
            isProductCategoryEnabled = false;
            //since form is known and if the other 2 are also known
            if (caseRecord.isVariantKnown__c && caseRecord.isPacksizeKnown__c){
                isProductCategoryEnabled = false;
                if (productId != null && productId != ''){    
                    mdm_Case_Product__c productObj = [select id, Consumer_Product_Descriptor_Local_Lang__c from mdm_Case_Product__c where Id = :productId ];
                    if (productObj != null && productObj.Consumer_Product_Descriptor_Local_Lang__c != null){
                        productHierarchy = productObj.Consumer_Product_Descriptor_Local_Lang__c;
                    }
                }
            }
        }
        try{
            caseRecord.CEC_Product_Hierarchy__c = productHierarchy;
            Database.update(caseRecord);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, e.getMessage()) );
        }
    }
    
    /**
This method updates the details based on check / uncheck of VARIANT checkbox
*/
    public void updateVariantAvailabilityDetails(){
        /*if variant is missing, loading product hierarchy */
        if (!caseRecord.isVariantKnown__c){
            if (productId != null && productId != ''){ 
                mdm_Case_Product__c productObj = [select id, Global_CPG_Code__r.Corp_Prod_Grouping_Name__c from mdm_Case_Product__c where Id = :productId ];
                if (productObj != null && productObj.Global_CPG_Code__r.Corp_Prod_Grouping_Name__c != null){
                    productHierarchy = productObj.Global_CPG_Code__r.Corp_Prod_Grouping_Name__c;
                }
            }
        }else {
            //since variant is known and if the other 2 are also known
            if (caseRecord.isFormKnown__c && caseRecord.isPacksizeKnown__c){
                isProductCategoryEnabled = false;
                if (productId != null && productId != ''){ 
                    mdm_Case_Product__c productObj = [select id, Consumer_Product_Descriptor_Local_Lang__c from mdm_Case_Product__c where Id = :productId ];
                    if (productObj != null && productObj.Consumer_Product_Descriptor_Local_Lang__c != null){
                        productHierarchy = productObj.Consumer_Product_Descriptor_Local_Lang__c;
                    }
                }
            }
        }
        try{
            caseRecord.CEC_Product_Hierarchy__c = productHierarchy;
            Database.update(caseRecord);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, e.getMessage()) );
        }
    }
    
    
    /**
This method updates the details based on check / uncheck of PACK SIZE checkbox
*/
    public void updatePacksizeAvailabilityDetails(){
        if (!caseRecord.isPacksizeKnown__c){
            if (productId != null && productId != ''){ 
                mdm_Case_Product__c productObj = [select id, Consumer_Product_Descriptor_no_size__c from mdm_Case_Product__c where Id = :productId ];
                if (productObj != null && productObj.Consumer_Product_Descriptor_no_size__c!= null){
                    productHierarchy = productObj.Consumer_Product_Descriptor_no_size__c;
                }
            }
        } else {
            //since PACK SIZE is known and if the other 2 are also known
            if (caseRecord.isFormKnown__c && caseRecord.isVariantKnown__c){
                isProductCategoryEnabled = false;
                if (productId != null && productId != ''){ 
                    mdm_Case_Product__c productObj = [select id, Consumer_Product_Descriptor_Local_Lang__c from mdm_Case_Product__c where Id = :productId ];
                    if (productObj != null && productObj.Consumer_Product_Descriptor_Local_Lang__c != null){
                        productHierarchy = productObj.Consumer_Product_Descriptor_Local_Lang__c;
                    }
                }
            }
        }
        try{
            caseRecord.CEC_Product_Hierarchy__c = productHierarchy;
            Database.update(caseRecord);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, e.getMessage()) );
        }
    }
    
    
    /**
This method processes the Production code into 2 parts -
1. Generate daycode
2. Generate Date of Manufacture
*/
    public void processProductionCode(){
        if(!isEmptyCountryVerbatimCheck){
            if (reasonId != null && reasonId != ''){
                List<mdm_Reason_Code__c> rObjList = [select name from mdm_Reason_Code__c where id = :reasonId ];
                if (rObjList != null && rObjList.size() > 0){
                    reasonName = rObjList[0].name;
                }
            }
            
            if (productId != null && productId != ''){
                List<mdm_Case_Product__c> pObjList = [select name from mdm_Case_Product__c where id = :productId ];
                if (pObjList != null && pObjList .size() > 0){
                    productName = pObjList[0].name;
                }
            }
            
            /* process the production code to identify daycode */
            identifyDaycode();
            
            /* process the daycode to identify date of manufacture */
            identifyDateOfManufacture();
            
            /* check for any popup alerts to show */
            checkAlertAction();
        }
    }
    
    
    
    /**
This method identifies daycode from the production code
*/
    public void identifyDaycode(){
        
        String Daycode = '';
        caseRecord.Date_of_Manufacture_str__c = '';
        caseRecord.Date_of_Manufacture__c = null;
        
        if (caseRecord.Production_Code__c!= null && caseRecord.Production_Code__c!= '' && caseRecord.Production_Code__c.length() >= 4){
            //production_Code validations
            String productionCode=caseRecord.Production_Code__c;
            
            if((productionCode.substring(0,4)).isNumeric()){
                Daycode = productionCode.substring(0,4);
            }
            else if (productionCode.length()>4 &&( productionCode.substring(1,5)).isNumeric() ){
                Daycode = productionCode.substring(1,5);
            }
            
            if(Daycode !=''){
                String days=Daycode.subString(1);
                if(Integer.valueof(days)>366){
                    Daycode='';
                    
                }
                
                /* identify the date of manufacture from the daycode */
            }
            
            identifyDateOfManufacture();
        }
        caseRecord.DayCode__c = Daycode;
        try{ 
            Database.update(caseRecord);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, e.getMessage()) );
        }
    }
    
    /**
This method identifies date of manufacture from the daycode
*/
    public void identifyDateOfManufacture(){
        if (caseRecord.DayCode__c != null && caseRecord.DayCode__c != '' && caseRecord.DayCode__c.length() == 4){
            /* splitting 1st char as Year & taking it as integer */
            
            try{
                
                String year = caseRecord.DayCode__c.substring(0,1); 
                Integer prodYearDigit = Integer.valueOf(year);  
                
                /* splitting 2 to 4 chars as number of days & taking it as integer*/            
                String noOfDays = caseRecord.DayCode__c.substring(1); 
                Integer n = Integer.valueOf(noOfDays);
                
                
                
                /* identifying current year & converting it into String */
                Integer currentYear = Integer.valueOf((Date.today()).year()); 
                String currentYearStr  = String.valueOf(currentYear);
                
                /*extracting the last digit of the current year */
                String currentYearLastDigitStr = currentYearStr.substring(3);
                Integer currentYearLastDigitNum = Integer.valueOf(currentYearLastDigitStr); 
                
                /*extracting the first three digits of the current year */
                String currentYearfirstthreeDigitStr = currentYearStr.substring(0,3);
                Integer currentYearfirstthreeDigitNum = Integer.valueOf(currentYearfirstthreeDigitStr); 
                
                
                Integer prodYear;
                
                /* if production year <= current year */
                if (prodYearDigit <= currentYearLastDigitNum ){    
                    //prodYear = Date.today().year();
                    
                    String prodYearStr = currentYearfirstthreeDigitStr + year;
                    System.debug('~~~prodYearStr '+ prodYearStr );
                    prodYear = Integer.valueOf(prodYearStr);
                    
                }else{
                    prodYear =  Date.today().year() -1;
                    
                    System.debug('~~~currentYearfirstthreeDigitNum '+ currentYearfirstthreeDigitNum);
                    
                    Integer prodYearfirstthreeDigitNum = currentYearfirstthreeDigitNum-1;
                    System.debug('~~~prodYearfirstthreeDigitNum '+ prodYearfirstthreeDigitNum );
                    
                    String prodYearfirstthreeDigitStr= string.valueof(prodYearfirstthreeDigitNum);
                    System.debug('~~~prodYearfirstthreeDigitStr'+ prodYearfirstthreeDigitStr);
                    
                    String prodYearStr = prodYearfirstthreeDigitStr + year;
                    System.debug('~~~prodYearStr'+ prodYearStr);
                    
                    prodYear =  Integer.valueOf(prodYearStr);
                    System.debug('~~~prodYear '+ prodYear );
                }
                
                /*creating a date instance for the Prod year & 1st Jan */
                DateTime dateOfManufacture =  DateTime.newInstance(prodYear , 1, 1);
                System.debug('~~~dateOfManufacture '+dateOfManufacture);
                /* adding number of days from daycode to above date */
                dateOfManufacture = dateOfManufacture.addDays(n-1);
                String dateOfManufactureStr =  dateOfManufacture.format('dd-MM-yyyy');
                
                System.debug('~~~dateOfManufactureStr '+ dateOfManufactureStr);
                
                this.dateOfManufacture = dateOfManufactureStr;
                caseRecord.Date_of_Manufacture__c = dateOfManufacture;
                caseRecord.Date_of_Manufacture_str__c = dateOfManufactureStr;
                
            }
            catch(Exception e)  {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Production Code.');
                ApexPages.addMessage(myMsg); 
                caseRecord.DayCode__c = '';
                this.dateOfManufacture = '';
            }
            
            try{ 
                Database.update(caseRecord);
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, e.getMessage()) );
            }
            
        }else if(caseRecord.DayCode__c==null || caseRecord.DayCode__c==''){
            caseRecord.Date_of_Manufacture__c =null;
            Database.update(caseRecord);
        }
    }
    
    
    /**
This method selects all distinct categories from ProductCategory table
*/
    public List<SelectOption> getCategoryValues() {
        List<SelectOption> categoryOptions = new List<SelectOption>();
        if(caseRecord.Case_product_category__c==null){
            categoryOptions.add(new SelectOption('None','None'));
        }
        /* selecting all distinct categories from ProductCategory table */
        AggregateResult[] productCategoryList = [select L2_Product_Category__c from mdm_Product_Category__c GROUP BY L2_Product_Category__c limit 20000 ];
        if (productCategoryList != null && productCategoryList.size() > 0){
            Integer increment = 0;
            for (AggregateResult ar : productCategoryList ){
                /* if ( (productCategory == null || productCategory == '') && increment == 0 ){
if (ar.get('L2_Product_Category__c') != null && ar.get('L2_Product_Category__c') != ''){
productCategory = String.valueOf(ar.get('L2_Product_Category__c'));
}
}
*/if (ar.get('L2_Product_Category__c') != null && ar.get('L2_Product_Category__c') != ''){
    //if(String.valueOf(ar.get('L2_Product_Category__c'))!=caseRecord.Category__c)
    categoryOptions.add(new SelectOption(String.valueOf(ar.get('L2_Product_Category__c')), String.valueOf(ar.get('L2_Product_Category__c') )));
}
                increment++;                
            }
        }
        
        return categoryOptions;
    }
    
    /**
This method updates the reason hierarchy
*/
    public void updateReasonHierarchy(){ 
        String level1Desc = '', level2Desc = '';
        popupAlertCheck = false;
        questionnaireAlertCheck = false;
        // If reasonId is updated and is not null, extract reason codes
        if (reasonId != null && reasonId != '' && oldReasonId != reasonId){
            List<mdm_Reason_Code__c> rObjList = [select id, L1_Desc__c, L2_Desc__c, name from mdm_Reason_Code__c where id = :reasonId];
            // if reason code exists, update reason hierarchy acordingly
            if (rObjList != null && rObjList.size() > 0 && rObjList[0].name != null){
                reasonName = rObjList[0].name;
                if (rObjList[0].L1_Desc__c != null && rObjList[0].L1_Desc__c != null){
                    level1Desc = rObjList[0].L1_Desc__c;
                }
                if (rObjList[0].L2_Desc__c != null && rObjList[0].L2_Desc__c != null){
                    level2Desc = rObjList[0].L2_Desc__c;
                }
                
                reasonHierarchy = level1Desc + ' ' +  level2Desc ;
            }
            // set case fields
            caseRecord.Reason_Code__c = reasonId;
            caseRecord.CEC_Reason_Hierarchy__c = reasonHierarchy;
            // Update case record
            try{
                Database.update(caseRecord);
                oldReasonId = reasonId;
                knowledgeWrapperList.clear();
                //fetch related reason and product knowledge articles 
                searchMatchingReasonKnowledgeArticles();
                searchMatchingProductKnowledgeArticles();
                if (productId != null && productId != ''){
                    /* check for any popup alerts to show */
                    checkAlertAction();
                }
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, e.getMessage()) );
                System.debug('Exception:: ' + e.getMessage()+ ' :: '+ e.getStackTraceString());
            }
        }
        // set product name
        if(productId != null && productId != '' && oldProductId != productId){
            List<mdm_Case_Product__c> pObjList = [select name from mdm_Case_Product__c where id = :productId ];
            if (pObjList != null && pObjList.size() > 0 && pObjList[0].name != null){
                productName = pObjList[0].name;
            }
        }
    }
    
    
    /**
This method updates the product hierarchy
*/
    public void updateProductHierarchy(){
        System.debug('reasonId =' + reasonId );
        // Reset the security alert flag to false
        popupAlertCheck = false;
        questionnaireAlertCheck = false;
        if (reasonId != null && reasonId != '' && oldReasonId != reasonId){
            mdm_Reason_Code__c rObj = [select name from mdm_Reason_Code__c where id = :reasonId ];
            if (rObj != null && rObj.name != null){
                reasonName = rObj.name;
            }
        }
        System.debug('reasonName =' + reasonName);
        System.debug('productId =' + productId);
        if (productId != null && productId != '' && oldProductId != productId){
            mdm_Case_Product__c pObj = [select name, Product_Status__c,Last_Sold_Manufactured__c  from mdm_Case_Product__c where id = :productId ];
            System.debug('pObj =' + pObj );
            if (pObj != null && pObj.name != null){
                productName = pObj.name;
                productStatus = pObj.Product_Status__c.toLowerCase();
                productMFD = pObj.Last_Sold_Manufactured__c ;
            }
            
            caseRecord.isFormKnown__c = true;
            caseRecord.isVariantKnown__c= true;
            caseRecord.isPacksizeKnown__c= true;
            isProductCategoryEnabled = false;
            System.debug('productName =' + productName );
            mdm_Case_Product__c productObj = [select id, Consumer_Product_Descriptor_Local_Lang__c from mdm_Case_Product__c where Id = :productId ];
            System.debug('productObj =' + productObj );
            if (productObj != null && productObj.Consumer_Product_Descriptor_Local_Lang__c != null){
                productHierarchy = productObj.Consumer_Product_Descriptor_Local_Lang__c;
                caseRecord.CEC_Product_Hierarchy__c = productHierarchy;
            }
            caseRecord.CEC_Product__c = productId;
            try{ 
                Database.update(caseRecord);
                oldProductId = productId;
                knowledgeWrapperList.clear();
                searchMatchingProductKnowledgeArticles();
                searchMatchingReasonKnowledgeArticles();
                if (reasonId != null && reasonId != '') {
                    /* check for any popup alerts to show */
                    checkAlertAction();
                }
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, e.getMessage()) );
                System.debug('Exception:: ' + e.getMessage()+ ' :: '+ e.getStackTraceString());
            }
            System.debug('productHierarchy  =' + productHierarchy);
        }
        
        
    }
    
    
    /**
This method checks for any Popup and Questionnaire alerts for the Case
*/
    
    public void checkAlertAction(){
        
        popupAlertCheck = false;
        questionnaireAlertCheck = false;
        
        List<cec_Alert_Tracker__c> alertTrackerList;
        
        // Get the Alert Tracker for the Case       
        
        List<cec_Alert_Tracker_Item__c> alertTrackerItems = [SELECT Alert_Tracker_Id__c FROM cec_Alert_Tracker_Item__c WHERE Active__c = True AND Case_Id__c = :caseRecord.Id];
        
        List<Id> alertTrackerIdList = new List<Id>();
        
        if(alertTrackerItems.size() > 0){
            
            for(cec_Alert_Tracker_Item__c atItem : alertTrackerItems){
                alertTrackerIdList.add(atItem.Alert_Tracker_Id__c); 
            }
            
            alertTrackerList = [SELECT Id, Alert_Rule_Id__c, Alert_Threshold__c, Current_Threshold__c FROM cec_Alert_Tracker__c WHERE Id IN :alertTrackerIdList];
            
        }   
        // Check the Current Threshold is reached to maximum Threshold
        
        System.debug('checkAlertAction::alertTrackerList:: '+alertTrackerList);
        
        List<Id> alertRuleIdList = new List<Id>();
        
        if(alertTrackerList != null){
            
            for(cec_Alert_Tracker__c alertTracker:alertTrackerList){
                if(alertTracker.Current_Threshold__c >= alertTracker.Alert_Threshold__c){
                    alertRuleIdList.add(alertTracker.Alert_Rule_Id__c);
                }
            }
            
            System.debug('checkAlertAction::alertRuleIdList:: '+alertRuleIdList);
            
            if(!alertRuleIdList.isEmpty()){
                
                // Get all the Alert Actions for the Alert Tracker Rule
                List<cec_Alert_Action__c> alertActionList = [SELECT Id, Type__c, Popup_Message__c FROM cec_Alert_Action__c WHERE Alert_Rule_Id__c IN :alertRuleIdList AND (Type__c = 'Popup' OR Type__c = 'Questionnaire')];
                
                System.debug('checkAlertAction::alertActionList:: '+alertActionList);
                popupAlertMsg = '';
                for(cec_Alert_Action__c alertAction : alertActionList){
                    
                    // Pick up all the Popup (or) Questionnaire Alert Action of the rule
                    
                    if(alertAction.Type__c == 'Popup'){
                        popupAlertCheck = true;
                        popupAlertMsg += String.escapeSingleQuotes(alertAction.Popup_Message__c) + '\\r\\n';
                    } else if (alertAction.Type__c == 'Questionnaire') {
                        questionnaireAlertCheck = true;
                    }                
                }
            }
        }
    }
    
    /**
This method updates form availability based on Category selection
*/    
    public void updateProductCategory() {
        if(caseRecord.Case_product_category__c=='None'){
            caseRecord.Case_product_category__c=null;
        }
        update caseRecord;
        updateFormAvailabilityDetails();
    }
    /*Wrapper class to contain the Related cases */
    public class RelatedIssue { 
        public String issueType {get; set;}
        public Case record {get; set;}
        public String parentNumber{get; set;}
        
        public RelatedIssue(String issueType, Case record,String parentNumber) {
            this.issueType = issueType;
            this.record = record;
            this.parentNumber=parentNumber;
        }
        
    }
    
    /* Method to search for matching Product knowledge articles */ 
    public void searchMatchingProductKnowledgeArticles(){
        String productUPC = '';
        
        System.debug('product Id ='  + productId  );
        
        /* identifying the GTIN_EAN_UPC_Code__c code for the selected product */        
        if (productId != null && productId != ''){
            mdm_Case_Product__c productObj = [ select GTIN_EAN_UPC_Code__c from mdm_Case_Product__c where id =:productId ];
            if (productObj != null && productObj.GTIN_EAN_UPC_Code__c  != null){
                productUPC = productObj.GTIN_EAN_UPC_Code__c;
            }
        }
        System.debug('productUPC ='  + productUPC);
        
        /* identifying the matching PRODUCT knowledge articles */        
        if (productUPC  != null && productUPC != '') {
            
            String query;
            // If the Case is of type George then fetch only the French language Product Info articles from 'TO - Product Information' article type - As per the business process the George will be creating/uploading the articles only in French language.
            
            if (caseRecord.Case_Market_Tag__c == Label.TO_CaseIdentifier) {
                query = 'select id, ArticleType, Title, KnowledgeArticleId from TO_Product_Information__kav where language = \'fr\' and publishStatus = \'Online\' and TO_Product_Code__c =: productUPC';
                if(caseRecord.Country_Name__c != null && caseRecord.Country_Name__c != ''){
                    query += ' WITH DATA CATEGORY Market__c AT '+caseRecord.Country_Name__c.replaceAll(' ','_')+'__c';                
                }
                matchingTOProductArticlesList = Database.query(query);
                if (matchingTOProductArticlesList != null && matchingTOProductArticlesList .size() > 0){
                    
                    for(TO_Product_Information__kav productArticle : matchingTOProductArticlesList ){
                        KnowledgeArticleWrapper wrapperObj =  new KnowledgeArticleWrapper();
                        wrapperObj.TOProductArticle = productArticle;
                        wrapperObj.isSelected = false;
                        wrapperObj.articleType = 'Product Information';
                        wrapperObj.subject= productArticle.Title ;   
                        wrapperObj.articleId= productArticle.id;
                        wrapperObj.knowledgeArticleId = productArticle.knowledgeArticleId;    
                        knowledgeWrapperList.add(wrapperObj);
                    }             
                }
            } else {
                query = 'select id, ArticleType, Title, KnowledgeArticleId from cec_Product_Information__kav where language = \'en_US\' and publishStatus = \'Online\' and Product_Code__c =: productUPC';
                if(caseRecord.Country_Name__c != null && caseRecord.Country_Name__c != ''){
                    query += ' WITH DATA CATEGORY Market__c AT '+caseRecord.Country_Name__c.replaceAll(' ','_')+'__c';                
                }
                matchingProductArticlesList = Database.query(query);
                if (matchingProductArticlesList != null && matchingProductArticlesList .size() > 0){
                    for(cec_Product_Information__kav productArticle : matchingProductArticlesList ){
                        KnowledgeArticleWrapper wrapperObj =  new KnowledgeArticleWrapper();
                        wrapperObj.productArticle = productArticle;
                        wrapperObj.isSelected = false;
                        wrapperObj.articleType = 'Product Information';
                        wrapperObj.subject= productArticle.Title ;   
                        wrapperObj.articleId= productArticle.id;
                        wrapperObj.knowledgeArticleId = productArticle.knowledgeArticleId;    
                        knowledgeWrapperList.add(wrapperObj);
                    }
                    
                }
            }
        }
        
    }
    
    
    /* Method to search for matching Reason knowledge articles */ 
    public void searchMatchingReasonKnowledgeArticles(){
        
        String reasonShortCode = '';
        
        System.debug('reason Id ='  + reasonId  );
        
        /* identifying the reason 5 short desc for the selected reason */ 
        if (reasonId != null && reasonId != ''){
            mdm_Reason_Code__c reasonObj = [ select L5_Short_Desc__c from mdm_Reason_Code__c where id =:reasonId ];
            if (reasonObj != null && reasonObj.L5_Short_Desc__c != null){
                reasonShortCode = reasonObj.L5_Short_Desc__c ;
            }
        }
        
        System.debug('reasonShortCode ='  + reasonShortCode );
        
        /* identifying the matching REASON knowledge articles */  
        if (reasonShortCode != null && reasonShortCode != '') {
            
            String query;
            // If the Case is of type George then fetch only the French language Reason Code articles - As per the business process the George will be creating/uploading the articles only in French language.
            if (caseRecord.Case_Market_Tag__c == Label.TO_CaseIdentifier) {
                query = 'select id, ArticleType, Title, KnowledgeArticleId from cec_Reason_Information__kav where language = \'fr\' and publishStatus = \'Online\' and Short_Code__c =: reasonShortCode';
            } else {
                query = 'select id, ArticleType, Title, KnowledgeArticleId from cec_Reason_Information__kav where language = \'en_US\' and publishStatus = \'Online\' and Short_Code__c =: reasonShortCode';
            }
            
            if(caseRecord.Country_Name__c != null && caseRecord.Country_Name__c != ''){
                query += ' WITH DATA CATEGORY Market__c AT '+caseRecord.Country_Name__c.replaceAll(' ','_')+'__c';                
            }
            
            matchingReasonArticlesList = Database.query(query);
            
            if (matchingReasonArticlesList != null && matchingReasonArticlesList.size() > 0)            {
                for(cec_Reason_Information__kav reasonArticle : matchingReasonArticlesList ){
                    KnowledgeArticleWrapper wrapperObj =  new KnowledgeArticleWrapper();
                    wrapperObj.reasonArticle = reasonArticle;
                    wrapperObj.isSelected = false;
                    wrapperObj.articleType = 'Reason Information';
                    wrapperObj.subject= reasonArticle.Title ; 
                    wrapperObj.articleId= reasonArticle.id;
                    wrapperObj.knowledgeArticleId = reasonArticle.knowledgeArticleId;                  
                    knowledgeWrapperList.add(wrapperObj);
                }
            }
        }
    }
    
    /* Method to map knowledge articles to Case */
    public void mapArticleToCase(){
        
        try{
            
            CaseArticle caseArticleObj;
            
            if (selectedArticleId != null && selectedArticleId != ''){
                
                /* creating a new CaseArticle object */ 
                caseArticleObj = new CaseArticle();
                
                /* setting case id for the case article */
                caseArticleObj.CaseId = caseRecord.Id;
                caseArticleObj.KnowledgeArticleId = Id.valueOf(selectedArticleId);
                
                /* setting article language for French if it is for George Case else English*/
                if (caseRecord.Case_Market_Tag__c == Label.TO_CaseIdentifier) {
                    caseArticleObj.ArticleLanguage = 'fr';
                } else {
                    caseArticleObj.ArticleLanguage = 'en_US';
                }
                insert caseArticleObj;
            }
            
            System.debug('caseArticleObj = ' + caseArticleObj);
            
        }catch(Exception ex){
            System.debug('Error in CEC_CaseInlineController -> mapArticleToCase : ' +  ex);
        }
    }
}