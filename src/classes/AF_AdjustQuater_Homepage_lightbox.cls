public class AF_AdjustQuater_Homepage_lightbox{
    public string ControlToFocus{get;set;}
    Public list<AF_Brand_Estimate__c> brandEstimate{get;set;}// Create Brand Estimate object list
    public String Category{get;set;}// To get Category value from URL parameter
    public String year{get;set;}// To get Finalcial value from URL parameter
    public String Quarter{get;set;}// To Display Quarter 
    public String BrandName{get;set;}// To get Brand Name
    public String sortDir{get;set;}//Filter Brand name as ascending or descending order
    public Boolean Quarter1;// pass quarter1 value and pass to wrapper class
    public Boolean Quarter2;// pass quarter2 value and pass to wrapper class
    public Boolean Quarter3;// pass quarter3 value and pass to wrapper class
    public Boolean Quarter4;// pass quarter4 value and pass to wrapper class
    public boolean displayPopup {get; set;}// Display output panel as popup while click on Continue button
    public boolean displaypopquarter {get; set;}// hide or show output panel  
    public Set<String> selectedBrandEstimateIds{get;set;}// Get selected brand estimate id's
    public list<AF_Brand_Estimate__c> updateBrandEstimate{get;set;}// to store Updated Brand Estimate records
    public list<wrapChechbox> QuarterEstimate{get;set;}// to get wrapper class records
    Public Map<id,String>ChangedBrand=new map<id,String>();// to store Id along with changed Brand estimate name    
    Public Map<id,String>ChangedQuarter=new map<id,String>();  // to store id along with changed quarters
    Public Map<id,String>BackupQuarter=new map<id,String>();
    public list<AF_Brand_Estimate__c> queryBrandEstimateRecords{get;set;}// to store Brand estimate records
    public String raiseNewPOQuarters='';   
          /** Constructor **/      
    public AF_AdjustQuater_Homepage_lightbox(){
       sortDir =null;
       displaypopquarter=false;
            
       /** Get Category and FYear from Homepage **/           
      Category=ApexPages.currentPage().getParameters().get('category');
      Year=ApexPages.currentPage().getParameters().get('Year');     
      
      /** Call QueryBrandEstimate Method **/
      queryBrandEstimate();
          }
      
      
   
   /** QueryBrandEstimate Method **/
   public void queryBrandEstimate(){
        QuarterEstimate =  new list<wrapChechbox>();
        queryBrandEstimateRecords = new List<AF_Brand_Estimate__c>();
        if(sortDir ==  null){
            sortDir = 'asc';    
        }
        else{
            sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        }
        String soql = 'select name,AF_Basefee_Estimate_Initial_Quarter__c,AF_RaiseNewPOQuarters__c,AF_BackupQuarter__c,Brand__r.Name,AF_Agency__r.Name,Brand__c,AF_Fiscal_Year__c from AF_Brand_Estimate__c where AF_Fiscal_Year__c =\''+year+'\'  and AF_Active__c=True and AF_Status_Base_Fees__c!=\''+'Ready for PO' +'\' order by name';
        soql = soql +' '+sortDir+' ' + 'limit 1000';
        system.debug('soql '+soql);
        queryBrandEstimateRecords = Database.query(soql);
        for(AF_Brand_Estimate__c eachBrandEstimate:queryBrandEstimateRecords){
            
           // Check all Brand Estimate quarters like Q1,Q2,Q3,Q4      
           if(eachBrandEstimate.AF_BackupQuarter__c != ''){
           
             Quarter1 = false;
             Quarter2 = false;
             Quarter3 = false;
             Quarter4 = false;
           String Quarters = '';
           Quarters  = eachBrandEstimate.AF_BackupQuarter__c;
           Quarter = '';
           if(Quarters != null){
           if(Quarters.contains('Q1')){
            Quarter1 = true;
            Quarter = 'Q1';
           
           }
           if(Quarters.contains('Q2')){
            Quarter2 = true;
            Quarter = Quarter + 'Q2';
           
           }
           if(Quarters.contains('Q3')){
            Quarter3 = true;
            Quarter = Quarter + 'Q3';
            
           }
           if(Quarters.contains('Q4')){
            Quarter4 = true;
            Quarter = Quarter + 'Q4';
           
           }
          }
          system.debug('Quarter...'+Quarter);
         }
          
           BrandName = '';
           BrandName = eachBrandEstimate.name;
           /*if(eachBrandEstimate.AF_RaiseNewPOQuarters__c != null){
            raiseNewPOQuarters = eachBrandEstimate.AF_RaiseNewPOQuarters__c;
            System.debug('raiseNewPOQuarters....'+raiseNewPOQuarters);
            system.debug('BrandName...'+BrandName);
        }*/
           QuarterEstimate.add(new wrapChechbox(eachBrandEstimate,BrandName,Quarter1,Quarter2,Quarter3,Quarter4)); 
      }
    }

  // Method for close Popup
  public void closePopup() { 
        displayPopup = false;    
      } 
        
   // Method for show Popup on Continue button
  public void showPopup() {
     String quarterformat='';
     String QuarterName='';
     list<String>addQuarter=new list<String>();
     list<String> validateAddQuarter=new list<String>();
     list<String>addDummyQuarter=new list<String>();
     selectedBrandEstimateIds = new Set<String>();
     String changedBrandName;
     String brandQuarter='';
     String raiseNewPOQuarters;
    for(wrapChechbox B:QuarterEstimate){
       
       if(B.selected == true){
           brandQuarter = '';
           changedBrandName = '';
           QuarterName='';
           quarterformat=''; 
           raiseNewPOQuarters='';
           if(B.BrandRecord.AF_RaiseNewPOQuarters__c!=null){
           raiseNewPOQuarters = B.BrandRecord.AF_RaiseNewPOQuarters__c;
           }
            selectedBrandEstimateIds.add(B.BrandRecord.Id);
            changedBrandName = B.BrandRecord.Brand__r.Name +'-';     
            changedBrandName=changedBrandname+B.BrandRecord.AF_Agency__r.Name +' '; 
           
            if(B.Q1 == true){
            
                if(!raiseNewPOQuarters.contains('Q1')){
                    addquarter.add('Q1');
                    
                }
                                       
             }
             if(B.Q2 == true){
             
             if(!raiseNewPOQuarters.contains('Q2')){
                addquarter.add('Q2');
                                
              }       
             }
             if(B.Q3 == true){
             
             if(!raiseNewPOQuarters.contains('Q3')){
                addquarter.add('Q3');
                
               }
                }
             if(B.Q4 == true){
             
             if(!raiseNewPOQuarters.contains('Q4')){
                addquarter.add('Q4');
                
                }
                }
             
             
             if(addquarter.IsEmpty()){
              displaypopquarter=true; 
              apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Please select current base fee name quarter,like Q1,Q2,Q3,Q4')); // Quarter value can not be empty
              
            }
           else{
           String missQuarter='';
           Integer count=0;
            for(String qr:addquarter){
                qr = qr.remove('Q');
                missQuarter = missQuarter+qr;
                validateAddQuarter.add(qr);
            }
            system.debug('missQuarter....'+missQuarter);
            system.debug('validateAddQuarter....'+validateAddQuarter);
            Integer i=1;
            Integer listSize=validateAddQuarter.size(); 
            Integer lastQuarter=0;
            if(validateAddQuarter.size()>0){
            lastQuarter = Integer.ValueOf(validateAddQuarter[listSize-1]);
            system.debug('lastQuarter....'+lastQuarter);
            validateAddQuarter.remove(listSize-1);
            }
            
            for(String qr:validateAddQuarter){
                String pos='';
                pos = String.ValueOf(lastQuarter-i);
                system.debug('pos...'+pos);
                if(!missQuarter.contains(pos)){
                    displayPopup = false;
                    displaypopquarter=true;
                    count=1;
                    apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Quarters are missing'));
                    break;
                }
                else{
                i++;
                }
                
            }
            if(count==0){
           displayPopup = true;
           }
           
           addquarter.sort();
           system.debug('addquarter...'+addquarter);
           //addDummyQuarter = addquarter;
           //addquarter.remove(0);
           
           //Quarter Formats like Q1-Q4
           if(addquarter.size()>1){
                    quarterformat=addquarter.get(0)+'-'+addquarter.get(addquarter.size()-1);           
               
               }
                else{
                    quarterformat=addquarter.get(0);
                }               
           
           for(String addquart:addQuarter){
                  QuarterName=QuarterName+addquart+';';
             }
           }
                       
                 
            QuarterName = QuarterName.removeEnd(';');
            changedBrandName = changedBrandName+ quarterformat +' ';
            changedBrandName=changedBrandname + B.BrandRecord.AF_Fiscal_Year__c;
           
            addquarter.clear(); 
            validateAddQuarter.clear();         
            ChangedBrand.put(B.BrandRecord.Id,changedBrandName);
            ChangedQuarter.put(B.BrandRecord.Id,QuarterName);
            String raiseQuarter='';
            if(B.Q1 == true){
            raiseQuarter = 'Q1';
            }
            if(B.Q2 == true){
            raiseQuarter = raiseQuarter+';'+'Q2';
            }
            if(B.Q3 == true){
            raiseQuarter = raiseQuarter+';'+'Q3';
            }
            if(B.Q4 == true){
            raiseQuarter = raiseQuarter+';'+'Q4';
            }
            
            BackupQuarter.put(B.BrandRecord.Id,raiseQuarter);
           
                 
         }
       }
       if(selectedBrandEstimateIds.size()==0)
           {
           displayPopup = false;
            apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Please select current base fee name,Which you want to update'));   // Page message to select atleast one records for update
               
           }
           else if(displaypopquarter!= true){
           displayPopup = true;
           }            
            
    }
      
  //Update Brand Estimate
  Public void saveBrandEstimate(){
    updateBrandEstimate = new list<AF_Brand_Estimate__c>();
    
    /** Get User Email ID **/                       
    String userID = UserInfo.getUserID();
    User activeUser = [Select Email From User where ID = :userID limit 1];
    String userEmail = activeUser.Email;
       
    for(AF_Brand_Estimate__c eBrand: [select AF_Active__c,ID,UserEmail__c,AF_BackupQuarter__c,IsUpdate__c,Brand__r.name,name,AF_Basefee_Estimate_Initial_Quarter__c from  AF_Brand_Estimate__c where Id IN:selectedBrandEstimateIds]){
    eBrand.UserEmail__c= userEmail ;
    eBrand.name = changedBrand.get(eBrand.ID);
    eBrand.AF_Basefee_Estimate_Initial_Quarter__c = ChangedQuarter.get(eBrand.ID);
    eBrand.IsUpdate__c=true; 
    eBrand.AF_BackupQuarter__c = BackupQuarter.get(eBrand.ID);
    updateBrandEstimate.add(eBrand);
     }
     
     try
     {
     update updateBrandEstimate; // Update brand estimate records
     displayPopup = false;
     queryBrandEstimate();
     apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,'Selected current base fee name has been updated'));  // selected records have been saved
     ControlToFocus = 'zipCodeFocus();';
     }
     catch(Exception e)
     {
     
     }
    
 }

  // Wrapper class,used for checkbox, Brand estimate name, Quarter and Brand estimate records,
  Public class wrapChechbox  {
  
    public AF_Brand_Estimate__c BrandRecord{get;set;}
    public String BN{get;set;}
    public Boolean Q1 {get; set;}
    public Boolean Q2 {get; set;}
    public Boolean Q3 {get; set;}
    public Boolean Q4 {get; set;} 
    public Boolean selected{get;set;}
    
     
     public wrapChechbox(AF_Brand_Estimate__c eachBrandEstimate,String BrandName,Boolean Quarter1,Boolean Quarter2,Boolean Quarter3,Boolean Quarter4) {
            BrandRecord = eachBrandEstimate;
            BN = BrandName;
            Q1 = Quarter1;
            Q2 = Quarter2;
            Q3 = Quarter3;
            Q4 = Quarter4;
            selected = false;
      }
}
}