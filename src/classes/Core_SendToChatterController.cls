/*
Class Name              : Core_SendToChatterController
Requirement/Description : 
*/

public with sharing class Core_SendToChatterController {

    public String strPostDetail { get; set; }
    public String strSelToVal    {get;set;}
    public String targetField { get; set; }
    public String strSharepointURL    {get;set;}
    public String strLinkName    {get;set;}
    public map<string,string> groupNameMap { get; set; }
    public Boolean flag {get; set;}
    
    public Boolean isClose {get; set;}
    public Core_SendToChatterController(){
       
        strSharepointURL = apexpages.currentpage().getparameters().get('urlVal');
       // strSharepointURL =strSharepointURL.Replace(' ', '+');              

       // strSharepointURL = EncodingUtil.urlEncode( apexpages.currentpage().getparameters().get('urlVal') , 'UTF-8');
        
       
        strLinkName = apexpages.currentpage().getparameters().get('linkName');
        groupNameMap=new map<string,string>();
        flag=false;
        strSelToVal='MyFollowers';        
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('MyFollowers','My Followers')); 
        options.add(new SelectOption('AGroup','A Group')); 
        return options; 
    }
    
    public List<SelectOption> getMyFollowers() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('My Followers','My Followers'));  
        options.add(new SelectOption('My Followers1','My Followers1'));  
        return options; 
    }
    
    public List<SelectOption> getAGroup() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('A Group','A Group')); 
        return options; 
    }
    
    public PageReference removeGroupInList() {
        string strValue=System.currentPageReference().getParameters().get('id');
        groupNameMap.remove(strValue);
        return null;
    }
    public PageReference saveGroupInList() {    
        List<CollaborationGroupMember> grpMember=[SELECT CollaborationGroupId,CollaborationGroup.name FROM CollaborationGroupMember WHERE CollaborationGroupId =:targetField and MemberId =: UserInfo.getUserId()];
        if(targetField!=null && grpMember.size()>0)
        {
            for(CollaborationGroupMember grpObj: grpMember)
            {
                if(!groupNameMap.containsKey(targetField))
                {
                    groupNameMap.put(targetField,grpObj.CollaborationGroup.name);
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
        System.debug('***** strSelToVal ' + strSelToVal);
        
        if(strSelToVal==null || strSelToVal==''){           
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Select the \"My Followers\" or \"A Group\" option...');
            ApexPages.addMessage(myMsg);
            return null;   
        }
        
        flag=false;
        
        try{  
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
        }           
        isClose=true;
        return null;
    }
    
}