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
private class PBS_TPlanAchievementMnagmntExt_Test{

  static testmethod void testAchievementsMassUpdate(){

    //Create admin users
    List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
    List<User> lmsUsers = PBS_UtilClass_Test.createUsers(10,'Standard User');

    System.runAs(adminUsers.get(0)){
      //Assign corresponding perm sets
      PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
      PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
    }

    PBS_TrainingPlanData_Test.createSampleData();

    List<PBS_Training_Plan__c> tplans = [select id from PBS_Training_Plan__c];
    System.assertEquals(1,tplans.size());
    PBS_Training_Plan__c tplan  = tplans.get(0);

    Set<Id> selectedUserIds = new Set<Id>();
    for(User u : lmsUsers){
      selectedUserIds.add(u.Id);
    }

    System.runAs(adminUsers.get(0)){
      PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplan.Id,null);
            System.assertEquals(10,getTrainingPlanAssignmentsCount(tplan.Id));
        }

        System.assertEquals(0,getAchievementAssignmentsCount(tplan.Id));

    //Test Insert
        PageReference testPageRef = Page.PBS_TrainingPlanAchievementManagement;
        Test.setCurrentPageReference(testPageRef);
    Test.startTest();

      System.runAs(adminUsers.get(0)){

                //Add achievements to the training plan
            List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
            List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, 'Achievements');
            List<PBS_Training_Plan_Achievement__c> lTPlanAchievement = PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplans, lAchievement);


                PBS_TrainingPlanAchievementMngmtExt_CC cont = new PBS_TrainingPlanAchievementMngmtExt_CC(new ApexPages.StandardController(tplan));
                cont.upsertAchievementAssignments();
      }


    Test.stopTest();
        System.assertEquals(10,getAchievementAssignmentsCount(tplan.Id));


  }

    private static Integer getTrainingPlanAssignmentsCount(String tplanId){
        return [select count() from PBS_Training_Plan_Assignment__c where Training_Plan__c = :tplanId];
    }

    private static Integer getAchievementAssignmentsCount(String tplanId){
    return [select count() from PBS_Achievement_Assignment__c where Training_Plan_Achievement__r.Training_Plan__c = :tplanId];
    }

}