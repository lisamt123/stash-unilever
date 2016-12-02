public class Engagement_feedback_cc {

    public Engagement_Rating__c r {get;set;}
    public List<Engagement_Answers__c> ware {get;set;}
    public Decimal i = 0.00;
    public Decimal avg = 0.00;
    public String loc {get;set;}
    public String loc1{get;set;}
    public String loc2{get;set;}
    public Integer totalrecords {get; set;}
    public List<Engagement_Answers__c> getloc {get; set;}
    public String Uname = UserInfo.getUsername();
    public List<Engagement_User_Detail__c> userd {get;set;}
    public Decimal qnum;

    public Engagement_feedback_cc(){
         getloc = [select Location__c,Location_Name__c from Engagement_Answers__c WHERE Username__c=:Uname ORDER BY CreatedDate DESC LIMIT 1];
         for(Engagement_Answers__c gl: getloc){
         loc2=gl.Location__c;
         }
        totalrecords = [select count() from Engagement_Question__c WHERE Location__c=:loc2];
        }


     public PageReference submit() {
        userd = new List<Engagement_User_Detail__c>();
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
        userd = [SELECT Question_Number__c FROM Engagement_User_Detail__c WHERE Username__c=:Uname];
        for(Engagement_User_Detail__c us:userd){
        qnum = us.Question_Number__c;
        qnum = qnum+2;
        us.Question_Number__c = qnum; 
       // userd.add(us);  
        }       
        update userd;    
        PageReference pageRef = new PageReference('/apex/Engagement_rating_vf');
        return pageRef;
    }


    public PageReference preview() {
        userd = [SELECT Question_Number__c FROM Engagement_User_Detail__c WHERE Username__c=:Uname];
        for(Engagement_User_Detail__c us:userd){
        qnum = us.Question_Number__c;
        qnum = qnum+1;
        us.Question_Number__c = qnum;
        //userd.add(us);
        }
        if(userd.size()>0){
        update userd;
        }      
        PageReference pageRef = new PageReference('/apex/Engagement_preview_vf');
        return pageRef;
    }

}