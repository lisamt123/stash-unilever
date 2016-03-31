/*************************************************************************************
Name : BET_LinkingServiceHelper

Purpose : Helper class for BET_LinkingService

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  28-09-2015  Initial
1.1        blessy.voola@accenture.com 24-Mar-2016    Do not send notification to inactive BET owner
*************************************************************************************/

/* Service helper class takes sharings settings from parent class */
public class BET_LinkingServiceHelper {

    private BET_LinkingServiceHelper() {}

    /************************************************************
        Purpose: Method indicates if given project is bet lead
        Parameters: Id ProjectId, uw_Bet__c bet
        Returns: Boolean
        Throws: -
    *************************************************************/  
    public static Boolean isProjectALead(Id ProjectId, uw_Bet__c bet){
        System.debug('Entering isProjectALead : ' + bet + ', ' + ProjectId);
        Boolean result = bet.IPM_Project__c != null && bet.IPM_Project__c == ProjectId;
        System.debug('Exit isProjectALead : ' + result);
        return result;
    }

    /************************************************************
        Purpose: Method retreives other lead project the one with greatest tlsd
        Parameters: Id ProjectId, Id BetId
        Returns: IPM_BETWrapper
        Throws: -
    *************************************************************/  
    public static IPM_BETWrapper getOtherFollowingProject(Id ProjectId, Id BetId){
        System.debug('Entering getOtherFollowingProject : ' + ProjectId + ', ' + BetId);
        IPM_BETWrapper wrapper = null;
        Date minTLD = Date.newInstance(2070,1,1);
        for(IPM_BETWrapper wrap : IPM_BETUpdateService.returnIPM(BetId)){
            if(wrap.projectId != ProjectId && wrap.targetLaunchDate != null && wrap.targetLaunchDate < minTLD){
                minTLD = wrap.targetLaunchDate;
                wrapper = wrap;
            }
        }
        System.debug('Exit getOtherFollowingProject : ' + wrapper);
        return wrapper;
    }

    /************************************************************
        Purpose: Method archives and sets ipm project to null
        Parameters: uw_Bet__c bet
        Returns: -
        Throws: -
    *************************************************************/  
    public static void archiveAndUnLeadBet(uw_Bet__c bet){
        System.debug('Entering archiveAndUnLeadBet : ' + bet);
        bet.Is_Archived__c = true;
        bet.IPM_Project__c = null;
        update bet;
        System.debug('Exit archiveAndUnLeadBet : ' + bet);
    }

    /************************************************************
        Purpose: Method sets new lead project and new owner if necessary
        Parameters: uw_Bet__c bet, IPM_Project__c project, IPM_Project__c oldProject
        Returns: -
        Throws: -
    *************************************************************/
    public static uw_Bet__c setNewLeadProjectAndOwner(uw_Bet__c bet, IPM_BETWrapper project,IPM_BETWrapper oldProject){
        System.debug('Entering setNewLeadProjectAndOwner : ' + bet + ', ' + project + ', ' + oldProject);
        if(oldProject.pLId != null && oldProject.pLId == bet.ownerId){
            bet.ownerId = project.pLId;
        } else {
        //Do not send notification if BET owner is inactive
        List<User> owner=[select id,isactive from user where id=:bet.ownerid];
        if(owner.size()>0){
        if(owner.get(0).isactive)
          BET_EmailNotificationService.notifyBetOwnerThatProjectIsUnlinked(bet,oldProject,project); //US23
            }
        }
        bet.IPM_Project__c = project.projectId;
        uw_Bet__c updatedBet = BET_BETService.updateBetFields(bet,project);
        update updatedBet;
        System.debug('Exit setNewLeadProjectAndOwner : ' + updatedBet);
        return updatedBet;
    }

    /************************************************************
        Purpose: Method creates member requests
        Parameters: BET_Follow_Request__c followRequest,uw_Bet__c relatedBet,String Role, String user
        Returns: BET_Member_Request__c object
        Throws: -
    *************************************************************/
    public static BET_Member_Request__c createMemberRequest(BET_Follow_Request__c followRequest,uw_Bet__c relatedBet,String Role, String user){
        return new BET_Member_Request__c(Brand_Experience_Toolkit__c = relatedBet.id, UserId__c = user, Role__c = role,
                                        ProjectRequest__c = followRequest.id, Project_Id__c = followRequest.Project_Id__c, BET_owner__c = relatedBet.ownerid);
    }

    /************************************************************
        Purpose: Method creates manager requests for new PL
        Parameters: Id newPL,uw_Bet__c bet, IPM_Project__c newProject
        Returns: -
        Throws: -
    *************************************************************/
    public static void createMemberRequestForNewPL(Id newPL,uw_Bet__c bet, IPM_BETWrapper newProject){
        BET_Member_Request__c request = new BET_Member_Request__c(Brand_Experience_Toolkit__c = bet.id, UserId__c = newPL, Role__c = 'Manager',
                              Project_Id__c = newProject.projectId, BET_owner__c = bet.ownerid, Status__c = 'New',Do_Not_Notify_Bet__c = true);
        insert request;
        request.Status__c = 'Approved';
        update request;
    }
}