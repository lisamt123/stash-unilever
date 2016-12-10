/***************************************************************
    Name: UL_CustomerUtility
    Copyright © 2016 Accenture Pvt. Ltd.
    ======================================================
    Purpose:
    Utility class to manage customer related generic logic.
    ======================================================
    History
    -------
    VERSION     AUTHOR         DATE         DETAIL             Description
    1.0         Ketan Mehta    30/11/2016   INITIAL DEV        Generic methods getCustomerTradeOrgHierarchy & getCustomerHierarchyAllCustomers added. 
    ***************************************************************/
    public class UL_CustomerUtility{

    /*******************************************************************
    Purpose: Method to get sales org customer hierarchy from the level provided as parameter 
    Version: 1.0
    Parameters: Id parentCustomertId, String customerOrgLevel, Date startDate, Date endDate, Boolean getAllChildLevel
    Returns: List of Account
    Throws: System Exception
    ********************************************************************/
    public static List<Account> getCustomerTradeOrgHierarchy(Id parentCustomertId, String customerOrgLevel, DateTime startDate, DateTime endDate, Boolean getAllChildLevel){
       List<Account> childCustomerHierarchy = null;
       
       //Check if in case date provided, Start and End date both are parameterised.
       if(startDate != UL_Utility.NULL_DATE || endDate != UL_Utility.NULL_DATE){
           if(startDate == UL_Utility.NULL_DATE && endDate == UL_Utility.NULL_DATE){
               return childCustomerHierarchy;
           }
       }
       
       if(parentCustomertId != UL_Utility.NULL_ID){
           
          Set<Id> parentAccIdSet = new Set<Id>();
          Set<Id> allChildLevelCustomerSet = new Set<Id>();
          
          parentAccIdSet.add(parentCustomertId);
          Boolean hasChildRecord=UL_Utility.BOOLEAN_TRUE;
          
          //Read Customer Trade Org Hierarchies
          String tradeOrgQuery = 'SELECT ACSFUL001__Parent_Account__c, ACSFUL001__Child_Account__c FROM ACSFUL001__Account_Trade_Org_Hierarchy__c';
          
          if(startDate != UL_Utility.NULL_DATE){
               tradeOrgQuery+= ' WHERE ACSFUL001__Valid_From__c <= ' + startDate.format(UL_Utility.DATE_FORMAT_YYYY_MM_DD) + ' AND ACSFUL001__Valid_Thru__c >=' + endDate.format(UL_Utility.DATE_FORMAT_YYYY_MM_DD);
          }
          
          try{
              List<ACSFUL001__Account_Trade_Org_Hierarchy__c> tradeOrgHierarchyList = Database.query(tradeOrgQuery);
              
              Set<Id> inlineCustomerSet = new Set<Id>();
              
              for(ACSFUL001__Account_Trade_Org_Hierarchy__c parentChildAcc: tradeOrgHierarchyList){
                inlineCustomerSet.add(parentChildAcc.ACSFUL001__Parent_Account__c);
                inlineCustomerSet.add(parentChildAcc.ACSFUL001__Child_Account__c);
              }
          
              //Read Customer records
              Map<Id,Account> customerMap = new Map<Id,Account>([SELECT Name, UL_Customer_Hierarchy_Level__c FROM Account WHERE id IN:inlineCustomerSet]);
              
              Set<Id> inlineChildCustomerSet = new Set<Id>();
              inlineCustomerSet.clear();
              
              while(hasChildRecord){
                 for(Id parentAccId: parentAccIdSet){
                    for(ACSFUL001__Account_Trade_Org_Hierarchy__c child: tradeOrgHierarchyList){ 
                        if(child.ACSFUL001__Parent_Account__c.equals(parentAccId)){
                            if(customerMap.get(child.ACSFUL001__Child_Account__c).UL_Customer_Hierarchy_Level__c != customerOrgLevel){
                               inlineChildCustomerSet.add(child.ACSFUL001__Child_Account__c);
                            }else{
                               inlineCustomerSet.add(child.ACSFUL001__Child_Account__c);
                            }    
                         }
                     }
                  }
                  if(!inlineChildCustomerSet.isEmpty()){
                    parentAccIdSet.clear();
                    parentAccIdSet.addAll(inlineChildCustomerSet);
                    allChildLevelCustomerSet.addAll(inlineChildCustomerSet);
                    inlineChildCustomerSet.clear();
                  } else{
                    hasChildRecord = UL_Utility.BOOLEAN_FALSE;
                  }
              }
          
              if(getAllChildLevel){
                 inlineChildCustomerSet.clear();
                 inlineChildCustomerSet.addAll(allChildLevelCustomerSet);
              }
          
              //Prepare final result
              if(!inlineCustomerSet.isEmpty()){
                childCustomerHierarchy = new List<Account>();
                for(Id orgCustomerId: inlineCustomerSet){
                     childCustomerHierarchy.add(customerMap.get(orgCustomerId));
                }          
              }
        }catch(Exception ex){
             ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'UL_Utility', 'getCustomerTradeOrgHierarchy', 'An Error occured while fetching customer org hierarchy', Ex, NULL, NULL, NULL, NULL, UL_Utility.APPLICATION_NAME);
          }
       }
   
    return childCustomerHierarchy;
   }
   
   
   /*******************************************************************
    Purpose: Method to get sales org customer top and lower level customer hierarchy from the level provided as parameter 
    Version: 1.0
    Parameters: Id parentCustomertId, String customerOrgLevel, Date startDate, Date endDate, Boolean getAllChildLevel
    Returns: List of Account
    Throws: System Exception
    ********************************************************************/
   public static List<Account> getCustomerHierarchyAllCustomers(Id parentCustomertId, String customerOrgLevel, DateTime startDate, DateTime endDate, Boolean getAllChildLevel){
       List<Account> childCustomerHierarchy = null;
       
       //Check if in case date provided, Start and End date both are parameterised.
       if(startDate != UL_Utility.NULL_DATE || endDate != UL_Utility.NULL_DATE){
           if(startDate == UL_Utility.NULL_DATE && endDate == UL_Utility.NULL_DATE){
             return childCustomerHierarchy;
           }
       }
       
       if(parentCustomertId != UL_Utility.NULL_ID){           
          Set<Id> parentAccIdSet = new Set<Id>();
          Set<Id> childAccIdSet = new Set<Id>();
          Set<Id> allChildLevelCustomerSet = new Set<Id>();
          Set<Id> allParentLevelCustomerSet = new Set<Id>();
          
          parentAccIdSet.add(parentCustomertId);
          childAccIdSet.add(parentCustomertId);
          Boolean hasChildRecord=UL_Utility.BOOLEAN_TRUE;
          Boolean hasParentRecord=UL_Utility.BOOLEAN_TRUE;
          
          //Read Customer Trade Org Hierarchies
          String tradeOrgQuery = 'SELECT ACSFUL001__Parent_Account__c, ACSFUL001__Child_Account__c FROM ACSFUL001__Account_Trade_Org_Hierarchy__c';
          
          if(startDate != UL_Utility.NULL_DATE){
               tradeOrgQuery+= ' WHERE ACSFUL001__Valid_From__c <= ' + startDate.format(UL_Utility.DATE_FORMAT_YYYY_MM_DD) + ' AND ACSFUL001__Valid_Thru__c >=' + endDate.format(UL_Utility.DATE_FORMAT_YYYY_MM_DD);
          }
          
          try{
          List<ACSFUL001__Account_Trade_Org_Hierarchy__c> tradeOrgHierarchyList = Database.query(tradeOrgQuery);
          
          Set<Id> inlineCustomerSet = new Set<Id>();
          
          for(ACSFUL001__Account_Trade_Org_Hierarchy__c parentChildAcc: tradeOrgHierarchyList){
            inlineCustomerSet.add(parentChildAcc.ACSFUL001__Parent_Account__c);
            inlineCustomerSet.add(parentChildAcc.ACSFUL001__Child_Account__c);
          }
          
          //Read Customer records
          Map<Id,Account> customerMap = new Map<Id,Account>([SELECT Name, UL_Customer_Hierarchy_Level__c FROM Account WHERE id IN:inlineCustomerSet]);
          
          Set<Id> inlineChildCustomerSet = new Set<Id>();
          Set<Id> inlineParentCustomerSet = new Set<Id>();
          inlineCustomerSet.clear();
          
          while(hasChildRecord){
             for(Id parentAccId: parentAccIdSet){
                for(ACSFUL001__Account_Trade_Org_Hierarchy__c child: tradeOrgHierarchyList){ 
                    if(child.ACSFUL001__Parent_Account__c.equals(parentAccId)){
                           inlineChildCustomerSet.add(child.ACSFUL001__Child_Account__c); 
                     }
                 }
              }
              if(!inlineChildCustomerSet.isEmpty()){
                parentAccIdSet.clear();
                parentAccIdSet.addAll(inlineChildCustomerSet);
                allChildLevelCustomerSet.addAll(inlineChildCustomerSet);
                inlineChildCustomerSet.clear();
              } else{
                hasChildRecord = UL_Utility.BOOLEAN_FALSE;
              }
          }
            system.debug('inlineChildCustomerSet '+inlineChildCustomerSet);
            
            
            while(hasParentRecord){
             for(Id childAccId: childAccIdSet){
                for(ACSFUL001__Account_Trade_Org_Hierarchy__c child: tradeOrgHierarchyList){
                    if(child.ACSFUL001__Child_Account__c.equals(childAccId)){
                           inlineParentCustomerSet.add(child.ACSFUL001__Parent_Account__c);                            
                    }
                 }
              }
              if(!inlineParentCustomerSet.isEmpty()){
                childAccIdSet.clear();
                childAccIdSet.addAll(inlineParentCustomerSet);
                allParentLevelCustomerSet.addAll(inlineParentCustomerSet);
                inlineParentCustomerSet.clear();
              } else{
                hasParentRecord = UL_Utility.BOOLEAN_FALSE;
              }
          }
            system.debug('inlineParentCustomerSet '+inlineParentCustomerSet);
            
            
          if(getAllChildLevel){
             inlineChildCustomerSet.clear();
             inlineChildCustomerSet.addAll(allChildLevelCustomerSet);
             inlineChildCustomerSet.addAll(allParentLevelCustomerSet);
          }
          
          //Prepare final result
          if(!inlineCustomerSet.isEmpty()){
            childCustomerHierarchy = new List<Account>();
            for(Id orgCustomerId: inlineCustomerSet){
                 childCustomerHierarchy.add(customerMap.get(orgCustomerId));
            }          
          }
            
            system.debug('inlineChildCustomerSet '+inlineChildCustomerSet);
            childCustomerHierarchy = [SELECT Id, Name From Account WHERE Id =: inlineChildCustomerSet] ;
            system.debug('childCustomerHierarchy '+childCustomerHierarchy);
            
        }catch(Exception ex){
             ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'UL_Utility', 'getCustomerTradeOrgHierarchy', 'An Error occured while fetching customer org hierarchy', Ex, NULL, NULL, NULL, NULL, UL_Utility.APPLICATION_NAME);
          }
       }
   
    return childCustomerHierarchy;
   } 

}