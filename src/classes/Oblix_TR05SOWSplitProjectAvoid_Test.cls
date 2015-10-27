@isTest 
private class Oblix_TR05SOWSplitProjectAvoid_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Profile p=[Select Id from Profile where Name='System Administrator' or Name='Système Administrateur'];       
     
         //Insert User 
         User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
          EmailEncodingKey='UTF-8', LastName='af test', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id,firstname='sf test one', 
          TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
          UserName='testuser@test123321.com');//,AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1'
         insert u;  
         
         System.runAs(u){
                Marketing_SOW__c marketingSow = new Marketing_SOW__c();
                marketingSow.Active__c = true;
                marketingSow.Name = 'Marketinf Sow Approval Test';
                marketingSow.SOW_Status__c = 'Open';
                insert marketingSow;
            MDO_Geography__c geography = new MDO_Geography__c();
                geography.Name = 'France';
                geography.geography_type__c = 'Country Cluste';
                insert geography;
                
            Oblix_SOW_Projects__c project = new Oblix_SOW_Projects__c();
                project.Name = 'Project #2';
                project.OblixCountries__c = 'France';
                project.Financial_Year__c = marketingSow.Id;
                insert project;     
               
				Test.startTest();
				      
                List<Oblix_Marketing_SOW_Project_Splits__c> lstSplit = new List<Oblix_Marketing_SOW_Project_Splits__c>();
                for(Integer i=0;i<5;i++){
                    Oblix_Marketing_SOW_Project_Splits__c projectSplit = new Oblix_Marketing_SOW_Project_Splits__c();
                    
                    projectSplit.Project_Splits__c = project.Id;
                    projectSplit.Percentage__c = 18;
                    projectSplit.OblixCountry__c = geography.Id;
                    
                    lstSplit.add(projectSplit);
                }
                insert lstSplit;
               Oblix_SOW_Projects__c projectRetrieve = [Select Id, Name, OblixProjectSplitPercentage_Comment__c from Oblix_SOW_Projects__c where Id =: project.Id];
        		System.assertequals(projectRetrieve.OblixProjectSplitPercentage_Comment__c, 'Total Percentage for that project is below 100%, please raise it');
                
        		try{
        			for(Oblix_Marketing_SOW_Project_Splits__c split : lstSplit){
        				split.Percentage__c = 60;
        			}
        			update lstSplit;
        			System.assertequals(projectRetrieve.OblixProjectSplitPercentage_Comment__c, 'Total Percentage for that project is below 100%, please raise it');
        		}catch(Exception e){
        			System.debug('###Split error valdiation : '+e.getMessage());
        		}
        		Test.stopTest();         
         }
    }
}