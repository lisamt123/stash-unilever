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
public class ICB_CheckInCheckOut_CC 
{
	
    private static RecordType RT_IceCream = [Select Id From RecordType 
                                        WHERE DeveloperName =: Label.ICB_REC_TYPE_ICE_CREAM_VISIT 
                                        AND SobjectType =: Label.ICB_SOBJECT_EVENT];
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
        List<Event> visita = [SELECT Id, What.Name From Event Where Id =: visitId limit 1];
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
            ICB_Territory_Management__c territory = ICB_Territory_Management__c.getInstance(Userinfo.getUserId());
            String lTerritoryLike = '%'+territory.ICB_Territory_Code__c+'%';
            
            List< ContentDocument > lstCon = [SELECT Id, CreatedDate, Title FROM ContentDocument Where Title LIKE :lTerritoryLike
                                              Order by CreatedDate desc limit 1];
           if( !lstCon.isEmpty() )
           {
               content = lstCon[0];
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
                FROM Event Where Id =: visitId limit 1];
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
                system.debug('Exiting <newCheckIn>: ');
                return Label.ICB_WARNING_CHECKIN_SUCCESSFULLY;
            }
            
            // Check if geolocation found or not
            if( latitude == null || latitude == 0 || latitude == null || latitude == 0 )
            {
                system.debug('Exiting <newCheckIn>: ');
                return Label.ICB_WARNING_CANT_POSSIBLE_RETURN_GEO;
            }
            Location locCheck = Location.newInstance(latitude,longitude);
            
            Double lDistance = null;
            Double lDistanceLastCheckIn = null;
            if( visit.ICB_CustomerGeolocation__c != null && locCheck != null )
            {
                lDistance = Location.getDistance( visit.ICB_CustomerGeolocation__c, locCheck, 'km' );
            }
            else
            {
                //Set default value because there isn't customer geolocation
                lDistance = 0;
            }
            //Validate the distance beetwen the last visit and the current visit
            List<Event> lastVisit = [Select Id, ICB_GeolocationCheckOut__c
                                     From Event Where ICB_GeolocationCheckOut__Longitude__s != null 
                                     AND StartDateTime = today];
            lDistanceLastCheckIn = (lastVisit.size() > 0) ? Location.getDistance( lastVisit[0].ICB_GeolocationCheckOut__c, locCheck, 'km' ) : 0;
            
            Double lDistanceParameter = Double.valueOf(Label.ICB_Distance_Limit);
            
            isConfirmed = confirm;
            
            if( lDistance <= lDistanceParameter || isConfirmed )
            {
                visit.ICB_GeolocationCheckIn__Latitude__s = latitude;
                visit.ICB_GeolocationCheckIn__Longitude__s = longitude;
                visit.StartDateTime = system.now();
                visit.EndDateTime = system.now();
                visit.ICB_ExecutedDistance__c = lDistanceLastCheckIn;
                update visit;
                isConfirmed = false;
                system.debug('Exiting <newCheckIn>: '+Label.ICB_SUCCESS_CHECKIN_SUCCESSFULLY);
                return Label.ICB_SUCCESS_CHECKIN_SUCCESSFULLY;
            }
            else
            {
                isConfirmed = false;
                system.debug('Exiting <newCheckIn>: '+Label.ICB_ALERT_CHECKIN_OUT_CUSTOMER);
                return Label.ICB_ALERT_CHECKIN_OUT_CUSTOMER;
            }
        }
        catch(DMLException dmlex)
        {
            system.debug('Exiting <newCheckIn>: '+ Label.ICB_TEXT_ERROR+ dmlex.getDMLMessage(0));
            return Label.ICB_TEXT_ERROR+ dmlex.getDMLMessage(0);
        }
        catch(Exception ex)
        {
            system.debug('Exiting <newCheckIn>: '+Label.ICB_TEXT_ERROR + ex.getMessage());
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
                system.debug('Exiting <newCheckOut>: ');
                return Label.ICB_ERROR_CHECKIN_BEFORE_CHECKOUT;
            }
            system.debug('aaa ' + visit);
            if( visit.ICB_GeolocationCheckOut__Latitude__s != null )
            {
                system.debug('Exiting <newCheckOut>: ');
                return Label.ICB_WARNING_CHECKOUT_SUCCESSFULLY;
            }
            
            // Check if geolocation found or not
            if( latitude == null || latitude == 0 || longitude == null || longitude == 0)
            {
                system.debug('Exiting <newCheckOut>: ');
                return Label.ICB_WARNING_CANT_POSSIBLE_RETURN_GEO;
            }
            
            Location locCheck = Location.newInstance(latitude,longitude);
            
            Double lDistance = null;
            Double lDistanceLastCheckOut = null;
            if( visit.ICB_CustomerGeolocation__c != null && locCheck != null )
            {
                lDistance = Location.getDistance( visit.ICB_CustomerGeolocation__c, locCheck, 'km' );
            }
            else
            {
                //Set default value because there isn't customer geolocation
                lDistance = 0;
            }
            //Validate the distance beetwen the last visit and the current visit
            List<Event> lastVisit = [Select Id, ICB_GeolocationCheckOut__c
                                     From Event Where ICB_GeolocationCheckOut__Longitude__s != null and StartDateTime = today];
            lDistanceLastCheckOut = (lastVisit.size() > 0) ? Location.getDistance( lastVisit[0].ICB_GeolocationCheckOut__c, locCheck, 'km' ) : 0;
            
            Double lDistanceParameter = Double.valueOf(Label.ICB_Distance_Limit);
            
            isConfirmed = confirm;
            
            if( lDistance <= lDistanceParameter || isConfirmed )
            {
                visit.ICB_GeolocationCheckOut__Latitude__s = latitude;
                visit.ICB_GeolocationCheckOut__Longitude__s = longitude;
                visit.EndDateTime = system.now();
                visit.ICB_ExecutedDistance__c = lDistanceLastCheckOut;
                visit.ICB_Status__c = 'Concluded';
                update visit;
                
                isConfirmed = false;
                system.debug('Exiting <newCheckOut>: ');
                return Label.ICB_SUCCESS_CHECKOUT_SUCCESSFULLY;
            }
            else
            {
                isConfirmed = false;
                system.debug('Exiting <newCheckOut>: ');
                return Label.ICB_ALERT_CHECKOUT_OUT_CUSTOMER;
            }
        }
        catch(DMLException dmlex)
        {
            system.debug('Exiting <newCheckIn>: '+ Label.ICB_TEXT_ERROR+ dmlex.getDMLMessage(0));
            return Label.ICB_TEXT_ERROR + dmlex.getDMLMessage(0);
        }
        catch(Exception ex)
        {
            system.debug('Exiting <newCheckOut>: '+ex.getMessage());
            return Label.ICB_TEXT_ERROR + ex.getMessage();
        }
    }
}