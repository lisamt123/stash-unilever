/*
Class Name              : Core_EventsAction_Controller 
Requirement/Description : 
*/

public with sharing class Core_EventsAction_Controller {

    public Core_EventsAction_Controller(ApexPages.StandardController controller) {
        strRecId= ApexPages.currentPage().getParameters().get('Id');
        strSelToVal='IAmAttending';
    }


    public String strPostDetail { get; set; }
    public String strSelToVal    {get;set;}
    public String targetField { get; set; }
    public String strSharepointURL    {get;set;}
    public String strLinkName    {get;set;}
    public map<string,string> groupNameMap { get; set; }
    public Boolean flag {get; set;}
    public String strRecId {get;set;}
    
    public Boolean isClose {get; set;}
    public Core_EventsAction_Controller(){
       //strRecId='Hi';
        //strSharepointURL = apexpages.currentpage().getparameters().get('urlVal');
       // strSharepointURL =strSharepointURL.Replace(' ', '+');              

       // strSharepointURL = EncodingUtil.urlEncode( apexpages.currentpage().getparameters().get('urlVal') , 'UTF-8');
        
       
        //strLinkName = apexpages.currentpage().getparameters().get('linkName');
        //groupNameMap=new map<string,string>();
        //flag=false;
        strRecId= ApexPages.currentPage().getParameters().get('Id');
        strSelToVal='IAmAttending';        
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('IAmAttending','I am attending')); 
        options.add(new SelectOption('AddOthers','I want to add others who are attending')); 
        return options; 
    }
    
    /*public List<SelectOption> getMyFollowers() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('My Followers','My Followers'));  
        options.add(new SelectOption('My Followers1','My Followers1'));  
        return options; 
    }
    
    public List<SelectOption> getAGroup() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('A Group','A Group')); 
        return options; 
    }*/
    
    public PageReference removeGroupInList() {
        string strValue=System.currentPageReference().getParameters().get('id');
        groupNameMap.remove(strValue);
        return null;
    }
    public PageReference saveGroupInList() {    
        List<User> grpMember=[SELECT Id,Name FROM User WHERE Id=:targetField];
        if(targetField!=null && grpMember.size()>0)
        {
            for(User grpObj: grpMember)
            {
                if(!groupNameMap.containsKey(targetField))
                {
                    groupNameMap.put(targetField,grpObj.Name);
                }
            }
        }
        return null;
    }

    public PageReference createDesc() {
        System.debug('********' + strSelToVal );        
        groupNameMap=new map<string,string>();
        return null;
    }

    
    public PageReference  postOnWall() { 
        //Check wether user has slected any group
        //System.debug('***** strSelToVal ' + strSelToVal);
        //Map<Id,Set<Id>> mapEventIdNAttendeesIds=new Map<Id,Set<Id>>();
        Set<Id> setAttendeesId=new Set<Id>();
        List<Attendee__c> lstAttendee=[SELECT Attendee__c,Event__c FROM Attendee__c where Event__c=:strRecId];
        List<Attendee__c> lstAddAttendee=new List<Attendee__c>();
        if(!lstAttendee.isEmpty()){
            for(Attendee__c attendee : lstAttendee){
                /*if(!mapEventIdNAttendeesIds.containsKey(attendee.Event__c))
                    mapEventIdNAttendeesIds.put(attendee.Event__c,new Set<Id>());            
                mapEventIdNAttendeesIds.get(attendee.Event__c).add(attendee.Attendee__c);*/
                setAttendeesId.add(attendee.Attendee__c);
            }
        }
        if(strSelToVal=='IAmAttending'){
            //mapEventIdNAttendeesIds.get(strRecId).containsvalue(Id.Valueof(Userinfo.getUserId()));
            if(setAttendeesId.contains(Userinfo.getUserid())){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You are already attending!');
                ApexPages.addMessage(myMsg);
            }
            else{
                Attendee__c attendee=new Attendee__c();
                attendee.Attendee__c=Userinfo.getUserId();
                attendee.Event__c=strRecId;
                lstAddAttendee.add(attendee);
            }
        }
        else{
            if(groupNameMap.keySet().isEmpty()){           
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Select any attendees');
                ApexPages.addMessage(myMsg);
                return null;   
            }
            else{
                for(String strUser : groupNameMap.keySet()){
                    if(!setAttendeesId.contains(strUser)) {
                        Attendee__c attendee=new Attendee__c();
                        attendee.Attendee__c=strUser;
                        attendee.Event__c=strRecId;
                        lstAddAttendee.add(attendee);
                    }
                }
            }
        }
        if(!lstAddAttendee.isEmpty()) database.insert(lstAddAttendee);
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.confirm, 'Attending Successfully');
        ApexPages.addMessage(myMsg);
        flag=false;
        
        /*try{  
            FeedItem post;
            if(strSelToVal=='AGroup'){                                       
                set<String> groupNameSet=new set<String>();
                groupNameSet=groupNameMap.keySet();
                
                if(groupNameSet.size()==0){                          
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select minimum 1 group.');
                    ApexPages.addMessage(myMsg1);
                    return null;
                }               
                if(groupNameSet.size()==0){
                    strSelToVal='MyFollowers';
                }               
                for(String groupId:groupNameSet){
                    post = new FeedItem();                                    
                    post.ParentId = groupId; 
                    post.Body = strPostDetail;
                    post.Title = strLinkName;
                    post.LinkUrl = strSharepointURL;
                    insert post;
                    flag=true;
                }               
            }    
            
            if(strSelToVal=='MyFollowers'){
                post = new FeedItem();                                    
                post.ParentId = UserInfo.getUserId();
                post.Body = strPostDetail;
                post.Title = strLinkName;
                post.LinkUrl = strSharepointURL;
                insert post;
                flag=true;
            }  
            
        }
        catch(System.DMLException ex){
            System.debug(LoggingLevel.ERROR, 'Exception in sending the Post ' + ex.getMessage());
        } */          
        isClose=false;
        return null;
    }
    
}