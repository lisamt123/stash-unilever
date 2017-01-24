/**************************************************************************************************************
* @Class            : UL_AccountTriggerHandler
* @Description      : Handler class for trigger on Account
* @CreatedBy/Date   : Accenture IDC, 5/10/2016
* @Updates By/Date  : 
**************************************************************************************************************/ 
public without sharing class UL_AccountTriggerHandler{
    private static Integer levelNo{set;get;}
    
    /***********************************************
* @Method      : planningLevelValidations
* @Description : method to handle validations while setting Planning Level for Customer, calls other methods for validity dates check, currency check.
* @Arguments    : Trigger new and old list and new, old maps
* @Return Type  : -NA-
***********************************************/
    public static void planningLevelValidations(List<Account> oldAccLst, Map<Id,Account> oldAccMap, List<Account> newAccLst, Map<Id,Account> newAccMap){
        List<Account> hierAccLst = new List<Account>() ;
        List<Account> PLAccLst = new List<Account>() ; 
        Map<Id, Id> accIdHierAccMap = new  Map<Id, Id>() ;
        Map<Id, Id> accIdPLAccIdMap= new  Map<Id, Id>() ;
        
        try{
            for(Account updAcc : newAccLst){
                system.debug('dates '+updAcc.UL_Customer_Role_Valid_From__c+ ' ' + updAcc.UL_Customer_Role_Valid_Thru__c);
                if(updAcc.UL_Customer_Role_Valid_From__c == NULL || updAcc.UL_Customer_Role_Valid_Thru__c == NULL){
                    System.debug('within dates if');
                    updAcc.addError(System.Label.UL_PlanningStartEndDate) ;
                }
            }
        }        
        catch(Exception e){
            System.debug('An exception occurred in Plannong Date block : ' + e.getMessage());
        }
        
        try{              
            //if(hierAccLst.size() > 0){
            for(Account newAcc : newAccLst){
                String level1 = newAcc.UL_Customer_Hierarchy_Level__c;  
                Integer levelNumber;
                List<Account>  lastLevAccLst = new List<Account>();                    
                if(String.isNotBlank(level1)){
                    level1 = level1.substringAfter(' ');      
                    levelNumber = Integer.valueOf(level1);
                }
                
                lastLevAccLst = getLastLevAcc(newAcc, levelNumber) ;
                system.debug('lastLevAccLst1 '+lastLevAccLst);
                
                if(lastLevAccLst.size() > 0){
                    if(lastLevAccLst[0].UL_Level_1__c != NULL){accIdHierAccMap.put(lastLevAccLst[0].UL_Level_1__c, newAcc.Id) ;}
                    if(lastLevAccLst[0].UL_Level_2__c != NULL){accIdHierAccMap.put(lastLevAccLst[0].UL_Level_2__c, newAcc.Id) ;}
                    if(lastLevAccLst[0].UL_Level_3__c != NULL){accIdHierAccMap.put(lastLevAccLst[0].UL_Level_3__c, newAcc.Id) ;}
                    if(lastLevAccLst[0].UL_Level_4__c != NULL){accIdHierAccMap.put(lastLevAccLst[0].UL_Level_4__c, newAcc.Id) ;}
                    if(lastLevAccLst[0].UL_Level_5__c != NULL){accIdHierAccMap.put(lastLevAccLst[0].UL_Level_5__c, newAcc.Id) ;}
                    if(lastLevAccLst[0].UL_Level_6__c != NULL){accIdHierAccMap.put(lastLevAccLst[0].UL_Level_6__c, newAcc.Id) ;}
                    if(lastLevAccLst[0].UL_Level_7__c != NULL){accIdHierAccMap.put(lastLevAccLst[0].UL_Level_7__c, newAcc.Id) ;}
                    if(lastLevAccLst[0].UL_Level_8__c != NULL){accIdHierAccMap.put(lastLevAccLst[0].UL_Level_8__c, newAcc.Id) ;}
                }
            }
            system.debug('accIdHierAccMap '+accIdHierAccMap);            
            
            if(accIdHierAccMap.size() > 0){
                PLAccLst = [Select Id, Name,UL_Customer_Role_Valid_From__c,UL_Customer_Hierarchy_Level__c, UL_Customer_Role_Valid_Thru__c From Account Where Id =: accIdHierAccMap.keySet() AND UL_Planning_Level__c = TRUE] ;
            }
            system.debug('PLAccLst '+PLAccLst);
            
            String level = newAccLst[0].UL_Customer_Hierarchy_Level__c;
            if(String.isNotBlank(level)){
                level = level.substringAfter(' ');
                levelNo = Integer.valueOf(level);
                system.debug('---------'+levelNo) ;
                
                if((levelNo <3||7<levelNo ) && newAccLst[0].UL_Planning_Level__c ){
                    newAccLst[0].addError(System.Label.UL_PlanningLevelBetween3To7);
                }
            } 
            
            if(PLAccLst.size() > 0){
                system.debug('---k------');
                for(Account PLAcc : PLAccLst){
                    if(accIdHierAccMap.containsKey(PLAcc.Id)){
                        accIdPLAccIdMap.put(accIdHierAccMap.get(PLAcc.Id), PLAcc.Id ) ;
                    }
                }
            }
            system.debug('accIdPLAccIdMap '+accIdPLAccIdMap) ;
            
            //if(PLAccLst.size() > 0){
            for (Account oldAcc : newAccLst ){      
                String level1 = oldAcc.UL_Customer_Hierarchy_Level__c;  
                Integer levelNumber;
                Boolean currencyMismatch = FALSE ;
                Boolean datesFlg = FALSE ;
                Boolean planLevFlg = FALSE ;
                
                if(String.isNotBlank(level1)){
                    level1 = level1.substringAfter(' ');      
                    levelNumber = Integer.valueOf(level1);
                }                
                
                if(levelNumber <> NULL){
                    currencyMismatch = checkCurrency(oldAcc, levelNumber) ;
                }
                
                if(PLAccLst.size() > 0){
                    datesFlg = validationDates(PLAccLst,oldAcc) ;
                }
                
                if(accIdPLAccIdMap.size() > 0){
                    planLevFlg = accIdPLAccIdMap.containsKey(oldAcc.Id) ;
                }               
                system.debug('flags '+currencyMismatch +datesFlg + planLevFlg);
                
                if(currencyMismatch || (planLevFlg && datesFlg)) {
                    oldAcc.addError(System.Label.UL_PlanningLevelAndCurrency) ;
                }   
            }
        }
        catch(Exception e) {
            System.debug('An exception occurred in Level and currency block : ' + e.getMessage());
        }
    }
    
    /***********************************************
* @Method      : validationDates
* @Description : method to check validations on validity from/to dates, while setting Planning Level for Customer
* @Arguments    : hierarchy account records with PLanning Level = TRUE, trigger context record
* @Return Type  : -NA-
***********************************************/
    public static boolean validationDates(List<Account> PLAccLst, Account oldAcc){
        if((PLAccLst[0].UL_Customer_Role_Valid_Thru__c == oldAcc.UL_Customer_Role_Valid_Thru__c ||
            PLAccLst[0].UL_Customer_Role_Valid_From__c == oldAcc.UL_Customer_Role_Valid_From__c)
           || (oldAcc.UL_Customer_Role_Valid_From__c > PLAccLst[0].UL_Customer_Role_Valid_From__c && 
               oldAcc.UL_Customer_Role_Valid_From__c < PLAccLst[0].UL_Customer_Role_Valid_Thru__c)
           || (oldAcc.UL_Customer_Role_Valid_Thru__c > PLAccLst[0].UL_Customer_Role_Valid_From__c && 
               oldAcc.UL_Customer_Role_Valid_Thru__c < PLAccLst[0].UL_Customer_Role_Valid_Thru__c)
          ){
              return true;
          }
        else{
            return false;
        }
    }    
    /***********************************************
* @Method      : checkCurrency
* @Description : method to check validations on currency, while setting Planning Level for Customer
* @Arguments    : trigger context record, context record hierarchy level
* @Return Type  : -NA-
***********************************************/
    public static boolean checkCurrency(Account oldAcc, Integer levelNumber){
        
        boolean currencyMismatch = FALSE ;
        try{
            String query ='select id,name,UL_Currency__c  from  Account where ' ;      
            query += 'UL_Level_'+ levelNumber +'__c = \'' + oldAcc.id + '\'';   
            
            List<Account>  allLevelRecords = Database.query(query);
            
            for(Account acc : allLevelRecords){                 
                if(acc.UL_Currency__c <> oldAcc.UL_Currency__c) {
                    currencyMismatch = TRUE ;
                }                        
            }
        }
        Catch (Exception e){
            System.debug('An exception occurred Currecny block: ' + e.getMessage());
        }  
        return currencyMismatch ;
    }   
    /***********************************************
* @Method      : getLastLevAcc
* @Description : method to check validations on currency, while setting Planning Level for Customer
* @Arguments    : trigger context record, context record hierarchy level
* @Return Type  : -NA-
***********************************************/
    public static List<Account> getLastLevAcc(Account newAcc, Integer levelNumber){        
        //boolean currencyMismatch = FALSE ;
        String level = 'Level 8';
        List<Account>  lastLevAccLst = new List<Account>();
        
        try{
            String query ='Select Id, Name, UL_Customer_Role_Valid_From__c, UL_Customer_Hierarchy_Level__c, UL_Customer_Role_Valid_Thru__c, UL_Level_1__c, UL_Level_2__c, UL_Level_3__c, UL_Level_4__c, UL_Level_5__c, UL_Level_6__c,  UL_Level_7__c, UL_Level_8__c, UL_Currency__c From  Account Where UL_Customer_Hierarchy_Level__c=\''+level+'\' AND  ';  
            query += 'UL_Level_'+ levelNumber +'__c = \'' + newAcc.id +'\'' + ' Limit 1';  
            system.debug('query '+query);
            
            lastLevAccLst = Database.query(query);  
            system.debug('lastLevAccLst2 '+lastLevAccLst);
        }
        Catch (Exception e){
            System.debug('An exception occurred getLastLevAcc() block: ' + e.getMessage());
        } 
        return lastLevAccLst ;
    }
    /*******************************************************************
Author: Balakrishna Mandula(balakrishna.mandula@accenture.com)
Purpose: before trigger events
Version 1.0
Parameters: List of Accounts
Returns: None
Throws: None
Date: 22/01/2017
********************************************************************/
    public static void beforeInsert(List<Account> accountList){
        try{
            updateExternalId(accountList);        
        }
        catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());   
        }
        
    }
    //after insert trigger events
    public static void afterInsert(Map<Id, Account> oldAccountMap, Map<Id, Account> newAccountMap){
        //System.debug('after insert');
        try{
          
            updateExternalId(newAccountMap.values()); 
            System.debug('after insert'+newAccountMap.values());
        }
        catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());   
        }
        
    }
    /*******************************************************************
Author: Balakrishna Mandula(balakrishna.mandula@accenture.com)
Purpose: Updates EXternal Id field on Account when it's empty
Version 1.0
Parameters: List of Accounts
Returns: None
Throws: None
Date: 22/01/2017
********************************************************************/
    public static void beforeUpdate(Map<Id, Account> oldAccountMap, Map<Id, Account> newAccountMap){
        System.debug('beforeUpdate');
        try{
            updateExternalId(newAccountMap.values());
            
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId()); 
        }        
    }
    
    /*******************************************************************
Author: Balakrishna Mandula(balakrishna.mandula@accenture.com)
Purpose: Updates EXternal Id field on Account when it's empty 
Version 1.0
Parameters: List of Accounts
Returns: None
Throws: None
Date: 22/01/2017
********************************************************************/
    private static void updateExternalId(List<Account> accList){ 
        try{
            for(Account acc : accList){
                if(String.isBlank(acc.ACCL__ExternalId__c)){
                    System.debug('acc.ACCL__ExternalId__c'+acc.ACCL__ExternalId__c);
                    //acc.ACCL__ExternalId__c = acc.AccountNumber + '-' +acc.ACCL__Sales_Org__c+ '-' +acc.UL_Activity_Sector_Division_Code__c+ '-' +acc.UL_Distribution_Channel_Code__c;
                    acc.ACCL__ExternalId__c = acc.AccountNumber + '-' +acc.ACCL__Sales_Org__c + acc.UL_Distribution_Channel_Code__c + acc.Division__c;
                }
            }
        }
        catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId()); 
        }
    }
}