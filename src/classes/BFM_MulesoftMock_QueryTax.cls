@RestResource(urlMapping='/MulesoftMock/v1/QueryTax/v1/*')
global class BFM_MulesoftMock_QueryTax {

    @HttpPost
    global static String queryTax(){
        try{
        	StaticResource res = [SELECT Body FROM StaticResource WHERE Name = 'BFM_Query_Tax_Response'];
        	return res.body.toString();
        } catch(Exception e){
            System.debug ('Error retrieving StaticResource body ' +  e.getMessage());
            return null;
        }
    }
}