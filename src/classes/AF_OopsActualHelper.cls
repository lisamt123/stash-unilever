public class AF_OopsActualHelper{
    
     public static void shareRecordToUser(List<AF_OOPS_Actual__c> oopsActualObjList){
        List<String> agencyNameList = new List<String>();
        Map<string,string> userTypeMap = new Map<string,string>();
        map<string, list<String>> catUserListMap = new map<string, list<String>>();
        map<string, list<AF_OOPS_Actual__c>> catOopsActualListMap = new map<string, list<AF_OOPS_Actual__c>>();
        
        for(AF_OOPS_Actual__c oopsActualObj : oopsActualObjList){
            if(!catOopsActualListMap.containsKey(oopsActualObj.AF_Category__c)){
                list<AF_OOPS_Actual__c> newOopsActualObjList = new list<AF_OOPS_Actual__c>();
                newOopsActualObjList.add(oopsActualObj);
                catOopsActualListMap.put(oopsActualObj.AF_Category__c,newOopsActualObjList);
            }else{
                list<AF_OOPS_Actual__c> oldoopsActualObjList = new list<AF_OOPS_Actual__c>();
                oldoopsActualObjList=catOopsActualListMap.get(oopsActualObj.AF_Category__c);
                oldoopsActualObjList.add(oopsActualObj); //new value to existing
                catOopsActualListMap.put(oopsActualObj.AF_Category__c,oldoopsActualObjList);
            }
        }
        system.debug('catOopsActualListMap...'+catOopsActualListMap);
        for(AF_OOPS_Actual__c oopsActualQueryObj:[select AF_Agency_lk__r.Name from AF_OOPS_Actual__c where Id IN:oopsActualObjList]){
            agencyNameList.add(oopsActualQueryObj.AF_Agency_lk__r.Name);
           }
        //get all users and their type
        list<Users_Category__c> userObjList = new list<Users_Category__c>();
        userObjList = AF_BrandEstimateHelper.userList(catOopsActualListMap.keySet(),agencyNameList);
        system.debug('userObjList...'+userObjList);
        for(Users_Category__c userCatObj: userObjList){
            string catId = string.valueOf(userCatObj.Category__c).substring(0,15);
            if(!userTypeMap.containsKey(userCatObj.User__c)){
                userTypeMap.put(userCatObj.User__c,userCatObj.User__r.AF_UserTypeText__c);
            }
            system.debug('userTypeMap...'+userTypeMap);
            if(!catUserListMap.containsKey(catId)){
                list<String> newUserObjList = new list<String>();
                newUserObjList.add(userCatObj.User__c);
                catUserListMap.put(catId,newUserObjList);
            }else{
                list<String> oldUserObjList = new list<String>();
                oldUserObjList=catUserListMap.get(catId);
                oldUserObjList.add(userCatObj.User__c); //new value to existing
                catUserListMap.put(catId,oldUserObjList);
            }
        }
        system.debug('catUserListMap...'+catUserListMap);
        
        //retrieve OopsActual and create share records
        list<AF_OOPS_Actual__Share> oopsActualShareObjList = new list<AF_OOPS_Actual__Share>();
        for(String str :catOopsActualListMap.keySet()){
            if(catUserListMap.containsKey(str)){
                for(String userId :catUserListMap.get(str)){
                    for(AF_OOPS_Actual__c oopsActualObj :catOopsActualListMap.get(str)){
                        if(oopsActualObj.OwnerId!=string.valueOf(userId).substring(0,15)){
                            AF_OOPS_Actual__Share oopsActualShareObj = new AF_OOPS_Actual__Share();
                            oopsActualShareObj.UserOrGroupId=userId;
                            oopsActualShareObj.ParentId=oopsActualObj.Id;
                            String userType =userTypeMap.get(userId);
                            if(userType =='CMCO User' || userType=='Category Finance'|| userType=='Agency'|| userType=='Controller'){
                                oopsActualShareObj.AccessLevel ='Edit';
                                oopsActualShareObjList.add(oopsActualShareObj);
                            }else{
                                oopsActualShareObj.AccessLevel ='Read';
                                oopsActualShareObjList.add(oopsActualShareObj);
                            }
                           system.debug('oopsActualShareObjList...'+oopsActualShareObjList);
                        }
                    }
                }
            }
        }
        if(!oopsActualShareObjList.isEmpty()){
            system.debug('++++++++++++share+++'+oopsActualShareObjList);
            insert oopsActualShareObjList;
        }
    }
}