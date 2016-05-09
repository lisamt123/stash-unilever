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
private class PBS_MyProfileController_Test {

static testMethod void testWithNoAchievements(){

        //Create admin users
        List<User> adminUsers = PBS_TestUtilClass.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_TestUtilClass.createUsers(2,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_TestUtilClass.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_TestUtilClass.addPermissionSet(lmsUsers,'LMS_User');
        }

        //Update manager for user 1
        User u1 = [select id,managerId from User where id = :lmsUsers.get(0).id];
        u1.managerId = lmsUsers.get(1).Id;
        update u1;

        PageReference ref = Page.PBS_MyProfile;
        Test.setCurrentPageReference(ref);

        Test.startTest();

            System.runAs(lmsUsers.get(0)){

                PBS_MyProfileController_CC cont = new PBS_MyProfileController_CC();
                System.assert(cont.oManager != null);
                
                System.assert(cont.oUser != null);
           
                ref.getParameters().put('aType','Certifications');
                Test.setCurrentPageReference(ref);

              
               

            }

        Test.stopTest();

    }

    static testMethod void testWithAchievements(){

        //Create admin users
        List<User> adminUsers = PBS_TestUtilClass.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_TestUtilClass.createUsers(2,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_TestUtilClass.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_TestUtilClass.addPermissionSet(lmsUsers,'LMS_User');
        }

        //Update manager for user 1
        User u1 = [select id,managerId from User where id = :lmsUsers.get(0).id];
        u1.managerId = lmsUsers.get(1).Id;
        update u1;

       

        PageReference ref = Page.PBS_MyProfile;
        Test.setCurrentPageReference(ref);

        Test.startTest();

            System.runAs(lmsUsers.get(0)){

                PBS_MyProfileController_CC cont = new PBS_MyProfileController_CC();
               
               // PBS_MyProfileController_CC.storeUserProfile('Guest', 'Guest', lmsUsers.get(0).id, 'Guest');
                ref.getParameters().put('aType','Certifications');
                Test.setCurrentPageReference(ref);

               
                
            }

        Test.stopTest();
        System.assert(ref != null);
    }


    static testMethod void testWithAchievementsAndOverrideURL(){

        //Create admin users
        List<User> adminUsers = PBS_TestUtilClass.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_TestUtilClass.createUsers(2,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_TestUtilClass.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_TestUtilClass.addPermissionSet(lmsUsers,'LMS_User');
        }

        //Update manager for user 1
        User u1 = [select id,managerId from User where id = :lmsUsers.get(0).id];
        u1.managerId = lmsUsers.get(1).Id;
        update u1;
        
        PBS_Standard_Job_Profile__c  objPBS_Standard_Job_Profile = new PBS_Standard_Job_Profile__c();
        objPBS_Standard_Job_Profile.name = 'Demand Planner';
       
        insert objPBS_Standard_Job_Profile;
        
        PBS_Profile__c objProfile = new PBS_Profile__c (User_Role__c = objPBS_Standard_Job_Profile.Id,
                                                         User__c = lmsUsers.get(0).id,
                                                         Work_Level__c = 'Guest',
                                                         Geography__c = 'Guest',
                                                         Buddy__c = 'Guest');
        insert objProfile ;
                
        PageReference ref = Page.PBS_MyProfile;
        Test.setCurrentPageReference(ref);

        Test.startTest();

            System.runAs(lmsUsers.get(0)){

               PBS_MyProfileController_CC cont = new PBS_MyProfileController_CC();
                                                     
               cont.getGeographyOptions();
               cont.getWorkLevelOptions();
               cont.getJobProfileOptions();
               cont.getProfile();
               PBS_MyProfileController_CC.storeUserProfile('Guest', 'Guest', objPBS_Standard_Job_Profile.Id, 'Guest');
                ref.getParameters().put('aType','Certifications');
                Test.setCurrentPageReference(ref);

              

            }

        Test.stopTest();
        System.assert(ref != null);
    }

}