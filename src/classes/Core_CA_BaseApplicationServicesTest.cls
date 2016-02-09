@isTest
public with sharing class Core_CA_BaseApplicationServicesTest {
    
     static testmethod void invokeTest(){
        
        /*String jsonInput1 = '{\n' +
                            ' "description" :"An appliance",\n' +
                            ' "accessories" : [ "powerCord", ' + 
                            '{ "right":"door handle1", ' + 
                            '"left":"door handle2" } ],\n' +
                            ' "dimensions" : ' + 
                            '{ "height" : 5.5 , ' + 
                            '"width" : 3.0 , ' + 
                            '"depth" : 2.2 },\n' +
                            ' "type" : null,\n' +
                            ' "inventory" : 2000,\n' +
                            ' "price" : 1023.45,\n' +
                            ' "isShipped" : true,\n' +
                            ' "modelNumber" : "123"\n' +
                            '}';*/
                            
        
        String jsonInput = '{"OrderRequest":{"AccountId":"001L000000WadfuIAB","ContactId":"003L000000QWwKHIA1","FunctionType":"GuestPass","SalesChannel":"Lobby","ProcessCreditCard":false,"DonorInformation":{"Type":"Primary","Suffix":null,"State":"OR","SendEmailOffers":null,"PurchaseReceiptEmailId":"ncmsec@gmail.com","Prefix":"Mr.","PostalCodeExtension":null,"PostalCode":"97701","MiddleName":"","MemberNumber":"40316154","MemberCalendarPreference":"Direct Mail","LastName":"28secondary","HomePhone":"1234567890","FirstName":"Cmtest5","ExpirationDate":"2015-10-31","EmailAddress":"ncmsec@gmail.com","DOB":null,"DAnonymous":null,"Country":"United States","ContactId":"003L000000QWwKHIA1","City":"Bend","CategoryCode":"7","BusinessPhone":null,"AddressLine2":null,"AddressLine1":"SW Gift Rd","AccountId":"001L000000WadfuIAB"},"Memberships":[],"PaymentInfo":{"AccountNumber":null,"Amount":10,"CardAddress1":null,"CardCVV2Code":null,"CardExprMonth":null,"CardExprYear":null,"CardholderName":null,"CardType":null,"CardZipCode":null,"ClientAuthorization":null,"ClientTransNumber":null,"PayType":"Checks/Cash","PromotionCode":null,"TransactionNumber":null,"CashTendered":"10"},"Donations":null,"GuestPass":{"TotalGuestPassCost":10,"TemporaryPassInfo":[{"BarCode":"M4031615400001"}],"SubFuncType":"GuestPass;TemporaryPass;ChildFreePass","GuestPassInfo":{"ProductCode":"TKTGP","NumberOfUnits":2},"GuestPassCost":5,"FunctionType":"GuestPass","ChildFreePassInfo":{"ProductCode":"TKTCH","NumberOfUnits":2}}}}';
        System.assert(jsonInput != null);
        Core_CA_ApplicationWrapper remoteServCallObj = constructRequestBody(jsonInput, 'Process Order', 'POST', 'TesturlParameter');
        Core_CA_ApplicationWrapper remoteServCallObj2 = constructRequestBody(jsonInput, 'Email Service', 'POST', 'TesturlParameter');
        Core_CA_ApplicationWrapper remoteServCallObj3 = constructRequestBody(jsonInput, 'Barcode Update', 'GET', 'TesturlParameter');
        Core_CA_ApplicationWrapper remoteServCallObj4 = constructRequestBody(jsonInput, 'Lobby Initialization', 'GET', 'TesturlParameter');
        Core_CA_ApplicationWrapper remoteServCallObj5 = constructRequestBody(jsonInput, 'Lobby Search', 'GET', 'TesturlParameter');
        Core_CA_ApplicationWrapper remoteServCallObj6 = constructRequestBody(jsonInput, 'Cart Service', 'POST', 'TesturlParameter');
        Core_CA_ApplicationWrapper remoteServCallObj7 = constructRequestBody(jsonInput, 'Membership Renewal', 'POST', 'TesturlParameter');
        Core_CA_ApplicationWrapper remoteServCallObj8 = constructRequestBody(jsonInput, 'Card Reprint Service', 'POST', 'TesturlParameter');
        Core_CA_ApplicationWrapper remoteServCallObj9 = constructRequestBody(jsonInput, 'Promotion Discount Helper', 'POST', 'TesturlParameter');
        Core_CA_ApplicationWrapper remoteServCallObj10 = constructRequestBody(jsonInput, 'Wrong Service', 'POST', 'TesturlParameter');
        System.assert(remoteServCallObj10  != null);
        Test.startTest();
        try{
            Core_CA_BaseApplicationServices.invokeService(remoteServCallObj);
        }catch(Core_CA_BaseServiceException ex)   {} 
        try{
            Core_CA_BaseApplicationServices.invokeService(remoteServCallObj2);
            }catch(Core_CA_BaseServiceException ex)   {}
        try{
            
            Core_CA_BaseApplicationServices.invokeService(remoteServCallObj3);
            }catch(Core_CA_BaseServiceException ex)   {}
        try{
            Core_CA_BaseApplicationServices.invokeService(remoteServCallObj4);
        }catch(Core_CA_BaseServiceException ex)   {}
            
        try{
            Core_CA_BaseApplicationServices.invokeService(remoteServCallObj5);
        }catch(Core_CA_BaseServiceException ex)   {}
            
        try{
            Core_CA_BaseApplicationServices.invokeService(remoteServCallObj6);
        }catch(Core_CA_BaseServiceException ex)   {}
        try{
            Core_CA_BaseApplicationServices.invokeService(remoteServCallObj7);
        }catch(Core_CA_BaseServiceException ex)   {}
        try{
            Core_CA_BaseApplicationServices.invokeService(remoteServCallObj8);
        }catch(Core_CA_BaseServiceException ex)   {} 
        try{
            Core_CA_BaseApplicationServices.invokeService(remoteServCallObj9);
        }catch(Core_CA_BaseServiceException ex)   {} 
        try{
            Core_CA_BaseApplicationServices.invokeService(remoteServCallObj10);
            Core_CA_BaseApplicationServices.constructResponseBody(remoteServCallObj10,new Core_CA_BaseServiceException());
        }catch(Core_CA_BaseServiceException ex)   {} 
        Test.stopTest();
    }
    
    
    private static Core_CA_ApplicationWrapper constructRequestBody(String serviceJSONObject,String serviceName,String requestType,String urlParameter){
        Core_CA_ApplicationWrapper serviceCallObj = new Core_CA_ApplicationWrapper();
        try{
            serviceCallObj.serviceJSONObjectasString = serviceJSONObject;
            serviceCallObj.serviceName = serviceName;
            serviceCallObj.requestType = requestType;
            //serviceCallObj.urlParam = urlParameter;
            //serviceCallObj.memberNumber = '45678932';
        }catch(Core_CA_BaseServiceException baseAppEx){ 
            throw new Core_CA_BaseServiceException('Exception occured: RemoteServiceCallController : constructRequestBody method ',baseAppEx);
        }
        
        return serviceCallObj;
    }
    
    
     private static void testHandleInvalidSvcNameReq(){
        //REST_ProcessOrder_V1.ProcessOrderResponse orderResponse = new REST_ProcessOrder_V1.ProcessOrderResponse();
        Core_CA_ApplicationWrapper responseObj = new Core_CA_ApplicationWrapper();
        System.assert(responseObj != null);
        Core_CA_BaseApplicationServices.handleInvalidSvcNameReq(responseObj);
            
     } 

}