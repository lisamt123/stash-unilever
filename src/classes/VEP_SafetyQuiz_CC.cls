/**********************************************************************
Name: VEP_SafetyQuiz_CC 
Purpose:
This Apex Class is used to populate set of Question and Answers to pass
or fail. If Passes generates a visitor pass.
VERSION   AUTHOR   DATE    
1.0       Leena   Jan-2016   
***********************************************************************/

public with sharing class VEP_SafetyQuiz_CC {
    public ApexPages.StandardSetController con{get; set;} 
    public Map<id,List<Vep_Answer__c>> mapQAns{get; set;}
    public Map<id,List<AnswerWrapper>> mapQAnsWrapper{get; set;}
    Map<id,Vep_Question__c> mapQues = new Map<id,Vep_Question__c>();
    public string visitorId{get; set;}
    public string errMessage{get; set;}
    public boolean errPanel{get; set;}
    public integer noOfCorrectAns{get; set;}
    public integer correctPercentage{get; set;}
    public boolean videopanel{get; set;}
     public boolean QApanel{get; set;}
     public boolean resultpanel{get; set;}
     public boolean visitorPasspanel{get; set;}
     public boolean thankuPanel{get; set;}
     public Vep_Visitor_Pass__c vPass{get; set;}
     public Vep_Visitor__c visitorRec{get; set;}
     
    public VEP_SafetyQuiz_CC(){
            try{
            List<Vep_Visitor__c> listVisitor = new List<Vep_Visitor__c>();           
            visitorId = Apexpages.currentpage().getparameters().get('VEPnumber');                     
            if(VisitorId!=null && VisitorId!=''){            
                listVisitor = [select id,name,email__c from Vep_Visitor__c where VEP_number__c=:VisitorId];
                if(!listVisitor.isEmpty()){
                     VisitorRec = listVisitor[0];
                 }
             }
             if(VisitorRec!=null){
                 List<Vep_Visitor_pass__c> listpasses = new List<vep_visitor_pass__c>();
                 listpasses = [select id from vep_visitor_pass__c where visitor__c =: VisitorRec.id];
                 if(!listpasses.isEmpty()){
                     ErrPanel = true;
                     ErrMessage = label.VEP_Quiz_Pass_Err;
                 }
                 else{
                     videopanel = true; 
                     ErrPanel = false;
                     List<Vep_Question__c> listQues = new List<Vep_Question__c>();
                    MapQAns = new Map<id,List<Vep_Answer__c>>();
                    MapQAnsWrapper = new Map<id,List<AnswerWrapper>>();
                    NoOfCorrectAns=0;
                    List<String> orderBys = new List<String>{'Id Asc','Id Desc','Name ASC','Name Desc'};
                    Integer rand = Math.floor(Math.random() * 1).intValue();
                    String orderBy = orderBys.get(Math.mod(rand,orderBys.size()));
                    string querystr = '';
                    querystr +='select id, No_of_Correct_Answers__c, Name,Question__c, (select id, Name,Is_true__c,Answer__c from Answers__r) from Vep_Question__c Order By ';
                    querystr +=orderBy;
                    querystr +=' limit 10';
                   querystr +='OFFSET :rand';
                    listQues = database.query(querystr);
                    
                    con = new ApexPages.StandardSetController(listQues); 
                    // sets the number of records in each page set
                    con.setPageSize(5);  
                    for(Vep_Question__c q: listQues){
                        MapQAns.put(q.id,q.Answers__r);
                        MapQues.put(q.id,q);
                    }
                    if(!MapQAns.isEmpty()){
                        for(id qid:MapQAns.keySet()){
                            List<AnswerWrapper> listAnsw = new List<AnswerWrapper>();
                            for(Vep_Answer__c Qans:MapQAns.get(qid)){
                                AnswerWrapper ansW = new AnswerWrapper(Qans);
                                listAnsw.add(ansW);
                            }
                            MapQAnsWrapper.put(qid,listAnsw);
                        }
                    }
                }
            
            }
            else{
                ErrPanel = true;
                ErrMessage = label.VEP_Quiz_Correcturl_Err;
            
            }
            }
            Catch(Exception e){
                ErrPanel = true;
                ErrMessage = label.VEP_Quiz_Correcturl_Err;
            }                 
    }
    
    public List<Vep_Question__c> getQuesRecords(){
        
        return con.getRecords();
    }
    
    public class AnswerWrapper {
        public Boolean checked{ get; set; }
        public Vep_Answer__c answ { get; set;}        
        public AnswerWrapper(Vep_Answer__c c){
            answ = c;
            checked = false;
        }
    }
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }    

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         con.next();
     }
     
         
     public void submitTest(){
         NoOfCorrectAns=0;
         correctPercentage =0;
         Resultpanel = true;
         QApanel=false;
         for(id qid:MapQAns.keySet()){
             integer count=0;
             for(Vep_Answer__c Qans: MapQAns.get(qid)){
                 for(AnswerWrapper QansW: MapQAnsWrapper.get(qid)){
                     if(Qans.id == QansW.answ.id && Qans.Is_true__c == QansW.checked && Qans.Is_true__c){                                                                                                           
                                 count++;                                                      
                     }       
                 }
                 
             }
             if(count==MapQues.get(qid).No_of_Correct_Answers__c && count!=0){
             NoOfCorrectAns++;
             }
         }
         
         correctPercentage=(NoOfCorrectAns*100)/10;
         
     }
         
     public void showQApage(){
         videopanel = false;
         QApanel = true;
     }
     
     public void visitorPass(){
         visitorPasspanel= true;
         QApanel = false;
         Resultpanel = false;
         
         if(correctPercentage>=70){
             //create pass object
             Vep_Visitor_Pass__c vpass1 = new Vep_Visitor_Pass__c();
             vpass = new Vep_Visitor_Pass__c();
             
             if(VisitorRec!=null){
             
             vpass1.visitor__c = VisitorRec.id;
             }
             try{
             insert vPass1;
             if(vPass1!=null){
                 vpass = [Select id,name,visitor__r.date_from__c,Visitor__r.Name,visitor__r.date_to__c,visitor__r.Reason_for_Visit__c,visitor__r.Factory_to_visit__c,visitor__r.Person_to_meet__r.name from Vep_Visitor_Pass__c where id=:vpass1.id];
             }
             VisitorRec.status__c = 'Pending Visit';
             Update VisitorRec;
             
             }
             Catch(Exception e){
                 ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,e.getmessage() );
                 ApexPages.addmessage(msg);
                 
             }
         }
         
         
     }
     public void closePage(){
         visitorPasspanel= false;
         ThankuPanel = true;
     }
     public pagereference back2Video(){
         PageReference redirectPage = Page.VEP_SafetyQuiz_VF;
         redirectPage.setRedirect(true);
         redirectPage.getParameters().put('VEPnumber',VisitorId);
         return redirectPage;    
     }
     
     public pagereference generatePdf(){
         PageReference redirectPage = Page.VEP_Visitorpass_VF;
         redirectPage.setRedirect(true);
         redirectPage.getParameters().put('id',vpass.id);
         return redirectPage;
     }
    
}