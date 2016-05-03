public with sharing class OV_KpiNotificationFormatter {

	public final static String VISIBLE_COLUMN_DELIMITER 			= ';';
	public final static String HEADER_DELIMITER 					= ', ';
	public final static String TIMERANGE_FIELD_RELATION_NAME    	= 'Time_Range__r';
	public final static String KPINAME_FIELD_RELATION_NAME    		= 'KPI_Name__r';
	public final static String KPI_TRANSACTION_FIELD_RELATION_NAME  = 'KPI_Transaction__r';

	private Map<String, OV_GetKPI_Mapping__c> customSettingsMapping;

	public static List<String> splitByVisibleColumnDelimiter(String input){
		return input.split(VISIBLE_COLUMN_DELIMITER);
	}

	public static String joinByHeaderDelimiter(List<String> input){
		return String.join(input, HEADER_DELIMITER);
	}

	public static String insertHeadersIntoFormulaMessage(String formulaMessage, String headers){
		List<String> arguments = new List<String>{ headers };
		String formattedMessage = String.format(formulaMessage, arguments);
		return formattedMessage;
	}

	public OV_KpiNotificationFormatter(){
		this.customSettingsMapping = OV_KpiUtils.getKpiMapping();
	}

	public String formatMessage(OV_KPI_Transaction_Favorite__c favourite){
		System.debug(LoggingLevel.DEBUG, 'Enter: formatMessage: ' + favourite);

		String visibleColumns = visibleColumnsFor(favourite);
		String formulaMessage = favourite.Chatter_Update_Message__c;

		List<String> headers = valuesForVisibleColumns(favourite, visibleColumns);

		String headersFormated =  joinByHeaderDelimiter(headers);

		String result = insertHeadersIntoFormulaMessage(formulaMessage, headersFormated);

		System.debug(LoggingLevel.DEBUG, 'Exit:  formatMessage: ' + result);
		return result;
	}

	private List<String> valuesForVisibleColumns(OV_KPI_Transaction_Favorite__c favourite, String visibleColumns){
		List<String> keys = splitByVisibleColumnDelimiter(visibleColumns); 
		System.debug('valuesForVisibleColumns - Get Values for columns: '+keys);
		List<String> results = new List<String>();
		for(String key : keys){
			if(this.customSettingsMapping.containsKey(key)){
				OV_GetKPI_Mapping__c mapping = this.customSettingsMapping.get(key);
				String fieldApiName = mapping.Field_API_Name__c;
				String relationNameFromFieldApiName = fieldApiName.replace('__c', '__r');

				System.debug('Field Api Name: '+fieldApiName);
				System.debug('Field Api Relation Name: '+ relationNameFromFieldApiName);

				if(favourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).getSObject(relationNameFromFieldApiName) != null){
					if(relationNameFromFieldApiName != TIMERANGE_FIELD_RELATION_NAME && relationNameFromFieldApiName != KPINAME_FIELD_RELATION_NAME){
						String value = String.valueOf(favourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).getSObject(relationNameFromFieldApiName).get('Name'));					
	                	results.add(value);
	                }
	            }				
			}			
		}
		return results;
	}

	private String visibleColumnsFor(OV_KPI_Transaction_Favorite__c favourite){
		System.debug(LoggingLevel.DEBUG, 'Enter: visibleColumnsFor:' + favourite.Id);

		OV_KPI_Transaction__c transactx = favourite.KPI_Transaction__r;
		OV_KPI_Dimension_KPI_Name__c kpiNameObject = transactx.KPI_Name__r;
		String visibleColumns = kpiNameObject.Visible_Columns__c;
		
		System.debug(LoggingLevel.DEBUG, 'Exit:  visibleColumnsFor:' + favourite.Id + ':result:' + visibleColumns);
		return (visibleColumns == null) ? '' :  visibleColumns;
	}
}