@isTest
private class FS_MABE_Test {
//Set up Test Data for unit test    
     @testSetup static void setupTestData(){
        
        String profile='System Administrator';
        String permissionset='FS_Sales_Rep';         
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile];
        Userrole role=[SELECT Id FROM UserRole WHERE Name = 'FS 59040 Sales Rep'];
        User salesRepUser1 = new User(Alias = 'newUser', Email='newuser1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,
        TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper1@testorg.com');
        insert salesRepUser1;
        User salesRepUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,ManagerId = SalesRepUser1.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper@testorg.com');
        insert SalesRepUser;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =:permissionset];
        PermissionSetAssignment psetassignment = new PermissionSetAssignment();
        psetassignment.AssigneeId = salesRepUser.Id;
        psetassignment.PermissionSetId = ps.Id;
        insert psetassignment;        
        system.runAs(salesRepUser){
            //FS_User_Territory__c territory=FS_User_Territory__c.getInstance();
            //Set up Custom settings for Opportunity Trigger
            FSOpportunityTriggerSettings__c oppCustomSettings=new FSOpportunityTriggerSettings__c(name='isEnabled',Enabled__c=true);
            insert oppCustomSettings;            
            // Set up the Account records
            List<Account> accounts = new List<Account>();
            List<Contract> listContract=new List<Contract>();
            Id operatorRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
            Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
            Id existingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Existing').getRecordTypeId();
            
            for(Integer i=0;i < 10;i++){
               accounts.add(new Account(Name = 'FS Test Acc_'+i,recordtypeid=operatorRecordTypeId));
            }
            insert accounts;
            
            For(Account Acc: accounts){
                listContract.add(New Contract(AccountId=Acc.Id,Name=Acc.Name));
            }
            Insert listContract;
            //Set up Opportunity records
            List<Opportunity> opportunities = new List<Opportunity>();
            
            for(contract con:listContract){
                For(Integer i=0;i<10;i++){
                  opportunities.add(new Opportunity(Name = 'FS Test Opportunity',AccountId = con.AccountId ,stageName = '03 – In the funnel',CloseDate = Date.today()+30,contractId=con.id,recordtypeId=newRecordTypeId,DealApproved__c=false));   
                }                                 
                 opportunities.add(new Opportunity(Name = 'FS Test Opportunity',AccountId = con.AccountId ,StageName = '01 – Universe',CloseDate = Date.today()+30,contractId=con.id,recordtypeId=existingRecordTypeId));
                 }
            insert opportunities;
            
            //Set up Product records     
            List<Product2> products=new  List<Product2>();
            
            for(Integer i=0;i < 2;i++){
                products.add(new Product2(Name = 'FS Test Product_'+i,COGS__c=(i+1),isActive=true,MarketType__c='BOH MAYO',StartDate__c=date.today(),EndDate__c=date.today()+1,CanUseQuantitySchedule=true));
            }
            insert products;
            
            //Fetch standard Price Book     
            Id pricebookId = Test.getStandardPricebookId();
            
            //Set up Price Book Entry records
            List<priceBookEntry> pricebookentries= new List<priceBookEntry>();
            
            for(Product2 prod : products)
            {
               pricebookentries.add(new priceBookEntry ( pricebook2id = pricebookId,Product2Id = prod.id,  unitPrice = 1000, IsActive = true,UseStandardPrice = false,FS_Bracket_1__c=1)); 
            }
            insert pricebookentries;
            List<Opportunity> oppList=new List<Opportunity>();
            oppList=[select id,name,stagename,contractid,recordtypeid,DealApproved__c from opportunity where recordtypeid=:newRecordTypeId and stagename='03 – In the funnel' limit 1];
            
         List<OpportunityLineItem> listOli=new List<OpportunityLineItem>();
         For(Opportunity Opp : oppList){             
                 For(PriceBookEntry Pbe: pricebookentries){
                     listOli.add(new OpportunityLineItem(OpportunityId=Opp.Id,PriceBookEntryId=Pbe.Id,Quantity=1200,totalPrice=Pbe.unitPrice,Distributor__c='CA GFS')); 
                 }                
             }         
         Insert listOli;
            List<OpportunityLineItemSchedule> listScheduletoinsert=new List<OpportunityLineItemSchedule>();
            For(OpportunityLineItem Oli : listoli){
            system.assertNotEquals(null, oli.Id);
            //system.assertEquals(true,Oli.Product2.CanUseRevenueSchedule);
            //If(Oli.Product2.CanUseRevenueSchedule==true){
            For(Integer i=1;i<=12;i++){
            listScheduletoinsert.add(new OpportunityLineItemSchedule(OpportunityLineItemId=oli.id,quantity=100,scheduledate=Date.newinstance(system.today().year(),i, 1),Type='Quantity'));                
            }                
            }
            //}            
            //system.assertEquals(false,listScheduletoinsert.isEmpty());
            //system.assertEquals(24, listScheduletoinsert.size());
            try{              
              if(!listScheduletoinsert.isEmpty()){
                  Insert listScheduletoinsert;
              }              
             }
             Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'FS_MonthlyClaimedCasesbatch', 'UpdateOppField', e.getMessage(), e, null, null, null, 0,'Food Solution');
              }            
            system.debug(listScheduletoinsert);
            listScheduletoinsert=new List<OpportunityLineItemSchedule>();
            listScheduletoinsert=[select id from OpportunityLineItemSchedule];
            //system.assertEquals(24, listScheduletoinsert.size());
            List<Opportunity> ListNewOppToBeclosed=new List<Opportunity>();
            For(Opportunity Opp: oppList){
            //Opp.FS_Agreement_Date__c=system.today();
            Opp.StageName='04 - Verbal Commitment';
            Opp.DealApproved__c=true;
            ListNewOppToBeclosed.add(Opp);
            }
