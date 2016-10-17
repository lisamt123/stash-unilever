/**
 * Class for building the request for NFS Upload and sending it to Mulesoft.
 * Constructor takes as parameter one BFM_File__c instance representing the NFS information and a Blob with the binary representation 
 * of the NFS pdf
 * */
public class BFM_NFSUpload {
	private String[] errors;
    private boolean isSuccess;
    private Blob fileBody;
    private BFM_File__c nfsFile;
    public BFM_NFSUpload(BFM_File__c nfsFile, Blob fileBody){
        this.nfsFile = nfsFile;
        this.errors = new List<String>();
        isSuccess = false;
        this.fileBody = fileBody;
    }
    
    /**
     * Method for uploading the NFS to Mulesoft using an Apex Callout
     * 
     * */
    public boolean uploadNFS(){
       	
        try{
            System.debug('file name ' + nfsFile.File_Name__c);
            System.debug('content type ' + nfsFile.content_Type__c);
            HttpResponse response = BFM_GeneralServiceCalls.nfsUpload(nfsFile.File_Name__c, System.now(), 
                                                                nfsFile.Content_Type__c, nfsFile.size__c, fileBody);
            System.debug('NFS Status Code ' + response.getStatusCode());
            System.debug('NFS Upload response: ' + response.getBody());
            
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            	isSuccess = true;    
            } else{
                String errorMessage = String.format(Label.BFM_Integration_Failure, new List<String>{String.valueOf(response.getStatusCode()),  
                    														response.getStatus(),
                    														response.getBody()});
                errors.add(errorMessage);
            }
            
        } catch(Exception ex){
            errors.add(ex.getMessage());
            System.debug('Error uploading NFS: '+ex.getMessage());
            isSuccess = false;
        }
        return isSuccess;
    }
    
    /**
     * Returns whether the upload process was successful or not
     * */
    public boolean isSuccess(){
        return isSuccess;
    }
    
    
    /**
     * Returns eventual errors generated on the upload process.
     * */
    public List<String> getErrors(){
        return this.errors;
    }
}