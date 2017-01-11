public class BEN_Matrix_Print_VF_Controller {

    public String fromYearVal { get; set; }
    public String fromQuarterVal { get; set; }
    public String toYearVal { get; set; }
    public String toQuarterVal { get; set; }
	public String productCat { get; set; }
	public String totalRecCount {get; set;}
    
    public String winLoss_00 { get; set; }
    public String winParity_01 { get; set; }
    public String winWin_02 { get; set; }
    public String parityLoss_10 { get; set; }
    public String parityParity_11 { get; set; }
    public String parityWin_12 { get; set; }
    public String lossLoss_20 { get; set; }
    public String lossParity_21 { get; set; }
    public String lossWin_22 { get; set; }
    
    
    public BEN_Matrix_Print_VF_Controller(){
        
        Map<String , String> params = ApexPages.currentPage().getParameters();
        this.fromYearVal = params.get('fromYearVal');
        this.fromQuarterVal = params.get('fromQuarterVal');
        this.toYearVal = params.get('toYearVal');
        this.toQuarterVal = params.get('toQuarterVal');
        this.productCat = params.get('productCat');
        this.totalRecCount = params.get('totalRecCount');
        this.winLoss_00 = params.get('winLoss_00');
        this.winParity_01 = params.get('winParity_01');
        this.winWin_02 = params.get('winWin_02');
        this.parityLoss_10 = params.get('parityLoss_10');
        this.parityParity_11 = params.get('parityParity_11');
        this.parityWin_12 = params.get('parityWin_12');
        this.lossLoss_20 = params.get('lossLoss_20');
        this.lossParity_21 = params.get('lossParity_21');
        this.lossWin_22 = params.get('lossWin_22');
        
    }
}