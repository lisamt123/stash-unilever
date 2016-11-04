/**
@Author - vinod.thupakula@accenture.com
@name - UL_UtilityController
@CreateDate - 03-10-2016
@Description - this class is helper for all the classes.
@Version - 1.0
@reference - N/A
*/
public with sharing class UL_UtilityController{
    /**
    @Author - vinod.thupakula@accenture.com
    @method name - usersSalesOrg
    @CreateDate - 03-10-2016
    @Description - this method get the sales org of login user.
    @Param - 
    @Version - 1.0
    @reference - NR
    */
    public static String usersSalesOrg(){
    	String salesOrg = null;
        try{         
	         List<User> userLst = new List<User>() ;
	         userLst  = [Select Id, Name,ACSFUL001__Sales_Organization__c from User where Id =: UserInfo.getUserID() limit 1];
	         salesOrg = userLst[0].ACSFUL001__Sales_Organization__c;         
         }
         catch(Exception ex){
         	 salesOrg = null;
         }
        return salesOrg;
    }
    
    
}