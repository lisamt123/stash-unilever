public without sharing class IPMProcessFinancialUpload{
    private static String SHARED_STRINGS = 'xl/sharedStrings.xml';
    private static String SHEET1 = 'xl/worksheets/sheet1.xml';

    private static String YEAR_TYPE_INNOVATION = 'Innovation';
    private static String YEAR_TYPE_CALENDAR = 'Calendar';
    private static String PL_TYPE_GROSS = 'Gross';
    private static String PL_TYPE_INCREMENTAL = 'Incremental';
    
    private static String PROJECT_SPAN_GLOBAL = 'Global';
    private static String PROJECT_SPAN_REGIONAL = 'Regional';
    private static String PROJECT_SPAN_LOCAL = 'Local';
    
    private Map<String, Attachment> mapAttachments;

    private String projectId;
    private String sustainabilityPeriod;
    private IPM_Project__c project;

    private Map<Integer, String> mapSharedStringNames;

    private Map<String, IPM_Financial__c> mapFinancials;
    private Map<String, IPM_Financial_Year__c> mapFinancialYears;

    private Map<Integer, String> mapFinancialsFromTemplate;

    private Map<String, String> mapYearNames;
    
    public String execute(String ipmFinancialFileId){
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
    }
    
    private void processFinancialFile(String ipmFinancialFileId){
        IPM_Financial_File__c financialFile = new IPM_Financial_File__c(Id = ipmFinancialFileId, IPM_Project__c = projectId);
        Database.update(financialFile);
    }
    
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
                if(sharedString == 'Y5')
                    sustainabilityPeriod = '5';
                mapSharedStringNames.put(i, sharedString);
            }
        }

    }

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
            
            //Row 6 - Project Id
            if (rowNumber == 5)
                getProjectDetails(rowNode, namespace);
            
            Integer remainder = Math.Mod(adjustedRowNumber, 26);
            Integer countIndex = Integer.valueOf(Math.Floor(adjustedRowNumber/26));
            
            //Adjusted Row 1 - indexed Rollout Names
            if(remainder == 1)
                generateFinancialsMapFromTemplate(rowNode, namespace, countIndex, rowNumber);
                
            //Adjusted Row 5 - Value Market Share (Innovation)
            else if(remainder == 5){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Value_Market_Share');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Value_Market_Share');
            }

            //Adjusted Row 6 - Volume (Innovation)
            else if(remainder == 6){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Volume');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Volume');
            }


            //Adjusted Row 7 - Turnover (Innovation)
            else if(remainder == 7){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Turnover');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Turnover');
            }

            //Adjusted Row 8 - Gross Profit (Innovation)
            else if(remainder == 8){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Gross_Profit');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Gross_Profit');
            }

            //Adjusted Row 9 - Advertising & Promotions (Innovation)
            else if(remainder == 9){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Advertising_Promotions');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Advertising_Promotions');
            }

            //Adjusted Row 10 - Profit Before Overheads (Innovation)
            else if(remainder == 10){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Profit_Before_Overheads');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_INNOVATION, 'Profit_Before_Overheads');
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
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Value_Market_Share');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Value_Market_Share');
            }

            //Adjusted Row 20 - Volume (Calendar)
            else if(remainder == 20){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Volume');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Volume');
            }

            //Adjusted Row 21 - Turnover (Calendar)
            else if(remainder == 21){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Turnover');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Turnover');
            }

            //Adjusted Row 22 - Gross Profit (Calendar)
            else if(remainder == 22){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Gross_Profit');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Gross_Profit');
            }

            //Adjusted Row 23 - Advertising & Promotions (Calendar)
            else if(remainder == 23){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Advertising_Promotions');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Advertising_Promotions');
            }

            //Adjusted Row 24 - Profit Before Overheads (Calendar)
            else if(remainder == 24){
                if(sustainabilityPeriod == '3')
                    processFinancialYearRow_SP3(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Profit_Before_Overheads');
                else if (sustainabilityPeriod == '5')
                    processFinancialYearRow_SP5(rowNode, namespace, countIndex, YEAR_TYPE_CALENDAR, 'Profit_Before_Overheads');

                processLastSavedBy(countIndex);
                mapYearNames = new Map<String, String>();
            }

            rowNode = null;
        }
    }
    
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
    
    private void generateFinancialMaps(){
        String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
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

        if(project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL)
            queryString+= 'AND Global_Project_Id__c =: projectId';
        else if(project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL)
            queryString+= 'AND Regional_Project__c =: projectId';
        else if(project.IPMProject_Span__c == PROJECT_SPAN_LOCAL)
            queryString+= 'AND Local_Project__c =: projectId';
        
        mapFinancials = new Map<String, IPM_Financial__c>();
        mapFinancialYears = new Map<String, IPM_Financial_Year__c>();
        
        For(IPM_Financial__c financial : Database.query(queryString)){
            mapFinancials.put(financial.Financial_External_ID__c, financial);
            For (IPM_Financial_Year__c financialYear : financial.IPM_Financial_Years__r)
                mapFinancialYears.put(financialYear.External_ID__c, financialYear);
        }
    }
    
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

    private void processFinancialYearRow_SP3(Dom.XmlNode rowNode, String namespace, Integer countIndex, String yearType, String fieldName){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);

            //INNOVATION YEARS
            if(yearType == YEAR_TYPE_INNOVATION){
                if(fieldName == 'Volume' && initialLetter == 'B')
                    processVolumeUnit(colNode, namespace, countIndex);
                else if (initialLetter == 'D')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y0', yearType, null, fieldName);
                else if (initialLetter == 'E')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y1', yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'F')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y2', yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'G')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y3', yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'H')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y1', yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'I')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y2', yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'J')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y3', yearType, PL_TYPE_INCREMENTAL, fieldName);
            } 
            //CALENDAR YEARS
            else {
                if (initialLetter == 'E')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'F')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'G')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'H')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'I')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'J')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_INCREMENTAL, fieldName);
            }
        }
    }

    private void processFinancialYearRow_SP5(Dom.XmlNode rowNode, String namespace, Integer countIndex, String yearType, String fieldName){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);

            //INNOVATION YEARS
            if(yearType == YEAR_TYPE_INNOVATION){
                if(fieldName == 'Volume' && initialLetter == 'B')
                    processVolumeUnit(colNode, namespace, countIndex);
                else if (initialLetter == 'D')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y0', yearType, null, fieldName);
                else if (initialLetter == 'E')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y1', yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'F')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y2', yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'G')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y3', yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'H')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y4', yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'I')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y5', yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'J')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y1', yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'K')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y2', yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'L')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y3', yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'M')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y4', yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'N')
                    processFinancialYearValue(colNode, namespace, countIndex, 'Y5', yearType, PL_TYPE_INCREMENTAL, fieldName);
            } 
            //CALENDAR YEARS
            else {
                if (initialLetter == 'E')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'F')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'G')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'H')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'I')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_GROSS, fieldName);
                else if (initialLetter == 'J')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'K')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'L')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'M')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_INCREMENTAL, fieldName);
                else if (initialLetter == 'N')
                    processFinancialYearValue(colNode, namespace, countIndex, mapYearNames.get(initialLetter), yearType, PL_TYPE_INCREMENTAL, fieldName);
            }
        }
    }

    private void processVolumeUnit(Dom.XmlNode colNode, String namespace, Integer countIndex){
        String externalId = mapFinancialsFromTemplate.get(countIndex);
        IPM_Financial__c ipmFinancial = mapFinancials.get(externalId);


        Integer sharedStringIndex = Integer.valueOf(colNode.getChildElement('v', namespace).getText());
        ipmFinancial.put('Volume_Unit_' + project.IPMProject_Span__c + '__c', mapSharedStringNames.get(sharedStringIndex));

        mapFinancials.put(externalId, ipmFinancial);
    }

    private void processFinancialYearValue(Dom.XmlNode colNode, String namespace, Integer countIndex, String yearName, String yearType, String plType, String fieldName){
        String externalId = mapFinancialsFromTemplate.get(countIndex) + '_' + yearName + '_' + yearType + '_' + plType;
        IPM_Financial_Year__c ipmFinancialYear = mapFinancialYears.get(externalId);
        
        Decimal fieldValue = Decimal.valueOf(colNode.getChildElement('v', namespace).getText());

        ipmFinancialYear.put(fieldName + '_' + project.IPMProject_Span__c + '__c', fieldValue);
        mapFinancialYears.put(externalId, ipmFinancialYear);
    }

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

    private void processNPVRow(Dom.XmlNode rowNode, String namespace, Integer countIndex){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);

            String externalId = mapFinancialsFromTemplate.get(countIndex);
            IPM_Financial__c ipmFinancial = mapFinancials.get(externalId);
    
            if (initialLetter == 'E')
                ipmFinancial.put('NPV_' + project.IPMProject_Span__c + '__c', Decimal.valueOf(colNode.getChildElement('v', namespace).getText()));
            else if (initialLetter == 'H')
                ipmFinancial.put('CAPEX_' + project.IPMProject_Span__c + '__c', Decimal.valueOf(colNode.getChildElement('v', namespace).getText()));

            mapFinancials.put(externalId, ipmFinancial);
        }
    }

    private void processIRRRow(Dom.XmlNode rowNode, String namespace, Integer countIndex){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);

            String externalId = mapFinancialsFromTemplate.get(countIndex);
            IPM_Financial__c ipmFinancial = mapFinancials.get(externalId);
    
            if (initialLetter == 'E')
                ipmFinancial.put('IRR_' + project.IPMProject_Span__c + '__c', Decimal.valueOf(colNode.getChildElement('v', namespace).getText()));
            else if (initialLetter == 'H')
                ipmFinancial.put('BIC_' + project.IPMProject_Span__c + '__c', Decimal.valueOf(colNode.getChildElement('v', namespace).getText()));

            mapFinancials.put(externalId, ipmFinancial);
        }
    }

    private void processPaybackRow(Dom.XmlNode rowNode, String namespace, Integer countIndex){
        For (Dom.XmlNode colNode : rowNode.getChildElements()){
            String cellName = colNode.getAttributeValue('r', null);
            String initialLetter = cellName.subString(0, 1);

            String externalId = mapFinancialsFromTemplate.get(countIndex);
            IPM_Financial__c ipmFinancial = mapFinancials.get(externalId);
    
            if (initialLetter == 'E')
                ipmFinancial.put('Payback_' + project.IPMProject_Span__c + '__c', Decimal.valueOf(colNode.getChildElement('v', namespace).getText()));

            mapFinancials.put(externalId, ipmFinancial);
        }
    }
    
    private void processLastSavedBy(Integer countIndex){
        String externalId = mapFinancialsFromTemplate.get(countIndex);
        IPM_Financial__c ipmFinancial = mapFinancials.get(externalId);

        ipmFinancial.put('Last_Saved_' + project.IPMProject_Span__c + '__c', System.now());
        ipmFinancial.put('Last_Saved_By_' + project.IPMProject_Span__c + '__c', UserInfo.getUserId());
    }
}