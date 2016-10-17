public with sharing class BFM_Fileupload_CC 
{
    public string filetype{get;set;}
    public List<SelectOption> filetypelist{get;set;}
    public List<Attachment> newAttachments {get; set;}
    public static final Integer NUM_ATTACHMENTS_TO_ADD=5;
    
    public static final String MDFE = 'MDF-e';
    public static final String CTE = 'CT-e';
    public static final String CCE = 'CC-e';
    public static final String POD = 'POD';
    public static final String NFS = 'NFS';
    public static final String GNRE = 'GNRE';
    
    PageReference pr;
    
    public BFM_Fileupload_CC()
    {
        filetypelist = new List<SelectOption>();
        filetypelist.add(new SelectOption('','--Select--'));
        filetypelist.add(new SelectOption(MDFE,MDFE));
        filetypelist.add(new SelectOption(CTE,CTE));
        filetypelist.add(new SelectOption(CCE,CCE));
        filetypelist.add(new SelectOption(POD,POD));
        filetypelist.add(new SelectOption(NFS,NFS));
        //filetypelist.add(new SelectOption('GNRE','GNRE'));    
        
        newAttachments=new List<Attachment>{new Attachment(),new Attachment(),new Attachment(),new Attachment(),new Attachment()};
            
        //Redirecting same page along with Success Message
        String message = '' + ApexPages.CurrentPage().GetParameters().Get('message');
        String integrationError = '' +ApexPages.CurrentPage().getParameters().get('integrationError');
        String pageHeaderReferer = ApexPages.currentPage().getHeaders().get('Referer'); 
        if(pageHeaderReferer != null && pageHeaderReferer.containsIgnoreCase('BFM_Fileupload_VF'))
        {
            if(message != 'null'){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message));    
            } 
            if(integrationError != 'null'){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, integrationError)); 
            }
        }
    }
    
    public pagereference save()
    {
        
        integer invalidsize=0,invalidformat=0;
        List<BFM_File__c> listBFMFiles = new List<BFM_File__c>();
        for(Integer i = 0; i <5; i++){
            listBFMFiles.add(new BFM_File__c());
        }
        
        set<id> setbfmids = new set<id>();
        Map<string,id> MapBfmattach = new Map<String,id>();
        
        if(filetype ==null){ 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select file type'));
        } else{
            List<Attachment> toInsert=new List<Attachment>();
            for (Integer i = 0; i < 5; i++)
            {
                Attachment newAtt = newAttachments[i];
                if(newAtt.body!=null){                
                    if(newAtt.body.size()>10485760){
                        invalidsize++;
                    }
                    if(((filetype== MDFE || filetype== CTE || filetype== CCE) && newAtt.contenttype!='text/xml') ||
                       ((filetype== NFS|| filetype== POD || filetype== GNRE) && newAtt.contenttype!='application/pdf')){
                           invalidformat++;
                       }
                    if(invalidsize ==0 && invalidformat==0){
                        BFM_File__c bfile = listBFMFiles[i];
                        bfile.File_Name__c =  newAtt.name;
                        bfile.Content_Type__c = newAtt.contenttype;
                        bfile.Size__c = string.valueof(newAtt.body.size());
                        bfile.File_Type__c = filetype;
                        // removed, passing on memory as blob
                        // bfile.Body_Blob__c = string.valueOf(newAtt.Body);
                    }
                }
            }
            if(invalidsize >0){
                listBFMFiles.clear();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File size should be less than 10 MB'));            
            }
            if(invalidformat >0){
                listBFMFiles.clear();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File format should match with file type'));        
            }
            
            if(invalidsize == 0 && invalidformat==0 && !listBFMFiles.isEmpty()){
                pr = new pagereference('/apex/BFM_Fileupload_VF');
                //service call to Mulsoft to send files 
                boolean filesSentSuccessfully = sendFilesToMulesoft(listBFMFiles);
                if(filesSentSuccessFully){
                    BFM_File__c emptyFile = new BFM_File__c();
                    List<BFM_File__c> filesCreated = new List<BFM_File__c>();
                    for(BFM_File__c newFile: listBFMFiles ){
                        if(newFile != emptyFile){
                            filesCreated.add(newFile);
                        }
                    }
                    insert filesCreated;
                    pr.getParameters().put('message', 'Record inserted successfully...');
                } 
                pr.setRedirect(true);
                
            }
        } 
        newAttachments.clear();
        for(integer i=0;i<5;i++){
            Attachment a = new Attachment();
            newAttachments.add(a);
        }
        listBFMFiles.clear();        
        return pr;           
    }
    
    private boolean sendFilesToMulesoft(List<BFM_File__c> listBFMFiles){
        boolean isAllSuccess = true;
        for(Integer i = 0; i< listBFMFiles.size(); i++){
            BFM_File__c file = listBFMFiles[i];
            Attachment att = newAttachments[i];
            boolean isSuccess = true;
            String error = '';
            
            if(file.File_Type__c == NFS){
                BFM_NFSUpload nfsUpload = new BFM_NFSUpload(file, att.Body);
                isSuccess = nfsUpload.uploadNFS();
                if(!isSuccess){
                    isAllsuccess = false;
                    for(String nfsUploadError: nfsUpload.getErrors()){
                        error += nfsUploadError;    
                    }
                    pr.getParameters().put('integrationError', error);
                }
            } else if(file.File_Type__c == POD){
                BFM_PODUpload podUpload = new BFM_PODUpload(file, att.Body);
                isSuccess = podUpload.uploadPOD();
                if(!isSuccess){
                    isAllSuccess = false;
                    for(String podUploadError: podUpload.getErrors()){
                        error += podUploadError;    
                    }
                    pr.getParameters().put('integrationError', error);
                }
            } else if(file.File_Type__c == CTE || file.file_Type__c == CCE || file.File_Type__c == MDFE){
                BFM_PublishXML xmlPublish = new BFM_PublishXML(file, att.Body);
                isSuccess = xmlPublish.doPublish();
                if(!isSuccess){
                    isAllSuccess = false;
                    for(String xmlPublishError: xmlPublish.getErrors()){
                        error+= xmlPublishError;
                    }
                    System.debug('got errors publishing xml ' + error);
                    pr.getParameters().put('integrationError', error);
                }
            }
            if(!isSuccess){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, error));
                isAllSuccess = false;
            }
        }
        return isAllSuccess;
    }
    public pagereference cancel(){
        pagereference pgr = new pagereference(BFM_Redirecttofileurl__c.getInstance('Fileurl').Redirect_Url__c);
        pgr.setRedirect(true);
        return pgr;
    }
}