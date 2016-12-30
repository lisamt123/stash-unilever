public class PicklistValueByRecordType {
    
    public static MetadataService.MetadataPort createService() {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    
    public static  Map<String, List<String>> getDependentPicklistValuesByRecordType(String objectName, String fieldName) {
        
		Map<String, List<String>> result = new Map<String, List<String>>();        
        
        MetadataService.MetadataPort service = createService();
        
        List<MetadataService.RecordType> recordTypes = getRecordTypes(service ,objectName);
        
        for (MetadataService.RecordType recordType : recordTypes) {
            system.debug(recordType.fullName);
            List<String> filterPicklistValues = new List<String>();
            
            if (recordType.picklistValues != null) {
                
        		for ( MetadataService.RecordTypePicklistValue rpk : recordType.picklistValues ) {
            		if ( fieldName == rpk.picklist ) {        
            	    	for ( MetadataService.PicklistValue pk : rpk.values ) {
							filterPicklistValues.add( pk.fullName );
            	    	}                
            		}
        		}
            }
            else
            {
                filterPicklistValues = null;
            }
            
            result.put(recordType.fullName, filterPicklistValues);
        }
		
		
        return result;
		
    }
   
    private static List<MetadataService.RecordType> getRecordTypes(MetadataService.MetadataPort service, String objectName) {
        
        String namespace = getNamespace(objectName);
        Schema.DescribeSObjectResult objectDesc = Schema.getGlobalDescribe().get(objectName).getDescribe();
		List<Schema.RecordTypeInfo> recordTypes = objectDesc.getRecordTypeInfos();
        
        List<String> recordTypeNames = new List<String>();
        
        for (Schema.RecordTypeInfo rti : recordTypes) {
            if (rti.getName() != 'Master')
            {
            	String rtName = objectName + '.' + namespace + rti.getName();
            	recordTypeNames.add(rtName);
            }
        }
       
        // Read Record Type
        List<MetadataService.RecordType> result = (List<MetadataService.RecordType>) service.readMetadata(
            'RecordType', recordTypeNames 
        ).getRecords();
        
		System.debug(result);
        return result;
    }
    
    private static String getNamespace(String objectName) {
        String namespace = '';
        String[] nameparts = objectName.split('__');
        if (nameparts.size() > 1)
        {
            namespace = nameparts[0] + '__';
        }
        return namespace;
    }

}