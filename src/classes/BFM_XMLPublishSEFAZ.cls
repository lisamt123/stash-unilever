public class BFM_XMLPublishSEFAZ {
    private String xmlBody;
    private String accessKey;
    private boolean isSuccess;
    private List<string> errors;
    public BFM_XMLPublishSEFAZ(Id validatedObjectId, String accessKey, String xmlBody){
        this.xmlBody = xmlBody;
        this.accessKey = accessKey;
        this.isSuccess = false;
        this.errors = new List<String>();
    }
    @future(callout=true)
    public static void sendForValidation(string accesskey,id mdfeid,string sessionid){
        boolean isSuccess = true;
       // String accessKey = '123';
       // String xmlbody = '2222';
        List<string> errors;
        try{
            string xmlbody='';
            xmlbody= BFM_AmazonConnector.getFile('00P8A000001dp2e');
            system.debug('ppppppppppppppppppp'+xmlbody);
            BFM_SefazCheck_Utility_CC.sefazcheck(mdfeid,'sad','MDFE',sessionid);
         /*   HttpResponse response = BFM_GeneralServiceCalls.publishXMLforValidation(xmlBody,accessKey);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                isSuccess = true;
                    
            } else{
                isSuccess = false;
                String errorMessage = String.format(Label.BFM_Integration_Failure, new List<String>{String.valueOf(response.getStatusCode()),  
                                                                                response.getStatus(),
                                                                                response.getBody()});
                errors.add(errorMessage);
            }*/
        }catch (Exception ex){
            isSuccess = false;
            System.debug('Integration error: ' + ex.getMessage() +' - ' + ex.getStackTraceString() );
            
        }
        //return isSuccess;
    }
    
    public boolean isSuccess(){
        return this.isSuccess;
    }
    
    public List<String> getErrors(){
        return this.errors;
    }
    
}