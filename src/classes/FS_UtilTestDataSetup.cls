public with sharing class FS_UtilTestDataSetup {
    //Method to create user
    Public user createTestUser(){
        String profile='System Administrator';
        //String permissionset='FS_Sales_Rep';         
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
        //PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =:permissionset];
        //PermissionSetAssignment psetassignment = new PermissionSetAssignment();
        //psetassignment.AssigneeId = salesRepUser.Id;
        //psetassignment.PermissionSetId = ps.Id;
        //insert psetassignment;
        Return SalesRepUser;
    }
    Public void setUpTestData(User salesRepUser){
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
            
            //Set up opportunity for Account Planning
             //Set up account plan records
            RecordType AccPlan_rt = [select id,Name from RecordType where SobjectType='FS_Account_Plan__c' and Name='Operator' Limit 1];
            List<FS_Account_Plan__c> AccPlanList = new List<FS_Account_Plan__c>();
            for(Account acc:accounts){
                AccPlanList.add(new FS_Account_Plan__c(FS_Customer__c=acc.id,FS_Status__c='Planning',FS_Start_Date__c=date.today(),FS_End_Date__c=date.today(),RecordTypeid=AccPlan_rt.Id));
            }           
          insert AccPlanList;        
            //Set up defined objective
            RecordType Obj_rt = [select id,Name from RecordType where SobjectType='FS_Defined_objective__c' and Name='Operator Objective' Limit 1];
            List<FS_Defined_Objective__c> ObjList=new List<FS_Defined_Objective__c>(); 
            for(FS_Account_Plan__C AccPlan:AccPlanList){
                for(integer i=0;i<5;i++){
                objList.add(new FS_Defined_Objective__c(FS_Account_Plan__c=AccPlan.id,FS_Customer__c=AccPlan.FS_Customer__c,FS_Status__C='Planning',RecordTypeid=Obj_rt.Id));
            }
            }
            insert objList;
            List<Risk__c> riskList=new List<Risk__c>(); 
            for(FS_Account_Plan__C accPlan:AccPlanList){
                for(FS_Defined_Objective__c obj : objList){
                  riskList.add(new Risk__c(Account_Plan__c=accPlan.id,Defined_Objective__c=obj.id,FS_Sector__c='Test'));  
                }
            }
            Insert riskList;
            //Set up Opportunity records
            opportunities = new List<Opportunity>();
            //Create 10 opportunities for each objective
            for(FS_Defined_Objective__c Obj : Objlist){
                for(integer i=0;i<1;i++){
                opportunities.add(new Opportunity (Name = 'FS Account Planning Test Opportunity',Reason__c='Price',FS_ReasonDescription__c='Field Activity',AccountId = Obj.FS_Customer__c,StageName = '01 – Universe',CloseDate = Date.today(),Account_Plan__c=Obj.FS_Account_Plan__c,Defined_Objective__c=obj.id));
            }
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
            listScheduletoinsert=[select id from OpportunityLineItemSchedule limit 49999];
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
}