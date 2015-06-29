/*************************************************************************************************************************
Class Name      :       uw_BET_autocompletecontroller_TEST
Class Desc.     :      Test class for controller class autocompletecontroller, this controller is used in a component which 
                        gives autosuggestion for brand and bet         
Author          :       Accenture UK

Change History
****************Date          Author       version             Description                       Requested By           Tag
--------------------------------------------------------------------------------------------------------------------------
Jan-2014         Accenture UK  0.01            Initial build of class                                              Unilever                                           
***************************************************************************************************************************/

@isTest(SeeAllData=false)
public with sharing class uw_BET_autocompletecontroller_TEST
{
static testMethod void autocomplete()
{
list<sobject> returnlist = new list<sobject>();
string obj = 'uw_BET__c';
string addFields ='Lastmodifiedby';
string qry ='Test';
string profilename = 'System Administrator';
//Call the global remote action method by passing object as bet
//this action method dynamically forms a soql and return the list of records.Since no testdata has been created
//no results will be returned
returnlist = autoCompleteController.findSObjects(obj, qry, addFields, profilename);

//create test data and call the method again
//Create brandcentre
        uw_Brand__c brandcentre = new uw_Brand__c(name = 'testbrandcentre');
         insert brandcentre;
         /*uw_Inoplan_Project__c projObj = new uw_Inoplan_Project__c();
         projObj.Name = 'Alok1';
         insert projObj;
         system.debug('&&&&&&&'+projObj.name);*/
        //Create 50 bet records for so that owner is running user                
          list <uw_bet__c> betlists = new list <uw_bet__c>();
          for(integer i = 0;i<10;i++)
          {
         uw_Inoplan_Project__c projObj = new uw_Inoplan_Project__c();
         projObj.Name = 'Alok1'+i;
         insert projObj;
         system.debug('&&&&&&&'+projObj.name);
             uw_BET__c bet = new  uw_BET__c ( Name = 'Testtoolkit'+i,uw_Brand__c = brandcentre.id, Inoplan_Project__c = projObj.id, Product_Category_Sub_Division__c ='Cross Category',Status__c = 'First release',Market_Clusters__c = 'Global');
            
            betlists.add(bet);
          }
                 
          insert betlists;

returnlist = autoCompleteController.findSObjects(obj,qry, '', '');
System.assertNotEquals(0,returnlist.size());

}//End of method
}//End of class