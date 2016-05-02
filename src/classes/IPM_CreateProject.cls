/************************************************* 
*@Author:Cognizant
*@Date:January 2015
*@Description :  To create new project and bosscard
*@Referring in createprojectsv page
**************************************************/
Global with sharing class IPM_CreateProject { //It is global class since we have used a remote action method in this class
    //@Description :For inserting a project on click of My project will not have a BOSSCARD.  
    //public IPM_Project__c ipmProject{get;set;}
    
    //@Description :To capture the project ID and pass it as a parameter.
    //public string projectid{get;set;}
    
    //@Description : To understand whether the BOSSCARD is editable or not.
    public string isBoosEdtable{get;set;}
    
    //@Description : To understand whether the Project is editable or not.
    public string isProEditable{get;set;}
    
    private static final string CLASS_NAME = 'IPM_CreateProject';
    
    /**************************************************************************************
    *@Description :Constructor to read the information from the page paramaters 
    ***************************************************************************************/    
    public IPM_CreateProject(){
        isBoosEdtable=apexpages.currentpage().getparameters().get('IsBossCardEditable');
        isProEditable=apexpages.currentpage().getparameters().get('IsProjectEditable');
    }
    
    /*************************************************************** 
    *@Description :For creating the project.
    *@return:project id
    ****************************************************************/   
    @Remoteaction
    global static id CreateProjectId(){
        
        IPM_Project__c ipmProject=new IPM_Project__c();
        try {
            
            // Insert the project.
            ipmProject.IPM_Project_Leader__c=userinfo.getuserid();
                insert ipmProject; //Need to insert only one project
                return ipmProject.id;
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                'createBosscard',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);                            
            return null;
        }
        
    }
    /*************************************************************** 
    *@Description :For creating the bosscard.
    *@return:bosscard id
    ****************************************************************/   
    @Remoteaction
    global static id createBosscard(){
        
        IPM_Bosscard__c ipmBosscard=new IPM_Bosscard__c();
        try {
            
            // Insert the bosscard.
            insert ipmBosscard; //Need to insert only one bosscard
            return ipmBosscard.id;
        }
        catch(Exception ex){
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                'createBosscard',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);                            

            return null;                                      
        }
    
    }
}