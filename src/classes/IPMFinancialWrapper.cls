public class IPMFinancialWrapper{
    //Year Names
    public List<String> lstYearNames {get; set;}

    //Value Market Share
    public Decimal y0ValueMarketShare {get{return this.y0ValueMarketShare.setScale(1);} set;}
    public Decimal y0ValueMarketShareDifference {get{return this.y0ValueMarketShareDifference.setScale(1);} set;}
    public List<ipmFinancialValueWrapper> lstGrossPLValueMarketShare {get; set;}
    public List<ipmFinancialValueWrapper> lstIncrementalPLValueMarketShare {get; set;}

    //Volume
    public Decimal y0Volume {get{return this.y0Volume.setScale(2);} set;}
    public Decimal y0VolumeDifference {get{return this.y0VolumeDifference.setScale(2);} set;}
    public List<ipmFinancialValueWrapper> lstGrossPLVolume {get; set;}
    public List<ipmFinancialValueWrapper> lstIncrementalPLVolume {get; set;}

    //VolumeTons
    public Decimal y0VolumeTons {get{return this.y0VolumeTons.setScale(2);} set;}
    public Decimal y0VolumeTonsDifference {get{return this.y0VolumeTonsDifference.setScale(2);} set;}
    public List<ipmFinancialValueWrapper> lstGrossPLVolumeTons {get; set;}
    public List<ipmFinancialValueWrapper> lstIncrementalPLVolumeTons {get; set;}

    //Turnover
    public Decimal y0Turnover {get{return this.y0Turnover.setScale(2);} set;}
    public Decimal y0TurnoverDifference {get{return this.y0TurnoverDifference.setScale(2);} set;}
    public List<ipmFinancialValueWrapper> lstGrossPLTurnover {get; set;}
    public List<ipmFinancialValueWrapper> lstIncrementalPLTurnover {get; set;}

    //Gross Profit
    public Decimal y0GrossProfit {get{return this.y0GrossProfit.setScale(2);} set;}
    public Decimal y0GrossProfitDifference {get{return this.y0GrossProfitDifference.setScale(2);} set;}
    public List<ipmFinancialValueWrapper> lstGrossPLGrossProfit {get; set;}
    public List<ipmFinancialValueWrapper> lstIncrementalPLGrossProfit {get; set;}

    //Advertising & Promotions
    public Decimal y0Advertising {get{return this.y0Advertising.setScale(2);} set;}
    public Decimal y0AdvertisingDifference {get{return this.y0AdvertisingDifference.setScale(2);} set;}
    public List<ipmFinancialValueWrapper> lstGrossPLAdvertising {get; set;}
    public List<ipmFinancialValueWrapper> lstIncrementalPLAdvertising {get; set;}

    //Profit before Overheads
    public Decimal y0Profit {get{return this.y0Profit.setScale(2);} set;}
    public Decimal y0ProfitDifference {get{return this.y0ProfitDifference.setScale(2);} set;}
    public List<ipmFinancialValueWrapper> lstGrossPLProfit {get; set;}
    public List<ipmFinancialValueWrapper> lstIncrementalPLProfit {get; set;}

    //GM (% of TO)
    public Decimal y0GM {get{return this.y0GM.setScale(1);} set;}
    public Decimal y0GMDifference {get{return this.y0GMDifference.setScale(1);} set;}
    public List<ipmFinancialValueWrapper> lstGrossPLGM {get; set;}
    public List<ipmFinancialValueWrapper> lstIncrementalPLGM {get; set;}

    //A&P (% of TO)
    public Decimal y0AP {get{return this.y0AP.setScale(1);} set;}
    public Decimal y0APDifference {get{return this.y0APDifference.setScale(1);} set;}
    public List<ipmFinancialValueWrapper> lstGrossPLAP {get; set;}
    public List<ipmFinancialValueWrapper> lstIncrementalPLAP {get; set;}

    //PBO (% of TO)
    public Decimal y0PBO {get{return this.y0PBO.setScale(1);} set;}
    public Decimal y0PBODifference {get{return this.y0PBODifference.setScale(1);} set;}
    public List<ipmFinancialValueWrapper> lstGrossPLPBO {get; set;}
    public List<ipmFinancialValueWrapper> lstIncrementalPLPBO {get; set;}
    
    public ipmFinancialWrapper(){
        this.lstYearNames = new List<String>();
        
        this.y0ValueMarketShare = 0;
        this.lstGrossPLValueMarketShare = new List<ipmFinancialValueWrapper>();
        this.lstIncrementalPLValueMarketShare = new List<ipmFinancialValueWrapper>();

        this.y0Volume = 0;
        this.lstGrossPLVolume = new List<ipmFinancialValueWrapper>();
        this.lstIncrementalPLVolume = new List<ipmFinancialValueWrapper>();

        this.y0VolumeTons = 0;
        this.lstGrossPLVolumeTons = new List<ipmFinancialValueWrapper>();
        this.lstIncrementalPLVolumeTons = new List<ipmFinancialValueWrapper>();

        this.y0Turnover = 0;
        this.lstGrossPLTurnover = new List<ipmFinancialValueWrapper>();
        this.lstIncrementalPLTurnover = new List<ipmFinancialValueWrapper>();

        this.y0GrossProfit = 0;
        this.lstGrossPLGrossProfit = new List<ipmFinancialValueWrapper>();
        this.lstIncrementalPLGrossProfit = new List<ipmFinancialValueWrapper>();

        this.y0Advertising = 0;
        this.lstGrossPLAdvertising = new List<ipmFinancialValueWrapper>();
        this.lstIncrementalPLAdvertising = new List<ipmFinancialValueWrapper>();

        this.y0Profit = 0;
        this.lstGrossPLProfit = new List<ipmFinancialValueWrapper>();
        this.lstIncrementalPLProfit = new List<ipmFinancialValueWrapper>();

        this.y0GM = 0;
        this.lstGrossPLGM = new List<ipmFinancialValueWrapper>();
        this.lstIncrementalPLGM = new List<ipmFinancialValueWrapper>();

        this.y0AP = 0;
        this.lstGrossPLAP = new List<ipmFinancialValueWrapper>();
        this.lstIncrementalPLAP = new List<ipmFinancialValueWrapper>();

        this.y0PBO = 0;
        this.lstGrossPLPBO = new List<ipmFinancialValueWrapper>();
        this.lstIncrementalPLPBO = new List<ipmFinancialValueWrapper>();
    }
}