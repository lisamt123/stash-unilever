@RestResource(urlMapping='/MulesoftMock/v1/XMLPublish/v1/*')
global class BFM_MulesoftMock_XMLPublish {
	@HttpPost
    global static String publishXML(){
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name = 'BFM_XML_Publish_XML_Response_Error' LIMIT 1];
        String responseXML = sr.Body.toString();
        return responseXML;
    }
}