Update ListNewOppToBeclosed;
}
}
    
static testMethod void TestCopyOliToExisting(){
//user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
//system.runAs(SalesRepUser){

    List<Opportunity> listNewOpp=new List<Opportunity>();
    Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
    listNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and DealApproved__c=true];
    List<Opportunity> listNewOppToBeclosed=new List<Opportunity>();
    listNewOppToBeclosed=new List<Opportunity>();
    Set<Id> contractList=New Set<Id>();
    For(Opportunity opp: listNewOpp){
    opp.AgreementDate__c=system.today();
    opp.StageName='05 – Won';
    contractList.add(opp.ContractId);
    listNewOppToBeclosed.add(Opp);
    }

    Test.startTest();
    Update listNewOppToBeclosed;
    Test.stopTest();
    

    List<Opportunity> listExistingOpp=new List<Opportunity>();
    Id existingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Existing').getRecordTypeId();
    //Get list of Existing Opportunities
    listExistingOpp=[select id,ContractId from Opportunity where recordtypeId=:existingRecordTypeId and ContractId in :ContractList];
List<OpportunityLineItem> listNewOppLineItem=New List<OpportunityLineItem>();
listNewOppLineItem=[select Id,OpportunityId,Product2Id,Opportunity.ContractId from OpportunityLineItem where opportunityId in : ListNewOpp];
List<OpportunityLineItem> listOppLineItemCreated=New List<OpportunityLineItem>();
listOppLineItemCreated=[select Id,OpportunityId,Product2Id,Opportunity.ContractId,contract_product__c,Quantity from OpportunityLineItem where opportunityId in : ListExistingOpp];
List<Contract_Product__c> listNewContractProduct=New List<Contract_Product__c>();
listNewContractProduct=[select contract__c,product__c from contract_product__c where contract__c in : ContractList];
List<FS_Monthly_Claimed_Cases__c> listclaimed_case=new List<FS_Monthly_Claimed_Cases__c>();
listclaimed_case=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :ListNewContractProduct];
system.assertEquals(true, !ListOppLineItemCreated.isEmpty());
system.assertEquals(true, !ListNewContractProduct.isEmpty());
//system.assertequals(true,!listclaimed_case.isEmpty());
    For(OpportunityLineItem oli : listOppLineItemCreated){
        system.assertNotEquals(null,oli.contract_product__c);
        system.assertNotEquals(null,oli.Quantity);
    }
