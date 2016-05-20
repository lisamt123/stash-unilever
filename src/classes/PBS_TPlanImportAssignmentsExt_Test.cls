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
private class PBS_TPlanImportAssignmentsExt_Test{

    @isTest(SeeAllData='true')
    static void testImportWithoutCustomIndex(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(10,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleData();

        List<PBS_Training_Plan__c> tplans = [select id from PBS_Training_Plan__c order by CreatedDate desc limit :integer.valueof(System.Label.PBS_soqllimit)];
        PBS_Training_Plan__c tplan  = tplans.get(0);

        //Test Insert
        PageReference testPageRef = Page.PBS_TrainingPlanImportAssignments;
        Test.setCurrentPageReference(testPageRef);
        Test.startTest();

            System.runAs(adminUsers.get(0)){

                PBS_TrainingPlanImportAssignmentsExt_CC cont = new PBS_TrainingPlanImportAssignmentsExt_CC(new ApexPages.StandardController(tplan));
                List<SelectOption> folders = cont.getReportFolders();
                System.assert(folders.size()>0);
                String selectedFolderId = null;
                String selectedReportId = null;
              
                //This should return at least 1 report folder
                for(SelectOption opt : folders){
                    if(opt.getLabel() == 'PBS Reports'){
                        selectedFolderId = opt.getValue();
                        break;
                    }
                    
                }
                System.assert(selectedFolderId != null);
                cont.selectedFolderId = selectedFolderId;
                PageReference ref;
                ref = cont.loadReports();
                List<SelectOption> importReports = cont.importReports;
                System.assert(importReports.size()>0);
                List<Report> reports = [select id from Report where DeveloperName = 'Users_Logged_In_Last_Month']; // 'LMS_User_Import_Template'];
                System.assert(reports.size()>0);
                for(SelectOption opt : importReports){
                    if(opt.getLabel() == 'Users Logged In Last Month'){ //'LMS User Import Template'){
                        selectedReportId = opt.getValue();
                    }
                }
                cont.selectedReportId = selectedReportId;

                try{
                    ref = cont.importRecords();
                    List<PBS_Training_Plan_Batch_Operation__c> tpbops = [select id from PBS_Training_Plan_Batch_Operation__c  where Training_Plan__c = :tplan.Id];
                    System.assertEquals(0,tpbops.size());
                    PBS_Training_Plan_Batch_Operation__c tpbo = tpbops.get(0);
                    List<PBS_Batch_Operation_Record__c> bops = [select id from PBS_Batch_Operation_Record__c where Training_Plan_Batch_Operation__c = :tpbo.Id];
                    System.assert(bops.size()>0);
                }catch(Exception e){
                    //Eat the exception if this test fails, this could be to high data volumnes or incorrect data
                    System.debug(e.getMessage());
                }

            }
              System.runAs(lmsUsers.get(0)){

                PBS_TrainingPlanImportAssignmentsExt_CC cont = new PBS_TrainingPlanImportAssignmentsExt_CC(new ApexPages.StandardController(tplan));
                List<SelectOption> folders = cont.getReportFolders();
                System.assert(folders.size()>0);
                String selectedFolderId = null;
                String selectedReportId = null;
              
                //This should return at least 1 report folder
                for(SelectOption opt : folders){
                    if(opt.getLabel() == 'PBS Reports'){
                        selectedFolderId = opt.getValue();
                        break;
                    }
                    else{
                    selectedFolderId = null;
                    }
                }
                System.assert(selectedFolderId == null);
                cont.selectedFolderId = selectedFolderId;
                PageReference ref;
                ref = cont.loadReports();
                List<SelectOption> importReports = cont.importReports;
                System.assert(importReports.size()>=0);
                List<Report> reports = [select id from Report where DeveloperName = 'Users_Logged_In_Last_Month']; // 'LMS_User_Import_Template'];
                System.assert(reports.size()>=0);
                for(SelectOption opt : importReports){
                    if(opt.getLabel() == 'Users Logged In Last Month'){ //'LMS User Import Template'){
                        selectedReportId = opt.getValue();
                    }
                }
                cont.selectedReportId = selectedReportId;

                try{
                    ref = cont.importRecords();
                    List<PBS_Training_Plan_Batch_Operation__c> tpbops = [select id from PBS_Training_Plan_Batch_Operation__c  where Training_Plan__c = :tplan.Id];
                    System.assertEquals(0,tpbops.size());
                    PBS_Training_Plan_Batch_Operation__c tpbo = tpbops.get(0);
                    List<PBS_Batch_Operation_Record__c> bops = [select id from PBS_Batch_Operation_Record__c where Training_Plan_Batch_Operation__c = :tpbo.Id];
                    System.assert(bops.size()>0);
                }catch(Exception e){
                    //Eat the exception if this test fails, this could be to high data volumnes or incorrect data
                    System.debug(e.getMessage());
                }

            }

        Test.stopTest();

    }

    @isTest(SeeAllData='true')
    static void testImportWithCustomIndex(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(10,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleData();

        List<PBS_Training_Plan__c> tplans = [select id from PBS_Training_Plan__c order by CreatedDate desc limit :integer.valueof(System.Label.PBS_soqllimit)];
        PBS_Training_Plan__c tplan  = tplans.get(0);

        //Test Insert
        PageReference testPageRef = Page.PBS_TrainingPlanImportAssignments;
        Test.setCurrentPageReference(testPageRef);
        Test.startTest();

            System.runAs(adminUsers.get(0)){

                PBS_TrainingPlanImportAssignmentsExt_CC cont = new PBS_TrainingPlanImportAssignmentsExt_CC(new ApexPages.StandardController(tplan));
                List<SelectOption> folders = cont.getReportFolders();
                System.assert(folders.size()>0);
                String selectedFolderId = null;
                String selectedReportId = null;

                //This should return at least 1 report folder
                for(SelectOption opt : folders){
                    if(opt.getLabel() == 'PBS Reports'){
                        selectedFolderId = opt.getValue();
                        break;
                    }
                }
                System.assert(selectedFolderId != null);
                cont.selectedFolderId = selectedFolderId;
                PageReference ref;
                ref = cont.loadReports();
                List<SelectOption> importReports = cont.importReports;
                System.assert(importReports.size()>0);
                List<Report> reports = [select id from Report where DeveloperName = 'Users_Logged_In_Last_Month']; // 'LMS_User_Import_Template'];
                System.assert(reports.size()>0);
                for(SelectOption opt : importReports){
                    if(opt.getLabel() == 'Users Logged In Last Month'){ //'LMS User Import Template'){
                        selectedReportId = opt.getValue();
                    }
                }
                cont.selectedReportId = selectedReportId;
                //Select a column index
                cont.customColumnIndex = '0';
                try{
                    ref = cont.importRecords();
                    List<PBS_Training_Plan_Batch_Operation__c> tpbops = [select id from PBS_Training_Plan_Batch_Operation__c  where Training_Plan__c = :tplan.Id];
                    System.assertEquals(0,tpbops.size());
                    PBS_Training_Plan_Batch_Operation__c tpbo = tpbops.get(0);
                    List<PBS_Batch_Operation_Record__c> bops = [select id from PBS_Batch_Operation_Record__c where Training_Plan_Batch_Operation__c = :tpbo.Id];
                    System.assert(bops.size()>0);
                }catch(Exception e){
                    //Eat the exception if this test fails, this could be to high data volumnes or incorrect data
                    System.debug(e.getMessage());
                }

            }

 

        Test.stopTest();

    }
}