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
private class PBS_TPlanAsgnmtExtensionNew_Test{

    static testmethod void testSearchWithoutFilters(){

        // Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers   = PBS_UtilClass_Test.createUsers(10,'Standard User');

        System.runAs(adminUsers.get(0)){
            // Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleData();

        List<PBS_Training_Plan__c> tplans = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplans.size());
        PBS_Training_Plan__c tplan  = tplans.get(0);

        // Test Insert
        PageReference testPageRef = Page.PBS_TrainingPlanAssignmentNew;
        Test.setCurrentPageReference(testPageRef);
        Test.startTest();

            System.runAs(adminUsers.get(0)){

                PBS_TrainingPlanAsgmtExtNew_CC cont = new PBS_TrainingPlanAsgmtExtNew_CC(new ApexPages.StandardController(tplan));
                List<SelectOption> profileList = cont.getProfiles();
                System.assert(profilelist.size()>0);
                List<SelectOption> rolesList = cont.getRoles();
                System.assert(rolesList.size()>0);
                PageReference ref;
                //An empty search should return all users
                List<PBS_TrainingPlanAsgmtExtNew_CC.UserWrapper> users = cont.users;
                System.assertEquals(0,users.size());
                ref = cont.searchUsers();

                users = cont.users;
                System.assert(users.size()>=12, 'User size is: ' + String.valueOf(users.size()) + ' lms : ' + String.valueOf(lmsUsers.size()));

                //Test import Assignmentes reference
                PageReference importPage = cont.goToImportAssignments();
                System.assert(importPage != null);

            }
        Test.stopTest();
    }

    static testmethod void testSearchWithFiltersAndAssignments(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }



        User sampleUser = [select id,firstName,lastName,email,profileId,userroleId from User where id in :lmsUsers limit 1];

        PBS_TrainingPlanData_Test.createSampleData();

        List<PBS_Training_Plan__c> tplans = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplans.size());
        PBS_Training_Plan__c tplan  = tplans.get(0);

        //Test Insert
        PageReference testPageRef = Page.PBS_TrainingPlanAssignmentNew;
        Test.setCurrentPageReference(testPageRef);
        Test.startTest();

            System.runAs(adminUsers.get(0)){

                PBS_TrainingPlanAsgmtExtNew_CC cont = new PBS_TrainingPlanAsgmtExtNew_CC(new ApexPages.StandardController(tplan));
                cont.firstName = sampleUser.firstName;
                cont.lastName = sampleUser.lastName;
                cont.email = sampleUser.email;
                cont.profileId = sampleUser.profileId;
                cont.roleId = sampleUser.userroleId;

                PageReference ref;
                //An empty search should return all users
                List<PBS_TrainingPlanAsgmtExtNew_CC.UserWrapper> users = cont.users;
                System.assertEquals(0,users.size());
                ref = cont.searchUsers();
                users = cont.users;
                System.assertEquals(1,users.size());
                //Select the user
                cont.users.get(0).isSelected = true;
                //Do assignment
                try{
                    ref = cont.assignUsers();
                }catch(Exception e){
                    System.assert(false,'Assignment failed');
                }

            }


        Test.stopTest();

    }

    static testmethod void testSingleUserAssignment(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(1,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        User sampleUser = [select id,firstName,lastName,email,profileId,userroleId from User where id in :lmsUsers limit 1];

        PBS_TrainingPlanData_Test.createSampleData();

        List<PBS_Training_Plan__c> tplans = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplans.size());
        PBS_Training_Plan__c tplan  = tplans.get(0);

        PageReference testPageRef = Page.PBS_TrainingPlanAssignmentNewSingle;
        Test.setCurrentPageReference(testPageRef);
        Test.startTest();

            System.runAs(adminUsers.get(0)){

                PBS_TrainingPlanAsgmtExtNew_CC cont = new PBS_TrainingPlanAsgmtExtNew_CC(new ApexPages.StandardController(tplan));

                PageReference ref;
                List<SelectOption> communitiesOptions = cont.getCommunities();
                System.assert(communitiesOptions.size()>0); //There should at least be an empty option for communities
                cont.dummySingleAssignment.User__c = lmsUsers.get(0).Id;
                try{
                    ref = cont.assignSingleUser();
                    List<PBS_Training_Plan_Assignment__c> userTPlanAssignment = [select id from PBS_Training_Plan_Assignment__c where User__c = :lmsUsers.get(0).Id];
                    System.assert(userTPlanAssignment.size()>0, 'Assignment was not created');
                }catch(Exception e){
                    System.assert(false,'Assignment failed');
                }

            }
        Test.stopTest();
    }

    static testmethod void testSingleUserAssignmentFailure(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(1,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
        }

        User sampleUser = [select id,firstName,lastName,email,profileId,userroleId from User where id in :lmsUsers limit 1];

        PBS_TrainingPlanData_Test.createSampleData();

        List<PBS_Training_Plan__c> tplans = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplans.size());
        PBS_Training_Plan__c tplan  = tplans.get(0);

        PageReference testPageRef = Page.PBS_TrainingPlanAssignmentNewSingle;
        Test.setCurrentPageReference(testPageRef);
        Test.startTest();

            System.runAs(adminUsers.get(0)){

                PBS_TrainingPlanAsgmtExtNew_CC cont = new PBS_TrainingPlanAsgmtExtNew_CC(new ApexPages.StandardController(tplan));

                PageReference ref;
                cont.dummySingleAssignment.User__c = lmsUsers.get(0).Id;
                try{
                    ref = cont.assignSingleUser();
                    List<PBS_Training_Plan_Assignment__c> userTPlanAssignment = [select id from PBS_Training_Plan_Assignment__c where User__c = :lmsUsers.get(0).Id];
                    System.assert(userTPlanAssignment.size() == 0, 'Assignment was created for invalid user');
                }catch(Exception e){
                    System.assert(false,'Assignment failed');
                }

            }
        Test.stopTest();
    }
}