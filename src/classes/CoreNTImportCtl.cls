/*
*       Class Name:CoreNTImportCtl
*       Author:Mindtree
*       Date:09 May 2014
*       Description : This class is used for Importing the MPP XML into Salesforce.
*                     
*/
public with sharing class CoreNTImportCtl {

        
    public CORE_NT_Project__c project {get; set;}
    public String contentType {get;set;}
    public string fileName{get;set;}  
    transient public Blob fileBody{get;set;} 
    public Integer maxFileSize {get; set;}
    
   // public static Integer MAX_FILE_SIZE = 9000000; 
    
    public List<String> errorList {get; set;}       
    public List<String> taskErrorList {get; set;}
    public List<String> resourceErrorList {get; set;}
    public List<String> assignmentErrorList {get; set;}
    public List<String> infoTaskList {get; set;}
    public List<String> infoResourceList {get; set;}
    public List<String> warnAssignmentList {get; set;}
    
    public boolean showPrjError {get;set;}
    public boolean showTaskError {get;set;}
    public boolean showResError {get;set;}
    public boolean showAssignError {get;set;}
    public boolean showInfoTaskSec {get;set;}
    public boolean showInfoResSec {get;set;}
    public boolean showAssignWarnSec {get;set;} 
      
    public String category {get;set;}
    public String subcategory {get;set;}
    public String brandName {get;set;}
    public double ito {get;set;}
    
    public List < SelectOption > subcategoryOptions {get;set;}
    public List < SelectOption > categoryOptions {get;set;}
    public List < SelectOption > brandOptions {get;set;}
    
    private static String CONTENT_ERROR = CoreNTException.ERROR_PROLOG;
    public boolean checkProjectExistFlag { get; set; }
    public CoreNTImportCtl() {
        System.debug(' Class : ImportProjectController || Method : constructor || Started ');

        showPrjError = false;
        showTaskError = false;
        showResError = false;
        showAssignError = false;
        showInfoTaskSec = false;
        showInfoResSec = false;
        showAssignWarnSec = false;
        
        checkProjectExistFlag = false;
        
        System.debug(' Class : ImportProjectController || Method : constructor || Started ');
    }
    
    /**
     *       This Method is used to upload the MPP Xml in the content version.
     *
     *       @param File Content
     *       @return 
     *       @throws exception-DMLException
     */
    public void uploadMPPXml(Blob fileContent)
    {            
        try {
         insert new ContentVersion(
            versionData = fileContent,
            Title = fileName,
            PathOnClient = fileName,            
            FirstPublishLocationId = Label.Core_NT_Network_Library_Id,
            Origin = 'C');
               
        } catch (DMLException e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
        }        
    }


    /**
     *       This is used to parse the xml tasks, resources, assignments etc with the help of utility methods.
     *
     *       @param None
     *       @return PageReference
     *       @throws exception-Exception
     */
    public PageReference importTemplateXML() {
        System.debug(' Class : ImportProjectController || Method : importTemplateXML || Started ');
       // PageReference newPage = new PageReference(CoreNTConstants.SUCCESS_PAGE);
        try {
            if (fileName == null || fileName == '')
                throw new CoreNTException(CoreNTException.ERROR_NO_FILE_SELECTED);
            if (this.maxFileSize < 1) {
                throw new CoreNTException(CoreNTException.ERROR_EMPTY_XML);
            }            
            checkProjectExistFlag = false;
            String xml = '';
            if (fileBody != null && fileName != null) {
                if (!fileName.contains(CoreNTConstants.XML_EXTENSION))
                    throw new CoreNTException(CoreNTException.ERROR_INVALID_XML);
                if (fileBody.size() > Integer.valueOf(Label.Core_NT_Import_File_Max_Size)) {
                    fileBody = null; // Null out the large filesize to prevent ViewState Max Size errors.
                    throw new CoreNTException(CoreNTException.ERROR_FILESIZE_TOO_LARGE + ' The number of characters must be less than ' + Label.Core_NT_Import_File_Max_Size + '.');
                }
            }
            // Uploading MPP Xml into Content Version for supporting Big Size Xmls

            uploadMPPXml(fileBody);
            
            for(List<ContentVersion> attachedFiles : [select d.Id,d.versionData,d.title from ContentVersion d where d.title =: fileName ORDER BY CreatedDate DESC limit 1] ) {
               
                transient DOM.Document doc = new DOM.Document();                
                doc.load(attachedFiles[0].versionData.toString());
                transient DOM.XMLNode root = doc.getRootElement();
                doc = null;
                transient String projectName=null;
                transient List < CORE_NT_Project__c > lstProject = new List < CORE_NT_Project__c > ();
                if (root.getChildElement(CoreNTConstants.PROJECT_TITLE_TAG, CoreNTConstants.XML_NAMESPACE) != null)
                    projectName = root.getChildElement(CoreNTConstants.PROJECT_TITLE_TAG, CoreNTConstants.XML_NAMESPACE).getText();
                root=null;
                if (projectName != null)
                    lstProject = [Select id, name from CORE_NT_Project__c where Name = : projectName Limit 1];
                if (!lstProject.isEmpty())
                    checkProjectExistFlag =true;
                lstProject=null;
            }

            if(checkProjectExistFlag ==true)
                return null;
            else
                return updateProjectDeatil();
        }
        catch (Exception e) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage());
                if (e.getMessage() != null && e.getMessage().contains(CONTENT_ERROR)){
                    errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, CoreNTException.ERROR_INVALID_XML);
            }
            ApexPages.addMessage(errorMsg);
            return ApexPages.currentPage();            
        }
    }
    public void cancelProjectDetail(){
        checkProjectExistFlag = false;
    }
    public PageReference updateProjectDeatil(){
        PageReference newPage = new PageReference(CoreNTConstants.SUCCESS_PAGE);
           // project = importUtility.importProject(fileBody);
        checkProjectExistFlag = false;
        try {
            project = new CORE_NT_Project__c();
            CoreNTImportUtility importUtility = new CoreNTImportUtility();
            for(List<ContentVersion> attachedFiles : [select d.Id,d.versionData,d.title from ContentVersion d where d.title =: fileName ORDER BY CreatedDate DESC limit 1] ) {       
                project = importUtility.importProject(attachedFiles[0].versionData);
            }
            errorList = new List < String > ();
            errorList.addAll(importUtility.prjErrorList);
            if (!errorList.isEmpty())
                showPrjError = true;
            else
                showPrjError = false;
            taskErrorList = new List < String > ();
            taskErrorList.addAll(importUtility.taskErrorList);
            if (!taskErrorList.isEmpty())
                showTaskError = true;
            else
                showTaskError = false;

            resourceErrorList = new List < String > ();
            resourceErrorList.addAll(importUtility.resourceErrorList);
            if (!resourceErrorList.isEmpty())
                showResError = true;
            else
                showResError = false;

            assignmentErrorList = new List < String > ();
            assignmentErrorList.addAll(importUtility.assignmentErrorList);

            infoTaskList = new List < String > ();
            infoTaskList.addAll(importUtility.infoTaskList);

            infoResourceList = new List < String > ();
            infoResourceList.addAll(importUtility.infoResourceList);

            warnAssignmentList = new List < String > ();
            warnAssignmentList.addAll(importUtility.warnAssignmentList);

            if (!assignmentErrorList.isEmpty())
                showAssignError = true;
            else
                showAssignError = false;

            if (!infoTaskList.isEmpty())
                showInfoTaskSec = true;
            else
                showInfoTaskSec = false;
            if (!infoResourceList.isEmpty())
                showInfoResSec = true;
            else
                showInfoResSec = false;
            if (!warnAssignmentList.isEmpty())
                showAssignWarnSec = true;
            else
                showAssignWarnSec = false;
        } catch (Exception e) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage());
            if (e.getMessage() != null && e.getMessage().contains(CONTENT_ERROR)) {
                errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, CoreNTException.ERROR_INVALID_XML);
            }
            ApexPages.addMessage(errorMsg);
            return ApexPages.currentPage();
        }


        List < CORE_NT_Project__c > projectLst = new List < CORE_NT_Project__c > ();

        if (project.Id != null)
            projectLst = [Select id, name, CategoryName__c, SubcategoryName__c, Brand__c, Project_Type__c, Project_Scope__c, Cluster__c, IPM_Project__C, ITO__c from CORE_NT_Project__c where id = : project.Id];
        if (!projectLst.isEmpty()) {
            project = projectLst[0];
            brandName = project.Brand__c;
            category = project.CategoryName__c;
            subcategory = project.SubcategoryName__c;
            ito = project.ITO__c;
            
        }
        newPage.setRedirect(false);
        System.debug(' Class : ImportProjectController || Method : importTemplateXML || Completed ');
        return newPage;
    }

    /**
     *       This is used to retrieve the brands from the Brand_Centre_New__c to pick dynamic values.
     *
     *       @param None
     *       @return List<SelectOption>
     *       @throws exception-None
     */
    public List < SelectOption > getBrandItems() {
        System.debug(' Class : ImportProjectController || Method : getBrandItems || Started ');
        brandOptions = new List < SelectOption > ();
        List < AggregateResult > lstBrandNames = [SELECT Name FROM uw_Brand__c GROUP BY Name];
        brandOptions.add(new SelectOption('-none-', '-None-'));
        if (lstBrandNames.size() > 0) {
            for (AggregateResult brandName: lstBrandNames) {
                brandOptions.add(new SelectOption((String) brandName.get('Name'), (String) brandName.get('Name')));
            }
        }
        System.debug(' Class : ImportProjectController || Method : getBrandItems || Completed ');
        return brandOptions;
    }


    /**
     *       This is used to retrieve the categorys from the Brand_Centre_New__c object.
     *
     *       @param None
     *       @return List<SelectOption>
     *       @throws exception-None
     */
    public List < SelectOption > getCategoryItems() {
            System.debug(' Class : ImportProjectController || Method : getCategoryItems || Started ');
            categoryOptions = new List < SelectOption > ();
            List < AggregateResult > lstCategoryNames = [SELECT Category__c FROM Brand_Centre_New__c GROUP BY Category__c];
            categoryOptions.add(new SelectOption('-none-', '-None-'));
            for (AggregateResult categoryName: lstCategoryNames) {
                if((String) categoryName.get('Category__c')!= null)
                    categoryOptions.add(new SelectOption((String) categoryName.get('Category__c'), (String) categoryName.get('Category__c')));
            }
            System.debug(' Class : ImportProjectController || Method : getCategoryItems || Completed ');
            return categoryOptions;
        }
        /**
         *       This is used to retrieve the subcategory data from the Brand_Centre_New__c object
         *
         *       @param None
         *       @return List<SelectOption>
         *       @throws exception-None
         */
    public List < SelectOption > getSubcategoryItems() {
            System.debug(' Class : ImportProjectController || Method : getSubcategoryItems || Started ');
            subcategoryOptions = new List < SelectOption > ();
            subcategoryOptions.add(new SelectOption('-none-', '-None-'));
            if (category != '-none-') {
                List < AggregateResult > lstSubcategoryNames = [SELECT Sub_Category__c FROM Brand_Centre_New__c where Category__c = : category GROUP BY Sub_Category__c];
                for (AggregateResult subcategoryName: lstSubcategoryNames) {
                    if((String) subcategoryName.get('Sub_Category__c') != null)
                    subcategoryOptions.add(new SelectOption((String) subcategoryName.get('Sub_Category__c'), (String) subcategoryName.get('Sub_Category__c')));
                }
            }
            System.debug(' Class : ImportProjectController || Method : getSubcategoryItems || Completed ');
            return subcategoryOptions;
        }
        /**
         *       This is used to update the category, brand, subcategory fields of the Project based on the user input.
         *
         *       @param None
         *       @return PageReference
         *       @throws exception-None
         */
    public PageReference updateProject() {
            System.debug(' Class : ImportProjectController || Method : updateProject || Started ');
            Pagereference projDetailPage = new Pagereference('/' + project.Id);
            try{
                if (brandName != null && category != null && subcategory != null && brandName != '-none-' && category != '-none-' && subcategory != '-none-') {
                    project.CategoryName__c = category;
                    project.SubcategoryName__c = subcategory;
                    project.Brand__c = brandName;
                }
                else
                {
                    ApexPages.Message errorMessage=New ApexPages.Message(ApexPages.Severity.ERROR,'Category,Subcategory and Brand fields are mandatory!! Please enter the values!!!');
                    ApexPages.addMessage(errorMessage);
                    return ApexPages.currentPage();
                }
                update project;
            }Catch(Exception ex){
                ApexPages.Message errorMessage=New ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
                ApexPages.addMessage(errorMessage);
            }
            System.debug(' Class : ImportProjectController || Method : updateProject || Completed ');
            return projDetailPage;
        } 
        /**
         *       This method supports the cancel operation while updating project details.
         *
         *       @param None
         *       @return PageReference
         *       @throws exception-None
         */
    public PageReference cancelAction() {
        System.debug(' Class : ImportProjectController || Method : cancelAction || Started ');
        PageReference importPage = new Pagereference(CoreNTConstants.IMPORT_TAB);
        importPage.setRedirect(false);
        System.debug(' Class : ImportProjectController || Method : cancelAction || Completed ');
        return importPage;
    }
}