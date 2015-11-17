/****************************************************************************************************
* @author:Cognizant
* @date:4/09/2015
* @description:used for IE compatibility
*/

public with sharing class IPM_IECompatible {
	/****************************************************************************************************
    * @description:get browser type as MSIE then put current page header as 'X-UA-Compatible', 'IE= edge'
    * @param:null
    * @return:null
    */
	public static void ieFix(){		
		//IE  Visualforce hack should be in the constructor 
        String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); //gets the browser name 
        if(String.isNotBlank(browserType) && (browserType.contains('MSIE')||(browserType.contains('Trident')))){ // browser values can be taken from salesforce custom setting if required
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE= edge');  // apply IE hack in the constructor
        }
	}    
}