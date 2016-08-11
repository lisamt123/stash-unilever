/************************************************
Name CEC_CaseTransferController
Copyright@ 2016  Unilever
Purpose: This class will be used by CEC_CaseTranfer page to
transfer case to the advisor selected market.
Once user selects any of the case market mapping perform the following action:
- Update the following case fields:
a. Case market mapping
b. Default the case owner with the case market mapping: default case owner field value
c. If Reason code exists then check if there is any reason code exists based on the L5 Code (not desc) and 2 - char country code.
If reason code exists then replace the existing reason code, otherwise blank it off
d. Remove the case product information
e. Remove the customer information
f. Remove any store information if present
g. Any deleted information should be populated in the case comment field

<!-- History-->
<!-- ---------------------------------------------------------->
VERSION     AUTHOR              DATE            DETAIL
1.0         Mahesh           May-2016      INITIAL DEVELOPMENT
*************************************************/
public class CEC_CaseTransferController {
    public string marketMapping {get; set;}
    public list<CEC_Case_Market_Mapping__c> caseMarketMappings {get; set;}
    public String caseMktMapIdStr {get; set;}
    public Boolean isTransferSuccess {get; set;}
    private static final string lineBreak = '\n\n';
    Case transCase;
    
    
    public CEC_CaseTransferController(ApexPages.StandardController controller) {
        caseMarketMappings = new list<CEC_Case_Market_Mapping__c>();
        transCase =  (case)controller.getRecord();
    }
    
    /*******************************************************************
Purpose: To display case market mapping on the basis of user input.
********************************************************************/
    
    public void searchMarketMap() {
        caseMarketMappings = new list<CEC_Case_Market_Mapping__c>();
        // Reset the new selected CMM to null for every search.
        
        if (String.isBlank(marketMapping)) {
            System.debug('**************' + marketMapping);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.CEC_EnterMktMappingMsg);
            ApexPages.addMessage(myMsg);
        } else {
            String searchparam = '%' + marketMapping.removeEnd('*') + '%';
            System.debug('*******searchparam**********' + searchparam );
            caseMarketMappings  = [SELECT Id, Name, Market__c, Language__c, Country__r.ISO_3166_1_Code__c, DefaultCaseOwnerId__c, Country__r.Name FROM CEC_Case_Market_Mapping__c
                                   WHERE Market__c != :transCase.Case_Market__c AND (Name Like :searchparam OR Market__c Like :searchparam)    limit 10000];
            System.debug('*******caseMarketMappings **********' + caseMarketMappings  );
            if (caseMarketMappings.isEmpty()) {
                ApexPages.Message searchResultNtFoundMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.CEC_NoResultFoundMsg);
                ApexPages.addMessage(searchResultNtFoundMsg);
            }
            else if(caseMarketMappings.size() >= 200){
                ApexPages.Message searchResultWarnMsg = new ApexPages.Message(ApexPages.Severity.Warning, Label.CEC_SearchWarningMsg);
                ApexPages.addMessage(searchResultWarnMsg);   
            }
        }
        
    }
    
    /*******************************************************************
Purpose: To transfer case to the advisor selected market.
********************************************************************/
    
    public void transferCase() {
        isTransferSuccess = false;
        if (String.isBlank(caseMktMapIdStr)) {                        
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.CEC_SelectMktMappingMsg);
            ApexPages.addMessage(myMsg);
        } else {
            Id caseMktMapId = (Id)caseMktMapIdStr;
            case oldCase = [SELECT  Id, Country__c, Country__r.name, owner.Name, Store__c, Store__r.name, 
                                    CEC_Product__r.Name, Account.Name, Reason_Code__c, Reason_Code__r.Name
                                    FROM Case 
                                    WHERE Id = : transCase.Id];
            
            Map<Id, CEC_Case_Market_Mapping__c> mktMappingById = new Map<Id, CEC_Case_Market_Mapping__c>(caseMarketMappings);
            CEC_Case_Market_Mapping__c mktMapSelected = mktMappingById.get(caseMktMapId);
            Group currentCaseOwner;
            
            transCase.status = 'New';
            transCase.Country__c = mktMapSelected.Id;
            transCase.ownerId = mktMapSelected.DefaultCaseOwnerId__c;
            transCase.Store__c = null;
            transCase.CEC_Product__c = null;
            transCase.AccountId = null;
            transCase.ContactId = null;
            transCase.Reason_Code__c = null;
            
            try {
                update transCase;
                currentCaseOwner = [SELECT Id, Name FROM Group WHERE Id = : mktMapSelected.DefaultCaseOwnerId__c];
                
                 String commentBody = 'Changed Case Market Mapping from ' + oldCase.Country__r.Name  + ' to ' + mktMapSelected.Name  + lineBreak;
                commentBody  += 'Changed Owner from ' + oldCase.owner.name + ' to ' + currentCaseOwner.Name + lineBreak;
                
                if (oldCase.Store__r.name != null)
                    commentBody  += 'Removed Store : ' + oldCase.Store__r.name + lineBreak;
    
                if (oldCase.Account.Name != null)
                    commentBody  += 'Removed Contact Name : ' + oldCase.Account.Name + lineBreak ;
                
                if (oldCase.CEC_Product__r.Name != null)
                    commentBody  += 'Removed Product : ' + oldCase.CEC_Product__r.Name + lineBreak ;
                
                if (oldCase.Reason_Code__r.Name != null)
                    commentBody  += 'Removed Reason Code : ' + oldCase.Reason_Code__r.Name  + lineBreak ;
                
                CaseComment caseCommt = new CaseComment();
                caseCommt.CommentBody = commentBody  ;
                caseCommt.ParentId = transCase.Id;
                 insert caseCommt;
                
            } Catch(DmlException ex) {
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0));
                ApexPages.addMessage(myMsg);
            }
            
           
            isTransferSuccess = true;
        }       
    }
}