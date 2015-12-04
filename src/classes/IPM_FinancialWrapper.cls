/**
* @author       Cognizant (Vipul)
* @date         27/04/2015
* @description  Wrapper class used to display financials on the ipmFinancial Page and in the Gate Documents
*/
public class IPM_FinancialWrapper{
    //Year Names
    public List<String> lstYearNames {get; set;}

    //Value Market Share
    public Decimal y0ValueMarketShare {get{return this.y0ValueMarketShare.setScale(1);} set;}
    public Decimal y0ValueMarketShareDifference {get{return this.y0ValueMarketShareDifference.setScale(1);} set;}
    public List<IPM_FinancialValueWrapper> lstGrossPLValueMarketShare {get; set;}
    public List<IPM_FinancialValueWrapper> lstIncrementalPLValueMarketShare {get; set;}
    //Newly added for new misalignment format or Regional and Local instead of difference in the tooltip
    public Decimal y0ValueMarketShareRegional {get;set;} 
    public Decimal y0ValueMarketShareLocal {get;set;} 

    //Volume
    public Decimal y0Volume {get{return this.y0Volume.setScale(2);} set;}
    public Decimal y0VolumeDifference {get{return this.y0VolumeDifference.setScale(2);} set;}
    public List<IPM_FinancialValueWrapper> lstGrossPLVolume {get; set;}
    public List<IPM_FinancialValueWrapper> lstIncrementalPLVolume {get; set;}
    //Newly added for new misalignment format or Regional and Local instead of difference in the tooltip
    public Decimal y0VolumeRegional {get;set;} 
    public Decimal y0VolumeLocal {get;set;} 

    //VolumeTons
    public Decimal y0VolumeTons {get{return this.y0VolumeTons.setScale(2);} set;}
    public Decimal y0VolumeTonsDifference {get{return this.y0VolumeTonsDifference.setScale(2);} set;}
    public List<IPM_FinancialValueWrapper> lstGrossPLVolumeTons {get; set;}
    public List<IPM_FinancialValueWrapper> lstIncrementalPLVolumeTons {get; set;}
    //Newly added for new misalignment format or Regional and Local instead of difference in the tooltip
    public Decimal y0VolumeTonsRegional {get;set;} 
    public Decimal y0VolumeTonsLocal {get;set;} 

    //Turnover
    public Decimal y0Turnover {get{return this.y0Turnover.setScale(2);} set;}
    public Decimal y0TurnoverDifference {get{return this.y0TurnoverDifference.setScale(2);} set;}
    public List<IPM_FinancialValueWrapper> lstGrossPLTurnover {get; set;}
    public List<IPM_FinancialValueWrapper> lstIncrementalPLTurnover {get; set;}
    //Newly added for new misalignment format or Regional and Local instead of difference in the tooltip
    public Decimal y0TurnoverRegional {get;set;} 
    public Decimal y0TurnoverLocal {get;set;} 

    //Gross Profit
    public Decimal y0GrossProfit {get{return this.y0GrossProfit.setScale(2);} set;}
    public Decimal y0GrossProfitDifference {get{return this.y0GrossProfitDifference.setScale(2);} set;}
    public List<IPM_FinancialValueWrapper> lstGrossPLGrossProfit {get; set;}
    public List<IPM_FinancialValueWrapper> lstIncrementalPLGrossProfit {get; set;}
    public Decimal y0GrossProfitRegional {get;set;} 
    public Decimal y0GrossProfitLocal {get;set;} 

    //Advertising & Promotions
    public Decimal y0Advertising {get{return this.y0Advertising.setScale(2);} set;}
    public Decimal y0AdvertisingDifference {get{return this.y0AdvertisingDifference.setScale(2);} set;}
    public List<IPM_FinancialValueWrapper> lstGrossPLAdvertising {get; set;}
    public List<IPM_FinancialValueWrapper> lstIncrementalPLAdvertising {get; set;}
    //Newly added for new misalignment format or Regional and Local instead of difference in the tooltip
    public Decimal y0AdvertisingRegional {get;set;} 
    public Decimal y0AdvertisingLocal {get;set;}

    //Profit before Overheads
    public Decimal y0Profit {get{return this.y0Profit.setScale(2);} set;}
    public Decimal y0ProfitDifference {get{return this.y0ProfitDifference.setScale(2);} set;}
    public List<IPM_FinancialValueWrapper> lstGrossPLProfit {get; set;}
    public List<IPM_FinancialValueWrapper> lstIncrementalPLProfit {get; set;}
    //Newly added for new misalignment format or Regional and Local instead of difference in the tooltip
    public Decimal y0ProfitRegional {get;set;} 
    public Decimal y0ProfitLocal {get;set;}

    //GM (% of TO)
    public Decimal y0GM {get{return this.y0GM.setScale(1);} set;}
    public Decimal y0GMDifference {get{return this.y0GMDifference.setScale(1);} set;}
    public List<IPM_FinancialValueWrapper> lstGrossPLGM {get; set;}
    public List<IPM_FinancialValueWrapper> lstIncrementalPLGM {get; set;}
    //Newly added for new misalignment format or Regional and Local instead of difference in the tooltip
    public Decimal y0GMRegional {get;set;} 
    public Decimal y0GMLocal {get;set;}

