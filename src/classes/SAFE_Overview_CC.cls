/**
* Name:        -   SAFE_Overview_CC
* @Description -   This controller fetches user entered data for Overview tab for all user group from custom setting(SAFE_Overview__c)
				  
* @Author      - Sibatri  
*/
public class SAFE_Overview_CC {
    public ApexPages.StandardController stdController;
  public List<SAFE_Overview__c> overview{get; set;}
 public SAFE_Overview_CC(ApexPages.StandardController controller){
     this.stdController = stdController;
       overview = [select Description__c,Is_Active__c,Question__c,Sequence_No__c from SAFE_Overview__c where Is_Active__c=true order By Sequence_No__c ASC ];
       
    }
    
}