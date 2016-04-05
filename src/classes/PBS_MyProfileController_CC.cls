/*
Copyright (c) 2014, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

*/
global with sharing class PBS_MyProfileController_CC extends PBS_LMSBaseController_CC{

    public User oUser{get;set;}
    public transient List<PBS_AchievementCategoryWrapper_CC> lcategories{get;set;}
    public User oManager{get;set;}
    public String achievementType{get;private set;}
    private String profileUserId{get;set;}
    public Integer totalAchievements{get;private set;}

    public List<AchievementTypeWrapper> getAchievementTypes(){
        List<AchievementTypeWrapper> results = new List<AchievementTypeWrapper>();
        Schema.DescribeFieldResult fieldResult = Almond__Achievement__c.Almond__Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            AchievementTypeWrapper act = new AchievementTypeWrapper();
            act.name = f.getValue();
            act.label = f.getLabel();
            results.add(act);
        }
        return results;
    }

    public PBS_MyProfileController_CC(){
        totalAchievements = 0;
        profileUserId = ApexPages.currentPage().getParameters().get('id');
        String chatterPageUserId = ApexPages.currentPage().getParameters().get('sfdc.userId');

        achievementType = 'Achievements';

        String paramAchievementType = ApexPages.currentPage().getParameters().get('aType');

        if(!String.isBlank(paramAchievementType)){
            achievementType = paramAchievementType;
        }

        if(String.isBlank(profileUserId)){
            profileUserId = chatterPageUserId;
        }

        if(String.isBlank(profileUserId)){
            profileUserId = UserInfo.getUserId();
        }

        //No need to enforce CRUD/FLS on User object + standard fields
        oUser = [select Id
                        ,Name
                        ,Title
                        ,ManagerId
                        ,Email
                        ,Department
                        ,AboutMe
                        ,FullPhotoUrl
                        from User
                        where Id =:profileUserId];

        if(oUser.ManagerId !=null){
            List<User> userManagers = [select Id
                                              ,Name
                                              ,SmallPhotoUrl
                                              from User
                                              where Id = :oUser.ManagerId];
            if(userManagers.size()>0){
                oManager = userManagers.get(0);
            }

        }

        lcategories = new List<PBS_AchievementCategoryWrapper_CC>();

        //BEGIN Access Check
        Map<Schema.sObjectType,List<String>> relatedFieldsObjects = new Map<Schema.sObjectType,List<String>>();
        relatedFieldsObjects.put(Almond__Achievement_Assignment__c.sObjectType,new List<String>{
            'Id'
            ,'Name'
            ,'Almond__Status__c'
            ,'Almond__Achievement__c'
            ,'Almond__Training_Plan_Achievement__c'
            ,'Almond__User__c'
        });
        relatedFieldsObjects.put(Almond__Achievement__c.sObjectType,new List<String>{
            'Id'
            ,'Name'
            ,'Almond__Acquired_Image__c'
            ,'Almond__Eligible_Image__c'
            ,'Almond__Work_Badge_Id__c'
            ,'Almond__Work_Badge_Image_URL__c'
            ,'Almond__Override_URL__c'
            ,'Almond__Override_Completed_Status__c'
        });
        relatedFieldsObjects.put(Almond__Training_Plan_Achievement__c.sObjectType,new List<String>{
            'Almond__Type__c'
            ,'Almond__Training_Plan__c'
            ,'Almond__Training_Plan_Section__c'
        });
        LMS_ESAPI.isAuthorizedToView(relatedFieldsObjects);
        //END Access Check

        String achievementCategory = '';

        List<String> listSOQLFields = new List<String>{
            'Id'
            ,'Name'
            ,'Almond__Status__c'
            ,'Almond__Achievement__c'
            ,'Almond__Achievement__r.Name'
            ,'Almond__Achievement__r.Almond__Acquired_Image__c'
            ,'Almond__Achievement__r.Almond__Eligible_Image__c'
            ,'Almond__Achievement__r.Almond__Work_Badge_Id__c'
            ,'Almond__Achievement__r.Almond__Work_Badge_Image_URL__c'
            ,'Almond__Achievement__r.Almond__Override_URL__c'
            ,'Almond__Achievement__r.Almond__Override_Completed_Status__c'
            ,'Almond__Achievement__r.Almond__Expiration_Date__c'
            ,'Almond__Achievement__r.Almond__Achievement_Category__r.Name'
            ,'Almond__Achievement__r.Almond__Type__c'
            ,'Almond__User__c'
        };

        String soqlQuery = 'select '+String.join(listSOQLFields,',')+' from Almond__Achievement_Assignment__c';
        soqlQuery += ' where Almond__User__c = :profileUserId and Almond__Achievement__r.Almond__Type__c = :achievementType and Almond__Achievement__r.Almond__Hidden__c = false';

        if(PBS_LMSUtils_CC.isPortalUser()){
            soqlQuery += ' and Almond__Achievement__r.Almond__Is_Internal__c = false';
        }

        soqlQuery += ' order by Almond__Achievement__r.Almond__Achievement_Category__r.Name desc, Almond__Status__c desc';

        List<PBS_AchievementAssignmentWrapper_CC> achievementRecs = new List<PBS_AchievementAssignmentWrapper_CC>();
        for (Almond__Achievement_Assignment__c a : (List<Almond__Achievement_Assignment__c>)Database.query(soqlQuery)){

            // Skip expired achievements
            if(a.Almond__Achievement__r.Almond__Expiration_Date__c != null && a.Almond__Achievement__r.Almond__Expiration_Date__c <= Date.today()){
                continue;
            }

            String currentCategoryName = a.Almond__Achievement__r.Almond__Achievement_Category__r.Name;
            if(achievementCategory == ''){
                achievementCategory = currentCategoryName;
            }

            if(achievementCategory != currentCategoryName){
                PBS_AchievementCategoryWrapper_CC acw = new PBS_AchievementCategoryWrapper_CC();
                acw.Name = achievementCategory;
                acw.achievements = achievementRecs;
                lcategories.add(acw);

                //Reset comparison params
                achievementRecs = new List<PBS_AchievementAssignmentWrapper_CC>();
                achievementCategory = currentCategoryName;
            }

            if(a.Almond__Status__c == PBS_LMSConstants_CC.AA_ACQUIRED_STATUS){
                totalAchievements++;
            }
            achievementRecs.add(new PBS_AchievementAssignmentWrapper_CC(a));
        }

        if(achievementRecs.size()>0){
            PBS_AchievementCategoryWrapper_CC acw = new PBS_AchievementCategoryWrapper_CC();
            acw.Name = achievementCategory;
            acw.achievements = achievementRecs;
            lcategories.add(acw);
      }
    }

    public PageReference changeAchievementType(){
        String paramAchievementType = ApexPages.currentPage().getParameters().get('type');
        String isSubTab = ApexPages.currentPage().getParameters().get('subtab');

        PageReference ref = Page.MyProfile;

        if(!String.isBlank(isSubTab)){
          ref = Page.AchievementsSubTab;
        }

        ref.getParameters().put('aType',paramAchievementType);
        ref.getParameters().put('id',profileUserId);
        ref.setRedirect(true);
        return ref;
    }

    public with sharing class AchievementTypeWrapper{
        public String name{get;set;}
        public String label{get;set;}
    }


    public List<String> getGeographyOptions()
    {
        return PBS_ProfileService.getPicklistOptions('PBS_Profile__c', 'Geography__c', false);
    }

    public List<String> getWorkLevelOptions()
    {
        return PBS_ProfileService.getPicklistOptions('PBS_Profile__c', 'Work_Level__c', false);
    }

    public List<PBS_Standard_Job_Profile__c> getJobProfileOptions()
    {
        return [
            SELECT
                Id, Name
            FROM
                PBS_Standard_Job_Profile__c
            ORDER BY
                Name
        ];
    }

    public PBS_Profile__c getProfile()
    {
        return PBS_ProfileService.getCurrentUserProfile();
    }

    @RemoteAction
    global static boolean storeUserProfile(String geography, String WorkLevel, Id UserRoleId, String Buddy)
    {
        PBS_Profile__c profile = PBS_ProfileService.getCurrentUserProfile();
        profile.Geography__c   = geography;
        profile.Work_Level__c  = WorkLevel;
        profile.User_Role__c   = UserRoleId;
        profile.Buddy__c       = Buddy;

        upsert profile;
        return true;
    }

}