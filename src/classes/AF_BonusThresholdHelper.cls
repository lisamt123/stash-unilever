public class AF_BonusThresholdHelper{
    public static void shareRecordToUser(List<AF_Bonus_Threshold__c> bonusThresholdObjList){
        List<String> agencyNameList = new List<String>();
        Map<string,string> userTypeMap = new Map<string,string>();
        map<string, list<String>> catUserListMap = new map<string, list<String>>();
        map<string, list<AF_Bonus_Threshold__c>> catBonusThresholdListMap = new map<string, list<AF_Bonus_Threshold__c>>();
        
        for(AF_Bonus_Threshold__c bonusThresholdObj : bonusThresholdObjList){
            if(!catBonusThresholdListMap.containsKey(bonusThresholdObj.AF_Category__c)){
                list<AF_Bonus_Threshold__c> newBonusThresholdObjList = new list<AF_Bonus_Threshold__c>();
                newBonusThresholdObjList.add(bonusThresholdObj);
                catBonusThresholdListMap.put(bonusThresholdObj.AF_Category__c,newBonusThresholdObjList);
            }else{
                list<AF_Bonus_Threshold__c> oldbonusThresholdObjList = new list<AF_Bonus_Threshold__c>();
                oldbonusThresholdObjList=catBonusThresholdListMap.get(bonusThresholdObj.AF_Category__c);
                oldbonusThresholdObjList.add(bonusThresholdObj); //new value to existing
                catBonusThresholdListMap.put(bonusThresholdObj.AF_Category__c,oldbonusThresholdObjList);
            }
        }
        system.debug('catBonusThresholdListMap...'+catBonusThresholdListMap);
        for(AF_Bonus_Threshold__c bonusThresholdQueryObj:[select Agency_Name__r.Name from AF_Bonus_Threshold__c where Id IN:bonusThresholdObjList]){
            agencyNameList.add(bonusThresholdQueryObj.Agency_Name__r.Name);
           }
    //get all users and their type
        list<Users_Category__c> userObjList = new list<Users_Category__c>();
        userObjList = AF_BrandEstimateHelper.userList(catBonusThresholdListMap.keySet(),agencyNameList);
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
        //retrieve Brand Estimate and create share records
        list<AF_Bonus_Threshold__Share> bonusThresholdShareObjList = new list<AF_Bonus_Threshold__Share>();
        for(String str :catBonusThresholdListMap.keySet()){
            if(catUserListMap.containsKey(str)){
                for(String userId :catUserListMap.get(str)){
                    for(AF_Bonus_Threshold__c bonusThresholdObj :catBonusThresholdListMap.get(str)){
                        if(bonusThresholdObj.OwnerId!=string.valueOf(userId).substring(0,15)){
                            AF_Bonus_Threshold__Share bonusThresholdShareObj = new AF_Bonus_Threshold__Share();
                            bonusThresholdShareObj.UserOrGroupId=userId;
                            bonusThresholdShareObj.ParentId=bonusThresholdObj.Id;
                            String userType =userTypeMap.get(userId);
                            if(userType =='CMCO User' || userType=='Category Finance'|| userType=='Agency'|| userType=='Controller'){
                                bonusThresholdShareObj.AccessLevel ='Edit';
                                bonusThresholdShareObjList.add(bonusThresholdShareObj);
                            }else{
                                bonusThresholdShareObj.AccessLevel ='Read';
                                bonusThresholdShareObjList.add(bonusThresholdShareObj);
                            }
                           system.debug('bonusThresholdShareObjList...'+bonusThresholdShareObjList);
                        }
                    }
                }
            }
        }
        if(!bonusThresholdShareObjList.isEmpty()){
            system.debug('++++++++++++share+++'+bonusThresholdShareObjList);
            insert bonusThresholdShareObjList;
        }
    }
}