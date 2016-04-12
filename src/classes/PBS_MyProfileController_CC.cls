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
    public User oManager{get;set;}
    private String profileUserId{get;set;}
 
    public PBS_MyProfileController_CC(){
        
        profileUserId = ApexPages.currentPage().getParameters().get('id');
        String chatterPageUserId = ApexPages.currentPage().getParameters().get('sfdc.userId');

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
                PBS_Standard_Job_Profile__c where Name != Null
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