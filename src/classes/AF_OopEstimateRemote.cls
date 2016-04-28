/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_OopEstimateRemote
@CreateDate : 17/6/2014
@Description : This is a controller class for AF_UL_oopsMatrix Page, 
@			  this is used to create the matrix cell structure for OOPS.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
global with sharing class AF_OopEstimateRemote {
	static List<String> orderedColumn = new List<String>();
	static List<String> orderedRow = new List<String>();
	static Integer colTotal;
	static Integer colTotalA;
	static Map<String, AF_OOPS_Estimate__c> oopsULRelationMap = new Map<String, AF_OOPS_Estimate__c>();
	static String rowDetail;
	static String tdCloseTagEst;
	static Integer colTotalVal;
	static String archiveImg;
	static String  colDetail;
	static Map<String, AF_Entity__c> agencyNameMap= new Map<String, AF_Entity__c>();
	static Map<String, String> ulNameMap=new Map<String, String>();
	static String strongStrt;
	static String strongEnd;
	static Integer total;
	static String crsBrdrImg;
	static String rowDetailToReturn;
	static String currCode;
	static Integer totalA;
	static Integer totalLocalA;
	static Integer totalLocal;
	static Decimal totalWithoutRounding;
	public AF_OopEstimateRemote(ApexPages.StandardController stdController) {}
	@remoteAction
	/***********************************************************************************
*  @Description: this method is used to query and display the records in oops matrix 
*  @             rows and column total of the oopsEstimate records will be displayed.
				 The total of the oops amount will be displayed in matrix cell rowise and colwise. 
*  @name : getOOPSEstimateRecords
*  @param : agencyId,oopsActualId
*  @return: Map of <String,String>.
*************************************************************************************/
	global static Map<String, String> getOOPSEstimateRecords(String agencyId, String oopsActualId) {
		tdCloseTagEst='</td>';
		String trOpenTag = '<tr>', trCloseTag = '</tr>';
		strongStrt = '<Strong>';
		strongEnd = '</strong>';
		Set<String> columnsSet = new Set<String>();
		Set<String> rowsSet = new Set<String>();
		Map<String, String> ulOopsMatrixMap = new Map<String, String>();
		colTotal = 0;
		colTotalA = 0;
		colTotalVal=0;
		Integer rowTotal = 0, rowTotalVal = 0, rowTotalA = 0; 
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
		orderedColumn = AF_BrandEstimateRemote.fillList(columnsSet);
		orderedColumn.sort();
		orderedRow = AF_BrandEstimateRemote.fillList(rowsSet);
		orderedRow.sort();
		agencyNameMap = AF_BrandEstimateRemote.getAllAgencyEntities(agencyId);
		ulNameMap = AF_BrandEstimateRemote.getUnileverEntitiesByName();
		List<String> agenciesToSelect = AF_BrandEstimateRemote.getAgencyEntities(agencyId, oopsActualId, AF_Constants.SOBJECT_OOPSACTUAL_APINAME); 
		// These are the Agency Entities which are not created as Agency Estimates.
		List<String> ulEntitiesToSelect = AF_BrandEstimateRemote.getUnileverEntities(oopsActualId, AF_Constants.SOBJECT_OOPSACTUAL_APINAME); 
		// These are those Unilever Entities which are not created as a record for Agency Estimates.
		colDetail = ''; //Column variable which gets added to the map finally.
		rowDetail = ''; //Row variable which gets added to the map finally.
		String imgPath = AF_Utils.isAgencyUser(UserInfo.getUserId()) ? Label.AF_AgencyUrlLink : Label.AF_UrlLink;
		archiveImg = '<img class=\"archive\" src="' + imgPath + '/resource/' + AF_Utils.getResourceURL('AF_DataTables') + '/AF_DataTables/AF_DataTables/examples/resources/remove_icon.png"'; 
		archiveImg += ' height="18" width="18" />';
		/* This is the first row of the matrix which actually calculates the Columnwise totals.*/
		rowDetail += trOpenTag;
		rowDetail += '<td class=\"headFirstRow\">' + strongStrt + 'Unilever Entities' + strongEnd + tdCloseTagEst;
		rowDetail += '<td class=\"totalCell\">' + strongStrt + 'Total' + strongEnd + tdCloseTagEst;
		orderedRowMethodOOPs();
		rowDetail += trCloseTag;
		orderedColMethodOOPs();
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
			rowDetail += '<td align=\"center\" class=\"headRow">'+ strongStrt +  eachRow + dispArchiveImg + strongEnd + tdCloseTagEst;
			String dispRowTotal = (rowTotal > 0) ? AF_Constants.AF_CURRENCY_EUR1 + AF_BrandEstimateRemote.currencyFormatted(rowTotal) : '';
			String dispRowTotalA = (rowTotalA > 0) ? AF_Constants.AF_CURRENCY_EUR1 + AF_BrandEstimateRemote.currencyFormatted(rowTotalA) : '';
			rowDetail += '<td title=\"\" class=\"totalCell details-control';
			rowDetail += '\" t=\"' + dispRowTotalA + '\" d=\"tot\" a=\"ob\">';
			rowDetail += '<a l e=\"' + dispRowTotal + '\">' + strongStrt + dispRowTotal + strongEnd + '</a>' + tdCloseTagEst;
			getOOPSRecordsExt(oopsActualId,eachRow);
			rowDetail += trCloseTag;
		}
		ulOopsMatrixMap.put('1', colDetail);
		ulOopsMatrixMap.put('2', rowDetail);
		return ulOopsMatrixMap;
	}
	public static void orderedRowMethodOOPs(){
		for(String eachCol : orderedColumn) { //Actual Agency Estimate Record's totals goes here..
			colTotal = 0; colTotalA = 0;
			for(String eachRow : orderedRow) {
				String keyMatch = eachCol+'-'+eachRow; //column Vs row
				if(oopsULRelationMap.containsKey(keyMatch)) {
					colTotal += AF_BrandEstimateRemote.truncateDecimal(oopsULRelationMap.get(keyMatch).AF_Estimate__c/1000);
					colTotalA += AF_BrandEstimateRemote.truncateDecimal(oopsULRelationMap.get(keyMatch).AF_Estimate__c);
				}
			}
			String dispColTotal = (colTotal > 0) ? AF_Constants.AF_CURRENCY_EUR1 + AF_BrandEstimateRemote.currencyFormatted(colTotal) : '';
			String dispColTotalA = (colTotalA > 0) ? AF_Constants.AF_CURRENCY_EUR1 + AF_BrandEstimateRemote.currencyFormatted(colTotalA) : '';
			rowDetail += '<td align=\"center\" title=\"\" class=\"totalCell details-control';
			rowDetail += '\" t=\"' + dispColTotalA + '\" d=\"tot\" a=\"ob\">';
			rowDetail += '<a l e=\"' + dispColTotal + '\">' + strongStrt + dispColTotal + strongEnd + '</a>' + tdCloseTagEst;
		}
	}
	//Display the distinct Columns from the agency estimates.
	public static void orderedColMethodOOPs(){
	Integer i=2;
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
	}
	
	public static void getOOPSRecordsExt(String oopsActualId,String eachRow){
		for(String eachCol : orderedColumn) { //Display the agency estimate records
				String keyMatch = eachCol+'-'+eachRow; //column Vs row
				if(oopsULRelationMap.containsKey(keyMatch)) {
					rowDetail += processOopsRow(true,oopsULRelationMap.get(keyMatch),null, null, null);
				}else {
					String aId = (agencyNameMap != null && agencyNameMap.get(eachCol) != null) ? agencyNameMap.get(eachCol).Id : null;
					String uId = (ulNameMap != null && ulNameMap.get(eachRow) != null) ? ulNameMap.get(eachRow) : '';
					rowDetail += processOopsRow(false,null,aId, uId, oopsActualId);
				}
			}
	}
	/***********************************************************************************
*  @Description: this method is used to frame the HTML of the matrix cell display
*  @             the total displayed on row and column will be round to it's nearest integer
				 by dividing it with thousand
*  @name : processOopsRow
*  @param : isValue,agSObj,oopsULRelationMap
*  @return: String.
*************************************************************************************/
	public static String processOopsRow(Boolean isValue, AF_OOPS_Estimate__c agSObj, 
		String aId, String uId, String bId) {
		String tdCloseTag = '</td>';
		rowDetailToReturn = '';
		if(isValue) {
			total = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Estimate__c/1000);
			totalLocal = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_EstimateLocal__c/1000);
			totalA = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_Estimate__c);
			totalLocalA = AF_BrandEstimateRemote.truncateDecimal(agSObj.AF_EstimateLocal__c);
			totalWithoutRounding = agSObj.AF_Estimate__c/1000;
			currCode = agSObj.AF_OOPS_Matrix_Currency_Code__c != null ? agSObj.AF_OOPS_Matrix_Currency_Code__c : '';
			String spacer = ' ';
			String href;
			String disptotal = agSObj.AF_Estimate__c > 0 ? AF_Constants.AF_CURRENCY_EUR1 + AF_BrandEstimateRemote.currencyFormattedDecimal(total) : '';
			String dispLocalTotal = agSObj.AF_EstimateLocal__c > 0 ? currCode + spacer + AF_BrandEstimateRemote.currencyFormattedDecimal(totalLocal) : '';
			String disptotalA = agSObj.AF_Estimate__c > 0 ? AF_Constants.AF_CURRENCY_EUR1 + AF_BrandEstimateRemote.currencyFormattedDecimal(totalA) : '';
			String dispLocalTotalA = agSObj.AF_EstimateLocal__c > 0 ? currCode + spacer + AF_BrandEstimateRemote.currencyFormattedDecimal(totalLocalA) : '';
			crsBrdrImg =  agSObj.AF_IsCrossBorderImage__c != null ? agSObj.AF_IsCrossBorderImage__c : '';
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
			processOopsExt(agSObj);
			rowDetailToReturn += '</div></a>';
			rowDetailToReturn += tdCloseTag;
		}
		return rowDetailToReturn;
	}
	
	public static void processOopsExt(AF_OOPS_Estimate__c agSObj){
			String lBreak = '<br/>';
			String cmntImg =  '';
			if(total != 0) {
				rowDetailToReturn += crsBrdrImg + '<br/>' + cmntImg;
				rowDetailToReturn += '</div><div align=\"center\" class=\"agencyCOlcanter\">' + AF_Constants.AF_CURRENCY_EUR1 + AF_BrandEstimateRemote.currencyFormatted(total);
				rowDetailToReturn = totalA != totalLocalA ? rowDetailToReturn + lBreak + currCode + ' ' + AF_BrandEstimateRemote.currencyFormatted(totalLocal) : rowDetailToReturn;
			} else if(totalWithoutRounding > 0 && totalWithoutRounding <= 499){
				rowDetailToReturn += crsBrdrImg + '<br/>' + cmntImg;
				rowDetailToReturn += '</div><div align=\"center\" class=\"agencyCOlcanter\">' + 'EUR 0';
				rowDetailToReturn = totalA != totalLocalA ? rowDetailToReturn + lBreak + currCode + ' ' + AF_BrandEstimateRemote.currencyFormatted(totalLocal) : rowDetailToReturn;
			}else {
				rowDetailToReturn += cmntImg;
			}
	}
}