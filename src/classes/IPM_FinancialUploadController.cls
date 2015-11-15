/**
* @author       Cognizant (Vipul)
* @date         27/04/2015
* @description  This class is used for managing the upload/download of the Excel templates
*               for the financial business cases
*/
public with sharing class IPM_FinancialUploadController {

    public IPM_Project__c project {get; set;} //Project record for which the financial template needs to be processed
    public Boolean isEditable{get;set;} //Boolean Variable to define if the record is editable by the current logged in user
    public String unzippedState {get;set;} //Unzipped state of the uploaded file. Used to store the record id
    
    public IPM_Financial_File__c financialFile {get; set;} //Financial File record that will be used to process the template

    public Boolean isError {get; set;} //Boolean variable to indicate error on page
    public String errorMessage {get; set;} //Error Message to be displayed on the page
    
    private Map<String, StaticResource> mapStaticResources; //Map of static resources for testt coverage
    
    private static String APP = 'docProps/app.xml'; //App Xml file name
    private static String CORE = 'docProps/core.xml'; //Core Xml file name
    private static String CALC_CHAIN = 'xl/calcChain.xml'; //Calc Chain Xml file name
    private static String SHARED_STRINGS = 'xl/sharedStrings.xml'; //Shared String Xml file name
    private static String STYLES = 'xl/styles.xml'; //Styles Xml file name
    private static String THEME1 = 'xl/theme/theme1.xml'; //Theme Xml file name
    private static String WORKBOOK = 'xl/workbook.xml'; //Workbook Xml file name
    private static String SHEET1 = 'xl/worksheets/sheet1.xml'; //Sheet Xml file name
    private static String WORKBOOK_XML_RELS = 'xl/_rels/workbook.xml.rels'; //Workbook Rels Xml file name
    private static String CONTENT_TYPES = '[Content_Types].xml'; //Content Types Xml file name
    private static String RELS = '_rels/.rels'; //Rels Xml file name

    private static String TEST_RESOURCE_APP = 'IPM_Fin_Test_App'; //Test Resource Name - App
    private static String TEST_RESOURCE_CORE = 'IPM_Fin_Test_Core'; //Test Resource Name - Core
    private static String TEST_RESOURCE_CALC_CHAIN = 'IPM_Fin_Test_CalcChain'; //Test Resource Name - Calc Chain
    private static String TEST_RESOURCE_SHARED_STRINGS = 'IPM_Fin_Test_SharedStrings'; //Test Resource Name - Shared Strings
    private static String TEST_RESOURCE_STYLES = 'IPM_Fin_Test_Styles'; //Test Resource Name - Styles
    private static String TEST_RESOURCE_THEME = 'IPM_Fin_Test_Theme1'; //Test Resource Name - Theme
    private static String TEST_RESOURCE_WORKBOOK = 'IPM_Fin_Test_Workbook'; //Test Resource Name - Workbook
    private static String TEST_RESOURCE_SHEET = 'IPM_Fin_Test_Sheet1'; //Test Resource Name - Sheet
    private static String TEST_RESOURCE_WORKBOOK_RELS = 'IPM_Fin_Test_WorkbookXmlRels'; //Test Resource Name - Workbook Xml Rels
    private static String TEST_RESOURCE_CONTENT_TYPES = 'IPM_Fin_Test_Content_Types'; //Test Resource Name - Content Types
    private static String TEST_RESOURCE_RELS = 'IPM_Fin_Test_Rels'; //Test Resource Name - Rels

    private static final String CLASS_NAME = 'IPM_FinancialUploadController'; //Class Name for Exception Logging

    /*******************************************************************************************************
    * @description  Constructor
    * @param        NONE
    * @return       NONE
    */
    public IPM_FinancialUploadController() {
        try{
            //IE-9 Fix
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
    
            String projectId = ApexPages.currentPage().getParameters().get('Id');
            if (projectId != null) {
                project = [SELECT Id, IPM_Project_Name__c, Sustainability_Period__c, IPMProject_Span__c, Market_Cluster__c, IPM_Parent_Project__c, IPM_Parent_Project__r.Market_Cluster__c, IPM_Phase__c 
                            FROM IPM_Project__C 
                            WHERE Id=:projectId];
                isEditable=IPM_Utils.getIpmuserType(projectId, IPM_ConstantUtils.IPM_ROLE_FINANCE);
            }
        } catch (Exception ex){
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
            		'constructor',ex.getMessage(),ex, 'Error', null, null, null); 
            isError = TRUE;
            errorMessage = ex.getMessage() + '\n' + ex.getStackTraceString();
        }
    }

    /*******************************************************************************************************
    * @description  Action Function method called by client code once all entries have been unzipped
    * @param        NONE
    * @return       NONE
    */
    public PageReference unzipped() {
        try{
            IPM_ProcessFinancialUpload handler = new IPM_ProcessFinancialUpload();
            String projectId = handler.execute(unzippedState);
            // Redirect to ZipFile record
            PageReference financialsPage = Page.IPM_Financial;
            financialsPage.getParameters().put('id', projectId);
            financialsPage.setRedirect(true);
            return financialsPage;
            
        } catch (Exception ex){
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
            		'unzipped',ex.getMessage(),ex, 'Error', null, null, null); 
            isError = TRUE;
            errorMessage = ex.getMessage() + '\n' + ex.getStackTraceString();
            return null;
        }
    }

    /*******************************************************************************************************
    * @description  Action Function to redirect the user to the financial page
    * @param        NONE
    * @return       NONE
    */
    public PageReference backToFinancial(){
        try{
            // Redirect to ZipFile record
            PageReference financialsPage = Page.IPM_Financial;
            financialsPage.getParameters().put('id', project.Id);
            financialsPage.setRedirect(true);
            return financialsPage;
        } catch (Exception ex){
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
            		'backToFinancial',ex.getMessage(),ex, 'Error', null, null, null); 
            isError = TRUE;
            errorMessage = ex.getMessage() + '\n' + ex.getStackTraceString();
            return null;
        }
    }
        
    /*******************************************************************************************************
    * @description      JavaScript Remoting method called as each item is unzipped from the file
    * @param filename   File Name of the extracted file
    * @param path       File Path of the extracted file
    * @param data       Actual data of the file in string format
    * @param state      record id
    * @return           NONE
    */
    @RemoteAction
    public static String receiveZipFileEntry(String filename, String path, String data, String state){
        try {
        	String attachParentId = '';
            // First file?
            if(state==''){
                String DEFAULT_RECORDTYPE = Schema.SObjectType.IPM_Financial_File__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
                // Create a record to store unzipped files as attachments
                IPM_Financial_File__c zipFile = new IPM_Financial_File__c();
                zipFile.Name = filename;
                zipFile.RecordtypeId = DEFAULT_RECORDTYPE;
                Database.SaveResult saveResult = Database.insert(zipFile);
                if (saveResult.isSuccess())
                    attachParentId = saveResult.getId();
            }
            
            if (state != ''){
                // Attach unzipped file
                Attachment attachment = new Attachment();
                attachment.Body = EncodingUtil.base64Decode(data);
                attachment.Name = path;
                attachment.ParentId = attachParentId;
                insert attachment;
            }
            
            return state;       
            
        } catch (Exception ex){
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
            		'receiveZipFileEntry',ex.getMessage(),ex, 'Error', null, null, null); 
            return null;
        }
    }   
    
    /*******************************************************************************************************
    * @description  Used to generate the template based on the project rollouts
    * @param        NONE
    * @return       NONE
    */
    public PageReference generateTemplate() {
        try{
            String DEFAULT_RECORDTYPE = Schema.SObjectType.IPM_Financial_File__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
    
            List<IPM_Financial_File__c> lstExistingTemplateFiles = [SELECT Id, Name, RecordtypeId, IPM_Project__c
                                                                        FROM IPM_Financial_File__c
                                                                        WHERE IPM_Project__c =: project.Id];
            //To Check CRUD
            if (lstExistingTemplateFiles != null && !lstExistingTemplateFiles.isEmpty() && IPM_Financial_File__c.sObjectType.getDescribe().isDeletable())
                Database.delete(lstExistingTemplateFiles);
            
            IPM_Financial_File__c projectTemplateFile = new IPM_Financial_File__c(Name = project.IPM_Project_Name__c + '.xlsx',
                                                                                        RecordtypeId = DEFAULT_RECORDTYPE,
                                                                                        IPM_Project__c = project.Id);
            String projectTemplateFileId = Database.insert(projectTemplateFile).getId();
            
            mapStaticResources = new Map<String, StaticResource>();
            String staticResourceIPMLike = 'IPM%';
            List<StaticResource> lstStatisResource = new List<StaticResource>();
            lstStatisResource = [SELECT Name, Body 
                                        FROM StaticResource 
                                        WHERE Name LIKE: staticResourceIPMLike];
            For(StaticResource sr : lstStatisResource){
                mapStaticResources.put(sr.Name, sr);
            }
            
            List<Attachment>  lstProjectTemplateAttachments = new List<Attachment>();
    
            //Process App
            lstProjectTemplateAttachments.add(
                new Attachment(
                    Name = APP,
                    Body = processXML(Page.IPM_ExcelTemplate3App, Page.IPM_ExcelTemplate5App, TEST_RESOURCE_APP),
                    ParentId = projectTemplateFileId
                )
            );
    
            //Process Core
            lstProjectTemplateAttachments.add(
                new Attachment(Name = CORE,
                    Body = processXML(Page.IPM_ExcelTemplate3Core, Page.IPM_ExcelTemplate5Core, TEST_RESOURCE_CORE),
                    ParentId = projectTemplateFileId
                )
            );
    
            //Process Calc Chain
            lstProjectTemplateAttachments.add(
                new Attachment(Name = CALC_CHAIN,
                    Body = processXML(Page.IPM_ExcelTemplate3CalcChain, Page.IPM_ExcelTemplate5CalcChain, TEST_RESOURCE_CALC_CHAIN),
                    ParentId = projectTemplateFileId
                )
            );
            
            //Process Shared Strings
            lstProjectTemplateAttachments.add(
                new Attachment(Name = SHARED_STRINGS,
                    Body = processXML(Page.IPM_ExcelTemplate3SharedStrings, Page.IPM_ExcelTemplate5SharedStrings, TEST_RESOURCE_SHARED_STRINGS),
                    ParentId = projectTemplateFileId
                )
            );
    
            //Process Styles
            lstProjectTemplateAttachments.add(
                new Attachment(Name = STYLES,
                    Body = processXML(Page.IPM_ExcelTemplate3Styles, Page.IPM_ExcelTemplate5Styles, TEST_RESOURCE_STYLES),
                    ParentId = projectTemplateFileId
                )
            );
    
            //Process Theme1
            lstProjectTemplateAttachments.add(
                new Attachment(Name = THEME1,
                    Body = processXML(Page.IPM_ExcelTemplate3Theme1, Page.IPM_ExcelTemplate5Theme1, TEST_RESOURCE_THEME),
                    ParentId = projectTemplateFileId
                )
            );
    
            //Process Workbook
            lstProjectTemplateAttachments.add(
                new Attachment(Name = WORKBOOK,
                    Body = processXML(Page.IPM_ExcelTemplate3Workbook, Page.IPM_ExcelTemplate5Workbook, TEST_RESOURCE_WORKBOOK),
                    ParentId = projectTemplateFileId
                )
            );
    
            //Process Sheet1
            lstProjectTemplateAttachments.add(
                new Attachment(Name = SHEET1,
                    Body = processXML(Page.IPM_ExcelTemplate3Sheet1, Page.IPM_ExcelTemplate5Sheet1, TEST_RESOURCE_SHEET),
                    ParentId = projectTemplateFileId
                )
            );
    
            //Process WorkbookXmlRels
            lstProjectTemplateAttachments.add(
                new Attachment(Name = WORKBOOK_XML_RELS,
                    Body = processXML(Page.IPM_ExcelTemplate3WorkbookXmlRels, Page.IPM_ExcelTemplate5WorkbookXmlRels, TEST_RESOURCE_WORKBOOK_RELS),
                    ParentId = projectTemplateFileId
                )
            );
    
            //Process ContentTypes
            lstProjectTemplateAttachments.add(
                new Attachment(Name = CONTENT_TYPES,
                    Body = processXML(Page.IPM_ExcelTemplate3ContentTypes, Page.IPM_ExcelTemplate5ContentTypes, TEST_RESOURCE_CONTENT_TYPES),
                    ParentId = projectTemplateFileId
                )
            );
    
            //Process Rels
            lstProjectTemplateAttachments.add(
                new Attachment(Name = RELS,
                    Body = processXML(Page.IPM_ExcelTemplate3Rels, Page.IPM_ExcelTemplate5Rels, TEST_RESOURCE_RELS),
                    ParentId = projectTemplateFileId
                )
            );
    
            insert lstProjectTemplateAttachments;
            PageReference downloadTemplate = Page.IPM_DownloadTemplate;
            downloadTemplate.getParameters().put('id', project.Id);
            downloadTemplate.getParameters().put('fileId', projectTemplateFileId);
            downloadTemplate.setRedirect(true);
            return downloadTemplate;
            
        } catch (Exception ex){
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
            		'generateTemplate',ex.getMessage(),ex, 'Error', null, null, null); 
            isError = TRUE;
            errorMessage = ex.getMessage() + '\n' + ex.getStackTraceString();
            return null;
        }
    }
    
    /*******************************************************************************************************
    * @description                      Process XML from Visualforce Page
    * @param Year3Page                  PageReference for 3 year template
    * @param Year5Page                  PageReference for 5 year template
    * @param testStaticResourceName     Name oof the Static resource for test coverage
    * @return                           NONE
    */
    private Blob processXML(PageReference Year3Page, PageReference Year5Page, String testStaticResourceName){
        PageReference xmlPage;

        if(project.Sustainability_Period__c == '5')
            xmlPage = Year5Page;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Year3Page;

        xmlPage.getParameters().put('id', project.Id);
        xmlPage.setRedirect(true);

        if (Test.IsRunningTest())
            return Blob.valueOf(mapStaticResources.get(testStaticResourceName).Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
        
    }
}