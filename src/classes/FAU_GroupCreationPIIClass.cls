public class FAU_GroupCreationPIIClass
{ 
    
    Static List<CollaborationGroup> chatterGroups = new List<CollaborationGroup>();
    // Static map<String,FAU_Class__c > chatterMap= new map<String,FAU_Class__c >();
    Static map<String,FAU_PII_Table__c> chatterMapPIITable= new map<String,FAU_PII_Table__c>();
    Static map<String,FAU_PII__c> chatterMapPII= new map<String,FAU_PII__c>();
    
    /*  Public static void createChatterGroup(List<FAU_Class__c> varListClass)
{
for(FAU_Class__c varName:varListClass)
{
chatterGroups.add(buildPrivateChatterGroup(varName.Name,varName.OwnerId,'Private'));
chatterMap.put(varName.name,varName);
}

insert chatterGroups;

for(CollaborationGroup vargrp:chatterGroups)
{
if(chatterMap.get(vargrp.name)!=null)
{
chatterMap.get(vargrp.name).FAU_Participant_Chatter_Group_Id__c=vargrp.id;
}
}
}  */
    
    Public static void createChatterGroupforPIITable(List<FAU_PII_Table__c> varListClass)
    {
        chatterGroups = new List<CollaborationGroup>(); 
        for(FAU_PII_Table__c varName:varListClass)
        {
            chatterGroups.add(buildPrivateChatterGroup(varName.Name,UserInfo.getUserId(),'Private'));
            chatterMapPIITable.put(varName.name,varName);
        }
        
        insert chatterGroups;
        
        for(CollaborationGroup vargrp:chatterGroups)
        {
            if(chatterMapPIITable.get(vargrp.name)!=null)
            {
                chatterMapPIITable.get(vargrp.name).FAU_Participant_Chatter_Group_Id__c=vargrp.id;
            }
        }
    }
    
    
    
    Public static void insertMemberToGroup(List<FAU_Sponsor__c> varListSponsor)
    {
        Database.SaveResult[] listResults;
        List<CollaborationGroupMember> gmList=new List<CollaborationGroupMember>();
        
        try
        {
            for(FAU_Sponsor__c tempSponser:varListSponsor)
            {
                if(tempSponser.FAU_Participant_Chatter_Group_Id__c!=null)
                {
                    CollaborationGroupMember gm=new CollaborationGroupMember();
                    gm.collaborationGroupId=tempSponser.PII_Chatter_Group__c;
                    gm.memberId=tempSponser.Sponsor__c;
                    gm.NotificationFrequency='P';
                    gmList.add(gm);
                }
            }
            if(gmList.size()!=0)
            {
                listResults=Database.insert(gmList,false);
            }
            
            for (Database.SaveResult srObject : listResults){
                if(!srObject.isSuccess()){
                    for(Database.Error err : srObject.getErrors()) {                 
                        
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Preason  ' + err.getFields());
                        varListSponsor[0].addError(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
        }
        Catch(Exception e)
        {
            varListSponsor[0].addError('Error ' + e.getMessage());
        }
    }
    
    //Adding participant to PII Table
    Public static void insertMemberToGroupParticipant(List<FAU_Participant__c> varListParticipant)
    {
        System.debug('varListParticipant'+varListParticipant);
        
        Database.SaveResult[] listResults;
        try
        {
         
            List<CollaborationGroupMember> gmList=new List<CollaborationGroupMember>();
            for(FAU_Participant__c tempParticipant:varListParticipant)
            {
            
             System.debug('tempParticipant.FAU_Participant_Chatter_Group_Id__c'+tempParticipant.FAU_Participant_Chatter_Group_Id__c);
             System.debug('tempParticipant.FAU_Invite_State__c'+tempParticipant.FAU_Invite_State__c);
             System.debug('tempParticipant.PII_Chatter_Group__c'+tempParticipant.PII_Chatter_Group__c);
             System.debug('tempParticipant.FAU_Personal_Assistant__c'+tempParticipant.FAU_Personal_Assistant__c);
           //  System.debug('varListParticipant'+varListParticipant);
                if(tempParticipant.FAU_Participant_Chatter_Group_Id__c!=null && tempParticipant.FAU_Invite_State__c=='Accepted')
                {
                    CollaborationGroupMember gm=new CollaborationGroupMember();
                    gm.collaborationGroupId=tempParticipant.FAU_Participant_Chatter_Group_Id__c;
                    gm.memberId=tempParticipant.FAU_User__c;
                    gm.NotificationFrequency='P';
                    gmList.add(gm);
                }
                
                if(tempParticipant.PII_Chatter_Group__c!=null && tempParticipant.FAU_Invite_State__c=='Accepted')
                {
                    CollaborationGroupMember gm=new CollaborationGroupMember();
                    gm.collaborationGroupId=tempParticipant.PII_Chatter_Group__c;
                    gm.memberId=tempParticipant.FAU_User__c;
                    gm.NotificationFrequency='P';
                    gmList.add(gm);
                }
                
                
                
                if(tempParticipant.FAU_Participant_Chatter_Group_Id__c!=null && tempParticipant.FAU_Invite_State__c=='Accepted' && tempParticipant.FAU_Personal_Assistant__c != null)
                {
                    CollaborationGroupMember gm=new CollaborationGroupMember();
                    gm.collaborationGroupId=tempParticipant.FAU_Participant_Chatter_Group_Id__c;
                    gm.memberId=tempParticipant.FAU_Personal_Assistant__c;
                    gm.NotificationFrequency='P';
                    gmList.add(gm);
                }
                
                if(tempParticipant.PII_Chatter_Group__c!=null && tempParticipant.FAU_Invite_State__c=='Accepted' && tempParticipant.FAU_Personal_Assistant__c != null)
                {
                    CollaborationGroupMember gm=new CollaborationGroupMember();
                    gm.collaborationGroupId=tempParticipant.PII_Chatter_Group__c;
                    gm.memberId=tempParticipant.FAU_Personal_Assistant__c;
                    gm.NotificationFrequency='P';
                    gmList.add(gm);
                }
                
                
                if(tempParticipant.FAU_Participant_Chatter_Group_Id__c!=null && tempParticipant.FAU_Invite_State__c=='Accepted' && tempParticipant.FAU_User__c != null)
                {
                    CollaborationGroupMember gm=new CollaborationGroupMember();
                    gm.collaborationGroupId=tempParticipant.FAU_Program_Group_Chatter_Id__c;
                    gm.memberId=tempParticipant.FAU_User__c;
                    gm.NotificationFrequency='P';
                    gmList.add(gm);
                }
                
                if(tempParticipant.PII_Chatter_Group__c!=null && tempParticipant.FAU_Invite_State__c=='Accepted' && tempParticipant.FAU_Personal_Assistant__c != null)
                {
                    CollaborationGroupMember gm=new CollaborationGroupMember();
                    gm.collaborationGroupId=tempParticipant.FAU_Program_Group_Chatter_Id__c;
                    gm.memberId=tempParticipant.FAU_Personal_Assistant__c;
                    gm.NotificationFrequency='P';
                    gmList.add(gm);
                }
                
            }
            
            
            
            System.debug('test'+gmList);
            if(gmList.size()!=0)
            {
                //insert gmList;
                listResults=Database.insert(gmList,false); 
                
                
                for (Database.SaveResult srObject : listResults){
                    
                    System.debug('*****srObject********'+srObject);
                    if(!srObject.isSuccess()){
                        for(Database.Error err : srObject.getErrors()) {                 
                            System.debug('srObject'+srObject);                 
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Preason  ' + err.getFields());
                            //  varListParticipant[0].addError(err.getStatusCode() + ': ' + err.getMessage());
                        }
                    }
                } 
            }
        }
        Catch(Exception e)
        {
            varListParticipant[0].addError('Error ' + e.getMessage());
        }
        
        
    }
    
    
    
    private static CollaborationGroup buildPrivateChatterGroup(String name, Id ownerId, String collaborationType)
    {
        System.debug('#### FAU_ChatterServiceImpl.buildPrivateChatterGroup: enter');
        CollaborationGroup chatterGroup = new CollaborationGroup();
        chatterGroup.Name = name;      
        chatterGroup.CollaborationType = collaborationType;
        chatterGroup.OwnerId = ownerId;
        chatterGroup.Description = 'Chatter Group for ' + name + 'participants';          
        return chatterGroup;
    }
    
    
    Public static void ParticipantDeletionFromChatter(List<FAU_Participant__c> varListParticipant)
    {
        
        
        Database.DeleteResult[] listResults;
        Set<id> grpid=new Set<id>();
        Set<id> grpUser=new Set<id>();
        map<id,id> grpidwithUserMap=new map<id,id>();
        List<CollaborationGroupMember> deleteparticipant=new List<CollaborationGroupMember>();
        try
        {
            for(FAU_Participant__c temp:varListParticipant)
            {
                grpidwithUserMap.put(temp.FAU_Participant_Chatter_Group_Id__c,temp.FAU_User__c);
                grpidwithUserMap.put(temp.PII_Chatter_Group__c,temp.FAU_User__c);
                grpidwithUserMap.put(temp.FAU_Participant_Chatter_Group_Id__c,temp.FAU_Personal_Assistant__c);
                grpidwithUserMap.put(temp.PII_Chatter_Group__c,temp.FAU_Personal_Assistant__c);
                grpid.add(temp.FAU_Participant_Chatter_Group_Id__c);
                grpid.add(temp.PII_Chatter_Group__c);
                grpUser.add(temp.FAU_User__c);
                grpid.add(temp.PII_Chatter_Group__c);
                if(temp.FAU_Personal_Assistant__c != null)
                {
                    grpUser.add(temp.FAU_Personal_Assistant__c);
                }
            }  
            
            List<CollaborationGroupMember> listGrpmemberList=[Select id,collaborationGroupId,memberId from CollaborationGroupMember 
                                                              where collaborationGroupId in :grpid OR memberId in:grpUser];
            
            for(CollaborationGroupMember varGrp:listGrpmemberList)
            {
                if(grpidwithUserMap.get(varGrp.collaborationGroupId)==varGrp.memberId)
                {
                    deleteparticipant.add(varGrp);
                }
            }
            if(!deleteparticipant.isEmpty())
            {
                
                listResults=Database.delete(deleteparticipant,false); 
                
                
                for (Database.DeleteResult srObject : listResults){
                    
                    System.debug('*****srObject********'+srObject);
                    if(!srObject.isSuccess()){
                        for(Database.Error err : srObject.getErrors()) {                 
                            System.debug('srObject'+srObject);                 
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Preason  ' + err.getFields());
                            //  varListParticipant[0].addError(err.getStatusCode() + ': ' + err.getMessage());
                        }
                    }
                } 
            }
        }
        Catch(Exception e)
        {
            deleteparticipant[0].addError('Error ' + e.getMessage());
        } 
    }
    
    
    public static void sponsordelfrmgroup(List<FAU_Sponsor__c> varListParticipant)
    {
        
        Database.DeleteResult[] listResults;
        Set<id> grpid=new Set<id>();
        Set<id> grpUser=new Set<id>();
        map<id,id> grpidwithUserMap=new map<id,id>();
        List<CollaborationGroupMember> deleteparticipant=new List<CollaborationGroupMember>();
        
        
        try
        {
            for(FAU_Sponsor__c temp:varListParticipant)
            {
                grpidwithUserMap.put(temp.PII_Chatter_Group__c,temp.Sponsor__c);
                grpid.add(temp.PII_Chatter_Group__c);
                grpUser.add(temp.Sponsor__c);
            }
            
            List<CollaborationGroupMember> listGrpmemberList=[Select id,collaborationGroupId,memberId from CollaborationGroupMember 
                                                              where collaborationGroupId in :grpid OR memberId in:grpUser];
            
            for(CollaborationGroupMember varGrp:listGrpmemberList)
            {
                if(grpidwithUserMap.get(varGrp.collaborationGroupId)==varGrp.memberId)
                {
                    deleteparticipant.add(varGrp);
                }
            }
            if(!deleteparticipant.isEmpty())
            {
                
                listResults=Database.delete(deleteparticipant,false); 
                
                
                for (Database.DeleteResult srObject : listResults){
                    
                    System.debug('*****srObject********'+srObject);
                    if(!srObject.isSuccess()){
                        for(Database.Error err : srObject.getErrors()) {                 
                            System.debug('srObject'+srObject);                 
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Preason  ' + err.getFields());
                            //  varListParticipant[0].addError(err.getStatusCode() + ': ' + err.getMessage());
                        }
                    }
                } 
            }
        }
        Catch(Exception e)
        {
            deleteparticipant[0].addError('Error ' + e.getMessage());
        } 
        
        
    }
    
    Public static void createChatterGroupPII(List<FAU_PII__c> varListClass)
    {
        Database.SaveResult[] listResults;
        chatterGroups = new List<CollaborationGroup>();
        for(FAU_PII__c varName:varListClass)
        {
            chatterGroups.add(buildPrivateChatterGroup(varName.Name,UserInfo.getUserId(),'Private'));
            chatterMapPII.put(varName.name,varName);
        }
        
        
        if(chatterGroups.size()!=0)
        {
            System.debug(chatterGroups);
            
            listResults=Database.insert(chatterGroups,false);
        }
        
        for (Database.SaveResult srObject : listResults){
            if(!srObject.isSuccess()){
                for(Database.Error err : srObject.getErrors()) {                 
                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Preason  ' + err.getFields());
                    varListClass[0].addError(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
        
        
        
        
        for(CollaborationGroup vargrp:chatterGroups)
        {
            if(chatterMapPII.get(vargrp.name)!=null)
            {
                chatterMapPII.get(vargrp.name).FAU_PII_Chatter_Group_Id__c=vargrp.id;
            }
        }
    }
    
    
    public static void retreivingFields(List<FAU_PII__c> varPiiList)
    {
        Set<Id> setPII=new Set<Id>();
        List<FAU_PII__c> piiList=new List<FAU_PII__c>();
        try
        {
            for(FAU_PII__c varTempPII:varPiiList)
            {
                if(varTempPII.PII_Table__c  != null)
                { 
                    setPII.add(varTempPII.PII_Table__c);
                    
                }
            }
            
            map<Id,FAU_PII_Table__c> tempPIITable=new map<Id,FAU_PII_Table__c>([select Id,name,FAU_Description__c,FAU_Objectives_Deliverables__c from FAU_PII_Table__c]);
            
            
            for(FAU_PII__c varTempPII:varpiiList)
            {
                if(tempPIITable.get(varTempPII.PII_Table__c) != null)
                { 
                    varTempPII.FAU_Description__c=tempPIITable.get(varTempPII.PII_Table__c).FAU_Description__c;
                    varTempPII.FAU_Objectives_Deliverables__c=tempPIITable.get(varTempPII.PII_Table__c).FAU_Objectives_Deliverables__c;
                }   
                
            }
        }
        
        catch(Exception e)
        {
            system.debug('Error'+e);
        }    
    } 
}