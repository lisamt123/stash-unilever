/**********************************************************************
Name: OV_SecurityHelper
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Class checking privileges for aura apps
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             12/10/2015      INITIAL DEVELOPMENT
**********************************************************************/
public without sharing class OV_SecurityHelper {
	public static void doPrivilegedOp(String objectName, List<String> fieldsToCheck) {
        Map<String,Schema.SObjectField> m = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

        for (String fieldToCheck : fieldsToCheck) {
            if(m.containsKey(fieldToCheck)){
                if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                    System.debug(LoggingLevel.WARN, 'You do not have appropriate access to ' + objectName + ':' + fieldToCheck);

                    throw new System.NoAccessException();
                }
            }
        } 
	}
}