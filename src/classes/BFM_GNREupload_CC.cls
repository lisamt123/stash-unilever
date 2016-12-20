public with sharing class BFM_GNREupload_CC {
    Id cteId;
    public Attachment gnreAtt{get; set;}
    public boolean isSuccess {get;set;}
    public BFM_GNREupload_CC(ApexPages.StandardController controller){       
        gnreAtt = new Attachment();
        cteId = ApexPages.currentpage().getParameters().get('id');
    }
    
    public pagereference savefile(){
        integer Errcount=0;
        string urlstring='';
        string filename='';
        BFM_CT_e__c cterec = new BFM_CT_e__c();
        cterec = [select id,name,CNPJ_issuer__c,GNRE_file_url__c, GNR_e_Required__c,CT_e_key__c from BFM_CT_e__c where id=: cteId];
        
        if(cterec!=null && cterec.GNR_e_Required__c == false){             
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'GNRE is not required')); 
            Errcount++;             
        } else if(gnreAtt !=null && gnreAtt.body!=null){                              
            if(gnreAtt.body.size()>10485760){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File size should be less than 10 MB')); 
                Errcount++;
                //return null;    
            }
            
            if(gnreAtt.contenttype!='application/pdf'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File format should be pdf only'));
                Errcount++;
                //return null;    
            }
            if(Errcount==0){
                
                //Service to upload GNRE File to Amazon
                filename = cterec.CT_e_key__c+'-gnre';
                BFM_AmazonConnector bac = new BFM_AmazonConnector();
                urlstring = bac.sendFile(gnreAtt,cterec.CNPJ_issuer__c,filename,'gnre');
                
                if(urlstring!=''){
                    isSuccess =true;
                } else{
                    issuccess =false;
                }
                
                gnreAtt = new Attachment();
                if(issuccess == true){
                    cterec.GNRE_file_url__c = urlstring;
                    update cterec;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Upload realizado com sucesso!'));
                    return null;
                } else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Integration Error - Error while uploading file'));
                    return null;
                }           
            } 
        } else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select file to upload'));
            return null;
        }        
        return null;
    }
    public pagereference cancel(){
        pagereference pgr = new pagereference('/'+cteId);
        pgr.setRedirect(true);
        return pgr;
    }
}