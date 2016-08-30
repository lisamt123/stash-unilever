/**********************************************************************
Purpose: Test class for OpportunityTrigger.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     13/July/2016     Created
                          
***********************************************************************/
@isTest
public class FS_Account_Planning_Test {
//Set up Test Data for unit test    
     @testSetup static void setupTestData(){
        //String profile_salesrep='Unilever - Salesforce MultiApp Standard';
        String profile='System Administrator';
        String permissionset='FS_Sales_Rep';         
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile];
        //Profile p_rep = [SELECT Id FROM Profile WHERE Name=:profile_salesrep];
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
        psetassignment.AssigneeId = SalesRepUser.Id;
        psetassignment.PermissionSetId = ps.Id;
        insert psetassignment;       
        system.runAs(salesRepUser){
            //Set up Custom settings for Opportunity Trigger
            FSOpportunityTriggerSettings__c oppCustomSettings=new FSOpportunityTriggerSettings__c(name='isEnabled',Enabled__c=true);
            insert OppCustomSettings;
            
            // Set up the Account records
            List<Account> accounts = new List<Account>();
            RecordType acc_rt = [select id,Name from RecordType where SobjectType='Account' and Name='Operator' Limit 1];
            for(Integer i=0;i<5;i++){
               accounts.add(new Account(Name ='FS_Acc_Plan_'+i,recordtypeid=Acc_rt.id));
            }            
             insert accounts;              
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
                ObjList.add(new FS_Defined_Objective__c(FS_Account_Plan__c=AccPlan.id,FS_Customer__c=AccPlan.FS_Customer__c,FS_Status__C='Planning',RecordTypeid=Obj_rt.Id));
            }
            }
            insert ObjList;
            //Set up Opportunity records
            List<Opportunity> opportunities = new List<Opportunity>();
            //Create 10 opportunities for each objective
            for(FS_Defined_Objective__c Obj : Objlist){
                for(integer i=0;i<1;i++){
                opportunities.add(new Opportunity (Name = 'FS Test Opportunity',Reason__c='Price',FS_ReasonDescription__c='Field Activity',AccountId = Obj.FS_Customer__c,StageName = '01 – Universe',CloseDate = Date.today(),Account_Plan__c=Obj.FS_Account_Plan__c,Defined_Objective__c=obj.id));
            }
            }
             insert opportunities;          
            //Set up Product records     
            List<Product2> products=new  List<Product2>();
            for(Integer i=0;i < 2;i++){
                products.add(new Product2(Name = 'FS Test Product_'+i,COGS__c=(i+1),isActive=true,MarketType__c='BOH MAYO',StartDate__c=date.today(),EndDate__c=date.today()+1));
            }
            insert products;
            
            //Fetch standard Price Book     
            Id pricebookId = Test.getStandardPricebookId();
            
            //Set up Price Book Entry records
            List<priceBookEntry> pricebookentries= new List<priceBookEntry>();
            for(Product2 prod : products)
            {
               pricebookentries.add(new priceBookEntry ( pricebook2id = pricebookId,Product2Id = prod.id,  unitPrice = 1000, IsActive = true,UseStandardPrice = false)); 
            }
            insert pricebookentries;     
           }//End of system.runas
     }//End of test data set up
    //Test if roll up sumarry fields are getting updated correctly on Defined Objective and Account plan 
    Static TestMethod Void AccountPlanRollUpFieldsBulkTest(){
      //Fetch Test User Data     
         user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
         system.runAs(SalesRepUser){
            Integer GrossProfit;
            Integer AvgGrossProfit;
            Integer MrktTarget;
            Integer AvgMrktTarget;
            Integer i = 0;
            List<priceBookEntry> pricebookentries2= new List<priceBookEntry>();
            List<opportunity> opportunities2= new List<opportunity>();
            list<OpportunityLineItem> oli=new list<OpportunityLineItem>();            
            pricebookentries2=[select id,unitPrice from pricebookentry where product2.name like 'FS Test Product%'];
            opportunities2=[select id,name,AverageGrossProfit__c,MarketTarget__c,accountid,FS_TotalNumberOfCases__c from opportunity where name='FS Test Opportunity'];
            //Set up Opportunity Line Item
            for (Opportunity opportunity:opportunities2){                
                for (pricebookentry pbookentry : pricebookentries2){
                        oli.add(new OpportunityLineItem(Opportunityid = opportunity.id,PricebookentryId =pbookentry.id,quantity=11,totalPrice=pbookentry.unitPrice,Distributor__c='Reinhart'));
                        i=i+1;
                    }               
                }
             List<Opportunity> Opp_To_Update=new List<Opportunity>();
             i=0;
             for(Opportunity Opp:opportunities2){
                 if(i<40){
                 Opp.StageName='Closed-Won';
                     i++;
                 }
                 if(i>40){
                 Opp.StageName='Closed-Lost';
                     i++;
                 }
                 Opp_To_Update.add(Opp);
             }
             Test.startTest();
            //Cause Opportunity trigger to fire
            Insert oli;
            Update Opp_To_Update;
            Test.stopTest();
            List<Opportunity> OppListAfterTrigger=[select name,amount,Account_Plan__C,Defined_Objective__c,StageName from Opportunity where name='FS Test Opportunity'];
            system.debug(OppListAfterTrigger);
            List<FS_Defined_Objective__c> Objlist=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Amount__c from FS_Defined_Objective__c];
            Map<FS_Defined_Objective__c,List<Opportunity>> ObjOppMap=new Map<FS_Defined_Objective__c,List<Opportunity>>();
            for(FS_Defined_Objective__c obj:Objlist){
                 List<Opportunity> OppList=new List<Opportunity>();
                 for(Opportunity Opp:OppListAfterTrigger){
                     if(Opp.defined_objective__c==obj.id){
                       OppList.add(Opp);  
                     }
                  }
                 ObjOppMap.put(Obj,OppList);
             }             
             for(FS_Defined_Objective__c obj:Objlist){
                List<Opportunity> OppList=new List<Opportunity>();
                Integer Gross_Amount=0;                 
                OppList=ObjOppMap.get(obj);                
                 for(Opportunity Opp : OppList){
                     Gross_Amount=Gross_Amount+Integer.valueOf(Opp.Amount);
                 }
                //Test if roll up sumarry fields are getting updated correctly on Defined Objective
                system.assertEquals(OppList.size(),obj.FS_No_of_Opportunities__c);
                system.assertEquals(Gross_Amount,obj.FS_Opportunity_Amount__c);
             }
            List<FS_Account_Plan__c> AccPlanlist=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Gain__c,FS_Opportunity_Amount__c from FS_Account_Plan__c];
            Map<FS_Account_Plan__c,List<Opportunity>> AccPlanOppMap=new Map<FS_Account_Plan__c,List<Opportunity>>();
            for(FS_Account_Plan__c AccPlan:AccPlanList){
                 List<Opportunity> OppList=new List<Opportunity>();
                 for(Opportunity Opp:OppListAfterTrigger){
                     if(Opp.account_plan__c==AccPlan.id){
                       OppList.add(Opp);  
                     }
                  }
                 AccPlanOppMap.put(AccPlan,OppList);
             }
             for(FS_Account_Plan__c AccPlan:AccPlanList){
                List<Opportunity> OppList=new List<Opportunity>();
                Integer Gained_Amount=0;
                Integer Gross_Amount=0;
                OppList=AccPlanOppMap.get(AccPlan);
                 for(Opportunity Opp : OppList){
                     if(opp.StageName=='Closed Won')
                     Gained_Amount=Gained_Amount+Integer.valueOf(Opp.Amount);
                     if(opp.StageName<>'Closed Lost')
                     Gross_Amount=Gross_Amount+Integer.valueOf(Opp.Amount);
                 }
                //Test if roll up sumarry fields are getting updated correctly on Account plan 
                system.assertEquals(OppList.size(),AccPlan.FS_No_of_Opportunities__c);
                system.assertEquals(Gained_Amount,AccPlan.FS_Opportunity_Gain__c);
                system.assertEquals(Gross_Amount,AccPlan.FS_Opportunity_Amount__c);
              }
    }//End of user context
   }//End of AccountPlanBulkTest
   
    Static TestMethod Void AccountPlanApprovalProcessBulkTest(){            
            //Fetch Test User Data
            Integer i=0;
            List<FS_Account_Plan__c> accPlanList_To_Approve=new List<FS_Account_Plan__c>();
            List<FS_Account_Plan__c> accPlanList_To_Submit=new List<FS_Account_Plan__c>();
            List<FS_Account_Plan__c> accPlanList=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c];
            for(FS_Account_Plan__c accPlan : AccPlanList){                
                    accPlan.FS_Status__c='Approval Requested';                    
                    accPlanList_To_Submit.add(accPlan);                                                 
            }
            Update accPlanList_To_Submit;
            List<FS_Account_Plan__c> accPlanList_After_Approval=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c];
            i=0;
            for(FS_Account_Plan__c accPlan : accPlanList_After_Approval){                
                    accPlan.FS_Status__c='Approved';
                    accPlan.FS_approved__c=true;
                    accPlanList_To_Approve.add(AccPlan);                    
            }            
            //Cause Opportunity trigger to fire
            Test.startTest();
            Update AccPlanList_To_Approve;
            Test.stopTest();            
            List<FS_Defined_Objective__c> Objlist=[select id,FS_Status__c,FS_approved__c,FS_Account_Plan__c from FS_Defined_Objective__c];
            Map<FS_Account_Plan__c,List<FS_Defined_Objective__c>> AccPlanObjMap=new Map<FS_Account_Plan__c,List<FS_Defined_Objective__c>>();
            for(FS_Account_Plan__c Accplan:AccPlanList_To_Approve){
            List<FS_Defined_Objective__c> ObjList2=new List<FS_Defined_Objective__c>();
            for(FS_Defined_Objective__c Obj:ObjList){
            if(Obj.FS_Account_Plan__c==Accplan.id){
            ObjList2.add(Obj);  
            }
            }
            AccPlanObjMap.put(Accplan,ObjList2);
            }             
            for(FS_Account_Plan__c Accplan:AccPlanList_To_Approve){
            List<FS_Defined_Objective__c> ObjList2=new List<FS_Defined_Objective__c>();
            ObjList2=AccPlanObjMap.get(AccPlan);
            for(FS_Defined_Objective__c Obj:ObjList2){
            //Test if we get expected result
            system.assertEquals(Accplan.FS_Status__c, Obj.FS_Status__c);            
            }                
            }    
   }//End of AccountPlanBulkTest
