/**********************************************************************
Purpose: Test class for OpportunityTrigger.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     13/July/2016     Created

***********************************************************************/
@isTest
public class FS_AccountPlanningTest {    
    //Set up Test Data for unit test    
    @testSetup static void setupTestData(){
        FS_UtilTestDataSetup testData=new FS_UtilTestDataSetup();
        User testUser=testData.createTestUser();        
        system.runAs(testUser){
            //set up custom setting for opportunity stages
            testData.setUpOpportunityStages();
            testdata.enableOpportunityTrigger();
            List<Account> accounts = testData.setUpAccountData();            
            testData.setUpAccountPlan(accounts);
            List<FS_Defined_Objective__c> objList=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Amount__c,FS_Customer__c,FS_Account_Plan__c from FS_Defined_Objective__c limit 100];
            List<Opportunity> opportunities=testData.setUpOppforAccPlan(objList);
            testData.setUpOpportunityLineItemData(opportunities);
            opportunities=testdata.closeOpportunity(opportunities);
        }       
    }//End of test data set up
    
    Static TestMethod Void testRollUpAccPlan(){
        //Fetch data from custom settings for opportuntiy stages
        FS_OpportunityStages__c stages=FS_OpportunityStages__c.getinstance('FS_Stages');
        string STATUS_WON=stages.FS_Stage_Won__c; 
        user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(SalesRepUser){ 
            FS_Account_Plan__c accPlan=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Gain__c,FS_Opportunity_Amount__c from FS_Account_Plan__c limit 1];        
            List<opportunity> opportunities= new List<opportunity>();        
            opportunities=[select id,name,accountid,FS_TotalNumberOfCases__c from opportunity where name='FS Account Planning Test Opportunity' and account_plan__c=:accPlan.Id and stagename='04 - Verbal Commitment'];       
            List<Opportunity> opp_To_Update=new List<Opportunity>();                 
            Test.startTest();           
            for(Opportunity oppUpd : opportunities){
                oppUpd.AgreementDate__c=system.today();
                oppUpd.StageName = STATUS_WON;              
                opp_To_Update.add(oppUpd);
            }            
            Update Opp_To_Update;            
            Test.stopTest();       
            Integer gained_Amount=0;
            opportunities=[select id,name,accountid,stagename,amount from opportunity where name='FS Account Planning Test Opportunity' and account_plan__c=:accPlan.Id];
            for(Opportunity oppWon : opportunities){                
                if(oppWon.StageName==STATUS_WON){
                    gained_Amount=gained_Amount+Integer.valueOf(oppWon.Amount);
                }                 
            }
            FS_Account_Plan__c accPlanUpd=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Gain__c,FS_Opportunity_Amount__c from FS_Account_Plan__c where id=:accPlan.Id];
            //Test if roll up sumarry fields are getting updated correctly on Account plan 
            system.assertEquals(opportunities.size(),accPlanUpd.FS_No_of_Opportunities__c);
            system.assertEquals(gained_Amount,accPlanUpd.FS_Opportunity_Gain__c);            
        }
    }
    
    Static TestMethod Void testRollUpDefinedObjective(){
        //Fetch data from custom settings for opportuntiy stages
        FS_OpportunityStages__c stages=FS_OpportunityStages__c.getinstance('FS_Stages');
        string STATUS_WON=stages.FS_Stage_Won__c; 
        user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(SalesRepUser){          
            FS_Account_Plan__c accPlan=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Gain__c,FS_Opportunity_Amount__c from FS_Account_Plan__c limit 1];            
            List<opportunity> opportunities= new List<opportunity>();       
            opportunities=[select id,name,FS_AverageGrossProfit__c,FS_MarketTarget__c,accountid,FS_TotalNumberOfCases__c from opportunity where name='FS Account Planning Test Opportunity' and account_plan__c=:accPlan.Id];          
            List<Opportunity> opp_To_Update=new List<Opportunity>();           
            Test.startTest();
            //Cause Opportunity trigger to fire            
            for(Opportunity opp:opportunities){
                opp.AgreementDate__c=system.today();
                opp.StageName = STATUS_WON;              
                opp_To_Update.add(Opp);
            }
            Update Opp_To_Update;
            Test.stopTest();
            FS_Defined_Objective__c obj=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Amount__c 
                                         from FS_Defined_Objective__c where FS_account_plan__c=:accPlan.Id limit 1];
            Integer gross_Amount=0;
            opportunities=[select id,amount from opportunity where name='FS Account Planning Test Opportunity' and account_plan__c=:accPlan.Id and defined_objective__c=:obj.Id];
            for(Opportunity opp : opportunities){                
                gross_Amount=gross_Amount+Integer.valueOf(opp.amount);                                
            }            
            //Test if roll up sumarry fields are getting updated correctly on Defined Objective
            system.assertEquals(opportunities.size(),obj.FS_No_of_Opportunities__c);
            system.assertEquals(gross_Amount,obj.FS_Opportunity_Amount__c);         
        }           
    }        
    Static TestMethod Void AccountPlanApprovalProcessBulkTest(){            
        //Fetch Test User Data
        user salesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(salesRepUser){       
        List<FS_Account_Plan__c> accPlanList_To_Submit=new List<FS_Account_Plan__c>();
        List<FS_Account_Plan__c> accPlanList=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c limit 10];
        for(FS_Account_Plan__c accPlan : accPlanList){                
            accPlan.FS_Status__c='Approval Requested';                    
            accPlanList_To_Submit.add(accPlan);                                                 
        }
        Update accPlanList_To_Submit;
        }
        List<FS_Account_Plan__c> accPlanList_To_Approve=new List<FS_Account_Plan__c>();
        List<FS_Account_Plan__c> accPlanList_After_Approval=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c limit 49999];        
        for(FS_Account_Plan__c accPlan : accPlanList_After_Approval){                
            accPlan.FS_Status__c='Approved';
            accPlan.FS_approved__c=true;
            accPlanList_To_Approve.add(AccPlan);                    
        }            
        //Cause Opportunity trigger to fire
        Test.startTest();
        Update accPlanList_To_Approve;
        Test.stopTest();
        List<FS_Defined_Objective__c> objList2=new List<FS_Defined_Objective__c>();
        List<FS_Defined_Objective__c> objlist=[select id,FS_Status__c,FS_approved__c,FS_Account_Plan__c from FS_Defined_Objective__c limit 49999];
        Map<FS_Account_Plan__c,List<FS_Defined_Objective__c>> accPlanObjMap=new Map<FS_Account_Plan__c,List<FS_Defined_Objective__c>>();
        for(FS_Account_Plan__c accplan:accPlanList_To_Approve){
            ObjList2=new List<FS_Defined_Objective__c>();
            for(FS_Defined_Objective__c obj:objList){
                if(obj.FS_Account_Plan__c==accplan.id){
                    objList2.add(obj);  
                }
            }
            AccPlanObjMap.put(accplan,objList2);
        }             
        for(FS_Account_Plan__c accplan:accPlanList_To_Approve){
            objList2=new List<FS_Defined_Objective__c>();
            objList2=accPlanObjMap.get(accPlan);
            for(FS_Defined_Objective__c obj:objList2){
                //Test if we get expected result
                System.debug('accplan.FS_Status__c'+accplan.FS_Status__c);
                System.debug('obj.FS_Status__c'+obj.FS_Status__c);
                system.assertEquals(accplan.FS_Status__c, obj.FS_Status__c);            
            }                
        }    
    }//End of AccountPlanBulkTest
    Static TestMethod Void AccountPlanApprovalProcessBulkTestRejection(){
        user salesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(salesRepUser){
        //Fetch Test User Data       
        List<FS_Account_Plan__c> accPlanList_To_Submit=new List<FS_Account_Plan__c>();
        List<FS_Account_Plan__c> accPlanList=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c limit 100];
        for(FS_Account_Plan__c accPlan : AccPlanList){                
            accPlan.FS_Status__c='Approval Requested';                    
            accPlanList_To_Submit.add(AccPlan);                                                 
        }
        Update accPlanList_To_Submit;
        }
        List<FS_Account_Plan__c> accPlanList_To_Approve=new List<FS_Account_Plan__c>();
        List<FS_Account_Plan__c> accPlanList_After_Approval=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c limit 100];            
        for(FS_Account_Plan__c accPlan : accPlanList_After_Approval){                
            accPlan.FS_Status__c='Planning';                    
            accPlanList_To_Approve.add(AccPlan);                                  
        }            
        //Cause Opportunity trigger to fire
        Test.startTest();
        Update accPlanList_To_Approve;
        Test.stopTest();            
        List<FS_Defined_Objective__c> objlist=[select id,FS_Status__c,FS_approved__c,FS_Account_Plan__c from FS_Defined_Objective__c where FS_account_plan__c in :accPlanList_After_Approval];
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