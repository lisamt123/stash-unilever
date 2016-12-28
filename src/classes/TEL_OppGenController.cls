/**********************************************************************
Name: TEL_OppGenController
Copyright © 2016 Unilever

Purpose:
Handles opportunity generation and association of account and product
campaigns. 

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Ronaldo Garcia  22/11/2016  Class creation  
***********************************************************************/
public with sharing class TEL_OppGenController {
    
    // Static Resources 
    private static Id 		CONST_OPP_RECORD_TYPE; 		// Store the opportunity Telesales recordtype id.
    private static Id 		CONST_ACC_CMPG_RECORD_TYPE; // Store the account campaign recordtype id.
    private static Id 		CONST_PRICE_RECORD_TYPE; 	// Store the price book entry recordtype id for telesales price. 
    private static Id 		CONST_STD_ACC_RECORD_TYPE;		// Store the standard account record type. 
    private static Integer 	nextSchedule 	= 0; 		// Store the number of days used to shedule the next opp. 
    private static Integer 	scheduledDay 	= 0; 		// Store the number of weekday scheduled.
    private static Integer 	weeklyDay 		= 0; 		// Store the number of weekday.
    private static Integer 	daysToSchedule 	= 0; 		// Store the number of days to be considered during the schedule process.
    private static Integer 	frequencySet	= 0; 		// Store the number of time which the record must be created.
    
    static{
    	CONST_OPP_RECORD_TYPE 		= ICB_RecordTypeMemory.getRecType(Label.TEL_Opportunity, Label.TEL_Telesales_Record_Type);
        CONST_ACC_CMPG_RECORD_TYPE 	= ICB_RecordTypeMemory.getRecType('TEL_Campaign_Accounts__c', 'TEL_Campaign_Account');
        CONST_STD_ACC_RECORD_TYPE	= ICB_RecordTypeMemory.getRecType(Label.TEL_Account, Label.TEL_Account_Record_Type);
        CONST_PRICE_RECORD_TYPE		= [Select Name From Pricebook2 Where Name =: Label.TEL_Telesales_UK_Price_Book].Id;
    }
    
    // Retrieve segment to be used as a search param account. 
    @AuraEnabled
    public static List<String> searchSubSegment(){
        System.debug('Entering <searchSubSegment>');
        Map<String, TEL_Sub_Segment__c> 	mapSubSegment	= TEL_Sub_Segment__c.getAll();
        List<String> 						lstSubSegment	= new List<String>();
        lstSubSegment.addAll(mapSubSegment.keySet());
        lstSubSegment.sort();
        System.debug('Exit <searchSubSegment>');
        return lstSubSegment;
    }
    
    // Retrieve segment to be used as a search param account. 
    @AuraEnabled
    public static List<String> searchSegment(){
        System.debug('Entering <searchSegment>');
        Map<String, TEL_Segment__c> 	mapSegment	= TEL_Segment__c.getAll();
        List<String> 					lstSegment	= new List<String>();
        lstSegment.addAll(mapSegment.keySet());
        lstSegment.sort();
        System.debug('Exit <searchSegment>');
        return lstSegment;
    }    
    
    // Retrieve the search param to product family field. 
    @AuraEnabled
    public static List<String> returnFamily(){
        System.debug('Entering <returnFamily>');
        Map<String, TEL_Product_Family__c> 	mapProductCode		= TEL_Product_Family__c.getAll();
        List<String> 						lstProductFamily 	= new List<String>();
        lstProductFamily.addAll(mapProductCode.keySet());
        lstProductFamily.sort();
        System.debug('Valor do lstProductFamily: '+lstProductFamily);
        return lstProductFamily;
    }
    
    // Retrieve the search param to OTM field. 
    @AuraEnabled
    public static List<String> searchOTM(){
        System.debug('Entering <searchOTM>');
        Map<String, TEL_OTM__c>	mapOTM 	= TEL_OTM__c.getAll();
        List<String>			lstOTM 	= new List<String>();
        lstOTM.addAll(mapOTM.keySet());
        lstOTM.sort();
        System.debug('Exit <searchOTM>');
        return lstOTM;
    }
    
    // Retrieve the param to set the frequency of generation opportunity. 
    @AuraEnabled
    public static List<String> frequencyOppGeneration(){
        System.debug('Entering <frequencyOppGeneration>');
        
        Map<String, TEL_Frequency__c> 	mapFrequency = TEL_Frequency__c.getAll();
        List<String> 					lstFrequency = new List<String>();
        lstFrequency.addAll(mapFrequency.keySet());
        System.debug('Valor do frequencyOppGeneration: '+lstFrequency);
        return lstFrequency;
    }
    
    // Retrieve the accounts based on search param. 
  	@AuraEnabled
    public static List<TEL_TelesalesWrapper.DisplayAccounts> searchAccounts(String type, String segment, String subSegment){
        System.debug('Entering <searchAccounts>');
        
        System.debug('Valor antes de entrar no if type: '+type);
        System.debug('Valor antes de entrar no if segment: '+segment);
        System.debug('Valor antes de entrar no if subSegment: '+subSegment);
        System.debug('Valor do record type account standard: '+CONST_STD_ACC_RECORD_TYPE);
        
        List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        
        String accQuery = 'Select Name, TEL_OTM__c, Segment__c, SubSegment__c From Account';
        
        if(type != 'None' && segment == 'None' && subSegment == 'None'){
            System.debug('Valor 01');
        	accQuery += ' Where TEL_OTM__c = \''+type+'\' '+'And RecordTypeId = \''+CONST_STD_ACC_RECORD_TYPE+'\'';
        }
        if(type == 'None' && segment != 'None' && subSegment == 'None'){
            System.debug('Valor 02');
        	accQuery += ' Where Segment__c = \''+segment+'\' '+'And RecordTypeId = \''+CONST_STD_ACC_RECORD_TYPE+'\'';
        }
        if(type == 'None' && segment == 'None' && subSegment != 'None'){
            System.debug('Valor 03');
        	accQuery += ' Where SubSegment__c = \''+subSegment+'\' '+'And RecordTypeId = \''+CONST_STD_ACC_RECORD_TYPE+'\'';
        }
        if(type != 'None' && segment != 'None' && subSegment == 'None'){
            System.debug('Valor 04');
        	accQuery += ' Where TEL_OTM__c = \''+type+'\' '+'And Segment__c = \''+segment+'\' '+'And RecordTypeId = \''+CONST_STD_ACC_RECORD_TYPE+'\'';
        }
        if(type != 'None' && segment != 'None' && subSegment != 'None'){
            System.debug('Valor 05');
        	accQuery += ' Where TEL_OTM__c = \''+type+'\' '+'And Segment__c = \''+segment+'\' '+'And SubSegment__c = \''+subSegment+'\' '+'And RecordTypeId = \''+CONST_STD_ACC_RECORD_TYPE+'\'';
        }
        if(type == 'None' && segment != 'None' && subSegment != 'None'){
            System.debug('Valor 06');
        	accQuery += ' Where Segment__c = \''+segment+'\' '+'And SubSegment__c = \''+subSegment+'\' '+'And RecordTypeId = \''+CONST_STD_ACC_RECORD_TYPE+'\'';
        }
        if(type != 'None' && segment == 'None' && subSegment != 'None'){
            System.debug('Valor 07');
        	accQuery += ' Where TEL_OTM__c = \''+type+'\' '+'And SubSegment__c = \''+subSegment+'\' '+'And RecordTypeId = \''+CONST_STD_ACC_RECORD_TYPE+'\'';
        }
        
		System.debug('Valor da query string: '+accQuery);
        List<Account> lstAccRetrieved = Database.query(accQuery); 
        lstAccRetrieved.sort();
        
        List<Id> accRetrieved = new List<Id>();
        
        for(Account a : lstAccRetrieved){
			accRetrieved.add(a.Id);            
        }
        
        // Retrieve related account campaign to validate if the account is already use in different campaings.
        List<TEL_Campaign_Accounts__c> lstAccCgn = [Select TEL_Account__c, TEL_Campaign__r.Name From TEL_Campaign_Accounts__c Where TEL_Account__c =: accRetrieved];
       
        // Store the campaigns names by account to indicate the associated campaigns in the return list. 
		List<TEL_TelesalesWrapper.DisplayAccounts> lstRelatedAccCampaign = new List<TEL_TelesalesWrapper.DisplayAccounts>();        
        
        for(TEL_Campaign_Accounts__c ac : lstAccCgn){
            TEL_TelesalesWrapper.DisplayAccounts acr = new TEL_TelesalesWrapper.DisplayAccounts();
            acr.accountId						 = ac.TEL_Account__c;
            acr.accountCampaign					 = ac.TEL_Campaign__r.Name;
            lstRelatedAccCampaign.add(acr);
        }
        System.debug('Valor do lstRelatedAccCampaign: '+lstRelatedAccCampaign);
        System.debug('Valor da lista: '+lstAccRetrieved);
        // Check if the account list return value. 
        if(lstAccRetrieved != null && lstAccRetrieved.size() > 0){
            for(Account acc : lstAccRetrieved){
                TEL_TelesalesWrapper.DisplayAccounts accDisplayed = new TEL_TelesalesWrapper.DisplayAccounts();
                accDisplayed.accountId 			= acc.Id;
                accDisplayed.accountName		= acc.Name;
                accDisplayed.accType			= acc.TEL_OTM__c;
                accDisplayed.accSegment			= acc.Segment__c;
                accDisplayed.accSubSegment		= acc.SubSegment__c;
                for(TEL_TelesalesWrapper.DisplayAccounts ca : lstRelatedAccCampaign){
                    if(acc.Id == ca.accountId){
                        System.debug('Valor da conta campanha: '+ca.accountCampaign);
                        accDisplayed.accountCampaign	=+ ca.accountCampaign + '\n' ;  
                        accDisplayed.hasAccCampaign		= true;
                    }
                }
                lstAccounts.add(accDisplayed);
            }
        }
        System.debug('Valor da lstAccounts: '+lstAccounts);
        System.debug('Exit <searchAccounts>');
        return lstAccounts;
    }
    
    // Create opportunities based on account selected. 
    @AuraEnabled
    public static void createOpp(String accSelected, String monday, String tuesday, String wednesday, String thursday, String friday, String frequency, String oppGenType, Id campaignId){
        
        System.debug('Valor do campaignId: '+campaignId);
        DateTime	currentDate 	= System.now();
        Integer 	currentDay 		= currentDate.day();
        String 	 	currentWeekDay 	= currentDate.format('EEEE');	 
        
        // Set a index for the weekday, scheduled day and frequency. 
        if(currentWeekDay 	== 'Monday')		{weeklyDay 		= 1;}
        if(currentWeekDay 	== 'Tuesday')		{weeklyDay 		= 2;}
        if(currentWeekDay 	== 'Wednesday')		{weeklyDay 		= 3;}
        if(currentWeekDay 	== 'Thursday')		{weeklyDay 		= 4;}
        if(currentWeekDay 	== 'Friday')		{weeklyDay 		= 5;} 
        if(frequency 	  	== 'One Week')		{frequencySet 	= 1; daysToSchedule = 7;}
        if(frequency 	  	== 'Two Weeks')		{frequencySet 	= 2; daysToSchedule = 7;}
        if(frequency 	  	== 'Three Weeks')	{frequencySet 	= 3; daysToSchedule = 7;}
        if(frequency 	  	== 'Four Weeks')	{frequencySet 	= 4; daysToSchedule = 7;}
        if(frequency 	  	== 'Biweekly')		{frequencySet 	= 1; daysToSchedule = 15;}
        if(frequency 	  	== 'Monthly')		{frequencySet 	= 1; daysToSchedule = 30;}
        
        // Verify if there are account selected. 
        if(!string.isBlank(accSelected)){
            
            // Deserialize the accounts retrieved.
            List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts = (List<TEL_TelesalesWrapper.DisplayAccounts>)System.JSON.deserialize(accSelected, List<TEL_TelesalesWrapper.DisplayAccounts>.class);
            // Store the oppportunities to be created. 
            List<Opportunity>	lstOpp = new List<Opportunity>();
            
            // Check which days of week was selected to create the opp for each day. 
            if(monday == 'monday'){
                scheduledDay 	= 1;
                lstOpp.addAll(createOpp(lstAccounts, oppGenType, campaignId));
            }
            if(tuesday == 'tuesday'){
                scheduledDay 	= 2;
                lstOpp.addAll(createOpp(lstAccounts, oppGenType, campaignId));
            }
            if(wednesday == 'wednesday'){
                scheduledDay 	= 3;
                lstOpp.addAll(createOpp(lstAccounts, oppGenType, campaignId));
            }
            if(thursday == 'thursday'){
                scheduledDay 	= 4;
                lstOpp.addAll(createOpp(lstAccounts, oppGenType, campaignId));
            }
            if(friday == 'friday'){
                scheduledDay 	= 5;
                lstOpp.addAll(createOpp(lstAccounts, oppGenType, campaignId));
            }
            System.debug('Valor da lista antes do upsert: '+lstOpp);
            database.upsert(lstOpp);
        }
    }
    
    // Make the link between the campaign and related accounts. 
    @AuraEnabled
    public static void createAccCampaign(String accSelected, Id campaignId){
        
        // Verify if there are account selected. 
        if(!string.isBlank(accSelected)){

            List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts 	= (List<TEL_TelesalesWrapper.DisplayAccounts>)System.JSON.deserialize(accSelected, List<TEL_TelesalesWrapper.DisplayAccounts>.class);
            List<TEL_Campaign_Accounts__c> 		   lstAccCgn   		= new List<TEL_Campaign_Accounts__c>();
            
            //Create an opportunity for each account selected. 
            for(TEL_TelesalesWrapper.DisplayAccounts acc : lstAccounts){
                if(acc.isSelected){
                        TEL_Campaign_Accounts__c cacc 	= new TEL_Campaign_Accounts__c();
                        cacc.TEL_Account__c    			= acc.accountId;
                        cacc.TEL_Campaign__c 			= campaignId;
                        cacc.RecordTypeId				= CONST_ACC_CMPG_RECORD_TYPE;
                        
                        lstAccCgn.add(cacc);
                }
            }
            Database.upsert(lstAccCgn);
        }
    }
    
    // Create opportunity based on weekdays and accounts selectes. 
    public static list<Opportunity> createOpp(List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts, String oppGenType, Id campaignId){
        
        System.debug('Valor do oppGenType: '+oppGenType);
        System.debug('Valor do campaignId: '+campaignId);
    	List<Opportunity>	lstOpp = new List<Opportunity>();
            
        //Create an opportunity for each account selected. 
        for(TEL_TelesalesWrapper.DisplayAccounts acc : lstAccounts){
        	if(acc.isSelected){
            	nextSchedule = 0;
                nextSchedule = (scheduledDay - weeklyDay) + daysToSchedule;

                // Verify the frequency which the opportunity must be created. 
                for(Integer i = 0; i < frequencySet; i++){
                                               
                	Opportunity opp 	= new Opportunity();
                    opp.StageName 		= 'Pending Call';
                    opp.AccountId 		= acc.accountId;
                    opp.RecordTypeId	= CONST_OPP_RECORD_TYPE;
                    opp.Pricebook2Id	= CONST_PRICE_RECORD_TYPE;
                    opp.Name 			= Label.TEL_Opportunity_Name;
                    if(campaignId != null){
                        System.debug('valor qdo entra no if campaignId');
                        opp.campaignId	= campaignId;
                    }
                    if(oppGenType == Label.TEL_Enrichment_Type){
                        System.debug('valor qdo entra no if campaignId 02');
                        opp.Type 		= Label.TEL_Enrichment_Type;
                    }
                    if(oppGenType == Label.TEL_Sales_Call_Type){
                        System.debug('valor qdo entra no if campaignId 03');
                        opp.Type 		= Label.TEL_Sales_Call_Type;
                    }
                    if(oppGenType == Label.TEL_Sales_Drive_Type){
                        System.debug('valor qdo entra no if campaignId 04');
                        opp.Type 		= Label.TEL_Sales_Drive_Type;
                    }
                    opp.CloseDate 		= System.today().addDays(nextSchedule);
                        
                    lstOpp.add(opp);
                  	nextSchedule = nextSchedule + daysToSchedule;
                }
           	}
		}
        return lstOpp;
    }
}