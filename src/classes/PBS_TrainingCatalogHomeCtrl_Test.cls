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
private class PBS_TrainingCatalogHomeCtrl_Test {

    static testMethod void testCatalogPageWithoutEntries(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(2,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        PageReference ref = Page.PBS_TrainingCatalogHome;
        Test.setCurrentPageReference(ref);
        Test.startTest();
            System.runAs(lmsUsers.get(0)){
                PBS_TrainingCatalogHomeController_CC cont = new PBS_TrainingCatalogHomeController_CC();
                System.assertEquals(0,cont.lcategories.size());
            }
        Test.stopTest();

    }

    static testMethod void testCatalogPageWithEntries(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(2,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleData();

        List<PBS_Training_Plan__c> tplans = [select id
                                            ,Enable_Self_Registration__c
                                            ,Self_Registration_Access__c
                                            from PBS_Training_Plan__c];

        System.assertEquals(1,tplans.size());
        PBS_Training_Plan__c tplan = tplans.get(0);
        tplan.Enable_Self_Registration__c = true;
        tplan.Self_Registration_Access__c = 'Public';
        update tplan;

        System.assertEquals(0,getTrainingPlanAssignmentsCount(tplan.Id));

        PageReference ref = Page.PBS_TrainingCatalogHome;
        ref.getParameters().put('id',tplan.Id);

        Test.setCurrentPageReference(ref);
        Test.startTest();
            System.runAs(lmsUsers.get(0)){
                PBS_TrainingCatalogHomeController_CC cont = new PBS_TrainingCatalogHomeController_CC();
                System.assert(cont.lcategories.size()>0);
            }
        Test.stopTest();

    }

    private static Integer getTrainingPlanAssignmentsCount(Id tplanId){
        return [select count() from PBS_Training_Plan_Assignment__c where Training_Plan__c = :tplanId];
    }

}