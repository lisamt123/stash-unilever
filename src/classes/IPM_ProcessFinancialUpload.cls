/**
* @author       Cognizant (Vipul)
* @date         27/04/2015
* @description  This class is used for managing the uploading of Financial Business Case
*               from the excel template generated
*/
public without sharing class IPM_ProcessFinancialUpload{
    
    private Map<String, Attachment> mapAttachments; //Map of the xml attachments
    
    private String projectId; //Project Id for the project for which the financial business cases are being processed
    private String sustainabilityPeriod; //Sustainability Period for the financial business cases
    private IPM_Project__c project; //Project record for which the financial business cases are being processed
    
    private Map<Integer, String> mapSharedStringNames; //Map of Shared String Names & Values
    
    private Map<String, IPM_Financial__c> mapFinancials; //Map of Financials for the project
    private Map<String, IPM_Financial_Year__c> mapFinancialYears; //Map of Financial Years for the project
    
    private Map<Integer, String> mapFinancialsFromTemplate; //Map of Financial External Ids which we get from the template
    
    private Map<String, String> mapYearNames; //Map of Calendar Year Names
    
    private static String SHARED_STRINGS = 'xl/sharedStrings.xml'; //Shared String XML File Name
    private static String SHEET1 = 'xl/worksheets/sheet1.xml'; //Sheet1 XML File Name

    private static final String CLASS_NAME = 'IPM_ProcessFinancialUpload'; //Class Name for Exception Logging
    
    /*******************************************************************************************************
    * @description                  Method called to process the record once the excel file has been uploaded
    * @param ipmFinancialFileId     Id of the IPM_Financial_File__c record
    * @return                       Project Id for which the upload has been processed
    */
    public String execute(String ipmFinancialFileId){
        try {
            mapAttachments = new Map<String, Attachment>();
            
            For(Attachment xmlAttachment : [SELECT Id, Name, Body 
                                            FROM Attachment
                                            WHERE ParentId =: ipmFinancialFileId]){
                                                mapAttachments.put(xmlAttachment.Name, xmlAttachment);
            }
            
            processSharedStrings();
            processSheet1();
            processFinancialFile(ipmFinancialFileId);
            
            Database.update(mapFinancials.values());
            Database.update(mapFinancialYears.values());
            
            return projectId;
            
        } catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
            				'execute',ex.getMessage(),ex, 'Error', null, null, null);
            if(ApexPages.currentPage() != null){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() + '\n' + ex.getStackTraceString()));
            }
            return null;
        }
    }
    
    /*******************************************************************************************************
    * @description      Method to process Shared Strings
    * @param            NONE
    * @return           NONE
    */
    private void processSharedStrings(){
        Attachment sharedStringAttachment = mapAttachments.get(SHARED_STRINGS);
        transient Dom.Document domDocument = new Dom.Document();
        domDocument.load(sharedStringAttachment.Body.toString());
        transient Dom.XmlNode root = domDocument.getRootElement();
        domDocument = null;
        
        String namespace = root.getNamespace();
        
        transient DOM.XmlNode[] lstChildElements = root.getChildElements();
        
        sustainabilityPeriod = '3';
        
        mapSharedStringNames = new Map<Integer, String>();
        For (Integer i=0;i < lstChildElements.size(); i++){
            transient Dom.XmlNode tNode = lstChildElements[i].getChildElement('t', namespace);
            if (tNode != null){
                String sharedString = tNode.getText();
                if(sharedString == IPM_ConstantUtils.Y5_LABEL)
                    sustainabilityPeriod = '5';
                mapSharedStringNames.put(i, sharedString);
            }
        }
        
    }
    
    /*******************************************************************************************************
    * @description      Method to process Worksheet
    * @param            NONE
    * @return           NONE
    */
    private void processSheet1(){
        Attachment sheet1Attachment = mapAttachments.get(SHEET1);
        transient Dom.Document domDocument = new Dom.Document();
        domDocument.load(sheet1Attachment.Body.toString());
        transient Dom.XmlNode root = domDocument.getRootElement();
        domDocument = null;
        sheet1Attachment = null;
        
        String namespace = root.getNamespace();
        transient Dom.XmlNode sheetDataNode = root.getChildElement('sheetData', namespace);
        
        mapFinancialsFromTemplate = new Map<Integer, String>();
        mapYearNames = new Map<String, String>();
        
        For (Dom.XmlNode rowNode : sheetDataNode.getChildElements()){
            Integer rowNumber = Integer.valueOf(rowNode.getAttributeValue('r', null));
            
            Integer adjustedRowNumber = rowNumber - 8;
            
            //Row 5 - Project Name
            if (rowNumber == 5)
                getProjectDetails(rowNode, namespace);
            
            Integer remainder = Math.Mod(adjustedRowNumber, 26); //Business Case line Number
            Integer countIndex = Integer.valueOf(Math.Floor(adjustedRowNumber/26)); //Business Case Number
            
            //Adjusted Row 1 - indexed Rollout Names
            if(remainder == 1)
                generateFinancialsMapFromTemplate(rowNode, namespace, countIndex, rowNumber);
            
            //Adjusted Row 5 - Value Market Share (Innovation)
            else if(remainder == 5){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE);
            }
            
            //Adjusted Row 6 - Volume (Innovation)
            else if(remainder == 6){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_VOLUME);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_VOLUME);
            }
            
            
            //Adjusted Row 7 - Turnover (Innovation)
            else if(remainder == 7){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_TURNOVER);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_TURNOVER);
            }
            
            //Adjusted Row 8 - Gross Profit (Innovation)
            else if(remainder == 8){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT);
            }
            
            //Adjusted Row 9 - Advertising & Promotions (Innovation)
            else if(remainder == 9){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS);
            }
            
            //Adjusted Row 10 - Profit Before Overheads (Innovation)
            else if(remainder == 10){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS);
            }
            
            //Adjusted Row 12 - NPV Row
            else if(remainder == 12)
                processNPVRow(rowNode, namespace, countIndex);
            
            //Adjusted Row 13 - IRR Row
            else if(remainder == 13)
                processIRRRow(rowNode, namespace, countIndex);
            
            //Adjusted Row 14 - Payback Row
            else if(remainder == 14)
                processPaybackRow(rowNode, namespace, countIndex);
            
            //Adjusted Row 18 - Calendar Year Names
            else if(remainder == 18){
                if(sustainabilityPeriod == '3')
                    processYearNameRow_SP3(rowNode, namespace);
                else if (sustainabilityPeriod == '5')
                    processYearNameRow_SP5(rowNode, namespace);
            }
            
            //Adjusted Row 19 - Value Market Share (Calendar)
            else if(remainder == 19){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE);
            }
            
            //Adjusted Row 20 - Volume (Calendar)
            else if(remainder == 20){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_VOLUME);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_VOLUME);
            }
            
            //Adjusted Row 21 - Turnover (Calendar)
            else if(remainder == 21){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_TURNOVER);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_TURNOVER);
            }
            
            //Adjusted Row 22 - Gross Profit (Calendar)
            else if(remainder == 22){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT);
            }
            
            //Adjusted Row 23 - Advertising & Promotions (Calendar)
            else if(remainder == 23){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS);
            }
            
            //Adjusted Row 24 - Profit Before Overheads (Calendar)
            else if(remainder == 24){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS);
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, countIndex, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS);
                
                processLastSavedBy(countIndex);
                mapYearNames = new Map<String, String>();
            }
            
            rowNode = null;
        }
    }
    
    /*******************************************************************************************************
    * @description          Method to get project details
    * @param rowNode        DOM Node for the excel row
    * @param namespace      DOM namespace
    * @return               NONE
    */
    private void getProjectDetails(Dom.XmlNode rowNode, String namespace){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            if(colNode.getAttributeValue('r', null) == 'B5'){
                Integer sharedStringIndex = Integer.valueOf(colNode.getChildElement('v', namespace).getText());
                String projectName = mapSharedStringNames.get(sharedStringIndex);
                project = [SELECT Id, IPM_Project_Name__c, IPMProject_Span__c 
                           FROM IPM_Project__c 
                           WHERE IPM_Project_Name__c =: projectName 
                           LIMIT 1];
                
                projectId = project.Id;
                if (projectId.length() > 15)
                    projectId = projectId.substring(0, 15);
            }
        }
        generateFinancialMaps();
    }
    
    /*******************************************************************************************************
    * @description      Method to generate Financial maps
    * @param            NONE
    * @return           NONE
    */
    private void generateFinancialMaps(){
        String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
        String queryString = 'SELECT ';
        //IPM Financial
        For (String field : Schema.SObjectType.IPM_Financial__c.fields.getMap().KeySet())
            queryString+= field + ', ';
        //IPM Financial Year
        queryString+= '(SELECT ';
        For (String field : Schema.SObjectType.IPM_Financial_Year__c.fields.getMap().KeySet()){
            if (field != 'Id')
                queryString+= field + ', ';
        }
        queryString+= 'Id FROM IPM_Financial_Years__r ORDER BY Year__c)';
        queryString+= 'FROM IPM_Financial__c WHERE RecordtypeId =: DEFAULT_FINANCIAL_RECORDTYPE ';
        
        if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
            queryString+= 'AND Global_Project_Id__c =: projectId';
        else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
            queryString+= 'AND Regional_Project__c =: projectId';
        else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
            queryString+= 'AND Local_Project__c =: projectId';
        
        mapFinancials = new Map<String, IPM_Financial__c>();
        mapFinancialYears = new Map<String, IPM_Financial_Year__c>();
        
        For(IPM_Financial__c financial : Database.query(queryString)){
            mapFinancials.put(financial.Financial_External_ID__c, financial);
            For (IPM_Financial_Year__c financialYear : financial.IPM_Financial_Years__r)
                mapFinancialYears.put(financialYear.External_ID__c, financialYear);
        }
    }
    
    /*******************************************************************************************************
    * @description          Method to generate Financial maps from template
    * @param rowNode        DOM Node for the excel row
    * @param namespace      DOM namespace
    * @param countIndex     index for the Financial being processed
    * @param rowNumber      Row Number
    * @return               Boolean
    */
    private Boolean generateFinancialsMapFromTemplate(Dom.XmlNode rowNode, String namespace, Integer countIndex, Integer rowNumber){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellToCheck = 'A'+ rowNumber;
            if(colNode.getAttributeValue('r', null) == cellToCheck){
                Integer sharedStringIndex = Integer.valueOf(colNode.getChildElement('v', namespace).getText());
                mapFinancialsFromTemplate.put(countIndex, mapSharedStringNames.get(sharedStringIndex));
                return true;
            }
        }
        return false;
    }
    
    /*******************************************************************************************************
    * @description          Method to process Financial Year Row for 3 year (sustainability period) template
    * @param rowNode        DOM Node for the excel row
    * @param countIndex     index for the Financial being processed
    * @param yearType       Year Type
    * @param fieldName      Field Name
    * @return               NONE
    */
    private void processFinancialYearRow_SP3(Dom.XmlNode rowNode, Integer countIndex, String yearType, String fieldName){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);
            
            //INNOVATION YEARS
            if(yearType == IPM_ConstantUtils.YEAR_TYPE_INNOVATION){
                if(fieldName == IPM_ConstantUtils.FIELD_LITERAL_VOLUME && initialLetter == 'B')
                    processVolumeUnit(colNode, countIndex);
                else if (initialLetter == 'D')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y0_LABEL, yearType, null, fieldName);
                else if (initialLetter == 'E')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y1_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'F')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y2_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'G')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y3_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'H')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y1_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'I')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y2_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'J')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y3_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
            } 
            //CALENDAR YEARS
            else {
                if (initialLetter == 'E')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'F')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'G')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'H')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'I')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'J')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
            }
        }
    }
    
    /*******************************************************************************************************
    * @description          Method to process Financial Year Row for 5 year (sustainability period) template
    * @param rowNode        DOM Node for the excel row
    * @param countIndex     index for the Financial being processed
    * @param yearType       Year Type
    * @param fieldName      Field Name
    * @return               NONE
    */
    private void processFinancialYearRow_SP5(Dom.XmlNode rowNode, Integer countIndex, String yearType, String fieldName){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);
            
            //INNOVATION YEARS
            if(yearType == IPM_ConstantUtils.YEAR_TYPE_INNOVATION){
                if(fieldName == IPM_ConstantUtils.FIELD_LITERAL_VOLUME && initialLetter == 'B')
                    processVolumeUnit(colNode, countIndex);
                else if (initialLetter == 'D')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y0_LABEL, yearType, null, fieldName);
                else if (initialLetter == 'E')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y1_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'F')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y2_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'G')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y3_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'H')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y4_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'I')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y5_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'J')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y1_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'K')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y2_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'L')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y3_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'M')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y4_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'N')
                    processFinancialYearValue(colNode, countIndex, IPM_ConstantUtils.Y5_LABEL, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
            } 
            //CALENDAR YEARS
            else {
                if (initialLetter == 'E')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'F')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'G')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'H')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'I')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'J')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'K')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'L')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'M')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'N')
                    processFinancialYearValue(colNode, countIndex, mapYearNames.get(initialLetter), yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, fieldName);
            }
        }
    }
    
    /*******************************************************************************************************
    * @description          Method to process Volume Unit
    * @param colNode        DOM Node for the excel column for Volume Unit
    * @param countIndex     index for the Financial being processed
    * @return               NONE
    */
    private void processVolumeUnit(Dom.XmlNode colNode, Integer countIndex){
        String externalId = mapFinancialsFromTemplate.get(countIndex);
        IPM_Financial__c ipmFinancial = mapFinancials.get(externalId);
        
        Integer sharedStringIndex = 24;
        if (sustainabilityPeriod == '5')
            sharedStringIndex = 26;
        For(Dom.XMLNode colChildNode : colNode.getChildElements()){
            if(colChildNode.getName() == 'v'){
                sharedStringIndex = Integer.valueOf(colChildNode.getText());
            }
        }
        
        //Integer sharedStringIndex = Integer.valueOf(colNode.getChildElement('v', namespace).getText());
        ipmFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_UNIT + project.IPMProject_Span__c + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, mapSharedStringNames.get(sharedStringIndex));
        
        mapFinancials.put(externalId, ipmFinancial);
    }
    
    /*******************************************************************************************************
    * @description          Method to process Financial Year Value
    * @param colNode        DOM Node for the excel column
    * @param countIndex     index for the Financial being processed
    * @param yearName       Year Name
    * @param yearType       Year Type
    * @param plType         P&L Type
    * @param fieldName      Field Name
    * @return               NONE
    */
    private void processFinancialYearValue(Dom.XmlNode colNode, Integer countIndex, String yearName, String yearType, String plType, String fieldName){
        String externalId = mapFinancialsFromTemplate.get(countIndex) + '_' + yearName + '_' + yearType + '_' + plType;
        IPM_Financial_Year__c ipmFinancialYear = mapFinancialYears.get(externalId);
        
        Decimal fieldValue = 0;
        For(Dom.XMLNode colChildNode : colNode.getChildElements()){
            if(colChildNode.getName() == 'v'){
                fieldValue = Decimal.valueOf(colChildNode.getText());
            }
        }

        ipmFinancialYear.put(fieldName + project.IPMProject_Span__c + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, fieldValue);
        mapFinancialYears.put(externalId, ipmFinancialYear);
    }
    
    /*******************************************************************************************************
    * @description          Method to process Calendar Year Names for 3 year template
    * @param rowNode        DOM Node for the excel row
    * @param namespace      DOM namespace
    * @return               NONE
    */
    private void processYearNameRow_SP3(Dom.XmlNode rowNode, String namespace){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);
            
            if (initialLetter == 'E' 
                || initialLetter == 'F' 
                || initialLetter == 'G' 
                || initialLetter == 'H' 
                || initialLetter == 'I' 
                || initialLetter == 'J')
                mapYearNames.put(initialLetter, colNode.getChildElement('v', namespace).getText());
        }
    }
    
    /*******************************************************************************************************
    * @description          Method to process Calendar Year Names for 5 year template
    * @param rowNode        DOM Node for the excel row
    * @param namespace      DOM namespace
    * @return               NONE
    */  
    private void processYearNameRow_SP5(Dom.XmlNode rowNode, String namespace){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);
            
            if (initialLetter == 'E' 
                || initialLetter == 'F' 
                || initialLetter == 'G' 
                || initialLetter == 'H' 
                || initialLetter == 'I' 
                || initialLetter == 'J'
                || initialLetter == 'K'
                || initialLetter == 'L'
                || initialLetter == 'M'
                || initialLetter == 'N')
                mapYearNames.put(initialLetter, colNode.getChildElement('v', namespace).getText());
        }
    }
    
    /*******************************************************************************************************
    * @description          Method to process NPV & CAPEX
    * @param rowNode        DOM Node for the excel row
    * @param namespace      DOM namespace
    * @param countIndex     index for the Financial being processed
    * @return               NONE
    */
    private void processNPVRow(Dom.XmlNode rowNode, String namespace, Integer countIndex){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);
            
            String externalId = mapFinancialsFromTemplate.get(countIndex);
            IPM_Financial__c ipmFinancial = mapFinancials.get(externalId);
            
            if (initialLetter == 'E')
                ipmFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_NPV + project.IPMProject_Span__c + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, Decimal.valueOf(colNode.getChildElement('v', namespace).getText()));
            else if (initialLetter == 'H')
                ipmFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_CAPEX + project.IPMProject_Span__c + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, Decimal.valueOf(colNode.getChildElement('v', namespace).getText()));
            
            mapFinancials.put(externalId, ipmFinancial);
        }
    }
    
    /*******************************************************************************************************
    * @description          Method to process IRR & BIC
    * @param rowNode        DOM Node for the excel row
    * @param namespace      DOM namespace
    * @param countIndex     index for the Financial being processed
    * @return               NONE
    */
    private void processIRRRow(Dom.XmlNode rowNode, String namespace, Integer countIndex){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);
            
            String externalId = mapFinancialsFromTemplate.get(countIndex);
            IPM_Financial__c ipmFinancial = mapFinancials.get(externalId);
            
            if (initialLetter == 'E')
                ipmFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_IRR + project.IPMProject_Span__c + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, Decimal.valueOf(colNode.getChildElement('v', namespace).getText()));
            else if (initialLetter == 'H')
                ipmFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_BIC + project.IPMProject_Span__c + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, Decimal.valueOf(colNode.getChildElement('v', namespace).getText()));
            
            mapFinancials.put(externalId, ipmFinancial);
        }
    }
    
    /*******************************************************************************************************
    * @description          Method to process Payback
    * @param rowNode        DOM Node for the excel row
    * @param namespace      DOM namespace
    * @param countIndex     index for the Financial being processed
    * @return               NONE
    */
    private void processPaybackRow(Dom.XmlNode rowNode, String namespace, Integer countIndex){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);
            
            String externalId = mapFinancialsFromTemplate.get(countIndex);
            IPM_Financial__c ipmFinancial = mapFinancials.get(externalId);
            
            if (initialLetter == 'E')
                ipmFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_PAYBACK + project.IPMProject_Span__c + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, Decimal.valueOf(colNode.getChildElement('v', namespace).getText()));
            
            mapFinancials.put(externalId, ipmFinancial);
        }
    }
    
    /*******************************************************************************************************
    * @description          Method to process Last Saved data
    * @param countIndex     index for the Financial being processed
    * @return               NONE
    */
    private void processLastSavedBy(Integer countIndex){
        String externalId = mapFinancialsFromTemplate.get(countIndex);
        IPM_Financial__c ipmFinancial = mapFinancials.get(externalId);
        
        ipmFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_LAST_SAVED + project.IPMProject_Span__c + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, System.now());
        ipmFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_LAST_SAVED_BY + project.IPMProject_Span__c + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, UserInfo.getUserId());
        
        ipmFinancial.put('Status__c', IPM_ConstantUtils.STATUS_IN_PROGRESS);
        
        mapFinancials.put(externalId, ipmFinancial);
    }

    /*******************************************************************************************************
    * @description                  Method for updating the Financial File record with the project id
    * @param ipmFinancialFileId     Id of the IPM_Financial_File__c record
    * @return                       NONE
    */
    private void processFinancialFile(String ipmFinancialFileId){
        IPM_Financial_File__c financialFile = new IPM_Financial_File__c(Id = ipmFinancialFileId, IPM_Project__c = projectId);
        Database.update(financialFile);
    }
}