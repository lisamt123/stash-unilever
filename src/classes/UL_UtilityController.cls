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
             userLst  = [Select Id, Name,ACCL__Sales_Org__c from User where Id =: UserInfo.getUserID() limit 1];
             salesOrg = userLst[0].ACCL__Sales_Org__c;         
         }
         catch(Exception ex){
           UL_Utility.logError(ex, UserInfo.getUserId());
         }
        return salesOrg;
    }
    
    /**
    @Author - vinod.thupakula@accenture.com
    @method name - usersSalesOrg
    @CreateDate - 08-12-2016
    @Description - this method get the error messages.
    @Param - 
    @Version - 1.0
    @reference - NR
    */
    public static String errorMessage(String exceptionMessage){
    try{
        if(exceptionMessage != null){
            exceptionMessage = exceptionMessage.subStringAfterLast(UL_Utility.FIELD_SPLITTER );
            exceptionMessage = exceptionMessage.subStringBeforeLast(UL_Utility.Qulon);
        }
    }
    catch(Exception ex){
             UL_Utility.logError(ex, UserInfo.getUserId());
         }
    return exceptionMessage;
    }
    
    
}