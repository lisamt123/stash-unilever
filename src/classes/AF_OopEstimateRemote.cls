global with sharing class AF_OopEstimateRemote {
    
    public AF_OopEstimateRemote(ApexPages.StandardController stdController) {}
    
    @remoteAction
    global static Map<String, String> getOOPSEstimateRecords(String agencyId, String oopsActualId) {
        
        String ulId, tdOpenTag = '<td>',tdCloseTag = '</td>', trOpenTag = '<tr>', trCloseTag = '</tr>', space = '&nbsp;', lBreak = '<br/>';
        String strongStrt = '<Strong>', strongEnd = '</strong>';
        Set<String> columnsSet = new Set<String>();
        Set<String> rowsSet = new Set<String>();
        Map<String, String> ulOopsMatrixMap = new Map<String, String>();
        Integer colTotal = 0, colTotalLocal = 0, rowTotal = 0, rowTotalLocal=0, colTotalVal = 0, rowTotalVal = 0, rowTotalA = 0, colTotalA = 0; 
        Map<String, AF_OOPS_Estimate__c> oopsULRelationMap = new Map<String, AF_OOPS_Estimate__c>();
        List<AF_OOPS_Estimate__c> agencyEstimates = [SELECT  AF_Agency_Entity__c, AF_Unilever_Entity__c, AF_Agency_Entity__r.AF_Country__c,AF_Unilever_Entity__r.Name,
                                                                AF_OOPS_Actual__c, AF_Estimate__c, AF_OOPS_Matrix_Currency_Code__c, AF_IsCrossBorder__c,AF_EstimateLocal__c,
                                                                AF_IsCrossBorderImage__c,AF_isCommentImage__c, AF_Agreed_Base_Fees__c
                                                            FROM AF_OOPS_Estimate__c
                                                         WHERE AF_OOPS_Actual__c =:oopsActualId];
        for(AF_OOPS_Estimate__c eachAgencyEstimate : agencyEstimates) {
            columnsSet.add(eachAgencyEstimate.AF_Agency_Entity__r.AF_Country__c);
            oopsULRelationMap.put(eachAgencyEstimate.AF_Agency_Entity__r.AF_Country__c+'-'+eachAgencyEstimate.AF_Unilever_Entity__r.Name,
                                       eachAgencyEstimate);
            rowsSet.add(eachAgencyEstimate.AF_Unilever_Entity__r.Name);
        }
        List<String> orderedColumn = AF_BrandEstimateRemote.fillList(columnsSet);
        orderedColumn.sort();
        List<String> orderedRow = AF_BrandEstimateRemote.fillList(rowsSet);
        orderedRow.sort();
        Map<String, AF_Entity__c> agencyNameMap = AF_BrandEstimateRemote.getAllAgencyEntities(agencyId);
        Map<String, String> ulNameMap = AF_BrandEstimateRemote.getUnileverEntitiesByName();
        List<String> agenciesToSelect = AF_BrandEstimateRemote.getAgencyEntities(agencyId, oopsActualId, 'AF_OOPS_Actual__c'); 
        // These are the Agency Entities which are not created as Agency Estimates.
        List<String> ulEntitiesToSelect = AF_BrandEstimateRemote.getUnileverEntities(oopsActualId, 'AF_OOPS_Actual__c'); 
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
            colTotal = 0; colTotalA = 0;
            for(String eachRow : orderedRow) {
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(oopsULRelationMap.containsKey(keyMatch)) {
                    colTotal += AF_BrandEstimateRemote.truncateDecimal(oopsULRelationMap.get(keyMatch).AF_Estimate__c/1000);
                    colTotalA += AF_BrandEstimateRemote.truncateDecimal(oopsULRelationMap.get(keyMatch).AF_Estimate__c);
                }
            }
            String dispColTotal = (colTotal > 0) ? 'EUR ' + AF_BrandEstimateRemote.currencyFormatted(colTotal) : '';
            String dispColTotalA = (colTotalA > 0) ? 'EUR ' + AF_BrandEstimateRemote.currencyFormatted(colTotalA) : '';
            rowDetail += '<td align=\"center\" title=\"\" class=\"totalCell details-control';
            rowDetail += '\" t=\"' + dispColTotalA + '\" d=\"tot\" a=\"ob\">';
            rowDetail += '<a l e=\"' + dispColTotal + '\">' + strongStrt + dispColTotal + strongEnd + '</a>' + tdCloseTag;
        }
        rowDetail += trCloseTag;
        
        Integer i=2;
        //Display the distinct Columns from the agency estimates.
        for(String eachCol : orderedColumn) {
            colTotal = 0;colTotalVal=0;colTotalA = 0;
            for(String eachRow : orderedRow) {
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(oopsULRelationMap.containsKey(keyMatch)) {
                    colTotal += AF_BrandEstimateRemote.truncateDecimal(oopsULRelationMap.get(keyMatch).AF_Estimate__c/1000);
                    Decimal agreedBaseFee = oopsULRelationMap.get(keyMatch).AF_Agreed_Base_Fees__c != null ? 
                                                oopsULRelationMap.get(keyMatch).AF_Agreed_Base_Fees__c : 0;
                    colTotalVal += AF_BrandEstimateRemote.truncateDecimal(agreedBaseFee);
                    colTotalA += AF_BrandEstimateRemote.truncateDecimal(oopsULRelationMap.get(keyMatch).AF_Estimate__c);
                }
            }
            String dispArchiveImg = (colTotalVal > 0 || colTotalA > 0) ?  '' : archiveImg;
            colDetail += '<th id=\'' + i + '\' isDisplay=\'y\'>' + eachCol + dispArchiveImg + '</th>';
            i++;
        }
        
        /* Columns part is completed. */
        /* Following displays all the rows in the matrix.*/
        for(String eachRow : orderedRow) {
            rowDetail += trOpenTag;
            rowTotal = 0;rowTotalVal=0;rowTotalA=0;
            for(String eachCol : orderedColumn) { //Actual Agency Estimate Record's totals goes here..
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(oopsULRelationMap.containsKey(keyMatch)) {
                    rowTotal += AF_BrandEstimateRemote.truncateDecimal(oopsULRelationMap.get(keyMatch).AF_Estimate__c/1000);
                    Decimal agreedBaseFee = oopsULRelationMap.get(keyMatch).AF_Agreed_Base_Fees__c != null ? 
                                                oopsULRelationMap.get(keyMatch).AF_Agreed_Base_Fees__c : 0;
                    rowTotalVal += AF_BrandEstimateRemote.truncateDecimal(agreedBaseFee);
                    rowTotalA += AF_BrandEstimateRemote.truncateDecimal(oopsULRelationMap .get(keyMatch).AF_Estimate__c);
                }
            }
            String dispArchiveImg = (rowTotalVal > 0 || rowTotalA > 0)?  '' : archiveImg;
            rowDetail += '<td align=\"center\" class=\"headRow">'+ strongStrt +  eachRow + dispArchiveImg + strongEnd + tdCloseTag;
            String dispRowTotal = (rowTotal > 0) ? 'EUR ' + AF_BrandEstimateRemote.currencyFormatted(rowTotal) : '';
            String dispRowTotalA = (rowTotalA > 0) ? 'EUR ' + AF_BrandEstimateRemote.currencyFormatted(rowTotalA) : '';
            rowDetail += '<td title=\"\" class=\"totalCell details-control';
            rowDetail += '\" t=\"' + dispRowTotalA + '\" d=\"tot\" a=\"ob\">';
            rowDetail += '<a l e=\"' + dispRowTotal + '\">' + strongStrt + dispRowTotal + strongEnd + '</a>' + tdCloseTag;
            for(String eachCol : orderedColumn) { //Display the agency estimate records
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(oopsULRelationMap.containsKey(keyMatch)) {
                    rowDetail += processOopsRow(true, oopsULRelationMap.get(keyMatch), oopsULRelationMap, null, null, null);
                }else {
                    String aId = (agencyNameMap != null && agencyNameMap.get(eachCol) != null) ? agencyNameMap.get(eachCol).Id : null;
                    String uId = (ulNameMap != null && ulNameMap.get(eachRow) != null) ? ulNameMap.get(eachRow) : '';
                    rowDetail += processOopsRow(false, null, oopsULRelationMap, aId, uId, oopsActualId);
                }
            }
            rowDetail += trCloseTag;
        }
        ulOopsMatrixMap.put('1', colDetail);
        ulOopsMatrixMap.put('2', rowDetail);
        system.debug('** ulOopsMatrixMap : ' + ulOopsMatrixMap);
        return ulOopsMatrixMap;
        
    }

    public static String processOopsRow(Boolean isValue, AF_OOPS_Estimate__c agSObj, 
                                        Map<String, AF_OOPS_Estimate__c> oopsULRelationMap, 
                                        String aId, String uId, String bId) {
        String tdOpenTag = '<td>',tdCloseTag = '</td>', trOpenTag = '<tr>', trCloseTag = '</tr>', space = '&nbsp;', lBreak = '<br/>', spacer = ' ';
        String rowDetailToReturn = '';
        String href, title = '';
        if(isValue) {
            Integer total = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Estimate__c/1000);
            Integer totalLocal = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_EstimateLocal__c/1000);
            Integer totalA = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Estimate__c);
            Integer totalLocalA = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_EstimateLocal__c);
            Decimal totalWithoutRounding = agSObj.AF_Estimate__c/1000;
            String currCode = agSObj.AF_OOPS_Matrix_Currency_Code__c != null ? agSObj.AF_OOPS_Matrix_Currency_Code__c : '';
            String disptotal = agSObj.AF_Estimate__c > 0 ? 'EUR ' + AF_BrandEstimateRemote.currencyFormattedDecimal(total) : '';
            String dispLocalTotal = agSObj.AF_EstimateLocal__c > 0 ? currCode + spacer + AF_BrandEstimateRemote.currencyFormattedDecimal(totalLocal) : '';
            String disptotalA = agSObj.AF_Estimate__c > 0 ? 'EUR ' + AF_BrandEstimateRemote.currencyFormattedDecimal(totalA) : '';
            String dispLocalTotalA = agSObj.AF_EstimateLocal__c > 0 ? currCode + spacer + AF_BrandEstimateRemote.currencyFormattedDecimal(totalLocalA) : '';
            //String cmntImg =  agSObj.AF_isCommentImage__c != null ? agSObj.AF_isCommentImage__c : '';
            String cmntImg =  '';
            String crsBrdrImg =  agSObj.AF_IsCrossBorderImage__c != null ? agSObj.AF_IsCrossBorderImage__c : '';
            href = 'apex/af_oopsEstimate?id='+agSObj.Id;
            rowDetailToReturn += '<td title=\"\" class=\"details-control\"';
            rowDetailToReturn += ' t=\"' + disptotalA + '\" d=\"' + dispLocalTotalA + '\" a=\"ob\">';
            rowDetailToReturn += '<a data-src=\"' + href +  '\"';
            rowDetailToReturn += 'data-toggle=\"modal\"';
            rowDetailToReturn += 'data-backdrop=\"static\"';
            rowDetailToReturn += 'data-keyboard=\"false\"';
            rowDetailToReturn += 'data-target=\"#myModal3\"';
            rowDetailToReturn += 'class=\"modalButton3\"';
            rowDetailToReturn += ' e=\"' + disptotal + '\"';
            rowDetailToReturn += ' l=\"' + dispLocalTotal + '\">';
            if(total != 0) {
                rowDetailToReturn += crsBrdrImg + '<br/>' + cmntImg;
                rowDetailToReturn += '</div><div align=\"center\" class=\"agencyCOlcanter\">' + 'EUR ' + AF_BrandEstimateRemote.currencyFormatted(total);
                rowDetailToReturn = totalA != totalLocalA ? rowDetailToReturn + lBreak + currCode + ' ' + AF_BrandEstimateRemote.currencyFormatted(totalLocal) : rowDetailToReturn;
            } else if(totalWithoutRounding > 0 && totalWithoutRounding <= 499){
                rowDetailToReturn += crsBrdrImg + '<br/>' + cmntImg;
                rowDetailToReturn += '</div><div align=\"center\" class=\"agencyCOlcanter\">' + 'EUR 0';
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