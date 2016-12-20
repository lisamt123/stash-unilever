public class BFM_ValidateFiscalDocumentsRequest {

  public ValidateFiscalDocument validateFiscalDocument;

  public class ValidateFiscalDocument {
    public String requestType;
    public List<String> accessKey;
  }

    public BFM_ValidateFiscalDocumentsRequest(List<String> accessKeys){
        this.validateFiscalDocument = new BFM_ValidateFiscalDocumentsrequest.ValidateFiscalDocument();
        this.validateFiscaldocument.requestType='A';
        //this.validateFiscaldocument.accessKey = accessKeys;
        //List<string> acckey=new List<string>();
        //acckey.add('35161166036146000103577980000000031121055558');
        this.validateFiscaldocument.accessKey = accessKeys;
        
    }
  public static BFM_ValidateFiscalDocumentsRequest parse(String json) {
    return (BFM_ValidateFiscalDocumentsRequest) System.JSON.deserialize(json, BFM_ValidateFiscalDocumentsRequest.class);
  }
}