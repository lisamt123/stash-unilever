/*	@Description: General class to show the Funel Progress bar based on Project Type.
    @Author: Cognizant Technology
    @Date: Sep 2015
*/
public with sharing class IPM_FunnelController 
{
<<<<<<< HEAD
    public IPM_Project__c project {get;set;}
	public Integer currentProjectPhaseSeq{get; set;}
	
	// Array of Phases for that particular project.	
=======
    public IPM_Project__c ipmProject {get;set;}
    public Integer currentProjectPhaseSeq{get; set;}
    
    // Array of Phases for that particular project. 
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
    public String[] getAssociatedProjectPhases()
    {
        IPM_ProjectMetadata__c projectMetadata = IPM_Utils.getPhasesBasedOnProjectType(project);
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