Static TestMethod Void AccountPlanApprovalProcessBulkTestRejection(){            
            //Fetch Test User Data
            Integer i=0;
            List<FS_Account_Plan__c> accPlanList_To_Approve=new List<FS_Account_Plan__c>();
            List<FS_Account_Plan__c> accPlanList_To_Submit=new List<FS_Account_Plan__c>();
            List<FS_Account_Plan__c> accPlanList=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c];
            for(FS_Account_Plan__c accPlan : AccPlanList){                
                    accPlan.FS_Status__c='Approval Requested';                    
                    accPlanList_To_Submit.add(AccPlan);                                                 
            }
            Update accPlanList_To_Submit;
            List<FS_Account_Plan__c> accPlanList_After_Approval=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c];            
            for(FS_Account_Plan__c accPlan : AccPlanList_After_Approval){                
                    accPlan.FS_Status__c='Planning';                    
                    accPlanList_To_Approve.add(AccPlan);                                  
            }            
            //Cause Opportunity trigger to fire
            Test.startTest();
            Update AccPlanList_To_Approve;
            Test.stopTest();            
            List<FS_Defined_Objective__c> objlist=[select id,FS_Status__c,FS_approved__c,FS_Account_Plan__c from FS_Defined_Objective__c];
            Map<FS_Account_Plan__c,List<FS_Defined_Objective__c>> accPlanObjMap=new Map<FS_Account_Plan__c,List<FS_Defined_Objective__c>>();
            for(FS_Account_Plan__c accplan: accPlanList_To_Approve){
            List<FS_Defined_Objective__c> objList2=new List<FS_Defined_Objective__c>();
            for(FS_Defined_Objective__c obj: objList){
            if(obj.FS_Account_Plan__c==accplan.id){
            objList2.add(obj);  
            }
            }
            accPlanObjMap.put(accplan,objList2);
            }             
            for(FS_Account_Plan__c accplan : accPlanList_To_Approve){
            List<FS_Defined_Objective__c> objList2=new List<FS_Defined_Objective__c>();
            objList2=AccPlanObjMap.get(accPlan);
            for(FS_Defined_Objective__c obj : objList2){
            //Test if we get expected result
            system.assertEquals(accplan.FS_Status__c, obj.FS_Status__c);            
            }                
            }    
   }//End of AccountPlanBulkTest
}