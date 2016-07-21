public with sharing class AF_BonusMatrixOverrideController 
{
        public string ParentId {get;set;}
        public AF_Bonus_Matrix__c BonusMatrixObj {get;set;}
         public decimal EsLocal{get;set;}
         public decimal TotalBonusValue;
         public String brandid;
         public String agencyid;
         public String fyear;
         public Boolean IsReadonlyPO{get;set;}
         public Boolean IsShowPOTab{get;set;}
         public set<String> bonusresultid=new set<String>();
         public list<AF_Bonus_Matrix__c>listofbonusmatrix=new list<AF_Bonus_Matrix__c>();
         public list<AF_Bonus_Results__C>listofbonusresult=new list<AF_Bonus_Results__C>();
         public decimal totalMatrixbonus;
         public decimal totalbonusresult;
         public Boolean IsReadyforPO{get;set;}
         Public user LoggedinUser{set;get;}
         public boolean SubmitButtonDisplay {set;get;}
         public boolean isPOEditable{get;set;}
         public boolean isBonusEstimateEdit{get;set;}
         public string bonus_summaryid;
         public String BonusMatrixValue{     
         get{String result = '';if(BonusMatrixObj.AF_Value__c!= null){if(BonusMatrixObj.AF_Value__c > 0) {result = BonusMatrixObj.AF_Value__c.format();}else{result ='';}}return result;}
         set{/*System.debug('TraditionalDisplay: ' + value);*/value = CommaFilter(value);System.debug('BonusMatrixObj.AF_Value__c ' + value);if(value != ''){BonusMatrixObj.AF_Value__c = Decimal.valueOf(value);}else{BonusMatrixObj.AF_Value__c = 0.00;}}
    }
        public AF_BonusMatrixOverrideController()
        {
                try   
               
        {
         bonus_summaryid='';
         IsShowPOTab=false;
         IsReadonlyPO=false;    
         TotalBonusValue=0;  
         totalMatrixbonus=0;  
         brandid='';
         agencyid='';
         fyear=''; 
         totalbonusresult=0; 
         IsReadyforPO=false; 
         isPOEditable=false;
         isBonusEstimateEdit=false;
         listofbonusmatrix=new list<AF_Bonus_Matrix__c >();
         listofbonusresult=new list<AF_Bonus_Results__C>();
         bonusresultid=new set<String>();
         
          LoggedinUser=[select id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c,profile.name  from  User  where id=:Userinfo.getuserid()   and IsActive=true  Order by CreatedDate Limit 50000];             
         if(LoggedinUser.AF_Agency_Fees_User_Type__c!=null){
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Controller' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Regional Category Finance'){
                isPOEditable=true;
            }
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance'){
                isBonusEstimateEdit=true;
            }
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Procurement'   || LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency'){
            IsReadonlyPO=true;
               }
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance'|| LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Procurement' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Controller' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Regional Category Finance'|| LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency' ){
            IsShowPOTab=true;
               }  
           }
            system.debug('id-----'+ApexPages.currentPage().getParameters().get('Id'));
            if(ApexPages.currentPage().getParameters().get('Id') != null)
            {
                ParentId = ApexPages.currentPage().getParameters().get('Id');
                system.debug('ParentId '+ ParentId );                               
                BonusMatrixObj = [Select a.AF_Bonus_Summary__r.AF_Status__c,a.AF_Bonus_Summary__r.id,a.AF_Bonus_Results__r.id, a.AF_Bonus_Results__r.AF_Bonus_Thresholds__r.Agency_Name__c,a.AF_Bonus_Results__r.AF_Bonus_Thresholds__r.Brand_Name__c,a.PO_Number__c,a.Unilever_Entity_Name__c,a.Agency_Entity_Name__c,a.AF_Bonus_Local_Value__c, a.Name, a.LastViewedDate, a.IsDeleted, a.Id, a.Category__c, a.Brand__c, a.AF_Value__c, a.AF_Value_Local__c, a.AF_Unilever_Entity__c, a.AF_Unilever_Entity_Column_Name__c, a.AF_Status__c, a.AF_Rate_Type__c, a.AF_Rate_Currency__c, a.AF_IsCrossBorder__c, a.AF_Fiscal_Year__c, a.AF_Brand_Estimate__c, a.AF_Bonus_Summary__c, a.AF_Bonus_Results__c, a.AF_Agency_Spot_Rate__c, a.AF_Agency_Exchange_Rate__c, a.AF_Agency_Entity__c, a.AF_Bonus_Results__r.AF_Bonus_Value_Bm__c, a.AF_Agency_Entity_Column_Name__c From AF_Bonus_Matrix__c a WHERE Id =:ParentId LIMIT 1];                
                TotalBonusValue=BonusMatrixObj.AF_Bonus_Results__r.AF_Bonus_Value_Bm__c;
                brandid=BonusMatrixObj.AF_Bonus_Results__r.AF_Bonus_Thresholds__r.Brand_Name__c;
                agencyid=BonusMatrixObj.AF_Bonus_Results__r.AF_Bonus_Thresholds__r.Agency_Name__c;
                fyear= BonusMatrixObj.AF_Fiscal_Year__c;
                bonus_summaryid=BonusMatrixObj.AF_Bonus_Summary__r.id;
                EsLocal=BonusMatrixObj.AF_Bonus_Local_Value__c;
                system.debug('BonusMatrixObj.AF_Status__c'+ BonusMatrixObj.AF_Status__c);
                if(BonusMatrixObj.AF_Bonus_Summary__r.AF_Status__c=='Ready for PO'){
                 IsReadyforPO=true;
                }
               
              // listofbonusmatrix=[Select id,AF_Bonus_Results__r.id,AF_Value__c from AF_Bonus_Matrix__c where AF_Bonus_Results__r.AF_Bonus_Thresholds__r.Agency_Name__c=:agencyid and AF_Bonus_Results__r.AF_Bonus_Thresholds__r.Brand_Name__c=:brandid and AF_Fiscal_Year__c=:fyear ];
                listofbonusmatrix=[Select id,AF_Bonus_Results__r.id,AF_Value__c from AF_Bonus_Matrix__c where AF_Bonus_Summary__r.id=:bonus_summaryid];
                system.debug('listofbonusmatrix'+listofbonusmatrix);
                if(listofbonusmatrix.size()>0){
                    for(AF_Bonus_Matrix__c  bm:listofbonusmatrix){
                      if(bm.id!=ParentId){
                       totalMatrixbonus=totalMatrixbonus+bm.AF_Value__c;
                      }
                     bonusresultid.add(bm.AF_Bonus_Results__r.id);
                    }
                    system.debug('totalMatrixbonus'+totalMatrixbonus);
                }
                system.debug('bonusresultid -----'+bonusresultid);
                listofbonusresult=[select id,AF_Total_Bonus_Value__c from AF_Bonus_Results__C where id IN:bonusresultid ];
                system.debug('listofbonusresult ---'+listofbonusresult);
                if(listofbonusresult.size()>0){
                    for(AF_Bonus_Results__C bs:listofbonusresult){
                        if(bs.AF_Total_Bonus_Value__c!=Null){
                        totalbonusresult=totalbonusresult+bs.AF_Total_Bonus_Value__c;
                        }
                    }
                    system.debug('totalbonusresult'+totalbonusresult);
                }
                
                 if(BonusMatrixObj == null)
                {                 
                        BonusMatrixObj = new AF_Bonus_Matrix__c();
                        
                }
                else{
                EsLocal=BonusMatrixObj.AF_Bonus_Local_Value__c;
                }                                           
            }
        }
        catch(Exception ex) 
        {
            System.debug('Exception ----'+ex.getMessage());
        }
        }
        
        
         public PageReference Save()
    {        
        try
        {
                if(BonusMatrixValue!=null){
                    Decimal pureMatrixBonus = Decimal.valueof(BonusMatrixValue.Remove(','))+totalMatrixbonus;
                if(pureMatrixBonus>math.round(totalbonusresult)){
                 apexpages.addmessage(new apexpages.message(apexpages.severity.Error,' Override Bonus Value can not be more than Total Bonus. Override Bonus: ' + pureMatrixBonus + ' Total Bonus: ' + math.round(totalbonusresult)));                  
                 }
                else{
                BonusMatrixObj.AF_Overidden__c = true;
                update BonusMatrixObj;
                CalculateLocalC();
                apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved'));          
                 }
               }
               else{
                
               }
              }
        catch(Exception ex)
        {
                BonusMatrixObj.AF_Overidden__c = true;
                update BonusMatrixObj;
                CalculateLocalC();
                apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved'));  
        }
        //PageReference pageRef = new PageReference('/apex/af_bonusmatrix?Id=' + BonusMatrixObj.AF_Bonus_Summary__c);        
        //pageRef.setRedirect(true);                
        //PageReference pageRef = new PageReference('/apex/AF_CloseAndRefresh?IsError=false');    
           // pageRef.setRedirect(true);
     //   return pageRef;
     return null;
        
    }
    private string CommaFilter(string value)
    {
        if(value.contains(',') == true){value = value.replaceAll(',','');}
        return value;       
    } 
  public void CalculateLocalC(){
        try{
        if(BonusMatrixValue!=null || BonusMatrixValue!=''){
        String bonusvalue=BonusMatrixValue.Remove(',');
        EsLocal=Decimal.valueof(bonusvalue)*BonusMatrixObj.AF_Agency_Exchange_Rate__c;
       // BonusMatrixObj.AF_Bonus_Local_Value__c=(EsLocal);
         }
         }
         catch(exception e){
         if(BonusMatrixValue==''){
         EsLocal=0;
         }
         }
        
      }
      
    Public void SavePo(){
        
        update BonusMatrixObj;
        apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved'));          
        
    }            
          
}