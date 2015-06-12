public without sharing class IPMFinancialUploadController {

    public IPM_Project__c project {get; set;}
    public Boolean isEditable{get;set;}
    public String unzippedState {get;set;}
    
    public IPM_Financial_File__c financialFile {get; set;}
    
    private static String APP = 'docProps/app.xml';
    private static String CORE = 'docProps/core.xml';
    private static String CALC_CHAIN = 'xl/calcChain.xml';
    private static String SHARED_STRINGS = 'xl/sharedStrings.xml';
    private static String STYLES = 'xl/styles.xml';
    private static String THEME1 = 'xl/theme/theme1.xml';
    private static String WORKBOOK = 'xl/workbook.xml';
    private static String SHEET1 = 'xl/worksheets/sheet1.xml';
    private static String WORKBOOK_XML_RELS = 'xl/_rels/workbook.xml.rels';
    private static String CONTENT_TYPES = '[Content_Types].xml';
    private static String RELS = '_rels/.rels';

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         IPMFinancialUploadController()
      Type:         CONSTRUCTOR
    --------------------------------------------------------------------------------------------------------------------- */
    public IPMFinancialUploadController() {
        //IE-9 Fix
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');

        String projectId = ApexPages.currentPage().getParameters().get('Id');
        if (projectId != NULL){
            project = [SELECT Id, IPM_Project_Name__c, Sustainability_Period__c, IPMProject_Span__c, Market_Cluster__c, IPM_Parent_Project__c, IPM_Parent_Project__r.Market_Cluster__c, IPM_Phase__c 
                        FROM IPM_Project__C 
                        WHERE Id=:projectId];
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 
                'Upload will start as soon as the file is selected, please wait to be redirected to the results after this.'));
        }
        isEditable=false;
        getIpmuserType();
    }

    // Action Function method called by client code once all entries have been unzipped
    public PageReference unzipped()
    {
        ipmProcessFinancialUpload handler = new ipmProcessFinancialUpload();
        String projectId = handler.execute(unzippedState);
        // Redirect to ZipFile record
        PageReference financialsPage = Page.ipmFinancial;
        financialsPage.getParameters().put('id', projectId);
        financialsPage.setRedirect(true);
        return financialsPage;
    }

    public PageReference backToFinancial()
    {
        // Redirect to ZipFile record
        PageReference financialsPage = Page.ipmFinancial;
        financialsPage.getParameters().put('id', project.Id);
        financialsPage.setRedirect(true);
        return financialsPage;
    }
        
    @RemoteAction
    // JavaScript Remoting method called as each item is unzipped from the file
    public static String receiveZipFileEntry(String filename, String path, String data, String state)
    {
        // First file?
        if(state=='')
        {
            String DEFAULT_RECORDTYPE = Schema.SObjectType.IPM_Financial_File__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
            // Create a record to store unzipped files as attachments
            IPM_Financial_File__c zipFile = new IPM_Financial_File__c();
            zipFile.Name = filename;
            zipFile.RecordtypeId = DEFAULT_RECORDTYPE;
            insert zipFile;
            state = zipFile.Id;
        }
        
        // Attach unzipped file
        Attachment attachment = new Attachment();
        attachment.Body = EncodingUtil.base64Decode(data);
        attachment.Name = path;
        attachment.ParentId = state;
        insert attachment;
        
        return state;       
    }   
    
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         generateTemplate()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to generate the template based on the project rollouts
    --------------------------------------------------------------------------------------------------------------------- */
    public PageReference generateTemplate() {
        String DEFAULT_RECORDTYPE = Schema.SObjectType.IPM_Financial_File__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();

        List<IPM_Financial_File__c> lstExistingTemplateFiles = [SELECT Id, Name, RecordtypeId, IPM_Project__c
                                                                    FROM IPM_Financial_File__c
                                                                    WHERE IPM_Project__c =: project.Id];
        
        if (lstExistingTemplateFiles.size()>0)
            Database.delete(lstExistingTemplateFiles);
        
        IPM_Financial_File__c projectTemplateFile = new IPM_Financial_File__c(Name = project.IPM_Project_Name__c + '.xlsx',
                                                                                    RecordtypeId = DEFAULT_RECORDTYPE,
                                                                                    IPM_Project__c = project.Id);
        String projectTemplateFileId = Database.insert(projectTemplateFile).getId();
        
        List<Attachment>  lstProjectTemplateAttachments = new List<Attachment>();

        //Process App
        lstProjectTemplateAttachments.add(
            new Attachment(
                Name = APP,
                Body = processApp(),
                ParentId = projectTemplateFileId
            )
        );

        //Process Core
        lstProjectTemplateAttachments.add(
            new Attachment(Name = CORE,
                Body = processCore(),
                ParentId = projectTemplateFileId
            )
        );

        //Process Calc Chain
        lstProjectTemplateAttachments.add(
            new Attachment(Name = CALC_CHAIN,
                Body = processCalcChain(),
                ParentId = projectTemplateFileId
            )
        );
        
        //Process Shared Strings
        lstProjectTemplateAttachments.add(
            new Attachment(Name = SHARED_STRINGS,
                Body = processSharedStrings(),
                ParentId = projectTemplateFileId
            )
        );

        //Process Styles
        lstProjectTemplateAttachments.add(
            new Attachment(Name = STYLES,
                Body = processStyles(),
                ParentId = projectTemplateFileId
            )
        );

        //Process Theme1
        lstProjectTemplateAttachments.add(
            new Attachment(Name = THEME1,
                Body = processTheme1(),
                ParentId = projectTemplateFileId
            )
        );

        //Process Workbook
        lstProjectTemplateAttachments.add(
            new Attachment(Name = WORKBOOK,
                Body = processWorkbook(),
                ParentId = projectTemplateFileId
            )
        );

        //Process Sheet1
        lstProjectTemplateAttachments.add(
            new Attachment(Name = SHEET1,
                Body = processSheet1(),
                ParentId = projectTemplateFileId
            )
        );

        //Process WorkbookXmlRels
        lstProjectTemplateAttachments.add(
            new Attachment(Name = WORKBOOK_XML_RELS,
                Body = processWorkbookXmlRels(),
                ParentId = projectTemplateFileId
            )
        );

        //Process ContentTypes
        lstProjectTemplateAttachments.add(
            new Attachment(Name = CONTENT_TYPES,
                Body = processContentTypes(),
                ParentId = projectTemplateFileId
            )
        );

        //Process Rels
        lstProjectTemplateAttachments.add(
            new Attachment(Name = RELS,
                Body = processRels(),
                ParentId = projectTemplateFileId
            )
        );

        insert lstProjectTemplateAttachments;
        PageReference downloadTemplate = Page.ipmDownloadTemplate;
        downloadTemplate.getParameters().put('id', project.Id);
        downloadTemplate.getParameters().put('fileId', projectTemplateFileId);
        downloadTemplate.setRedirect(true);
        return downloadTemplate;
    }
    
    private Blob processApp(){
        PageReference xmlPage;
        
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5App;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate3App;

        xmlPage.setRedirect(true);

        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_App'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }

    private Blob processCore(){
        PageReference xmlPage;
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5Core;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate3Core;

        xmlPage.setRedirect(true);

        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_Core'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }

    private Blob processCalcChain(){
        PageReference xmlPage;
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5CalcChain;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate3CalcChain;

        xmlPage.getParameters().put('id', project.Id);
        xmlPage.setRedirect(true);
        
        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_CalcChain'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }

    private Blob processSharedStrings(){
        PageReference xmlPage;
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5SharedStrings;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate3SharedStrings;

        xmlPage.getParameters().put('id', project.Id);
        xmlPage.setRedirect(true);

        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_SharedStrings'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }

    private Blob processStyles(){
        PageReference xmlPage;
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5Styles;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate3Styles;

        xmlPage.setRedirect(true);

        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_Styles'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }

    private Blob processTheme1(){
        PageReference xmlPage;
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5Theme1;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate3Theme1;

        xmlPage.setRedirect(true);

        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_Theme1'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }

    private Blob processWorkbook(){
        PageReference xmlPage;
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5Workbook;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate5Workbook;

        xmlPage.setRedirect(true);

        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_Workbook'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }

    private Blob processSheet1(){
        PageReference xmlPage;
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5Sheet1;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate3Sheet1;

        xmlPage.getParameters().put('id', project.Id);
        xmlPage.setRedirect(true);

        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_Sheet1'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }

    private Blob processWorkbookXmlRels(){
        PageReference xmlPage;
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5WorkbookXmlRels;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate3WorkbookXmlRels;

        xmlPage.setRedirect(true);

        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_WorkbookXmlRels'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }

    private Blob processContentTypes(){
        PageReference xmlPage;
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5ContentTypes;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate3ContentTypes;

        xmlPage.setRedirect(true);

        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_Content_Types'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }

    private Blob processRels(){
        PageReference xmlPage;
        if(project.Sustainability_Period__c == '5')
            xmlPage = Page.ipmExcelTemplate5Rels;
        else if(project.Sustainability_Period__c == '3')
            xmlPage = Page.ipmExcelTemplate3Rels;
        xmlPage.setRedirect(true);        

        if (Test.IsRunningTest())
            return Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'IPM_Fin_Test_Rels'].Body.toString()); 
        else
            return Blob.valueOf(xmlPage.getContent().toString());
    }
    //Get user type
    public void getIpmuserType(){
        String projectId = ApexPages.currentPage().getParameters().get('Id');
        list<IPM_Project_Resource__c>lstProuser = [SELECT IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c 
                                                    FROM IPM_Project_Resource__c 
                                                    WHERE IPM_Project__c =: projectId 
                                                        AND IPM_User__c=:userinfo.getuserid() 
                                                        AND IPM_Role_Type__c='Finance'  
                                                    LIMIT 1];
        if(lstProuser.size()>0)
            isEditable=true;   

        list<IPM_Project__c>lstofuser = [SELECT IPM_Project_Leader__c,Deputy_Project_Leader__c 
                                            FROM IPM_Project__c 
                                            WHERE (IPM_Project_Leader__c=:userinfo.getuserid() 
                                                    OR Deputy_Project_Leader__c=:userinfo.getuserid()) 
                                                AND id=:projectId 
                                            LIMIT 1];
        if(lstofuser.size()>0)
            isEditable=true;

        list<PermissionSetAssignment> PermissonS = [SELECT Assignee.Name, PermissionSet.Name
                                                        FROM PermissionSetAssignment 
                                                        WHERE (PermissionSet.Name='IPM_Central_Team' 
                                                                OR PermissionSet.Name='IPM_Business_Partners') 
                                                            AND Assignee.id = :userinfo.getuserid()];
        if(PermissonS.size()>0)
            isEditable=true;
    }   
}