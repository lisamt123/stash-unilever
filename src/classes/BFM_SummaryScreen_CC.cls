public with sharing class BFM_SummaryScreen_CC {
    
    public String data { get; set; }
    
    public BFM_SES__c ses{get;set;}
    public List<BFM_SES__c> seslist {get;set;}
    public List<BFM_CT_e__c> ctelist {get;set;}
    public List<BFM_Stage__c> stlist {get;set;}
    public List<wrappercls> wrapper {get; set;}   
    public string searchWord{get; set;}
    public string lStatus {get; set;}
    public string vStatus {get; set;}
    public string PStatus {get; set;}
    public string PayStatus {get; set;}
    public list<BFM_SES__c> sesId;
    
    public decimal countLinkStatusOk {get; set;}
    public decimal countLinkStatusNotOk {get; set;}
    public decimal countValidationkStatusOk {get; set;}
    public decimal countValidationkStatusNotOk {get; set;}
    public decimal countPaymenttatusOk {get; set;}
    public decimal countPaymenttatusNotOk {get; set;}
    public decimal countPODStatusOk {get; set;}
    public decimal countPODStatusNotOk {get; set;}
    
    
    public BFM_SummaryScreen_CC(){
        searchWord='';
        seslist =[Select id,name,stage__r.Origin_city__c,stage__r.Destination_City__c,stage__r.Shipment__r.Pricing_Calculation_Date__c,Gross_Value_net_tax__c,Document_Upload_Date_Time__c,CT_E__r.UF_Goods_Sender__c,CT_E__r.CT_e_Number__c,CT_E__r.Link_Status__c,CT_E__r.Company_Code_Status__c,CT_E__r.Is_Duplicated__c, CT_E__r.CT_e_Sefaz_Check_Status__c,CT_E__r.Cte_Status__c , CT_E__r.Is_CNPJ_Invalid__c from BFM_SES__c];
        SESView(seslist);
    }
    
    public void searchSES(){
        
        if(searchWord!=null && searchWord.length()>1 ){    
            List<List <sObject>> searchList = [FIND :searchWord IN ALL FIELDS RETURNING  BFM_SES__c(Id)];
            sesId=searchList[0];
        } 
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'search term must be longer than one character'));
        } 
        
        if(sesId!=null){     
            seslist =[Select id,name,Gross_Value_net_tax__c,Document_Upload_Date_Time__c,stage__r.Origin_city__c,stage__r.Destination_City__c,stage__r.Shipment__r.Pricing_Calculation_Date__c,CT_E__r.Link_Status__c,CT_E__r.Company_Code_Status__c,CT_E__r.Is_Duplicated__c, CT_E__r.CT_e_Sefaz_Check_Status__c,CT_E__r.Cte_Status__c , CT_E__r.Is_CNPJ_Invalid__c from BFM_SES__c where id in:sesId];
            SESView(seslist);
        }
        
        
    } 
    
    public pageReference redirectPage(){
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }    
    
    
    Private void SESView(List<BFM_SES__c> sesList ){
        
        wrapper = new List<wrappercls>();
        for(BFM_SES__c ses:seslist ){
            wrappercls wr = new wrappercls(ses,lStatus,vStatus,PStatus,PayStatus);
            wr.ses=ses;
            if(ses.CT_E__r.Link_Status__c=='Link Ok'){    
                wr.linkStatus='OK';
                countLinkStatusOk=countLinkStatusOk+1;
            } 
            if(ses.CT_E__r.Link_Status__c=='Pending Link'){    
                wr.linkStatus='NOTOK';
                countLinkStatusNotOk=countLinkStatusNotOk+1;
            }      
            if(ses.CT_E__r.Is_Duplicated__c && ses.CT_E__r.Is_CNPJ_Invalid__c ){
                wr.validationStatus='OK';  
                countValidationkStatusOk=countValidationkStatusOk+1;    
            } 
            if(ses.CT_E__r.Is_Duplicated__c && !ses.CT_E__r.Is_CNPJ_Invalid__c){
                wr.validationStatus='NOTOK'; 
                countValidationkStatusNotOk=countValidationkStatusNotOk+1;      
            }
            if(ses.CT_E__r.Cte_Status__c=='Invoice Posted' ){
                wr.PaymentStatus='OK';
                countPaymenttatusOk=countPaymenttatusOk+1;      
            }   
            wrapper.add(wr);
        }
        
    }
    public class wrappercls{
        public BFM_SES__c ses {get;set;}
        public BFM_CT_e__c cte {get;set;}
        public BFM_Stage__c stg {get;set;}
        public String linkStatus {get; set;}
        public String validationStatus {get; set;}
        public String PODStatus {get; set;}
        public String PaymentStatus {get; set;}
        public wrappercls(BFM_SES__c ses,string linkStatus,string validationStatus,string PODStatus,string PaymentStatus){
            this.linkStatus='NOTCHECKED';
            this.validationStatus='NOTCHECKED';
            this.PODStatus='NOTCHECKED';
            this.PaymentStatus='NOTCHECKED';                
        } 
    }
    
}