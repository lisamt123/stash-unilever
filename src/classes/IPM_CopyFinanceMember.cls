/*
created by rajesh(cognizant)
created date:09-04-2015
description:copy finance owner to finance filed in IPM Project
*/
public with sharing class IPM_CopyFinanceMember{
public list<IPM_Project__c> ipmProject ;
public list<IPM_Project__c> lstIpmProject=new list<IPM_Project__c>();
public final String ROLE_TYPE ='Finance';
public map<id,id> holdPro_Fin;

/***********************************
* @Description: Used for Copying Finance member
* *********************************/

public void copyFinaceMember(list<IPM_Project_Resource__c>lstResource){
    try {
    
        holdPro_Fin=new map<id,id>();

	    for(IPM_Project_Resource__c resM:lstResource){
	        if(resM.IPM_Role_Type__c == ROLE_TYPE && (resM.IPM_Project_Role_Owner__c != null && resM.IPM_Project_Role_Owner__c) && resM.IPM_Project__c!=null && resM.IPM_User__c!=null){
	        holdPro_Fin.put(resM.IPM_Project__c,resM.IPM_User__c);
	        }
	    }
    
	    if(!holdPro_Fin.isEmpty()){
	        IpmProject =new list<IPM_Project__c>();
	        IpmProject=[select id,IPM_Finance_Member__c from IPM_Project__c where id IN:holdPro_Fin.keyset() LIMIT 50000];
	        
	        for(IPM_Project__c proj:IpmProject){
	            
	            if(holdPro_Fin.containskey(proj.id)){
	                IPM_Project__c ipmpro=new IPM_Project__c();
	                ipmpro.id=proj.id;
	                ipmpro.IPM_Finance_Member__c=holdPro_Fin.get(proj.id);
	                lstIpmProject.add(ipmpro);
	            }
	        }
	        
	        update lstIpmProject;
	    }
    }
    catch(Exception ex)
    {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.IPM_ImageRequired));
        ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ConsumerImageUploadController.class.getName(),
            'copyFinaceMember',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
    }


}


}