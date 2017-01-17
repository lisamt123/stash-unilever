public with sharing class BFM_SESSummaryScreen_CC {
    
    public BFM_SES__c ses{get;set;}
    public String seslistString {get;set;}
    public String recordscount{get;set;}
    public List<BFM_SES__c> seslist {get;set;}
    public List<BFM_CT_e__c> ctelist {get;set;}
    public String stlist {get;set;}
    public List<wrappercls> wrapper {get; set;}   
    public String searchWord{get; set;}
    public String lStatus {get; set;}
    public String vStatus {get; set;}
    public String PStatus {get; set;}
    public String PayStatus {get; set;}
    public List<BFM_SES__c> sesId;
    public ApexPages.StandardSetController con{get; set;}
    public List<SelectOption> statusOptions {get;set;}
    public List<SelectOption> recordsize{get;set;}
    
    public BFM_SESSummaryScreen_CC(ApexPages.StandardSetController controller){
        seslistString ='Select id,name,stage__r.Origin_city__c,stage__r.Destination_City__c,stage__r.Shipment__r.Pricing_Calculation_Date__c,Gross_Value_net_tax__c,Document_Upload_Date_Time__c,CT_E__r.UF_Goods_Sender__c,CT_E__r.CT_e_Number__c,CT_E__r.Link_Status__c,CT_E__r.Is_Not_Duplicated__c, CT_E__r.CT_e_Sefaz_Check_Status__c,CT_E__r.Cte_Status__c,CT_E__r.Is_CNPJ_Valid__c from BFM_SES__c';
        try{
            con = new ApexPages.StandardSetController(Database.getQueryLocator(seslistString));
            system.debug('con---->'+con);
        } catch(QueryException ex){
            String errorMessage = ex.getMessage();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, errorMessage));
            System.debug(errorMessage);
        }
        setPaginationSettings();
        
    }
    
    
    public void setPaginationSettings(){
        ses = new BFM_SES__c();        
        statusOptions = new List<SelectOption>();
        
        Schema.DescribeFieldResult statusFieldDescription = BFM_SES__c.Display__c.getDescribe();
        for (Schema.Picklistentry picklistEntry:statusFieldDescription.getPicklistValues())
        {
            statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
            // obtain and assign default value
            if (picklistEntry.defaultValue){
                ses.Display__c= pickListEntry.getValue();
            }  
        }    
        // sets the number of records in each page set
        if(ses.Display__c != null ){
            con.setPageSize(integer.ValueOf(ses.Display__c));
        } else{
            con.setPageSize(2);
        }
    }
    
    public void getses(){
        if(recordscount=='10'){
            con.setPageSize(10);   
        }
        else if(recordscount=='25'){
            con.setPageSize(25);   
        }
        else if(recordscount=='50'){
            con.setPageSize(50);   
        }
        else if(recordscount=='100'){
            con.setPageSize(100);   
        }
        else if(recordscount=='200'){
            con.setPageSize(200);   
        }
    }
    
    public BFM_SESSummaryScreen_CC(){
        
        recordsize = new List<SelectOption>(); 
        recordsize.add(new SelectOption('10','10'));
        recordsize.add(new SelectOption('25','25'));
        recordsize.add(new SelectOption('50','50'));
        recordsize.add(new SelectOption('100','100'));
        recordsize.add(new SelectOption('200','200'));
        searchWord='';
        
        seslist =[Select id,name,stage__r.Origin_city__c,stage__r.Destination_City__c,stage__r.Shipment__r.Pricing_Calculation_Date__c,Gross_Value_net_tax__c,Document_Upload_Date_Time__c,CT_E__r.UF_Goods_Sender__c,CT_E__r.CT_e_Number__c,CT_E__r.Link_Status__c,CT_E__r.Is_Not_Duplicated__c, CT_E__r.CT_e_Sefaz_Check_Status__c,CT_E__r.Cte_Status__c ,CT_E__r.Is_CNPJ_Valid__c from BFM_SES__c];
        
        SESView(seslist);
    }
    
    
    public List<BFM_SES__c> SESVfList
    {  
        get  
        {  
            if(con != null)  
                return (List<BFM_SES__c>)con.getRecords();            
            else  
                return null ;             
        }  
        set;
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
            seslist =[Select id,name,Gross_Value_net_tax__c,Document_Upload_Date_Time__c,stage__r.Origin_city__c,stage__r.Destination_City__c,stage__r.Shipment__r.Pricing_Calculation_Date__c,CT_E__r.Link_Status__c,CT_E__r.Is_Not_Duplicated__c, CT_E__r.CT_e_Sefaz_Check_Status__c,CT_E__r.Cte_Status__c, CT_E__r.Is_CNPJ_Valid__c from BFM_SES__c where id in:sesId];
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
            if(ses.CT_E__r.Is_Not_Duplicated__c && !ses.CT_E__r.Is_CNPJ_Valid__c){
                wr.validationStatus='OK';    
            } 
            if(!ses.CT_E__r.Is_Not_Duplicated__c && ses.CT_E__r.Is_CNPJ_Valid__c){
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
        public wrappercls(BFM_SES__c ses,String linkStatus,String validationStatus,String PODStatus,String PaymentStatus){
            this.linkStatus='NOTCHECKED';
            this.validationStatus='NOTCHECKED';
            this.PODStatus='NOTCHECKED';
            this.PaymentStatus='NOTCHECKED';                
        } 
    }
    
    // returns the first page of records
    public void first() {
        con.first();
    }
    
    // returns the last page of records
    public void last() {
        con.last();
    }
    
    // returns the previous page of records
    public void previous() {
        con.previous();
    }
    
    // returns the next page of records
    public void next() {
        con.next();
    }
    
    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    }
    public Boolean hasNext  
    {  
        get  
        {  
            return con.getHasNext();  
        }  
        set;  
    }  
    public Boolean hasPrevious  
    {  
        get  
        {  
            return con.getHasPrevious();  
        }  
        set;  
    }  
}