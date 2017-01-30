/**********************************************************************
Name: BEN_Matrix_VF_controller Copyright © 2016 Salesforce 
======================================================
======================================================
Purpose: This class is controller class for Visualforce page BEN_Matrix3Cross3_Report
======================================================
======================================================
History
-------
VERSION     AUTHOR        DATE            DETAIL Description
V1.0         mahesh         10/01/2017    Visualforce page COntroller clazz
***********************************************************************/
public with sharing class BEN_Matrix_VF_controller {

    public List<SelectOption> fromYear {
        get{
            return getPicklistValues(BEN_Category_Details__c.pkl_Year__c.getDescribe());
        }
        set;
     }
    public List<SelectOption> toYear {
        get{
            return getPicklistValues(BEN_Category_Details__c.pkl_Year__c.getDescribe());
        }
        set;
     }
    
    public List<SelectOption> fromQuarter {
        get{
            return getPicklistValues(BEN_Category_Details__c.pkl_Quarter__c.getDescribe());
        }
        set;
     }
    
    public List<SelectOption> toQuarter {
        get{
            return getPicklistValues(BEN_Category_Details__c.pkl_Quarter__c.getDescribe());
        }
        set;
     }
    
    public List<SelectOption> productCategory {
        get{
            List<SelectOption> sOptions = new List<SelectOption>();
            List<BEN_Category_Master__c> pcs = [Select Name from BEN_Category_Master__c];
                       
            List<GroupMember> gms = [select Id from GroupMember where UserOrGroupId = :UserInfo.getUserId() AND group.name = 'BEN GPL User'];
            if(gms.size()>0){
            sOptions.add(new SelectOption('All Categories', 'All Categories'));    
            }
            //eleminate all records with delete category.
            for(BEN_Category_Master__c master : pcs){
                if(!master.Name.trim().contains('Deleted'))
                sOptions.add(new SelectOption(master.Name, master.Name));
            }
            if(sOptions!=null )
                if(sOptions.get(0)!=null)
            productCat = sOptions.get(0).getValue();
            return sOptions;
        }
        set;
    }

    public String fromYearVal { get; set; }
    public String fromQuarterVal { get; set; }
    public String toYearVal { get; set; }
    public String toQuarterVal { get; set; }
    public String productCat {get; set; }
    public List<String> procductCategories = new List<String>();
    public List<String> selectedCategories{
        get{
            if(selectedCategories == null){
                selectedCategories = new List<String>();
            }
            return selectedCategories;
        }
        set;
    }
    private final BEN_Category_Details__c  catDetails;
    public Integer totalRecCount {get; set;}
    public Boolean renderBlock{get;set;}
    public String winLoss_00 { get; set; }
    public String winParity_01 { get; set; }
    public String winWin_02 { get; set; }
    public String parityLoss_10 { get; set; }
    public String parityParity_11 { get; set; }
    public String parityWin_12 { get; set; }
    public String lossLoss_20 { get; set; }
    public String lossParity_21 { get; set; }
    public String lossWin_22 { get; set; }
     
    //the method used to redirct to Print version of Visualforce page (BEN_Matrix_Report_Print_VF.vfp)
    public PageReference  redirectToPDF(){
        PageReference printPageRef = Page.BEN_Matrix_Report_Print_VF;
        Map<String, String> params = printPageRef.getParameters();
        params.put('fromYearVal', fromYearVal);
        params.put('fromQuarterVal', fromQuarterVal);
        params.put('toYearVal', toYearVal);
        params.put('toQuarterVal', toQuarterVal);
        params.put('productCat', productCat);
        params.put('totalRecCount', String.valueOf(totalRecCount));
        params.put('winLoss_00', winLoss_00);
        params.put('winParity_01', winParity_01);
        params.put('winWin_02', winWin_02);
        params.put('parityLoss_10', parityLoss_10);
        params.put('parityParity_11', parityParity_11);
        params.put('parityWin_12',parityWin_12 );
        params.put('lossLoss_20', lossLoss_20);
        params.put('lossParity_21',lossParity_21);
        params.put('lossWin_22', lossWin_22);
        
        printPageRef.setRedirect(true);
        return printPageRef;
    }
    
    
    public List<String> parseProductCategory(){
        List<String> catts = new List<String>();
        if(productCat!= null){
         productCat =  productCat.substring(productCat.indexOf('[')+1,productCat.indexOf(']'));
            catts.addAll(productCat.split(', '));
        }
        return catts;
    }
    
    // this action method for visualforce Command action gives report based on inputs.
    public void getReport(){
        String accid = System.currentPagereference().getParameters().get('id');
     
        if(Integer.valueof(fromYearVal.trim()) > Integer.valueof(toYearVal.trim()) ){
             ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'From-Year should be greater than To-Year value provided  :' + 
                                                              fromYearVal +' > '+toYearVal);
             ApexPages.addMessage(myMsg); 
         }
            
         if(Integer.valueof(fromYearVal.trim()) == Integer.valueof(toYearVal.trim()) ){
             Integer result = fromQuarterVal.compareTo(toQuarterVal);
             If(result > 0){
                 ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Search Year is Same :' + 
                                                              fromYearVal +' To Quarter '+ toQuarterVal + 'should be equal or greater to :  '+fromQuarterVal + ' (from Quarter) ');
                 ApexPages.addMessage(myMsg); 
             }
          }
       
        
        Double winLossNum_00 = 0;
        Double winParityNum_01 = 0;
        Double winWinNum_02 = 0;
        Double parityLossNum_10 = 0;
        Double parityParityNum_11 = 0;
        Double parityWinNum_12 = 0;
        Double lossLossNum_20 = 0;
        Double lossParityNum_21 = 0;
        Double lossWinNum_22 = 0;
        String Year = '';
        String quarter = '';
        
        List<BEN_Category_Details__c> actualCollection = new List<BEN_Category_Details__c>();
  
       
        selectedCategories = parseProductCategory();
              
         List<BEN_Category_Details__c> filterQuery = null;
         String query = 'Select ID, pkl_Blind_OO__c, pkl_Key_Attributes__c, pkl_Year__c, pkl_Quarter__c from BEN_Category_Details__c where pkl_Status__c=\'Approved\' AND Product_Category__c IN (Select ID from BEN_Category_Master__c where Name IN :selectedCategories) ORDER BY pkl_Year__c, pkl_Quarter__c';
            if(selectedCategories.get(0) =='All Categories'){
                query = 'Select ID, pkl_Blind_OO__c, pkl_Key_Attributes__c, pkl_Year__c, pkl_Quarter__c from BEN_Category_Details__c where pkl_Status__c=\'Approved\' AND Product_Category__c IN (Select ID from BEN_Category_Master__c where (NOT Name LIKE \'%Deleted%\')) ORDER BY pkl_Year__c, pkl_Quarter__c';
            }
        filterQuery = Database.query(query);
       
        //preparing collection based on the input queried.
        for(BEN_Category_Details__c cd : filterQuery){
            year = cd.pkl_Year__c;
            quarter = cd.pkl_Quarter__c;
            if(year>=fromYearVal && year<=toYearVal){
                if(Year !=fromYearVal && year !=toYearVal){
                actualCollection.add(cd);    
                }else if(((year >fromyearVal) || (year == fromYearVal && quarter >= fromQuarterVal)) && ((year < toYearVal) || (year == toYearVal && quarter <= toQuarterVal ))){
                actualCollection.add(cd); 
                }
            }   
        }
        
        totalRecCount = actualCollection.size();
        if(totalRecCount <30){
             ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.WARNING,'Please Confirm: the total tested records are not upto mark (Small Base Size (30) ), total found records  :' + 
                                                              totalRecCount);
             ApexPages.addMessage(myMsg); 
            
        }
        
        renderBlock = true;
        
        for(BEN_Category_Details__c  cd: actualCollection){
            if(cd.pkl_Blind_OO__c== 'Win' && cd.pkl_Key_Attributes__c == 'Loss')
                winLossNum_00 += 1;
            
            if(cd.pkl_Blind_OO__c== 'Win' && cd.pkl_Key_Attributes__c == 'Parity')
                winParityNum_01 +=1;
            
             if(cd.pkl_Blind_OO__c== 'Win' && cd.pkl_Key_Attributes__c == 'Win')
                winWinNum_02 += 1;
            
            if(cd.pkl_Blind_OO__c== 'Parity' && cd.pkl_Key_Attributes__c == 'Loss')
                parityLossNum_10 +=1;
            
            if(cd.pkl_Blind_OO__c== 'Parity' && cd.pkl_Key_Attributes__c == 'Parity')
                parityParityNum_11 +=1;
            
             if(cd.pkl_Blind_OO__c== 'Parity' && cd.pkl_Key_Attributes__c == 'Win')
                parityWinNum_12 += 1;
            
             if(cd.pkl_Blind_OO__c== 'Loss' && cd.pkl_Key_Attributes__c == 'Loss')
                lossLossNum_20  += 1;
            
            if(cd.pkl_Blind_OO__c== 'Loss' && cd.pkl_Key_Attributes__c == 'Parity')
                lossParityNum_21 += 1;
            
             if(cd.pkl_Blind_OO__c== 'Loss' && cd.pkl_Key_Attributes__c == 'Win')
                lossWinNum_22 += 1;
        }//forloop
        
        Double totalRecds = (Double)totalRecCount;
        if(totalRecds != 0){
        winLossNum_00 = (winLossNum_00/totalRecds) * 100;
        winParityNum_01 = (winParityNum_01/totalRecds) * 100;
        winWinNum_02 = (winWinNum_02/totalRecds) * 100;
        parityLossNum_10 = (parityLossNum_10/totalRecds) * 100;
        parityParityNum_11 = (parityParityNum_11/totalRecds) * 100;
        parityWinNum_12 = (parityWinNum_12/totalRecds) * 100;
        lossLossNum_20 = (lossLossNum_20/totalRecds) * 100;
        lossParityNum_21 = (lossParityNum_21/totalRecds) * 100;
        lossWinNum_22 = (lossWinNum_22/totalRecds) * 100;
        }
        
        winLoss_00 = String.valueOf(Decimal.valueOf(winLossNum_00).setScale(1))+ '%';
         winParity_01 = String.valueOf(Decimal.valueOf(winParityNum_01).setScale(1)) + '%';
         winWin_02 = String.valueOf(Decimal.valueOf(winWinNum_02).setScale(1)) + '%';
         parityLoss_10 = String.valueOf(Decimal.valueOf(parityLossNum_10).setScale(1)) + '%';
         parityParity_11 = String.valueOf(Decimal.valueOf(parityParityNum_11).setScale(1)) + '%';
         parityWin_12 = String.valueOf(Decimal.valueOf(parityWinNum_12).setScale(1)) + '%';
         lossLoss_20 = String.valueOf(Decimal.valueOf(lossLossNum_20).setScale(1)) + '%';
         lossParity_21 = String.valueOf(Decimal.valueOf(lossParityNum_21).setScale(1)) + '%';
         lossWin_22 = String.valueOf(Decimal.valueOf(lossWinNum_22).setScale(1)) + '%';
   
    }

    //helper method gives Field values based on the argumets passed.
   public static list<SelectOption> getPicklistValues( Schema.DescribeFieldResult dfr){
        list<SelectOption> options = new list<SelectOption>();
      
        List<Schema.PicklistEntry> ple = dfr.getPicklistValues();
       
       for( Schema.PicklistEntry f : ple)
       {
         options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       
       return options;
   }

}