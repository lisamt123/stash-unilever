/**********************************************************************
Name: BET_CommonServiceHelper
Copyright © 2014 Unilever.
======================================================
==========================================================
Purpose: Serviece helper class
==========================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0     Michal Bluj             21/10/2015      Initial
***********************************************************************/
/* Sharing setting taken from 'parent' class */
public class BET_CommonServiceHelper {

	private BET_CommonServiceHelper() {}

	/*****************************************************************************************
    Purpose: Function to generate template of mail basing on BET, user and custom settings
    Parameters: uw_BET__c, User, BET_Request_Access__c
    Returns: String
    ******************************************************************************************/  
    public static String generateTemplate(uw_BET__c bet, User usr, BET_Request_Access__c settings){
        String siteUrl = String.valueOf(Url.getSalesforceBaseUrl().toExternalForm());

        String template = '<table style="color: #222; font-size: 12px; font-family: Arial, Helvetica, sans-serif; line-height: 15px;" border="0" width="600">'
                            +'<tbody><tr><td>'
                            +'<table style="color: #222; font-size: 12px; font-family: Arial, Helvetica, sans-serif; line-height: 15px;" border="0" width="600">'
                            +'<tbody><tr>'
                            +'<td colspan="2">'
                                +'<div class="headlineText" style="margin-top: 30px; margin-bottom: 19px;">'
                                +'<a href="'+siteUrl+'/'+usr.Id+'" style="text-decoration:none; color: #015ba7;" target="_blank" title="This external link will open in a new window">'+usr.Name+'</a> '
                                +'requested access to the BET <a href="'+siteUrl+'/'+bet.Id+'" style="text-decoration:none; color: #015ba7;" target="_blank" title="This external link will open in a new window">'+bet.Name+'</a> '
                                +'<span style="color:#888;font-size:13px;font-weight:normal;">('+bet.Sharing__c+' With Customers)</span>.<br></div>' 
                            +'</td>'
                            +'</tr>'                  
                            +'<tr><td colspan="2"><div class="messageSmallText" style="width: 600px;">'
                            +'To view this BET, go to: <br><a href="'+siteUrl+'/'+bet.Id+'" style="text-decoration:none; color: #015ba7;" class="smallLinkStyle" target="_blank" title="This external link will open in a new window">'
                            +' '+siteUrl+'/'+bet.Id+'</a></div>'
                            +'</td></tr>'
                            +'</tbody></table></td>'
                            +'</tr><tr><td>'
                            +'<br><div class="footerText">'
                            +'<div class="emailfootertext" emloc="_footer_" style="font-family: Arial, Helvetica, sans-serif; color: #7d7d84; line-height: 14px; font-size: 11px;">'
                            +'This email was sent to the user <a href="'+siteUrl+'/'+bet.OwnerId+'?fromEmail=1" style="text-decoration:none; color: #015ba7;" target="_blank" title="This external link will open in a new window">'+bet.Owner.Email+'</a>.<br>';
                            if(settings.Logo_Url__c != null && settings.Logo_Url__c != ''){
                                template += '<br><img src="'+settings.Logo_Url__c+'" alt="Logo" title="Logo">';
                            }                           
                            template +=''+settings.Footer__c+'</div></div>'
                            +'</td>'
                            +'</tr></tbody></table>';
        return template;
    }

	/*****************************************************************************************
    Purpose: Support method to get a BETShare object 
    Parameters:  uw_BET_Team_Member__c
    Returns: BETShare object 
    ******************************************************************************************/ 
    public static uw_BET__Share deleteBETShare(uw_BET_Team_Member__c teamMember) {
        List<uw_BET__Share> betShareList = [SELECT Id FROM uw_BET__Share WHERE ParentId = :teamMember.Team_Member__c AND userOrGroupId = :teamMember.Id LIMIT 1]; 
        if (betShareList.isEmpty()) {
           System.Debug('No BET Share is found');
           return null;
        }
        
        return betShareList[0];
    }

    /*****************************************************************************************
    Purpose: Support method to get a CollaborationGroupMember object 
    Parameters: uw_BET_Team_Member__c
    Returns: CollaborationGroupMember object
    ******************************************************************************************/
    public static CollaborationGroupMember deleteCollaborationGroupMember(uw_BET_Team_Member__c teamMember) {
        Id chatterGroupId = teamMember.BET__r.Studio_Chatter_Group__c;
        List<CollaborationGroupMember> cgmList = [SELECT Id FROM CollaborationGroupMember WHERE CollaborationGroupId =: chatterGroupId AND memberId=:teamMember.Team_Member__c];
        if ( cgmList.isEmpty()) {
           System.Debug('No CollaborationGroupMember found.');
           return null;
        }
        
        return cgmList[0];
    }