//}
}//End for TestCopyOliToExisting
    
 static TestMethod void testCalculateForecast(){
 List<Opportunity> listNewOpp=new List<Opportunity>();
 Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
 listNewOpp=[select id,ContractId from Opportunity where recordtypeId=:newRecordTypeId];
 List<Opportunity> listNewOppToBeclosed=new List<Opportunity>();
 listNewOppToBeclosed=new List<Opportunity>();
 Set<Id> contractList=New Set<Id>();
 listNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and DealApproved__c=true limit 1];
 
     For(Opportunity opp: listNewOpp){
     opp.AgreementDate__c=system.today();
     opp.StageName='05 – Won';
     contractList.add(opp.ContractId);
     listNewOppToBeclosed.add(opp);
     }
     Update listNewOppToBeclosed;
     
     List<Contract_Product__c> listNewContractProduct=New List<Contract_Product__c>();
     listNewContractProduct=[select contract__c,product__c from contract_product__c where contract__c in : ContractList limit 1];
     List<FS_Monthly_Claimed_Cases__c> listclaimed_case=new List<FS_Monthly_Claimed_Cases__c>();
     listclaimed_case=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c,FS_Claimed_Cases_Paid__c,FS_Forecast_Quantity__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :ListNewContractProduct];
     system.debug(listclaimed_case);
     system.debug(listclaimed_case.size());
     List<OpportunityLineItemSchedule> listScheduletoinsert=new List<OpportunityLineItemSchedule>();
     listScheduletoinsert=[select id from OpportunityLineItemSchedule where OpportunityLineItem.Opportunity.ContractId in :contractList];
     system.assertEquals(24, listScheduletoinsert.size());
     system.assertequals(12,listclaimed_case.size());     
     List<FS_Monthly_Claimed_Cases__c> listclaimed_case_Update=new List<FS_Monthly_Claimed_Cases__c>();
     For(FS_Monthly_Claimed_Cases__c claimed_Case : listclaimed_case){
       claimed_Case.FS_Claimed_Cases_Paid__c=10;
       listclaimed_case_Update.add(claimed_Case);
    }
Update(listclaimed_case_Update);
system.assertNotEquals(null, listclaimed_case_Update.size());
//ClaimCaseForecast.ClaimCaseList=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c,FS_Claimed_Cases_Paid__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :ListNewContractProduct];
Test.startTest();
MonthlyClaimCasesBatch ClaimCaseForecast=new MonthlyClaimCasesBatch();
//Database.executeBatch(ClaimCaseForecast,1);
Database.QueryLocator ql = ClaimCaseForecast.start(null);
ClaimCaseForecast.execute(null,listclaimed_case_Update);
ClaimCaseForecast.finish(null);
Test.stopTest();

    //For(FS_Monthly_Claimed_Cases__c claimed_Case : listclaimed_case){     
    //system.debug(claimed_Case.FS_Forecast_Quantity__c);
    //system.assertNotEquals(Null,claimed_Case.FS_Forecast_Quantity__c);
    //}
//}
    //}
}//End for TestCreateContractProduct

static TestMethod void testCreateClaimedCase(){
List<Opportunity> ListNewOpp=new List<Opportunity>();
Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
ListNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and DealApproved__c=true limit 2];
//ListNewOpp=[select id,ContractId from Opportunity where recordtypeId=:newRecordTypeId];
List<Opportunity> ListNewOppToBeclosed=new List<Opportunity>();
//ListNewOppToBeclosed=new List<Opportunity>();
Set<Id> ContractList=New Set<Id>();
For(Opportunity Opp: ListNewOpp){
Opp.AgreementDate__c=system.today();
Opp.StageName='05 – Won';
ContractList.add(Opp.ContractId);
ListNewOppToBeclosed.add(Opp);
}
Update ListNewOppToBeclosed;
List<Contract_Product__c> ListNewContractProduct=New List<Contract_Product__c>();
ListNewContractProduct=[select contract__c,product__c from contract_product__c where contract__c in : ContractList];
List<FS_Monthly_Claimed_Cases__c> listClaimed_Case=new List<FS_Monthly_Claimed_Cases__c>();
listClaimed_Case=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c,FS_Claimed_Cases_Paid__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :ListNewContractProduct];
Map<id,List<FS_Monthly_Claimed_Cases__c>> MapClaimCase=new Map<id,List<FS_Monthly_Claimed_Cases__c>>();
        List<FS_Monthly_Claimed_Cases__c> tempList  = new List<FS_Monthly_Claimed_Cases__c>();
        //set<id> tempSet = new set<id>();
        for(FS_Monthly_Claimed_Cases__c claimed_case : listclaimed_case)
        {
            tempList  = new List<FS_Monthly_Claimed_Cases__c>();
            if(MapClaimCase.containskey(claimed_case.Contract_Product__c))
                    {
                        tempList   = MapClaimCase.get(claimed_case.Contract_Product__c);
                    }
            If(claimed_case.FS_First_of_Month__c!=Null){
            tempList.add(claimed_case);
            }            		
                    MapClaimCase.put(claimed_case.Contract_Product__c,tempList);
            //tempSet.add(claimed_case.Contract_Product__c);
        }
NewMonthlyClaimCase_Batch ClaimCaseForecast=new NewMonthlyClaimCase_Batch();
Test.startTest();
ClaimCaseForecast.start(null);
ClaimCaseForecast.execute(null,listClaimed_Case);
ClaimCaseForecast.finish(null);
Test.stopTest();
}//End for TestLinkOlitoConProd
}//End for test class