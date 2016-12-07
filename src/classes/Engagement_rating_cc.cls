public class Engagement_rating_cc {


   public List<Engagement_Rating__c> rlist1 {get; set;}
   public List<Engagement_Rating__c> plist1 {get; set;}
   public List<Engagement_Rating__c> plist {get; set;}
   public Decimal total = 0.00;
   public Integer count = 0;
   public Decimal avrg = 0.00;
   public String loc {get; set;}
   public Decimal rec = 0.00;
   public String Uname = UserInfo.getUsername();
   public List<Engagement_User_Detail__c> userd {get;set;}
   
 public List<Engagement_Rating__c> getRLists() {
     rlist1 = new List<Engagement_Rating__c>();
     rlist1 = [SELECT Rating__c,Location_Name__c,Location__c FROM Engagement_Rating__c WHERE Username__c=:Uname ORDER BY CreatedDate DESC limit 1];
        return rlist1;
    }
    
     public Decimal getAvg() {
     plist1 = new List<Engagement_Rating__c>();
     plist = new List<Engagement_Rating__c>();
     plist = [SELECT Rating__c,Location_Name__c,Location__c FROM Engagement_Rating__c WHERE Username__c=:Uname ORDER BY CreatedDate DESC limit 1];
     for(Engagement_Rating__c q:plist){
     loc = q.Location_Name__c;
     rec = q.Rating__c;
     }
     plist1 = [SELECT Rating__c,Location_Name__c,Location__c FROM Engagement_Rating__c WHERE Location_Name__c=:loc ORDER BY CreatedDate DESC];
     for(Engagement_Rating__c p:plist1){
     total+=p.Rating__c;
     count++;
     }
     total = total - rec;
     if(count!=1){
     avrg = total/(count-1);
     avrg = avrg.setScale(1);
     return avrg;
     }
     return 0;
    }
    

  
   public PageReference gohome() {
       userd = [SELECT Question_Number__c FROM Engagement_User_Detail__c WHERE Username__c=:Uname];
        for(Engagement_User_Detail__c us:userd){
        us.Question_Number__c = 0;
        us.Location__c = null;
        us.Location_Name__c = null;
        //userd.add(us);
        }
        if(userd.size()>0){
        update userd;
        }      
       PageReference pageref=new PageReference('/apex/Engagement_home_vf');
       return pageref;
    }
    
}