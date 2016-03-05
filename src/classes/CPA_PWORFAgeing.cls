/**********************************************************************
Name: CPA_PWORFAgeing()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform claculation of PWORF Aging and TAT
-------
======================================================
======================================================
History: AC.08.05.03, AC.09.05.03, AC.11.05.03
-------
VERSION     AUTHOR                 DATE            DETAIL Description
1.0         Jayprakash Bharti       22/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_PWORFAgeing {

   //array of seven boolean indicating working days, Monday is index 0
    private static final List<Boolean> isWorkingDay;
    //count of the number of working days in the array
    private static final Integer workingDaysInWeek;
    static {
        //my real implementation uses the Salesforce BusinessHours Object to populate this array
        isWorkingDay = new List<Boolean> { true, true, true, true, true, false, false };
        //You will have real problems if this number does not match the number of true flags in the array
        workingDaysInWeek = 5;
    }
    private static final Date monday = Date.newInstance(1900, 1, 3);
    /*******************************************************************
    Purpose: This method is used to get day of week
    Parameters: value
    Returns: Integer
    Throws [Exceptions]: 
    ********************************************************************/
    private static Integer getDayOfWeek(Date value) {
        return Math.mod(monday.daysBetween(value), 7);
    }
    /*******************************************************************
    Purpose: This method is used to get working days
    Parameters: startDate, endDate
    Returns: Integer
    Throws [Exceptions]: 
    ********************************************************************/
    public static Integer getWorkingDays(Date startDate, Date endDate) {
        //when the number of working days is 0
        if(workingDaysInWeek == 0 || startDate == null || endDate == null) {
            return 0;
        } else {
            Integer difference = startDate.daysBetween(endDate);
            if(difference == 0) {
                //If the 2 dates are the same day check if the day is a working day or not
                return isWorkingDay[getDayOfWeek(startDate)] ? 1 : 0;
            } else if(workingDaysInWeek == 7) {
                //when every day is a working day return the difference
                return difference;
            } else {
                //The guts of the solution
                Integer wholeWeeks = Math.floor(difference / 7).intValue();
                Integer workingDays = wholeWeeks * workingDaysInWeek;
                Integer dayOfWeek = getDayOfWeek(endDate);
                for(Integer remainder = Math.mod(difference, 7); remainder >= 0; remainder--) {
                    if(isWorkingDay[remainder]) {
                        workingDays++;
                    }
                    dayOfWeek--;
                    if(dayOfWeek < 0) {
                        dayOfWeek = 6;
                    }
                }
                return workingDays;
            }
        }
    }// getWorkingDays() end    
                
                
    /*******************************************************************
    Purpose: This method is used to calculate ageing
    Parameters: LstPWORF
    Returns: void
    Throws [Exceptions]: 
    ********************************************************************/
    public static void calcualteAgeing(List<CPA_PWORF__c> LstPWORF){
        CPA_PWORF_Ageing__c tempPA ;
        CPA_PWORF_Ageing__c objPA;
        Integer nowPworfAge = 0;
        //CPA_PWORF__c pworfRec;
        List<CPA_PWORF__c> newLstPWORF = new List<CPA_PWORF__c>();
        Set<Id> setPWORFId = new Set<Id>();
        List<CPA_PWORF_Ageing__c> PaUpsertLst = new List<CPA_PWORF_Ageing__c>();

        Map<Id,CPA_PWORF_Ageing__c> mapPAIdPAobj = new Map<Id,CPA_PWORF_Ageing__c>();  //This Map contains PWORF_ID & CPA_PWORF_Ageing__c obj

        for(CPA_PWORF__c obj:LstPWORF){
        setPWORFId.add(obj.id);
        }
        newLstPWORF = [select id,pkl_Status__c,dat_Submitted_Date__c,dat_Withhold_Date__c,dat_Resubmitted_Date__c, dat_PWORF_Answered_Date__c from CPA_PWORF__c where id IN:setPWORFId];


        List<CPA_PWORF_Ageing__c> lstPA = [select id, PWORF_ID__c,num_PWORF_Age__c,num_Total_PWORF_Ageing_Days__c from CPA_PWORF_Ageing__c where PWORF_ID__c IN:setPWORFId];
        for(CPA_PWORF_Ageing__c obj:lstPA){
        mapPAIdPAobj.put(obj.PWORF_ID__c,obj);
        }


        for(CPA_PWORF__c pworfRec :newLstPWORF ){           
            tempPA = new CPA_PWORF_Ageing__c();

            if(pworfRec.pkl_Status__c== CPA_ConstantsForContractingAppClasses.WITHHOLD && pworfRec.dat_Submitted_Date__c !=null){        
                if(pworfRec.dat_Resubmitted_Date__c != null){
                    nowPworfAge = getWorkingDays(pworfRec.dat_Resubmitted_Date__c,System.today());
                }else{
                    nowPworfAge = getWorkingDays(pworfRec.dat_Submitted_Date__c,System.today());
                }        
                
            }else if (pworfRec.pkl_Status__c== CPA_ConstantsForContractingAppClasses.ANSWERED && pworfRec.dat_Submitted_Date__c != null){
                if(pworfRec.dat_Resubmitted_Date__c != null){
                    nowPworfAge = getWorkingDays(pworfRec.dat_Resubmitted_Date__c,System.today());
                }else{
                    nowPworfAge = getWorkingDays(pworfRec.dat_Submitted_Date__c,System.today());
                }
            }

            tempPA.PWORF_ID__c =   pworfRec.id;
            tempPA.txt_Status__c = pworfRec.pkl_Status__c;
            tempPA.dat_Submitted_Date__c = pworfRec.dat_Submitted_Date__c;
            tempPA.dat_Resubmitted_Date__c = pworfRec.dat_Resubmitted_Date__c;
            tempPA.Latest_Update_Date__c = system.now(); // Set current Date&Time
            
            if(mapPAIdPAobj != null && mapPAIdPAobj.size() >0){
                objPA = mapPAIdPAobj.get(pworfRec.id);
            }
                
            if(objPA == null){ // no record found then
                tempPA.num_PWORF_Age__c = nowPworfAge;
                tempPA.num_Total_PWORF_Ageing_Days__c = nowPworfAge;
                //insert tempPA;
            }else{
                tempPA.id= objPA.id;
                tempPA.num_PWORF_Age__c = nowPworfAge + objPA.num_PWORF_Age__c;  
                //update tempPA;
            }
            PaUpsertLst.add(tempPA);
        }// for end

        upsert PaUpsertLst;
    }//calcualteAgeing ends
  
    /*******************************************************************
    Purpose: This method will be called from Batch process schedular to calcuate final Pworf Aging Days
    Parameters: PAList
    Returns: void
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PworfAgeUpdateScheduler(List<CPA_PWORF_Ageing__c> PAList){
        system.debug('PworfAgeUpdateScheduler() >> Started');
        Decimal tempPworfAge = 0;
        List<CPA_PWORF_Ageing__c> newPAList = new List<CPA_PWORF_Ageing__c>();
        List<CPA_project_work_order__c> PwoList = new List<CPA_project_work_order__c>();

        Set<Id> setPworfId = new Set<Id> ();
        for(CPA_PWORF_Ageing__c Obj : PAList){
            setPworfId.add(Obj.PWORF_ID__c);
        }
        PwoList = [select id,pkl_Status__c,PWORF_ID__c from CPA_project_work_order__c where PWORF_ID__c IN:setPworfId];

        Map<CPA_project_work_order__c,Id> mapPwoPworfID = new Map<CPA_project_work_order__c,Id>();  //This Map contains PWO object & PWORF_ID
        for(CPA_project_work_order__c obj:PwoList){
            mapPwoPworfID.put(obj,obj.PWORF_ID__c); 
        }

        Map<Id,Integer> mapPworfIDTatAge = new Map<Id,Integer>();   //This Map contains PWORF_ID & TATAge

        for(CPA_PWORF_Ageing__c obj :PAList ){

            // start --> calcualtion of PWORF Age 

            if(obj.num_PWORF_Age__c == null){obj.num_PWORF_Age__c =0;}

            if(obj.txt_Status__c == 'Auto Accepted' || obj.txt_Status__c =='Returned' || obj.txt_Status__c =='Accepted'){
                if(obj.dat_Resubmitted_Date__c == null){
                    tempPworfAge = getWorkingDays(obj.dat_Submitted_Date__c,System.today());
                }
                else{
                    tempPworfAge = getWorkingDays(obj.dat_Resubmitted_Date__c,System.today()) + obj.num_PWORF_Age__c;
                }
            }
            else if(obj.txt_Status__c == 'Withhold' || obj.txt_Status__c == 'Answered'){
                tempPworfAge = obj.num_PWORF_Age__c; // no need to update
            }
            else if(obj.txt_Status__c == 'Submitted'){
                tempPworfAge = getWorkingDays(obj.dat_Submitted_Date__c,System.today());
            }
            else if(obj.txt_Status__c == 'Resubmitted'){
                tempPworfAge = getWorkingDays(obj.dat_Resubmitted_Date__c,System.today())+ obj.num_PWORF_Age__c;
            }
            else{
                tempPworfAge = 0;
            }
            obj.num_Total_PWORF_Ageing_Days__c = tempPworfAge.intValue();
            obj.Latest_Update_Date__c = system.now(); // Set current Date&Time
            
            newPAList.add(obj);
            mapPworfIDTatAge.put(obj.PWORF_ID__c,tempPworfAge.intValue());
            // End --> calcualtion of PWORF Age
        }

        update(newPAList);
        tatCalculation(mapPwoPworfID,mapPworfIDTatAge); // Upadate TAT object data
        system.debug('PworfAgeUpdateScheduler() >> Ends');
    }// PworfAgeUpdateScheduler() ends
    
    /*******************************************************************
    Purpose: This method will be used to calculate TAT
    Parameters: mapPwoPworfID, mapPworfIDTatAge
    Returns: void
    Throws [Exceptions]: 
    ********************************************************************/
    public static void tatCalculation(Map<CPA_project_work_order__c,Id> mapPwoPworfID , Map<Id,Integer> mapPworfIDTatAge){
        // start --> calcualtion of TAT
        List<CPA_TAT__c> newTATList = new List<CPA_TAT__c>();
        Set <CPA_project_work_order__c> PwoList = new Set<CPA_project_work_order__c>();
        PwoList = mapPwoPworfID.keySet();

        List<CPA_TAT__c> tempTatList = new List<CPA_TAT__c>();
        Set<Id> setPwoID = new Set<Id>();
        Map<Id,CPA_TAT__c> mapTat = new Map<Id,CPA_TAT__c>(); //This Map contains PWO_ID & TAT object

        for(CPA_project_work_order__c obj: PwoList){
            setPwoID.add(obj.id);   
        }

        tempTatList = [select id,lkp_PWO_ID__c,TAT_Days__c from CPA_TAT__c where lkp_PWO_ID__c IN:setPwoID];

        for(CPA_TAT__c obj: tempTatList){
            mapTat.put(obj.lkp_PWO_ID__c,obj);
        }

        for(CPA_project_work_order__c pwoObj : PwoList){

            if(mapTat.containsKey(pwoObj.Id)){
                mapTat.get(pwoObj.Id).TAT_Days__c = mapPworfIDTatAge.get(mapPwoPworfID.get(pwoObj));
                newTATList.add(mapTat.get(pwoObj.Id));
            }
            else{
                CPA_TAT__c tat = new CPA_TAT__c();
                tat.lkp_PWO_ID__c = pwoObj.id;
                tat.TAT_Days__c = mapPworfIDTatAge.get(mapPwoPworfID.get(pwoObj));
                newTATList.add(tat);    
            }
        }
        // End --> calcualtion of TAT
        upsert(newTATList);
    }
       
}