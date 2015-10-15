/*************************************************************************************************************************
Class Name      :  uw_bet_update_totalnumberof_betmembers_TEST
Class Desc.     :  Test class for class uw_bet_update_totalnumberof_betmembers.This class handles the logic to update 
                   the total number of bet members( on brandexperience records
                   when someone joins/leaves the bet                  
Author          :       Accenture UK

Change History
****************Date          Author       version             Description                       Requested By           Tag
----------------------------------------------------------------------------------------------------------------------------
Dec-2013         Accenture UK  0.01            Initial build of class for BET 2.0                Unilever                                           
***************************************************************************************************************************/

@istest
public with sharing class uw_bet_update_totalnoof_betmembers_TEST{

static testMethod void recalculatemembers()
{
//Create brandcentre
        uw_Brand__c brandcentre = new uw_Brand__c(name = 'testbrandcentre');
         insert brandcentre;

//Create 5 bet records for so that owner is running user                
          list <uw_bet__c> betlists = new list <uw_bet__c>();
          for(integer i = 0;i<5;i++)
          {
          
            uw_Inoplan_Project__c projObj =  uw_UnitTestDataFactory.createInoplan();
            insert projObj;
            uw_BET__c bet = new  uw_BET__c ( Name = 'BETTesTkit'+i,uw_Brand__c = brandcentre.id,  Inoplan_Project__c = projObj.id, Product_Category_Sub_Division__c ='Cross Category',Status__c = 'First release',Market_Clusters__c = 'Global');
             
            betlists.add(bet);
          }                 
          insert betlists;
     

}



}