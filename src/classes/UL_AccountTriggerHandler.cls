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
            List<Account> PLAccLst = new List<Account>() ; 
            Map<Id, Id> accIdHierAccMap = new  Map<Id, Id>() ;
            Map<Id, Id> accIdPLAccIdMap= new  Map<Id, Id>() ;
            
            try{
                for(Account account : newAccLst){
                    if(account.UL_Customer_Role_Valid_From__c == NULL || account.UL_Customer_Role_Valid_Thru__c == NULL){
                        account.addError(System.Label.UL_PlanningStartEndDate) ;
                    }
                }
            }        
            catch(Exception ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
            }
            
            try{
                String level1 = UL_Utility.STRING_NULL;  
                Integer levelNumber;
                List<Account>  lastLevAccLst = null;  
                                  
                for(Account newAcc : newAccLst){
                    level1 = newAcc.UL_Customer_Hierarchy_Level__c;  
                    if(String.isNotBlank(level1)){
                        level1 = level1.substringAfter(UL_Utility.SPACE);      
                        levelNumber = Integer.valueOf(level1);
                    }
                    
                    lastLevAccLst = getLastLevAcc(newAcc, levelNumber) ;
                    
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
                
                if(accIdHierAccMap.size() > 0){
                    PLAccLst = [Select Id, Name,UL_Customer_Role_Valid_From__c,UL_Customer_Hierarchy_Level__c, UL_Customer_Role_Valid_Thru__c From Account Where Id =: accIdHierAccMap.keySet() AND UL_Planning_Level__c = TRUE] ;
                }
                
                String level = newAccLst[0].UL_Customer_Hierarchy_Level__c;
                if(String.isNotBlank(level)){
                    level = level.substringAfter(UL_Utility.SPACE);
                    levelNo = Integer.valueOf(level);
                    
                    if((levelNo <3||7<levelNo ) && newAccLst[0].UL_Planning_Level__c ){
                        newAccLst[0].addError(System.Label.UL_PlanningLevelBetween3To7);
                    }
                } 
                
                if(PLAccLst.size() > 0){
                    for(Account PLAcc : PLAccLst){
                        if(accIdHierAccMap.containsKey(PLAcc.Id)){
                            accIdPLAccIdMap.put(accIdHierAccMap.get(PLAcc.Id), PLAcc.Id ) ;
                        }
                    }
                }
                
                levelNumber = null;
                for (Account oldAcc : newAccLst ){      
                    level1 = oldAcc.UL_Customer_Hierarchy_Level__c;  
                    Boolean currencyMismatch = FALSE ;
                    Boolean datesFlg = FALSE ;
                    Boolean planLevFlg = FALSE ;
                    
                    if(String.isNotBlank(level1)){
                        level1 = level1.substringAfter(UL_Utility.SPACE);      
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
                    
                    if(currencyMismatch || (planLevFlg && datesFlg)) {
                        oldAcc.addError(System.Label.UL_PlanningLevelAndCurrency) ;
                    }   
                }
            }
            catch(Exception ex) {
                UL_Utility.logError(ex, UserInfo.getUserId());
            }
        }
        
        /***********************************************
        * @Method      : validationDates
        * @Description : method to check validations on validity from/to dates, while setting Planning Level for Customer
        * @Arguments    : hierarchy account records with PLanning Level = TRUE, trigger context record
        * @Return Type  : -NA-
        ***********************************************/
        public static boolean validationDates(List<Account> PLAccLst, Account oldAcc){
            Boolean isValidDate = UL_Utility.BOOLEAN_FALSE;
            try{
                if((PLAccLst[0].UL_Customer_Role_Valid_Thru__c == oldAcc.UL_Customer_Role_Valid_Thru__c ||
                    PLAccLst[0].UL_Customer_Role_Valid_From__c == oldAcc.UL_Customer_Role_Valid_From__c)
                   || (oldAcc.UL_Customer_Role_Valid_From__c > PLAccLst[0].UL_Customer_Role_Valid_From__c && 
                       oldAcc.UL_Customer_Role_Valid_From__c < PLAccLst[0].UL_Customer_Role_Valid_Thru__c)
                   || (oldAcc.UL_Customer_Role_Valid_Thru__c > PLAccLst[0].UL_Customer_Role_Valid_From__c && 
                       oldAcc.UL_Customer_Role_Valid_Thru__c < PLAccLst[0].UL_Customer_Role_Valid_Thru__c)){
                  
                      isValidDate = UL_Utility.BOOLEAN_TRUE;
                  }
            }
            catch (Exception ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
            } 
            return isValidDate;
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
                String query ='SELECT id,name,UL_Currency__c  FROM  Account WHERE ' ;      
                query += 'UL_Level_'+ levelNumber +'__c = \'' + oldAcc.id + '\'';   
                
                List<Account>  allLevelRecords = Database.query(query);
                
                for(Account acc : allLevelRecords){                 
                    if(acc.UL_Currency__c <> oldAcc.UL_Currency__c) {
                        currencyMismatch = true;
                    }                        
                }
            }
            catch (Exception ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
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
            List<Account>  lastLevAccLst = new List<Account>();
            
            try{
                String query ='Select Id, Name, UL_Customer_Role_Valid_From__c, UL_Customer_Hierarchy_Level__c, UL_Customer_Role_Valid_Thru__c, UL_Level_1__c, UL_Level_2__c, UL_Level_3__c, UL_Level_4__c, UL_Level_5__c, UL_Level_6__c,  UL_Level_7__c, UL_Level_8__c, UL_Currency__c From  Account Where UL_Customer_Hierarchy_Level__c=\''+UL_Utility.LEVEL8+'\' AND  ';  
                query += 'UL_Level_'+ levelNumber +'__c = \'' + newAcc.id +'\'' + ' Limit 1';  
                
                lastLevAccLst = Database.query(query);  
            }
            catch (Exception ex){
               UL_Utility.logError(ex, UserInfo.getUserId());
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
        
        /*******************************************************************
        Author: Balakrishna Mandula(balakrishna.mandula@accenture.com)
        Purpose: Updates EXternal Id field on Account when it's empty
        Version 1.0
        Parameters: List of Accounts
        Returns: None
        Throws: None
        Date: 22/01/2017
        ********************************************************************/
        public static void afterInsert(Map<Id, Account> oldAccountMap, Map<Id, Account> newAccountMap){
            try{
                updateExternalId(newAccountMap.values()); 
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
                    String accNum = (String.isBlank(acc.AccountNumber)? UL_Utility.EMPTY_STRING : acc.AccountNumber);
                    String accSalesOrg = (String.isBlank(acc.ACCL__Sales_Org__c)? UL_Utility.EMPTY_STRING : acc.ACCL__Sales_Org__c);
                    String accDistChannel = (String.isBlank(acc.UL_Distribution_Channel_Code__c)? UL_Utility.EMPTY_STRING : acc.UL_Distribution_Channel_Code__c);
                    String accDivision = (String.isBlank(acc.Division__c)? UL_Utility.EMPTY_STRING : acc.Division__c); 
                    if(String.isBlank(acc.ACCL__ExternalId__c)){
                        acc.ACCL__ExternalId__c = accNum  + UL_Utility.HYPHEN +accSalesOrg;
                    }
                }
            }
            catch(Exception ex){
                UL_Utility.logError(ex, UserInfo.getUserId()); 
            }
        }
    }