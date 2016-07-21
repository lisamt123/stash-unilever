global with sharing class AF_BrandEstimateRemote {
    
    public AF_BrandEstimateRemote(ApexPages.StandardController stdController) {
        
    }
    public static Integer truncateDecimal(Decimal inVal) {
        return Integer.valueOf(inVal.setScale(0, RoundingMode.HALF_UP));
    }
    
    public static String currencyFormatted(Integer inpCurrency) {
        
        List<String> args = new String[]{'0,number,###,###,###'};
        String valueToReturn = inpCurrency > 0 ? String.format(inpCurrency.format(), args) : '0';
        return valueToReturn;
    }
    
    public static String currencyFormattedDecimal(Decimal inpCurrency) {
        
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        String valueToReturn = inpCurrency > 0 ? String.format(inpCurrency.format(), args) : '0';
        return valueToReturn;
    }
    
    public static List<String> fillList(Set<String> strSet) {
        List<String> listToReturn = new List<String>();
        listToReturn.addAll(strSet);
        return listToReturn;
    }
    
    @remoteAction
    global static Map<String, String> getAgencyEstimateRecords(String agencyId, String brandEstimateId) {
        
        String ulId, tdOpenTag = '<td>',tdCloseTag = '</td>', trOpenTag = '<tr>', trCloseTag = '</tr>', space = ' ', lBreak = '<br/>';
        Boolean isLocked = false;
        String strongStrt = '<Strong>', strongEnd = '</strong>';
        Set<String> columnsSet = new Set<String>();
        Set<String> rowsSet = new Set<String>();
        Map<String, String> ulAgenciesMatrixMap = new Map<String, String>();
        Integer colTotal = 0, colTraditional = 0, colDigital = 0, colAdaptation = 0, rowTotal = 0, rowTraditional = 0, rowDigital = 0, rowAdaptation =0;
        Decimal colTotalA = 0, rowTotalA = 0;
        Map<String, AF_Agency_Estimate__c> agencyULRelationMap = new Map<String, AF_Agency_Estimate__c>();
        List<AF_Agency_Estimate__c> agencyEstimates = [SELECT  AF_Agency_Entity__c, AF_Unilever_Entity__c, AF_Agency_Entity__r.AF_Country__c,AF_Unilever_Entity__r.Name,
                                                                AF_Total_Local__c,AF_Total__c, AF_IsCrossborder__c, AF_isComment__c, AF_Brand_Estimate__r.AF_Locked__c,
                                                               Matrix_Currency_Code__c,AF_Brand_Estimate__c, AF_Brand_Estimate__r.AF_Agency__c,AF_IsCrossBorderImage__c,
                                                               AF_Traditional__c, AF_Digital__c, AF_Adaptation__c, AF_isCommentImage__c, AF_Traditional_Local__c, 
                                                               AF_Adaptation_Local__c, AF_Digital_Local__c
                                                            FROM AF_Agency_Estimate__c
                                                         WHERE AF_Brand_Estimate__c =:brandEstimateId];
        for(AF_Agency_Estimate__c eachAgencyEstimate : agencyEstimates) {
            columnsSet.add(eachAgencyEstimate.AF_Agency_Entity__r.AF_Country__c);
            agencyULRelationMap.put(eachAgencyEstimate.AF_Agency_Entity__r.AF_Country__c+'-'+eachAgencyEstimate.AF_Unilever_Entity__r.Name,
                                       eachAgencyEstimate);
            isLocked = eachAgencyEstimate.AF_Brand_Estimate__r.AF_Locked__c;
            rowsSet.add(eachAgencyEstimate.AF_Unilever_Entity__r.Name);
        }
        List<String> orderedColumn = fillList(columnsSet);
        orderedColumn.sort();
        List<String> orderedRow = fillList(rowsSet);
        orderedRow.sort();
        Map<String, AF_Entity__c> agencyNameMap = getAllAgencyEntities(agencyId);
        Map<String, String> ulNameMap = getUnileverEntitiesByName();
        List<String> agenciesToSelect = getAgencyEntities(agencyId, brandEstimateId, 'AF_Brand_Estimate__c'); 
        // These are the Agency Entities which are not created as Agency Estimates.
        List<String> ulEntitiesToSelect = getUnileverEntities(brandEstimateId, 'AF_Brand_Estimate__c'); 
        // These are those Unilever Entities which are not created as a record for Agency Estimates.
        
        system.debug('** agencyNameMap : ' + agencyNameMap);
        system.debug('** agenciesToSelect : ' + agenciesToSelect);
        system.debug('** ulEntitiesToSelect : ' + ulEntitiesToSelect);
        Map<String, String> ulEntityDetails = new Map<String, String>();
        List<String> colOrder = new List<String>();
        String  colDetail = ''; //Column variable which gets added to the map finally.
        String rowDetail = ''; //Row variable which gets added to the map finally.
        String imgPath = AF_Utils.isAgencyUser(UserInfo.getUserId()) ? Label.AF_AgencyUrlLink : Label.AF_UrlLink;
        String archiveImg = '<img class=\"archive\" src="' + imgPath + '/resource/' + AF_Utils.getResourceURL('AF_DataTables') + '/AF_DataTables/AF_DataTables/examples/resources/remove_icon.png"'; 
        archiveImg += ' height="18" width="18" />';
        /* This is the first row of the matrix which actually calculates the Columnwise totals.*/
        rowDetail += trOpenTag;
        rowDetail += '<td class=\"headFirstRow\">' + strongStrt + 'Unilever Entities' + strongEnd + tdCloseTag;
        rowDetail += '<td class=\"totalCell\">' + strongStrt + 'Total' + strongEnd + tdCloseTag;

        for(String eachCol : orderedColumn) { //Actual Agency Estimate Record's totals goes here..
            colTotal = 0;colTraditional = 0;colDigital = 0;colAdaptation = 0;
            for(String eachRow : orderedRow) {
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(agencyULRelationMap.containsKey(keyMatch)) {
                    colTotal += truncateDecimal(agencyULRelationMap.get(keyMatch).AF_Total__c/1000);
                    colTraditional += truncateDecimal(agencyULRelationMap.get(keyMatch).AF_Traditional__c);
                    colDigital += truncateDecimal(agencyULRelationMap.get(keyMatch).AF_Digital__c);
                    colAdaptation += truncateDecimal(agencyULRelationMap.get(keyMatch).AF_Adaptation__c);
                }
            }
            String dispColTotal = colTotal > 0 ? 'EUR ' + currencyFormatted(colTotal) : '';
            String dispColDigital = colDigital > 0 ? 'EUR ' + currencyFormatted(colDigital) : '';
            String dispColTraditional = colTraditional > 0 ? 'EUR ' + currencyFormatted(colTraditional) : '';
            String dispColAdaptation = colAdaptation > 0 ? 'EUR ' + currencyFormatted(colAdaptation) : '';
            rowDetail += '<td align=\"center\" title=\"\" class=\"totalCell details-control" t=\"' + dispColTraditional + '\" d=\"' + dispColDigital;
            rowDetail += '\" a=\"' + dispColAdaptation + '\"><a l e=\"' + dispColTotal + '\">';
            if(colTotal != 0) {
                rowDetail += strongStrt + dispColTotal + strongEnd;
            }
            rowDetail += '</a>' + tdCloseTag;
        }
        rowDetail += trCloseTag;
        Integer i=2;
        //Display the distinct Columns from the agency estimates.
        for(String eachCol : orderedColumn) {
            colTotal = 0;colTotalA = 0;
            for(String eachRow : orderedRow) {
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(agencyULRelationMap.containsKey(keyMatch)) {
                    colTotal += truncateDecimal(agencyULRelationMap.get(keyMatch).AF_Total__c/1000);
                    colTotalA += agencyULRelationMap.get(keyMatch).AF_Total__c;
                }
            }
            String dispArchiveImg = (colTotalA > 0 || isLocked) ?  '' : archiveImg;
            colDetail += '<th id=\'' + i + '\' isDisplay=\'y\'>' + eachCol + dispArchiveImg + '</th>';
            i++;
        }
        /* Columns part is completed. */
        /* Following displays all the rows in the matrix.*/
        for(String eachRow : orderedRow) {
            rowDetail += trOpenTag;
            rowTotal = 0;rowTraditional = 0;rowDigital = 0;rowAdaptation = 0;rowTotalA = 0;
            for(String eachCol : orderedColumn) { //Actual Agency Estimate Record's totals goes here..
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(agencyULRelationMap.containsKey(keyMatch)) {
                    rowTotal += AF_BrandEstimateRemote.truncateDecimal(agencyULRelationMap.get(keyMatch).AF_Total__c/1000);
                    rowTotalA += agencyULRelationMap.get(keyMatch).AF_Total__c;
                    rowTraditional += truncateDecimal(agencyULRelationMap.get(keyMatch).AF_Traditional__c);
                    rowDigital += truncateDecimal(agencyULRelationMap.get(keyMatch).AF_Digital__c);
                    rowAdaptation += truncateDecimal(agencyULRelationMap.get(keyMatch).AF_Adaptation__c);
                }
            }
            String dispArchiveImg = (rowTotalA > 0 || isLocked) ?  '' : archiveImg;
            rowDetail += '<td align=\"center\" class=\"headRow">'+ strongStrt +  eachRow + dispArchiveImg + strongEnd + tdCloseTag;
            String dispRowTotal = (rowTotal > 0) ? 'EUR ' + currencyFormatted(rowTotal) : '';
            String dispRowDigital = rowDigital > 0 ? 'EUR ' + currencyFormatted(rowDigital) : '';
            String dispRowTraditional = rowTraditional > 0 ? 'EUR ' + currencyFormatted(rowTraditional) : '';
            String dispRowAdaptation = rowAdaptation > 0 ? 'EUR ' + currencyFormatted(rowAdaptation) : '';
            rowDetail += '<td align=\"center\" title=\"\" class=\"totalCell mydisplaytotal details-control" t=\"' + dispRowTraditional + '\" d=\"' + dispRowDigital;
            rowDetail += '\" a=\"' + dispRowAdaptation + '\"><a class="margin0" l e=\"' + dispRowTotal + '\">' + strongStrt + dispRowTotal + strongEnd + '</a>' + tdCloseTag;
            for(String eachCol : orderedColumn) { //Display the agency estimate records
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(agencyULRelationMap.containsKey(keyMatch)) {
                    rowDetail += processAgencyRow(true, agencyULRelationMap.get(keyMatch), agencyULRelationMap, null, null, null);
                }else {
                    String aId = (agencyNameMap != null && agencyNameMap.get(eachCol) != null) ? agencyNameMap.get(eachCol).Id : null;
                    String uId = (ulNameMap != null && ulNameMap.get(eachRow) != null) ? ulNameMap.get(eachRow) : '';
                    rowDetail += processAgencyRow(false, null, agencyULRelationMap, aId, uId, brandEstimateId);
                }
            }
            rowDetail += trCloseTag;
        }
        ulAgenciesMatrixMap.put('1', colDetail);
        ulAgenciesMatrixMap.put('2', rowDetail);
        system.debug('** ulAgenciesMatrixMap : ' + ulAgenciesMatrixMap);
        return ulAgenciesMatrixMap;
    }
    
    public static String processAgencyRow(Boolean isValue, AF_Agency_Estimate__c agSObj, 
                                        Map<String, AF_Agency_Estimate__c> agencyULRelationMap, 
                                        String aId, String uId, String bId) {
        String tdOpenTag = '<td>',tdCloseTag = '</td>', trOpenTag = '<tr>', trCloseTag = '</tr>', space = ' ', lBreak = '<br/>', euro = 'EUR';
        String rowDetailToReturn = '';
        String href, title = '';
        if(isValue) {
            String currCode = agSObj.Matrix_Currency_Code__c != null ? agSObj.Matrix_Currency_Code__c : '';
            Integer total = truncateDecimal(agSObj.AF_Total__c/1000);
            Integer totalA = truncateDecimal(agSObj.AF_Total__c);
            Decimal totalWithoutRounding = agSObj.AF_Total__c/1000;
            Integer totalLocal = truncateDecimal(agSObj.AF_Total_Local__c/1000);
            Integer totalLocalA = truncateDecimal(agSObj.AF_Total_Local__c);
            Integer traditionalK =  agSObj.AF_Traditional__c != null ? truncateDecimal(agSObj.AF_Traditional__c/1000) : 0;
            Integer adaptationK =  agSObj.AF_Adaptation__c != null ? truncateDecimal(agSObj.AF_Adaptation__c/1000) : 0; 
            Integer digitalK = agSObj.AF_Digital__c != null ? truncateDecimal(agSObj.AF_Digital__c/1000) : 0;
            Integer traditionalLocalK = agSObj.AF_Traditional_Local__c != null ? truncateDecimal(agSObj.AF_Traditional_Local__c/1000) : 0;
            Integer adaptationLocalK = agSObj.AF_Adaptation_Local__c != null ? truncateDecimal(agSObj.AF_Adaptation_Local__c/1000) : 0;
            Integer digitalLocalK = agSObj.AF_Digital_Local__c != null ? truncateDecimal(agSObj.AF_Digital_Local__c/1000) : 0;
            
            Decimal traditionalA =  agSObj.AF_Traditional__c != null ? agSObj.AF_Traditional__c : 0;
            Decimal adaptationA =  agSObj.AF_Adaptation__c != null ? agSObj.AF_Adaptation__c : 0; 
            Decimal digitalA = agSObj.AF_Digital__c != null ? agSObj.AF_Digital__c : 0;
            Decimal traditionalLocalA = agSObj.AF_Traditional_Local__c != null ? agSObj.AF_Traditional_Local__c : 0;
            Decimal adaptationLocalA = agSObj.AF_Adaptation_Local__c != null ? agSObj.AF_Adaptation_Local__c : 0;
            Decimal digitalLocalA = agSObj.AF_Digital_Local__c != null ? agSObj.AF_Digital_Local__c : 0;
            
            Decimal digital = truncateDecimal(agSObj.AF_Digital__c);
            Decimal adaptation = truncateDecimal(agSObj.AF_Adaptation__c);
            Decimal traditional = truncateDecimal(agSObj.AF_Traditional__c);
            Decimal traditionalLocal = agSObj.AF_Traditional_Local__c != null ? truncateDecimal(agSObj.AF_Traditional_Local__c) : 0;
            Decimal digitalLocal = agSObj.AF_Digital_Local__c != null ? truncateDecimal(agSObj.AF_Digital_Local__c) : 0;
            
            Decimal adaptationLocal = agSObj.AF_Adaptation_Local__c != null ? truncateDecimal(agSObj.AF_Adaptation_Local__c) : 0;
            String dispDigital = digital > 0 ? euro + space + currencyFormattedDecimal(digital) : '';
            String dispTraditional = traditional > 0 ? euro + space + currencyFormattedDecimal(traditional) : '';
            String dispAdaptation = adaptation > 0 ? euro + space + currencyFormattedDecimal(adaptation) : '';
            String dispDigitalLocal = digitalLocal > 0 ? '/' + currCode + space + currencyFormattedDecimal(digitalLocal) : '';
            String dispTraditionalLocal = traditionalLocal > 0 ? '/' + currCode + space + currencyFormattedDecimal(traditionalLocal) : '';
            String dispAdaptationLocal = adaptationLocal > 0 ? '/' + currCode + space + currencyFormattedDecimal(adaptationLocal) : '';
            String dispDigitalK = digitalA > 0 ? euro + space + currencyFormattedDecimal(digitalK) : space;
            String dispTraditionalK = traditionalA > 0 ? euro + space + currencyFormattedDecimal(traditionalK) : space;
            String dispAdaptationK = adaptationA > 0 ? euro + space + currencyFormattedDecimal(adaptationK) : space;
            String dispDigitalLocalK = digitalLocalA > 0 ? '/' + currCode + space + currencyFormattedDecimal(digitalLocalK) : '/' + space;
            String dispTraditionalLocalK = traditionalLocalA > 0 ? '/' + currCode + space + currencyFormattedDecimal(traditionalLocalK) : '/' + space;
            String dispAdaptationLocalK = adaptationLocalA > 0 ? '/' + currCode + space + currencyFormattedDecimal(adaptationLocalK) : '/' + space;
            href = 'apex/af_agencyestimate?id='+agSObj.Id;
            String cmntImg =  agSObj.AF_isCommentImage__c != null ? agSObj.AF_isCommentImage__c : '';
            String crsBrdrImg =  agSObj.AF_IsCrossBorderImage__c != null ? agSObj.AF_IsCrossBorderImage__c : '';
            String dispTotal = totalA > 0 ? euro + space + currencyFormatted(total) : '';
            String dispLocalTotal = totalLocalA > 0 ? currCode + space + currencyFormatted(totalLocal) : '';
            rowDetailToReturn += '<td title=\"\" class=\"details-control\" t=\"' + dispTraditional + dispTraditionalLocal;
            rowDetailToReturn += '\" d=\"' + dispDigital + dispDigitalLocal;
            rowDetailToReturn += '\" tf=\"' + dispTraditionalK + dispTraditionalLocalK;
            rowDetailToReturn += '\" df=\"' + dispDigitalK + dispDigitalLocalK;
            rowDetailToReturn += '\" af=\"' + dispAdaptationK + dispAdaptationLocalK;
            rowDetailToReturn += '\" a=\"' + dispAdaptation + dispAdaptationLocal + '\">';
            rowDetailToReturn += '<a data-src=\"' + href +  '\"';
            rowDetailToReturn += 'data-toggle=\"modal\"';
            rowDetailToReturn += 'data-backdrop=\"static\"';
            rowDetailToReturn += 'data-keyboard=\"false\"';
            rowDetailToReturn += 'data-target=\"#myModal3\"';
            rowDetailToReturn += ' e=\"' + dispTotal + '\" l=\"' + dispLocalTotal + '\"';
            rowDetailToReturn += ' class=\"modalButton3\">';
            if(total != 0) {
                rowDetailToReturn += '<div class="imageHolder" style=\"float:left;height:100%\">' + crsBrdrImg + cmntImg;
                rowDetailToReturn += '</div><div>' + 'EUR ' + currencyFormatted(total);
                rowDetailToReturn = agSObj.AF_Total__c != agSObj.AF_Total_Local__c ? rowDetailToReturn + lBreak + currCode + ' ' + currencyFormatted(totalLocal) : rowDetailToReturn;
            } else if(totalWithoutRounding > 0 && totalWithoutRounding <= 499){
                rowDetailToReturn += '<div style=\"float:left;height:100%\">' + crsBrdrImg + '<br/>' + cmntImg;
                rowDetailToReturn += '</div><div>' + 'EUR 0';
                rowDetailToReturn = agSObj.AF_Total__c != agSObj.AF_Total_Local__c ? rowDetailToReturn + lBreak + currCode + ' ' + currencyFormatted(totalLocal) : rowDetailToReturn;
            } else {
                rowDetailToReturn += cmntImg != null ? cmntImg : ' ';
            }
            
            rowDetailToReturn += '</div></a>';
            rowDetailToReturn += tdCloseTag;
        }

        system.debug('** rowDetailToReturn : ' + rowDetailToReturn);
        return rowDetailToReturn;
    }
    
    public static Map<String, String> getAgencyEntitiesFromName(Set<String> agencyNames, String agencyId) {
        
        Map<String, String> agencyMapToReturn = new Map<String, String>();
        Id agencyRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Agency);
        system.debug(' ** agencyRecordTypeId : ' + agencyRecordTypeId +  ' agencyId ' + agencyId);
        List<AF_Entity__c> agancyEntityList = [SELECT Name From AF_Entity__c 
                                                WHERE RecordTypeId = :agencyRecordTypeId AND
                                                        AF_Agency__c = :agencyId AND Name IN :agencyNames ORDER BY AF_Country__c];
        for(AF_Entity__c eachEntity : agancyEntityList) {
            agencyMapToReturn.put(eachEntity.Name, eachEntity.Id);
        }
        
        return agencyMapToReturn;
    }
    
    public static Map<String, String> getUnileverEntitiesByName() {
        
        Map<String, String> unileverMapToReturn = new Map<String, String>();
        Id ulRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Unilever);
        List<AF_Entity__c> unileverEntityList = [SELECT Name From AF_Entity__c 
                                                WHERE RecordTypeId = :ulRecordTypeId ORDER BY Name];
        for(AF_Entity__c eachEntity : unileverEntityList) {
            unileverMapToReturn.put(eachEntity.Name, eachEntity.Id);
        }
        
        return unileverMapToReturn;
    }
    
    @remoteAction
    global static Map<String, AF_Entity__c> getAllAgencyEntities(String agencyId) {
        
        Map<String, AF_Entity__c> agenciesToReturn = new Map<String, AF_Entity__c>();
        Id agencyRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Agency);
        system.debug(' ** agencyRecordTypeId : ' + agencyRecordTypeId +  ' agencyId ' + agencyId);
        List<AF_Entity__c> agancyEntityList = [SELECT AF_Country__c, Id From AF_Entity__c 
                                                WHERE RecordTypeId = :agencyRecordTypeId AND
                                                        AF_Agency__c = :agencyId and AF_Inactive__c=false ORDER BY AF_Country__c];
        for(AF_Entity__c eachEntity : agancyEntityList) {
            agenciesToReturn.put(eachEntity.AF_Country__c, eachEntity);
        }
        
        return agenciesToReturn;
    }
    
    private static AF_Bonus_Summary__c getBrandSummaryDetails(String brandSummaryId) {
        
        AF_Bonus_Summary__c brandSumObjToReturn = [SELECT Id, Name, AF_Brand__c, AF_Fiscal_Year__c, AF_Agency__c 
                                                       FROM AF_Bonus_Summary__c WHERE Id =:brandSummaryId LIMIT 1];
        return brandSumObjToReturn;
    }
    
    public static List<AF_Agency_Estimate__c> getAgencyEstimates(String brandEstimateId) {
        
        List<AF_Agency_Estimate__c> agencyEstimates = [SELECT  AF_Agency_Entity__c, AF_Agency_Entity__r.AF_Country__c, AF_Brand_Estimate__c, AF_Unilever_Entity__c,
                                                               AF_Brand_Estimate__r.AF_Agency__c 
                                                            FROM AF_Agency_Estimate__c
                                                         WHERE AF_Brand_Estimate__c =:brandEstimateId];
        return agencyEstimates;
    }
    
    public static List<AF_Agency_Estimate__c> archiveAgencyEstimatesPerUnileverEntity(String unileverEntityName, String brandEstimateId) {
        
        system.debug('** unileverEntityName : ' + unileverEntityName);
        List<AF_Agency_Estimate__c> agencyEstimates = [SELECT Id
                                                            FROM AF_Agency_Estimate__c
                                                         WHERE AF_Unilever_Entity__r.Name = :unileverEntityName AND
                                                                AF_Brand_Estimate__c = :brandEstimateId];
        return agencyEstimates;
    }
    
    public static List<AF_OOPS_Estimate__c> archiveOopsEstimatesPerUnileverEntity(String unileverEntityName, String oopsActualId) {
        
        system.debug('** unileverEntityName : ' + unileverEntityName);
        List<AF_OOPS_Estimate__c> oopsEstimates = [SELECT Id
                                                            FROM AF_OOPS_Estimate__c
                                                         WHERE AF_Unilever_Entity__r.Name = :unileverEntityName AND
                                                                AF_OOPS_Actual__c = :oopsActualId];
        return oopsEstimates;
    }
    
    public static List<AF_Bonus_Matrix__c> archiveBonusMatrixPerUnileverEntity(String unileverEntityName, String bonusSummaryId) {
        
        system.debug('** unileverEntityName : ' + unileverEntityName);
        List<AF_Bonus_Matrix__c> bonusMatrices = [SELECT Id
                                                            FROM AF_Bonus_Matrix__c
                                                         WHERE AF_Unilever_Entity__r.Name = :unileverEntityName AND
                                                                AF_Bonus_Summary__c = :bonusSummaryId];
        return bonusMatrices;
    }
    
    public static List<AF_Agency_Estimate__c> archiveAgencyEstimatesPerAgencyEntity(String agencyEntityName, String brandEstimateId) {
        
        system.debug('** agencyEntityName : ' + agencyEntityName);
        List<AF_Agency_Estimate__c> agencyEstimates = [SELECT  Id
                                                            FROM AF_Agency_Estimate__c
                                                         WHERE AF_Agency_Entity__r.AF_Country__c = :agencyEntityName AND
                                                                AF_Brand_Estimate__c = :brandEstimateId];
        return agencyEstimates;
    }
    
    public static List<AF_OOPS_Estimate__c> archiveOopsEstimatesPerAgencyEntity(String agencyEntityName, String oopsActualId) {
        
        system.debug('** agencyEntityName : ' + agencyEntityName);
        List<AF_OOPS_Estimate__c> oopsEstimates = [SELECT  Id
                                                            FROM AF_OOPS_Estimate__c
                                                         WHERE AF_Agency_Entity__r.AF_Country__c = :agencyEntityName AND
                                                                AF_OOPS_Actual__c = :oopsActualId];
        return oopsEstimates;
    }
    
    public static List<AF_Bonus_Matrix__c> archiveBonusMatrixPerAgencyEntity(String agencyEntityName, String bonusSummaryId) {
        
        system.debug('** agencyEntityName : ' + agencyEntityName);
        List<AF_Bonus_Matrix__c> bonusMatrices = [SELECT Id
                                                            FROM AF_Bonus_Matrix__c
                                                         WHERE AF_Agency_Entity__r.AF_Country__c = :agencyEntityName AND
                                                                AF_Bonus_Summary__c = :bonusSummaryId];
        return bonusMatrices;
    }
    
    public static List<AF_OOPS_Estimate__c> getOopsEstimates(String oopsActualId) {
        
        List<AF_OOPS_Estimate__c> oopsEstimates = [SELECT  AF_Agency_Entity__c, AF_Agency_Entity__r.AF_Country__c, AF_OOPS_Actual__c, AF_Unilever_Entity__c
                                                            FROM AF_OOPS_Estimate__c 
                                                         WHERE AF_OOPS_Actual__c =:oopsActualId];
        return oopsEstimates;
    }
    
    public static List<AF_Bonus_Matrix__c> getBonusMatrices(String bonusSummaryId) {
        
        List<AF_Bonus_Matrix__c> bonusMatrices = [SELECT  AF_Agency_Entity__c, AF_Agency_Entity__r.AF_Country__c, AF_Bonus_Summary__c, AF_Unilever_Entity__c
                                                            FROM AF_Bonus_Matrix__c 
                                                         WHERE AF_Bonus_Summary__c =:bonusSummaryId];
        return bonusMatrices;
    }
    
    public static List<AF_Agency_Estimate__c> getULBrandEstimates(String brandEstimateId) {
        List<AF_Agency_Estimate__c> ulEstimates = [SELECT AF_Unilever_Entity__r.Name
                                                            FROM AF_Agency_Estimate__c
                                                         WHERE AF_Brand_Estimate__c =:brandEstimateId];
        return ulEstimates;
    }
    
    
    public static List<AF_OOPS_Estimate__c> getULOopsEstimates(String oopsActualId) {
        List<AF_OOPS_Estimate__c> ulEstimates = [SELECT AF_Unilever_Entity__r.Name
                                                            FROM AF_OOPS_Estimate__c
                                                         WHERE AF_OOPS_Actual__c =:oopsActualId];
        return ulEstimates;
    }
    
    public static List<AF_Bonus_Matrix__c> getULBonusEstimates(String bonusSummaryId) {
        List<AF_Bonus_Matrix__c> ulEstimates = [SELECT AF_Unilever_Entity__r.Name
                                                            FROM AF_Bonus_Matrix__c
                                                         WHERE AF_Bonus_Summary__c =:bonusSummaryId];
        return ulEstimates;
    }
    
     public static Map<String, String> getEntityIds(List<String> entityNames, Id recordType, String agencyId) {
        
        Map<String, String> mapToReturn = new Map<String, String>();
        system.debug('** recordType : ' + recordType + ' :: ' + entityNames);
        List<AF_Entity__c> entityList = new List<AF_Entity__c>();
        system.debug('SELECT Name FROM AF_Entity__c ' + 'WHERE RecordTypeId = ' + recordType + ' AND Name IN ' + entityNames + ' AND AF_Agency__c = ' + agencyId);
        if(agencyId != null) {
            entityList = [SELECT AF_Country__c FROM AF_Entity__c 
                                                    WHERE RecordTypeId = :recordType AND AF_Country__c IN :entityNames AND AF_Agency__c = :agencyId and af_inactive__c=false];
            for(AF_Entity__c eachEntity : entityList) {
                mapToReturn.put(eachEntity.AF_Country__c, eachEntity.Id);
            }
        }else {
            entityList = [SELECT Name FROM AF_Entity__c 
                                                    WHERE RecordTypeId = :recordType AND Name IN :entityNames];
            for(AF_Entity__c eachEntity : entityList) {
                mapToReturn.put(eachEntity.Name, eachEntity.Id);
            }
        }
        
        system.debug('** mapToReturn : ' + mapToReturn);
        return mapToReturn;
    }
    
    @remoteAction
    global static List<String> getAgencyEntities(String agencyId, String sObjectId, String sobjectName) {
        
        List<String> agenciesToReturn = new List<String>();
        Set<String> estimatesSet = new Set<String>();
        Id agencyRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Agency);
        List<AF_Entity__c> agancyEntityList = [SELECT AF_Country__c From AF_Entity__c 
                                                WHERE RecordTypeId = :agencyRecordTypeId AND
                                                        AF_Agency__c = :agencyId and af_inactive__c=false ORDER BY AF_Country__c];
        if(sobjectName == 'AF_Brand_Estimate__c') {
            for(AF_Agency_Estimate__c eachAgencyEstimate : getAgencyEstimates(sObjectId)) {
                estimatesSet.add(eachAgencyEstimate.AF_Agency_Entity__r.AF_Country__c);
            }
        } else if(sobjectName == 'AF_OOPS_Actual__c') {
            for(AF_OOPS_Estimate__c oopsEstimates : getOopsEstimates(sObjectId)) {
                estimatesSet.add(oopsEstimates.AF_Agency_Entity__r.AF_Country__c);
            }
        }
        for(AF_Entity__c eachEntity : agancyEntityList) {
            if(!estimatesSet.contains(eachEntity.AF_Country__c)) {
                agenciesToReturn.add(eachEntity.AF_Country__c);
            }
        }
        system.debug('** estimatesSet : ' + estimatesSet);
        system.debug('** agenciesToReturn : ' + agenciesToReturn);
        return agenciesToReturn;
    }
    
    @remoteAction
    global static List<String> getUnileverEntities(String sObjectId, String sobjectName) {
        
        List<String> unileverToReturn = new List<String>();
        Set<String> estimatesSet = new Set<String>();
        Id ulRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Unilever);
        List<AF_Entity__c> unileverEntityList = [SELECT Name From AF_Entity__c 
                                                    WHERE RecordTypeId = :ulRecordTypeId ORDER BY Name];

        if(sobjectName == 'AF_Brand_Estimate__c') {
            for(AF_Agency_Estimate__c eachAgencyEstimate : getULBrandEstimates(sObjectId)) {
                estimatesSet.add(eachAgencyEstimate.AF_Unilever_Entity__r.Name);
            }
        } else if(sobjectName == 'AF_OOPS_Actual__c') {
            for(AF_OOPS_Estimate__c oopsEstimates : getULOopsEstimates(sObjectId)) {
                estimatesSet.add(oopsEstimates.AF_Unilever_Entity__r.Name);
            }
        } else if(sobjectName == 'AF_Bonus_Summary__c') {
            for(AF_Bonus_Matrix__c bonusEstimates : getULBonusEstimates(sObjectId)) {
                estimatesSet.add(bonusEstimates.AF_Unilever_Entity__r.Name);
            }
        }
        system.debug('** estimatesSet : ' + estimatesSet + ' ' + unileverEntityList);
        for(AF_Entity__c eachEntity : unileverEntityList) {
            if(!estimatesSet.contains(eachEntity.Name)) {
                unileverToReturn.add(eachEntity.Name);
            }
        }
        
        return unileverToReturn;
    }
    
    @remoteAction
    global static void addAgencyEntityToEstimates(String sObjectId, String sobjectName, List<String> rowsArr, String agencyId) {
        
        AF_Bonus_Summary__c brandsObj;
        Map<String, String> brMap;
        Id ulRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Unilever);
        List<AF_Agency_Estimate__c> entityListsToCreate = new List<AF_Agency_Estimate__c>();
        List<AF_OOPS_Estimate__c> entityOopsListsToCreate = new List<AF_OOPS_Estimate__c>();
        List<AF_Bonus_Matrix__c> entityBonusListsToCreate = new List<AF_Bonus_Matrix__c>();
        Map<String, String> agULMap = new Map<String, String>();
        Set<String> columnsSet = new Set<String>();
        
        if(sobjectName == 'AF_Brand_Estimate__c') {
            for(AF_Agency_Estimate__c eachEst : getAgencyEstimates(sObjectId)) {
                columnsSet.add(eachEst.AF_Agency_Entity__c);
                agULMap.put(eachEst.AF_Agency_Entity__c+'-'+eachEst.AF_Unilever_Entity__c, eachEst.AF_Agency_Entity__c);
            }
        }else if(sobjectName == 'AF_OOPS_Actual__c') {
            for(AF_OOPS_Estimate__c eachEst : getOopsEstimates(sObjectId)) {
                columnsSet.add(eachEst.AF_Agency_Entity__c);
                agULMap.put(eachEst.AF_Agency_Entity__c+'-'+eachEst.AF_Unilever_Entity__c, eachEst.AF_Agency_Entity__c);
            }
        }else if(sobjectName == 'AF_Bonus_Summary__c') {
            for(AF_Bonus_Matrix__c eachEst : getBonusMatrices(sObjectId)) {
                columnsSet.add(eachEst.AF_Agency_Entity__c);
                agULMap.put(eachEst.AF_Agency_Entity__c+'-'+eachEst.AF_Unilever_Entity__c, eachEst.AF_Agency_Entity__c);
            }
        }
        Map<String, String> rowNameMap = getEntityIds(rowsArr, ulRecordTypeId, null);
        Set<String> rowsSet = new Set<String>();
        if(sobjectName == 'AF_Bonus_Summary__c'){
            rowsSet.addAll(rowNameMap.values());
            brandsObj = getBrandSummaryDetails(sObjectId);
            
            //Calling method to create Thresholds
            createThresholds(rowsArr, brandsObj);
            
            brMap = getBonusResultsMap(rowsSet, brandsObj);        
        }

        
        for(String eachRow : rowsArr) {
            for(String eachCol : columnsSet) {
                String key = eachCol+'-'+rowNameMap.get(eachRow);
                if(sobjectName == 'AF_Brand_Estimate__c' && !agULMap.containsKey(key)) {
                    entityListsToCreate.add(buildAgencyEstimate(eachCol, rowNameMap.get(eachRow), sObjectId));
                    agULMap.put(key, key);
                }else if(!agULMap.containsKey(key) && sobjectName == 'AF_OOPS_Actual__c') {
                    entityOopsListsToCreate.add(buildOopsEstimate(eachCol, rowNameMap.get(eachRow), sObjectId));
                    agULMap.put(key, key);
                }else if(!agULMap.containsKey(key) && sobjectName == 'AF_Bonus_Summary__c') {
                    system.debug(' **eachCol ' + eachCol + '::' + rowNameMap.get(eachRow) + '::' +  sObjectId + '::' + brMap.get(rowNameMap.get(eachRow)));
                    if(brMap.get('IsPilot')=='IsPilot'){
                    entityBonusListsToCreate.add(buildBonusMatrix(eachCol, rowNameMap.get(eachRow), sObjectId, brMap.get('Null')));
                    agULMap.put(key, key);
                    }else{
                    entityBonusListsToCreate.add(buildBonusMatrix(eachCol, rowNameMap.get(eachRow), sObjectId, brMap.get(rowNameMap.get(eachRow))));
                    agULMap.put(key, key);
                    }
                                   
                    
                }
            }
        }
        
        if(sobjectName == 'AF_Brand_Estimate__c') {
            system.debug('** entityListsToCreate : ' + entityListsToCreate);
            insert entityListsToCreate;
        }else if(sobjectName == 'AF_OOPS_Actual__c'){
            system.debug('** entityOopsListsToCreate : ' + entityOopsListsToCreate);
            insert entityOopsListsToCreate;
        }else if(sobjectName == 'AF_Bonus_Summary__c'){
            system.debug('** entityBonusListsToCreate : ' + entityBonusListsToCreate);
            insert entityBonusListsToCreate;
        }
    }
    
    @remoteAction
    global static void archiveAgencyEntityToEstimates(String sObjectId, String sobjectName, String rowName) {
        
        system.debug('** sObjectId : ' + sObjectId + ' :: sobjectName : ' + sobjectName + ' :: rowName : ' + rowName);
        AF_Bonus_Summary__c brandsObj;
        Map<String, String> brMap;
        Id ulRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Unilever);
        List<AF_Agency_Estimate__c> agencyEstimatesToDelete = new List<AF_Agency_Estimate__c>();
        List<AF_OOPS_Estimate__c> oopsEstimatesToDelete = new List<AF_OOPS_Estimate__c>();
        List<AF_Bonus_Matrix__c> bonusMatrixToDelete = new List<AF_Bonus_Matrix__c>();
        if(sobjectName == 'AF_Brand_Estimate__c') {
            for(AF_Agency_Estimate__c eachAgencyEstimate : archiveAgencyEstimatesPerUnileverEntity(rowName, sObjectId)) {
                agencyEstimatesToDelete.add(eachAgencyEstimate);
            }
            try{
            delete agencyEstimatesToDelete;
            }
            catch(Exception e){
                system.debug(e);
            }
        }else if(sobjectName == 'AF_OOPS_Actual__c') {
            for(AF_OOPS_Estimate__c eachOopsEstimate : archiveOopsEstimatesPerUnileverEntity(rowName, sObjectId)) {
                system.debug(' ** eachOopsEstimate : ' + eachOopsEstimate);
                oopsEstimatesToDelete.add(eachOopsEstimate);
            }
            system.debug('** oopsEstimatesToDelete : ' + oopsEstimatesToDelete);
            delete oopsEstimatesToDelete;
        }else if(sobjectName == 'AF_Bonus_Summary__c') {
            for(AF_Bonus_Matrix__c eachBonusMatrix : archiveBonusMatrixPerUnileverEntity(rowName, sObjectId)) {
                bonusMatrixToDelete.add(eachBonusMatrix);
            }
            delete bonusMatrixToDelete;
        }
    }
    
    @remoteAction
    global static void archiveUnileverEntityToEstimates(String sObjectId, String sObjectName, String colsArr, String agencyId) {
        
        AF_Bonus_Summary__c brandsObj;
        Map<String, String> brMap;
        Id agRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Agency);
        List<AF_Agency_Estimate__c> agencyEstimatesToDelete = new List<AF_Agency_Estimate__c>();
        List<AF_OOPS_Estimate__c> oopsEstimatesToDelete = new List<AF_OOPS_Estimate__c>();
        List<AF_Bonus_Matrix__c> bonusMatrixToDelete = new List<AF_Bonus_Matrix__c>();
        if(sobjectName == 'AF_Brand_Estimate__c') {
            for(AF_Agency_Estimate__c eachAgencyEstimate : archiveAgencyEstimatesPerAgencyEntity(colsArr, sObjectId)) {
                agencyEstimatesToDelete.add(eachAgencyEstimate);
            }
            try{
            delete agencyEstimatesToDelete;
            }
            catch(Exception e){
                system.debug(e);
            }
        }else if(sobjectName == 'AF_OOPS_Actual__c') {
            for(AF_OOPS_Estimate__c eachOopsEstimate : archiveOopsEstimatesPerAgencyEntity(colsArr, sObjectId)) {
                oopsEstimatesToDelete.add(eachOopsEstimate);
            }
            try{
            delete oopsEstimatesToDelete;
            }
            catch(Exception e){
                system.debug(e);
            }
        }else if(sobjectName == 'AF_Bonus_Summary__c') {
            for(AF_Bonus_Matrix__c eachBonusMatrix : archiveBonusMatrixPerAgencyEntity(colsArr, sObjectId)) {
                bonusMatrixToDelete.add(eachBonusMatrix);
            }
            delete bonusMatrixToDelete;
        }
    }
    
    @remoteAction
    global static void addUnileverEntityToEstimates(String sObjectId, String sObjectName, List<String> colsArr, String agencyId) {
        
        system.debug('** colsArr : ' + colsArr);
        AF_Bonus_Summary__c brandsObj;
        Map<String, String> brMap;
        Id agRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Agency);
        List<AF_Agency_Estimate__c> entityListsToCreate = new List<AF_Agency_Estimate__c>();
        List<AF_OOPS_Estimate__c> entityOopsListsToCreate = new List<AF_OOPS_Estimate__c>();
        List<AF_Bonus_Matrix__c> entityBonusListsToCreate = new List<AF_Bonus_Matrix__c>();
        Map<String, String> colNameMap = getEntityIds(colsArr, agRecordTypeId, agencyId);
        Map<String, String> agULMap = new Map<String, String>();
        Set<String> rowsSet = new Set<String>();
        if(sobjectName == 'AF_Brand_Estimate__c') {
            for(AF_Agency_Estimate__c eachEst : getAgencyEstimates(sObjectId)) {
                rowsSet.add(eachEst.AF_Unilever_Entity__c);
                agULMap.put(eachEst.AF_Agency_Entity__c+'-'+eachEst.AF_Unilever_Entity__c, eachEst.AF_Unilever_Entity__c);
            }
        }else if(sobjectName == 'AF_OOPS_Actual__c') {
            for(AF_OOPS_Estimate__c eachEst : getOopsEstimates(sObjectId)) {
                rowsSet.add(eachEst.AF_Unilever_Entity__c);
                agULMap.put(eachEst.AF_Agency_Entity__c+'-'+eachEst.AF_Unilever_Entity__c, eachEst.AF_Unilever_Entity__c);
            }
        }else if(sobjectName == 'AF_Bonus_Summary__c') {
            for(AF_Bonus_Matrix__c eachEst : getBonusMatrices(sObjectId)) {
                rowsSet.add(eachEst.AF_Unilever_Entity__c);
                agULMap.put(eachEst.AF_Agency_Entity__c+'-'+eachEst.AF_Unilever_Entity__c, eachEst.AF_Unilever_Entity__c);
            }
        }
        
        if(sobjectName == 'AF_Bonus_Summary__c'){
            brandsObj = getBrandSummaryDetails(sObjectId);
            brMap = getBonusResultsMap(rowsSet, brandsObj);
        }
        system.debug('** brMap : ' + brMap);
        for(String eachCol : colsArr) {
            for(String eachRow : rowsSet) {
                String key = colNameMap.get(eachCol)+'-'+eachRow;
                if(sobjectName == 'AF_Brand_Estimate__c' && !agULMap.containsKey(key)) {
                    entityListsToCreate.add(buildAgencyEstimate(colNameMap.get(eachCol), eachRow, sObjectId));
                    agULMap.put(key, key);
                }else if(!agULMap.containsKey(key) && sobjectName == 'AF_OOPS_Actual__c') {
                    entityOopsListsToCreate.add(buildOopsEstimate(colNameMap.get(eachCol), eachRow, sObjectId));
                    agULMap.put(key, key);
                }else if(!agULMap.containsKey(key) && sobjectName == 'AF_Bonus_Summary__c') {
                    system.debug('** brMap.get(eachRow) : ' + brMap.get(eachRow) + ' :: ' + eachRow);
                    if(brMap.get('IsPilot')=='IsPilot'){
                    entityBonusListsToCreate.add(buildBonusMatrix(colNameMap.get(eachCol), eachRow, sObjectId, brMap.get('Null')));
                    agULMap.put(key, key);
                    }else{
                     entityBonusListsToCreate.add(buildBonusMatrix(colNameMap.get(eachCol), eachRow, sObjectId, brMap.get(eachRow)));
                    agULMap.put(key, key);
                    }
                   
                }
            }
        }
        
        if(sobjectName == 'AF_Brand_Estimate__c') {
            system.debug('** entityListsToCreate : ' + entityListsToCreate);
            insert entityListsToCreate;
        }else if(sobjectName == 'AF_OOPS_Actual__c'){
            system.debug('** entityOopsListsToCreate : ' + entityOopsListsToCreate);
            insert entityOopsListsToCreate;
        }else if(sobjectName == 'AF_Bonus_Summary__c'){
            system.debug('** entityBonusListsToCreate : ' + entityBonusListsToCreate);
            insert entityBonusListsToCreate;
        }
    }
    
    @remoteAction
    global static void addSingleULAGEntity(String sObjectId, String sObjectName, String rowName, String colName, String agencyId) {
        
        List<String> colsArr = new List<String>{colName};
        String bonusResultId;
        AF_Bonus_Summary__c brandsObj;
        Map<String, String> brMap;
        List<String> rowsArr = new List<String>{rowName};
        Id agRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Agency);
        Id ulRecordTypeId = AF_Utils.getEntityRecordId(Label.Entity_RT_Unilever);
        Set<String> rowsIdSet = new Set<String>();
        List<AF_Agency_Estimate__c> entityListsToCreate = new List<AF_Agency_Estimate__c>();
        List<AF_Bonus_Matrix__c> entityBonusListsToCreate = new List<AF_Bonus_Matrix__c>();
        Map<String, String> colNameMap = getEntityIds(colsArr, agRecordTypeId, agencyId);
        Map<String, String> rowNameMap = getEntityIds(rowsArr, ulRecordTypeId, null);
        if(sobjectName == 'AF_Bonus_Summary__c'){
            brandsObj = getBrandSummaryDetails(sObjectId);
            brMap = getBonusResultsMap(rowsIdSet, brandsObj);
        }
        system.debug('** colNameMap : ' + colNameMap);
        system.debug('** rowNameMap : ' + rowNameMap);
        Map<String, String> agULMap = new Map<String, String>();
        for(String eachRow : rowNameMap.values()) {
            rowsIdSet.add(eachRow);
        }
        
        for(String eachCol : colsArr) {
            for(String eachRow : rowsArr) {
                String key = eachCol+'-'+eachRow;
                if(!agULMap.containsKey(key) && sobjectName == 'AF_Brand_Estimate__c') {
                    entityListsToCreate.add(buildAgencyEstimate(colNameMap.get(eachCol), rowNameMap.get(eachRow), sObjectId));
                    agULMap.put(key, key);
                }else if(!agULMap.containsKey(key) && sobjectName == 'AF_Bonus_Summary__c') {
                    system.debug('** eachRow : ' + eachRow + ' :: ' + rowNameMap.get(eachRow));
                    
                    if(brMap.get('IsPilot')=='IsPilot'){
                   entityBonusListsToCreate.add(buildBonusMatrix(colNameMap.get(eachCol), rowNameMap.get(eachRow), sObjectId, brMap.get('Null')));
                    agULMap.put(key, key);
                    }else{
                     entityBonusListsToCreate.add(buildBonusMatrix(colNameMap.get(eachCol), rowNameMap.get(eachRow), sObjectId, brMap.get(eachRow)));
                    agULMap.put(key, key);
                    }
                   
                }
            }
        }
        
        if(sobjectName == 'AF_Brand_Estimate__c') {
            system.debug('** entityListsToCreate : ' + entityListsToCreate);
            insert entityListsToCreate;
        }else if(sobjectName == 'AF_Bonus_Summary__c'){
            system.debug('** entityBonusListsToCreate : ' + entityBonusListsToCreate);
            insert entityBonusListsToCreate;
        }
        
    }

    
    private static Map<String, String> getBonusResultsMap(Set<String> rowsIdsSet, AF_Bonus_Summary__c brandsObj) {
        
        Map<String, String> bRMapToReturn = new Map<String, String>();
        Id bRRecordTypeId = AF_Utils.getBonusResRecordId(Label.Bonus_Annual);
        Set<Id> brIdsSet = new Set<Id>();
        Boolean isPilotmodel2=false;
        List<AF_Bonus_Threshold__c> bonusTHList=new  List<AF_Bonus_Threshold__c>();
        List<AF_Bonus_Results__c> bonusResultsToCreate = new List<AF_Bonus_Results__c>();

         for(AF_Brand_Estimate__c brandEstimate :[Select Id,AF_Pilot_Model__c  from AF_Brand_Estimate__c 
                                                    where AF_Active__c = true
                                                    AND AF_Agency__c =:brandsObj.AF_Agency__c
                                                    AND Brand__c=: brandsObj.AF_Brand__c
                                                    AND AF_Fiscal_Year__c =:brandsObj.AF_Fiscal_Year__c 
                                                    AND AF_Pilot_Model__c = true]){
            if(brandEstimate .AF_Pilot_Model__c ==true){
            isPilotmodel2 = true;
            }
        }
        if(isPilotmodel2==true){
         bonusTHList = [SELECT AF_Country__c, AF_Country__r.AF_Country__c, 
                                                            (SELECT Name FROM Bonus_Results__r WHERE RecordTypeId = :bRRecordTypeId LIMIT 1)
                                                            FROM AF_Bonus_Threshold__c 
                                                            WHERE  AF_Country__c =Null and 
                                                                   Agency_Name__c =:brandsObj.AF_Agency__c AND  
                                                                   Brand_Name__c =:brandsObj.AF_Brand__c AND  
                                                                   Year__c =:brandsObj.AF_Fiscal_Year__c];
              }else{ 
              system.debug('hi...'); 
              system.debug('rowsIdsSet'+rowsIdsSet);
                bonusTHList = [SELECT AF_Country__c, AF_Country__r.AF_Country__c, 
                                                            (SELECT Name FROM Bonus_Results__r WHERE RecordTypeId = :bRRecordTypeId LIMIT 1)
                                                            FROM AF_Bonus_Threshold__c 
                                                            WHERE  AF_Country__c IN :rowsIdsSet AND
                                                                   Agency_Name__c =:brandsObj.AF_Agency__c AND  
                                                                   Brand_Name__c =:brandsObj.AF_Brand__c AND  
                                                                   Year__c =:brandsObj.AF_Fiscal_Year__c];
                    }   
        system.debug('** brandsObj : ' + brandsObj);
        system.debug('bonusTHList '+bonusTHList );
        for(String eachRow : rowsIdsSet) {
            for(AF_Bonus_Threshold__c eachBonusTH : bonusTHList) {
                system.debug('** eachBonusTH.Bonus_Results__r : ' + eachBonusTH.Bonus_Results__r);
                if(eachBonusTH.AF_Country__c ==null && eachBonusTH.Bonus_Results__r.size() != 0){
                bRMapToReturn.put('Null', eachBonusTH.Bonus_Results__r[0].Id);
                }
                else{
                 bRMapToReturn.put(eachBonusTH.AF_Country__c, eachBonusTH.Bonus_Results__r[0].Id);
                }
                /*if(eachBonusTH.AF_Country__c == eachRow && eachBonusTH.Bonus_Results__r.size() != 0) {
                    bRMapToReturn.put(eachBonusTH.AF_Country__c, eachBonusTH.Bonus_Results__r[0].Id);
                }*/
            }
            
           
        }
        if(isPilotmodel2==true){
        bRMapToReturn.put('IsPilot', 'IsPilot');
        }
        system.debug('bRMapToReturn --- '+bRMapToReturn);
        return bRMapToReturn;
    }
    
    private static AF_Bonus_Matrix__c buildBonusMatrix(String agencyEntityId, String ulEntityId, String bonusSummaryId, String bonusResultId) {
        AF_Bonus_Matrix__c bonusMatrixToReturn = new AF_Bonus_Matrix__c();
        bonusMatrixToReturn.AF_Bonus_Summary__c = bonusSummaryId;
        bonusMatrixToReturn.AF_Agency_Entity__c = agencyEntityId;
        bonusMatrixToReturn.AF_Unilever_Entity__c = ulEntityId;
        bonusMatrixToReturn.AF_Value__c = 0;
        bonusMatrixToReturn.AF_Bonus_Results__c = bonusResultId;
        system.debug('** bonusMatrixToReturn : ' + bonusMatrixToReturn);
        return bonusMatrixToReturn;
    }
    
    private static AF_Bonus_Results__c buildBonusResult(String bonusThreshold) {
        AF_Bonus_Results__c bonusResultToReturn = new AF_Bonus_Results__c();
        bonusResultToReturn.AF_Bonus_Thresholds__c = bonusThreshold;
        return bonusResultToReturn;
    }
    
    public static AF_Agency_Estimate__c buildAgencyEstimate(String agencyEntityId, String ulEntityId, String brandEstimateId) {
        system.debug('** rowId : ' + ulEntityId);
        AF_Agency_Estimate__c agEstToReturn = new AF_Agency_Estimate__c();
        agEstToReturn.AF_Brand_Estimate__c = brandEstimateId;
        agEstToReturn.AF_Agency_Entity__c = agencyEntityId;
        agEstToReturn.AF_Unilever_Entity__c = ulEntityId;
        agEstToReturn.AF_Traditional__c = 0;
        agEstToReturn.AF_Digital__c = 0;
        agEstToReturn.AF_Adaptation__c = 0;
        agEstToReturn.bReqValidation__c = true;
        return agEstToReturn;
    }
    
    public static AF_OOPS_Estimate__c buildOopsEstimate(String agencyEntityId, String ulEntityId, String oopsActualId) {
        system.debug('** rowId : ' + ulEntityId);
        AF_OOPS_Estimate__c oopsEstToReturn = new AF_OOPS_Estimate__c();
        oopsEstToReturn.AF_OOPS_Actual__c = oopsActualId;
        oopsEstToReturn.AF_Agency_Entity__c = agencyEntityId;
        oopsEstToReturn.AF_Unilever_Entity__c = ulEntityId;
        oopsEstToReturn.AF_Estimate__c = 0;
        return oopsEstToReturn;
    }
    
    //Method to create Thresholds
    private static void createThresholds(List<String> lstCountry, AF_Bonus_Summary__c brandsObj){   
        List<AF_Bonus_Threshold__c> lstBonusThresholdToInsert = new List<AF_Bonus_Threshold__c>();
        Map<Id, AF_Entity__c> mapEntity = new Map<Id, AF_Entity__c>();
        Boolean isPilotModel = false;
        
        for(AF_Brand_Estimate__c brandEstimate :[Select Id,AF_Pilot_Model__c  from AF_Brand_Estimate__c 
                                                    where AF_Active__c = true
                                                    AND AF_Agency__c =:brandsObj.AF_Agency__c
                                                    AND Brand__c=: brandsObj.AF_Brand__c
                                                    AND AF_Fiscal_Year__c =:brandsObj.AF_Fiscal_Year__c 
                                                    AND AF_Pilot_Model__c = true]){
            if(brandEstimate .AF_Pilot_Model__c==true ){
             isPilotModel = true;
            }
           
        }
        
        if(!isPilotModel){
            for(AF_Entity__c entity : [Select Id, AF_Country__c from AF_Entity__c 
                                        where AF_Country__c IN : lstCountry AND
                                        RecordType.Name = 'Unilever Entity']){
                mapEntity.put(entity.Id, entity);
            }

            for(Id entityId : mapEntity.keySet()){
                AF_Bonus_Threshold__c bonusThreshold = new AF_Bonus_Threshold__c();
                bonusThreshold.Name = brandsObj.Name+'_'+mapEntity.get(entityId).AF_Country__c;
                bonusThreshold.Agency_Name__c = brandsObj.AF_Agency__c;
                bonusThreshold.Brand_Name__c = brandsObj.AF_Brand__c;
                bonusThreshold.Year__c = brandsObj.AF_Fiscal_Year__c;
                bonusThreshold.AF_Country__c = entityId;
                lstBonusThresholdToInsert.add(bonusThreshold);
            }
            system.debug('lstBonusThresholdToInsert ----- '+lstBonusThresholdToInsert);
            
            if(!lstBonusThresholdToInsert.isEmpty()){
                insert lstBonusThresholdToInsert;
            }
       }
    }
}