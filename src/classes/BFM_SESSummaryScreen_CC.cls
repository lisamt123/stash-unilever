public with sharing class BFM_SESSummaryScreen_CC {

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
    

    public BFM_SESSummaryScreen_CC(){
        data = new List<PieWedgeData>();
        searchWord='';
        seslist =[Select id,name,stage__r.Origin_city__c,stage__r.Destination_City__c,stage__r.Shipment__r.Pricing_Calculation_Date__c,Gross_Value_net_tax__c,Document_Upload_Date_Time__c,CT_E__r.UF_Goods_Sender__c,CT_E__r.CT_e_Number__c,CT_E__r.Link_Status__c,CT_E__r.Company_Code_Status__c,CT_E__r.CT_e_Duplicate_Record_Status__c, CT_E__r.CT_e_Sefaz_Check_Status__c,CT_E__r.Cte_Status__c,CT_E__r.CT_e_Valid_CNPJ_Status__c from BFM_SES__c];
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
        seslist =[Select id,name,Gross_Value_net_tax__c,Document_Upload_Date_Time__c,stage__r.Origin_city__c,stage__r.Destination_City__c,stage__r.Shipment__r.Pricing_Calculation_Date__c,CT_E__r.Link_Status__c,CT_E__r.Company_Code_Status__c,CT_E__r.CT_e_Duplicate_Record_Status__c, CT_E__r.CT_e_Sefaz_Check_Status__c,CT_E__r.Cte_Status__c,CT_E__r.CT_e_Valid_CNPJ_Status__c from BFM_SES__c where id in:sesId];
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
        } 
        if(ses.CT_E__r.Link_Status__c=='Pending Link'){    
            wr.linkStatus='NOTOK';
        }      
        if(ses.CT_E__r.CT_e_Duplicate_Record_Status__c=='Validation OK' && ses.CT_E__r.CT_e_Valid_CNPJ_Status__c=='Valid CNPJ'){
        wr.validationStatus='OK';    
        } 
        if(ses.CT_E__r.CT_e_Duplicate_Record_Status__c=='Validation Error' && ses.CT_E__r.CT_e_Valid_CNPJ_Status__c=='Invalid CNPJ'){
        wr.validationStatus='NOTOK';    
        }
        if(ses.CT_E__r.Cte_Status__c=='Invoice Posted' ){
        wr.PaymentStatus='OK';    
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
  
    //Pie chart data
    public List<PieWedgeData> data {get;set;}
    public List<PieWedgeData> getPieData() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        AggregateResult[] groupedResults  = [SELECT Cte_Status__c ,Sum(Net_Value__c) FROM BFM_CT_e__c Group by Cte_Status__c];
        for (AggregateResult ar : groupedResults)  {            
                    if(ar.get('Cte_Status__c')!=null)
                    {
                     data.add(new PieWedgeData(
                         String.ValueOf(ar.get('Cte_Status__c')),
                         Double.ValueOf(ar.get('expr0'))
                         ));
                    }    
             }      
             return data;
    }
   
    public class PieWedgeData {
        public String name { get; set; }
        public Decimal data { get; set; }
        public PieWedgeData(String name, Decimal data) {
                 this.name = name;
                 this.data = data;
        }
    }
}