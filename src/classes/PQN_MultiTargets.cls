public class PQN_MultiTargets {
    

    public class PQN_tabledata{
        public PQN_Targets__c target{get; set;}
        public string errorMessage{get; set;}
        public PQN_tabledata(PQN_Targets__c Tdata){
            target = Tdata;
            errormessage='';
        }
    }
  
    public List<PQN_Targets__c> listTargets{get; set;}
    public List<PQN_tabledata> listTargetWrapper {get; set;}
    public List<PQN_tabledata> listSuccessTargetWrapper {get; set;}
    public String myString {get;set;}
    public string sfileformat{get; set;}    
    string exceptionmsg = 'Excel has more than 1000 records. Please import 1000 records at a time';
    public string message{get; set;}
    public boolean showsuccesslink{get; set;}
    public boolean showerrorlink{get; set;}
    public boolean showerrortable{get; set;}
    public boolean showallsuccessmsg{get; set;}
    
    public PQN_MultiTargets(){
        //forInsert = new List<PQN_Pallet_Quality_Non_Conformance__c>();
        listTargets = new List<PQN_Targets__c>();
        listSuccessTargetWrapper = new List<PQN_tabledata>();
        listTargetWrapper = new List<PQN_tabledata>();
        myString= '';
        sfileformat = '';
        message = '';
        showerrortable = true;
        
    }
    
     public void parseData(){
        showsuccesslink = false;
        showerrorlink = false;
        showerrortable = true;
        showallsuccessmsg = false;
        listTargetWrapper = new List<PQN_tabledata>(); 
        listSuccessTargetWrapper.clear();
        message='';
     parseJSONString();   
        
        //return Null;
    }
    
    public void parseJSONString() {
    message='';
    String jsonStr = myString;
    String sresult = '';
    boolean substr =false;
    integer err =0; 
    if(jsonStr!=null){
    substr = jsonStr.contains('Year__c');
    }
    if(substr == false){
        message = 'Please choose the correct file';
        err++;
    }
    if(sfileformat!=null){
       sresult = sfileformat.right(3);
    }
    if((sresult != 'lsx' && sresult != 'xls') || sfileformat==null){
        message = 'Please upload xlsx or xls files';
        err++;
    }
    if(err==0) {
    try{
    JSONParser parser = JSON.createParser(jsonStr);
    while (parser.nextToken() != null) {
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {                
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    PQN_Targets__c tgt = (PQN_Targets__c)parser.readValueAs(PQN_Targets__c.class);
                  //  listTargets.add(tgt);
                    system.debug(tgt);
                    PQN_tabledata uLwrap = new PQN_tabledata(tgt);
                    listTargetWrapper.add(uLwrap);
                    if(listTargetWrapper.size() == 1000){
                        listTargetWrapper.clear();
                        message = exceptionmsg;
                        break;
                    }                    
                    parser.skipChildren();
                   }
                }
            }
        }
    }
    catch(Exception e){
        listTargetWrapper.clear();
        message = 'Please upload the file with correct data';
    }
    }
      //  upsert forInsert;
    }
    
    public void savedata(){
        List<integer> setsucessindex = new List<integer>();
        List<integer> seterrorindex = new list<integer>();
        List<PQN_tabledata> ListTargeterrors= new List<PQN_tabledata>();
        listSuccessTargetWrapper = new List<PQN_tabledata>();
        for(PQN_tabledata t: listTargetWrapper){
            listTargets.add(t.target);
        }
         Database.SaveResult[] SR = Database.insert(listTargets, false);
         
            PQN_updateTAR.update_TAR(listTargets);
         
         for(Integer i=0;i<SR.size();i++){
             if (sr[i].isSuccess()) {
                setsucessindex.add(i);                  
             }
             else{//only look at failures, or NOT Successes
                 seterrorindex.add(i);                     
                  for(Database.Error err : SR[i].getErrors()){                     
                      listTargetWrapper[i].errormessage = err.getMessage();
                      system.debug('mmm'+listTargetWrapper[i].errormessage);
                  }                     
             }
         }
         for(integer i=0; i<seterrorindex.size(); i++){
             ListTargeterrors.add(listTargetWrapper[seterrorindex[i]]);                      
         }
         for(integer i=0; i<setsucessindex.size(); i++){
            listSuccessTargetWrapper.add(listTargetWrapper[setsucessindex[i]]);
            showsuccesslink = true;
        }
         system.debug('eeee'+ListTargeterrors);
        if(!ListTargeterrors.isEmpty()){
            listTargets.clear();
            listTargetWrapper.clear();
            listTargetWrapper.addall(ListTargeterrors);
            showallsuccessmsg = false;            
        }
        else{
            showallsuccessmsg = true;
            showerrortable = false;
        }
        
    }
    public void clicksuccesslink(){
        showsuccesslink = false;
        showerrorlink = true;
        showerrortable = false; 
        if(showallsuccessmsg == true){
            showerrorlink = false;
        }
    }
    public void clickerrorlink(){
        showsuccesslink = true;
        showerrorlink = false;
        showerrortable = true;    
    }
    
}