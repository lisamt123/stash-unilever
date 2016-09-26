/**********************************************************************
Name: ICB_RecordTypeMemory
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Retrive all recordtypes and store in memory.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Carlos Carvalho 13/06/2016  Class creation  
***********************************************************************/
public with sharing class ICB_RecordTypeMemory {
  
    //Static variables
    private static Map< String, Map< String, Id > > fRecTypes = new Map< String, Map< String, Id > >();
    static {
        List< RecordType > lList = [ select id, SobjectType, DeveloperName from RecordType WHERE IsActive = true ];
        for ( RecordType lRec : lList )
        {
            Map< String, Id > lObjMap = fRecTypes.get( lRec.SobjectType );
            if ( lObjMap == null )
            {
                lObjMap = new Map< String, Id >();
                fRecTypes.put( lRec.SobjectType, lObjMap );
            }
            lObjMap.put( lRec.DeveloperName, lRec.id );
        }
    }
  
    /*******************************************************************
     Purpose: Retrieve the recordType Id from specific Sobject and 
	 recordtype developer name.
     Parameters: [String aObj]: SOBJECTTYPE API 
				 [String aDevName]: RecordType Developer Name
     Returns: [Id]: Recordtype Id
     Throws [Exceptions]: [NONE]
     ********************************************************************/
    public static id getRecType( String aObj, String aDevName )
    {
        system.debug('Entering <getRecType>: aObj: '+aObj + ' | aDevName: '+aDevName );
        Map< String, Id > lObjMap = fRecTypes.get( aObj );
        if ( lObjMap == null ) {
            return null;
        }
        system.debug('Entering <getRecType>: lObjMap.get( aDevName ): '+lObjMap.get( aDevName ) );
        return lObjMap.get( aDevName );
    }
}