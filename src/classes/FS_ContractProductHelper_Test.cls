/**********************************************************************
Purpose: Test class for ContractProduct Trigger.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     22/Aug/2016     Created
                          
***********************************************************************/
@isTest
private class FS_ContractProductHelper_Test {
    Static testMethod void testContractProduct(){
        FS_UtilTestDataSetup testData= new FS_UtilTestDataSetup();
        User testUser = testData.createTestUser();
        
        system.runAs(testUser){
            //Set up custom settings for opportunity stages
            testData.setUpOpportunityStages();
            //Enable for opportunity trigger
            testdata.enableOpportunityTrigger();
            FS_OpportunityStages__c stages=FS_OpportunityStages__c.getValues('FS_Stages');       
            string STATUS_Prospecting=stages.FS_Stage_Prospecting__c;
            string STATUS_COMMITMENT=stages.FS_Stage_Commitment__c;
            string STATUS_WON=stages.FS_Stage_Won__c;
            //Preparing data, so that the Contract Product is created by the opp trigger           
            Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
            Account acc = new Account(Name = 'Bahama', recordtypeid= accRecType, CurrencyIsoCode = 'EUR' );
            INSERT acc;
            
            Contract con = new Contract();
            con.AccountId= acc.Id; 
            con.StartDate= Date.today();
            con.ContractTerm = 12;
            con.Status = 'Draft';
            con.CurrencyIsoCode = 'EUR';
            INSERT con;
            
            Id oppRecType1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NAFS Existing Business').getRecordTypeId();
            Opportunity oppExisting = new Opportunity(Name = 'Existing Opp', recordtypeid=oppRecType1,AccountId = acc.Id,StageName = STATUS_Prospecting,CloseDate = Date.today(), ContractId=con.id);
            INSERT oppExisting;
                        
            //Set up Opportunity records
            Id oppRecType2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NAFS Opportunity MABE').getRecordTypeId();
            List<Opportunity> listOpportunities = new List<Opportunity>();
            for(integer i=0;i<10;i++){
                listOpportunities.add(new Opportunity(Name = 'Opp'+i, recordtypeid=oppRecType2,AccountId = acc.Id,StageName = STATUS_Prospecting,CloseDate = Date.today(), ContractId=con.id));
            }
            INSERT listOpportunities;
            
            //Set up Product and pricebook
            Product2 prod = new Product2(Name = 'Test Prod',isActive=true,MarketType__c='BOH MAYO',StartDate__c=date.today(),EndDate__c=date.today()+1,CanUseQuantitySchedule=true,UID_Material_ID__c='123test');
            Insert Prod;
            Id pricebookId = Test.getStandardPricebookId();
            PriceBookEntry pbe = new priceBookEntry ( pricebook2id = pricebookId,Product2Id = prod.id,  unitPrice = 1000, IsActive = true,UseStandardPrice = false); 
            insert pbe;
            
            //Set up Opportunity Product
            List<OpportunityLineItem> listOLIs = new List<OpportunityLineItem>();
            For(Opportunity oppFirst: listOpportunities){
                listOLIs.add(new OpportunityLineItem(OpportunityId = oppFirst.Id, Quantity = 500, PricebookEntryId = pbe.Id, TotalPrice = 3946725));
            }    
            INSERT listOLIs;
            
            //Set up Quantity Schefuling
            //testData.setUpSchedule(listOLIs); 
            List<OpportunityLineItem> olilist=new List<OpportunityLineItem>();
            olilist=[select id from opportunitylineitem limit 1];
            testData.setUpSchedule(olilist); 
                       
            For(Opportunity oppSecond: listOpportunities){
                oppSecond.DealApproved__c = true;
                oppSecond.AgreementDate__c = date.today();
                oppSecond.StageName = STATUS_COMMITMENT;
            }    
            UPDATE listOpportunities;
            
            For(Opportunity oppThird: listOpportunities){
                oppThird.StageName = STATUS_WON;
            }
            Test.startTest();
            
            UPDATE listOpportunities;
            
            //Check if 'Existing' opp is updated          
            List<OpportunityLineItem> oliListCreated=[select id from OpportunityLineItem where opportunityid=:oppExisting.id];
            system.assertEquals(true,!oliListCreated.isEmpty());
            
            //Check if Contract Product is created by Opp trigger
            List<contract_product__c> listConProduct=[select id from contract_product__C limit 1];
            system.assertEquals(true,!listConProduct.isEmpty());
            
            //Check if Monthly Claimed Case is created by Contract Product trigger
            List<FS_Monthly_Claimed_Cases__c> listMCC = [SELECT Id from FS_Monthly_Claimed_Cases__c limit 1];            
            system.assertEquals(true,!listMCC.isEmpty());
            
            //Prearing data, so that the Contract Product is updated by the opp trigger
            Opportunity opp = new Opportunity();
            opp.Name = 'Test'; 
            opp.recordtypeid=oppRecType2;
            opp.AccountId = acc.Id;
            opp.StageName = STATUS_Prospecting;
            opp.CloseDate = Date.today();
            opp.ContractId=con.Id;
            
            Insert opp;
            
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = opp.Id;
            oli.Quantity = 500;
            oli.PricebookEntryId = pbe.Id;
            oli.TotalPrice = 3946725;
            
            Insert oli;
            listOLIs=new List<OpportunityLineItem>();
            listOLIs.add(oli);
            
            testData.setUpSchedule(listOLIs);            
            opp.DealApproved__c = true;
            opp.AgreementDate__c = date.today();
            opp.StageName = STATUS_COMMITMENT;
            update opp;
            opp.StageName = STATUS_WON;
            update opp;
             
            Test.StopTest();       
        }        
    }
}