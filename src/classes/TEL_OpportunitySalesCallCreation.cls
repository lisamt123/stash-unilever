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
    private static String 				oppRecordType; 	// Store the telesales team opportunity record type. 
    private static String 				oppName;		// Set the opportunity name.
    private static List<Opportunity> 	lstOpportunity; // List of opportunity to be created.
    private static List<Account>        lstAccount;     // List of Accounts from the same country
    
    // Instance Class
    private static final TEL_OpportunitySalesCallCreation instance = new TEL_OpportunitySalesCallCreation();
    
    // Construtor 
    public TEL_OpportunitySalesCallCreation() {
        lstAccount = [SELECT Id FROM Account WHERE Sales_ORG__c =: Label.TEL_Sales_ORG LIMIT 10000];
        createOpportunities();
    }
    
    // Get Instance method to return a static final instance of this object. 
    public static TEL_OpportunitySalesCallCreation getInstance(){
        return instance;
    }
    
    static 
    {
        oppRecordType	= 	ICB_RecordTypeMemory.getRecType(Label.TEL_Opportunity, Label.TEL_Telesales_Record_Type);
        oppName 		= 	Label.TEL_Sales_Call_Opp;
        lstOpportunity	= 	new List<Opportunity>();
    }
    
    private void createOpportunities() {
        if(!lstAccount.isEmpty()) {
            for(Account acc : lstAccount) {
                lstOpportunity.add(
                    new Opportunity(Name = oppName, 
                                    RecordTypeId = oppRecordType, 
                                    AccountId = acc.Id,
                                    CloseDate = Date.today().addDays(90))
                );    
            }
            System.Database.insert(lstOpportunity); 
        }
    }
    
}