public with sharing class BFM_SearchOccurrenceController_CC{
    public ApexPages.StandardSetController con{get; set;}
    public BFM_Occurrence__c searchOccurrence{get;set;}
    public Boolean secondBlock{get;set;} 
    public string recordscount{get;set;}
    public List<SelectOption> recordsize{get;set;}
    public string occrid;
    public BFM_SearchOccurrenceController_CC(ApexPages.StandardSetController controller) {
    occrid = ApexPages.currentPage().getParameters().get('Id');
    searchOccurrence = New BFM_Occurrence__c();
    recordsize = new List<SelectOption>(); 
    recordsize.add(new SelectOption('10','10'));
    recordsize.add(new SelectOption('25','25'));
    recordsize.add(new SelectOption('50','50'));
    recordsize.add(new SelectOption('100','100'));
    recordsize.add(new SelectOption('200','200'));    
    }
    
    public List<BFM_Occurrence__c> OccList
    {  
        get  
        {  
            if(con != null)  
                return (List<BFM_Occurrence__c>)con.getRecords();  
            else  
                return null ;  
        }  
        set;
    }
    
    public void mySearch(){
        secondBlock = true;
        
        String OccurenceString = 'SELECT id,name,Occurrence_Number__c,Status__c,Range_of_Extent_of_Occurrence_From__c,Range_of_Extent_of_Occurrence_To__c FROM BFM_Occurrence__c WHERE';
       
        String Occurrence_Number = searchOccurrence.Occurrence_Number__c;
        string OccurenceDate= string.ValueOf(searchOccurrence.Range_of_Extent_of_Occurrence_From__c); 
        
       /* 
        if(searchOccurrence.name!=null && searchOccurrence.name!=''){
            OccurenceString += ' name LIKE \''+String.escapeSingleQuotes(shipname)+'%\''+' '; OccurenceString += 'AND';
        }
        */
        
        if(String.valueOf(searchOccurrence.Occurrence_Number__c)!=null && String.valueOf(searchOccurrence.Occurrence_Number__c)!=''){
            //shipString += ' Occurrence_Number__c LIKE \''+String.valueOf(shipNumber)+'%\''+' '; shipString += 'AND';
            OccurenceString += ' Occurrence_Number__c =' +(Occurrence_Number); OccurenceString += 'AND';
        }
        
        if(String.valueOf(searchOccurrence.Range_of_Extent_of_Occurrence_From__c)!=null && string.valueOf(searchOccurrence.Range_of_Extent_of_Occurrence_From__c)!=''){
            OccurenceString += ' Range_of_Extent_of_Occurrence_From__c = ' +(OccurenceDate); OccurenceString += 'AND';
        }
                   
        OccurenceString = OccurenceString.Substring(0,OccurenceString.length()-3);
      

         con = new ApexPages.StandardSetController(Database.getQueryLocator(OccurenceString));
                        // sets the number of records in each page set
                        con.setPageSize(5);
        
       
    }
    
    public void getoccurences(){
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