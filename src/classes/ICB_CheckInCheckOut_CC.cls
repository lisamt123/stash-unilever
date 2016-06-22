/**********************************************************************
Name: ICB_CheckInCheckOut_CC
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Controller class for lightning component 
ICB_CheckInCheckOut.cmp
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Carlos Carvalho 22/05/2016  Class creation  
***********************************************************************/
public with sharing class ICB_CheckInCheckOut_CC 
{
    private static Id idRecTypeIceCream = ICB_RecordTypeMemory.getRecType( Label.ICB_SOBJECT_EVENT, 
                                                                                   Label.ICB_REC_TYPE_ICE_CREAM_VISIT );
    public static Boolean isConfirmed = false;
    
    /*******************************************************************
     Purpose: Retrieve the specific Visit on the first load component
     Parameters: @visitId(Current record Id to retieve)
     Returns: Event
     Throws [Exceptions]: Exception
     ********************************************************************/
    @AuraEnabled
    public static Event getVisit(String visitId)
    {
        system.debug('Entering <getVisit>: '+ visitId);
        List<Event> visita = [SELECT Id, What.Name, WhatId, Account.SAP_ID__c, ICB_GeolocationCheckIn__Latitude__s,
                              ICB_GoldenMinuteOpen__c, ICB_Sales_Area__c From Event Where Id =: visitId 
                              AND REcordTypeId =: idRecTypeIceCream limit 1];
        system.debug('Exiting <getVisit>: '+ visita);
        if(!visita.isEmpty())
        {
          return visita[0];   
        }
        else
        {
            return null;
        }
    }
    
    @AuraEnabled
    //public static ContentDocument getCognosFile(String visitId){
    public static ContentDocument getCognosFile()
    {
        system.debug('Entering <getCognosFile>: NONE');
        ContentDocument content = null;
        
        try
        {
<<<<<<< HEAD
            Territory__c lTerritory = [SELECT Id, User__c, Territory_ID__c FROM Territory__c WHERE Id =: UserInfo.getUserId()];
=======
            Territory__c lTerritory = [SELECT Id, User__c, Territory_ID__c FROM Territory__c WHERE User__c =: UserInfo.getUserId()];
>>>>>>> develop
            String lTerritoryLike = '%'+lTerritory.Territory_ID__c+'%';
            
            List< ContentDocument > lstCon = [SELECT Id, CreatedDate, Title FROM ContentDocument Where Title LIKE :lTerritoryLike
                                              Order by CreatedDate desc limit 1];
            if( !lstCon.isEmpty() )
            {
                content = lstCon[0];
            }
        }
        catch(Exception e)
        {
            system.debug(e.getMessage());
        }
        
        system.debug('Exiting <getCognosFile>: '+ content);
        return content;
    }
    
    /*******************************************************************
     Purpose: Retrieve the specific Visti record (Event)
     Parameters: @visitId(Current record Id to retieve)
     Returns: Event
     Throws [Exceptions]: Exception
     ********************************************************************/
    @AuraEnabled
    public static Event getEvent(String visitId)
    {
        system.debug('Entering <getEvent>: '+ visitId);
        List<Event> visita = [SELECT Id, What.Name, WhatId, ICB_GeolocationCheckIn__c, ICB_GeolocationCheckIn__Latitude__s,
                ICB_GeolocationCheckIn__Longitude__s, EndDateTime, StartDateTime, ICB_CustomerGeolocation__c,
                ICB_CustomerGeolocation__Latitude__s, ICB_CustomerGeolocation__Longitude__s,ICB_GeolocationCheckOut__c, 
                ICB_GeolocationCheckOut__Longitude__s, ICB_GeolocationCheckOut__Latitude__s, ICB_ExecutedDistance__c 
                FROM Event Where Id =: visitId AND RecordTypeId =: idRecTypeIceCream  limit 1];
        if(!visita.isEmpty())
        {
            system.debug('Exiting <getEvent>: '+ visita);
            return visita[0];
        }
        else
        {
            return null;
        }
    }
    /*******************************************************************
     Purpose: Make checkin in the specific visit
     Parameters: @idRecord(Current record Id to make checkin)
                 @latitude / @longitude (Excact salesrep location when 
				 clicked in checkin button)
     Returns: String
     Throws [Exceptions]: DMLException, Exception
     ********************************************************************/
    @AuraEnabled
    public static String newCheckIn(String idRecord, Decimal latitude, Decimal longitude, Boolean confirm)
    {
        System.debug('Valor do idRecord: '+idRecord);
        System.debug('Valor do latitude: '+latitude);
        System.debug('Valor do longitude: '+longitude);
        System.debug('Valor do confirm: '+confirm);
        
        try
        {
            Event visit = getEvent(idRecord);
            if( visit.ICB_GeolocationCheckIn__Latitude__s != null )
            {
                return Label.ICB_WARNING_CHECKIN_SUCCESSFULLY;
            }
            if( latitude == null || latitude == 0 || latitude == null || latitude == 0 )
            {
                // Check if geolocation found or not
                return Label.ICB_WARNING_CANT_POSSIBLE_RETURN_GEO;
            }
            Location locCheck = Location.newInstance(latitude,longitude);
            Decimal lDistance = validateDistance(visit, locCheck);
            
            //Validate the distance beetwen the last visit and the current visit
            List<Event> lastVisit = [Select Id, ICB_GeolocationCheckOut__c From Event Where ICB_GeolocationCheckOut__Longitude__s != null 
                                     AND StartDateTime = today AND Id <>: visit.Id];
            Decimal lDistanceLastCheckIn = (lastVisit.size() > 0) ? Location.getDistance( lastVisit[0].ICB_GeolocationCheckOut__c, locCheck, 'km' ) : 0;
            Double lDistanceParameter = Double.valueOf(Label.ICB_Distance_Limit);
            isConfirmed = confirm;
            String lReturn;
            if( lDistance <= lDistanceParameter || isConfirmed )
            {
                Event lUpdateVisit = new Event(Id=visit.Id, ICB_GeolocationCheckIn__Latitude__s = latitude,
                                               ICB_GeolocationCheckIn__Longitude__s = longitude, StartDateTime = system.now(),
                                               EndDateTime = system.now(),ICB_ExecutedDistance__c = lDistanceLastCheckIn);
                update lUpdateVisit;
                isConfirmed = false;
                lReturn = Label.ICB_SUCCESS_CHECKIN_SUCCESSFULLY;
            }
            else
            {
                isConfirmed = false;
                lReturn = Label.ICB_ALERT_CHECKIN_OUT_CUSTOMER;
            }
            system.debug('Exiting <newCheckIn>: '+lReturn);
            return lReturn;
        }
        catch(Exception ex)
        {
            return Label.ICB_TEXT_ERROR + ex.getMessage();
        }
    }
    
    /*******************************************************************
     Purpose: Make checkin in the specific visit
     Parameters: @idRecord(Current record Id to make checkout)
                 @latitude / @longitude (Exact salesrep location when 
				 clicked in checkout button)
     Returns: String
     Throws [Exceptions]: DMLException, Exception
     ********************************************************************/
    @AuraEnabled
    public static String newCheckOut(String idRecord, Decimal latitude, Decimal longitude, Boolean confirm)
    {
        System.debug('Valor do idRecord: '+idRecord);
        System.debug('Valor do latitude: '+latitude);
        System.debug('Valor do longitude: '+longitude);
        System.debug('Valor do confirm: '+confirm);
        try
        {
            Event visit = getEvent(idRecord);
            if( visit.ICB_GeolocationCheckIn__Latitude__s == null )
            {
                return Label.ICB_ERROR_CHECKIN_BEFORE_CHECKOUT;
            }
            if( visit.ICB_GeolocationCheckOut__Latitude__s != null )
            {
                return Label.ICB_WARNING_CHECKOUT_SUCCESSFULLY;
            }
            if( latitude == null || latitude == 0 || longitude == null || longitude == 0)
            {
                // Check if geolocation found or not
                return Label.ICB_WARNING_CANT_POSSIBLE_RETURN_GEO;
            }
            Location locCheck = Location.newInstance(latitude,longitude);
            Decimal lDistance = validateDistance(visit, locCheck);
            
            Double lDistanceParameter = Double.valueOf(Label.ICB_Distance_Limit);
            isConfirmed = confirm;
            String lReturn;
            if( lDistance <= lDistanceParameter || isConfirmed )
            {
                Event lUpdateVisit = new Event(Id=visit.Id,ICB_GeolocationCheckOut__Latitude__s=latitude,
                                              ICB_GeolocationCheckOut__Longitude__s=longitude, EndDateTime=system.now(),
                                              ICB_Status__c='Concluded');
                update lUpdateVisit;
                isConfirmed = false;
                lReturn = Label.ICB_SUCCESS_CHECKOUT_SUCCESSFULLY;
            }
            else
            {
                isConfirmed = false;
                lReturn = Label.ICB_ALERT_CHECKOUT_OUT_CUSTOMER;
            }
            system.debug('Exiting <newCheckOut>: '+lReturn);
            return lReturn;
        }
        catch(Exception ex)
        {
            return Label.ICB_TEXT_ERROR + ex.getMessage();
        }
    }
    
    private static Decimal validateDistance(Event lVisit, Location lLoc ){
        Double lDistance = 0;
        if( lVisit.ICB_CustomerGeolocation__c != null && lLoc != null )
        {
            lDistance = Location.getDistance( lVisit.ICB_CustomerGeolocation__c, lLoc, 'km' );
        }
        return lDistance;
    }
    
    /*******************************************************************
     Purpose: Retrieve the specific Visit on the first load component
     Parameters: @visitId(Current record Id to retieve)
     Returns: Event
     Throws [Exceptions]: Exception
     ********************************************************************/
    @AuraEnabled
    public static Boolean setGoldenMinuteOpen(String idVisit){
        system.debug('Entering <setGoldenMinuteOpen>: '+ idVisit);
        Boolean lIsConfirmed = false;
        try
        {
        	Event lVisit = [Select Id, ICB_GoldenMinuteOpen__c FROM Event Where Id =: idVisit];
            lVisit.ICB_GoldenMinuteOpen__c = true;
            update lVisit;
            lIsConfirmed = lVisit.ICB_GoldenMinuteOpen__c;
        }
        catch(Exception e)
        {
        	system.debug(e.getMessage());    
        }
        system.debug('Exit <setGoldenMinuteOpen>: '+ lIsConfirmed);
        return lIsConfirmed;
    }
}