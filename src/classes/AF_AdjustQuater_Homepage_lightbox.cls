/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_AdjustQuater_Homepage_lightbox
@CreateDate : 6/6/2014
@Description : This is a controller class for AF_AjustBaseQuater Page, 
@              this is used to adjust the quarters of the BrandEstimate.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_AdjustQuater_Homepage_lightbox{
    public string ControlToFocus{get;set;}
    public list<AF_Brand_Estimate__c> brandEstimate{get;set;}// Create Brand Estimate object list
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
    public Map<id,String>ChangedBrand=new map<id,String>();// to store Id along with changed Brand estimate name    
    public Map<id,String>ChangedQuarter=new map<id,String>();  // to store id along with changed quarters
    public Map<id,String>BackupQuarter=new map<id,String>();
    public list<AF_Brand_Estimate__c> queryBrandEstimateRecords{get;set;}// to store Brand estimate records
    public String raiseNewPOQuarters=''; 
    private list<String> validateAddQuarter=new list<String>();
    private list<String>addQuarter=new list<String>();
    String quarterformat;
    String QuarterName;
    String changedBrandName;
    private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
    /**********************************************************************
*  @Description: Contructor method
*  @name : AF_AdjustQuater_Homepage_lightbox
*  @param : none
*  @return : none
*************************************************************************/    
    public AF_AdjustQuater_Homepage_lightbox(){
        sortDir =null;
        displaypopquarter=false;
        /** Get Category and FYear from Homepage **/           
        Category=ApexPages.currentPage().getParameters().get(AF_Constants.CATEGORY);
        Year=ApexPages.currentPage().getParameters().get(AF_Constants.YEAR);     
        /** Call QueryBrandEstimate Method **/
        queryBrandEstimate();
    }
    /**********************************************************************
*  @Description: this method is called from constructor and used to populate quarters
*  @             for each brandEstimate.
*  @name : queryBrandEstimate
*  @param : none
*  @return: none.
**********************************************************************/
    public void queryBrandEstimate(){
        QuarterEstimate =  new list<wrapChechbox>();
        queryBrandEstimateRecords = new List<AF_Brand_Estimate__c>();
        if(sortDir ==  null){
            sortDir =AF_Constants.SORT_ORDER_ASC;    
        }
        else{
            sortDir = AF_Constants.SORT_ORDER_ASC.equals(sortDir)?  AF_Constants.SORT_ORDER_DESC: AF_Constants.SORT_ORDER_ASC ;
        }
        String soql = 'SELECT name,AF_Basefee_Estimate_Initial_Quarter__c,AF_RaiseNewPOQuarters__c,AF_BackupQuarter__c,Brand__r.Name,AF_Agency__r.Name,Brand__c,AF_Fiscal_Year__c FROM AF_Brand_Estimate__c WHERE AF_Fiscal_Year__c =\''+year+'\'  AND AF_Active__c=True AND AF_Status_Base_Fees__c!=\''+'Ready for PO' +'\' ORDER BY name';
        soql = soql +' '+sortDir+' ' + 'LIMIT 1000';
        queryBrandEstimateRecords = Database.query(soql);
        for(AF_Brand_Estimate__c eachBrandEstimate:queryBrandEstimateRecords){
            // Check all Brand Estimate quarters like Q1,Q2,Q3,Q4      
            if('' != eachBrandEstimate.AF_BackupQuarter__c ){
                Quarter1 = false;
                Quarter2 = false;
                Quarter3 = false;
                Quarter4 = false;
                String Quarters = '';
                Quarters  = eachBrandEstimate.AF_BackupQuarter__c;
                Quarter = '';
                if(Quarters != null){
                    if(Quarters.contains(AF_Constants.QUARTER1)){
                        Quarter1 = true;
                        Quarter = AF_Constants.QUARTER1;
                    }
                    if(Quarters.contains(AF_Constants.QUARTER2)){
                        Quarter2 = true;
                        Quarter = Quarter + AF_Constants.QUARTER2;
                    }
                    if(Quarters.contains(AF_Constants.QUARTER3)){
                        Quarter3 = true;
                        Quarter = Quarter + AF_Constants.QUARTER3;
                    }
                    if(Quarters.contains(AF_Constants.QUARTER4)){
                        Quarter4 = true;
                        Quarter = Quarter + AF_Constants.QUARTER4;
                    }
                }
            }
            BrandName = '';
            BrandName = eachBrandEstimate.name;
            QuarterEstimate.add(new wrapChechbox(eachBrandEstimate,BrandName,Quarter1,Quarter2,Quarter3,Quarter4)); 
        }
    }
    /**********************************************************************
*  @Description: this method is to close the popup window.
*  @name : closePopup
*  @param : none
*  @return: none
**********************************************************************/
    public void closePopup() { 
        displayPopup = false;    
    } 
    /***********************************************************************************************************
*  @Description: this method is used to show the popup window with quarter values populated for BrandEstimate  
@   and update the quarter's for records based on the existing quarter's available for that record
@   and changes the brandestimate name repectively and display's the used quarter's.
*  @name : showPopup
*  @param : none
*  @return: none
***************************************************************************************************/
    public void showPopup() {
        selectedBrandEstimateIds = new Set<String>();
        String raiseNewPOQuarters;
        for(wrapChechbox B:QuarterEstimate){
            if(B.selected){
                changedBrandName = '';
                raiseNewPOQuarters='';
                QuarterName='';
                if(B.BrandRecord.AF_RaiseNewPOQuarters__c!=null){
                    raiseNewPOQuarters = B.BrandRecord.AF_RaiseNewPOQuarters__c;
                }
                selectedBrandEstimateIds.add(B.BrandRecord.Id);
                changedBrandName = B.BrandRecord.Brand__r.Name +'-';     
                changedBrandName=changedBrandname+B.BrandRecord.AF_Agency__r.Name +' '; 
                if(B.Q1 && !raiseNewPOQuarters.contains(AF_Constants.QUARTER1) ){
                    addquarter.add(AF_Constants.QUARTER1);
                }
                if(B.Q2 && !raiseNewPOQuarters.contains(AF_Constants.QUARTER2) ){
                    addquarter.add(AF_Constants.QUARTER2);     
                }
                if(B.Q3 && !raiseNewPOQuarters.contains(AF_Constants.QUARTER3)){
                    addquarter.add(AF_Constants.QUARTER3);
                }
                if(B.Q4 && !raiseNewPOQuarters.contains(AF_Constants.QUARTER4)){
                    addquarter.add(AF_Constants.QUARTER4);
                }
                showPopupExtension(B);
                showRaiseQuarter(B);
             }   
        }
        if(selectedBrandEstimateIds.isEmpty() )
        {
            displayPopup = false;
            apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Base_Fee_Name));   // Page message to select atleast one records for update
        }
        else if(!displaypopquarter){
            displayPopup = true;
        }            
    }
    
