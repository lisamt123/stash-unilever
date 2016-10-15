/**********************************************************************
 Name:  isll_EventController
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:the class for isll_EventController. Manages the creation and edit of a event                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     27/08/2013        INITIAL DEVELOPMENT         Story id:USLL-55   
 
***********************************************************************/
public with sharing class isll_EventController {
    private Event__c theEvent;
    private Map<id, Event_Member__c> eventMemberMap; 
    private boolean refreshMembersMap;
    public boolean updatePotentialExpertUserList = true;
    private ApexPages.StandardController standardController;
    private id externalMemberProfileId;

    public static final String EXTERNAL_MEMBER_PROFILE = 'ISLL External Event Member';
    public List<SelectOption> selectedUsers {get;set;}
    public List<SelectOption> selectedExternalUsers {get;set;}
    public List<SelectOption> expertUserList {get;set;}
    public string search {get;set;}
    public string newChatterGroupName {get;set;}
    public string exChatterGroupName {get;set;}
    public string externalAttendeeEmails {get;set;}
    public string eventURL {get;set;}
    public string existingGroupId {get; set;}

    public isll_EventController(){
        if(currentDate == null){
            currentDate = Date.newInstance(Date.today().year(), Date.today().month(), 1);
        }
        selectedUsers = new List<SelectOption>();
        selectedExternalUsers = new List<SelectOption>();
    }

    public isll_EventController(ApexPages.StandardController standardController) {
        externalMemberProfileId = [select id from Profile where name =  :EXTERNAL_MEMBER_PROFILE][0].id;
        updatePotentialExpertUserList = true;
        refreshMembersMap = true;
        this.standardController = standardController;
        theEvent = (Event__c) standardController.getRecord();
        selectedUsers = new List<SelectOption>();
        selectedExternalUsers = new List<SelectOption>();
        if(theEvent.id != null){
            theEvent = [select Chatter_Group_Name__c, locked__c from Event__c where id = :theEvent.id ];
            if(String.isNotEmpty(theEvent.Chatter_Group_Name__c)){
                try {
                    exChatterGroupName = [select Name from CollaborationGroup where id = :theEvent.Chatter_Group_Name__c].Name;
                    existingGroupId = theEvent.Chatter_Group_Name__c;
                } catch(Exception ex) {
                    //theEvent.Chatter_Group_Name__c = null;
                }
            }
        }

        //get event members
        eventMemberMap = new Map<id, Event_Member__c>();
        for(Event_Member__c aMember : [ select id, name, User__c, User__r.Name, Member_Type__c, User__r.Email, User__r.SmallPhotoUrl, 
                                            User__r.LocaleSidKey, Event__c, Is_Expert__c 
                                        from Event_Member__c 
                                        where Event__c = :theEvent.id order by User__r.Name]){
            eventMemberMap.put(aMember.User__c, aMember);
        }

            //get user names
        for(Event_Member__c aUser :  eventMemberMap.values()){
            if(aUser.Member_Type__c == 'Internal'){
                selectedUsers.add(new SelectOption(aUser.User__c, aUser.User__r.Name));
            }
            else if(aUser.Member_Type__c == 'External'){
                selectedExternalUsers.add(new SelectOption(aUser.User__c, aUser.User__r.Name));
            }
        }

        eventURL =  URL.getSalesforceBaseUrl().toExternalForm()+Page.isll_EventsDetail.getUrl()+'?id='+theEvent.id;
        
    }


    /*******************************************************************
       Purpose:  the attachment which stores the event header image                                                      
       Returns: Attachment -                                                        
    ********************************************************************/
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }

    /*******************************************************************
       Purpose:  the attachment which stores the event logo                                                      
       Returns: Attachment -                                                        
    ********************************************************************/
    public Attachment attachmentLogo {
        get {
            if (attachmentLogo == null)
                attachmentLogo = new Attachment();
            return attachmentLogo;
            }
        set;
    }


    public String attendeeEmails{
        get{
            attendeeEmails = '';
            externalAttendeeEmails = '';
            for(Event_Member__c aMember : [ select id, User__r.Email, Member_Type__c 
                                            from Event_Member__c 
                                            where Event__c = :theEvent.id order by User__r.Name]){
                if(aMember.Member_Type__c == 'Internal'){
                    attendeeEmails += aMember.User__r.Email+', ';
                }
                else if(aMember.Member_Type__c == 'External'){
                    externalAttendeeEmails += aMember.User__r.Email+', ';
                }
                
            }
            externalAttendeeEmails = externalAttendeeEmails.removeEnd(', ');
            return attendeeEmails.removeEnd(', ');
        }
        set;
    }


    public List<SelectOption> userList {
        get{
            Set<id> selectedUserId = new Set<id>();
            userList = new List<SelectOption>();
            if(null != selectedUsers){
                for(SelectOption selectedUser :selectedUsers){
                    selectedUserId.add(selectedUser.getValue());
                }
            }
            if(String.isNotBlank(search)){
            	String query = 'select id, name, lastname from User  where name like \'%'+String.escapeSingleQuotes(search)+'%\' and IsActive = true Limit 1000';
                for(User aUser : Database.query(query)){
                    if(!selectedUserId.contains(aUser.id)){
                        userList.add(new SelectOption(aUser.id, aUser.Name));
                    }
                }
            }
            return userList;
        }
        set;
    }

    public List<SelectOption> externalUserList {
        get{
            Set<id> selectedUserId = new Set<id>();
            externalUserList = new List<SelectOption>();
            if(null != selectedExternalUsers){
                for(SelectOption selectedUser :selectedExternalUsers){
                    selectedUserId.add(selectedUser.getValue());
                }
            }
            
            for(User aUser : [select id, name, lastname from User  where profileId = :externalMemberProfileId and IsActive = true Limit 1000]){
                if(!selectedUserId.contains(aUser.id)){
                    externalUserList.add(new SelectOption(aUser.id, aUser.Name));
                }
            }
            
            return externalUserList;
        }
        set;
    }

    public List<SelectOption> potentialExpertUserList {
        get{
            if(updatePotentialExpertUserList){
                potentialExpertUserList = new List<SelectOption>();
                expertUserList = new List<SelectOption>();
                for(Event_Member__c aMember : [ select id, name, User__c, User__r.Name, User__r.SmallPhotoUrl, User__r.LocaleSidKey, User__r.Email, 
                                                    Event__c, Is_Expert__c, Member_Type__c 
                                                from Event_Member__c 
                                                where Event__c = :theEvent.id order by User__r.Name]){
                    eventMemberMap.put(aMember.User__c, aMember);
                }
                for(Event_Member__c aMember : eventMemberMap.values()){
                    if(!aMember.Is_Expert__c){
                        potentialExpertUserList.add(new SelectOption(aMember.id, aMember.User__r.Name));
                    }
                    else{
                        expertUserList.add(new SelectOption(aMember.id, aMember.User__r.Name));
                    }
                }
                updatePotentialExpertUserList = false;
            }
            return potentialExpertUserList;
        }
        set;
    }

    
    private Map<id, CollaborationGroupMember> memberMapByUser{
        get{
            if(refreshMembersMap){
                memberMapByUser = new Map<id, CollaborationGroupMember>();
                for(CollaborationGroupMember aMember : [select Memberid, CollaborationRole  
                                                        from CollaborationGroupMember 
                                                        where CollaborationGroupId = : theEvent.Chatter_Group_Name__c]){
                    memberMapByUser.put(aMember.Memberid, aMember);
                }
                refreshMembersMap = false;
            }
            return memberMapByUser;
        }
        set;
    }

    public PageReference save()
    {
        Savepoint sp = Database.setSavepoint();
        PageReference returnRef;
        try
        {

            if (newChatterGroupName == null && existingGroupId == null)
            {
                addError('You must enter a new Chatter Group Name, or select and existing Chatter Group.');
                return null;
            }

            if (theEvent.Id == null && [Select Id From CollaborationGroup Where Name = :newChatterGroupName].size() > 0)
            {
                addError('A Chatter Group with this name already exists. Please create a different name, or select the existing group from the Existing Group option');
                return null;
            }

            // Link to existing Chatter Group
            if (existingGroupId != '' && existingGroupId != null)
            {
                theEvent.Chatter_Group_Name__c = existingGroupId;
                if (theEvent.Id != null)
                {
                    update new Event__c(Id = theEvent.Id, Chatter_Group_Name__c = theEvent.Chatter_Group_Name__c);
                }
            }
            else if (theEvent.Id == null)
            {
                CollaborationGroup grp = new CollaborationGroup();
                grp.Name = newChatterGroupName;   
                grp.CollaborationType = 'Public';                 
                insert grp;
                theEvent.Chatter_Group_Name__c = grp.id;
            }

            List<Event__c> relatedEvent = [ select Event_Carousel__c, (select id, name from Attachments) 
                                            from Event__c 
                                            where id =  :standardController.getRecord().id];
            Id eventCarouselId;
            if (relatedEvent.size() > 0)
            {
                eventCarouselId = relatedEvent[0].Event_Carousel__c;
            }
            if (eventCarouselId == null)
            {
                Carousel__c eventCarousel = new Carousel__c();
                eventCarousel.Name = ((Event__c) standardController.getRecord()).name;
                insert eventCarousel;

                Event__C aEvent = (Event__c)  standardController.getRecord();
                aEvent.Event_Carousel__c = eventCarousel.id;
            }

            returnRef = standardController.save();

            if (ApexPages.hasMessages())
            {
                throw new ApplicationException();
            }

            List<Attachment> attachmentsToInsert = new List<Attachment>();
            List<Attachment> attachmentsToDelete = new List<Attachment>();
            if(String.isNotEmpty(attachment.Name))
            {
                //if it has an attachment already then delete
                if(relatedEvent.size() > 0  && relatedEvent[0].Attachments.size() > 0)
                {
                    for (Attachment att : relatedEvent[0].Attachments)
                    {
                        if (att.Name.contains('Header'))
                        {
                            attachmentsToDelete.add(att);
                            break;
                        }
                    }
                    //delete new Attachment(id = relatedEvent[0].Attachments[0].id);
                }
                attachment.name = attachment.name+'_Header';
                attachment.OwnerId = UserInfo.getUserId();
                attachment.ParentId = standardController.getRecord().id;
                attachmentsToInsert.add(attachment);
            }

            if(String.isNotEmpty(attachmentLogo.Name)){
                //if it has an attachment already then delete
                if(relatedEvent.size() > 0  && relatedEvent[0].Attachments.size() > 0){
                    for(Attachment att : relatedEvent[0].Attachments){
                        if(att.Name.contains('Logo')){
                            attachmentsToDelete.add(att);
                            break;
                        }
                    }
                    //delete new Attachment(id = relatedEvent[0].Attachments[0].id);
                }
                attachmentLogo.name = attachmentLogo.name+'_Logo';
                attachmentLogo.OwnerId = UserInfo.getUserId();
                attachmentLogo.ParentId = standardController.getRecord().id;
                attachmentsToInsert.add(attachmentLogo);
            }

            delete attachmentsToDelete;
            insert attachmentsToInsert;
            refreshMembersMap = true;
        }
        catch (Exception e){
            ApexPages.addMessages(e);
            Database.rollback(sp);
        }

        return returnRef;
    }

    public PageReference addMembersToGroup(){
        //get existing users
        if(null != theEvent.Chatter_Group_Name__c ){
            List<CollaborationGroupMember> membersToAdd = new LIst<CollaborationGroupMember>();
            List<CollaborationGroupMember> membersToRemove= new LIst<CollaborationGroupMember>();
            List<Event_Member__c> eventMembersToAdd = new List<Event_Member__c>();
            List<Event_Member__c> eventMembersToDelete = new List<Event_Member__c>();

            List<id> membersToShareTo = new List<id>();
            List<id> membersToRevokeShare = new List<id>();

            Set<id> selectedUserID = new Set<id>();
            //add members
            for(SelectOption selectedUser : selectedUsers){
                if(!eventMemberMap.containsKey(selectedUser.getValue())){
                    //add member
                    if(null != memberMapByUser.get(selectedUser.getValue()) && 
                        memberMapByUser.get(selectedUser.getValue()).CollaborationRole != 'Admin'){
                        membersToAdd.add(new CollaborationGroupMember(CollaborationGroupId = theEvent.Chatter_Group_Name__c, MemberId = selectedUser.getValue()));
                    }
                    eventMembersToAdd.add(new Event_Member__c (Name =selectedUser.getLabel(),  User__c = selectedUser.getValue(), Event__c = theEvent.id));
                    membersToShareTo.add(selectedUser.getValue());
                }
                selectedUserID.add(selectedUser.getValue());
            }           
            system.debug('selectedUserID: '+selectedUserID);
            system.debug('memberMapByUser.keySet(): '+memberMapByUser.keySet());
            system.debug('eventMemberMap: '+eventMemberMap);
            //delete members
            for(ID exsitingUser : memberMapByUser.keySet()){
                if(!selectedUserID.contains(exsitingUser)){
                    system.debug('selectedUserID contains');
                    system.debug('memberMapByUser.get(exsitingUser).CollaborationRole: '+ memberMapByUser.get(exsitingUser).CollaborationRole);
                    if(memberMapByUser.get(exsitingUser).CollaborationRole != 'Admin'){
                        membersToRemove.add(memberMapByUser.get(exsitingUser));
                        system.debug('is not admin');
                    }
                    if(null != eventMemberMap.get(exsitingUser)){
                        system.debug('usr is in event map');
                        eventMembersToDelete.add(eventMemberMap.get(exsitingUser));
                        if(memberMapByUser.get(exsitingUser).CollaborationRole != 'Admin'){
                            membersToRevokeShare.add(exsitingUser);
                        }
                    }
                }
            }

            Savepoint sp = Database.setSavepoint();
            try{
                system.debug('membersToAdd: '+membersToAdd);
                system.debug('eventMembersToDelete: '+eventMembersToDelete);
                insert membersToAdd;
                insert eventMembersToAdd;

                if(!membersToRemove.isEmpty()){
                    delete membersToRemove; 
                }

                if(!eventMembersToDelete.isEmpty()){
                    delete eventMembersToDelete;
                }

                shareEventWithMembers(membersToShareTo, membersToRevokeShare);
                
                updatePotentialExpertUserList = true;
                ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Members Updated');
                ApexPages.addMessage(successMessage);
            }
            catch (Exception e){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(errorMsg);
                Database.rollback(sp);
            }
            
        }
        else{
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is no chatter group for this event');
            ApexPages.addMessage(errorMsg);
        }
        return null;

    }


    private void shareEventWithMembers(List<id> usersToAdd, List<id> usersToRevoke){
        map<id,Event__Share> currentShareStatus = new map<id, Event__Share>();
        List<Event__Share> toShare  = new List<Event__Share>();
        List<Event__Share> toRevoke  = new List<Event__Share>();

        for(Event__Share aEventShare : [select UserOrGroupId from Event__Share where ParentId =: theEvent.id ]){
            currentShareStatus.put(aEventShare.UserOrGroupId, aEventShare);
        }

        for(ID userId :usersToAdd){
            if(!currentShareStatus.containsKey(userId)){
                toShare.add(new Event__Share(ParentId = theEvent.id, UserOrGroupId = userId, AccessLevel = 'Read'));
            }
        }

        for(ID userId :usersToRevoke){
            if(currentShareStatus.containsKey(userId)){
                toRevoke.add(currentShareStatus.get(userId));
            }
        }

        insert toShare;
        delete toRevoke;
        
    }

    public PageReference addExpertsToGroup(){
        //get existing users
        if(null != theEvent.Chatter_Group_Name__c ){
            updatePotentialExpertUserList = false;
            List<Event_Member__c> eventMembersToUpdate = new List<Event_Member__c>();
            //add experts
            for(SelectOption selectedExpert : expertUserList){
                eventMembersToUpdate.add(new Event_Member__c(id = selectedExpert.getValue(), Is_Expert__c = true));
            }
            system.debug('poten size: '+potentialExpertUserList.size());
            //remove experts
            for(SelectOption selectedExpert : potentialExpertUserList){
                eventMembersToUpdate.add(new Event_Member__c(id = selectedExpert.getValue(), Is_Expert__c = false));
            }
            try{
                update eventMembersToUpdate;
                ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Experts Updated');
                ApexPages.addMessage(successMessage);
            }
            catch (Exception e){
                system.debug('the error: '+e);
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An error occured while adding experts: '+e.getMessage());
                ApexPages.addMessage(errorMsg);
            }
        }
        else{
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is no chatter group for this event');
            ApexPages.addMessage(errorMsg);
        }
        return null;

    }

    public PageReference addExternalMemberToGroup(){
        //get existing users
        system.debug('theEvent.Chatter_Group_Name__c: '+theEvent.Chatter_Group_Name__c);
        if(null != theEvent.Chatter_Group_Name__c ){
            
            List<CollaborationGroupMember> membersToAdd = new LIst<CollaborationGroupMember>();
            List<CollaborationGroupMember> membersToRemove= new LIst<CollaborationGroupMember>();
            List<Event_Member__c> eventMembersToAdd = new List<Event_Member__c>();
            List<Event_Member__c> eventMembersToDelete = new List<Event_Member__c>();

            List<id> membersToShareTo = new List<id>();
            List<id> membersToRevokeShare = new List<id>();

            Set<id> selectedUserID = new Set<id>();
            //add members
            system.debug('selectedExternalUsers: '+selectedExternalUsers);
            for(SelectOption selectedUser : selectedExternalUsers){
                if(!eventMemberMap.containsKey(selectedUser.getValue())){
                    membersToAdd.add(new CollaborationGroupMember(CollaborationGroupId = theEvent.Chatter_Group_Name__c, MemberId = selectedUser.getValue()));
                    eventMembersToAdd.add(new Event_Member__c (Name =selectedUser.getLabel(),  User__c = selectedUser.getValue(), Event__c = theEvent.id, Member_Type__c = 'External'));
                    membersToShareTo.add(selectedUser.getValue());
                }
                selectedUserID.add(selectedUser.getValue());
            }           
system.debug('membersToAdd: '+membersToAdd);
system.debug('eventMembersToAdd: '+eventMembersToAdd);
            //delete members
            for(ID exsitingUser : memberMapByUser.keySet()){
                if(!selectedUserID.contains(exsitingUser) && 
                    (null != eventMemberMap.get(exsitingUser) && eventMemberMap.get(exsitingUser).Member_Type__c == 'External')){
                    membersToRemove.add(memberMapByUser.get(exsitingUser));

                    if(null != eventMemberMap.get(exsitingUser)){
                        eventMembersToDelete.add(eventMemberMap.get(exsitingUser));
                        membersToRevokeShare.add(exsitingUser);
                    }
                }
            }

            Savepoint sp = Database.setSavepoint();
            try{
                
                insert membersToAdd;
                insert eventMembersToAdd;

                system.debug('membersToAdded: '+membersToAdd);

                system.debug('eventMembersToAdded: '+eventMembersToAdd);

                if(!membersToRemove.isEmpty()){
                    delete membersToRemove; 
                }

                if(!eventMembersToDelete.isEmpty()){
                    delete eventMembersToDelete;
                }
                shareEventWithMembers(membersToShareTo, membersToRevokeShare);

                updatePotentialExpertUserList = true;
                ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Members Updated');
                ApexPages.addMessage(successMessage);
            }
            catch (Exception e){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(errorMsg);
                Database.rollback(sp);
            }
            
        }
        else{
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is no chatter group for this event');
            ApexPages.addMessage(errorMsg);
        }
        return null;

    }

    private Map<integer,String> monthByNum = new Map<integer,String> { 1 => 'January',  
                                                                       2 => 'February', 
                                                                       3 => 'March',
                                                                       4 => 'April',
                                                                       5 => 'May',
                                                                       6 => 'June',
                                                                       7 => 'July',
                                                                       8 => 'August',
                                                                       9 => 'September',
                                                                       10 => 'October',
                                                                       11 => 'November',
                                                                       12 => 'December',
                                                                       13 => 'January',
                                                                       14 => 'February'};

    public List<String> months{
        get{Map<String,List<Event__c>> calendar1 = calendar; return months;}

        set;}
                                                                           
    public List<String> selectedMonths {
        get{
            selectedMonths  = new List<String>();
            selectedMonths.add(monthByNum.get(currentDate.month()));
            selectedMonths.add(monthByNum.get(currentDate.month()+1));
            selectedMonths.add(monthByNum.get(currentDate.month()+2));
            return selectedMonths;
        }

        set;}

    public Map<String,List<Event__c>> calendar{
        get{
            if(null == calendar){
                months = new List<String>();
                calendar = new Map<String, List<Event__c>>();

                for(Event__c aEvent : [select Id, Name, Start_Date_Time__c, Type__c, Is_Big_Six__c, Locked__c, Status__c, Event_Description__c,
                                              (select Id, Name from Attachments where Name like '%_Logo' order by LastModifiedDate desc limit 1)
                                       from Event__c
                                       where Start_Date_Time__c >= : System.now() order by Start_Date_Time__c asc limit 7]){
                                        
                    aEvent.Event_Description__c = aEvent.Event_Description__c != null ?
                        aEvent.Event_Description__c.replaceAll('<[^>]*>', '') : '';
                                        
                    if(!calendar.containsKey(monthByNum.get(aEvent.Start_Date_Time__c.month()))){
                        months.add(monthByNum.get(aEvent.Start_Date_Time__c.month()));
                        calendar.put(monthByNum.get(aEvent.Start_Date_Time__c.month()), new List<Event__c>());
                    }
                    calendar.get(monthByNum.get(aEvent.Start_Date_Time__c.month())).add(aEvent);
                }   
            }
            
            return calendar;
        }
        set;

    }
    
    public Map<String,List<Event__c>> calendarOld{
        get{
            //init map
            //only show 3 months..current money plus 2...
            calendar = new Map<String,List<Event__c>>();
            calendar.put(monthByNum.get(currentDate.month()), new List<Event__c>());
            calendar.put(monthByNum.get(currentDate.month()+1), new List<Event__c>());
            calendar.put(monthByNum.get(currentDate.month()+2), new List<Event__c>());
    /*      if(currentDate < Date.today()){
                currentDate = Date.today();
            }*/
            
            Date endDate = currentDate.addMonths(4);

            for(Event__c aEvent : [select id, name, Start_Date_Time__c, Type__c, Is_Big_Six__c, Locked__c, Status__c 
                                    from Event__c
                                    where Start_Date_Time__c >= : currentDate and Start_Date_Time__c < : endDate
                                    order by Start_Date_Time__c]){
                if(aEvent.Start_Date_Time__c.month() == currentDate.month()){
                    calendar.get(monthByNum.get(aEvent.Start_Date_Time__c.month())).add(aEvent);
                }
                else if(aEvent.Start_Date_Time__c.month() == currentDate.month()+1){
                    calendar.get(monthByNum.get(aEvent.Start_Date_Time__c.month())).add(aEvent);
                }
                else if(aEvent.Start_Date_Time__c.month() == currentDate.month()+2){
                    calendar.get(monthByNum.get(aEvent.Start_Date_Time__c.month())).add(aEvent);
                }
            }
            
            Integer size = 7;
            for(String key : calendar.keySet()){
                if(size < calendar.get(key).size()){
                    size = calendar.get(key).size();
                }
            }
            
            for(String key : calendar.keySet()){
                if(size > calendar.get(key).size()){
                    for(Integer i=calendar.get(key).size(); i < size; i++){
                        calendar.get(key).add(new Event__c());
                    }
                }
            }
            
            return calendar;
        }
        set;
    }
    
    //--------- Calendar functionality
    
    public Date currentDate {get; set;}
    
    public String currentMonth{ 
        get{
            return String.valueOf(currentDate.month());
        }
    }
    
    public String currentYear{ 
        get{
            return String.valueOf(currentDate.year());
        }
    }
    
    public void prewMonth(){
        Integer month = Integer.valueOf(Apexpages.currentPage().getParameters().get('month'));
        Integer year = Integer.valueOf(Apexpages.currentPage().getParameters().get('year'));
        currentDate = Date.newInstance(year, month, 1);
        currentDate = currentDate.addMonths(-1);
    }
    
    public void nextMonth(){
        Integer month = Integer.valueOf(Apexpages.currentPage().getParameters().get('month'));
        Integer year = Integer.valueOf(Apexpages.currentPage().getParameters().get('year'));
        currentDate = Date.newInstance(year, month, 1);
        currentDate = currentDate.addMonths(1);
    }
    
    public Boolean showPrewBtn{
        get{
            return currentDate.month() > Date.today().month() || currentDate.year() > Date.today().year();
        }
    }
    
    public List<Event__c> pastEvents {
        get{
            if(pastEvents == null){
                pastEvents = [select id, name, Start_Date_Time__c, Event_Description__c, Is_Big_Six__c, Event_Summary_Document_Link__c 
                                    from Event__c
                                    where Start_Date_Time__c < : Date.today()
                                    order by Start_Date_Time__c desc limit 7];
            }                   
            return pastEvents;
            
        } set;      
    }
    
    public List<Event__c> allPastEvents {
        get{
            if(allPastEvents == null){
                allPastEvents = [select id, name, Start_Date_Time__c, Event_Description__c, Is_Big_Six__c, Event_Summary_Document_Link__c 
                                    from Event__c
                                    where Start_Date_Time__c < : Date.today()
                                    order by Start_Date_Time__c desc];
            }                   
            return allPastEvents;
            
        } set;      
    }

    public void refreshUser(){}

    public class ApplicationException extends Exception {}
    
    //Add Live events
    public List<Event__c> liveEvents{
        get{
            if(null == liveEvents){
                liveEvents = new List<Event__c>();

                for(Event__c aEvent : [select Id, Name, Start_Date_Time__c, Type__c, Is_Big_Six__c, Locked__c, Status__c, Event_Description__c,
                                              (select Id, Name from Attachments where Name like '%_Logo' order by LastModifiedDate desc limit 1),
                                              End_Date_Time__c
                                       from Event__c
                                       where Start_Date_Time__c <= : System.now() AND End_Date_Time__c >= : System.now() 
                                       order by Start_Date_Time__c asc]){
                                        
                    aEvent.Event_Description__c = aEvent.Event_Description__c != null ?
                        aEvent.Event_Description__c.replaceAll('<[^>]*>', '') : '';
                                        
                    liveEvents.add(aEvent);
                }   
            }
            
            return liveEvents;
        }
        set;

    }

    private void addError(String errorMessage)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage));
    }
    
    
}