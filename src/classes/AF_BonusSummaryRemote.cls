/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusSummaryRemote
@CreateDate : 18/7/2014
@Description : This is a controller class for AF_BonusMatrix Page, 
@             this is used to frame matrix cell structure for Bonus matrix.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
global with sharing class AF_BonusSummaryRemote {
    static List<String> orderedColumn = new List<String>();
    static List<String> orderedRow = new List<String>();
    static Integer colTotalA;
    static Integer colTotal;
    static String rowDetail;
    static String rowDetailToReturn;
    static Map<String, AF_Bonus_Matrix__c> bonusULRelationMap  = new Map<String, AF_Bonus_Matrix__c>();
    //static String strongStrt;
    //static String strongEnd;
    //static String tdCloseTagEst;
    static String archiveImg;
    static String  colDetail;
    static Map<String, AF_Entity__c> agencyNameMap= new Map<String, AF_Entity__c>();
    static Map<String, String> ulNameMap = new Map<String, String>();
    static Integer total;
    //static String crsBrdrImg;
    //static String cmntImg;
    static Integer totalA;
    static Integer totalLocalA;
    static String currCode;
    static Decimal totalWithoutRounding;
    static Integer totalLocal;
    public AF_BonusSummaryRemote(ApexPages.StandardController stdController) {}
    /***********************************************************************************
*  @Description: this method is used to query and frame the rows and columns of the 
*  @             agency and unilerver entity of Bonus Matrix records and display's
*  @             Total of the each entity and sub-total of the row and column
*  @name : getBonusMatrixRecords
*  @param : agencyId,bonusSummaryId
*  @return: Map of <String,String>.
*************************************************************************************/  
    @remoteAction
    global static Map<String, String> getBonusMatrixRecords(String agencyId, String bonusSummaryId) {
        String strongStrt;
        String strongEnd;
        String tdCloseTagEst;
        tdCloseTagEst= '</td>';
        AF_Constants.tdCloseTagEst=tdCloseTagEst;
        String trOpenTag = '<tr>', trCloseTag = '</tr>';
        strongStrt = '<Strong>';
        AF_Constants.strongStrt=strongStrt;
        strongEnd = '</strong>';
        AF_Constants.strongEnd =strongEnd ;
        Set<String> columnsSet = new Set<String>();
        Set<String> rowsSet = new Set<String>();
        Map<String, String> ulbonusMatrixMap  = new Map<String, String>();
        colTotal = 0;
        colTotalA=0;
        Integer rowTotal = 0, rowLocalTotal=0, rowTotalA = 0;
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
        orderedColumn = AF_BrandEstimateRemote.fillList(columnsSet);
        orderedColumn.sort();
        orderedRow = AF_BrandEstimateRemote.fillList(rowsSet);
        orderedRow.sort();
        agencyNameMap = AF_BrandEstimateRemote.getAllAgencyEntities(agencyId);
        ulNameMap = AF_BrandEstimateRemote.getUnileverEntitiesByName(); 
        // These are the Agency Entities which are not created as Agency Estimates.
        // These are those Unilever Entities which are not created as a record for Agency Estimates.
        colDetail = ''; //Column variable which gets added to the map finally.
        rowDetail = ''; //Row variable which gets added to the map finally.
        String imgPath = AF_Utils.isAgencyUser(UserInfo.getUserId()) ? Label.AF_AgencyUrlLink : Label.AF_UrlLink;
        archiveImg = '<img class=\"archive\" src="' + imgPath + '/resource/' + AF_Utils.getResourceURL('AF_DataTables') + '/AF_DataTables/AF_DataTables/examples/resources/remove_icon.png"'; 
        archiveImg += ' height="18" width="18" />';
        /* This is the first row of the matrix which actually calculates the Columnwise totals.*/
        rowDetail += trOpenTag;
        rowDetail += '<td class=\"headFirstRow\">' + AF_Constants.strongStrt + 'Unilever Entities' + AF_Constants.strongEnd + AF_Constants.tdCloseTagEst;
        rowDetail += '<td class=\"totalCell\">' + AF_Constants.strongStrt + 'Total' + AF_Constants.strongEnd + AF_Constants.tdCloseTagEst;
        orderedRowMethodBonus();
        rowDetail += trCloseTag;
        orderedColMethodBonus();
        /* Columns part is completed. */
        /* Following displays all the rows in the matrix.*/
        for(String eachRow : orderedRow) {
            rowDetail += trOpenTag;
            rowTotal = 0;rowTotalA=0;
            for(String eachCol : orderedColumn) { //Actual Agency Estimate Record's totals goes here..
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(bonusULRelationMap .containsKey(keyMatch)) {
                    /* commented for incident No:INC000097270556 */
                    /* commented for incident No:INC000097270556 */
                    rowLocalTotal += AF_BrandEstimateRemote.truncateDecimal(bonusULRelationMap .get(keyMatch).AF_Bonus_Local_Value__c/1000);
                    rowTotalA += AF_BrandEstimateRemote.truncateDecimal(bonusULRelationMap .get(keyMatch).AF_Value__c);
                }
            }
            String dispArchiveImg = rowTotalA > 0 ?  '' : archiveImg;
            rowDetail += '<td align=\"center\" class=\"headRow">'+ AF_Constants.strongStrt +  eachRow + dispArchiveImg + AF_Constants.strongEnd + AF_Constants.tdCloseTagEst;
            /* Added for incident No:INC000097270556 */
            rowTotal = AF_BrandEstimateRemote.truncateDecimal(Decimal.valueOf(rowTotalA)/1000);
            /* Added for incident No:INC000097270556 */
            String dispRowTotal = (rowTotal > 0) ? AF_Constants.AF_CURRENCY_EUR + ' ' + AF_BrandEstimateRemote.currencyFormatted(rowTotal) : '';
            String dispRowTotalA = (rowTotalA > 0) ? AF_Constants.AF_CURRENCY_EUR + ' ' + AF_BrandEstimateRemote.currencyFormatted(rowTotalA) : '';
            rowDetail += '<td title=\"\" class=\"totalCell details-control';
            rowDetail += '\" t=\"' + dispRowTotalA + '\" d=\"tot\" a=\"ob\">';
            rowDetail += '<a l e=\"' + dispRowTotal + '\">' + AF_Constants.strongStrt + dispRowTotal + AF_Constants.strongEnd + '</a>' + AF_Constants.tdCloseTagEst;
            getBonusRecordsExt(bonusSummaryId,eachRow);
            rowDetail += trCloseTag;
        }
        ulbonusMatrixMap .put('1', colDetail);
        ulbonusMatrixMap .put('2', rowDetail);
        return ulbonusMatrixMap ;
    }
    /***********************************************************************************
*  @Description: this method is used display add the row detail total
*  @name : orderedRowMethodBonus
*  @param : none
*  @return: none.
*************************************************************************************/  
    public static void orderedRowMethodBonus(){
        for(String eachCol : orderedColumn) { //Actual Agency Estimate Record's totals goes here..
            colTotal = 0;colTotalA=0;
            for(String eachRow : orderedRow) {
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(bonusULRelationMap .containsKey(keyMatch)) {
                    /* commented for incident No:INC000097270556 */
                    /* commented for incident No:INC000097270556 */
                    colTotalA += AF_BrandEstimateRemote.truncateDecimal(bonusULRelationMap .get(keyMatch).AF_Value__c);
                }
            }
            /* Added for incident No:INC000097270556 */
            colTotal = AF_BrandEstimateRemote.truncateDecimal(Decimal.valueOf(colTotalA)/1000);
            /* Added for incident No:INC000097270556 */
            String dispColTotal = colTotal > 0 ? AF_Constants.AF_CURRENCY_EUR + ' '+ AF_BrandEstimateRemote.currencyFormatted(colTotal) : '';
            String dispColTotalA = (colTotal > 0) ? AF_Constants.AF_CURRENCY_EUR + ' ' + AF_BrandEstimateRemote.currencyFormatted(colTotalA) : '';
            rowDetail += '<td align=\"center\" title=\"\" class=\"totalCell details-control';
            rowDetail += '\" t=\"' + dispColTotalA + '\" d=\"tot\" a=\"ob\">';
            rowDetail += '<a l e=\"' + dispColTotal + '\">' + AF_Constants.strongStrt + dispColTotal + AF_Constants.strongEnd + '</a>' + AF_Constants.tdCloseTagEst;
        }
    }
        /***********************************************************************************
*  @Description: this method is used display add the column detail total
*  @name : orderedColMethodBonus
*  @param : none
*  @return: none.
*************************************************************************************/  
    public static void orderedColMethodBonus(){
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
    }
        /***********************************************************************************
*  @Description: this method is used get the bonus records to call detail methods
*  @name : getBonusRecordsExt
*  @param : String,String
*  @return: none.
*************************************************************************************/  
    public static void getBonusRecordsExt(String bonusSummaryId,String eachRow){
        for(String eachCol : orderedColumn) { //Display the agency estimate records
                String keyMatch = eachCol+'-'+eachRow; //column Vs row
                if(bonusULRelationMap .containsKey(keyMatch)) {
                    rowDetail += processBonusRow(true, bonusULRelationMap .get(keyMatch),null, null, null);
                }else {
                    String aId = (agencyNameMap != null && agencyNameMap.get(eachCol) != null) ? agencyNameMap.get(eachCol).Id : null;
                    String uId = (ulNameMap != null && ulNameMap.get(eachRow) != null) ? ulNameMap.get(eachRow) : '';
                    rowDetail += processBonusRow(false, null,aId, uId, bonusSummaryId);
                }
            }
    }
    /***********************************************************************************
*  @Description: this method is used display the total of each row and column of the matrix
*  @             and display's the localtotal, round the total value to it's nearest value.
*  @name : processBonusRow
*  @param : isValue,agSObj,aId,uId,bId
*  @return: String.
*************************************************************************************/  
    public static String processBonusRow(Boolean isValue, AF_Bonus_Matrix__c agSObj, 
        String aId, String uId, String bId) {
        String tdCloseTag = '</td>';
        rowDetailToReturn = '';
        String crsBrdrImg;
        String cmntImg;
        if(isValue) {
            total = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Value__c/1000);
            totalWithoutRounding = agSObj.AF_Value__c/1000;
            totalLocal = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Bonus_Local_Value__c/1000);
            totalA = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Value__c);
            totalLocalA = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Bonus_Local_Value__c);
            cmntImg =  agSObj.AF_isCommentImage__c != null ? agSObj.AF_isCommentImage__c : '';
            AF_Constants.cmntImg=cmntImg;
            crsBrdrImg =  agSObj.AF_IsCrossBorderImage__c != null ? agSObj.AF_IsCrossBorderImage__c : '';
            AF_Constants.crsBrdrImg=crsBrdrImg;
            currCode = agSObj.AF_BonusMatrixCode__c != null ? agSObj.AF_BonusMatrixCode__c : '';
            processBonusRowExt(agSObj);
            rowDetailToReturn += '</div></a>';
            rowDetailToReturn += tdCloseTag;
        }
        return rowDetailToReturn;
    }
    
    public static void processBonusRowExt(AF_Bonus_Matrix__c agSObj){
        String lBreak = '<br/>';
        String href;
        String spacer = ' ';
        href = 'apex/af_bonusEstimate?id='+agSObj.Id;
        String disptotal = agSObj.AF_Value__c > 0 ? AF_Constants.AF_CURRENCY_EUR + ' ' + AF_BrandEstimateRemote.currencyFormattedDecimal(total) : '';
            String dispLocalTotal = agSObj.AF_Bonus_Local_Value__c > 0 ? currCode + spacer + AF_BrandEstimateRemote.currencyFormattedDecimal(totalLocal) : '';
            String disptotalA = agSObj.AF_Value__c > 0 ? AF_Constants.AF_CURRENCY_EUR + ' ' + AF_BrandEstimateRemote.currencyFormattedDecimal(totalA) : '';
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
                rowDetailToReturn += '<div style=float:left;>' + AF_Constants.crsBrdrImg + '<br/>' + AF_Constants.cmntImg;
                rowDetailToReturn += '</div><div align=\"center\">' + AF_Constants.AF_CURRENCY_EUR + ' ' + AF_BrandEstimateRemote.currencyFormatted(total);
                rowDetailToReturn = totalA != totalLocalA ? rowDetailToReturn + lBreak + currCode + ' ' + AF_BrandEstimateRemote.currencyFormatted(totalLocal) : rowDetailToReturn;
            } else if(totalWithoutRounding > 0 && totalWithoutRounding <= 499){
                rowDetailToReturn += '<div style=float:left;>' + AF_Constants.crsBrdrImg + '<br/>' + AF_Constants.cmntImg;
                rowDetailToReturn += '</div><div align=\"center\">' + AF_Constants.AF_CURRENCY_EUR + ' 0';
                rowDetailToReturn = totalA != totalLocalA ? rowDetailToReturn + lBreak + currCode + ' ' + AF_BrandEstimateRemote.currencyFormatted(totalLocal) : rowDetailToReturn;
            }else {
                rowDetailToReturn += AF_Constants.cmntImg;
            }
    }
}