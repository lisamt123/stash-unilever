/**********************************************************************
Name: CPA_TotalWorkingDyasBetweenTwoDates
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: Class for Calculating Working Dates between Two Days
-------
======================================================
======================================================
History: AC.08.05.03, AC.09.05.03, AC.11.05.03
-------
VERSION     AUTHOR                 DATE            DETAIL Description
1.0         Jayprakash Bharti       16/04/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/

public with sharing class CPA_TotalWorkingDyasBetweenTwoDates {

/*******************************************************************
    Purpose: This method is used to calculate date diff excluding weekends.
    Parameters: startDate, endDate
    Returns: Integer
    Throws [Exceptions]: 
    ********************************************************************/
    public static Integer totalWorkingDays(Date startDate, Date endDate) {
        Integer i = 0;
        DateTime startDt;
        DateTime endDt;
        if(startDate == null){
            startDt = System.now();
        }else{
            startDt = date2DatTime(startDate);
        }
        if(endDate == null){ 
            endDt = System.now();
        }else{
            endDt = date2DatTime(endDate);
        }
        while (startDt < endDt) {
            if (startDt.format('E') != 'Sat' && startDt.format('E') != 'Sun') {
                i++;
            }
            startDt = startDt.addDays(1);
        }

        return i;
    }
    
    
    /*******************************************************************
    Purpose: This method is used to Date to DateTime Datatype.
    Parameters: Date
    Returns: DateTime
    Throws [Exceptions]: 
    ********************************************************************/
    public static DateTime date2DatTime(Date newdt)
    {
        //Date dt = new Date();
        Date dt= newdt;
        return datetime.newInstance(dt.year(), dt.month(),dt.day());
    }   
}