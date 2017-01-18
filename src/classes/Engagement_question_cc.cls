public with sharing class Engagement_question_cc {

    public transient Blob file2 { get; set; }
    public String Uname = UserInfo.getUsername();
    public Id qsname;
    public transient Blob file{get;set;}
    public transient Blob file3{get;set;}   
    public Decimal bar { get; set; }
    public Decimal x { get; set; }
    public Integer val2 { get; set; }
    public String comment { get; set; }
    public String val1 { get; set; }       
    public String loc { get; set; }
    public String loc1 { get; set; }

    public List<Engagement_Question__c> options = new List<Engagement_Question__c> ();
    public List<Engagement_User_Detail__c> userd = new List<Engagement_User_Detail__c> ();
    public Decimal TotalRecords {get; set;}
    public Integer OffsetSize = 0;
    public Integer QueryLimit = 1;
    public class SkillWrapper {
        // holds the sobject from the query
        public Engagement_Question__c qName { get; set; }
        public Id qId {get; set;}
        // stores the selection from the radio button
        //public String answers { get; set; }
    }
        
    public List<SkillWrapper> skillWrappers { get; set; }

    public Engagement_question_cc() {
        loc = ApexPages.CurrentPage().getParameters().get('param');
        loc1 = ApexPages.CurrentPage().getParameters().get('param1');
       TotalRecords = [select count() from Engagement_Question__c WHERE Location__c=:loc];
        system.debug('totalrecords-->'+totalrecords);
        userd = [SELECT Question_Number__c,Location__c,Location_Name__c FROM Engagement_User_Detail__c WHERE Username__c=:Uname];
        for(Engagement_User_Detail__c us:userd){
        OffsetSize = Integer.valueof(us.Question_Number__c);
        }
        skillWrappers = new List<SkillWrapper>();
    }
    
    public List<skillWrapper> getRecords(){
        skillWrappers = new List<SkillWrapper>();
        for (Engagement_Question__c skill : [SELECT Id,Name,Question__c FROM Engagement_Question__c WHERE Location__c=:loc ORDER BY CreatedDate limit:QueryLimit offset:OffsetSize]) {
            //system.debug('skil-->'+skill);
            SkillWrapper sWrapper = new SkillWrapper();
            sWrapper.qName = skill;
            qsname = skill.id;
            sWrapper.qId = skill.Id;
            val1='';
            comment='';
            bar = (100/TotalRecords)*(OffsetSize+1);
            //sWrapper.answers= ''; // a default selection (blank)
            skillWrappers.add(sWrapper);
        }
        return skillWrappers;
    }
    
    public List <Engagement_Question__c> getItems() {
        
        options = [SELECT Id,Name,Answer1__c,Answer2__c,Answer3__c,Answer4__c,Answer5__c,Location__c,Location_Name__c FROM Engagement_Question__c WHERE Location__c=:loc ORDER BY CreatedDate limit:QueryLimit offset:OffsetSize];
        system.debug('options-->'+options);
        return options;
    }
    
      public Decimal getBar1() {
        x = (100/TotalRecords)*(OffsetSize);
        return x;
    }
    
    
    public void SaveRecord() {
        List<Engagement_Answers__c> skilldetailslist = new List<Engagement_Answers__c>();
        List<Engagement_User_Detail__c> userDetailList = new List<Engagement_User_Detail__c>();       
        // loop our wrappers and get the data out of the sObject and the selected value
        for (SkillWrapper sWrapper: skillWrappers) {
            if (val1 != '') {
               /* Document d= new Document();
                Document d1= new Document();
                Document d2= new Document();
                 d.name = 'Engagement';
                 d.body=file; // body field in document object which holds the file.
                 d.folderid='00l22000000EWBA'; //folderid where the document will be stored insert d;
                 insert d;
                 d1.name = 'Engagement';
                 d1.body=file2; // body field in document object which holds the file.
                 d1.folderid='00l22000000EWBA'; //folderid where the document will be stored insert d;
                 insert d1;
                 d2.name = 'Engagement';
                 d2.body=file3; // body field in document object which holds the file.
                 d2.folderid='00l22000000EWBA'; //folderid where the document will be stored insert d;
                 insert d2;*/
                 
               Engagement_Answers__c sd = new Engagement_Answers__c();
                sd.Question__c = sWrapper.qName.Question__c;
                sd.Answer__c = val1;
                sd.Comments__c = comment;
                /*sd.Upload__c = '<img src="https://unilever--capgupool--c.cs27.visual.force.com/servlet/servlet.FileDownload?file='+d.id+'" width="100" height="100"></img>';
                sd.Upload1__c = '<img src="https://unilever--capgupool--c.cs27.visual.force.com/servlet/servlet.FileDownload?file='+d1.id+'" width="100" height="100"></img>';
                sd.Upload2__c = '<img src="https://unilever--capgupool--c.cs27.visual.force.com/servlet/servlet.FileDownload?file='+d2.id+'" width="100" height="100"></img>';*/
                /*sd.Upload__c = d.id;
                sd.Upload1__c = d1.id;
                sd.Upload2__c = d2.id;*/
                sd.Question_Id__c = sWrapper.qId;
                sd.Location__c = loc;
                sd.Location_Name__c = loc1;
                sd.Rating__c = val2;
                sd.Username__c = Uname;
                skilldetailslist.add(sd);
                
                
                Engagement_User_Detail__c ud = new Engagement_User_Detail__c();
                ud = [SELECT Username__c FROM Engagement_User_Detail__c WHERE Username__c=:Uname];
                ud.Question_Number__c = OffsetSize+1;
                ud.Engagement_Question__c = qsname;
                userDetailList.add(ud);
                if(userDetailList.size()>0){
                update userDetailList;
            }
          }
        }
        if(skilldetailslist.size()>0){            
            insert skilldetailslist;  
            Attachment d= new Attachment();
                Attachment d1= new Attachment();
                Attachment d2= new Attachment();
                 d.name = 'Engagement1';
                 d.body = file; // body field in document object which holds the file.
                 d.ParentId = skilldetailslist[0].id; //folderid where the document will be stored insert d;
                 if(d.body!=null){                
                  insert d;              
                }
                 d1.name = 'Engagement2';
                 d1.body = file2; // body field in document object which holds the file.
                 d1.ParentId = skilldetailslist[0].id; //folderid where the document will be stored insert d;
                  if(d1.body!=null){                
                  insert d1;              
                }
                 d2.name = 'Engagement3';
                 d2.body = file3; // body field in document object which holds the file.
                 d2.ParentId = skilldetailslist[0].id; //folderid where the document will be stored insert d;
                 if(d2.body!=null){                
                  insert d2;              
                }
        }
        if(userDetailList.size()>0){
            update userDetailList;
        }  
    }
   

    Public Pagereference save() {
        if(val1!=''){
        saveRecord();
        if ((OffsetSize + QueryLimit) == TotalRecords){
        Pagereference pageref = new PageReference('/apex/Engagement_feedback_vf');
         return pageref;
         }
         else
         {
          OffsetSize += QueryLimit;
          return null;
        }
      }
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'Please select any of the below options.'));
      return null;       
    } 
}