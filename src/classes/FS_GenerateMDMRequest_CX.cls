/**********************************************************************
Name: FS_GenerateMDMRequest_CX()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
------- Controller that is used for the generation of PDF and Excel VF page
======================================================
======================================================
History
-------
VERSION AUTHOR         DATE         DETAIL                  Description
1.0     Accenture      15/08/2016   INITIAL DEVELOPMENT     CSR: FS-501
***********************************************************************/
public with sharing class FS_GenerateMDMRequest_CX{
    
    
    private Id opportunityId;
    private static final String StepStatusStarted = 'Started';
    private static final String FoodSolution = 'Food Solution';
    private static final String ClassName = 'FS_GenerateMDMRequest_CX';
    
    /*******************************************************************
    Purpose: Constructor method
    Parameters: ApexPages.StandardController
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public FS_GenerateMDMRequest_CX(ApexPages.StandardController stdController) {
         opportunityId = stdController.getId();
    }
    
    
    /*******************************************************************
    Purpose: Variable for DateSent
    Parameters: None
    Returns: 
    Throws [Exceptions]: N/A
    ********************************************************************/
    public DateTime dateSent{
        get{ 
            if (dateSent == null){
                    try{
                        ProcessInstanceStep pis = [SELECT CreatedDate
                                        FROM ProcessInstanceStep
                                        WHERE StepStatus = :StepStatusStarted
                                        AND ProcessInstance.TargetObjectId = :opportunityId 
                                        ORDER By CreatedDate Desc Limit 1];
                                
                              dateSent = pis.CreatedDate;
                    }catch(Exception e){
                        ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), ClassName , 'dateSent', e.getMessage(), e, null, null, null, 0, FoodSolution);
                    }          
             }
             return dateSent;           
        }
        set;
    }

    /*******************************************************************
    Purpose: Variable for opportunityRecord
    Parameters: None
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public Opportunity opportunityRecord{
        get{ 
            if(opportunityRecord== null){
                    try{    
                            opportunityRecord =[SELECT Id,
                                                    FS_startDateTPR__c,
                                                    FS_endDateTPR__c,
                                                    FS_internalOrder__c,
                                                    Owner.Email,
                                                    FS_TPRApproved__c,
                                                    FS_MDMRequestSent__c,
                                                    ShipToCode__c
                                                FROM Opportunity
                                                WHERE Id=:opportunityId 
                                                LIMIT 1];
                            opportunityRecord.FS_internalOrder__c = opportunityRecord.FS_internalOrder__c.replaceAll('[^0-9]', '');
                        }catch(Exception e){
                            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), ClassName, 'opportunityRecord', e.getMessage(), e, null, null, null, 0, FoodSolution);
                        }  
                }
            return opportunityRecord;
        }
        set;
    }
    
    /*******************************************************************
    Purpose: Get method for Default Custom Setting Value
    Parameters: None
    Returns: mdmDefaultValue
    Throws [Exceptions]: N/A
    ********************************************************************/
    public FS_MDMEmailRequestDefaultValue__c getDefaultCSValue(){
        FS_MDMEmailRequestDefaultValue__c mdmDefaultValue = FS_MDMEmailRequestDefaultValue__c.getInstance(UserInfo.getProfileId());          
        return mdmDefaultValue;
    }
     
    /*******************************************************************
    Purpose: Get method for Header Custom Setting Value
    Parameters: None
    Returns: mdmHeader
    Throws [Exceptions]: N/A
    ********************************************************************/   
    public FS_MDMEmailRequestTemplate__c getHeaderCSValue(){
        FS_MDMEmailRequestTemplate__c mdmHeader = FS_MDMEmailRequestTemplate__c.getInstance(UserInfo.getProfileId());
        return mdmHeader;
    }
    
    /*******************************************************************
    Purpose: Variable for accountRecord
    Parameters: None
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public Account accountRecord{
        get{      
            if(accountRecord == null){
                    try{
                        accountRecord = [SELECT Id,
                                        Name,
                                        FS_SoldToCode__c,
                                        FS_hierarchyLevel__c,
                                        CustomerLegalName__c
                                    FROM Account
                                    WHERE Id = :opportunityRecord.ShipToCode__c
                                    LIMIT 1];
                        }catch(Exception e){
                            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), ClassName, 'accountRecord', e.getMessage(), e, null, null, null, 0, FoodSolution);
                        }              
                }
             return accountRecord;
         }
        set;
    }
    
    /*******************************************************************
    Purpose: Variable for Product Map of the Opportunity Product Line Items
    Parameters: None
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public Map<Id, Product2> product2Map{
        get{      
                if(product2Map == null){
                        try{
                            product2Map = new Map<Id, Product2>([SELECT Name
                                                FROM Product2
                                                WHERE Id IN (
                                                        SELECT Product2Id
                                                        FROM OpportunityLineItem
                                                        WHERE OpportunityId = :opportunityRecord.Id
                                                    )]);
                        }catch(Exception e){
                            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), ClassName, 'product2Map', e.getMessage(), e, null, null, null, 0, FoodSolution);
                        }                                                
                    }
                 return product2Map;
             }
        set;
    }
    
    /*******************************************************************
    Purpose: Variable for Opportunity Line Items
    Parameters: None
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public List<OpportunityLineItem> opportunityProducts{
        get{ 
                if(opportunityProducts == null){
                   try{
                        opportunityProducts     =       [SELECT id,
                                                FS_totalTPRPercentage__c,
                                                ProductCode,
                                                Product2Id
                                            FROM OpportunityLineItem
                                            WHERE OpportunityId = :opportunityRecord.Id];
                    }catch(Exception e){
                        ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), ClassName, 'opportunityProducts', e.getMessage(), e, null, null, null, 0, FoodSolution);
                    } 
                }
                return opportunityProducts;
           }
         set;
    }
    
    /*******************************************************************
    Purpose: Variable for total TPR Percentage Map
    Parameters: None
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public Map<Id,String> totalTPRPercentageMap{
        get{
            if(totalTPRPercentageMap==null || totalTPRPercentageMap.isempty()){
                totalTPRPercentageMap = new Map<Id, String>();
                String formattedTotalTPRPercentage = null; 
                try{
                    for(OpportunityLineItem oli: [Select Id,
                                                            FS_totalTPRPercentage__c
                                                           FROM OpportunityLineItem
                                                           WHERE OpportunityId = :opportunityRecord.Id]){
                        formattedTotalTPRPercentage = null;
                        formattedTotalTPRPercentage = String.valueof(oli.FS_totalTPRPercentage__c).replace('.' , ',');
                        totalTPRPercentageMap.put(oli.Id,formattedTotalTPRPercentage);
                    }
                }catch(Exception e){
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), ClassName, 'totalTPRPercentageMap', e.getMessage(), e, null, null, null, 0, FoodSolution);
                } 
            }
            return totalTPRPercentageMap;
        }
        set;
    }
}