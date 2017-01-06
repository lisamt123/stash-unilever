public class PQN_UploadNCData {
    

    public class PQN_tabledata{
        public PQN_Pallet_Quality_Non_Conformance__c pqn{get; set;}
        public string errorMessage{get; set;}
        public PQN_tabledata(PQN_Pallet_Quality_Non_Conformance__c pqndata){
            pqn = pqndata;
            errormessage='';
        }
    }
  
    List<PQN_Pallet_Quality_Non_Conformance__c> forInsert = new List<PQN_Pallet_Quality_Non_Conformance__c>();
    public List<PQN_tabledata> forInsertWrapper {get; set;}
    public Integer size {get;set;}
    public String myString {get;set;}
    public Boolean status {get;set;}
    public String message {get;set;}
    public string selectedfile{get; set;}
    public List<selectoption> filetype{get; set;}
    public List<PQN_Pallet_Quality_Non_Conformance__c> forinsertsuccess{get; set;}
    public List<PQN_Pallet_Quality_Non_Conformance__c> forinsertErrors{get; set;}
    public boolean showsuccessdata{get; set;}
    public boolean hidesuccessdata{get; set;}
    public boolean showerrortable{get; set;}
    public boolean showallsuccessmsg{get; set;}
    string exceptionmsg = 'Excel has more than 1000 records. Please import 1000 records at a time';
    
    
    public PQN_UploadNCData(){
        //forInsert = new List<PQN_Pallet_Quality_Non_Conformance__c>();
        forinsertsuccess = new List<PQN_Pallet_Quality_Non_Conformance__c>();
        forinsertErrors = new List<PQN_Pallet_Quality_Non_Conformance__c>();
        forInsertWrapper = new List<PQN_tabledata>();
        myString= '';
        size = 0;
        status= false;
        showerrortable = true;
        showsuccessdata = false;
        showallsuccessmsg = false;
        hidesuccessdata = false;
        filetype = new List<selectOption>();
        filetype.add(new SelectOption('Unilever','Unilever'));
        filetype.add(new SelectOption('Cannock','Cannock'));
        filetype.add(new SelectOption('Heilbronn','Heilbronn'));
    }
     public void parseData(){
        forInsertWrapper = new List<PQN_tabledata>();
        forInsert = new List<PQN_Pallet_Quality_Non_Conformance__c>();
        forinsertsuccess = new List<PQN_Pallet_Quality_Non_Conformance__c>();
        forinsertErrors = new List<PQN_Pallet_Quality_Non_Conformance__c>();
        showsuccessdata = false;
        hidesuccessdata = false;
        if(selectedfile == 'Unilever'){
            parseJSONString();
        }
        if(selectedfile == 'Cannock'){
            cannock_parseJSONString();
            system.debug('cccccccccccc');
        }
        if(selectedfile == 'Heilbronn'){
            helibronn_parseJSONString();
            
        }
        
        //return Null;
    }
    
    public void parseJSONString() {
    String jsonStr = myString;
    forInsert = new List<PQN_Pallet_Quality_Non_Conformance__c>();
    try{
    JSONParser parser = JSON.createParser(jsonStr);
    while (parser.nextToken() != null) {
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
                system.debug('ppppppppppppppp '+parser.getCurrentToken());
                system.debug('jjjjjjjjjjjjj '+JSONToken.START_OBJECT);
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    PQN_Pallet_Quality_Non_Conformance__c acc = (PQN_Pallet_Quality_Non_Conformance__c)parser.readValueAs(PQN_Pallet_Quality_Non_Conformance__c.class);
                    forInsert.add(acc);
                    
                    PQN_tabledata uLwrap = new PQN_tabledata(acc);
                    forInsertWrapper.add(uLwrap);
                    if(forInsertWrapper.size() == 1000){
                        forInsertWrapper.clear();
                        message = exceptionmsg;
                        break;
                    }
                    System.debug('Debug'+ acc.cluster__c);
                    String s = JSON.serialize(acc);
                    system.debug('Serialized invoice: ' + s);
                    parser.skipChildren();
                   }
                }
            }
        }
        }
        catch(Exception e){
            message = 'Please upload the file with correct data';
        }
      //  upsert forInsert;
    } 
    
    public void cannock_parseJSONString() {
    String jsonStr = myString;
    jsonStr = jsonStr.replace('"Data Collection":', '"DataCollection":');
    jsonStr = jsonStr.replace('"Supplier Name":', '"SupplierName":');
    jsonStr = jsonStr.replace('"Product Code":', '"ProductCode":');
    jsonStr = jsonStr.replace('"Reject Code":', '"RejectCode":');
    jsonStr = jsonStr.replace('"Number Pallets Affected":', '"NumberPalletsAffected":');
    
    forInsert = new List<PQN_Pallet_Quality_Non_Conformance__c>();
    try{
    PQN_CannockJSON2Apex response = PQN_CannockJSON2Apex.parse(jsonStr);
    for(PQN_CannockJSON2Apex.DataCollection resp: response.DataCollection){
        system.debug('mmmmmmmmmm'+resp.Month);
        system.debug('sssssssss'+resp.SupplierName);
        PQN_Pallet_Quality_Non_Conformance__c cann = new PQN_Pallet_Quality_Non_Conformance__c();
        cann.Supplier__c = resp.SupplierName;
        cann.Reporting_DC__c = resp.Depot;
        cann.SKU__c = resp.ProductCode;
        if(resp.RejectCode!=null){
            cann.Non_compliance_reason_code__c = integer.valueof(resp.RejectCode);
        }
        cann.Number_of_Pallets_Per_SKU_Non_Compliant__c= resp.NumberPalletsAffected;
        cann.Date_Pallet_Received__c = system.today();
       
        forInsert.add(cann);
        
        PQN_tabledata cannwrap = new PQN_tabledata(cann);
        forInsertWrapper.add(cannwrap);
        if(forInsertWrapper.size() == 1000){
            forInsertWrapper.clear();
            message = exceptionmsg;
            break;
        }
        
    }
    }
    catch(Exception e){
        status = true;
        message = e.getmessage();
    }
   
      
    } 
    
    public void helibronn_parseJSONString() {
    String jsonStr = myString;
    jsonStr = jsonStr.replace('"Data Collection":', '"DataCollection":');
    jsonStr = jsonStr.replace('"DN#":', '"DN":');
    jsonStr = jsonStr.replace('"Source Factory":', '"SourceFactory":');
    jsonStr = jsonStr.replace('"Source DC (if applicable)":', '"SourceDC":');
    jsonStr = jsonStr.replace('"Reporting DC":', '"ReportingDC":');
    jsonStr = jsonStr.replace('"Product Group (Category)":', '"ProductGroup":');
    jsonStr = jsonStr.replace('"Product Number (SKU)":', '"ProductNumberSKU":');    
    jsonStr = jsonStr.replace('"Product Name":', '"ProductName":');
    jsonStr = jsonStr.replace('"LOSS CODE #":', '"LossCode":');
    jsonStr = jsonStr.replace('"Additional Information":', '"AdditionalInfo":');
    jsonStr = jsonStr.replace('"Number Pallets affected":', '"NumberPalletsAffected":');
    
    forInsert = new List<PQN_Pallet_Quality_Non_Conformance__c>();
    try{
    boolean looph = true;
    PQN_HelibronnJSON2Apex response = PQN_HelibronnJSON2Apex.parse(jsonStr);
    
    for(PQN_HelibronnJSON2Apex.DataCollection resp: response.DataCollection){
        if(looph){
        PQN_Pallet_Quality_Non_Conformance__c cann = new PQN_Pallet_Quality_Non_Conformance__c();
        cann.Delivery_Note_Number__c= resp.DN;
        cann.Supplier__c= resp.SourceFactory;
        cann.Product_Name__c = resp.ProductName;
        cann.Reporting_DC__c= resp.ReportingDC;
        cann.SKU__c= resp.ProductNumberSKU;
        if(resp.LossCode!=null){
            cann.Non_compliance_reason_code__c = integer.valueof(resp.LossCode);
        }
        cann.Description__c= resp.AdditionalInfo;        
        cann.Product_Group__c = resp.ProductGroup;
        cann.Number_of_Pallets_Per_SKU_Non_Compliant__c= resp.NumberPalletsAffected;        
        cann.Date_Pallet_Received__c = system.today();
        if(cann!=null){
        forInsert.add(cann);
        
        PQN_tabledata cannwrap = new PQN_tabledata(cann);
        forInsertWrapper.add(cannwrap);
        }
        
        if(forInsertWrapper.size() == 1000){
            forInsertWrapper.clear();
            looph = false;
            message = exceptionmsg;
           // break;
        }
        
    }
    }
    }
    catch(Exception e){
        status = true;
        message = e.getmessage();
    }
   
      
    }
    
    
    public void savedata(){
   
    forinsertSuccess = new List<PQN_Pallet_Quality_Non_Conformance__c>();
    forinsertErrors= new List<PQN_Pallet_Quality_Non_Conformance__c>();
    List<PQN_tabledata> forinsertErrorsWrap = new List<PQN_tabledata>();
    Map<string,id> mapoftarget = new  Map<string,id>();
    Map<string,decimal> mapoftargetred = new  Map<string,decimal>();
    
    //forinsertduplicate.addAll(forInsert);
    List<integer> setsucessindex = new List<integer>();
    List<integer> seterrorindex = new list<integer>();
       /* for(PQN_tabledata p: forinsertwrapper){
            forinsert.add(p.pqn);    
        }*/ 
        set<string>  setregion = new set<string>();
        set<string>  setyear = new set<string>();
         for(PQN_Pallet_Quality_Non_Conformance__c pqn: forInsert){
             setregion.add(pqn.Region__c);  
             setyear.add(string.valueOf(pqn.Date_Pallet_Received__c.year()));   
               }
              List<PQN_Targets__c> listtar=new List<PQN_Targets__c>();
                    listtar=[select id,Target_Reduction__c,Target__c,Region__c,Year__c,Month__c from PQN_Targets__c where region__c in:setregion and Year__c in:setyear ];
                    for(PQN_Targets__c lt:listtar){
                         mapoftarget.put(lt.Year__c+lt.Region__c,lt.id);
                         mapoftargetred.put(lt.Year__c+lt.Region__c,lt.Target_Reduction__c);
                         }
                    for(PQN_Pallet_Quality_Non_Conformance__c pqn: forInsert){
                          if(mapoftarget.containskey(pqn.Date_Pallet_Received__c.year()+pqn.Region__c)){                          
                            pqn.Targets__c = mapoftarget.get(pqn.Date_Pallet_Received__c.year()+pqn.Region__c);
                            pqn.Target_Reduction__c=mapoftargetred.get(pqn.Date_Pallet_Received__c.year()+pqn.Region__c);
                          }
                    }
        
        if(!forInsert.isEmpty()){
            try{               
                size = forInsert.size();
                //status = true;                
                Database.SaveResult[] SR = Database.insert(forInsert, false);
                
    
    
                
                for(Integer i=0;i<SR.size();i++){
                    
                    if (sr[i].isSuccess()) {
                        setsucessindex.add(i);
                       // forinsert.remove(i);    
                    }
                    else{//only look at failures, or NOT Successes
                    seterrorindex.add(i);
                     
                      for(Database.Error err : SR[i].getErrors()){                     
                          forinsertwrapper[i].errormessage = err.getMessage();
                      }
                    
                    }
                }
                for(integer i=0; i<setsucessindex.size(); i++){
                    forinsertSuccess.add(forinsert[setsucessindex[i]]);
                    showsuccessdata = true;
                }
                for(integer i=0; i<seterrorindex.size(); i++){
                    forinsertErrors.add(forinsert[seterrorindex[i]]); 
                    forinsertErrorsWrap.add(forinsertwrapper[seterrorindex[i]]);                      
                }
                if(!forinsertErrors.isEmpty()){
                    forinsert.clear();
                    forinsertwrapper.clear();
                    forinsert.addall(forinsertErrors);
                    forinsertwrapper.addall(forinsertErrorsWrap);
                    showallsuccessmsg = false;
                }
                else{
                    forinsert.clear();
                    forinsertwrapper.clear();
                    showallsuccessmsg = true;
                }
                
                
                }catch(Exception e){
                    status = false;
                    message = e.getmessage();
            }
        }
    }
    public void showsucesstable(){
        showsuccessdata = false;
        hidesuccessdata = true;
        showerrortable = false;
    }
    public void hidesuccesstable(){
        showsuccessdata = true;
        hidesuccessdata = false;
        showerrortable = true;
    }
    public pagereference export2excel(){
    system.debug('eeeeeeeeeeeeeeeeee');
        PageReference np = new PageReference('/apex/export2excel');
        np.setRedirect(false);
        return np;
    }
    
}