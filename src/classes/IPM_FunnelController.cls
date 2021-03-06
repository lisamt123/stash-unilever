/*	@Description: General class to show the Funel Progress bar based on Project Type.
    @Author: Cognizant Technology
    @Date: Sep 2015
*/
public with sharing class IPM_FunnelController 
{
    public static IPM_Project__c ipmProject {
        get {
            return IPM_Utils.getProjectFullInfo(ApexPages.currentPage().getParameters().get('Id'));
        }
		set;
    }
    public Integer currentProjectPhaseSeq{get; set;}
    
    // Array of Phases for that particular project. 
    public String[] getAssociatedProjectPhases()
    {
        IPM_ProjectMetadata__c projectMetadata = IPM_Utils.getPhasesBasedOnProjectType(ipmProject);
        String phaseSequenceString = IPM_ConstantUtils.BLANK;
        
        if(projectMetadata !=null)
        {
            phaseSequenceString = projectMetadata.IPM_Applicable_Phases__c;
            return phaseSequenceString.split(IPM_ConstantUtils.COMMA);
        }
        else
        {
            return IPM_ConstantUtils.DEFAULT_PHASE_SEQ;
        }
    }
}