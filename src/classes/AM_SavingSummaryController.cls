public with sharing class AM_SavingSummaryController {
    public integer intTotalSubmission {get; set;}
    public string strTotalSavings {get; set;}
    public integer intTotalSubmissionAug {get; set;}
    public string strTotalSavingsAug {get; set;}
        
        public AM_SavingSummaryController(){
    intTotalSubmission =20;
    strTotalSavings = '$20,000';
    intTotalSubmissionAug = 0;
    strTotalSavingsAug  = '$0.00';
        
}

}