private void showPopupExtension(wrapChechbox B){
                
                if(addquarter.IsEmpty()){
                    displaypopquarter=true; 
                    apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Base_Fee_Quarter)); // Quarter value can not be empty
                }
                else{
                    String missQuarter='';
                    Integer count=0;
                    for(String qr:addquarter){
                        qr = qr.remove('Q');
                        missQuarter = missQuarter+qr;
                        validateAddQuarter.add(qr);
                    }
                    Integer i=1;
                    Integer listSize=validateAddQuarter.size(); 
                    Integer lastQuarter=0;
                    if( !validateAddQuarter.isEmpty() ){
                        lastQuarter = Integer.ValueOf(validateAddQuarter[listSize-1]);
                        validateAddQuarter.remove(listSize-1);
                    }
                    for(String qr:validateAddQuarter){
                        String pos='';
                        pos = String.ValueOf(lastQuarter-i);
                        if(!missQuarter.contains(pos)){
                            displayPopup = false;
                            displaypopquarter=true;
                            count=1;
                            apexpages.addmessage(new apexpages.message(apexpages.severity.error,Label.AF_Missing_Quarters));
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
                    showBrandName(B);
                }
                QuarterName = QuarterName.removeEnd(';');
                changedBrandName = changedBrandName+ quarterformat +' ';
                changedBrandName=changedBrandname + B.BrandRecord.AF_Fiscal_Year__c;
                addquarter.clear(); 
                validateAddQuarter.clear();         
                ChangedBrand.put(B.BrandRecord.Id,changedBrandName);
                ChangedQuarter.put(B.BrandRecord.Id,QuarterName);
}
public void showBrandName(wrapChechbox B){
                    quarterformat='';
                    quarterformat='';
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
                    system.debug('addQuarter...'+addQuarter);
                   system.debug('QuarterName...'+QuarterName);
                
}

public void showRaiseQuarter(wrapChechbox B){
                String raiseQuarter='';
                if(B.Q1){
                    raiseQuarter = AF_Constants.QUARTER1;
                }
                if(B.Q2){
                    raiseQuarter = raiseQuarter+';'+AF_Constants.QUARTER2;
                }
                if(B.Q3){
                    raiseQuarter = raiseQuarter+';'+AF_Constants.QUARTER3;
                }
                if(B.Q4){
                    raiseQuarter = raiseQuarter+';'+AF_Constants.QUARTER4;
                }
                BackupQuarter.put(B.BrandRecord.Id,raiseQuarter);
}               
    /**********************************************************************
*  @Description: this method is to update and adjust the quarters 
@             BrandEstimate.
*  @name : saveBrandEstimate
*  @param : none
*  @return: none
**********************************************************************/
    public void saveBrandEstimate(){
        updateBrandEstimate = new list<AF_Brand_Estimate__c>();
        /** Get User Email ID **/                       
        String userID = UserInfo.getUserID();
        User activeUser = [Select Email From User where ID = :userID limit 1];
        String userEmail = activeUser.Email;
        for(AF_Brand_Estimate__c eBrand: [SELECT AF_Active__c,ID,UserEmail__c,AF_BackupQuarter__c,IsUpdate__c,Brand__r.name,name,AF_Basefee_Estimate_Initial_Quarter__c FROM  AF_Brand_Estimate__c WHERE Id IN:selectedBrandEstimateIds]){
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
            apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,Label.AF_Base_Fee_Updated));  // selected records have been saved
            ControlToFocus = AF_Constants.ZIPCODE_FOCUS;
        }
        catch(Exception e)
        {
            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'saveBrandEstimate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
        }
    }
    /**********************************************************************
*  @Description: this is the Wrapper class to populate the quarters in 
@            checkbox BrandEstimate name.
*  @name : wrapChechbox
*  @param : none
*  @return: none
**********************************************************************/
    public class wrapChechbox  {
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