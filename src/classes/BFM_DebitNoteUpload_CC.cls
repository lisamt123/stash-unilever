public class BFM_DebitNoteUpload_CC{
    public Attachment newAttachment {get; set;}
    Id recordId;
    string objR='';
    public BFM_DebitNoteUpload_CC(){
        newAttachment = new Attachment();
        recordId = ApexPages.currentpage().getParameters().get('id');
        objR = ApexPages.currentpage().getParameters().get('obj');
        system.debug('ddddddddddd'+objR);
    }
    
    public pagereference upload(){
        Boolean issuccess;
        string urlstring='';
        string filename='';
        if(objR=='DebitNote' ){
            BFM_Debit_Note__c debitn = [select id,name from BFM_Debit_Note__c where id=: recordId];
            filename = debitn.name; 
        }
        if(objR=='PODReceipt' ){
            BFM_POD__c podrec = [select id,name from BFM_POD__c where id=: recordId];
            filename = podrec.name; 
        }
        if(newAttachment.body==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please choose the file'));
            return null;
        }
        else{
            //Service has to be written to upload file to Amazon
            BFM_AmazonConnector bac = new BFM_AmazonConnector();
            urlstring = bac.sendFile(newAttachment,'cnpj',filename,objR);
            if(urlstring!=''){
                issuccess =true;
            }
            else{
                issuccess =false;
            }
            newAttachment = new Attachment();
            if(issuccess == true){
                if(objR=='DebitNote'){
                system.debug('uuuuuuuuuuu'+urlstring);
                    BFM_Debit_Note__c dn = new BFM_Debit_Note__c(id=recordId);
                    dn.Amazon_File_Link__c = urlstring;
                    update dn;
                    
                }
                if(objR=='PODReceipt'){
                    BFM_POD__c podr = new BFM_POD__c(id=recordId);
                    podr.Amazon_File_Link__c = urlstring;
                    update podr;
                }
                pagereference pgr = new pagereference('/'+recordId);
                pgr.setRedirect(true);
                return pgr;
            }
            else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Integration Error - Error while uploading file'));
            return null;
            }
        }
    }
    
    public pagereference cancel(){
        pagereference pgr = new pagereference('/'+recordId);
        pgr.setRedirect(true);
        return pgr;
    }
}