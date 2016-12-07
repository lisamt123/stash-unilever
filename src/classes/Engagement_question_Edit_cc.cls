public class Engagement_question_Edit_cc {

    public List<wrapper> wrapperList {get; set;}
    public String qId {get;set;}
    public Engagement_Question__c ques {get; set;}
    public string val1 {get; set;}
    public Integer val2 {get; set;}
    public String comment {get; set;} 
    public transient Blob file{get;set;}
    public transient Blob file2{get;set;}
    public transient Blob file3{get;set;}
    String Uname = UserInfo.getUsername();
    private List<Id> photoIds;
    private List<Id> photoIds1;
    private List<Id> photoIds2;
    public List<Engagement_Question__c> QuestionList {get; set;}
    public Id aId;  
    public List<Attachment> d {get; set;}
    public List<Attachment> d1 {get; set;}
    public List<Attachment> d2 {get; set;}
    public Attachment a1;
    public Attachment a2;
    public Attachment a3;
    
    public Engagement_question_Edit_cc() {
        wrapperList = new List<wrapper>();
        qId = ApexPages.CurrentPage().getParameters().get('qId');   
        QuestionList = new List<Engagement_Question__c>();
        List<Engagement_Answers__c> wList = [select id,Question__c,Comments__c from Engagement_Answers__c where (Question_Id__c=:qId AND Username__c =: Uname)  ORDER BY CreatedDate DESC LIMIT 1];
        for(Engagement_Answers__c wa :wList){
            aId = wa.id;
            comment = wa.Comments__c;
       }
        system.debug('wList-->'+wList);
        ques = [select Question__c,Answer1__c,Answer2__c,Answer3__c,Answer4__c,Answer5__c from Engagement_Question__c WHERE Id=:qId];
        QuestionList.add(ques);
        for(Engagement_Question__c q:questionList){
            wrapper w = new wrapper();
            w.qs = q;
            val1='';
            wrapperList.add(w);            
        }
    }
    
    public List<Id> getPhotos() {
            if(photoIds == null) {
                photoIds = new List<Id>();
                for(Attachment att : [select Id from Attachment where ParentId = :aId and Name = 'Engagement1']) {
                    photoIds.Add(att.Id);
                }
            }                             
            return photoIds;
        }
   public List<Id> getPhotos1() {
            if(photoIds1 == null) {
                photoIds1 = new List<Id>();
                for(Attachment att : [select Id from Attachment where ParentId = :aId and Name = 'Engagement2']) {
                    photoIds1.Add(att.Id);
                }
            }                             
            return photoIds1;
        }
   public List<Id> getPhotos2() {
            if(photoIds2 == null) {
                photoIds2 = new List<Id>();
                for(Attachment att : [select Id from Attachment where ParentId = :aId and Name = 'Engagement3']) {
                    photoIds2.Add(att.Id);
                }
            }                             
            return photoIds2;
        }
    
    public pagereference save(){
        system.debug('wrapperList-->'+wrapperList);
        List<Engagement_Answers__c> waList = new List<Engagement_Answers__c>();
        for(wrapper wr:wrapperList){
            Engagement_Answers__c wa = new Engagement_Answers__c();
            if (val1 != '') {
                wa.Question__c = wr.qs.Question__c;            
                wa.answer__c = val1; 
                wa.Rating__c = val2;         
            }  
             wa.id = aId;
             wa.Comments__c = comment;
             waList.add(wa);  
        }
        if(waList.size()>0){
            update waList;
        }
        
              d= new List<Attachment>();
              d1= new List<Attachment>();
              d2= new List<Attachment>();
                 d = [select Id,body,name from Attachment where ParentId = :aId AND Name = 'Engagement1'];
                 if(file!=null){                 
                 for(Attachment a:d){                  
                  a.body = file;                                                           
                  }
                  if(d.size()>0){
                   update d; 
                  }
                  else{
                  a1 = new Attachment();
                  a1.name = 'Engagement1';
                  a1.body = file;
                  a1.ParentId = aId;
                  insert a1;
                  }
                 }
                 d1 = [select Id,body,name from Attachment where ParentId = :aId AND Name = 'Engagement2'];
                 if(file2!=null){
                 for(Attachment a:d1){  
                  a.body = file2; 
                  }
                  if(d1.size()>0){                             
                  update d1;              
                  }
                  else{
                  a2 = new Attachment();
                  a2.name = 'Engagement2';
                  a2.body = file2;
                  a2.ParentId = aId;
                  insert a2;
                 }
                 }
                 d2 = [select Id,body,name from Attachment where ParentId = :aId AND Name = 'Engagement3'];
                 if(file3!=null){
                 for(Attachment a:d2){  
                  a.body = file3; 
                  }
                  if(d2.size()>0){                             
                  update d2;              
                  }
                  else{
                  a3 = new Attachment();
                  a3.name = 'Engagement3';
                  a3.body = file3;
                  a3.ParentId = aId;
                  insert a3;
                  }
                 }
                 
        pageReference pgref = page.Engagement_preview_vf;
        pgref.setreDirect(true);
        return pgref;
    }
 
    public class wrapper{        
        public Engagement_Question__c qs {get; set;} 
        public string ans {get; set;}        
    }
    
}