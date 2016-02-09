global with sharing class AF_BonusSummaryRemote {
    
    public AF_BonusSummaryRemote(ApexPages.StandardController stdController) {}
    
    @remoteAction
    global static Map<String, String> getBonusMatrixRecords(String agencyId, String bonusSummaryId) {
        
        String ulId, tdOpenTag = '<td>',tdCloseTag = '</td>', trOpenTag = '<tr>', trCloseTag = '</tr>', space = '&nbsp;', lBreak = '<br/>';
        String strongStrt = '<Strong>', strongEnd = '</strong>';
        Set<String> columnsSet = new Set<String>();
        Set<String> rowsSet = new Set<String>();
        Map<String, String> ulbonusMatrixMap  = new Map<String, String>();
        Integer colTotal = 0, colLocalTotal=0, rowTotal = 0, rowLocalTotal=0, rowTotalA = 0, colTotalA = 0;
        
        Map<String, AF_Bonus_Matrix__c> bonusULRelationMap  = new Map<String, AF_Bonus_Matrix__c>();
        List<AF_Bonus_Matrix__c> bonusEstimates  = [SELECT  AF_Agency_Entity__c, AF_Unilever_Entity__c, AF_Agency_Entity__r.AF_Country__c,AF_Unilever_Entity__r.Name,
                                                                AF_Bonus_Summary__c, AF_Value__c, AF_BonusMatrixCode__c, AF_IsCrossBorderImage__c,
                                                                AF_Bonus_Local_Value__c,AF_isCommentImage__c
                                                            FROM AF_Bonus_Matrix__c
                                                         WHERE AF_Bonus_Summary__c =:bonusSummaryId];
        for(AF_Bonus_Matrix__c eachAgencyEstimate : bonusEstimates ) {
            columnsSet.add(eachAgencyEstimate.AF_Agency_Entity__r.AF_Country__c);
            bonusULRelationMap .put(eachAgencyEstimate.AF_Agency_Entity__r.AF_Country__c+'-'+eachAgencyEstimate.AF_Unilever_Entity__r.Name,
                                       eachAgencyEstimate);
            rowsSet.add(eachAgencyEstimate.AF_Unilever_Entity__r.Name);
        }
        List<String> orderedColumn = AF_BrandEstimateRemote.fillList(columnsSet);
        orderedColumn.sort();
        List<String> orderedRow = AF_BrandEstimateRemote.fillList(rowsSet);
        orderedRow.sort();
        Map<String, AF_Entity__c> agencyNameMap = AF_BrandEstimateRemote.getAllAgencyEntities(agencyId);
        Map<String, String> ulNameMap = AF_BrandEstimateRemote.getUnileverEntitiesByName();
        List<String> agenciesToSelect = AF_BrandEstimateRemote.getAgencyEntities(agencyId, bonusSummaryId, 'AF_Bonus_Summary__c'); 
        // These are the Agency Entities which are not created as Agency Estimates.
        List<String> ulEntitiesToSelect = AF_BrandEstimateRemote.getUnileverEntities(bonusSummaryId, 'AF_Bonus_Summary__c'); 
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
            colTotal = 0;colTotalA=0;
            for(String eachRow : orderedRow) {
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(bonusULRelationMap .containsKey(keyMatch)) {
                    /* commented for incident No:INC000097270556 */
                    //colTotal += AF_BrandEstimateRemote.truncateDecimal(bonusULRelationMap .get(keyMatch).AF_Value__c/1000);
                    /* commented for incident No:INC000097270556 */
                    colTotalA += AF_BrandEstimateRemote.truncateDecimal(bonusULRelationMap .get(keyMatch).AF_Value__c);
                    
                }
            }
            /* Added for incident No:INC000097270556 */
            colTotal = AF_BrandEstimateRemote.truncateDecimal(Decimal.valueOf(colTotalA)/1000);
            /* Added for incident No:INC000097270556 */
            String dispColTotal = colTotal > 0 ? 'EUR ' + AF_BrandEstimateRemote.currencyFormatted(colTotal) : '';
            String dispColTotalA = (colTotal > 0) ? 'EUR ' + AF_BrandEstimateRemote.currencyFormatted(colTotalA) : '';
            rowDetail += '<td align=\"center\" title=\"\" class=\"totalCell details-control';
            rowDetail += '\" t=\"' + dispColTotalA + '\" d=\"tot\" a=\"ob\">';
            rowDetail += '<a l e=\"' + dispColTotal + '\">' + strongStrt + dispColTotal + strongEnd + '</a>' + tdCloseTag;
        }
        
        rowDetail += trCloseTag;
        Integer i=2;
        //Display the distinct Columns from the agency estimates.
        for(String eachCol : orderedColumn) {
            colTotal = 0;colTotalA = 0;
            for(String eachRow : orderedRow) {
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(bonusULRelationMap.containsKey(keyMatch)) {
                    colTotal += AF_BrandEstimateRemote.truncateDecimal(bonusULRelationMap.get(keyMatch).AF_Value__c/1000);
                    colTotalA += AF_BrandEstimateRemote.truncateDecimal(bonusULRelationMap.get(keyMatch).AF_Value__c);
                }
            }
            String dispArchiveImg = colTotalA > 0 ?  '' : archiveImg;
            colDetail += '<th id=\'' + i + '\' isDisplay=\'y\'>' + eachCol + dispArchiveImg + '</th>';
            i++;
        }
        /* Columns part is completed. */
        /* Following displays all the rows in the matrix.*/
        for(String eachRow : orderedRow) {
            rowDetail += trOpenTag;
            rowTotal = 0;rowTotalA=0;
            for(String eachCol : orderedColumn) { //Actual Agency Estimate Record's totals goes here..
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(bonusULRelationMap .containsKey(keyMatch)) {
                    /* commented for incident No:INC000097270556 */
                    //rowTotal += AF_BrandEstimateRemote.truncateDecimal(bonusULRelationMap .get(keyMatch).AF_Value__c/1000);
                    /* commented for incident No:INC000097270556 */
                    rowLocalTotal += AF_BrandEstimateRemote.truncateDecimal(bonusULRelationMap .get(keyMatch).AF_Bonus_Local_Value__c/1000);
                    rowTotalA += AF_BrandEstimateRemote.truncateDecimal(bonusULRelationMap .get(keyMatch).AF_Value__c);
                }
            }
            String dispArchiveImg = rowTotalA > 0 ?  '' : archiveImg;
            rowDetail += '<td align=\"center\" class=\"headRow">'+ strongStrt +  eachRow + dispArchiveImg + strongEnd + tdCloseTag;
            /* Added for incident No:INC000097270556 */
            rowTotal = AF_BrandEstimateRemote.truncateDecimal(Decimal.valueOf(rowTotalA)/1000);
            /* Added for incident No:INC000097270556 */
            String dispRowTotal = (rowTotal > 0) ? 'EUR ' + AF_BrandEstimateRemote.currencyFormatted(rowTotal) : '';
            String dispRowTotalA = (rowTotalA > 0) ? 'EUR ' + AF_BrandEstimateRemote.currencyFormatted(rowTotalA) : '';
            rowDetail += '<td title=\"\" class=\"totalCell details-control';
            rowDetail += '\" t=\"' + dispRowTotalA + '\" d=\"tot\" a=\"ob\">';
            rowDetail += '<a l e=\"' + dispRowTotal + '\">' + strongStrt + dispRowTotal + strongEnd + '</a>' + tdCloseTag;
            for(String eachCol : orderedColumn) { //Display the agency estimate records
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(bonusULRelationMap .containsKey(keyMatch)) {
                    rowDetail += processBonusRow(true, bonusULRelationMap .get(keyMatch), bonusULRelationMap , null, null, null);
                }else {
                    String aId = (agencyNameMap != null && agencyNameMap.get(eachCol) != null) ? agencyNameMap.get(eachCol).Id : null;
                    String uId = (ulNameMap != null && ulNameMap.get(eachRow) != null) ? ulNameMap.get(eachRow) : '';
                    rowDetail += processBonusRow(false, null, bonusULRelationMap , aId, uId, bonusSummaryId);
                }
            }
            rowDetail += trCloseTag;
        }
        ulbonusMatrixMap .put('1', colDetail);
        ulbonusMatrixMap .put('2', rowDetail);
        system.debug('** ulbonusMatrixMap  : ' + ulbonusMatrixMap );
        return ulbonusMatrixMap ;
    }
    
    public static String processBonusRow(Boolean isValue, AF_Bonus_Matrix__c agSObj, 
                                        Map<String, AF_Bonus_Matrix__c> bonusULRelationMap, 
                                        String aId, String uId, String bId) {
        String tdOpenTag = '<td>',tdCloseTag = '</td>', trOpenTag = '<tr>', trCloseTag = '</tr>', space = '&nbsp;', lBreak = '<br/>', spacer = ' ';
        String rowDetailToReturn = '';
        String href, title = '';
        if(isValue) {
            Integer total = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Value__c/1000);
            Decimal totalWithoutRounding = agSObj.AF_Value__c/1000;
            Integer totalLocal = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Bonus_Local_Value__c/1000);
            Integer totalA = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Value__c);
            Integer totalLocalA = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Bonus_Local_Value__c);
            String cmntImg =  agSObj.AF_isCommentImage__c != null ? agSObj.AF_isCommentImage__c : '';
            String crsBrdrImg =  agSObj.AF_IsCrossBorderImage__c != null ? agSObj.AF_IsCrossBorderImage__c : '';
            href = 'apex/af_bonusEstimate?id='+agSObj.Id;
            String currCode = agSObj.AF_BonusMatrixCode__c != null ? agSObj.AF_BonusMatrixCode__c : '';
            String disptotal = agSObj.AF_Value__c > 0 ? 'EUR ' + AF_BrandEstimateRemote.currencyFormattedDecimal(total) : '';
            String dispLocalTotal = agSObj.AF_Bonus_Local_Value__c > 0 ? currCode + spacer + AF_BrandEstimateRemote.currencyFormattedDecimal(totalLocal) : '';
            String disptotalA = agSObj.AF_Value__c > 0 ? 'EUR ' + AF_BrandEstimateRemote.currencyFormattedDecimal(totalA) : '';
            String dispLocalTotalA = agSObj.AF_Bonus_Local_Value__c > 0 ? currCode + spacer + AF_BrandEstimateRemote.currencyFormattedDecimal(totalLocalA) : '';
            rowDetailToReturn += '<td title=\"\" class=\"details-control\"';
            rowDetailToReturn += ' t=\"' + disptotalA + '\" d=\"' + dispLocalTotalA + '\" a=\"ob\">';
            rowDetailToReturn += '<a data-src=\"' + href +  '\"';
            rowDetailToReturn += 'data-toggle=\"modal\"';
            rowDetailToReturn += 'data-backdrop=\"static\"';
            rowDetailToReturn += 'data-keyboard=\"false\"';
            rowDetailToReturn += 'data-target=\"#myModal3\"';
            rowDetailToReturn += ' e=\"' + disptotal + '\"';
            rowDetailToReturn += ' l=\"' + dispLocalTotal + '\"';
             rowDetailToReturn += ' class=\"modalButton3\">';
            if(total != 0) {
                rowDetailToReturn += '<div style=float:left;>' + crsBrdrImg + '<br/>' + cmntImg;
                rowDetailToReturn += '</div><div align=\"center\">' + 'EUR ' + AF_BrandEstimateRemote.currencyFormatted(total);
                rowDetailToReturn = totalA != totalLocalA ? rowDetailToReturn + lBreak + currCode + ' ' + AF_BrandEstimateRemote.currencyFormatted(totalLocal) : rowDetailToReturn;
            } else if(totalWithoutRounding > 0 && totalWithoutRounding <= 499){
                rowDetailToReturn += '<div style=float:left;>' + crsBrdrImg + '<br/>' + cmntImg;
                rowDetailToReturn += '</div><div align=\"center\">' + 'EUR 0';
                rowDetailToReturn = totalA != totalLocalA ? rowDetailToReturn + lBreak + currCode + ' ' + AF_BrandEstimateRemote.currencyFormatted(totalLocal) : rowDetailToReturn;
            }else {
                rowDetailToReturn += cmntImg;
            }
            
            rowDetailToReturn += '</div></a>';
            rowDetailToReturn += tdCloseTag;
        }

        system.debug('** rowDetailToReturn : ' + rowDetailToReturn);
        return rowDetailToReturn;
    }
}