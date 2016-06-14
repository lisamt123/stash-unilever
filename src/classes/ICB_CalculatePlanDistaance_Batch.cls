/**********************************************************************
Name: ICB_CalculatePlanDistaance_Batch
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Esta classe realiza o calculo da distancia planejada 
onde a distancia da visita anterior até a próxima é 
gravada na visita subsequente.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Carlos Carvalho 12/06/2016  Class creation  
***********************************************************************/
global class ICB_CalculatePlanDistaance_Batch implements Database.Batchable<sObject>
{
    
    //Static variables
	static Id RT_IceCreamId = ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_EVENT, Label.ICB_REC_TYPE_ICE_CREAM_VISIT);
    
    /*******************************************************************
     Purpose: This method execute the query in Event object.
     Parameters: [Database.Batchablecontext]
     Returns: [Database.Querylocator]
     Throws [Exceptions]: [NONE]
     ********************************************************************/
    global Database.Querylocator start (Database.Batchablecontext bc)
    {
        String soqlQuery = 'SELECT Ownerid, id, StartDateTime, ICB_Start_Executed_Visit__c, ' 
                                + 'ICB_CustomerGeolocation__c, ICB_PlannedDistance__c, Subject '
                                + 'FROM Event WHERE (ICB_PlannedDistance__c = null OR ICB_PlannedDistance__c = 0) '
                                + 'AND StartDateTime = today '
            					+ 'AND RecordTypeId = \'' + RT_IceCreamId + '\' ORDER by StartDateTime asc';
        
    	//Colocar a query aqui
    	return Database.getQueryLocator(soqlQuery);
    }
    
    /*******************************************************************
     Purpose: This method perform the calculation distance beetween two 
			  visits(Event).
     Parameters: [Database.Batchablecontext, List<sObject> ]
     Returns: [VOID]
     Throws [Exceptions]: [NONE]
     ********************************************************************/
    global void execute( Database.BatchableContext BC, List<sObject> scopeSobjects)
    {
        List< Event > lstVisits = (List<Event>)scopeSobjects;
        
        if( lstVisits.isEmpty() ) return;
       
        Map< Id, List< Event > > mapVisits = new Map< Id, List< Event >>();
        for( Event visit : lstVisits )
        {
            List< Event > lList = mapVisits.get( visit.OwnerId );
            if( lList == null )
            {
                lList = new List< Event >();
                mapVisits.put( visit.OwnerId, lList );
            }
            lList.add( visit );
        }
        
        Event previousVisit = null;
        Id idSalesRep = null;
        for( Id idOwner : mapVisits.keySet() )
        {
            List< Event > lList = mapVisits.get( idOwner );
            if( lList.isEmpty() ) continue;
            
            idSalesRep = null;
            previousVisit = null;
            for( Event currentVisit : lList )
            {
                //Primeira visita do vendedor
                if( idSalesRep != currentVisit.OwnerId )
                {
                    idSalesRep = currentVisit.OwnerId;
                }
                //Se o valor for diferente de NULL significa que não é a primeira visita do dia e o calculo deve ser feito
                if( previousVisit != null ) 
                {
                    Decimal lDistance = Location.getDistance(previousVisit.ICB_CustomerGeolocation__c, currentVisit.ICB_CustomerGeolocation__c, 'km');
                    currentVisit.ICB_PlannedDistance__c = lDistance;
                }
                //Atribui a visita atual para que na proxima iteração o calculo seja realizado
                previousVisit = currentVisit;
            }
        }
        Database.update(lstVisits);
    }
    
    /*******************************************************************
     Purpose: Actions to execute after class execution
     Parameters: [Database.Batchablecontext]
     Returns: [VOID]
     Throws [Exceptions]: [NONE]
     ********************************************************************/
    global void finish (Database.Batchablecontext bc)
    {
        
    }
}