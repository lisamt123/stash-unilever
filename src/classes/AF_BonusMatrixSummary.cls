public with sharing class AF_BonusMatrixSummary {

    Public  List<AF_Bonus_Summary__c> bonusSummaries{get;set;}
    public AF_Bonus_Results__c bonusResultObj{get;set;}
    public AF_Bonus_Summary__c bonusSummaryObj{get;set;}
    public Integer bonus {get;set;}//To get bonus 
    public Decimal bonusableFee{get;set;}//To get bonusableFee
    public Integer totalfee{get;set;}//To get totalfee
    public Integer overallbonusPer{get;set;}//To display overallbonusPer
    public Integer qualPer{get;set;}//To display Qualitative bonus
    public Integer quantPer{get;set;}//To display Quantitative bonus
    public String BrandId {get;set;}//To get selected Brand
    public String AgencyId{get;set;}//To get selected Agency
    public Decimal remainingAllowances{get;set;}
    public Decimal BonusTarget{get;set;}
    public Decimal qualValue{get;set;}
    public  Decimal quant{get;set;}
    public Integer totalquant_qual{get;set;}
    public Boolean IsReadyForPO{get;set;}
    public Boolean isCatFinance{get;set;}
    public Boolean isAgencyFlag{get;set;}
   /** construtor **/
   
    public AF_BonusMatrixSummary(ApexPages.StandardController stdController){
     String BonusSummaryId = ApexPages.currentPage().getParameters().get('Id');
   
        IsReadyForPO=false;
        BonusTarget=0;
        totalquant_qual=0;
        bonusSummaryObj= new AF_Bonus_Summary__c();
        Decimal overallBonus=0;
        qualValue=0;
        quant=0;
        Set<Id> threSholdsSet = new Set<Id>();
        bonusableFee=0;
        totalfee=0;
        overallbonusPer=0;
        qualPer=0;
        quantPer=0;
        remainingAllowances=0;
        isCatFinance=false;
        isAgencyFlag=false;
        User userObj = new User();
        userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
        if(userObj.AF_Agency_Fees_User_Type__c=='Category Finance'){
          
                isCatFinance=true;
            
            }
        if(userObj.AF_Agency_Fees_User_Type__c=='Agency'){
          
                isAgencyFlag=true;
            
            }
        
         bonusSummaryObj=[SELECT AF_Status__c,AF_Agency__c,AF_Agency__r.Name,AF_Brand__c,AF_Brand__r.Name,AF_Fiscal_Year__c,AF_Bonus_Matrix_Value__c,AF_Is_Pilot_Model__c,
                            (SELECT AF_Bonus_Results__r.AF_Total_Remuneration__c,AF_Bonus_Results__r.AF_Status__c,AF_Bonus_Results__r.AF_Bonus_Value_Bm__c, AF_Bonus_Results__r.AF_Total_Bonus_Value__c 
                                From Bonus_Matrix__r)
                            FROM AF_Bonus_Summary__c 
                            WHERE id=:BonusSummaryId];
         BrandId=bonusSummaryObj.AF_Brand__c;
         AgencyId=bonusSummaryObj.AF_Agency__c;
         String year=bonusSummaryObj.AF_Fiscal_Year__c;
         if(bonusSummaryObj.AF_Status__c=='Ready For PO'){
           IsReadyForPO=true;
         }
       
         decimal BonusTarget1=0;
        //to store unique Threshold Ids
        Set<ID> ids = new Set<ID>();
        for(AF_Bonus_Threshold__c bonusThObj : [SELECT Id FROM AF_Bonus_Threshold__c Where Agency_Name__c=:AgencyId AND Brand_Name__c=:BrandId AND Year__c=:year]){
            ids.add(bonusThObj.Id);
        }
     
        //Query all Results related to Bonus Thresholds
        for(AF_Bonus_Results__c bonusResultObj :[SELECT AF_Total_Bonus_Value__c,AF_Total_Remuneration__c,
                                                    AF_Bonus_Value_Bm__c,AF_Bonusable_Fees__c,AF_Total_bonus_fees__c,
                                                    AF_Total_Bonus__c,AF_Quant_Bonus_Value__c,AF_Qual_Bonus_Value__c
                                                    FROM AF_Bonus_Results__c 
                                                    WHERE AF_Bonus_Thresholds__c IN:ids AND recordType.Name='Bonus Annual']){
            if(bonusResultObj.AF_Total_Bonus_Value__c==null)
            bonusResultObj.AF_Total_Bonus_Value__c=0;
            overallBonus+=bonusResultObj.AF_Total_Bonus_Value__c;
            system.debug('overallBonus..'+overallBonus);
            BonusTarget1=BonusTarget1+(bonusResultObj.AF_Total_Bonus_Value__c);
            
            if(bonusResultObj.AF_Qual_Bonus_Value__c==null)
            bonusResultObj.AF_Qual_Bonus_Value__c=0;
            qualValue+=bonusResultObj.AF_Qual_Bonus_Value__c;
           
            
            if(bonusResultObj.AF_Quant_Bonus_Value__c==null)
            bonusResultObj.AF_Quant_Bonus_Value__c=0;
            quant+=bonusResultObj.AF_Quant_Bonus_Value__c;
            
            if(bonusResultObj.AF_Bonusable_Fees__c==null)
            bonusResultObj.AF_Bonusable_Fees__c=0;
            bonusableFee+=bonusResultObj.AF_Bonusable_Fees__c;
            
            if(bonusResultObj.AF_Total_bonus_fees__c==null)
            bonusResultObj.AF_Total_bonus_fees__c=0;
            totalfee+=Integer.valueOf(bonusResultObj.AF_Total_bonus_fees__c);
        }
        BonusTarget=math.round(BonusTarget1);
        totalquant_qual=math.round(quant+qualValue);
        if(bonusSummaryObj.AF_Is_Pilot_Model__c) {
            if(bonusSummaryObj.Bonus_Matrix__r.size() > 0) {
                if(bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Total_Remuneration__c != null &&
                        bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Bonus_Value_Bm__c != null) {
                    /*remainingAllowances = math.round(bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Total_Remuneration__c - 
                                bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Bonus_Value_Bm__c);*/
                                remainingAllowances = (bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Total_Remuneration__c - 
                                bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Bonus_Value_Bm__c);
                                if(remainingAllowances<1){
                                    remainingAllowances=0;
                                }
                }
            }
         }else {
          // remainingAllowances = Math.round(BonusTarget - math.round((bonusSummaryObj.AF_Bonus_Matrix_Value__c)));
             remainingAllowances = (BonusTarget - bonusSummaryObj.AF_Bonus_Matrix_Value__c);
             if(remainingAllowances<1){
             remainingAllowances=0;
             }
           system.debug('remainingAllowances....'+remainingAllowances);
           system.debug('BonusTarget...'+BonusTarget);
           system.debug('bonusSummaryObj.AF_Bonus_Matrix_Value__c...'+bonusSummaryObj.AF_Bonus_Matrix_Value__c);
           system.debug('math.round((bonusSummaryObj.AF_Bonus_Matrix_Value__c))..'+math.round((bonusSummaryObj.AF_Bonus_Matrix_Value__c)));
         }
       
        //Calculate Overall bonus Percentage,Quatitative Bonus,Qualitative Bonus
        if(bonusableFee!=0){  
            qualPer=Math.round((qualValue*100)/bonusableFee);
            quantPer=Math.round((quant*100)/bonusableFee);
            if(bonusSummaryObj.AF_Is_Pilot_Model__c) 
                {
                    overallbonusPer=Math.round((overallBonus*100)/bonusableFee);
                    system.debug('before round....'+(overallBonus*100)/bonusableFee);
                    system.debug('overallbonusPer....'+overallbonusPer);
                }
            else
                {
                    overallbonusPer=qualPer+quantPer;
                }
           System.debug('overallbonusPer'+overallbonusPer);
           System.debug('qualPer'+qualPer);
           System.debug('quantPer'+quantPer);
           
        }
    }
    public pagereference SubmitforStatus(){
            List<AF_Bonus_Matrix__c> bonusMatrixList = new List<AF_Bonus_Matrix__c>();
            if(bonusableFee==0){
            apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Please submit the Annual Bonus,and proceed'));
            }
            else if(remainingAllowances==0){
            bonusSummaryObj.AF_Status__c='Ready For PO';
            update bonusSummaryObj;
            system.debug('bonusSummaryObj.Bonus_Matrix__r....'+bonusSummaryObj.Bonus_Matrix__r);
            for(AF_Bonus_Matrix__c BM:bonusSummaryObj.Bonus_Matrix__r){
            BM.AF_Status__c = 'Ready For PO';
            bonusMatrixList.add(BM);
            }
            if(bonusMatrixList.size()>0){
            system.debug('bonusMatrixList...'+bonusMatrixList);
            update bonusMatrixList;
            }
            IsReadyForPO=true;
            }
           // apexpages.addmessage(new apexpages.message(apexpages.severity.info,system.label.AF_ReadforPo_status_of_bonus_matrix));
            return null;
    }
    
}