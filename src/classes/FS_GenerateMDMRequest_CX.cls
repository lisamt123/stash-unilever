public with sharing class FS_GenerateMDMRequest_CX{
    
    
    private Id opportunityId;
    private static final String SystemAdmin = 'System Administrator';
    private static final String RoleUFSRussia = 'UFS Russia';
    private static final String StepStatusStarted = 'Started';
    private static final Id SYS_ADMIN_PROFILE_ID = [SELECT ProfileId FROM User WHERE Profile.Name = :SystemAdmin Limit 1].ProfileId;
    
    public FS_GenerateMDMRequest_CX(ApexPages.StandardController stdController) {
         opportunityId = stdController.getId();

    }
    
    public void identifyAction(){
    }
   
    public DateTime dateSent{
        get{ if (dateSent == null){
                    ProcessInstanceStep pis = [SELECT CreatedDate
                                    FROM ProcessInstanceStep
                                    WHERE StepStatus = :StepStatusStarted
                                    AND ProcessInstance.TargetObjectId = :opportunityId 
                                    ORDER By CreatedDate Desc Limit 1];
                            
                          dateSent = pis.CreatedDate;          
                      }
                  return dateSent;           
        }
        set;
    }

    
    public Opportunity opportunityRecord{
          get{ if(opportunityRecord== null){
                        opportunityRecord =[SELECT Id,
                                                FS_startDateTPR__c,
                                                FS_endDateTPR__c,
                                                FS_internalOrder__c,
                                                Owner.Email,
                                                FS_TPRApproved__c,
                                                FS_MDMRequestSent__c
                                            FROM Opportunity
                                            WHERE Id=:opportunityId 
                                            LIMIT 1];
            }
            return opportunityRecord;
        }
        set;
    }
    
    public FS_MDMEmailRequestDefaultValue__c getDefaultCSValue(){
        FS_MDMEmailRequestDefaultValue__c mdmDefaultValue = FS_MDMEmailRequestDefaultValue__c.getOrgDefaults();         
        return mdmDefaultValue;
    }
        
    public FS_MDMEmailRequestTemplate__c getHeaderCSValue(){
        FS_MDMEmailRequestTemplate__c mdmHeader = FS_MDMEmailRequestTemplate__c.getOrgDefaults();
        return mdmHeader;
    }
    
    public Map<Id, Product2> product2Map{
      get{      if(product2Map == null){
                                product2Map = new Map<Id, Product2>([SELECT Name
                                                        FROM Product2
                                                        WHERE Id IN (
                                                                SELECT Product2Id
                                                                                        FROM OpportunityLineItem
                                                                                        WHERE OpportunityId = :opportunityRecord.Id
                                                            )]);
                }
             return product2Map;
         }
     set;
    }
    
    public List<OpportunityLineItem> opportunityProducts{
    get{ if(opportunityProducts == null){
                        opportunityProducts     =       [SELECT id,
                                                FS_totalTPRPercentage__c,
                                                ProductCode,
                                                Product2Id
                                            FROM OpportunityLineItem
                                            WHERE OpportunityId = :opportunityRecord.Id];
                }
                system.debug('------------------------>>>>>>>>>>'+opportunityProducts);
                return opportunityProducts;
       }
     set;
    }
}