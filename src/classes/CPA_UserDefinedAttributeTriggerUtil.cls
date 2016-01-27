/**********************************************************************  
Name:  CPA_UserDefinedAttributeTriggerUtil ()  Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------   This class is holds the  business logic for CAP [Contracting process Automation] User Defined Attribute duplication record  verification.                                                         
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION  AUTHOR                        DATE              DETAIL                    Description    
 1.0      Shreyas Mangalvedhekar        29/12/2015      INITIAL DEVELOPMENT          CSR: 
 ***********************************************************************/

public class CPA_UserDefinedAttributeTriggerUtil {
    
    
    
  /*******************************************************************    
  Purpose:  This static method will not allow user to creat duplicate record for User definned attribute                                                            
  Parameters: List of User definned attribute     
  Returns:  

  ********************************************************************/ 
  
  public static void findDuplicate(List<CAP_User_Defined_Attribute__c > lstUDA) {
      
      Set<Id> setPworfID = new set <ID>();
      map<string,CAP_User_Defined_Attribute__c> mapUserDefinedAttribute = new  map<string,CAP_User_Defined_Attribute__c>();
      map<string,CAP_User_Defined_Attribute__c> mapNewUserDefinedAttribute = new  map<string,CAP_User_Defined_Attribute__c>();
      
        
      
      
      for(CAP_User_Defined_Attribute__c obj: lstUDA ){
          setPworfID.add(obj.lkp_PWORF__c);     
          mapNewUserDefinedAttribute.put(obj.lkp_PWORF__c+obj.pkl_Attribute_Type__c,obj);
      }
      
      List<CAP_User_Defined_Attribute__c> lst = [Select pkl_Attribute_Type__c,txt_Value__c,lkp_PWORF__c from CAP_User_Defined_Attribute__c where lkp_PWORF__c IN: setPworfID];
      
      for(CAP_User_Defined_Attribute__c obj : lst){       
           mapUserDefinedAttribute.put(obj.lkp_PWORF__c+obj.pkl_Attribute_Type__c,obj);       
      }
      
      for(CAP_User_Defined_Attribute__c  obj: lstUDA){
          if(mapUserDefinedAttribute.get(obj.lkp_PWORF__c+obj.pkl_Attribute_Type__c)!=null)
              obj.addError('you cant create the duplicate record for '+obj.pkl_Attribute_Type__c);      

      }
          
  
  
  }
    
}