    /*****************************************************************************************
    Purpose: Support method to get an EntitySubscription object
    Parameters: uw_BET_Team_Member__c
    Returns: EntitySubscription object
    ******************************************************************************************/
    public static EntitySubscription deleteEntitySubscription(uw_BET_Team_Member__c teamMember) {
        List<EntitySubscription> entitySubscriptionList = [Select Id,SubscriberId,ParentId from EntitySubscription where SubscriberId=:teamMember.Team_Member__c and ParentId=:teamMember.BET__c LIMIT 1];
        if ( entitySubscriptionList.isEmpty() ) {
           System.Debug('No CollaborationGroupMember found.');
           return null;
        }
        
        return entitySubscriptionList[0];        
    }

	/*****************************************************************************************
    Purpose: Method to add user to a BET as a member
    Parameters: Id, Id
    ******************************************************************************************/
    public static void addUserToPublicBET(uw_BET__c bet, Id userId){
        
        /*BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
        String ToolkitAccessLevel = BETManageMembersConfig.ToolkitAccessLevel__c;
        String InternalUserRecordType = BETManageMembersConfig.InternalUserRecordType__c;
        String BETMemberObjectName = BETManageMembersConfig.BET_Member_Object_Name__c;

        uw_BET_Team_Member__c BETTeamMember = new uw_BET_Team_Member__c();
        List<RecordType> recordTypeIdList = [SELECT Id FROM RecordType WHERE SobjectType = :BETMemberObjectName and Name = :InternalUserRecordType LIMIT 1];
        if ( recordTypeIdList.isEmpty()) {
            System.Debug('No RecordType found');
            return;
        }     
        //recordTypeId = recordTypeIdList[0];
        BETTeamMember.recordTypeId = recordTypeIdList[0].Id;
        BETTeamMember.Team_Member__c = userId;
        BETTeamMember.BET__c = bet.Id;
        BETTeamMember.BETEnabled__c = true;
        BETTeamMember.Access_Level__c = ToolkitAccessLevel;*/
		
		BET_Member_Request__c betMemberRequest = new BET_Member_Request__c();
		betMemberRequest.UserId__c = userId;
		betMemberRequest.Brand_Experience_Toolkit__c = bet.Id;
        betMemberRequest.Status__c = BET_LinkingService.FOLLOW_STATUS_APPROVED;
        betMemberRequest.Do_Not_Notify_Bet__c = true;
        betMemberRequest.External_User_Request__c = false;
        betMemberRequest.Do_Not_Notify_User__c = true;
        betMemberRequest.Role__c = 'Member';

        //  T0-Begin---------------------
        /*done by member trigger
        List<EntitySubscription> eslist= [SELECT Id FROM EntitySubscription
                                                    WHERE SubscriberId=: userId and ParentId=: bet.Id];
        EntitySubscription entitySubscription = new EntitySubscription();
        */
        //T0-End--------------------- 

        /*done by member trigger
        List<CollaborationGroupMember> cgmList = [SELECT Id FROM CollaborationGroupMember 
                                                    WHERE MemberId =: userId and CollaborationGroupId =: bet.Studio_Chatter_Group__c];                                       
        CollaborationGroupMember cgm;
        if (cgmList.isEmpty()) {
            cgm = new CollaborationGroupMember();
            cgm.CollaborationGroupId = bet.Studio_Chatter_Group__c;
            cgm.MemberId = userId;
            cgm.NotificationFrequency = 'N';
            cgm.CollaborationRole = 'Standard';
        }
        
        uw_BET__Share betShare = new uw_BET__Share();
        betShare.UserOrGroupId = userId;
        betShare.AccessLevel = 'Read';
        betShare.ParentId = bet.Id;
        
        */
      
        Savepoint sp = Database.setSavepoint();
        try {
			insert betMemberRequest;
            //insert BETTeamMember;
            /*insert betShare; done by member trigger
            if (cgm!= null) {
                insert cgm;
            }*/
             //T0-Begin---------------------
        /*/*done by member trigger
        if(eslist.isempty())
        {
        entitySubscription.SubscriberId = userId;
        entitySubscription.ParentId = bet.Id;
        if(entitySubscription!=null){
           insert entitySubscription;
            }
              //T0-End---------------------
        }         */
          
        } catch (Exception e) {
           Database.rollback(sp);
           throw new BET_CommonService.BetException('Cannot access BET',e);
        }
    }
}