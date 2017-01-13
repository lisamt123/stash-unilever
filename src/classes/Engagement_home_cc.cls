public class Engagement_home_cc {

    public PageReference onload() {
       
      List<Engagement_User_Detail__c> ud = new List<Engagement_User_Detail__c>();
      ud = [SELECT Question_Number__c,Location__c,Location_Name__c FROM Engagement_User_Detail__c WHERE Username__c=:Uname];
      if(ud.size() == 0){
      Engagement_User_Detail__c u = new Engagement_User_Detail__c();
      u.Location__c = null;
      u.Location_Name__c = null;
      u.Question_Number__c = 0;
      u.Username__c = Uname;
      insert u;
      }
      else{
      for(Engagement_User_Detail__c u:ud){
      x = u.Question_Number__c;
      par1 = u.Location__c;
      par2 = u.Location_Name__c;
      }
      totalqns = [SELECT count() FROM Engagement_Question__c WHERE Location__c=:par1];
      if((x==0) && (par1==null) && (par2 == null)){
      return null;
      }
      else if(x<totalqns){  
        PageReference pageRef = new PageReference('/apex/Engagement_question_vf');
        pageRef.getParameters().put('param',par1);
        pageRef.getParameters().put('param1',par2);
        pageRef.setRedirect(true);
        return pageRef; 
        }
       else if(x == totalqns){  
        PageReference pageRef = new PageReference('/apex/Engagement_feedback_vf');
        pageRef.setRedirect(true);
        return pageRef; 
        }
       else if(x == (totalqns+1)){  
        PageReference pageRef = new PageReference('/apex/Engagement_preview_vf');
        pageRef.setRedirect(true);
        return pageRef; 
        }
       else if(x == (totalqns+2)){  
        PageReference pageRef = new PageReference('/apex/Engagement_rating_vf');
        pageRef.setRedirect(true);
        return pageRef; 
        }
       }
      return null;
    }

   public Decimal x;
   public String par1 { get; set; }
   public String par2 { get; set; }
   public boolean rend1 {get; set;}
   public boolean rend2 {get; set;}
   public Engagement_Locations__c home {get;set;}
   public Engagement_RS_Names__c rs {get;set;}
   public String Uname = UserInfo.getUsername();
   public Integer totalqns;
   public List<Engagement_RS_Names__c> rnames{get;set;}
   public List<Engagement_User_Detail__c> ud{get;set;}
    
   public Engagement_home_cc(){
    rend1 = false;
    rend2 = false;
    home = new Engagement_Locations__c();
    rs = new Engagement_RS_Names__c(); 
    
    }

   public PageReference start() {  
        rnames = new List<Engagement_RS_Names__c>();      
        par1 = home.Location__c;  
        if(home.Location__c == 'RS'){
        rnames = [SELECT Name FROM Engagement_RS_Names__c WHERE RS_Code__c =: rs.RS_Code__c];
        for(Engagement_RS_Names__c r:rnames){
        par2 = r.Name;
        }
        }
        else if(home.Location__c != 'RS'){
        par2 = home.Location_Name__c;   
        }
        if((home.Location__c == 'RS') && (rnames.size() == 0)){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'Please enter a valid RS Code'));
        return null;
        }
        else if(par2 == null){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'Please select a Location Name'));
        return null;
        }
        ud = new List<Engagement_User_Detail__c>();
        ud = [SELECT Location__c, Location_Name__c FROM Engagement_User_Detail__c WHERE Username__c=:Uname];
        for(Engagement_User_Detail__c us:ud){
        us.Location__c = par1;
        us.Location_Name__c = par2;
        update ud;
        }
        PageReference pageRef = new PageReference('/apex/Engagement_question_vf');
        pageRef.getParameters().put('param',par1);
        pageRef.getParameters().put('param1',par2);       
        pageRef.setRedirect(true);
        return pageRef;       
    }
    public void start1(){
        if(home.Location__c == 'RS'){
            rend1 = false;
            rend2 = true;
        }else if(home.Location__c == 'Warehouse'){
            rend1 = true;
            rend2 = false;
        }else if(home.Location__c == 'Factory'){
            rend1 = true;
            rend2 = false;
        }    
    }  
}