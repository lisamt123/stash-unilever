/**********************************************************************
Name: CPA_getThreshold ()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This class is used to capture mandatory fields
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       06/05/2016     INITIAL DEVELOPMENT CSR

***********************************************************************/
public with sharing class  CPA_getThreshold {

/* Justification: We need to show warning messages at the top of the page for all mandatory fields, so for that
     * we have used multiple if conditions. If that field is null, flag warning message.
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     *  Dev team will fix this in next release.
     */
    /*******************************************************************
    Purpose: This method check  Threshold for  PWO
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static map<String,double> getThresholdPWO(CPA_project_work_order__c pwoRecord){
        map<String,double> mapThreshold = new map<String,double>();
        
        Map<string, CPA_Commercials_Threshold__c>  mapCommericalThreshold = new Map<string, CPA_Commercials_Threshold__c>();
        string RARecordtype = Schema.SObjectType.CPA_PWORF__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWORF_RA_RECORDTYPE ).getName ();
        String Ratype = RARecordtype;
        String strProjectScale='';
        String[] strPrjPhases;
        String strProjectPhases='';
        String strToCompare = '';
        mapCommericalThreshold = CPA_Commercials_Threshold__c.getAll(); 
        
        if(pwoRecord.fur_Project_Scale__c != null  ){
            strProjectScale = pwoRecord.fur_Project_Scale__c;
             strToCompare = (strProjectScale.substring(0,strProjectScale.indexOf('('))).trim();
             system.debug('strToCompare----->'+strToCompare);
        }
        
        if(pwoRecord.mpkl_Project_Phases__c != null){
             strPrjPhases = pwoRecord.mpkl_Project_Phases__c.split(';'); 
            
            for(String strPP : strPrjPhases){
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.PLAN)){
                   strProjectPhases = strProjectPhases + 'P';
               }
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.ANALYSE)){
                   strProjectPhases = strProjectPhases + 'A';
               }
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.DESIGN)){
                   strProjectPhases = strProjectPhases + 'D';
               }
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.BUILD)){
                   strProjectPhases = strProjectPhases + 'B';
               }
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.TEST)){
                   strProjectPhases = strProjectPhases + 'T';
               }
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.DEPLOY)){
                   strProjectPhases = strProjectPhases + 'D';
               }                           
                if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.OTHER)){
                   strProjectPhases = strProjectPhases + 'Other';
                }                          
            }
        }
                   
        for(string SLAMapKey: mapCommericalThreshold.keySet()){ 
        
            String nameFromSLAConfig = mapCommericalThreshold.get(SLAMapKey).Name;
            system.debug('strProjectPhases--->'+strProjectPhases);
            if(nameFromSLAConfig!=null && pwoRecord.fur_PWORFRecord_Type__c !=null){
                if(nameFromSLAConfig.equalsIgnoreCase('RA') && pwoRecord.fur_PWORFRecord_Type__c.equalsIgnoreCase('RA')){
                system.debug('RA');
                mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTOFF,double.valueof(mapCommericalThreshold.get(SLAMapKey).RA_Est_Off__c) );
                mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTON,double.valueof(mapCommericalThreshold.get(SLAMapKey).RA_Est_On__c ));
                mapThreshold.put(CPA_ConstantsForContractingAppClasses.EXP,double.valueof(mapCommericalThreshold.get(SLAMapKey).RA_Expense_Perc__c ));
                }
            
                if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.PA) && !pwoRecord.fur_PWORFRecord_Type__c.equalsIgnoreCase('RA')){
                    system.debug('CPA_ConstantsForContractingAppClasses.PA--'+CPA_ConstantsForContractingAppClasses.PA);
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTOFF,double.valueof(mapCommericalThreshold.get(SLAMapKey).PA_Est_Off__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTON,double.valueof(mapCommericalThreshold.get(SLAMapKey).PA_Est_On__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.EXP,double.valueof(mapCommericalThreshold.get(SLAMapKey).PA_Expense_Perc__c ));
                         
                }
                if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.PADBTD) && !pwoRecord.fur_PWORFRecord_Type__c.equalsIgnoreCase('RA')){
                    system.debug('CPA_ConstantsForContractingAppClasses.PADBTD--'+CPA_ConstantsForContractingAppClasses.PADBTD);
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTOFF,double.valueof(mapCommericalThreshold.get(SLAMapKey).PADBTD_Est_Off__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTON,double.valueof(mapCommericalThreshold.get(SLAMapKey).PADBTD_Est_On__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.EXP,double.valueof(mapCommericalThreshold.get(SLAMapKey).PADBTD_Expense_Perc__c ));   
                }
                if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.DBTD) && !pwoRecord.fur_PWORFRecord_Type__c.equalsIgnoreCase('RA')){
                    system.debug('CPA_ConstantsForContractingAppClasses.PADBTD-->'+CPA_ConstantsForContractingAppClasses.PADBTD);
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTOFF,double.valueof(mapCommericalThreshold.get(SLAMapKey).DBTD_Est_Off__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTON,double.valueof(mapCommericalThreshold.get(SLAMapKey).DBTD_Est_On__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.EXP,double.valueof(mapCommericalThreshold.get(SLAMapKey).DBTD_Expense_Perc__c ));        
                }
                if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.OTHER) && !pwoRecord.fur_PWORFRecord_Type__c.equalsIgnoreCase('RA')){
                system.debug('CPA_ConstantsForContractingAppClasses.OTHER---->'+CPA_ConstantsForContractingAppClasses.OTHER);
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTOFF,double.valueof(mapCommericalThreshold.get(SLAMapKey).Others_Est_Off__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTON,double.valueof(mapCommericalThreshold.get(SLAMapKey).Others_Est_On__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.EXP,double.valueof(mapCommericalThreshold.get(SLAMapKey).Others_Expense_Perc__c ));      
                }
            }
            
             
                
        }
        if(mapThreshold !=null){
            return mapThreshold;
        }
        return null;
    }
        
    /*******************************************************************
    Purpose: This method check  Threshold for  CR
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static map<String,double> getThresholdCR(CPA_CR__c CRRecord){
        map<String,double> mapThreshold = new map<String,double>();
        
        Map<string, CPA_Commercials_Threshold__c>  mapCommericalThreshold = new Map<string, CPA_Commercials_Threshold__c>();
        string RARecordtype = Schema.SObjectType.CPA_PWORF__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWORF_RA_RECORDTYPE).getName ();
        String Ratype = RARecordtype;
        String strProjectScale='';
        String[] strPrjPhases;
        String strProjectPhases='';
        String strToCompare = '';
        mapCommericalThreshold = CPA_Commercials_Threshold__c.getAll(); 
        
        if(CRRecord.fur_Project_Scale__c != null  ){
            strProjectScale = CRRecord.fur_Project_Scale__c;
             strToCompare = (strProjectScale.substring(0,strProjectScale.indexOf('('))).trim();
             system.debug('strToCompare----->'+strToCompare);
        }else if(CRRecord.pkl_PWORFDelta_Project_Scale__c!=null && CRRecord.fur_Project_Scale__c== null){
             strProjectScale = CRRecord.fur_Project_Scale__c;
             strToCompare = (strProjectScale.substring(0,strProjectScale.indexOf('('))).trim();
             system.debug('strToCompare----->'+strToCompare);
        }
        
        if(CRRecord.pkl_Project_Phases__c != null){
             strPrjPhases = CRRecord.pkl_Project_Phases__c.split(';'); 
            
            for(String strPP : strPrjPhases){
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.PLAN)){
                   strProjectPhases = strProjectPhases + 'P';
               }
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.ANALYSE)){
                   strProjectPhases = strProjectPhases + 'A';
               }
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.DESIGN)){
                   strProjectPhases = strProjectPhases + 'D';
               }
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.BUILD)){
                   strProjectPhases = strProjectPhases + 'B';
               }
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.TEST)){
                   strProjectPhases = strProjectPhases + 'T';
               }
               if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.DEPLOY)){
                   strProjectPhases = strProjectPhases + 'D';
               }                           
                if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.OTHER)){
                   strProjectPhases = strProjectPhases + 'Other';
                }                          
            }
        }
                   
        for(string SLAMapKey: mapCommericalThreshold.keySet()){ 
        
            String nameFromSLAConfig = mapCommericalThreshold.get(SLAMapKey).Name;
            system.debug('strProjectPhases--->'+strProjectPhases);
            if(nameFromSLAConfig!=null && CRRecord.fur_PWORFRecord_Type__c !=null){
                if(nameFromSLAConfig.equalsIgnoreCase('RA') && CRRecord.fur_PWORFRecord_Type__c.equalsIgnoreCase('RA')){
                system.debug('RA');
                mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTOFF,double.valueof(mapCommericalThreshold.get(SLAMapKey).RA_Est_Off__c) );
                mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTON,double.valueof(mapCommericalThreshold.get(SLAMapKey).RA_Est_On__c ));
                mapThreshold.put(CPA_ConstantsForContractingAppClasses.EXP,double.valueof(mapCommericalThreshold.get(SLAMapKey).RA_Expense_Perc__c ));
                }
            
                if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.PA) && !CRRecord.fur_PWORFRecord_Type__c.equalsIgnoreCase('RA')){
                    system.debug('CPA_ConstantsForContractingAppClasses.PA--'+CPA_ConstantsForContractingAppClasses.PA);
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTOFF,double.valueof(mapCommericalThreshold.get(SLAMapKey).PA_Est_Off__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTON,double.valueof(mapCommericalThreshold.get(SLAMapKey).PA_Est_On__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.EXP,double.valueof(mapCommericalThreshold.get(SLAMapKey).PA_Expense_Perc__c ));
                         
                }
                if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.PADBTD) && !CRRecord.fur_PWORFRecord_Type__c.equalsIgnoreCase('RA')){
                    system.debug('CPA_ConstantsForContractingAppClasses.PADBTD--'+CPA_ConstantsForContractingAppClasses.PADBTD);
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTOFF,double.valueof(mapCommericalThreshold.get(SLAMapKey).PADBTD_Est_Off__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTON,double.valueof(mapCommericalThreshold.get(SLAMapKey).PADBTD_Est_On__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.EXP,double.valueof(mapCommericalThreshold.get(SLAMapKey).PADBTD_Expense_Perc__c ));   
                }
                if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.DBTD) && !CRRecord.fur_PWORFRecord_Type__c.equalsIgnoreCase('RA')){
                    system.debug('CPA_ConstantsForContractingAppClasses.DBTD-->'+CPA_ConstantsForContractingAppClasses.PADBTD);
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTOFF,double.valueof(mapCommericalThreshold.get(SLAMapKey).DBTD_Est_Off__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTON,double.valueof(mapCommericalThreshold.get(SLAMapKey).DBTD_Est_On__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.EXP,double.valueof(mapCommericalThreshold.get(SLAMapKey).DBTD_Expense_Perc__c ));        
                }
                if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.OTHER) && !CRRecord.fur_PWORFRecord_Type__c.equalsIgnoreCase('RA')){
                system.debug('CPA_ConstantsForContractingAppClasses.OTHER---->'+CPA_ConstantsForContractingAppClasses.OTHER);
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTOFF,double.valueof(mapCommericalThreshold.get(SLAMapKey).Others_Est_Off__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.ESTON,double.valueof(mapCommericalThreshold.get(SLAMapKey).Others_Est_On__c ));
                    mapThreshold.put(CPA_ConstantsForContractingAppClasses.EXP,double.valueof(mapCommericalThreshold.get(SLAMapKey).Others_Expense_Perc__c ));      
                }
            }
            
             
                
        }
        if(mapThreshold !=null){
            return mapThreshold;
        }
        return null;
    }
            
        
}