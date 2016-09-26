public class BFM_PODUpload {
	
    private Id podFileId;
    private List<String> errors;
    private boolean isSuccess;
    private BFM_File__c podFile;
    private blob podFileBody;
    
    
    public BFM_PODUpload(BFM_File__c podFile, blob podFileBody){
    	this.podFile = podFile;
        this.errors = new List<String>();
        this.isSuccess = false;
        this.podFileBody = podFileBody;
    }
    
    public boolean uploadPOD(){
        
        try{
        	
            String response = BFM_GeneralServiceCalls.podUpload(podFile.File_Name__c, System.now(), 
                                                                podFile.Content_Type__c, podFile.size__c, podFileBody);
            isSuccess = true;
        } catch(Exception ex){
            errors.add(ex.getMessage());
            System.debug(ex.getMessage() + ' ' + ex.getStackTraceString());
            isSuccess = false;
        }
        return isSuccess;
    }
    
    public list<String> getErrors(){
        return this.errors;
    }
    
    public boolean isSuccess(){
        return this.isSuccess;
    }
}