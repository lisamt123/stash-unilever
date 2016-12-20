public class BFM_PODUpload {
  
    private Id podFileId;
    private List<String> errors;
    @testVisible private boolean isSuccess;
    private BFM_File__c podFile;
    private blob podFileBody;
    private String cnpj;
    
    /**
     * Constructor takes as parameter one BFM_File__c representing the PoD and a Blob with the binary representation of the file being uploaded.
     * To actually run the upload, execute the uploadPOD method of this class.
     * */
    public BFM_PODUpload(String cnpj,BFM_File__c podFile, blob podFileBody){
        this.cnpj = cnpj;
      this.podFile = podFile;
        this.errors = new List<String>();
        this.isSuccess = false;
        this.podFileBody = podFileBody;
    }
    
    /**
     * Runs the callout to send the data to Mulesoft.
     * 
     * @return boolean boolean saying whether the operation was successful or not
     * */
    public boolean uploadPOD(){
        
        try{
          
            HttpResponse response = BFM_GeneralServiceCalls.podUpload(cnpj,podFile.File_Name__c, System.now(), 
                                                                podFile.Content_Type__c, podFile.size__c, podFileBody);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                isSuccess = true;
                system.debug('---->'+isSuccess);
            } else{
                isSuccess = false;
                String errorMessage = String.format(Label.BFM_Integration_Failure, new List<String>{String.valueOf(response.getStatusCode()),  
                                                response.getStatus(),
                                                response.getBody()});
                errors.add(errorMessage);
            }
            
        } catch(Exception ex){
            errors.add(ex.getMessage());
            System.debug(ex.getMessage() + ' ' + ex.getStackTraceString());
            isSuccess = false;
        }
        return isSuccess;
    }
    
    /**
     * Returns eventual errors generated on the upload process
     * */
    public list<String> getErrors(){
        return this.errors;
    }
    
    /**
     * Returns whether the upload process was sucessful or not 
     * */
    public boolean isSuccess(){
        return this.isSuccess;
    }
 }