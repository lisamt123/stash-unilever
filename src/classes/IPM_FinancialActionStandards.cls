//For Getting Financial Action Standards
public class IPM_FinancialActionStandards
{
    public Id projectId;
    public ID getprojectId(){ return projectId; }
    public void setprojectId (ID p){
        projectId= p;
        showFinancialActionStandards();
    }

    public IPM_Financial__c financial{get; set;}
    public Map<String,IPM_Financial_Year__c> mapFinancialYears{get;set;}
    
    public IPM_Financial_Year__c firstFullYearGross {get; set;}
    public IPM_Financial_Year__c firstFullYearIncremental {get; set;}
    
    public Integer finRecCount{get;set;}

    public void showFinancialActionStandards(){
        IPM_Project__c project = [SELECT IPM_PROject_Name__c 
                                    FROM IPM_Project__c 
                                    WHERE ID =: projectId];
        
             String financialExternalId = project.IPM_PROject_Name__c + '_CONSOLIDATED';
        
            finRecCount=[SELECT count() FROM IPM_Financial__c WHERE Financial_External_Id__c =: financialExternalId];
            if(finRecCount>0)
            {
            financial = [SELECT Id, NPV_Charter__c, IRR_Charter__c, Payback_Charter__c,
                            (SELECT Id, External_Id__c, PL_Type__c, Value_Market_Share_Charter__c, GM_of_TO_Charter__c, Turnover_Charter__c, Year_Type__c
                                FROM IPM_Financial_Years__r)
                        FROM IPM_Financial__c 
                        WHERE Financial_External_Id__c =: financialExternalId];
    
         
            mapFinancialYears = new Map<String, IPM_Financial_Year__c>();
            For(IPM_Financial_Year__c finYear : financial.IPM_Financial_Years__r)
                mapFinancialYears.put(finYear.External_Id__c, finYear);
            
            firstFullYearGross = mapFinancialYears.get(financialExternalId + '_Y1_Innovation_Gross');
            firstFullYearIncremental = mapFinancialYears.get(financialExternalId + '_Y1_Innovation_Incremental');
        }
    }
}