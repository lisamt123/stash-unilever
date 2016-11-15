public class AF_BrandEstimateHelper{
    
    public static void shareRecordToUser(list<AF_Brand_Estimate__c> brandEstObjList){
        List<String> agencyNameList = new List<String>();
        //map to store users and their type
        Map<string,string> userTypeMap = new Map<string,string>();
        //map to store group of users that belongs to same category
        map<string, list<String>> catUserListMap = new map<string, list<String>>();
        //map to store group of Brand Estimate that belongs to same category
        map<string, list<AF_Brand_Estimate__c>> catBrandListMap = new map<string, list<AF_Brand_Estimate__c>>();
        
        for(AF_Brand_Estimate__c brandEstObj : brandEstObjList){
            if(!catBrandListMap.containsKey(brandEstObj.AF_Category__c)){
                list<AF_Brand_Estimate__c> newBrandObjList = new list<AF_Brand_Estimate__c>();
                newBrandObjList.add(brandEstObj);
                catBrandListMap.put(brandEstObj.AF_Category__c,newBrandObjList);
            }else{
                list<AF_Brand_Estimate__c> oldBrandObjList = new list<AF_Brand_Estimate__c>();
                oldBrandObjList=catBrandListMap.get(brandEstObj.AF_Category__c);
                oldBrandObjList.add(brandEstObj); //new value to existing
                catBrandListMap.put(brandEstObj.AF_Category__c,oldBrandObjList);
            }
        }
        for(AF_Brand_Estimate__c brandEstQueryObj:[select AF_Agency__r.Name from AF_Brand_Estimate__c where Id IN:brandEstObjList]){
            agencyNameList.add(brandEstQueryObj.AF_Agency__r.Name);
           // system.debug('agencyName...'+agencyName);
        }
        //get all users and their type
        list<Users_Category__c> userObjList = new list<Users_Category__c>();
        userObjList = userList(catBrandListMap.keySet(),agencyNameList);
        
        for(Users_Category__c userCatObj: userObjList){
            string catId = string.valueOf(userCatObj.Category__c).substring(0,15);
            if(!userTypeMap.containsKey(userCatObj.User__c)){
                userTypeMap.put(userCatObj.User__c,userCatObj.User__r.AF_UserTypeText__c);
            }
            
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
        
        //retrieve Brand Estimate and create share records
        list<AF_Brand_Estimate__Share> brandShareObjList = new list<AF_Brand_Estimate__Share>();
        for(String str :catBrandListMap.keySet()){
            if(catUserListMap.containsKey(str)){
                for(String userId :catUserListMap.get(str)){
                    for(AF_Brand_Estimate__c brandEstObj :catBrandListMap.get(str)){
                        if(brandEstObj.OwnerId!=string.valueOf(userId).substring(0,15)){
                            AF_Brand_Estimate__Share brandShareObj = new AF_Brand_Estimate__Share();
                            brandShareObj.UserOrGroupId=userId;
                            brandShareObj.ParentId=brandEstObj.Id;
                            String userType =userTypeMap.get(userId);
                            if(userType =='CMCO User' || userType=='Category Finance'|| userType=='Agency' || userType=='Controller'){
                                brandShareObj.AccessLevel ='Edit';
                                brandShareObjList.add(brandShareObj);
                            }else{
                                brandShareObj.AccessLevel ='Read';
                                brandShareObjList.add(brandShareObj);
                            }
                        }
                    }
                }
            }
        }
        
        //If list is not empty create new records
        if(!brandShareObjList.isEmpty()){
            system.debug('++++++++++++share+++'+brandShareObjList);
            insert brandShareObjList;
        }
    }
    
    
    
    //Get All Users Category records
    public static list<Users_Category__c> userList(set<string> catIdSet,List<String> agencyNameList){
        list<Users_Category__c> userObjList = new list<Users_Category__c>();
        list<Users_Category__c> agencyUserObjList = new list<Users_Category__c>();
        system.debug('agencyNameList...'+agencyNameList);
        
        userObjList = [select id,Category__c,User__c, User__r.AF_UserTypeText__c from Users_Category__c where  Category__c IN:catIdSet AND User__r.IsActive=True and User__r.Profile.Name!='System Administrator' AND User__r.AF_UserTypeText__c!=null AND User__r.AF_UserTypeText__c!='' AND User__r.AF_UserTypeText__c NOT IN ('Agency','CMCO Super User')];
        
        if(agencyNameList.size()>0){
        system.debug('inside agency share');
        agencyUserObjList= [select id,Category__c,User__c, User__r.AF_UserTypeText__c,Agency_Account__c from Users_Category__c where  User__r.IsActive=True and Category__c IN:catIdSet AND Agency_Account__c IN:agencyNameList AND User__r.Profile.Name!='System Administrator' AND User__r.AF_UserTypeText__c!=null AND User__r.AF_UserTypeText__c!='' AND User__r.AF_UserTypeText__c NOT IN ('CMCO Super User')];
        }
        system.debug('userObjList...'+userObjList);
        if(agencyUserObjList.size()>0){
            for(Users_Category__c agencyUser:agencyUserObjList){
                userObjList.add(agencyUser);
            }
        }
        return userObjList;
    }
}