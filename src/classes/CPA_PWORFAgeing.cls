/*
 * @author Jayprakash Bharti(M1033242)
 * @date 22/01/2016
 * @description - This Class is used to perform claculation of PWORF Aging and TAT
 */

public with sharing class CPA_PWORFAgeing {
                
  static Integer nowPworfAge = 0;
  static CPA_PWORF__c pworfRec;
  
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
    private static Integer getDayOfWeek(Date value) {
        return Math.mod(monday.daysBetween(value), 7);
    }
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
                
                
                
  public static void calcualteAgeing(List<CPA_PWORF__c> LstPWORF){
    CPA_PWORF_Ageing__c tempPA ;
    for(CPA_PWORF__c newPworf :LstPWORF ){
        
        tempPA = new CPA_PWORF_Ageing__c();
        
        pworfRec = [select id,pkl_Status__c,dat_Submitted_Date__c,dat_Withhold_Date__c,dat_Resubmitted_Date__c, dat_PWORF_Answered_Date__c from CPA_PWORF__c where id =:newPworf.id];
      
     // if(newPworf.num_PWORF_Age__c== null ){newPworf.num_PWORF_Age__c= 0; }
      //if(pworfRec.num_PWORF_Age__c== null ){pworfRec.num_PWORF_Age__c= 0; }
      
      system.debug('Pre Record >>>' + pworfRec);
      
      if(newPworf.pkl_Status__c== 'Withhold' && pworfRec.dat_Submitted_Date__c !=null){        
        if(pworfRec.dat_Resubmitted_Date__c != null){
          nowPworfAge = getWorkingDays(pworfRec.dat_Resubmitted_Date__c,System.today());
        }else{
          nowPworfAge = getWorkingDays(pworfRec.dat_Submitted_Date__c,System.today());
        }        
        system.debug('In WithHold  days >'+ nowPworfAge + 'System.today() >>'+ System.today());
        
      }else if (newPworf.pkl_Status__c== 'Answered' && pworfRec.dat_Submitted_Date__c != null){
        if(pworfRec.dat_Resubmitted_Date__c != null){
            nowPworfAge = getWorkingDays(pworfRec.dat_Resubmitted_Date__c,System.today());
        }else{
            nowPworfAge = getWorkingDays(pworfRec.dat_Submitted_Date__c,System.today());
          }
        system.debug('In Answered  days >'+ nowPworfAge + 'System.today() >>'+ System.today());      
      }
      
      tempPA.PWORF_ID__c =   pworfRec.id;
      tempPA.txt_Status__c = pworfRec.pkl_Status__c;
      tempPA.dat_Submitted_Date__c = pworfRec.dat_Submitted_Date__c;
      tempPA.dat_Resubmitted_Date__c = pworfRec.dat_Resubmitted_Date__c;
      
      List<CPA_PWORF_Ageing__c> lstPA = [select id, PWORF_ID__c,num_PWORF_Age__c,num_Total_PWORF_Ageing_Days__c from CPA_PWORF_Ageing__c where PWORF_ID__c =: newPworf.id];
      if(lstPA == null || lstPA.size() <= 0){ // no record found then
        tempPA.num_PWORF_Age__c = nowPworfAge;
        tempPA.num_Total_PWORF_Ageing_Days__c = nowPworfAge;
        insert tempPA;
      }else{
        tempPA.id= lstPA[0].id;
        tempPA.num_PWORF_Age__c = nowPworfAge + lstPA[0].num_PWORF_Age__c;  
        update tempPA;
      }
      system.debug('Record updated in CPA_PWORF_Ageing__c >>>' + tempPA);  
    }

   
  }//calcualteAgeing ends
  
  //This method will be called from Batch process schedular to calcuate final Pworf Aging Days

    public static void PworfAgeUpdateScheduler(List<CPA_PWORF_Ageing__c> PAList){
        system.debug('PworfAgeUpdateScheduler() >> Started');
        
        Decimal tempPworfAge = 0;
        List<CPA_PWORF_Ageing__c> newPAList = new List<CPA_PWORF_Ageing__c>();
        List<CPA_TAT__c> newTATList = new List<CPA_TAT__c>();
               
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
            
            newPAList.add(obj);
            
        // End --> calcualtion of PWORF Age
            
        // start --> calcualtion of TAT
        
            List<CPA_TAT__c> tempTatList = new List<CPA_TAT__c>();
            List<CPA_project_work_order__c> PwoList = new List<CPA_project_work_order__c>();
            PwoList = [select id,pkl_Status__c from CPA_project_work_order__c where PWORF_ID__c =: obj.PWORF_ID__c];
            
            
            for(CPA_project_work_order__c pwoObj : PwoList){
            
            tempTatList = [select id,lkp_PWO_ID__c,TAT_Days__c from CPA_TAT__c where lkp_PWO_ID__c =: pwoObj.id];
                
                if(tempTatList == null || tempTatList.size() <= 0){
                    CPA_TAT__c tat = new CPA_TAT__c();
                    tat.lkp_PWO_ID__c = pwoObj.id;
                    tat.TAT_Days__c = tempPworfAge.intValue();
                    newTATList.add(tat);
                }else{
                    tempTatList[0].TAT_Days__c = tempPworfAge.intValue();
                    newTATList.add(tempTatList[0]);
                }
            }

        // End --> calcualtion of TAT
        

        }
        update(newPAList);
        upsert(newTATList);
        

        system.debug('PworfAgeUpdateScheduler() >> Ends');
    }// PworfAgeUpdateScheduler() ends

}