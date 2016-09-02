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
        system.debug(testUser.ManagerId);
        system.runAs(testUser){
            List<Account> accounts = testData.setUpAccountData();            
            testData.setUpAccountPlan(accounts);
            List<FS_Defined_Objective__c> objList=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Amount__c,FS_Customer__c,FS_Account_Plan__c from FS_Defined_Objective__c limit 100];
            List<Opportunity> opportunities=testData.setUpOppforAccPlan(objList);
            List<OpportunityLineItem> listOli=testData.setUpOpportunityLineItemData(opportunities);    
        }       
    }//End of test data set up
    //Test if roll up sumarry fields are getting updated correctly on Defined Objective and Account plan 
    Static TestMethod Void AccountPlanRollUpFieldsBulkTest(){
        //Fetch Test User Data     
        user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(SalesRepUser){            
            Integer i = 0;
            List<priceBookEntry> pricebookentries2= new List<priceBookEntry>();
            List<opportunity> opportunities2= new List<opportunity>();
            list<OpportunityLineItem> oli=new list<OpportunityLineItem>();            
            pricebookentries2=[select id,unitPrice from pricebookentry where product2.name like 'FS Test Product%'];
            opportunities2=[select id,name,AverageGrossProfit__c,MarketTarget__c,accountid,FS_TotalNumberOfCases__c from opportunity where name='FS Account Planning Test Opportunity'];
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
                else {
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
            List<Opportunity> OppListAfterTrigger=[select name,amount,Account_Plan__C,Defined_Objective__c,StageName from Opportunity where name='FS Account Planning Test Opportunity'];
            system.debug(OppListAfterTrigger);
            List<FS_Defined_Objective__c> Objlist=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Amount__c from FS_Defined_Objective__c limit 49999];
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
            List<FS_Account_Plan__c> AccPlanlist=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Gain__c,FS_Opportunity_Amount__c from FS_Account_Plan__c limit 49999];
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
            for(FS_Account_Plan__c accPlan:accPlanList){
                List<Opportunity> oppList=new List<Opportunity>();
                Integer gained_Amount=0;
                Integer gross_Amount=0;
                oppList=accPlanOppMap.get(AccPlan);
                for(Opportunity opp : oppList){
                    if(opp.StageName=='Closed Won'){
                        Gained_Amount=Gained_Amount+Integer.valueOf(Opp.Amount);
                    }
                    else if(opp.StageName<>'Closed Lost'){
                        Gross_Amount=Gross_Amount+Integer.valueOf(Opp.Amount);   
                    }                     
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
        //Integer i=0;
        List<FS_Account_Plan__c> accPlanList_To_Approve=new List<FS_Account_Plan__c>();
        List<FS_Account_Plan__c> accPlanList_To_Submit=new List<FS_Account_Plan__c>();
        List<FS_Account_Plan__c> accPlanList=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c];
        for(FS_Account_Plan__c accPlan : AccPlanList){                
            accPlan.FS_Status__c='Approval Requested';                    
            accPlanList_To_Submit.add(accPlan);                                                 
        }
        Update accPlanList_To_Submit;
        List<FS_Account_Plan__c> accPlanList_After_Approval=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c limit 49999];
        //i=0;
        for(FS_Account_Plan__c accPlan : accPlanList_After_Approval){                
            accPlan.FS_Status__c='Approved';
            accPlan.FS_approved__c=true;
            accPlanList_To_Approve.add(AccPlan);                    
        }            
        //Cause Opportunity trigger to fire
        Test.startTest();
        Update AccPlanList_To_Approve;
        Test.stopTest();            
        List<FS_Defined_Objective__c> Objlist=[select id,FS_Status__c,FS_approved__c,FS_Account_Plan__c from FS_Defined_Objective__c limit 49999];
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