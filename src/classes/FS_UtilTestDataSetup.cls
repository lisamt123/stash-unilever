@isTest
public with sharing class FS_UtilTestDataSetup {    
    Private Map<String, String> recordIdBasedonDeveloperName=FS_Utility.recordTypewithName('Opportunity');
    String oppStageName='FS_Stages';
    Id newRecordTypeId=recordIdBasedonDeveloperName.get('FS_OpportunityMABE');
    Id existingRecordTypeId=recordIdBasedonDeveloperName.get('FS_ExistingBusiness');  
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
        Return SalesRepUser;
    }
    //Create custom settings for opportunity stages
    Public void setUpOpportunityStages(){
        FS_OpportunityStages__c oppStages=new FS_OpportunityStages__C(name='FS_Stages',FS_Stage_Prospecting__c='01 - Prospecting',FS_Stage_Proposal__c='03 - Proposal',FS_Stage_Commitment__c='04 - Verbal Commitment',FS_Stage_Won__c='05 – Won');
        insert oppStages;        
    }
    //create custom settings to enable opportunity trigger
    Public void enableOpportunityTrigger(){
        //Set up Custom settings for Opportunity Trigger
        FSOpportunityTriggerSettings__c oppCustomSettings=new FSOpportunityTriggerSettings__c(name='isEnabled',Enabled__c=true);
        insert oppCustomSettings;         
    }
    
    //Create account data for test data set up
    Public List<Account> setUpAccountData(){     
        List<Account> accounts = new List<Account>();
        Id operatorRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();        
        for(Integer i=0;i < 10;i++){
            accounts.add(new Account(Name ='FS Test Acc_'+i,recordtypeid=operatorRecordTypeId));
        }
        insert accounts;  
        return accounts;        
    }
    
    //create contract data for test data set up
    Public List<Contract> setUpContractData(List<Account> accounts){
        List<Contract> listContract=new List<Contract>();
        For(Account Acc: accounts){
            listContract.add(New Contract(AccountId=Acc.Id,Name=Acc.Name));
        }
        Insert listContract;
        return listContract;
    }
    
    //Create opportunity for MABE process
    Public List<Opportunity> setUpMABEOpportunityData(List<Contract> listContract){
        //Fetch custom settings for opportunity stages        
        FS_OpportunityStages__c stages=FS_OpportunityStages__c.getValues(oppStageName);    
        string STATUS_Prospecting=stages.FS_Stage_Prospecting__c;                  
        //Set up Opportunity records
        List<Opportunity> opportunities = new List<Opportunity>();            
        for(contract con:listContract){
            For(Integer i=0;i<10;i++){
                opportunities.add(new Opportunity(Name = 'FS Test Opportunity',AccountId = con.AccountId ,stageName = STATUS_Prospecting,CloseDate = Date.today()+30,contractId=con.id,recordtypeId=newRecordTypeId,DealApproved__c=false));   
            }                                 
            opportunities.add(new Opportunity(Name = 'FS Test Opportunity',AccountId = con.AccountId ,StageName = STATUS_Prospecting,CloseDate = Date.today()+30,contractId=con.id,recordtypeId=existingRecordTypeId));
        }
        insert opportunities;
        return opportunities;
    }
    
    //Create account plan test data set up
    Public void setUpAccountPlan(List<Account> accounts){
        //Set up opportunity for Account Planning
        //Set up account plan records
        RecordType AccPlan_rt = [select id,Name from RecordType where SobjectType='FS_Account_Plan__c' and Name='Operator' Limit 1];
        List<FS_Account_Plan__c> accPlanList = new List<FS_Account_Plan__c>();
        for(Account acc:accounts){
            AccPlanList.add(new FS_Account_Plan__c(FS_Customer__c=acc.id,FS_Status__c='Planning',FS_Start_Date__c=date.today(),FS_End_Date__c=date.today(),RecordTypeid=AccPlan_rt.Id));
        }           
        insert AccPlanList;        
        //Set up defined objective
        RecordType Obj_rt = [select id,Name from RecordType where SobjectType='FS_Defined_objective__c' and Name='Operator Objective' Limit 1];
        List<FS_Defined_Objective__c> objList=new List<FS_Defined_Objective__c>(); 
        for(FS_Account_Plan__C AccPlan:AccPlanList){
            for(integer i=0;i<5;i++){
                objList.add(new FS_Defined_Objective__c(FS_Account_Plan__c=AccPlan.id,FS_Customer__c=AccPlan.FS_Customer__c,FS_Status__C='Planning',RecordTypeid=Obj_rt.Id));
            }
        }
        insert objList;
        List<Risk__c> riskList=new List<Risk__c>(); 
        for(FS_Account_Plan__C accPlan:AccPlanList){
            for(FS_Defined_Objective__c obj : objList){
                riskList.add(new Risk__c(Account_Plan__c=accPlan.id,Defined_Objective__c=obj.id,FS_Sub_Sector__c='Test'));  
            }
        }
        Insert riskList;
    }
    
    //Create opportunity for account planning test
    Public list<Opportunity> setUpOppforAccPlan(List<FS_Defined_Objective__c> objList){
        //Fetch custom settings for opportunity stages        
        FS_OpportunityStages__c stages=FS_OpportunityStages__c.getValues(oppStageName);    
        string STATUS_Prospecting=stages.FS_Stage_Prospecting__c;             
        //Set up Opportunity records
        List<Opportunity> opportunities = new List<Opportunity>();
        //Create 10 opportunities for each objective
        for(FS_Defined_Objective__c Obj : Objlist){
            for(integer i=0;i<1;i++){
                opportunities.add(new Opportunity (Name ='FS Account Planning Test Opportunity',Reason__c='Price',FS_ReasonDescription__c='Field Activity',AccountId = Obj.FS_Customer__c,StageName = STATUS_Prospecting,CloseDate = Date.today(),Account_Plan__c=Obj.FS_Account_Plan__c,Defined_Objective__c=obj.id,recordtypeId=newRecordTypeId));
            }
        }
        insert opportunities; 
        return opportunities;
    }
    
    //Create opportunity line item for opportunities
    Public void setUpOpportunityLineItemData(List<Opportunity> opportunities){
        List<Product2> products=new  List<Product2>();
        
        for(Integer i=0;i < 2;i++){
            products.add(new Product2(Name = 'FS Test Product_'+i,COGS__c=(i+1),isActive=true,MarketType__c='BOH MAYO',StartDate__c=date.today(),EndDate__c=date.today()+1,UID_Material_ID__c=string.valueof(i+1),CanUseQuantitySchedule=true));
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
        List<OpportunityLineItem> listOli=new List<OpportunityLineItem>();
        For(Opportunity Opp : opportunities){             
            For(PriceBookEntry Pbe: pricebookentries){
                listOli.add(new OpportunityLineItem(OpportunityId=Opp.Id,PriceBookEntryId=Pbe.Id,Quantity=1200,totalPrice=Pbe.unitPrice,Distributor__c='CA GFS')); 
            }                
        }         
        Insert listOli;        
    }
    
    //Create scheduling for line items
    Public void setUpSchedule(List<OpportunityLineItem> listOli){
        List<OpportunityLineItemSchedule> listScheduletoinsert=new List<OpportunityLineItemSchedule>();
        For(OpportunityLineItem oli : listOli){
            system.assertNotEquals(null, oli.Id);                
            For(Integer i=1;i<=12;i++){
                listScheduletoinsert.add(new OpportunityLineItemSchedule(OpportunityLineItemId=oli.id,quantity=100,scheduledate=Date.newinstance(system.today().year(),i,1),Type='Quantity'));                
            }                
        }            
        try{              
            if(!listScheduletoinsert.isEmpty()){
                Insert listScheduletoinsert;
            }              
        }
        Catch(DmlException e){
            System.debug( 'The following exception has occurred: '+e.getMessage() );
            ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'FS_MonthlyClaimedCasesbatch', 'UpdateOppField', e.getMessage(), e, null, null, null, 0,'Food Solution');
        }     
    }
    
    //Update opportunities to stage 4
    Public List<Opportunity> closeOpportunity(List<Opportunity> oppList){    
    FS_OpportunityStages__c stages=FS_OpportunityStages__c.getValues(oppstageName);   
    string STATUS_COMMITMENT=stages.FS_Stage_Commitment__c;
        List<Opportunity> ListNewOppToBeclosed=new List<Opportunity>();
        For(Opportunity Opp: oppList){                
            Opp.StageName=STATUS_COMMITMENT;
            Opp.DealApproved__c=true;
            ListNewOppToBeclosed.add(Opp);
        }
        Update ListNewOppToBeclosed;
        return ListNewOppToBeclosed;
    }    
}