    //A&P (% of TO)
    public Decimal y0AP {get{return this.y0AP.setScale(1);} set;}
    public Decimal y0APDifference {get{return this.y0APDifference.setScale(1);} set;}
    public List<IPM_FinancialValueWrapper> lstGrossPLAP {get; set;}
    public List<IPM_FinancialValueWrapper> lstIncrementalPLAP {get; set;}
    //Newly added for new misalignment format or Regional and Local instead of difference in the tooltip
    public Decimal y0APRegional {get;set;} 
    public Decimal y0APLocal {get;set;}

    //PBO (% of TO)
    public Decimal y0PBO {get{return this.y0PBO.setScale(1);} set;}
    public Decimal y0PBODifference {get{return this.y0PBODifference.setScale(1);} set;}
    public List<IPM_FinancialValueWrapper> lstGrossPLPBO {get; set;}
    public List<IPM_FinancialValueWrapper> lstIncrementalPLPBO {get; set;}
    //Newly added for new misalignment format or Regional and Local instead of difference in the tooltip
    public Decimal y0PBORegional {get;set;} 
    public Decimal y0PBOLocal {get;set;}
    
    /*******************************************************************************************************
    * @description  Constructor
    * @param        NONE
    * @return       NONE
    */
    public IPM_FinancialWrapper(){
        this.lstYearNames = new List<String>();
        
        this.y0ValueMarketShare = 0;
        this.y0ValueMarketShareDifference = 0;
        this.lstGrossPLValueMarketShare = new List<IPM_FinancialValueWrapper>();
        this.lstIncrementalPLValueMarketShare = new List<IPM_FinancialValueWrapper>();
        this.y0ValueMarketShareRegional = 0;
        this.y0ValueMarketShareLocal = 0;

        this.y0Volume = 0;
        this.y0VolumeDifference = 0;
        this.lstGrossPLVolume = new List<IPM_FinancialValueWrapper>();
        this.lstIncrementalPLVolume = new List<IPM_FinancialValueWrapper>();
        this.y0VolumeRegional = 0;
        this.y0VolumeLocal = 0;

        this.y0VolumeTons = 0;
        this.y0VolumeTonsDifference = 0;
        this.lstGrossPLVolumeTons = new List<IPM_FinancialValueWrapper>();
        this.lstIncrementalPLVolumeTons = new List<IPM_FinancialValueWrapper>();
        this.y0VolumeTonsRegional = 0;
        this.y0VolumeTonsLocal = 0; 

        this.y0Turnover = 0;
        this.y0TurnoverDifference = 0;
        this.lstGrossPLTurnover = new List<IPM_FinancialValueWrapper>();
        this.lstIncrementalPLTurnover = new List<IPM_FinancialValueWrapper>();
        this.y0TurnoverRegional = 0;
        this.y0TurnoverLocal = 0;

        this.y0GrossProfit = 0;
        this.y0GrossProfitDifference = 0;
        this.lstGrossPLGrossProfit = new List<IPM_FinancialValueWrapper>();
        this.lstIncrementalPLGrossProfit = new List<IPM_FinancialValueWrapper>();
        this.y0GrossProfitRegional = 0;
        this.y0GrossProfitLocal = 0;  

        this.y0Advertising = 0;
        this.y0AdvertisingDifference = 0;
        this.lstGrossPLAdvertising = new List<IPM_FinancialValueWrapper>();
        this.lstIncrementalPLAdvertising = new List<IPM_FinancialValueWrapper>();
        this.y0AdvertisingRegional = 0;
        this.y0AdvertisingLocal = 0;

        this.y0Profit = 0;
        this.y0ProfitDifference = 0;
        this.lstGrossPLProfit = new List<IPM_FinancialValueWrapper>();
        this.lstIncrementalPLProfit = new List<IPM_FinancialValueWrapper>();
        this.y0ProfitRegional = 0;
        this.y0ProfitLocal = 0; 

        this.y0GM = 0;
        this.y0GMDifference = 0;
        this.lstGrossPLGM = new List<IPM_FinancialValueWrapper>();
        this.lstIncrementalPLGM = new List<IPM_FinancialValueWrapper>();
        this.y0GMRegional = 0;
        this.y0GMLocal = 0; 

        this.y0AP = 0;
        this.y0APDifference = 0;
        this.lstGrossPLAP = new List<IPM_FinancialValueWrapper>();
        this.lstIncrementalPLAP = new List<IPM_FinancialValueWrapper>();
        this.y0APRegional = 0;
        this.y0APLocal = 0; 

        this.y0PBO = 0;
        this.y0PBODifference = 0;
        this.lstGrossPLPBO = new List<IPM_FinancialValueWrapper>();
        this.lstIncrementalPLPBO = new List<IPM_FinancialValueWrapper>();
        this.y0PBORegional = 0;
        this.y0PBOLocal = 0;
    }
}