@IsTest
public class BFM_UpdateFreightDataRequest_Test {
	
	static testMethod void testParse() {
		String json = '{\"UpdateFreightData\":'+
		'    {\"vehiclePlate\":\"strings\",'+
		'     \"shipment\":'+
		'      {\"shipmentId\": \"stringstri\",'+
		'       \"checkoutDateTime\":\"2017-01-15\"},'+
		'     \"occurrence\":'+
		'      {\"occurrenceNumber\":\"stringstri\"}}}';
		BFM_UpdateFreightDataRequest obj = BFM_UpdateFreightDataRequest.parse(json);
		System.assert(obj != null);
	}
	
    public static testMethod void bfm_updateFreightDataTestMethod(){
        
        BFM_UpdateFreightDataRequest.getInstance('plate','12345678','34567214');
    }

}