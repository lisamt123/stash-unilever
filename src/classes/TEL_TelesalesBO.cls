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
    
    // Create a log history event related to opportunity when a call is rescheduled or closed. 
    public void createOppLog(List<Opportunity> paramNewOpp, List<Opportunity> paramOldOpp){
        try{
            system.debug('Entering <createOppLog>');
            
            // Store the new and old stage phase. 
            String 	newStage;
            String 	oldStage; 
            id 		oppId;
            Date 	newCloseDate; 
            Date 	oldCloseDate;
            
            // Pass through new and old opp to set the new stage name. 
            for(Opportunity o : paramNewOpp){
                newStage 		= o.StageName;
                oppId 	 		= o.Id;
                oldCloseDate	= o.CloseDate;
            }
            for(Opportunity o : paramOldOpp){
                oldStage 		= o.StageName;       
                newCloseDate	= o.CloseDate;
            }
            
            // Create the new event log.
            Task  task			= new Task();
            task.Status			= Label.TEL_Completed_Task;
            task.RecordTypeId	= [SELECT Id FROM RecordType WHERE DeveloperName =: Label.TEL_Task_Telesales LIMIT 1].Id;
            task.ActivityDate	= System.today();
            task.WhatId			= oppId;
            task.Type 			= Label.TEL_Task_Type_Call;
            
            // Check if the stage changes. 
            if(newStage != oldStage || oldCloseDate != newCloseDate){
                if(newStage == Label.TEL_Stage_Recheduled){
                    task.Subject = Label.TEL_Subject_Rescheduled_Call + ' - '+ datetime.now();
                } 
                if(newStage == Label.TEL_OppStageClosedLost){
                    task.Subject = Label.TEL_Subject_Close_Lost + ' - '+ datetime.now();
                } 
                if(newStage == Label.TEL_OppStageReleased){
                    task.Subject = Label.TEL_Subject_Close_Won + ' - '+ datetime.now();
                } 
                
                // Insert the event log.
                database.upsert(task);
            }
        }
        catch(Exception e){
            system.debug('Fail <createOppLog> '+e.getMessage());
        }
    }
    
}