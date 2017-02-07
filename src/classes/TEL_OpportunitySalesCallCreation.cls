/**********************************************************************
Name: TEL_OpportunitySalesCallCreation
Copyright © 2016 Unilever

Purpose: Class to create the opportunity call list for telesales team.

History 

VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	RONALDO GARCIA      11/12/2016  INITIAL DEVELOPMENT.
***********************************************************************/
public with sharing class TEL_OpportunitySalesCallCreation {
    
    // Variables 
    @testVisible private static String oppRecordType; 	// Store the telesales team opportunity record type. 
    @testVisible private static String oppName;		// Set the opportunity name.
    @testVisible private static String oppStageName;	// Set the opportunity stageName.
    @testVisible private static List<Opportunity> lstOpportunity; // List of opportunity to be created.
    @testVisible private static List<Account> lstAccount;     // List of Accounts from the same country
    
    // Instance Class
    private static final TEL_OpportunitySalesCallCreation instance = new TEL_OpportunitySalesCallCreation();
    
    // Get Instance method to return a static final instance of this object. 
    public static TEL_OpportunitySalesCallCreation getInstance(){
        return instance;
    }
    
    static 
    {
        lstAccount 		=   [SELECT Id FROM Account WHERE Sales_ORG__c =: Label.TEL_Sales_ORG LIMIT 10000];
        oppRecordType	= 	ICB_RecordTypeMemory.getRecType(Label.TEL_Opportunity, Label.TEL_Telesales_Record_Type);
        oppName 		= 	Label.TEL_Sales_Call_Opp;
        oppStageName	= 	Label.TEL_OppStagePendingCall;
        lstOpportunity	= 	new List<Opportunity>();
    }
    
    public void createOpportunities() {
        if(!lstAccount.isEmpty()) {
            for(Account acc : lstAccount) {
                lstOpportunity.add(
                    new Opportunity(Name = oppName, 
                                    RecordTypeId = oppRecordType, 
                                    AccountId = acc.Id,
                                    StageName = oppStageName,
                                    CloseDate = Date.today().addDays(90))
                );    
            }
            System.Database.insert(lstOpportunity); 
        }
    }
    
}