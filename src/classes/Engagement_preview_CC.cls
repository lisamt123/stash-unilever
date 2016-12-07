public class Engagement_preview_CC {

    public Engagement_Rating__c r {get;set;}
    public List<Engagement_Answers__c> ware {get;set;}
    public Decimal i = 0.00;
    public Decimal avg = 0.00;
    public String loc {get;set;}
    public String loc2 {get;set;}
    public String loc1{get;set;}
    public Integer totalrecords {get; set;}
    public List<Engagement_Answers__c> getloc {get; set;}
    public String Uname = UserInfo.getUsername();
    public Decimal qnum;
    public List<Engagement_User_Detail__c> userd {get;set;}

    public Engagement_preview_CC() {
         getloc = [select Location__c,Location_Name__c from Engagement_Answers__c WHERE Username__c=:Uname ORDER BY CreatedDate DESC LIMIT 1];
         for(Engagement_Answers__c gl: getloc){
         loc2=gl.Location__c;
         }
        totalrecords = [select count() from Engagement_Question__c WHERE Location__c=:loc2];
}
    
    public PageReference Submit() {
        ware = new List<Engagement_Answers__c>();
        ware = [SELECT Rating__c,Location__c,Location_Name__c FROM Engagement_Answers__c WHERE (Location__c=:loc2 AND Username__c=:Uname) ORDER BY CreatedDate DESC limit:totalrecords];
        for(Engagement_Answers__c wh: ware){
        i += wh.Rating__c;
        loc = wh.Location__c;
        loc1 = wh.Location_Name__c;
        }
        avg = (i*100)/(9*totalrecords); 
        avg = avg.setScale(1);
        r = new Engagement_Rating__c(Rating__c = avg,Location__c = loc,Location_Name__c = loc1,Username__c = Uname);
        insert r;
        userd = new List<Engagement_User_Detail__c>();
        userd = [SELECT Question_Number__c FROM Engagement_User_Detail__c WHERE Username__c=:Uname];
        for(Engagement_User_Detail__c us:userd){
        qnum = us.Question_Number__c;
        qnum++;
        us.Question_Number__c = qnum;
        }
        if(userd.size()>0){
        update userd;   
        }    
        Pagereference pageref = new Pagereference('/apex/Engagement_rating_vf');
        return pageref;
    }
    
    public List<Engagement_Answers__c> indexAnswers {get; set;}
    public List<Engagement_Answers__c> questionsList {get; set;}
    public List<Engagement_Answers__c> getQuestions(){
        indexAnswers = new List<Engagement_Answers__c>();       
        questionsList = new List<Engagement_Answers__c>();
        questionsList = [select id,Question__c,Answer__c,Question_Id__c,Rating__c  from Engagement_Answers__c WHERE (Location__c=:loc2 AND Username__c=:Uname) ORDER BY CreatedDate DESC LIMIT:totalrecords];
        for(Integer i = questionsList.size()-1; i>=0; i--){
        indexAnswers.add(questionsList[i]);
        }
        return indexAnswers;    
    }
    
}