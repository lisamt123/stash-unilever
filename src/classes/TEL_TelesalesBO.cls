/**********************************************************************
Name: TEL_TelesalesBO
Copyright © 2016 Unilever

Purpose:
Store the telesales business rules. 

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Ronaldo Garcia  05/12/2016  Class creation  
***********************************************************************/
public with sharing class  TEL_TelesalesBO {
    
    // Instance Class
    private static final TEL_TelesalesBO instance = new TEL_TelesalesBO();
    
    // Construtor 
    public TEL_TelesalesBO() {}
    
    // Get Instance method to return a static final instance of this object. 
    public static TEL_TelesalesBO getInstance(){
        return instance;
    }
    
    // Create opportunity related approved case. 
    public void createOpp(List<Case> approvedCase){
        
        try{
            system.debug('Entering <createOpp>');
            
            // Retrieve the Telesales opportunity record type Id. 
        	Id opportunityRecordType	=  ICB_RecordTypeMemory.getRecType(Label.TEL_Opportunity, Label.TEL_Telesales_Record_Type);
        
            // Store the number of days to add in close date field. 
            Integer additionalDays 		= integer.valueOf(TEL_Telesales__c.getValues('Additional_Days').Value__c);
            
            // Store the opportunity name to be created. 
            String opportunityName 		=  Label.TEL_Sample_Request;
            
            // List to create the opportunity. 
            List<Opportunity> 	lstOpp 	= new List<Opportunity>(); 
        
            for(Case c : approvedCase){
                if(c.status == Label.TEL_Sample_Request_Status){
                    Opportunity opp 		= new Opportunity();
                    opp.Name				= Label.TEL_Opportunity_Name;
                    opp.TEL_Case__c			= c.Id;
                    opp.Type				= Label.TEL_Sample_Request;
                    opp.RecordTypeId		= opportunityRecordType;
                    opp.CloseDate			= System.today().addDays(additionalDays);
                    opp.StageName 			= Label.TEL_Opportunity_Status;
                    
                    lstOpp.add(opp);
                }
            }
        
            // Insert the opportunity related to a sample request approved. 
            database.insert(lstOpp); 
		    system.debug('Exit <createOpp>'); 
            
        }catch(Exception e){
            system.debug('Fail <createOpp> '+e.getMessage());
        }       
    } 
}