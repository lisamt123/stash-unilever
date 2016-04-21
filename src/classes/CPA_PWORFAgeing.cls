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

public static boolean runOnceFlag = true;

/*******************************************************************
    Purpose: This method is used to Insert the Pworf Ageing record on PWORF creation.
    Parameters: LstPWORF
    Returns: void
    Throws [Exceptions]: 
    ********************************************************************/
    public static boolean InsertPworfAgeingRecord(List<CPA_PWORF__c> LstPWORF){
        List<CPA_PWORF_Ageing__c> PaUpsertLst = new List<CPA_PWORF_Ageing__c>();
        CPA_PWORF_Ageing__c tempPA = null;
        for(CPA_PWORF__c pworfRec :LstPWORF ){           
            tempPA = new CPA_PWORF_Ageing__c();
            tempPA.PWORF_ID__c =   pworfRec.id;
            tempPA.dat_Latest_Update_Date__c = system.now(); // Set current Date&Time
            tempPA.num_PWORF_Age__c = 0;
            tempPA.num_Total_PWORF_Ageing_Days__c = 0;
            PaUpsertLst.add(tempPA);
        }// for end
        upsert PaUpsertLst;
        return true;    
    }

                  
    /*******************************************************************
    Purpose: This method is used to update calculate ageing
    Parameters: LstPWORF
    Returns: void
    Throws [Exceptions]: 
    ********************************************************************/
    public static boolean updatePworfAgeingRecord(List<CPA_PWORF__c> oldPWORFlst,List<CPA_PWORF__c> LstPWORF){
        
        if(!runOnceFlag){
          
            return false; // code execution will return false and pervent futher execution as It is 2nd call for same action.
        }
        
        //Initialized below two variables to fix SonarQube issue
        //Variable not assigned: Found 'UR'-anomaly for variable 'objpa' (lines '81'-'132')
        CPA_PWORF_Ageing__c tempPA = null;
        CPA_PWORF_Ageing__c objPA = null;
        Integer nowPworfAge = 0;
        boolean onedayGapFlag = true;
        
        //below code is to execute full code only if status is changed.
        Map<ID,String> oldPWORFMap = new Map<Id,String>();
        
        for(CPA_PWORF__c old : oldPWORFlst){
            oldPWORFMap.put(old.id,old.pkl_Status__c);
        }
    
        List<CPA_PWORF__c> newLstPWORF = new List<CPA_PWORF__c>();
        Set<Id> setPWORFId = new Set<Id>();
        List<CPA_PWORF_Ageing__c> PaUpsertLst = new List<CPA_PWORF_Ageing__c>();

        Map<Id,CPA_PWORF_Ageing__c> mapPAIdPAobj = new Map<Id,CPA_PWORF_Ageing__c>();  //This Map contains PWORF_ID & CPA_PWORF_Ageing__c obj

        for(CPA_PWORF__c obj:LstPWORF){// will create set of pworfid whose staus is changed or Pworf is newly inserted
            if(oldPWORFMap.get(obj.id)==null || !(oldPWORFMap.get(obj.id)).equalsIgnoreCase(obj.pkl_Status__c)){
                setPWORFId.add(obj.id);
            }
        }
        
        if(setPWORFId.size()<=0){
            
            return false; // code execution will return false and pervent futher execution as there is no status change for the record.
        }
        
        newLstPWORF = [select id,pkl_Status__c,dat_Submitted_Date__c,dat_Withhold_Date__c,dat_Resubmitted_Date__c, dat_PWORF_Answered_Date__c, dat_VDM_Request_return_Date__c from CPA_PWORF__c where id IN:setPWORFId];


        List<CPA_PWORF_Ageing__c> lstPA = [select id, PWORF_ID__c,num_PWORF_Age__c,num_Total_PWORF_Ageing_Days__c,dat_Latest_Update_Date__c from CPA_PWORF_Ageing__c where PWORF_ID__c IN:setPWORFId];
        for(CPA_PWORF_Ageing__c obj:lstPA){
        mapPAIdPAobj.put(obj.PWORF_ID__c,obj);
        }


        for(CPA_PWORF__c pworfRec :newLstPWORF ){           
            tempPA = new CPA_PWORF_Ageing__c();
            
            if(pworfRec.dat_Resubmitted_Date__c !=null && pworfRec.dat_Resubmitted_Date__c == system.today()){
                onedayGapFlag = false;
            }else if(pworfRec.dat_Submitted_Date__c !=null && pworfRec.dat_Submitted_Date__c == system.today()){
                onedayGapFlag = false;
            }
            if(onedayGapFlag){              
                if(pworfRec.pkl_Status__c== CPA_ConstantsForPworfAging.WITHHOLD && pworfRec.dat_Submitted_Date__c !=null){
                    
                    if(pworfRec.dat_VDM_Request_return_Date__c == null){
                        if(pworfRec.dat_Resubmitted_Date__c != null){
                            nowPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(pworfRec.dat_Resubmitted_Date__c,System.today());
                        }else{
                            nowPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(pworfRec.dat_Submitted_Date__c,System.today());
                        }        
                    }else{
                        if(pworfRec.dat_Resubmitted_Date__c != null && (pworfRec.dat_Resubmitted_Date__c > pworfRec.dat_VDM_Request_return_Date__c)){
                            nowPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(pworfRec.dat_Resubmitted_Date__c,System.today());
                        }else{
                            nowPworfAge = 0; // as this withheld will happen after Return, soo recalculation is not required.
                        }
                    }
                   
                }
                else if (pworfRec.pkl_Status__c== CPA_ConstantsForPworfAging.ANSWERED && pworfRec.dat_Submitted_Date__c != null){
                    if(pworfRec.dat_Resubmitted_Date__c != null){
                        nowPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(pworfRec.dat_Resubmitted_Date__c,System.today());
                    }else{
                        nowPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(pworfRec.dat_Submitted_Date__c,System.today());
                    }
                   
                } 
                else if (pworfRec.pkl_Status__c== CPA_ConstantsForPworfAging.RETURNED && pworfRec.dat_Submitted_Date__c != null){
                    if(pworfRec.dat_Resubmitted_Date__c != null){
                        nowPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(pworfRec.dat_Resubmitted_Date__c,System.today());
                    }else{
                        nowPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(pworfRec.dat_Submitted_Date__c,System.today());
                    }
                 
                }
            }
            tempPA.PWORF_ID__c =   pworfRec.id;
            tempPA.dat_Latest_Update_Date__c = system.now(); // Set current Date&Time
            
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
        PworfAgeUpdateScheduler(PaUpsertLst);
        runOnceFlag = false;
        return true;
    }//calcualteAgeing ends
  
    /*******************************************************************
    Purpose: This method will be called from Batch process schedular to calcuate final Pworf Aging Days
    Parameters: PAList
    Returns: void
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PworfAgeUpdateScheduler(List<CPA_PWORF_Ageing__c> currentPAList){
      
        Decimal tempPworfAge = 0;
        Boolean refreshPAListFlag = false;
        
        List<CPA_PWORF_Ageing__c> newPAList = new List<CPA_PWORF_Ageing__c>();
        List<CPA_project_work_order__c> PwoList = new List<CPA_project_work_order__c>();
        List<CPA_PWORF_Ageing__c> PAList = new List<CPA_PWORF_Ageing__c>();
        PAList = currentPAList; // assigning the incomming PAList to a list
        
        Set<Id> setPworfId = new Set<Id> ();
        for(CPA_PWORF_Ageing__c Obj : PAList){
            setPworfId.add(Obj.PWORF_ID__c);
            if(obj.fml_Status__c == null){
                refreshPAListFlag = true;
            }
        }
        PwoList = [select id,pkl_Status__c,PWORF_ID__c from CPA_project_work_order__c where PWORF_ID__c IN:setPworfId];
        
        if(refreshPAListFlag){
            PAList = [select id, PWORF_ID__c, fml_Status__c, fml_Submitted_Date__c, fml_Resubmitted_Date__c, num_PWORF_Age__c, num_Total_PWORF_Ageing_Days__c from CPA_PWORF_Ageing__c where PWORF_ID__c IN:setPworfId];
            
        }
        
        Map<CPA_project_work_order__c,Id> mapPwoPworfID = new Map<CPA_project_work_order__c,Id>();  //This Map contains PWO object & PWORF_ID
        for(CPA_project_work_order__c obj:PwoList){
            mapPwoPworfID.put(obj,obj.PWORF_ID__c); 
        }

        Map<Id,Integer> mapPworfIDTatAge = new Map<Id,Integer>();   //This Map contains PWORF_ID & TATAge

        for(CPA_PWORF_Ageing__c obj :PAList ){

           

            if(obj.num_PWORF_Age__c == null){obj.num_PWORF_Age__c =0;}

            if(obj.fml_Status__c == CPA_ConstantsForPworfAging.AUTOACCEPT || obj.fml_Status__c == CPA_ConstantsForPworfAging.ACCEPTED){
                if(obj.fml_Resubmitted_Date__c == null){
                    tempPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(obj.fml_Submitted_Date__c,System.today());
                }
                else{
                    tempPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(obj.fml_Resubmitted_Date__c,System.today()) + obj.num_PWORF_Age__c;
                }
                
                
            }
            else if(obj.fml_Status__c == CPA_ConstantsForPworfAging.RETURNED || obj.fml_Status__c == CPA_ConstantsForPworfAging.WITHHOLD || obj.fml_Status__c == CPA_ConstantsForPworfAging.ANSWERED){
                tempPworfAge = obj.num_PWORF_Age__c; // no need to update
                
            }
            else if(obj.fml_Status__c == CPA_ConstantsForPworfAging.SUBMITTED){
                tempPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(obj.fml_Submitted_Date__c,System.today());
                
            }
            else if(obj.fml_Status__c == CPA_ConstantsForPworfAging.RESUBMITTED){
                tempPworfAge = CPA_TotalWorkingDyasBetweenTwoDates.totalWorkingDays(obj.fml_Resubmitted_Date__c,System.today())+ obj.num_PWORF_Age__c;
                
            }
            else{
                tempPworfAge = 0;
            }
            obj.num_Total_PWORF_Ageing_Days__c = tempPworfAge.intValue();
            obj.dat_Latest_Update_Date__c = system.now(); // Set current Date&Time
            
            newPAList.add(obj);
            mapPworfIDTatAge.put(obj.PWORF_ID__c,tempPworfAge.intValue());
            // End --> calcualtion of PWORF Age
            
        }

        update(newPAList);
        tatCalculation(mapPwoPworfID,mapPworfIDTatAge); // Upadate TAT object data
        
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

        tempTatList = [select id,txt_Status__c,lkp_PWO_ID__c,TAT_Days__c ,dat_Latest_Update_Date__c from CPA_TAT__c where lkp_PWO_ID__c IN:setPwoID];

        for(CPA_TAT__c obj: tempTatList){
            mapTat.put(obj.lkp_PWO_ID__c,obj);
        }

        for(CPA_project_work_order__c pwoObj : PwoList){

            if(mapTat.containsKey(pwoObj.Id)){
                mapTat.get(pwoObj.Id).dat_Latest_Update_Date__c = system.now();
                mapTat.get(pwoObj.Id).TAT_Days__c = mapPworfIDTatAge.get(mapPwoPworfID.get(pwoObj));
                mapTat.get(pwoObj.Id).txt_Status__c = pwoObj.pkl_Status__c;
                newTATList.add(mapTat.get(pwoObj.Id));
               
            }
            else{
                CPA_TAT__c tat = new CPA_TAT__c();
                tat.lkp_PWO_ID__c = pwoObj.id;
                tat.TAT_Days__c = mapPworfIDTatAge.get(mapPwoPworfID.get(pwoObj));
                tat.dat_Latest_Update_Date__c = system.now();
                tat.txt_Status__c = pwoObj.pkl_Status__c;
                newTATList.add(tat);  
              
            }
            
        }
        // End --> calcualtion of TAT
        upsert(newTATList);
    }
   }