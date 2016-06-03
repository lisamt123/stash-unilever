/* -----------------------------------------------------------------------------------------------------------------------
   Name:        CEC_IssueCreationPageController
   Description: 
                                   
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   Oct 2014    1.0           Shruti          Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */

/**
This class acts as a controller class for Issue creation VF page.
*/
global with sharing class CEC_IssueCreationPageController{

    /* Issue object */
  //  public cec_Issue__c caseReason {get; set;}
    
    /* Reason Id */
  //  public String reasonId {get; set;}
    
    /* Reason name */
//    public String reasonName {get; set;}
    
    /* Product Id */
 //   public String productId {get; set;}
    
    /* Product name */
 /*   public String productName {get; set;}
    
    public Boolean showKnowledgeLink {get; set;}
    public String knowledgeLink {get; set;}
    public Boolean showQuestionnaireLink {get; set;}
    public String questionnaireLink {get; set;}
    public String userMessage {get; set;}
    public String userWarning {get; set;}
    
    /* to decide whether to display missing information section or not */
 //   public boolean missingInfoSectionDisplay {get; set;}    
    
    /* to maintain 4 char day code */
 //   public String daycode {get; set;}
    
    /* to maintain date of manufacture */
  //  public String dateOfManufacture{get; set;}

    /* to maintain product category */
 //   public String productCategory{get; set;}
    
    /* to decide whether the product category is enabled or disabled */
 //   public boolean isProductCategoryEnabled {get; set;}    
    
    /* reason hierarchy */
  //  public String reasonHierarchy {get; set;}
    
    /* product hierarchy */
  //  public String productHierarchy {get; set;}
    
    /* List to maintain matching Product knowledge articles*/
 //   public List<cec_Product_Information__kav> matchingProductArticlesList {get; set;}
    
    /* List to maintain matching Reason knowledge articles*/
 //   public List<cec_Reason_Information__kav> matchingReasonArticlesList {get; set;}
    
    /* List to maintain matching Reason knowledge articles*/
//    public List<KnowledgeArticleWrapper> knowledgeWrapperList {get; set;}
    
 //   public List<cec_Store__c> storeList{get; set;}
    
    /* constructor */
  /*  public CEC_IssueCreationPageController(ApexPages.StandardController controller) {
    knowledgeWrapperList = new List<KnowledgeArticleWrapper>();
        caseReason = (cec_Issue__c) controller.getRecord();
        if (caseReason.Id != null) {
            caseReason = [Select Id, Reason_Code__c, Reason_Code__r.Name, CEC_Product__c, CEC_Product__r.Name From cec_Issue__c Where Id = :caseReason.Id];
            reasonId = caseReason.Reason_Code__c;
            reasonName = caseReason.Reason_Code__r.Name;
            productId = caseReason.CEC_Product__c;
            productName = caseReason.CEC_Product__r.Name;   
            showKnowledgeLink = true;
            showQuestionnaireLink = true;
        } else {
            showKnowledgeLink = false;
            showQuestionnaireLink = false;
        }
        userMessage = 'Please enter a reason and  a product.';
        userWarning = '';

        /* making 'missising info' section hidden as default */        
   //     missingInfoSectionDisplay = false;
        
        /* making 'form' checkbox uncheched as default */                
   //     caseReason.isFormKnown__c = false;
        
        /* making 'variant' checkbox uncheched as default */    
   //     caseReason.isVariantKnown__c = false;
        
        /* making 'pack size' checkbox uncheched as default */    
   //     caseReason.isPacksizeKnown__c= false;
        
   //     isProductCategoryEnabled = true;
        
  //  }

    /**
    This method is used to save an issue
    */
 /*   public PageReference saveAndContinue() {
        try{ 
            cec_Issue__c cr = new cec_Issue__c();
            cr.Case__c = caseReason.Case__c;
        
            if (reasonId  != null && reasonId  != '' && productId != null && productId != ''){
                cr.Unique_ID__c = cr.Case__c + reasonId + productId;
                cr.Reason_Code__c = reasonId;
                cr.CEC_Product__c= productId;
                cr.Production_Code__c = caseReason.Production_Code__c;
                cr.DayCode__c= caseReason.DayCode__c;
                cr.Date_of_Manufacture__c= caseReason.Date_of_Manufacture__c;
                cr.Date_of_Manufacture_str__c= caseReason.Date_of_Manufacture_str__c;
                cr.isFormKnown__c= caseReason.isFormKnown__c;
                cr.isVariantKnown__c= caseReason.isVariantKnown__c;
                cr.isPacksizeKnown__c= caseReason.isPacksizeKnown__c;
                cr.Purchase_Date__c= caseReason.Purchase_Date__c;
                cr.Verbatim__c= caseReason.Verbatim__c;
                cr.Store__c= caseReason.Store__c;
                cr.Store_Location__c= caseReason.Store_Location__c;
                
                try {
                    //inserting issue
                    upsert cr Case_Reason__c.Unique_ID__c;
                    System.debug('Issue created : Id ============= ' + cr.Id);
                    /* if (cr.Id != null){
                        searchInKnowledgeArticles(cr.Id);
                    }*/
                    
               /*     if (knowledgeWrapperList != null && knowledgeWrapperList.size() > 0){
                        mapArticlesToCases(cr.Case__c);
                    }
                    
                    
                } catch (Exception e) {
                    System.debug('Exception in CEC_IssueCreationPageController -> saveAndContinue() : ' +e);  
                }
        
                /*
                Integer count = [Select Count() from Case_Reason_Alert__c where Case_Reason__c = :cr.Id];
        
                if (count > 0) {
                    userMessage = '';
                    userWarning = 'An alert has been raised for this combination of case reason and product. View the related list of alerts for more information.'; 
                } else {
                    userMessage = 'The case reason has been added to the case. Click the "View in Knowledge" button to search the Knowledge Base for futher information, or click "Close" to return to the case record.';        
                    userWarning = '';
                }
                showKnowledgeLink = true;
                showQuestionnaireLink = true;
                */
         /*       PageReference ref = new PageReference('/' + cr.id);
                ref.setRedirect(true);
                return ref;
            }else{
                System.debug('else.....');
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Reason.');
                ApexPages.addmessage(errMsg); 
                return null;
            }
        }catch(Exception ex){
            System.debug('Exception in CEC_IssueCreationPageController -> saveAndContinue() : ' +ex); 
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Reason.');
            ApexPages.addmessage(errMsg); 
            return null;
        }
        System.debug('before return.....');
        return null;
    }
    
    
 /*   public PageReference validateCloseTab() {
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Changes have not been saved.'));
        return null;
    }
    
    /*public PageReference setKnowledgeUrl() {
        String url;
        try {
            System.debug('********Product ID ******'+productId);
        
            mdm_Case_Product__c cp = [Select Product_Code__c 
                                  From mdm_Case_Product__c 
                                  Where Id = : productId];
            System.debug('******CP ******'+cp);
            url = [Select Id
                   From Product_Information__kav 
                   Where Product_Code__c = : cp.Product_Code__c 
                   And PublishStatus = 'Online' 
                   And Language = 'en_US'].Id;
            System.debug('********url ******'+url);           
        } catch (Exception e) {
            System.debug(e);
        }            
        knowledgeLink = '/' + url;
        return null;
    }
    
    */
    /**
    This method toggles the display of 'Missing information' section
    */
   /* public void toggleMissingInfoDisplay(){
        System.debug('in toggleMissingInfoDisplay....................');
        if (missingInfoSectionDisplay == true){
            missingInfoSectionDisplay = false;
        }else{
            missingInfoSectionDisplay = true;
        }
        
        /*maintaining reason name on screen */   
   /*     if (reasonId != null && reasonId != ''){
           mdm_Reason_Code__c rObj = [select name from mdm_Reason_Code__c where id = :reasonId ];
           if (rObj != null){
               reasonName = rObj.name;
           }
        }
        
        /*maintaining product name on screen */   
     /*   if (productId != null && productId != ''){
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
  /*  public void updateFormAvailabilityDetails(){
        if (caseReason.isFormKnown__c == false){
            isProductCategoryEnabled = true;
            
            /*if form is missing, loading product hierarchy */
       /*     if (caseReason.isFormKnown__c== false){
                if (productId != null && productId != ''){
                    mdm_Case_Product__c productObj = [select id, Brand__c from mdm_Case_Product__c where Id = :productId ];
                    if (productObj != null && productObj.Brand__c!= null){
                        productHierarchy = productObj.Brand__c;
                    }
                    if (productCategory !=null && productCategory != ''){
                        productHierarchy =  productHierarchy + ' ' + productCategory ;
                    }
                 }
             } 
        }else{
            isProductCategoryEnabled = false; */
            //since form is known and if the other 2 are also known
        /*    if (caseReason.isVariantKnown__c== true && caseReason.isPacksizeKnown__c == true){
                isProductCategoryEnabled = false;
                if (productId != null && productId != ''){    
                    mdm_Case_Product__c productObj = [select id, Consumer_Product_Descriptor_Local_Lang__c from mdm_Case_Product__c where Id = :productId ];
                    if (productObj != null && productObj.Consumer_Product_Descriptor_Local_Lang__c != null){
                        productHierarchy = productObj.Consumer_Product_Descriptor_Local_Lang__c;
                    }
                }
            }
        }
    } */

    /**
    This method updates the details based on check / uncheck of VARIANT checkbox
    */
  //  public void updateVariantAvailabilityDetails(){
        /*if variant is missing, loading product hierarchy */
   /*     if (caseReason.isVariantKnown__c== false){
             if (productId != null && productId != ''){ 
                 mdm_Case_Product__c productObj = [select id, Global_CPG_Code__r.Corp_Prod_Grouping_Name__c from mdm_Case_Product__c where Id = :productId ];
                 if (productObj != null && productObj.Global_CPG_Code__r.Corp_Prod_Grouping_Name__c != null){
                     productHierarchy = productObj.Global_CPG_Code__r.Corp_Prod_Grouping_Name__c;
                 }
             }
        }else { */
            //since variant is known and if the other 2 are also known
       /*     if (caseReason.isFormKnown__c== true && caseReason.isPacksizeKnown__c == true){
                isProductCategoryEnabled = false;
                if (productId != null && productId != ''){ 
                    mdm_Case_Product__c productObj = [select id, Consumer_Product_Descriptor_Local_Lang__c from mdm_Case_Product__c where Id = :productId ];
                    if (productObj != null && productObj.Consumer_Product_Descriptor_Local_Lang__c != null){
                        productHierarchy = productObj.Consumer_Product_Descriptor_Local_Lang__c;
                    }
                }
            }
         }
    } */
    
    
    /**
    This method updates the details based on check / uncheck of PACK SIZE checkbox
    */
   /* public void updatePacksizeAvailabilityDetails(){
        if (caseReason.isPacksizeKnown__c == false){
            if (productId != null && productId != ''){ 
                mdm_Case_Product__c productObj = [select id, Consumer_Product_Descriptor_no_size__c from mdm_Case_Product__c where Id = :productId ];
                if (productObj != null && productObj.Consumer_Product_Descriptor_no_size__c!= null){
                     productHierarchy = productObj.Consumer_Product_Descriptor_no_size__c;
                 }
            }
         } else {
             //since PACK SIZE is known and if the other 2 are also known
             if (caseReason.isFormKnown__c== true && caseReason.isVariantKnown__c == true){
                 isProductCategoryEnabled = false;
                 if (productId != null && productId != ''){ 
                     mdm_Case_Product__c productObj = [select id, Consumer_Product_Descriptor_Local_Lang__c from mdm_Case_Product__c where Id = :productId ];
                     if (productObj != null && productObj.Consumer_Product_Descriptor_Local_Lang__c != null){
                         productHierarchy = productObj.Consumer_Product_Descriptor_Local_Lang__c;
                     }
                 }
             }
        }
    } */

    
    /**
    This method processes the Production code into 2 parts -
    1. Generate daycode
    2. Generate Date of Manufacture
    */
/*    public void processProductionCode(){
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
        } */
        
        /* process the production code to identify daycode */
     //   identifyDaycode();
        
        /* process the daycode to identify date of manufacture */
   //     identifyDateOfManufacture();
  //  } 
    

    
    /**
    This method identifies daycode from the production code
    */
  /*   public void identifyDaycode(){
     if (caseReason.Production_Code__c!= null && caseReason.Production_Code__c!= '' && caseReason.Production_Code__c.length() >= 4){
            caseReason.DayCode__c = caseReason.Production_Code__c.substring(1,5);
            //caseReason.DayCode__c = daycode ;
            
            /* identify the date of manufacture from the daycode */
      //      identifyDateOfManufacture();
     //   }
   // } */
    
    /**
    This method identifies date of manufacture from the daycode
    */
  //  public void identifyDateOfManufacture(){
   //    if (caseReason.DayCode__c != null && caseReason.DayCode__c != '' && caseReason.DayCode__c.length() == 4){
            /* splitting 1st char as Year & taking it as integer */
            
         //   try{
            
         //   String year = caseReason.DayCode__c.substring(0,1); 
          //  Integer prodYearDigit = Integer.valueOf(year);  

            /* splitting 2 to 4 chars as number of days & taking it as integer*/            
        //    String noOfDays = caseReason.DayCode__c.substring(1); 
         //   Integer n = Integer.valueOf(noOfDays);
            
            //caseReason.DayCode__c = daycode ;
            
            /* identifying current year & converting it into String */
           // Integer currentYear = Integer.valueOf((Date.today()).year()); 
          //  String currentYearStr  = String.valueOf(currentYear);
            
            /*extracting the last digit of the current year */
        /*    String currentYearLastDigitStr = currentYearStr.substring(3);
            Integer currentYearLastDigitNum = Integer.valueOf(currentYearLastDigitStr); 
            
            /*extracting the first three digits of the current year */
          //  String currentYearfirstthreeDigitStr = currentYearStr.substring(0,3);
         //   Integer currentYearfirstthreeDigitNum = Integer.valueOf(currentYearfirstthreeDigitStr); 
            
            
         //   Integer prodYear; */
            
            /* if production year <= current year */
         /*   if (prodYearDigit <= currentYearLastDigitNum ){    
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
            } */
            
            /*creating a date instance for the Prod year & 1st Jan */
       /*     DateTime dateOfManufacture =  DateTime.newInstance(prodYear , 1, 1);
            System.debug('~~~dateOfManufacture '+dateOfManufacture);
            /* adding number of days from daycode to above date */
       /*     dateOfManufacture = dateOfManufacture.addDays(n-1);
            String dateOfManufactureStr =  dateOfManufacture.format('dd-MM-yyyy');
            
            System.debug('~~~dateOfManufactureStr '+ dateOfManufactureStr);
            
            this.dateOfManufacture = dateOfManufactureStr;
            caseReason.Date_of_Manufacture__c = dateOfManufacture;
            caseReason.Date_of_Manufacture_str__c = dateOfManufactureStr;
            
            }
            catch(Exception e)  {
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Production Code.');
               ApexPages.addMessage(myMsg); 
               caseReason.DayCode__c = '';
               this.dateOfManufacture = '';
            }
            
        }
    } */
    
    
    /**
    This method selects all distinct categories from ProductCategory table
    */
  //  public List<SelectOption> getCategoryValues() {
 //       List<SelectOption> categoryOptions = new List<SelectOption>();
        
        /* selecting all distinct categories from ProductCategory table */
    /*    AggregateResult[] productCategoryList = [select L2_Product_Category__c from mdm_Product_Category__c GROUP BY L2_Product_Category__c ];
        if (productCategoryList != null && productCategoryList.size() > 0){
            Integer i = 0;
            for (AggregateResult ar : productCategoryList ){
                if ( (productCategory == null || productCategory == '') && i == 0 ){
                    if (ar.get('L2_Product_Category__c') != null && ar.get('L2_Product_Category__c') != ''){
                        productCategory = String.valueOf(ar.get('L2_Product_Category__c'));
                    }
                }
                if (ar.get('L2_Product_Category__c') != null && ar.get('L2_Product_Category__c') != ''){
                    categoryOptions.add(new SelectOption(String.valueOf(ar.get('L2_Product_Category__c')), String.valueOf(ar.get('L2_Product_Category__c') )));
                }
                i++;                
            }
        }
        
        return categoryOptions;
    } */
    
    /**
    This method updates the reason hierarchy
    */
  /*  public void updateReasonHierarchy(){ 
        if (reasonId != null && reasonId != ''){
            List<mdm_Reason_Code__c> rObjList = [select name from mdm_Reason_Code__c where id = :reasonId ];
            if (rObjList != null && rObjList.size() > 0 && rObjList[0].name != null){
                reasonName = rObjList[0].name;
            }
        }
        
        if (productId != null && productId != ''){
           List<mdm_Case_Product__c> pObjList = [select name from mdm_Case_Product__c where id = :productId ];
           if (pObjList != null && pObjList.size() > 0 && pObjList[0].name != null){
               productName = pObjList[0].name;
           }
        }
    
        String level1Desc = '', level2Desc = '';
        if (reasonId != null && reasonId != ''){
            List<mdm_Reason_Code__c> reasonCodeObjList = [ select id, L1_Desc__c, L2_Desc__c from mdm_Reason_Code__c where Id =:  reasonId ];
            if (reasonCodeObjList != null && reasonCodeObjList.size() > 0 && reasonCodeObjList[0] != null ){
                if (reasonCodeObjList[0].L1_Desc__c != null && reasonCodeObjList[0].L1_Desc__c != 'null'){
                    level1Desc = reasonCodeObjList[0].L1_Desc__c;
                }
                if (reasonCodeObjList[0].L2_Desc__c != null && reasonCodeObjList[0].L2_Desc__c != 'null'){
                    level2Desc = reasonCodeObjList[0].L2_Desc__c;
                } */
            
                /*if (reasonCodeObj.Global_Listening_Tree__r.L1_Desc__c != null && reasonCodeObj.Global_Listening_Tree__r.L1_Desc__c!= 'nulll'){
                    level1Desc = reasonCodeObj.Global_Listening_Tree__r.L1_Desc__c;
                }
                if (reasonCodeObj.Global_Listening_Tree__r.L2_Desc__c != null && reasonCodeObj.Global_Listening_Tree__r.L2_Desc__c != 'nulll'){
                    level2Desc = reasonCodeObj.Global_Listening_Tree__r.L2_Desc__c;
                } */
       /*         reasonHierarchy = level1Desc + ' ' +  level2Desc ;
            }
        }
        
        searchMatchingReasonKnowledgeArticles();
    } */
    
    
    /**
    This method updates the product hierarchy
    */
/*    public void updateProductHierarchy(){
        System.debug('reasonId =' + reasonId );
        if (reasonId != null && reasonId != ''){
            mdm_Reason_Code__c rObj = [select name from mdm_Reason_Code__c where id = :reasonId ];
            if (rObj != null && rObj.name != null){
                reasonName = rObj.name;
            }
        }
        System.debug('reasonName =' + reasonName );
        
        System.debug('productId =' + productId );
        if (productId != null && productId != ''){
           mdm_Case_Product__c pObj = [select name from mdm_Case_Product__c where id = :productId ];
           System.debug('pObj =' + pObj );
           if (pObj != null && pObj.name != null){
               productName = pObj.name;
           }
           
           caseReason.isFormKnown__c = true;
           caseReason.isVariantKnown__c= true;
           caseReason.isPacksizeKnown__c= true;
           
           isProductCategoryEnabled = false;
        }
         System.debug('productName =' + productName );
         
         
         mdm_Case_Product__c productObj = [select id, Consumer_Product_Descriptor_Local_Lang__c from mdm_Case_Product__c where Id = :productId ];
         System.debug('productObj =' + productObj );
         if (productObj != null && productObj.Consumer_Product_Descriptor_Local_Lang__c != null){
             productHierarchy = productObj.Consumer_Product_Descriptor_Local_Lang__c;
         }
         
         System.debug('productHierarchy  =' + productHierarchy  );
         searchMatchingProductKnowledgeArticles();
    } */
    

    /**
    This method updates form availability based on Category selection
    */    
  /*  public void updateProductCategory() {
        updateFormAvailabilityDetails();
    } */
    
   /* public void searchInKnowledgeArticles(Id issueId){
        System.debug('issueId =' + issueId);
        String reasonShortDesc = '';
        String productUPC = '';
        
        if (issueId != null ){
            cec_Issue__c issueObj = [select Reason_L5_Short_desc__c, Product_UPC__c from cec_Issue__c where id =:issueId];
            if (issueObj != null){
                reasonShortDesc = issueObj.Reason_L5_Short_desc__c;
                productUPC = issueObj.Product_UPC__c ;
            }
        }
        System.debug('reasonShortDesc =' + reasonShortDesc );
        System.debug('productUPC ='  + productUPC  );
        List<Issue_Knowledge_Article__c> issueArticleList = new List<Issue_Knowledge_Article__c>();
        
        if(reasonShortDesc != null && reasonShortDesc != ''){
            List<cec_Reason_Information__kav> reasonArticlesList = [select id, ArticleNumber, ArticleType, publishStatus from cec_Reason_Information__kav where language = 'en_US' and publishStatus = 'Online' and Short_Code__c =: reasonShortDesc ];
            if (reasonArticlesList != null && reasonArticlesList.size() > 0){
                for (cec_Reason_Information__kav reasonArticle : reasonArticlesList ){
                    Issue_Knowledge_Article__c issueArticleObj = new Issue_Knowledge_Article__c();
                    issueArticleObj.Short_Reason_Code__c = reasonShortDesc  ;
                    issueArticleObj.issue__c = issueId;
                    issueArticleObj.Article_Id__c = reasonArticle.id;
                    
                    issueArticleList.add(issueArticleObj);
                }
            }
       }  
       
       if(productUPC != null && productUPC != ''){
            List<cec_Product_Information__kav > productArticlesList = [select id, ArticleNumber, ArticleType, publishStatus from cec_Product_Information__kav where language = 'en_US' and publishStatus = 'Online' and Product_Code__c =: productUPC ];
            if (productArticlesList != null && productArticlesList .size() > 0){
                for (cec_Product_Information__kav productArticle : productArticlesList ){
                    Issue_Knowledge_Article__c issueArticleObj = new Issue_Knowledge_Article__c();
                    issueArticleObj.Product_Code__c= productUPC ;
                    issueArticleObj.issue__c = issueId;
                    String articleId = String.valueOf(productArticle.id);
                    issueArticleObj.Article_Id__c = articleId.substring(0, 15);
                   
                    issueArticleList.add(issueArticleObj);
                }
            }
       }        
        if (issueArticleList != null){
            insert issueArticleList;
        }
        
    } */
    
    
    
    /* Method to search for matching Product knowledge articles */ 
   // public void searchMatchingProductKnowledgeArticles(){
   //     String productUPC = '';

        /* identifying the GTIN_EAN_UPC_Code__c code for the selected product */        
      /*  if (productId != null ){
            mdm_Case_Product__c productObj = [ select GTIN_EAN_UPC_Code__c from mdm_Case_Product__c where id =:productId ];
            if (productObj != null && productObj.GTIN_EAN_UPC_Code__c  != null){
                productUPC = productObj.GTIN_EAN_UPC_Code__c  ;
            }
        }
        System.debug('productUPC ='  + productUPC  ); */
        
        /* identifying the matching PRODUCT knowledge articles */        
     /*   if (productUPC  != null && productUPC != '') {
            matchingProductArticlesList = [select id, ArticleType, Title from cec_Product_Information__kav where language = 'en_US' and publishStatus = 'Online' and Product_Code__c =: productUPC ];
            if (matchingProductArticlesList != null && matchingProductArticlesList .size() > 0)            {
                for(cec_Product_Information__kav productArticle : matchingProductArticlesList ){
                    KnowledgeArticleWrapper wrapperObj =  new KnowledgeArticleWrapper();
                    wrapperObj.productArticle = productArticle ;
                    wrapperObj.isSelected = false;
                    wrapperObj.articleType = 'Product Information';
                    wrapperObj.subject= productArticle .Title ;   
                    wrapperObj.articleId= productArticle.id;    
                    knowledgeWrapperList.add(wrapperObj);
                }
            }
        }
    } */
    
    
    /* Method to search for matching Reason knowledge articles */ 
   //  public void searchMatchingReasonKnowledgeArticles(){
    //    String reasonShortCode = '';

        /* identifying the reason 5 short desc for the selected reason */ 
     /*   if (reasonId != null ){
            mdm_Reason_Code__c reasonObj = [ select L5_Short_Desc__c from mdm_Reason_Code__c where id =:reasonId ];
            if (reasonObj != null && reasonObj.L5_Short_Desc__c != null){
                reasonShortCode = reasonObj.L5_Short_Desc__c ;
            }
        }
        System.debug('reasonShortCode ='  + reasonShortCode ); */
        
        /* identifying the matching REASON knowledge articles */  
    /*    if (reasonShortCode != null && reasonShortCode != '') {
            matchingReasonArticlesList = [select id, ArticleType, Title from cec_Reason_Information__kav where language = 'en_US' and publishStatus = 'Online' and Short_Code__c =: reasonShortCode ];
            if (matchingReasonArticlesList != null && matchingReasonArticlesList.size() > 0)            {
                for(cec_Reason_Information__kav reasonArticle : matchingReasonArticlesList ){
                    KnowledgeArticleWrapper wrapperObj =  new KnowledgeArticleWrapper();
                    wrapperObj.reasonArticle = reasonArticle;
                    wrapperObj.isSelected = false;
                    wrapperObj.articleType = 'Reason Information';
                    wrapperObj.subject= reasonArticle.Title ; 
                    wrapperObj.articleId= reasonArticle.id;                  
                    knowledgeWrapperList.add(wrapperObj);
                }
            }
            
        }
    } */
    
    
    /* Method to map knowledge articles to Case */
  /*  public void mapArticlesToCases(Id caseId){
        try{
            List<CaseArticle> caseArticleList = new List<CaseArticle>();
            CaseArticle caseArticleObj;
            
            if (knowledgeWrapperList != null && knowledgeWrapperList.size() > 0){
                for(KnowledgeArticleWrapper wrapperObj : knowledgeWrapperList ){
                    /* if article is selected to be attached */
                 /*   if (wrapperObj.isSelected == true){
                        /* creating a new CaseArticle object */ 
                      //  caseArticleObj = new CaseArticle();
                        
                        /* setting case id for the case article */
                      //  caseArticleObj.CaseId = caseId;
                        
                    //    if (wrapperObj.articleType == 'Product Information'){
                            /* setting article id for the case article */
                   /*         ID articleId = Id.valueOf(wrapperObj.productArticle.Id);
                            caseArticleObj.KnowledgeArticleId = articleId ;
                        }else if (wrapperObj.articleType == 'Reason Information'){
                            /* setting article id for the case article */
                  /*         ID articleId = Id.valueOf(wrapperObj.reasonArticle.Id);
                            caseArticleObj.KnowledgeArticleId = articleId ;
                        }
                                                
                        /* setting article language */
                   //     caseArticleObj.ArticleLanguage = 'en_US'; 
                        
                /*        caseArticleList.add(caseArticleObj);
                    }
                }
            }
            System.debug('caseArticleList = ' + caseArticleList );
            if (caseArticleList != null){
                insert caseArticleList;
            }
            
        }catch(Exception ex){
            System.debug('Error in CEC_IssueCreationPageController -> mapArticlesToCases : ' +  ex);
        }
        
        
    } */
    
    /* Inner class */
    /* This class is a wrapper class for the knowledge articles */
 // public class KnowledgeArticleWrapper{
    
    /* article id*/
     //   public String articleId{ get; set; }
        
        /* Reference to reason article */
    //    public cec_Reason_Information__kav reasonArticle{ get; set; }

        /* Reference to product article */
    //    public cec_Product_Information__kav productArticle{ get; set; }
        
        /* flag to indicate whether article is selected */
   //     public boolean isSelected{ get; set; }
        
        /* article type */
     //   public String articleType{ get; set; }
        
        /* article subject */
    //    public String subject{ get; set; }
        
        /* constructor */
      //  public KnowledgeArticleWrapper(){}
        
  //  } 

}