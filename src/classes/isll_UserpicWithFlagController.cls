/**********************************************************************
 Name:  isll_UserpicWithFlagController
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Controller for isll_UserpicWithFlag component
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      07/08/2013      INITIAL DEVELOPMENT 
***********************************************************************/
public with sharing class isll_UserpicWithFlagController {
	public User cUser {get; set;}
	
	public String getIconName(){
		String res;
		res = getCoutry(cUser.LocaleSidKey);
		return res;
	}
	
	//method calculates short abbreviation of country
	public static String getCoutry(String locale){
		String res;
		
		String[] splited = locale.split('_');
		if(splited.size()>1){
			res = splited[1];
		} else {
			res = splited[0];
		}
		
		return res.toLowerCase();
	}

}