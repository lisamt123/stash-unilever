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
@isTest
public class PBS_TrainingTracks_Test {
    
    static testMethod void testTrackAchievements(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'PBS_LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'PBS_LMS_User');
        }

        PBS_TrainingTrackData_Test.createSampleData();

        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(3,tplan.size());

        Id tplanId1 = tplan.get(0).Id;
        Id tplanId2 = tplan.get(1).Id;
        Id tplanId3 = tplan.get(2).Id;

        Set<Id> selectedUserIds = new Set<Id>{lmsUsers.get(0).Id};

        System.runAs(adminUsers.get(0)){
            //Upsert assignemtns for tplan 1
            PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId1,null);
            PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId2,null);
            PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId3,null);
        }

        //Add achievement to the training track

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, 'Achievements');
        List<PBS_Training_Track__c> tracks = [select id,Achievement__c,name from PBS_Training_Track__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        tracks.get(0).Achievement__c = lAchievement.get(0).id;
        update tracks.get(0);

        List<PBS_Training_Track_Level_Item__c> trackItems = [select id,name from PBS_Training_Track_Level_Item__c limit :integer.valueof(System.Label.PBS_soqllimit)];

        System.assertEquals(1,tracks.size());
        System.assert(trackItems.size()>0);

        List<PBS_Training_Track__Share> shares = new List<PBS_Training_Track__Share>();

        for(PBS_Training_Track__c t : tracks){
            PBS_Training_Track__Share tShr  = new PBS_Training_Track__Share();
            tShr.ParentId = t.Id;
            tShr.UserOrGroupId = lmsUsers.get(0).Id;
            tShr.AccessLevel = 'Read';
            shares.add(tShr);
        }

        insert shares;


        Integer aaCount = getTrackAchievements();
        System.assertEquals(0,aaCount);

        List<PBS_Learning_Assignment__c> lasgmts = [select id
                                                ,Progress__c
                                                ,Progress_Percentage__c
                                                from PBS_Learning_Assignment__c
                                                where User__c = :lmsUsers.get(0).Id];

        Test.startTest();

            for(PBS_Learning_Assignment__c la : lasgmts){
                la.Progress__c = 'Completed';
                la.Progress_Percentage__c = 100.0;
            }

            update lasgmts;


        Test.stopTest();

        aaCount = getTrackAchievements();
        System.assertEquals(1,aaCount);

    }

    private static Integer getTrackAchievements(){
        return [select count() from PBS_Achievement_Assignment__c where Training_Track__c != null];
    }
}