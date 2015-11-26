/****************************************************************************************************
* @author:Cognizant
* @date:4/09/2015
* @description:used for IE compatibility
*/

public with sharing class IPM_IECompatible {
	
	private static final string USER_AGENT = 'USER-AGENT';
	private static final string MSIE = 'MSIE';
	private static final string TRIDENT = 'Trident';
	private static final string X_UA_CIMPATIBLE = 'X-UA-Compatible';
	private static final string IE_EDGE = 'IE= edge';
	
	/****************************************************************************************************
    * @description:get browser type as MSIE then put current page header as 'X-UA-Compatible', 'IE= edge'
    * @param:null
    * @return:null
    */
	public static void ieFix(){		
		//IE  Visualforce hack should be in the constructor 
        String browserType = Apexpages.currentPage().getHeaders().get(USER_AGENT); //gets the browser name 
        if(String.isNotBlank(browserType) && (browserType.contains(MSIE)||(browserType.contains(TRIDENT)))){ // browser values can be taken from salesforce custom setting if required
            Apexpages.currentPage().getHeaders().put(X_UA_CIMPATIBLE,IE_EDGE );  // apply IE hack in the constructor
        }
	}    
}