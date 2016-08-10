/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_RaisenewPO_Homepage_lightbox
@CreateDate : 6/6/2014
@Description : This is a controller class for AgencyHomePage Page, 
@        this is used to raise new PO's for BrandEstimate.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_RaisenewPO_Homepage_lightbox{
  public list<AF_Brand_Estimate__c> brandEstimate{get;set;}
  public Boolean Quarter1;
  public Boolean Quarter2;
  public Boolean Quarter3;
  public Boolean Quarter4;
  public String sortDir{get;set;}
  public Boolean RaisePo{get;set;}
  public String BrandName{get;set;}
  public String selectedQuarters{ get; set; }
  public String selectedId{get;set;}
  public Boolean noBrandEstimateRecords{get;set;}
  public list<wrapChechbox> QuarterEstimate{get;set;}
  public list<AF_Brand_Estimate__c> updateBrandEstimate{get;set;}
  public list<AF_Brand_Estimate__c> createBrandEstimate{get;set;}
  public list<AF_Brand_Estimate__c> queryBrandEstimateRecords{get;set;}
  public list<AF_Agency_Estimate__c> updateAgencyEstimate{get;set;}
  public list<AF_Agency_Estimate__c> createAgencyEstimate{get;set;}
  public list<AF_Agency_Estimate__c> archivedAgencyEstimate{get;set;}
  public Set<String> selectedBrandEstimateIds{get;set;}
  public Set<String> newBrandEstimateIds{get;set;}
  public Map<String,String> tempvalueMap = new Map<String,String>();
  public List<SelectOption> Commprefvalue = new List<SelectOption>();
  public Map<String,String> backupBrandQuarter = new Map<String,String>();
  public list<wrapChechbox> QuarterBackupEstimate{get;set;}
  public String category{get;set;} 
  public String year{get;set;}
  Integer counter;
  Integer countOfSelectedBaseFee;
  public Boolean displayPopup{get;set;}
  String newQuarter;
  List<String> gapQuarter;
  private static string className_STR=AF_RaisenewPO_Homepage_lightbox.class.getName();
  List<String>addQuarter=new List<String>();
  String brandQuarter;
  String newBrandName;
  /**********************************************************************
*  @Description: Contructor method
*  @name : AF_RaisenewPO_Homepage_lightbox
*  @param : none
*  @return : none
*************************************************************************/
  public AF_RaisenewPO_Homepage_lightbox(){
    sortDir =null;
    noBrandEstimateRecords=false;
    category = System.currentPageReference().getParameters().get('category');
    year=ApexPages.currentPage().getParameters().get('Year');
    queryBrandEstimate();
  }
  /***********************************************************************************
*  @Description: this method is used to close the popup window
*  @name : closePopup
*  @param : none
*  @return: none.
*************************************************************************************/
  public void closePopup() { 
    displayPopup = false;    
  } 
  /***********************************************************************************
*  @Description: this method is used to query the Brandestimate and the quarters
*  @name : queryBrandEstimate
*  @param : none
*  @return: none.
*************************************************************************************/
  public void queryBrandEstimate(){
    QuarterEstimate =  new list<wrapChechbox>();
    QuarterBackupEstimate=  new list<wrapChechbox>();
    queryBrandEstimateRecords = new List<AF_Brand_Estimate__c>();
    if(sortDir ==  null){
      sortDir = AF_Constants.SORT_ORDER_ASC;    
    }
    else{
      sortDir = sortDir.equals(AF_Constants.SORT_ORDER_ASC) ? AF_Constants.SORT_ORDER_DESC : AF_Constants.SORT_ORDER_ASC;
    }
    String soql = 'select name,AF_Basefee_Estimate_Initial_Quarter__c,AF_RaiseNewPOQuarters__c,AF_BackupQuarter__c,AF_Pilot_Model__c,Archived_BrandEstimate_Quarter__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c,Brand__r.Name,AF_Agency__r.Name,Brand__c,AF_Fiscal_Year__c from AF_Brand_Estimate__c where AF_Status_Base_Fees__c = \'Ready for PO\' and AF_Fiscal_Year__c =\''+year+'\'  and AF_Active__c=True and AF_Controller_Flag__c=False order by name';
    soql = soql +' '+sortDir+' '+ 'limit 49999';
    queryBrandEstimateRecords = Database.query(soql);
    for(AF_Brand_Estimate__c eachBrandEstimate:queryBrandEstimateRecords){
      Quarter1 = false;
      Quarter2 = false;
      Quarter3 = false;
      Quarter4 = false;
      if(eachBrandEstimate.AF_BackupQuarter__c != null){
        String Quarters = '';
        Quarters  = eachBrandEstimate.AF_BackupQuarter__c;
        backupBrandQuarter.put(eachBrandEstimate.Id,eachBrandEstimate.AF_BackupQuarter__c);
        if(Quarters != null){
          if(Quarters.contains(AF_Constants.QUARTER1)){
            Quarter1 = true;
          }
          if(Quarters.contains(AF_Constants.QUARTER2)){
            Quarter2 = true;
          }
          if(Quarters.contains(AF_Constants.QUARTER3)){
            Quarter3 = true;
          }
          if(Quarters.contains(AF_Constants.QUARTER4)){
            Quarter4 = true;
          }
        }
      }
      QuarterEstimate.add(new wrapChechbox(eachBrandEstimate,Quarter1,Quarter2,Quarter3,Quarter4));
      QuarterBackupEstimate.add(new wrapChechbox(eachBrandEstimate,Quarter1,Quarter2,Quarter3,Quarter4));
    }
    if(QuarterEstimate.size()==0){
      noBrandEstimateRecords = false;
      apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_RaiseNewPO_ValidRecords));    
    }
    else{
      noBrandEstimateRecords = true;
    }
  }
  /***********************************************************************************
*  @Description: this method is used to adjust the quarter for an exisitng record and to
*  @             handle the updation of the selected records.This method holds the logic 
         to prepare the data to update the BrandEstimate Adjusted quarters
*  @name : showPopup
*  @param : none
*  @return: none.
*************************************************************************************/
  public void showPopup(){
    list<String> validateAddQuarter=new list<String>();
    countOfSelectedBaseFee =0;
    selectedBrandEstimateIds = new Set<String>();
    gapQuarter = new List<String>();
    newBrandName='';
    String quarterformat='';
    brandQuarter='';
    displayPopup = true;
    for(wrapChechbox B:QuarterEstimate){
      if(B.selected){
        countOfSelectedBaseFee++;
        brandQuarter = '';
        newBrandName = '';
        quarterformat='';
        newQuarter='';
        newBrandName = B.BrandRecord.Brand__r.Name +'-';     
        newBrandName=newBrandName+B.BrandRecord.AF_Agency__r.Name;
        counter=0;
        quarterCalc(B);
        
        newQuarter = newQuarter.removeEnd(';');
        tempvalueMap.put(B.BrandRecord.Id,newQuarter);
        createBackupQuarter();
        if(counter==1){
          this.selectedBrandEstimateIds.add(B.BrandRecord.Id);
        }
        if(counter==0 && countOfSelectedBaseFee!=0){
          displayPopup = False;
          apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Select_Quarter));    
        }
        else{
          String missQuarter='';
          for(String qr:gapQuarter){
            qr = qr.remove('Q');
            missQuarter = missQuarter+qr;
            validateAddQuarter.add(qr);
          }
          Integer i=1;
          Integer listSize=validateAddQuarter.size(); 
          Integer lastQuarter=0;
          if(validateAddQuarter.size()>0){
            lastQuarter = Integer.ValueOf(validateAddQuarter[listSize-1]);
            validateAddQuarter.remove(listSize-1);
          }
          for(String qr:validateAddQuarter){
            String pos='';
            pos = String.ValueOf(lastQuarter-i);
            if(!missQuarter.contains(pos)){
              displayPopup = false;
              apexpages.addmessage(new apexpages.message(apexpages.severity.error,Label.AF_Missing_Quarters));
              break;
            }
            else{
              i++;
            }
          }
        }
        tempvalueMap.clear();
        addquarter.sort();
        if(addquarter.size()>1){
          quarterformat=addquarter.get(0)+'-'+addquarter.get(addquarter.size()-1);           
        }
        else if(addquarter.size()==1){
          quarterformat=addquarter.get(0);
        }               
        for(String addquart:addQuarter){
          brandQuarter=brandQuarter+addquart+';';
        }
        addquarter.clear();
        gapQuarter.clear();
        validateAddQuarter.clear();
        brandQuarter = brandQuarter.removeEnd(';');
        newBrandName = newBrandName+'-'+quarterformat +' ';
        newBrandName=newBrandName + B.BrandRecord.AF_Fiscal_Year__c;
        createNewBrandEst(B);
      }
    }
    if(countOfSelectedBaseFee==0 && QuarterEstimate.size()>0)
    {   displayPopup = False;
      apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Select_Current_BaseFee)); 
      sortDir = sortDir.equals(AF_Constants.SORT_ORDER_ASC) ?AF_Constants.SORT_ORDER_DESC : AF_Constants.SORT_ORDER_ASC;
      queryBrandEstimate();
    }
  }
  /***********************************************************************************
*  @Description: this method is used to adjust the quarter for an exisitng record and to
*  @             handle the updation of the selected records.this hold the logic to upadte
         the backupquarter fields
*  @name : createBackupQuarter
*  @param : none
*  @return: none.
*************************************************************************************/  
  public void createBackupQuarter(){
    List<String> tempSplit = new List<String>();
        if(tempvalueMap.size()>0){
          for(String key:backupBrandQuarter.keySet()){  
            for(String keyNewValue:tempvalueMap.keySet()){ 
              if(key==keyNewValue && tempvalueMap.get(keyNewValue)!=backupBrandQuarter.get(key)){
                tempSplit = tempvalueMap.get(keyNewValue).split(';');
                for(String t:tempSplit){
                  if(!backupBrandQuarter.get(key).contains(t)){
                    addquarter.add(t);
                  }
                }
                counter =1;
              }
            }
          }
        }
  }
  /***********************************************************************************
*  @Description: this method is used to adjust the quarter for an exisitng record and to
*  @             handle the updation of the selected records.
*  @name : quarterCalc
*  @param : wrapChechbox
*  @return: none.
*************************************************************************************/  
  public void quarterCalc(wrapChechbox B){
    if(B.Q1){
          newQuarter = newQuarter+'Q1;';
          gapQuarter.add(AF_Constants.QUARTER1);
        }
        if(B.Q2){
          newQuarter = newQuarter+'Q2;';
          gapQuarter.add(AF_Constants.QUARTER2);
        }
        if(B.Q3){
          newQuarter = newQuarter+'Q3;';
          gapQuarter.add(AF_Constants.QUARTER3);
        }
        if(B.Q4){
          newQuarter = newQuarter+'Q4;';
          gapQuarter.add(AF_Constants.QUARTER4);
        }
  }
  /***********************************************************************************
*  @Description: this method is used to create new brandestimate record and also to archive
         the old BrandEstimate record.
*  @name : quarterCalc
*  @param : wrapChechbox
*  @return: none.
*************************************************************************************/    
  public void createNewBrandEst(wrapChechbox B){
    createBrandEstimate = new list<AF_Brand_Estimate__c>();
        AF_Brand_Estimate__c createBrand = new AF_Brand_Estimate__c();
        createBrand.name = newBrandName;
        createBrand.Brand__c = B.BrandRecord.Brand__c;
        createBrand.AF_Agency__c = B.BrandRecord.AF_Agency__c;
        createBrand.AF_Basefee_Estimate_Initial_Quarter__c = brandQuarter;
        createBrand.AF_Fiscal_Year__c = B.BrandRecord.AF_Fiscal_Year__c;
        createBrand.BrandEstimateArchivedId__c = B.BrandRecord.Id;
        createBrand.TriggerEmailAgency__c = True;
        createBrand.AF_Active__c = True;
        if(B.BrandRecord.AF_Traditional__c!=null)
        createBrand.AF_Traditional__c= B.BrandRecord.AF_Traditional__c;
        if(B.BrandRecord.AF_Digital__c!=null)
        createBrand.AF_Digital__c = B.BrandRecord.AF_Digital__c;
        if(B.BrandRecord.AF_Adaptive__c!=null)
        createBrand.AF_Adaptive__c = B.BrandRecord.AF_Adaptive__c;
        createBrand.Archived_BrandEstimate_Quarter__c = newQuarter;
        createBrand.AF_Status_Base_Fees__c = AF_Constants.BASE_FEES_WITH_AGENCY;
        createBrand.AF_BackupQuarter__c = newQuarter;
        }
        /***********************************************************************************
*  @Description: this method is used to track the raise new po quarters
*  @name : quarterCalc
*  @param : wrapChechbox
*  @return: none.
*************************************************************************************/ 
       public void createNewBrandEstimate(wrapChechbox B)
       {
       AF_Brand_Estimate__c createBrand = new AF_Brand_Estimate__c();
        if(B.BrandRecord.AF_RaiseNewPOQuarters__c==null){
          createBrand.AF_RaiseNewPOQuarters__c = B.BrandRecord.AF_Basefee_Estimate_Initial_Quarter__c;
        }
        else{
          List<String> raiseQuarters = new List<String>();
          List<String> raiseQuartersTempList = new List<String>();
          String raiseNewQuarter='';
          raiseNewQuarter = B.BrandRecord.AF_RaiseNewPOQuarters__c;
          if(raiseNewQuarter!=null){
            raiseQuarters = raiseNewQuarter.split(';');
          }
          raiseNewQuarter='';
          raiseNewQuarter = B.BrandRecord.AF_Basefee_Estimate_Initial_Quarter__c;
          if(raiseNewQuarter!=null){
            raiseQuartersTempList = raiseNewQuarter.split(';');
          }
          for(String temp:raiseQuartersTempList){
            raiseQuarters.add(temp);
          }
          raiseNewQuarter ='';
          Set<String> raiseQuartersSet = new Set<String>();
          if(raiseQuarters.size()>0){
            raiseQuartersSet.addAll(raiseQuarters);
          }
          for(String s:raiseQuartersSet){
            raiseNewQuarter = raiseNewQuarter+s+';';
          }
          if(raiseNewQuarter!=null){
            raiseNewQuarter = raiseNewQuarter.removeEnd(';');
            createBrand.AF_RaiseNewPOQuarters__c = raiseNewQuarter;
          }
        }
        if(B.BrandRecord.AF_Traditional__c!=null && B.BrandRecord.AF_Digital__c!=null && B.BrandRecord.AF_Adaptive__c!=null)
        createBrand.Archived_BrandEstimate_BaseFee__c = B.BrandRecord.AF_Traditional__c+B.BrandRecord.AF_Digital__c+B.BrandRecord.AF_Adaptive__c;
        createBrand.CreatedUserEmail__c = UserInfo.getUserEmail();
        createBrand.AF_Pilot_Model__c = B.BrandRecord.AF_Pilot_Model__c;
        createBrandEstimate.add(createBrand);
  }
  /***********************************************************************************
*  @Description: this method is used to insert the BrandEstimate and AgencyEstimate
*  @             and moves the status of new record to with Agency
*  @name : saveBrandEstimate
*  @param : none
*  @return: none.
*************************************************************************************/
  public void saveBrandEstimate(){
    updateAgencyEstimate = new list<AF_Agency_Estimate__c>();
    createAgencyEstimate = new list<AF_Agency_Estimate__c>();
    archivedAgencyEstimate = new list<AF_Agency_Estimate__c>();
    updateBrandEstimate = new list<AF_Brand_Estimate__c>();
    newBrandEstimateIds = new Set<String>();
    for(AF_Brand_Estimate__c eBrand: [select AF_Active__c,name,AF_Basefee_Estimate_Initial_Quarter__c from  AF_Brand_Estimate__c where Id IN:selectedBrandEstimateIds]){
      eBrand.AF_Active__c = False;
      updateBrandEstimate.add(eBrand);
    }
    for(AF_Agency_Estimate__c agencyEstimate:[select name,AF_Brand_Estimate__c,AF_Fiscal_Year__c,AF_Unilever_Entity__c,AF_Agency_Entity__c,AF_Adaptation__c,AF_Digital__c,AF_Traditional__c,AF_Quarter_PO_Raised__c,AF_Quarter__c from AF_Agency_Estimate__c where AF_Brand_Estimate__c IN:selectedBrandEstimateIds]){
      archivedAgencyEstimate.add(agencyEstimate);
      agencyEstimate.AF_Archived__c = True;
      updateAgencyEstimate.add(agencyEstimate);
    }
    if(updateBrandEstimate.size()>0){
      try{
      update updateBrandEstimate;
      }
      catch(Exception e)
          {
              AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'saveBrandEstimate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
              apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
          }
    }
    if(updateAgencyEstimate.size()>0){
      try{
      update updateAgencyEstimate;
      }
      catch(Exception e)
            {
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'saveBrandEstimate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
            }
    }
    if(createBrandEstimate.size()>0 && selectedBrandEstimateIds.size()>0)
    {
      try{
      insert createBrandEstimate;
      }
      catch(Exception e)
      {
        AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'saveBrandEstimate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
              apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert));
      }
    }
    for(AF_Brand_Estimate__c f:createBrandEstimate){
      newBrandEstimateIds.add(f.Id);
    }
}
    /***********************************************************************************
*  @Description: this method is used to insert the BrandEstimate and AgencyEstimate
*  @             and moves the status of new record to with Agency
*  @name : saveBrandEstimate
*  @param : none
*  @return: none.
*************************************************************************************/
  public void saveBrandEstimateRecords()
  {
    for(AF_Brand_Estimate__c newBrandRecord: [select name,AF_Basefee_Estimate_Initial_Quarter__c,BrandEstimateArchivedId__c from  AF_Brand_Estimate__c where Id IN:newBrandEstimateIds]){
      for(AF_Agency_Estimate__c newAgencyRecord:archivedAgencyEstimate){
        if(newAgencyRecord.AF_Brand_Estimate__c == newBrandRecord.BrandEstimateArchivedId__c){
          AF_Agency_Estimate__c newRecord = new AF_Agency_Estimate__c();
          List<String> noOfOldQuarters = new List<String>();
          String agencyOldQuarter = newAgencyRecord.AF_Quarter__c;
          if(agencyOldQuarter != null){
            noOfOldQuarters = agencyOldQuarter.split(';');
          }
          newRecord.name = newBrandRecord.name;
          newRecord.AF_Brand_Estimate__c = newBrandRecord.Id;
          newRecord.AF_Quarter__c = newBrandRecord.AF_Basefee_Estimate_Initial_Quarter__c;
          newRecord.AF_Fiscal_Year__c = newAgencyRecord.AF_Fiscal_Year__c;
          newRecord.AF_Unilever_Entity__c = newAgencyRecord.AF_Unilever_Entity__c;
          newRecord.AF_Agency_Entity__c = newAgencyRecord.AF_Agency_Entity__c;
          newRecord.AF_Adaptation__c = newAgencyRecord.AF_Adaptation__c;
          newRecord.AF_Digital__c =  newAgencyRecord.AF_Digital__c;
          newRecord.AF_Traditional__c =  newAgencyRecord.AF_Traditional__c;
          newRecord.AF_Previous_PO_Value__c = newAgencyRecord.AF_Quarter_PO_Raised__c;
          newRecord.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
          if(noOfOldQuarters.size()>0)
          newRecord.AF_Previous_Quarters_Done__c = noOfOldQuarters.size();
          createAgencyEstimate.add(newRecord);
        }
      }
    }
    try{
      if(createAgencyEstimate.size()>0){
        insert  createAgencyEstimate;
        apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Brandestimate_Archived));
      }
    }
    catch(Exception e){
      AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'saveBrandEstimate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
      apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert));
    }
    displayPopup = False;
    //SendEmailNotification();
  }
  /***********************************************************************************
*  @Description: this method is used to send email notification to the CMCO Superuser
*  @name : SendEmailNotification
*  @param : none
*  @return: none.
*************************************************************************************/
  public void SendEmailNotification(){
    Set<String>Agency_Name=new set<String>();
    List<AF_Agency_Estimate__c> NewAgencyRecord=new list<AF_Agency_Estimate__c>();
    List<String> AgencySendEmailIds = new List<String>();
    List<Send_Email__c> Send_Email_List=new list<Send_Email__c>();
    for(AF_Agency_Estimate__c af:createAgencyEstimate){
      AgencySendEmailIds.add(af.Id);
    }
    for(AF_Agency_Estimate__c AgencyEstimate: [select Brand__c,Category_Agency__c,AF_Fiscal_Year__c,Agency_Account__c from AF_Agency_Estimate__c where Id IN:AgencySendEmailIds]){
      Agency_Name.add(AgencyEstimate.Agency_Account__c);
      NewAgencyRecord.add(AgencyEstimate);
    }
    list<Contact> Agency_Contact=new list<Contact>();
    Agency_Contact=[Select ID,Name,Account.Name,Email,AF_Send_Email_Notification__c from Contact where AF_Send_Email_Notification__c=true and Account.name IN :Agency_Name];
    if(Agency_Contact.Size()>0){
      for(AF_Agency_Estimate__c A_Estimate:NewAgencyRecord){
        for(Contact AF_Contact:Agency_Contact)
        {
          if(A_Estimate.Agency_Account__c==AF_Contact.Account.Name){
            Send_Email__c NewEmailRecord= new Send_Email__c();
            NewEmailRecord.Brand_Name__c=A_Estimate.Brand__c;
            NewEmailRecord.Category__c=A_Estimate.Category_Agency__c;
            NewEmailRecord.Financial_Year__c=A_Estimate.AF_Fiscal_Year__c;
            NewEmailRecord.URL_link_to_Agency_Fees__c='https://unilever--agfeescog.cs14.my.salesforce.com/a2b/o';
            NewEmailRecord.Angency_Name__c=AF_Contact.Account.Name;
            NewEmailRecord.Contact_Name__c=AF_Contact.Name;
            NewEmailRecord.Contact_Email__c=AF_Contact.Email;
            NewEmailRecord.TriggerEmail__c = true;
            Send_Email_List.add(NewEmailRecord )  ;
          }
        }
      }
    }
    try{
    insert Send_Email_List;
    }
    catch(Exception e)
        {
            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'SendEmailNotification',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert)); 
        }
  }
  /***********************************************************************************
*  @Description: this wrapper class to display the brandestimate and quarters
*  @name : wrapChechbox
*  @param : none
*  @return: none.
*************************************************************************************/
  public class wrapChechbox
  {
    public AF_Brand_Estimate__c BrandRecord{get;set;}
    public Boolean Q1 {get; set;}
    public Boolean Q2 {get; set;}
    public Boolean Q3 {get; set;}
    public Boolean Q4 {get; set;} 
    public Boolean selected{get;set;}  
    public wrapChechbox(AF_Brand_Estimate__c eachBrandEstimate,Boolean Quarter1,Boolean Quarter2,Boolean Quarter3,Boolean Quarter4) {
      BrandRecord = eachBrandEstimate;
      Q1 = Quarter1;
      Q2 = Quarter2;
      Q3 = Quarter3;
      Q4 = Quarter4;
      selected = false;
    }  
  } 
}