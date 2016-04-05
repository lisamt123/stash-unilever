//S.M. 2016-03-12 - THIS CLASS IS NO LONGER USED!! 
    //Replaced by Oblix_ProjectHandlerLogic as part of code refactoring


@isTest 
private class Oblix_TR05SOWSplitProjectAvoid_Test {

    //static testMethod void myUnitTest() {

    //    User u = Oblix_TestUtils.createTestUser();  
         
    //    System.runAs(u){
    //            Marketing_SOW__c marketingSow = new Marketing_SOW__c();
    //            marketingSow.Active__c = true;
    //            marketingSow.Name = 'Marketinf Sow Approval Test';
    //            marketingSow.SOW_Status__c = 'Open';
    //            insert marketingSow;
    //        MDO_Geography__c geography = new MDO_Geography__c();
    //            geography.Name = 'France';
    //            geography.geography_type__c = 'Country Cluste';
    //            insert geography;
    //        Oblix_SOW_Projects__c project = new Oblix_SOW_Projects__c();
    //            project.Name = 'Project #2';
    //            project.Campaign_Countries__c = 'France';
    //            project.Financial_Year__c = marketingSow.Id;
    //            insert project;     
 				
                      
    //            List<Oblix_Marketing_SOW_Project_Splits__c> lstSplit = new List<Oblix_Marketing_SOW_Project_Splits__c>();
    //            for(Integer i=0;i<5;i++){
    //                Oblix_Marketing_SOW_Project_Splits__c projectSplit = new Oblix_Marketing_SOW_Project_Splits__c();
                    
    //                projectSplit.Project_Splits__c = project.Id;
    //                projectSplit.Percentage__c = 18;
    //                projectSplit.OblixCountry__c = geography.Id;
                    
    //                lstSplit.add(projectSplit);
    //            }
    //            insert lstSplit;
                
    //           Oblix_SOW_Projects__c projectRetrieve = [Select Id, Name, OblixProjectSplitPercentage_Comment__c from Oblix_SOW_Projects__c where Id =: project.Id];
    //            System.assertequals(projectRetrieve.OblixProjectSplitPercentage_Comment__c, 'Total Percentage for that project is below 100%, please raise it');
                
    //            try{
    //                for(Oblix_Marketing_SOW_Project_Splits__c split : lstSplit){
    //                    split.Percentage__c = 60;
    //                }
                
    //                update lstSplit;
    //                System.assertequals(projectRetrieve.OblixProjectSplitPercentage_Comment__c, 'Total Percentage for that project is below 100%, please raise it');
    //                delete lstSplit[4];
    //                Test.startTest();
    //                delete lstSplit[3];
    //                delete lstSplit[2];
    //                delete lstSplit[1];
    //            }catch(Exception e){
    //                System.debug('###Split error valdiation : '+e.getMessage());
    //            }
    //            Test.stopTest();         
    //    }
    //}
}