/**********************************************************************
Name: BET_ManageMembersContoller
Copyright © 2014 Unilever.
======================================================
==========================================================
Purpose: Apex controller to manage BET members
Used in: BET_ManageMembers VisualForce page
==========================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          12/12/2014      INITIAL DEVELOPMENT
1.1-    Blessy Voola            28 Apr 2015   T0: Fix for the issue: If a user is already added to chatter group, when trying to 
                                                 add the same user to the bet associated it is showing error
1.2    Kendre Dnyaneshwar       27 Apr 2015   T1: Modified the query in getmembers method to remove delete button for BET 
                                                 owner                                      
1.3     Michal Bluj             03/08/2015      Sonar related issues fixes
1.4     Michal Bluj             11/08/2015      IPM Member Related Changes
***********************************************************************/

public without sharing class BET_ManageMembersController {
    public BET_Member_Request__c BETTeamMember {get;set;}
    public Id betId {get;set;}
    public Boolean selectAll {get;set;}
    public List<MemberRequestWrapper> memberRequests {get;set;}
    public List<MemberWrapper> members {get;set;}

    public Id selectedRequestId {get;set;}
    public Boolean isBetOwnerOrManager {get;set;}
    
    public BET_ManageMembersController(ApexPages.StandardController controller) {
        betId = (Id)ApexPages.currentPage().getParameters().get('bet');
        BETTeamMember = new BET_Member_Request__c();
        selectAll = false;
        isBetOwnerOrManager = BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betId, UserInfo.getUserId());

        memberRequests = new List<MemberRequestWrapper>();
        for(BET_Member_Request__c request : [select id,  ProjectRequest__r.Project_Name__c, UserId__r.FirstName,UserId__r.LastName, UserId__r.SmallPhotoUrl 
                                                from BET_Member_Request__c where Brand_Experience_Toolkit__c =: betId and Status__c = 'New']){
            memberRequests.add(new MemberRequestWrapper(request));
        }

        /*MemberRequestWrapper test = new MemberRequestWrapper();
        test.firstName = 'Michał';
        test.lastName = 'Bluj';
        test.projectName = 'Project 1';
        test.isSelected = false;

        MemberRequestWrapper test1 = new MemberRequestWrapper();
        test1.firstName = 'Piotr';
        test1.lastName = 'Czechumski';
        test1.projectName = 'Project 2';
        test1.isSelected = false;

        MemberRequestWrapper test2 = new MemberRequestWrapper();
        test2.firstName = 'Michael';
        test2.lastName = 'Baker';
        test2.projectName = 'Project 3';
        test2.isSelected = false;

        memberRequests.add(test);
        memberRequests.add(test1);
        memberRequests.add(test2);*/


        members = new List<MemberWrapper>();

        /*MemberWrapper wrap = new MemberWrapper();
        wrap.firstName = 'Michał';
        wrap.lastName = 'Bluj';
        wrap.isSelected = false;
        wrap.role = 'Member';
        wrap.obj = new uw_BET_Team_Member__c();

        MemberWrapper wrap1 = new MemberWrapper();
        wrap1.firstName = 'Piotr';
        wrap1.lastName = 'Czechumski';
        wrap1.isSelected = false;
        wrap1.role = 'Manager';
        wrap1.obj = new uw_BET_Team_Member__c();

        members.add(wrap);
        members.add(wrap1);*/

    }

    public void addMember(){

    }

    public void addExternalMember(){

    }

    public PageReference doDelete(){
        return null;
    }

    public PageReference doApprove(){
        BET_Member_Request__c request = [select Status__c from BET_Member_Request__c where id=:selectedRequestId];
        request.Status__c = 'Approved';
        update request;
        return forward();
    }

    public PageReference doDeny(){
        BET_Member_Request__c request = [select Status__c from BET_Member_Request__c where id=:selectedRequestId];
        request.Status__c = 'Rejected';
        update request;
        return forward();
    }

    public PageReference massApprove(){
        List<BET_Member_Request__c> requests = new List<BET_Member_Request__c>();
        for(MemberRequestWrapper memberRequest : memberRequests){
            if(memberRequest.isSelected){
                memberRequest.obj.Status__c = 'Approved';
                requests.add(memberRequest.obj);
            }
        }
        update requests;
        return forward();
    }

    public PageReference massDeny(){
        List<BET_Member_Request__c> requests = new List<BET_Member_Request__c>();
        for(MemberRequestWrapper memberRequest : memberRequests){
            if(memberRequest.isSelected){
                memberRequest.obj.Status__c = 'Rejected';
                requests.add(memberRequest.obj);
            }
        }
        update requests;
        return forward();
    }

    public PageReference massDelete(){
        return null;
    }

    private PageReference forward(){
        PageReference pr = new PageReference('/apex/BET_ManageMembers?bet='+betId);
        pr.setRedirect(true);
        return pr;
    }

    public class MemberRequestWrapper{
        public BET_Member_Request__c obj {get;set;}
        public Boolean isSelected {get;set;}
        public String projectName {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String photo {get;set;}
        public Id objectId {get;set;}

        public MemberRequestWrapper(){}

        public MemberRequestWrapper(BET_Member_Request__c request){
            this.obj = request;
            projectName = request.ProjectRequest__r.Project_Name__c;
            firstName = request.UserId__r.FirstName;
            lastName = request.UserId__r.LastName;
            photo = request.UserId__r.SmallPhotoUrl;
            this.isSelected = false;
            objectId = request.id;
        }

    }

    public class MemberWrapper{
        public Boolean isSelected {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String photo {get;set;}
        public Id objectId {get;set;}
        public String role {get;set;}
        public uw_BET_Team_Member__c obj {get;set;}
    }
  
}