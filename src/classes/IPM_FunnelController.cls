/*  @Description: General class to show the Funel Progress bar based on Project Type.
    @Author: Cognizant Technology
    @Date: Sep 2015
*/
public with sharing class IPM_FunnelController  
{
    public static IPM_Project__c ipmProject {
        get {
            If(ipmProjectclone!=null) {
                return ipmProjectclone;
            }
            else {
                ipmProjectclone = [SELECT id, IPM_Project_Name__c, IPM_Phase__c, IPM_Bosscard_Status__c, IPM_SourceProjectType__c, IPM_Project_Type__c, IPM_CompanyCardText__c FROM IPM_Project__c WHERE id=:ApexPages.currentPage().getParameters().get('Id') limit 1]; return ipmProjectclone;
            }
        }
        set;
    }
    public static IPM_Project__c ipmProjectclone;
    public Integer currentProjectPhaseSeq{
        get; 
        set;
    }
    
    // Array of Phases for that particular project. 
    public String[] getAssociatedProjectPhases()
    {
        IPM_ProjectMetadata__c projectMetadata = IPM_Utils.getPhasesBasedOnProjectType(ipmProject);
        String phaseSequenceString = IPM_ConstantUtils.BLANK;
        
        if(projectMetadata !=null)
        {
            phaseSequenceString = projectMetadata.IPM_Applicable_Phases__c; return phaseSequenceString.split(IPM_ConstantUtils.COMMA);
        }
        else
        {
            return IPM_ConstantUtils.DEFAULT_PHASE_SEQ;
        }
    }
}