/**********************************************************************
Name: CPA_CalculationOfBusinessDaysForSLADates()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to add business days to current date for expected SLA date calculation
-------
======================================================
======================================================
History: Modified class name against Unilevers coding standards
-------
VERSION     AUTHOR         DATE            DETAIL Description
1.0         Dinesh Girase  13/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_CalculationOfBusinessDaysForSLADates{

    //Holiday logic is pending
    
   /*
    * Method Name : isWeekendDay
    * Parameter   : dateParam
    * Return type : Boolean
    * Description : This method identifies week ends and returns true or false
    */
    public static Boolean isWeekendDay(Date dateParam)
    {
        boolean result     = false;
        //Recover the day of the week
        Date startOfWeek   = dateParam.toStartOfWeek();
        //Integer dayOfWeek  = dateParam.day() - startOfWeek.day();
        Integer dayOfWeek = startOfWeek.daysBetween(dateParam);
        result = dayOfWeek == 0 || dayOfWeek == 6 ? true : false;
        return result;
    } 
   
   /*******************************************************************
    Purpose: This method is used to add business days to the given date
    Parameters: startDate, businessDaysToAdd
    Returns: Date
    Throws [Exceptions]: 
    ********************************************************************/
   public static Date addBusinessDays(Date startDate, integer businessDaysToAdd )
    {
        Integer businessDaysCount = 0;
        businessDaysCount = businessDaysToAdd;
        //Add or decrease in businessDaysToAdd days 
        Date finalDate = startDate;
        integer direction = businessDaysCount < 0 ? -1 : 1;
        while(businessDaysCount != 0)
        {
            finalDate = finalDate.AddDays(direction);
            if (!isWeekendDay(finalDate))
            {
                businessDaysCount -= direction;
               
            }
        }
        return finalDate;
    }
   
    /**   Method Name : generateInternalPWOID
    * Parameter   : oldPWORFList,newPWORFList
    * Return type : None
    * Author      : Dinesh Girase  
    * Description : This method creates Internal PWO ID when PWORF is Accepted and store it on PWORF.
    */
   public static void generateInternalPWOID(List<CPA_PWORF__c> oldPWORFList, List<CPA_PWORF__c> newPWORFList){
       if(newPWORFList[0].pkl_Status__c != null && (newPWORFList[0].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.ACCEPTED)|| newPWORFList[0].pkl_Status__c=='Auto Accepted')  && (!oldPWORFList[0].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.ACCEPTED)|| oldPWORFList[0].pkl_Status__c!='Auto Accepted')){
            List<CPA_PWORF__c> pworfs = [SELECT txt_Internal_PWO_ID__c FROM CPA_PWORF__c Where Id =: newPWORFList[0].ID];
            newPWORFList[0].txt_Internal_PWO_ID__c = pwoInternalCountLogic(false);           
        }
    }
    /*******************************************************************
    Purpose: This method is used to create internal PWO number
    Parameters: secondPWO
    Returns: String
    Throws [Exceptions]: 
    ********************************************************************/
    public static string  pwoInternalCountLogic(boolean secondPWO){
        integer count=0;
        List<CPA_project_work_order__c> pwoCnt = [SELECT id FROM CPA_project_work_order__c Limit 50000];
        List<CPA_PWORF__c>pworfRecord = [SELECT Id,(select id from PWO11__r) FROM CPA_PWORF__c Where pkl_Status__c='Accepted' or pkl_Status__c='Auto Accepted'];     
        List<CPA_PWORF__c> pworfsAccepted = [SELECT id FROM CPA_PWORF__c Where pkl_Status__c='Accepted' or pkl_Status__c='Auto Accepted'];
        for(CPA_PWORF__c pworf : pworfRecord){
            if(pworf.PWO11__r.size()>0)
                    count =count+1;
        }
        Integer maxNo1 = pworfsAccepted.size() - count;
        Integer maxNo = 0;
        String newInternalPWOID = null;
        if(pwoCnt.size()>0){
            maxNo = pwoCnt.size();
            if(secondPWO) 
                maxNo = maxNo  + maxNo1 + 1;
            else 
                maxNo = maxNo  + maxNo1;
            newInternalPWOID = getInternalPWOID(maxNo);
        }
        return newInternalPWOID;
    }
    
    /**   Method Name : forSearch
    * Parameter   : oldPWORFList,newPWORFList
    * Return type : None
    * Author      : Dinesh Girase  
    * Description : This method creates Internal PWO ID, if not present on PWORF. This logic will work only when PWORF is
    *    status is Accepted
    */
   /* public static void forSearch(List<CPA_PWORF__c> oldPWORFList, List<CPA_PWORF__c> newPWORFList){
        //if(oldPWORFList[0].pkl_Status__c != null && newPWORFList[0].pkl_Status__c != null){
        if(newPWORFList[0].pkl_Status__c != null && newPWORFList[0].pkl_Status__c.equalsIgnoreCase('Accepted')){
           
        
            Integer maxNo=0;
            List<AggregateResult> maxNum = new List<AggregateResult>();
            maxNum = [SELECT Max(For_Search_Numeric__c) FROM CPA_PWORF__c];
           if(maxNum[0].get('expr0') != null){
                maxNo = Integer.valueOf(maxNum[0].get('expr0') + '');
                
            }
            
            for(AggregateResult maxNumber : maxNum){
                if(maxNumber.get('expr0') != null){
                    maxNo = Integer.valueOf(maxNumber.get('expr0') + '');
                  
                }else{
                    maxNo = 0;
                    
                }
            }
            List<CPA_PWORF__c> pworfs = [SELECT For_Search__c, For_Search_Numeric__c FROM CPA_PWORF__c Where Id =: newPWORFList[0].ID];
            if(pworfs[0].For_Search__c == null || pworfs[0].For_Search__c == ''){
                String newInternalPWOID = getInternalPWOID(maxNo);
                pworfs[0].For_Search__c = newInternalPWOID;
                pworfs[0].txt_Internal_PWO_ID__c = newInternalPWOID;
                pworfs[0].For_Search_Numeric__c = maxNo + 1;
                
                update pworfs;
            } else{
              
            }
        }
    }*/
    
    /**   Method Name : getInternalPWOID
    * Parameter   : numSearch
    * Return type : Strint
    * Author      : Dinesh Girase  
    * Description : This method generates incremental Internal PWO ID
    */
    public static String getInternalPWOID(Integer numSearch){
        String strPWOID='';
        integer intIncrementNum = numSearch;//+ 1;
        if(string.valueof(numSearch).length() == 1)
            strPWOID = 'PWO-0000' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 2)
            strPWOID = 'PWO-000' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 3)
            strPWOID = 'PWO-00' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 4)
            strPWOID = 'PWO-0' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 5)
            strPWOID = 'PWO-' + string.valueof(intIncrementNum);
        return strPWOID;
    }
}