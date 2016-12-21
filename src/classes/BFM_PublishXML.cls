/**
 * Class for providing publish XML functionality to upload xml files to Mulesoft
 * */
public class BFM_PublishXML {

    private blob xmlBody;
    
    private String NULL_XML_ERROR = 'XML Body was null';
    private List<String> errors;
    private BFM_File__c xmlFile;
    public BFM_PublishXML(BFM_File__c file, blob xmlBody){
        this.xmlBody = xmlBody;
        this.errors = new List<String>();
        this.xmlFile = file;
    }
    
    public boolean doPublish(){
        boolean isSuccess = true;
        if(xmlBody == null){
            this.errors.add(NULL_XML_ERROR);
        	isSuccess = false;   
        }
        HttpResponse response = BFM_GeneralServiceCalls.publishXML(xmlBody, xmlFile.File_Name__c, xmlFile.Size__c);
        System.debug('response status code on publish xml ' + response.getStatusCode());
        if(response.getStatusCode() != 200 && response.getStatusCode() != 201){
            System.debug('entrei no if');
            isSuccess = false;
            if(response.getStatusCode() == 400){
            	this.errors.add('Integration Error: Bad Request');
            }
        }
        
        return isSuccess;
    }
    public List<String> getErrors(){
        return this.errors;
    }
    
}