public with sharing class BFM_NFSSearch_CC {
    public BFM_NFS__c nfs{get;set;}
    public List<BFM_NFS__c> nfsList {get;set;}
    List<string> conditions = new List<string>();
    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize= 10;
    public Date toDate {get;set;}
    public Date createDate {get;set;}
    
    public BFM_NFSSearch_CC(){
        nfs = new BFM_NFS__c();
    }
    
    public void searchnfs(){
        totalRecs = 0;
        OffsetSize = 0;
        if(nfsList !=null && nfsList.size()>0){
            nfsList=null;
        }
        searchnfsrec();
        conditions.clear();
    }
    
    
    public Void searchnfsrec(){
        if(nfsList != null && !nfsList.isEmpty()){
            nfsList.clear();
        }
        String strQuery ='SELECT id, Name,NFS_Number__c,NFS_Emission_Date_Time__c,Service_Detailed_Description__c,Service_Taker_CNPJ__c,'
            + 'Vendor_s_CNPJ_or_CPF__c, NFS_Key__c, NFS_Status__c, Tax_Status__c, CreatedDate from BFM_NFS__c';
        
        if(nfs.Name !=null && nfs.Name !=''){
            List<String> iterateItems = nfs.Name.split(',') ;
            List<String> name = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                name.add(item);
            }
            conditions.add('Name in' + name);                
        }
        
        if(nfs.NFS_Key__c !=null && nfs.NFS_Key__c !=''){
            List<String> iterateItems = nfs.NFS_Key__c.split(',') ;
            List<String> nfsKey = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                nfsKey.add(item);
            }
            conditions.add('NFS_Key__c in' + nfsKey);                
        }        
        
        if(nfs.NFS_Number__c !=null && nfs.NFS_Number__c !=''){
            List<String> iterateItems = nfs.NFS_Number__c.split(',') ;
            List<String> nfsNumber = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                nfsNumber.add(item);
            }
            conditions.add('NFS_Number__c in' + nfsNumber);            
        }
        
        if(nfs.NFS_Emission_Date_Time__c !=null){
            String emissionDate = nfs.NFS_Emission_Date_Time__c.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
            conditions.add('NFS_Emission_Date_Time__c > ' + emissionDate);
        }
        
        if(createDate != null){
            DateTime dt = datetime.newInstance(createDate.year(), createDate.month(),createDate.day());
            String createdDate = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
            conditions.add('CreatedDate > ' + createdDate);
        }
            
        if(createDate !=null && toDate !=null){
            DateTime dt = datetime.newInstance(toDate.year(), toDate.month(),toDate.day());
            String finishedDate = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
            conditions.add('NFS_Emission_Date_Time__c < ' + finishedDate);
        }
        
        if(nfs.Service_Taker_CNPJ__c !=null && nfs.Service_Taker_CNPJ__c !=''){
            List<String> iterateItems = nfs.Service_Taker_CNPJ__c.split(',') ;
            List<String> serviceTaker = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                serviceTaker.add(item);
            }
            conditions.add('Service_Taker_CNPJ__c in' + serviceTaker);            
        }
        
        if (conditions.size() > 0) {
            strQuery += '  WHERE ' + conditions[0];
            for (Integer i = 1; i < conditions.size(); i++)
                strQuery += '  AND ' + conditions[i];
        }
        
          System.debug('strQuery' +strQuery);
        if(totalRecs !=null && totalRecs ==0){
            List<BFM_NFS__c> nfsTemp = Database.query(strQuery);
            totalRecs = (nfsTemp !=null &&nfsTemp.size()>0)?nfsTemp.size():0;
        }
        strQuery += ' ORDER BY Name  ASC LIMIT :LimitSize OFFSET :OffsetSize';
        
        nfsList  =Database.query(strQuery);
    }
    
    public void FirstPage()
    {
        OffsetSize = 0;
        searchnfsrec();
    }
    public void previous()
    {
        OffsetSize = (OffsetSize-LimitSize);
        searchnfsrec();
    }
    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
        searchnfsrec();
    }
    public void LastPage()
    {
        OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
        searchnfsrec();
    }
    public boolean getprev()
    {
        
        if(OffsetSize == 0){
            
            return true;
        }
        else {
            
            return false;
        }
    }
    public boolean getnxt() {
        if((OffsetSize + LimitSize) > totalRecs){
            
            return true;
        }
        else {
            
            return false;
        }
    }
}