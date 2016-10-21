/** 
  * This class is used to associate members to collaborationgroup,
     when member is added to the course occurence.
  * And to create a member chatter group and private collaborationgroup for each participant
    and associate course facilitators to all the groups based on the course.
  * To associate existing and new instructors to all the chatter groups 
    based on course occurence 
  * And when occurence member is created he will be added as a member 
    to AllFourAcres group and FourAcres Help Group
  * And when member is deleted from the occurence then member should be deleted 
    from all the groups related to that course occurence
  * And member chatter group and participant private chatter group also will be deleted
    if the participant is deleted from the occurence.
  */ 
public class FA_Trigger_OccurenceMember { 

 /*
   * The method 'After_AssociateMembersToGroup' helps to associate
     the members to collaborationgroup.
   * when member is added to the course occurence, then he will be added as 
     a member to the groups which are related to that course occurence. 
   * And also helps to associate existing course facilitators
     to course chatter group
  * @param listAssMemToGrp - list of occurence members which contains 
    occurence member trigger.new records.
*/
  public static void After_AssociateMembersToGroup(FA_Occurence_Member__c[] listAssMemToGrp)   
   {
      List <CollaborationGroupMember> AssocMembers = new List< CollaborationGroupMember>();    
      Set <CollaborationGroupMember> setAssocMembers = new Set < CollaborationGroupMember>();
      List<FA_Occurence_Member__c>  liPrivateGroup =new List<FA_Occurence_Member__c>(); 
      List<FA_Occurence_Member__c>  liPrivGroupInst =new List<FA_Occurence_Member__c>();
      List<FA_Occurence_Member__c>  liPrivGroupAllInst =new List<FA_Occurence_Member__c>();  
      Map<ID,ID> mGroupOccs= new Map<ID,ID>();
      Set<string> setCoOccId = new Set<string>(); 
      Map<ID,ID> mCoOccIds = new Map<ID,ID>();
      List<ID> facilId= new List<id>();
       
     
       
     for(FA_Occurence_Member__c liOccmem : listAssMemToGrp)
          {       
            setCoOccId.add(liOccmem.FA_Course_Occurence__c);                                                   
          }         
     for(FA_Course_Chattergroup__c tCouGrup:[select id,
                                                     FA_Course_Occurence__c,
                                                     FA_Course_Occurence__r.FA_Course__c,
                                                     FA_Group_ID__c 
                                                     from FA_Course_Chattergroup__c
                                                     where FA_Course_Occurence__c=:setCoOccId]) 
                                                          
      {       
        mGroupOccs.put(tCouGrup.FA_Course_Occurence__c,tCouGrup.FA_Group_ID__c);     
        mCoOccIds.put(tCouGrup.FA_Course_Occurence__c,tCouGrup.FA_Course_Occurence__r.FA_Course__c);
      }   
     
     list<CollaborationGroupMember> lstcolmem = [select memberId,CollaborationGroupId 
                                                         from CollaborationGroupMember
                                                         where CollaborationGroupId in:mGroupOccs.values()];
     set<string> setmemids = new set<string>();
     for(CollaborationGroupMember s:lstcolmem)
         setmemids.add(string.valueOf(s.memberId) + string.valueOf(s.CollaborationGroupId));
         
      List <CollaborationGroupMember> liCoAssocFacilMems = new List< CollaborationGroupMember>(); 
      Map<ID,List<ID>> mCoFacilIds= new Map<ID,List<ID>>();
      
      // code to prepare existing course facilitators related to the course
       for(FA_Course_Facilitator__c tCourFacil : [select id,
                                                         FA_Course__c,
                                                         FA_Facilitator__c,
                                                         FA_Role__c 
                                                         from FA_Course_Facilitator__c
                                                         where FA_Course__c in:mCoOccIds.values()])
          
        {
           if(mCoFacilIds.ContainsKey(tCourFacil.FA_Course__c))
                    {
                       
                       facilId=mCoFacilIds.get(tCourFacil.FA_Course__c);
                       facilId.add(tCourFacil.FA_Facilitator__c);
                    
                    }
          else{
                   List<string> liFacil =new string[]{tCourFacil.FA_Facilitator__c};
                   mCoFacilIds.put(tCourFacil.FA_Course__c,liFacil);
              }
                        
       } 
       
        /** code to stop chatter notification mails when participant is added to course chatter group.**/  
          
       Set<string> setUserId = new Set<string>();
       List <User> liUsers = new List<User>();
       
       for(FA_Occurence_Member__c  OccMember : listAssMemToGrp)    
           {
               setUserId.add(OccMember.FA_Participant_Instructor__c);
            } 
       
       for(User tuser : [select Id,UserPreferencesDisableAllFeedsEmail
                                from User 
                                where Id=:setUserId])
            {
               tuser.UserPreferencesDisableAllFeedsEmail = true; 
               liUsers.add(tuser);
             
            }
       try
         {
            if(!liUsers.isEmpty()) Update liUsers;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssMemToGrp[0].addError(message);
         }  
     /** code to stop chatter notification mails when existing facilitator is added to course chatter group.**/ 
       
       Set<string> setFacilId = new Set<string>();
       List <User> liFacils = new List<User>();
        for(FA_Occurence_Member__c  OccMember : listAssMemToGrp)    
              {
                  if(!mCoFacilIds.isEmpty() && mCoFacilIds.containsKey(mCoOccIds.get(OccMember.FA_Course_Occurence__c)))      
                    {
                      for(Id iFacilId:mCoFacilIds.get(mCoOccIds.get(OccMember.FA_Course_Occurence__c)))
                       {   
                         setFacilId.add(iFacilId);
                       }
                   }
              }
         for(User tFacil : [select Id,UserPreferencesDisableAllFeedsEmail
                                   from User 
                                   where Id=:setFacilId])
            {
             
               tFacil.UserPreferencesDisableAllFeedsEmail = true; 
               liFacils.add(tFacil);
               
             
            }
       try
         {
            if(!liFacils.isEmpty()) Update liFacils;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssMemToGrp[0].addError(message);
         }  
     
     // code to insert the occurence members into the chatter group based on the course occurence.
         
     if(!mGroupOccs.isEmpty()) 
        {    
             for(FA_Occurence_Member__c  OccMember : listAssMemToGrp)    
              {            
                if(!setmemids.contains(OccMember.FA_Participant_Instructor__c + string.valueOf(mGroupOccs.get(OccMember.FA_Course_Occurence__c))) && mGroupOccs.containsKey(OccMember.FA_Course_Occurence__c))
                    {
                       //To prepare member for the Private group creation
                       
                        CollaborationGroupMember  cMember = new CollaborationGroupMember();        
                        cMember.memberId  = OccMember.FA_Participant_Instructor__c;        
                        cMember.CollaborationGroupId = mGroupOccs.get(OccMember.FA_Course_Occurence__c);                
                        setAssocMembers.add(cMember);
                        
                    }
         // code to insert the course facilitators into the chatter group   
                if(!mCoFacilIds.isEmpty() && mCoFacilIds.containsKey(mCoOccIds.get(OccMember.FA_Course_Occurence__c)))      
                 {
                  for(Id iFacilId:mCoFacilIds.get(mCoOccIds.get(OccMember.FA_Course_Occurence__c)))
                    {
                      
                          if(!setmemids.contains(iFacilId + string.valueOf(mGroupOccs.get(OccMember.FA_Course_Occurence__c))) )
                          {
                             CollaborationGroupMember  colFacil = new CollaborationGroupMember();
                             colFacil.memberId  = iFacilId;
                             colFacil.CollaborationGroupId = mGroupOccs.get(OccMember.FA_Course_Occurence__c); 
                             liCoAssocFacilMems.add(colFacil);
                           }
                              
                    } 
                 } 
                  
                  if(OccMember.FA_Role__c == 'Participant'  )
                          {
                            liPrivateGroup.add(OccMember);
                          }
                  else if(OccMember.FA_Role__c == 'Instructor')
                         {
                          
                           liPrivGroupInst.add(OccMember);
                           
                         } 
              }  
              
     AssocMembers.addAll(setAssocMembers);
     
        try
        {
            if(!AssocMembers.isEmpty()) insert AssocMembers;
            if(!liCoAssocFacilMems.isEmpty())  insert liCoAssocFacilMems;
        }
        
       
    
          
     catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssMemToGrp[0].addError(message);
         }   
         
         /** code to enable sending chatter notification mails after adding Participant to course chatter group */ 
          
      
        set<string> setMemberIds = new set<string>();
        List <User> liMembers = new List<User>();
   
       /*  for(CollaborationGroupMember colMember : [select memberId,CollaborationGroupId 
                                                        from CollaborationGroupMember 
                                                        where memberId=:setUserId] )    
             {
                setMemberIds.add(colMember.memberId); 
             }   */
             
         for(User tmember : [select Id,
                                UserPreferencesDisableAllFeedsEmail 
                                from User 
                                where Id=:setUserId])
                {
                  
                   tmember.UserPreferencesDisableAllFeedsEmail = false;
                   liMembers.add(tmember);
                   
                } 
                
           try
             {
                if(!liMembers.isEmpty()) Update liMembers;
             }
      
           catch(DMLException ex)
             {
               string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
               listAssMemToGrp[0].addError(message);
             } 
     /** code to enable sending chatter notification mails after adding existing course facilitator to course chatter group */     
         
       Set<string> setFacilMemId = new Set<string>();
       List <User> liFacilMems = new List<User>();
        for(FA_Occurence_Member__c  OccMember : listAssMemToGrp)    
              {
                  if(!mCoFacilIds.isEmpty() && mCoFacilIds.containsKey(mCoOccIds.get(OccMember.FA_Course_Occurence__c)))      
                    {
                      for(Id iFacilId:mCoFacilIds.get(mCoOccIds.get(OccMember.FA_Course_Occurence__c)))
                       {   
                         setFacilMemId.add(iFacilId);
                       }
                   }
              }
         for(User tFacilMem : [select Id,UserPreferencesDisableAllFeedsEmail
                               from User 
                                where Id=:setFacilMemId])
            {
            
               tFacilMem.UserPreferencesDisableAllFeedsEmail = false; 
               liFacilMems.add(tFacilMem);
               
             
            }
       try
         {
            if(!liFacilMems.isEmpty()) Update liFacilMems;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssMemToGrp[0].addError(message);
         }  
         
          After_CreatePrivateChatterGroup(liPrivateGroup);
          After_AssociateInstructorsToPrivChatGroup(liPrivGroupInst);  

           
       }
 }
 
 /*
 * The method 'After_CreatePrivateChatterGroup' helps to create the private chatter group
   for each Participant when he is added as a member to the course occurence.
 * To associate occurence members to member chatter group and participant private collaborationgroup
   and associate existing course facilitators to all the groups based on the course.
 * Helps to associate existing instructors to  member chatter group
   and participant private collaborationgroup
 * @param listAssMemToGrp - list of occurence members which contains 
    occurence member trigger.new records.
*/
   public static void After_CreatePrivateChatterGroup(FA_Occurence_Member__c[] listCreatePrivChatGrp)   
    {
      List <FA_Member_ChatterGroup__c> ChatterGroup = new List<FA_Member_ChatterGroup__c>();
      List <FA_Occurence_Member__c> occMemId = new List<FA_Occurence_Member__c>();
      List <CollaborationGroup> CollGroup = new List <CollaborationGroup>();
      set <CollaborationGroup> setCollGroup = new set <CollaborationGroup>();
      List <CollaborationGroupMember> AssociateMembers = new List< CollaborationGroupMember>();
      Map<String,ID> Cmap = new Map<String,ID>();
      Map<String,ID> mGroupOcc = new Map<String,ID>(); 
      Map<String,ID> mGroupMem = new Map<String,ID>();
      List <CollaborationGroupMember> AssociateAllInstructors = new List< CollaborationGroupMember>();
      Map<ID,List<ID>> mOccInstIds= new Map<ID,List<ID>>();
      Map<ID,List<ID>> mOccGrpIds = new Map<ID,List<ID>>();
      List<ID> instId= new List<id>();
      Set<string> setCoOcc = new Set<string>(); 
      Set<string> setCourse = new Set<string>(); 
      Map<ID,List<ID>> mCoFacilIds= new Map<ID,List<ID>>();
              
     // code to create new private collaboration group for the participant.
       
    set<string> sGroupOccs= new set<string>(); 
        set<string> setCoOccId = new set<string>();
         
        for(FA_Occurence_Member__c liOccmem : listCreatePrivChatGrp)
          {       
            setCoOccId.add(liOccmem.FA_Course_Occurence__c);                                                   
          }         
          
     for(FA_Member_Chattergroup__c  tCouGrup:[select id,
                                                     FA_Course_Occurence__c,
                                                     FA_Chatter_Group_Name__c,
                                                     FA_Group_ID__c 
                                                     from FA_Member_Chattergroup__c
                                                     where FA_Course_Occurence__c=:setCoOccId]) 
                                                          
      {       
        sGroupOccs.add(tCouGrup.FA_Group_ID__c);     
      
      }   
     
     set<string> setmemids = new set<string>();
     
     for(CollaborationGroup s:[select Name,Id 
                                           from CollaborationGroup
                                           where Id in:sGroupOccs])
       {
          setmemids.add(string.valueOf(s.Name));  
       }
         
         
          for(FA_Occurence_Member__c  occMember : listCreatePrivChatGrp)                  
             {              
                 if(!setmemids.contains(occMember.FA_Course_Occ_Group_Name__c)) 
                  {
                      CollaborationGroup cGroup = new CollaborationGroup();
                      cGroup.name =  occMember.FA_Course_Occ_Group_Name__c;                      
                      cGroup.CollaborationType  = 'Private';
                      CollGroup.add(cGroup);
                      Cmap.put(cGroup.name,occMember.id); 
                      mGroupOcc.put(cGroup.name,occMember.FA_Participant_Instructor__c);  
                      mGroupMem.put(cGroup.name,occMember.FA_Course_Occurence__c); 
                      setCoOcc.add(occMember.FA_Course_Occurence__c);
                  }
                  
            }
     /** code to stop chatter notification mails being sent when Participant is added to member chatter group */
          
                  
       Set<string> setOccMemId = new Set<string>();
       List <User> liOccMems = new List<User>();
        for(FA_Occurence_Member__c  OccMember : listCreatePrivChatGrp)    
              {
                     
                 setOccMemId.add(OccMember.FA_Participant_Instructor__c);
                   
              }
         for(User tOccMem : [select Id,UserPreferencesDisableAllFeedsEmail,
                                DefaultGroupNotificationFrequency,DigestFrequency,
                                ReceivesAdminInfoEmails,ReceivesInfoEmails
                                from User 
                                where Id=:setOccMemId])
            {
               
               tOccMem.UserPreferencesDisableAllFeedsEmail = true; 
               liOccMems.add(tOccMem);
            }
       try
         {
            if(!liOccMems.isEmpty()) Update liOccMems;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listCreatePrivChatGrp[0].addError(message);
         }   
         
               if(!CollGroup.isEmpty())
                   {
                      insert CollGroup;  
                   } 
      
        
      
       
      for(CollaborationGroup colGrup : CollGroup)
       { 
         
         // Code to create the Member ChatterGroup for the participant.
         
         FA_Member_Chattergroup__c cChatter = new FA_Member_ChatterGroup__c();
         cChatter.FA_Group_ID__c = colGrup.id;
         cChatter.FA_Chatter_Group_Name__c = colGrup.name;
         cChatter.FA_Occurence_Member__c=Cmap.get(colGrup.name);
         cChatter.FA_Course_Occurence__c=mGroupMem.get(colGrup.name);
         ChatterGroup.add(cChatter);
         
         // Code for associating participant to the private group
         
         CollaborationGroupMember  cMember = new CollaborationGroupMember();
         cMember.memberId  = mGroupOcc.get(colGrup.name);
         cMember.CollaborationGroupId = colGrup.id;
         AssociateMembers.add(cMember);
         
      } 
      
    try
    {
       if(!ChatterGroup.isEmpty())      insert ChatterGroup;
       if(!AssociateMembers.isEmpty())  insert AssociateMembers; 
    }
      
       
   catch(DMLException de)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/ColGrupMem','FA_Trigger_OccurenceMember','After_CreatePrivateChatterGroup','FATAL',de);
           listCreatePrivChatGrp[0].addError(message);
         }
         
      /** code to enable sending chatter notification mails after Participant is added to member chatter group */
          
                  
       Set<string> setOccMemIds = new Set<string>();
       List <User> listOccMems = new List<User>();
        for(FA_Occurence_Member__c  OccMember : listCreatePrivChatGrp)    
              {
                     
                 setOccMemIds.add(OccMember.FA_Participant_Instructor__c);
                   
              }
         for(User tOccMem : [select Id,UserPreferencesDisableAllFeedsEmail,
                                DefaultGroupNotificationFrequency,DigestFrequency,
                                ReceivesAdminInfoEmails,ReceivesInfoEmails
                                from User 
                                where Id=:setOccMemIds])
            {
               
               tOccMem.UserPreferencesDisableAllFeedsEmail = false; 
               listOccMems.add(tOccMem);
            }
       try
         {
            if(!listOccMems.isEmpty()) Update listOccMems;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listCreatePrivChatGrp[0].addError(message);
         } 
     
     //Code for adding the existing instructors to the Private groups 
     
     Map<ID,ID> mcouOccIds = new Map<ID,ID>();
     for(FA_Occurence_Member__c liOccMember: [select id,
                                                         FA_Course_Occurence__c,
                                                         FA_Participant_Instructor__c,
                                                         FA_Role__c,
                                                         FA_Course_Occurence__r.FA_Course__c
                                                         from FA_Occurence_Member__c
                                                         where FA_Course_Occurence__c=:setCoOcc] )       
         {
           mcouOccIds.put(liOccMember.FA_Course_Occurence__c,liOccMember.FA_Course_Occurence__r.FA_Course__c);
          if(liOccMember.FA_Role__c=='Instructor')
          {
             if(mOccInstIds.ContainsKey(liOccMember.FA_Course_Occurence__c))
                    {
                       
                       instId=mOccInstIds.get(liOccMember.FA_Course_Occurence__c);
                       instId.add(liOccMember.FA_Participant_Instructor__c);
                    
                    }
                    else{
                         List<string> liInTr =new string[]{liOccMember.FA_Participant_Instructor__c};
                         mOccInstIds.put(liOccMember.FA_Course_Occurence__c,liInTr);
                        }
                        
          }
        }
        
        
                  set<string> setGrpIds = new set<string>();
                  set<string> setInstIds = new set<string>();
        
        for(FA_Member_ChatterGroup__c m:[select FA_Group_ID__c
                                                          from FA_Member_ChatterGroup__c 
                                                          where FA_Course_Occurence__c in :mOccInstIds.keyset()])
                                                          
             {
              setGrpIds.add(string.valueOf(m.FA_Group_ID__c));
              
             }
       
          for(CollaborationGroupMember m:[select memberId,CollaborationGroupId 
                                                         from CollaborationGroupMember
                                                         where CollaborationGroupId in:setGrpIds])
           {
            setinstids.add(string.valueOf(m.memberId) + string.valueOf(m.CollaborationGroupId));
           }
     /** code to stop notification mails when existing instructor is added to member chatter groups  */
          
       Set<string> setInstId = new Set<string>();
       List <User> liInstMems = new List<User>();
       
         for(FA_Member_Chattergroup__c memChatGrp : ChatterGroup)
              {
               if(!mOccInstIds.isEmpty()&& mOccInstIds.containskey(memChatGrp.FA_Course_Occurence__c))       
                {
                  for(Id iInstId:mOccInstIds.get(memChatGrp.FA_Course_Occurence__c))
                     {
                     
                        setInstId.add(iInstId);
                   
                      }
                }
             }
         for(User tOccMem : [select Id,UserPreferencesDisableAllFeedsEmail
                                   from User 
                                   where Id=:setInstId])
            {
               
               tOccMem.UserPreferencesDisableAllFeedsEmail = true; 
               liInstMems.add(tOccMem);
            }
       try
         {
            if(!liInstMems.isEmpty()) Update liInstMems;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listCreatePrivChatGrp[0].addError(message);
         }              
       // code to prepare member(existing instructor) to participant private group        
        
              for(FA_Member_Chattergroup__c memChatGrp : ChatterGroup)
              {
               if(!mOccInstIds.isEmpty()&& mOccInstIds.containskey(memChatGrp.FA_Course_Occurence__c))       
                {
                  for(Id iInstId:mOccInstIds.get(memChatGrp.FA_Course_Occurence__c))
                     {
                      if(!setinstids.contains(iInstId + string.valueOf(memChatGrp.FA_Group_ID__c)) )
                      {
                         CollaborationGroupMember  colInst = new CollaborationGroupMember();
                         colInst.memberId  = iInstId;
                         colInst.CollaborationGroupId = memChatGrp.FA_Group_ID__c; 
                         AssociateAllInstructors.add(colInst);
                     }
                     }      
                } 
            }
        try{
                 if(!AssociateAllInstructors.isEmpty()) insert AssociateAllInstructors;
           }
       catch(DMLException de)
             {
                string message= FA_ErrorLogHandler.errorMethod('OccMem/ColGrupMem','FA_Trigger_OccurenceMember','After_CreatePrivateChatterGroup','FATAL',de);
                listCreatePrivChatGrp[0].addError(message);
             }
   /** code to enable sending chatter mails after adding existing instructor to member chatter groups */  
           
      set<string> setMemberIds = new set<string>();
      List <User> liMembers = new List<User>();
   
     for(CollaborationGroupMember colMember : [select memberId,CollaborationGroupId 
                                                    from CollaborationGroupMember 
                                                    where memberId=:setInstId] )    
         {
            setMemberIds.add(colMember.memberId); 
         }   
         
     for(User tmember : [select Id,
                            UserPreferencesDisableAllFeedsEmail 
                            from User 
                            where Id=:setMemberIds])
            {
               
               tmember.UserPreferencesDisableAllFeedsEmail = false;
               liMembers.add(tmember);
               
            } 
            
       try
         {
            if(!liMembers.isEmpty()) Update liMembers;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listCreatePrivChatGrp[0].addError(message);
         } 
          
       // code to associate existing course facilitators to the participant chatter group.
          
       List <CollaborationGroupMember> liAssocFacilMems = new List< CollaborationGroupMember>(); 
       for(FA_Course_Facilitator__c tCourFacil : [select id,
                                                         FA_Course__c,
                                                         FA_Facilitator__c,
                                                         FA_Role__c 
                                                         from FA_Course_Facilitator__c
                                                         where FA_Course__c in:mcouOccIds.values()])
          
        {
           if(mCoFacilIds.ContainsKey(tCourFacil.FA_Course__c))
                    {
                       
                       instId=mCoFacilIds.get(tCourFacil.FA_Course__c);
                       instId.add(tCourFacil.FA_Facilitator__c);
                    
                    }
          else{
                   List<string> liFacil =new string[]{tCourFacil.FA_Facilitator__c};
                   mCoFacilIds.put(tCourFacil.FA_Course__c,liFacil);
              }
                        
       } 
       
         set<string> setMemGrpIds = new set<string>();
         set<string> setFacilIds = new set<string>();
       
       for(FA_Member_ChatterGroup__c m:[select FA_Group_ID__c
                                                          from FA_Member_ChatterGroup__c 
                                                          where FA_Course_Occurence__c in :mcouOccIds.keyset()])
                                                          
             {
              setMemGrpIds.add(string.valueOf(m.FA_Group_ID__c));
              
             }
       
          for(CollaborationGroupMember m:[select memberId,CollaborationGroupId 
                                                         from CollaborationGroupMember
                                                         where CollaborationGroupId in:setMemGrpIds])
           {
            setFacilIds.add(string.valueOf(m.memberId) + string.valueOf(m.CollaborationGroupId));
           }
      
           
       for(FA_Member_Chattergroup__c memChatGrp : ChatterGroup)
            {
               if(!mCoFacilIds.isEmpty()&& mCoFacilIds.containsKey(mcouOccIds.get(memChatGrp.FA_Course_Occurence__c)))      
                {
                  for(Id iFacilId:mCoFacilIds.get(mcouOccIds.get(memChatGrp.FA_Course_Occurence__c)))
                    {
                       if(!setFacilIds.contains(iFacilId + string.valueOf(memChatGrp.FA_Group_ID__c)) )
                          {
                             CollaborationGroupMember  colFacil = new CollaborationGroupMember();
                             colFacil.memberId  = iFacilId;
                             colFacil.CollaborationGroupId = memChatGrp.FA_Group_ID__c; 
                             liAssocFacilMems.add(colFacil);
                           }
                      } 
                 }
           }
       /** code to stop chatter notification mails when existing facilitator is added to Member chatter groups */  
                   
       Set<string> setFacilId = new Set<string>();
       List <User> liFacils = new List<User>();
        for(FA_Occurence_Member__c  OccMember : listCreatePrivChatGrp)    
              {
                  if(!mCoFacilIds.isEmpty() && mCoFacilIds.containsKey(mcouOccIds.get(OccMember.FA_Course_Occurence__c)))      
                    {
                      for(Id iFacilId:mCoFacilIds.get(mcouOccIds.get(OccMember.FA_Course_Occurence__c)))
                       {   
                         setFacilId.add(iFacilId);
                       }
                   }
              }
         for(User tFacil : [select Id,UserPreferencesDisableAllFeedsEmail
                                   from User 
                                   where Id=:setFacilId])
            {
               tFacil.UserPreferencesDisableAllFeedsEmail = true; 
               liFacils.add(tFacil);
            }
       try
         {
            if(!liFacils.isEmpty()) Update liFacils;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listCreatePrivChatGrp[0].addError(message);
         }  
   // code to insert existing course facilitators to member chatter group 
        
      try
        {   
          if(!liAssocFacilMems.isEmpty())  insert liAssocFacilMems;
        }   
    
    catch(DMLException de)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CoFacil','FA_Trigger_OccurenceMember','After_CreatePrivateChatterGroup','FATAL',de);
           listCreatePrivChatGrp[0].addError(message);
         }
    /* code to enable sending chatter mails after existing facilitator is added to member chatter group.*/
         
      Set<string> sFacilIds = new Set<string>();
       List <User> listFacils = new List<User>();
        for(FA_Occurence_Member__c  OccMember : listCreatePrivChatGrp)    
              {
                  if(!mCoFacilIds.isEmpty() && mCoFacilIds.containsKey(mcouOccIds.get(OccMember.FA_Course_Occurence__c)))      
                    {
                      for(Id iFacilId:mCoFacilIds.get(mcouOccIds.get(OccMember.FA_Course_Occurence__c)))
                       {   
                         sFacilIds.add(iFacilId);
                       }
                   }
              }
         for(User tFacil : [select Id,UserPreferencesDisableAllFeedsEmail
                                   from User 
                                   where Id=:sFacilIds])
            {
               tFacil.UserPreferencesDisableAllFeedsEmail = false; 
               listFacils.add(tFacil);
            }
       try
         {
            if(!liFacils.isEmpty()) Update listFacils;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listCreatePrivChatGrp[0].addError(message);
         }    
                
 }  
 
   /**
    * The Method 'After_AssociateInstructorsToPrivChatGroup' helps to associate 
      new instructors to member chatter groups and participant private chatter groups
    * When member is added to the occurence as a instructor then he will be added to the member chatter groups
      and particiapnt private chatter groups related to the course occurence.
    * @param listAssMemToGrp - list of occurence members which contains 
      occurence member trigger.new records.
    */ 
  
   
   public static void After_AssociateInstructorsToPrivChatGroup(FA_Occurence_Member__c[] listAssMemToGrp)   
    {     

      List <CollaborationGroupMember> AssociateInstructors = new List< CollaborationGroupMember>();
      Map<ID,List<ID>> mGrpInst = new Map<ID,List<ID>>();
         
 
      List<ID> OccId= new List<id>();
      
      /* 
       * code to prepare instructors for the course occurence where 
         one course occurence can have more than one instructor 
       */
     
        for(FA_Occurence_Member__c  occMem : listAssMemToGrp)                  
             {  
               if(occMem.FA_Role__c == 'Instructor')
                {
                   if(mGrpInst.ContainsKey(occMem.FA_Course_Occurence__c))
                    {
                       OccId=mGrpInst.get(occMem.FA_Course_Occurence__c);
                       OccId.add(occMem.FA_Participant_Instructor__c);
                    }
                    
                    else{
                         List<string> liInTr =new string[]{occMem.FA_Participant_Instructor__c};
                         mGrpInst.put(occMem.FA_Course_Occurence__c,liInTr);
                    }
                 }
                 
             }  
    
     
                  set<string> setGrpIds = new set<string>();
                  set<string> setinstids = new set<string>();
                  set<string> setUserIds = new set<string>();
                
          for(FA_Member_ChatterGroup__c m:[select FA_Group_ID__c,
                                                      FA_Course_Occurence__c
                                                          from FA_Member_ChatterGroup__c 
                                                          where FA_Course_Occurence__c in :mGrpInst.keyset()])
                                                          
             {
              setGrpIds.add(string.valueOf(m.FA_Group_ID__c));
              
              if(!mGrpInst.isEmpty()&& mGrpInst.containskey(m.FA_Course_Occurence__c))
               {
                   for(Id iInstId:mGrpInst.get(m.FA_Course_Occurence__c))
                     {
                       setUserIds.add(iInstId);
                      }
                 }
             
             }
       
          for(CollaborationGroupMember m:[select memberId,CollaborationGroupId 
                                                         from CollaborationGroupMember
                                                         where CollaborationGroupId in:setGrpIds])
           {
            setinstids.add(string.valueOf(m.memberId) + string.valueOf(m.CollaborationGroupId));
           }
           
        /** code to stop notification mails being sent when new instructor is added to Chatter Groups  */
       
       
       List <User> liUsers = new List<User>();
       
      
          
          for(User tOccMem : [select Id,UserPreferencesDisableAllFeedsEmail
                               from User 
                               where Id=:setUserIds])
            {
               
               tOccMem.UserPreferencesDisableAllFeedsEmail = true; 
                liUsers.add(tOccMem);
            }
       try
         {
            if(! liUsers.isEmpty()) Update  liUsers;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssMemToGrp[0].addError(message);
         }   
         
         // code to add new instructors to participant private chatter groups
       
          for(FA_Member_ChatterGroup__c memChatGrp :[select id,
                                                      FA_Chatter_Group_Name__c,
                                                      FA_Course_Occurence__c,
                                                      FA_Group_ID__c 
                                               from FA_Member_ChatterGroup__c 
                                               where FA_Course_Occurence__c =: mGrpInst.keyset()])
          {
           if(!mGrpInst.isEmpty()&& mGrpInst.containskey(memChatGrp.FA_Course_Occurence__c))
           {
               for(Id iInstId:mGrpInst.get(memChatGrp.FA_Course_Occurence__c))
                 {
                  if(!setinstids.contains(iInstId + string.valueOf(memChatGrp.FA_Group_ID__c)) )
                    {
                       CollaborationGroupMember  cGrpMem = new CollaborationGroupMember();
                       cGrpMem.memberId  = iInstId;         
                       cGrpMem.CollaborationGroupId = memChatGrp.FA_Group_ID__c;
                       AssociateInstructors.add(cGrpMem);
                    }
                 }
               }
         } 
     
     
       
      // code to insert the list 'AssociateInstructors' if list is not empty  
         
      try{
            if(!AssociateInstructors.isEmpty()) insert AssociateInstructors;
        }
     catch(DMLException de)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/ColGrupMem','FA_Trigger_OccurenceMember','After_AssociateInstructorsToPrivChatGroup','FATAL',de);
           listAssMemToGrp[0].addError(message);
         } 
         
       /** code to enable notification mails being sent after adding new instructor to Chatter Groups  */
       
       set<string> setMemIds = new set<string>();
       List <User> liMems = new List<User>();
       
  
          
          for(User tOccMem : [select Id,UserPreferencesDisableAllFeedsEmail
                               from User 
                               where Id=:setUserIds])
            {
               
               tOccMem.UserPreferencesDisableAllFeedsEmail = false; 
                liMems.add(tOccMem);
            }
       try
         {
            if(!liMems.isEmpty()) Update  liMems;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssMemToGrp[0].addError(message);
         }    
 }


  
 
 
 /*
  * The  method 'After_DeleteMembersFromGroup' helps to delete the members
    from all the groups related to the course occurence and course.
  * when member is deleted from the course occurence then he will be deleted from
    the groups which are related to the course occurence and course.
  * @param listAssMemToGrp - list of occurence members which contains 
    occurence member trigger.old records.
*/  
    
    public static void After_DeleteMembersFromGroup(FA_Occurence_Member__c[] listDelMemFroGrp)   
    {
          List <CollaborationGroupMember> liColmembers = new List< CollaborationGroupMember>();    
          Map<ID,ID> mCourGroupIds= new Map<ID,ID>();
          Map<ID,List<string>> mMemGroupIds= new Map<ID,List<string>>();
          Map<string,CollaborationGroupMember> mGroupmems= new Map<string,CollaborationGroupMember>();
          set<string> setGrupIds = new set<string>();
          set<string> setCoOccIds = new set<string>();
          set<string> setMemIds = new set<string>();
          set<string> setColGrupIds = new set<string>();
          Map<string,CollaborationGroup> mGroupId= new Map<string,CollaborationGroup>();
          Map<string,FA_Member_ChatterGroup__c> mChatGroup= new Map<string,FA_Member_ChatterGroup__c>();
          Map<string,string> mapMemGrupId= new Map<string,string>();
          List<CollaborationGroup> liColGrups = new List<CollaborationGroup>();
          List<FA_Member_ChatterGroup__c> liMemChatGrups = new List<FA_Member_ChatterGroup__c>();
          
       // code to fetch Group IDs from Course Chatter Group and Member Chatter Group
      
    for(FA_Occurence_Member__c liOccmem : listDelMemFroGrp)
          {
                 setCoOccIds.add(liOccmem.FA_Course_Occurence__c);
                 setMemIds.add(liOccmem.FA_Participant_Instructor__c); 
                                                  
          }
          
     for(FA_Course_ChatterGroup__c c : [select id,FA_Chatter_Group_Name__c,FA_Course_Occurence__c,FA_Group_ID__c
                                                                           from FA_Course_ChatterGroup__c
                                                                           where FA_Course_Occurence__c in: setCoOccIds])
            {
              setGrupIds.add(c.FA_Group_ID__c);
              mCourGroupIds.put(c.FA_Course_Occurence__c,c.FA_Group_ID__c);
            }
            
      for(FA_Member_ChatterGroup__c m :[select id,
                                               FA_Chatter_Group_Name__c,
                                               FA_Course_Occurence__c,
                                               FA_Group_ID__c,
                                               FA_Occurence_Member__c,
                                               FA_Occurence_Member__r.FA_Participant_Instructor__c
                                               from FA_Member_ChatterGroup__c
                                               where FA_Course_Occurence__c in: setCoOccIds
                                               and FA_Group_ID__c != null])
           
            {
               setGrupIds.add(m.FA_Group_ID__c);
               mChatGroup.put(string.valueOf(m.FA_Chatter_Group_Name__c),m);
               
              
               if(mMemGroupIds.containsKey(m.FA_Course_Occurence__c))
               {
                 List<string> liGroupId=mMemGroupIds.get(m.FA_Course_Occurence__c);
                 liGroupId.add(m.FA_Group_ID__c);
               }
               else
                {
                   List<string> liInTr = new string[]{m.FA_Group_ID__c};
                   mMemGroupIds.put(m.FA_Course_Occurence__c,liInTr);
                   
                }
                
               
               
            }
            
           
          
     // code to fetch records from CollaborationGroupMember based on the Group Ids set related course ocurence.
       
         
             for(CollaborationGroupMember s:[select CollaborationGroupId,memberId 
                                                                        from CollaborationGroupMember
                                                                        where CollaborationGroupId in:setGrupIds])
                {
                    mGroupmems.put(string.valueOf(s.memberId) + string.valueOf(s.CollaborationGroupId),s);               
                    
                }
                
            for(CollaborationGroup colGrup : [select id,name 
                                                      from CollaborationGroup
                                                      where id in:setGrupIds])
                   {
                    system.debug('test&&&&' + colGrup);
                    mGroupId.put(string.valueOf(colGrup.name),colGrup);
                   
                   }
                
           // code to delete the participants from the course occurence level chatter group.
                 
             for(FA_Occurence_Member__c occMember:listDelMemFroGrp)
                 {
                   
                   if(mGroupmems.containsKey(OccMember.FA_Participant_Instructor__c + string.valueOf(mCourGroupIds.get(OccMember.FA_Course_Occurence__c))))
                   {
                     liColmembers.add(mGroupmems.get(OccMember.FA_Participant_Instructor__c + string.valueOf(mCourGroupIds.get(OccMember.FA_Course_Occurence__c))));
                    
                   }
                 if(!mMemGroupIds.isEmpty()&& mMemGroupIds.containskey(OccMember.FA_Course_Occurence__c)) 
                 {   
                 for(string iGrpId: mMemGroupIds.get(OccMember.FA_Course_Occurence__c))
                     {
                         if(mGroupmems.containsKey(string.valueOf(OccMember.FA_Participant_Instructor__c) + iGrpId))
                               {
                                 liColmembers.add(mGroupmems.get(string.valueOf(OccMember.FA_Participant_Instructor__c) + iGrpId));
                                
                               }
                     }
                     
                  } 
       
           }
               
         // code to delete the participants from the course level chatter group.   
             
      // code to delete the participants from the course level chatter group.   
             
        set<string> setCourseId = new set<string>(); 
         Map<ID,ID> mCoOccId = new Map<ID,ID>();
           
        FA_Config_Settings__c liCustSetUL2020GrpId =  FA_Config_Settings__c.getValues('FA_UL2020GroupId');

                              
            
              List <CollaborationGroupMember> liDelColmembers = new List< CollaborationGroupMember>();
              Map<string,CollaborationGroupMember> mDelGroupmems = new Map<string,CollaborationGroupMember>();
              
                
             
            for(CollaborationGroupMember c:[select CollaborationGroupId,memberId 
                                                                        from CollaborationGroupMember
                                                                        where CollaborationGroupId =:liCustSetUL2020GrpId.FA_Value__c])
                {
                     mDelGroupmems.put(string.valueOf(c.memberId) + string.valueOf(c.CollaborationGroupId).substring(0,15),c);               
                     system.debug('####$$$$' + c);
                }
                
           
              
              for(FA_Occurence_Member__c occMember:listDelMemFroGrp)
                 {
                   
                   if(mDelGroupmems.containsKey(OccMember.FA_Participant_Instructor__c + string.valueOf(liCustSetUL2020GrpId.FA_Value__c)))
                   { system.debug('####Final');
                     liDelColmembers.add(mDelGroupmems.get(OccMember.FA_Participant_Instructor__c + string.valueOf(liCustSetUL2020GrpId.FA_Value__c)));
                     
                   }
                } 


           
         
    try{                             
           if(!liColmembers.isEmpty())    delete liColmembers; 
          if(!liDelColmembers.isEmpty()) delete liDelColmembers;
          
        }
   catch(DMLException de)    
        {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/ColGrupMem','FA_Trigger_OccurenceMember','After_DeleteMembersFromGroup','FATAL',de);
           listDelMemFroGrp[0].addError(message);   
        }
     
      /* code to delete the participant private chatter group(coll'n group) and Member Chatter Groups. 
        And paricipant is deleted from the groups already.
      */
     
    for(FA_Occurence_Member__c occMember:listDelMemFroGrp)
        {
          if(!mGroupId.isEmpty() && mGroupId.containsKey(string.valueOf(occMember.FA_Course_Occ_Group_Name__c)))
              {
                   
                   liColGrups.add(mGroupId.get(string.valueOf(occMember.FA_Course_Occ_Group_Name__c)));
                   
              }
              
              if(!mChatGroup.isEmpty() && mChatGroup.containsKey(string.valueOf(occMember.FA_Course_Occ_Group_Name__c)))
              {
                   
                   liMemChatGrups.add(mChatGroup.get(string.valueOf(occMember.FA_Course_Occ_Group_Name__c)));
                   
              }
          }
     // deleting the lists if they are not empty
      try
       {   
          if(!liColGrups.isEmpty())  delete liColGrups;
          if(!liMemChatGrups.isEmpty())   delete liMemChatGrups;
       }   
           
           
      catch(DMLException de)
      {  
           string message= FA_ErrorLogHandler.errorMethod('OccMem/ColGrupMem','FA_Trigger_OccurenceMember','After_DeleteMembersFromGroup','FATAL',de);
           listDelMemFroGrp[0].addError(message);    
      }    
     
  }
 /*
  * The method 'After_AssocMembersToHelpAndAllFAGroup' helps to associate the members 
    to All Fouracres and FourAcresHelp groups.
  * When member is added to the course occurence then he will be added 
    to AllFourAcres and FourAcresHelp Group. 
  * @param listAssMemToGrp - list of occurence members which contains 
    occurence member trigger.new records.
*/       
     public static void After_AssocMembersToHelpAndAllFAGroup(FA_Occurence_Member__c[] listAssMemToGrp)   
      {  
        List <CollaborationGroupMember> liAssocMems = new List< CollaborationGroupMember>();    
         FA_Config_Settings__c liCustSetting =  FA_Config_Settings__c.getValues('FA_AllFourAcres');
         FA_Config_Settings__c liCustSettingHelp =  FA_Config_Settings__c.getValues('FA_HelpGroup');
         set<string> setMemIds = new set<string>();
         set<string> setGrpIds = new set<string>();
         set<string> setOccMemIds = new set<string>();
        
        
        
        setGrpIds.add(liCustSetting.FA_Value__c);
        setGrpIds.add(liCustSettingHelp.FA_Value__c);
        
        for(FA_Occurence_Member__c  OccMember : listAssMemToGrp)    
          {
             setOccMemIds.add(OccMember.FA_Participant_Instructor__c);
             
           }        
       
     for(CollaborationGroupMember s:[select memberId,CollaborationGroupId 
                                                         from CollaborationGroupMember
                                                        where CollaborationGroupId in:setGrpIds
                                                        and memberId in:setOccMemIds])
                                                        
           {     
                 setMemIds.add(string.valueOf(s.memberId) + string.valueOf(s.CollaborationGroupId).substring(0, 15));
                 
           }
    /** code to stop notification mails being sent when occurence member is added to All four acres and Four Acres Help Groups  */       
    
       Set<string> setOccMemId = new Set<string>();
       List <User> liOccMems = new List<User>();
        for(FA_Occurence_Member__c  OccMember : listAssMemToGrp)    
              {
                     
                 setOccMemId.add(OccMember.FA_Participant_Instructor__c);
                   
              }
         for(User tOccMem : [select Id,UserPreferencesDisableAllFeedsEmail
                                    from User 
                                    where Id=:setOccMemId])
            {
               
               tOccMem.UserPreferencesDisableAllFeedsEmail = true; 
               liOccMems.add(tOccMem);
            }
       try
         {
            if(!liOccMems.isEmpty()) Update liOccMems;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssMemToGrp[0].addError(message);
         }   
         
         
         for(FA_Occurence_Member__c  OccMember : listAssMemToGrp)    
          {
              // code to associate members to All FourAcres Group.
              
              if(!setMemIds.contains(OccMember.FA_Participant_Instructor__c + string.valueOf(liCustSetting.FA_Value__c))) 
                {
              
                  CollaborationGroupMember  cMember = new CollaborationGroupMember();        
                  cMember.memberId  = OccMember.FA_Participant_Instructor__c;        
                  cMember.CollaborationGroupId =  liCustSetting.FA_Value__c;              
                  liAssocMems.add(cMember);
                }
                
                // code to associate members to FourAcres Help Group.
                
                if(!setmemids.contains(OccMember.FA_Participant_Instructor__c + string.valueOf(liCustSettingHelp.FA_Value__c)))
                {
                  CollaborationGroupMember  cMember = new CollaborationGroupMember();        
                  cMember.memberId  = OccMember.FA_Participant_Instructor__c;        
                  cMember.CollaborationGroupId =  liCustSettingHelp.FA_Value__c;              
                  liAssocMems.add(cMember);
                }
          }
         
               
       // insert the list of members if the list is not empty.
    try{   
         if(!liAssocMems.isEmpty()) insert liAssocMems;
       }
       
    catch(DMLException de)
      {  
           string message= FA_ErrorLogHandler.errorMethod('OccMem/ColGrupMem','FA_Trigger_OccurenceMember','After_AssocMembersToHelpAndAllFAGroup','FATAL',de);
           listAssMemToGrp[0].addError(message);    
      }
      
    /** code to enable sending chatter mails after Occurence Member is added to All four acres and Four Acres Help Groups */

      set<string> setMemberIds = new set<string>();
      List <User> liMembers = new List<User>();
   
  /*   for(CollaborationGroupMember colMember : [select memberId,CollaborationGroupId 
                                                    from CollaborationGroupMember 
                                                    where memberId=:setOccMemId] )    
         {
            setMemberIds.add(colMember.memberId); 
         }   */
         
     for(User tmember : [select Id,
                            UserPreferencesDisableAllFeedsEmail 
                            from User 
                            where Id=:setOccMemId])
            {
               
               tmember.UserPreferencesDisableAllFeedsEmail = false;
               liMembers.add(tmember);
              
            } 
            
       try
         {
            if(!liMembers.isEmpty()) Update liMembers;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssMemToGrp[0].addError(message);
         } 
      
         
 }
       
    /**
  * Share access to Occurence Members.
  * The Method 'After_ShareAccessToOccMembers' helps to share access to OccurenceMembers
  * When member is added to the course occurence, 
  * then this code helps to share access to course occurence and related course.
  * @param listAssMemToGrp - list on the Occurence Member object,
  * which will contain the Occurence Member trigger.new records.
  */
  
  public static void After_ShareAccessToOccMembers(FA_Occurence_Member__c[] listAssMemToGrp)   
   {
   
      List<FA_Course_Occurence__Share> liCourOccShares = new List<FA_Course_Occurence__Share>();
      List<FA_Course__Share> liCourShares  = new List<FA_Course__Share>();
      set<string> setCoOccIds = new set<string>();
      Map<ID,FA_Occurence_Member__c> mapOccMem= new Map<ID,FA_Occurence_Member__c>([select id,
                                                                                              FA_Course_Occurence__c,
                                                                                              FA_Participant_Instructor__c,
                                                                                              FA_Course_Occurence__r.FA_Course__c,
                                                                                              FA_Role__c
                                                                                          from FA_Occurence_Member__c ]);
       
        //code to share course occurence record to occurence member     
                                                                                      
         for(FA_Occurence_Member__c courMem : listAssMemToGrp)
            {
                  
                 if(CourMem.FA_Role__c== 'Instructor')
                  { 
                          FA_Course_Occurence__Share instructorShare = new FA_Course_Occurence__Share();
                          instructorShare.ParentId = mapOccMem.get(courMem.id).FA_Course_Occurence__c;
                          instructorShare.UserOrGroupId = courMem.FA_Participant_Instructor__c;
                          instructorShare.AccessLevel = 'Edit';
                          instructorShare.RowCause = Schema.FA_Course_Occurence__Share.RowCause.FA_Member_Access__c;
                          liCourOccShares.add(instructorShare);
                  }
                  
                 else 
                    { 
                          FA_Course_Occurence__Share participantShare = new FA_Course_Occurence__Share();
                          participantShare.ParentId = mapOccMem.get(courMem.id).FA_Course_Occurence__c;
                          participantShare.UserOrGroupId = courMem.FA_Participant_Instructor__c;
                          participantShare.AccessLevel = 'Read';
                          participantShare.RowCause = Schema.FA_Course_Occurence__Share.RowCause.FA_Member_Access__c;
                          liCourOccShares.add(participantShare);
                          
                    }
            
        //code to share course record to occurence member
                  if(CourMem.FA_Role__c== 'Instructor')
                   { 
                          FA_Course__Share memberShare = new FA_Course__Share();
                          memberShare.ParentId = mapOccMem.get(courMem.id).FA_Course_Occurence__r.FA_Course__c;
                          memberShare.UserOrGroupId = courMem.FA_Participant_Instructor__c;
                          memberShare.AccessLevel = 'Edit';
                          memberShare.RowCause = Schema.FA_Course__Share.RowCause.FA_Member_Access__c;
                          liCourShares.add(memberShare);
                    }
                    
                    else
                      {
                          FA_Course__Share partiShare = new FA_Course__Share();
                          partiShare.ParentId = mapOccMem.get(courMem.id).FA_Course_Occurence__r.FA_Course__c;
                          partiShare.UserOrGroupId = courMem.FA_Participant_Instructor__c;
                          partiShare.AccessLevel = 'Read';
                          partiShare.RowCause = Schema.FA_Course__Share.RowCause.FA_Member_Access__c;
                          liCourShares.add(partiShare);
                      }
                  
                  
                    
           }
            
          
     /**
      * code to insert the licourShares and licourOccShares lists,
      * if the lists are not empty
      */
     try{
              if(!liCourOccShares.isEmpty()) insert liCourOccShares;  
              if(!liCourShares.isEmpty())  insert liCourShares;
        } 
      catch(DMLException de)
      {  
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CourOccShare','FA_Trigger_OccurenceMember','After_ShareAccessToOccMembers','FATAL',de);
           listAssMemToGrp[0].addError(message);    
      }
      
       
  }  
 
/**
  * Revoke access from Occurence Members.
  * The Method 'After_RevokeAccessFromOccMembers' helps to revoke the access from OccurenceMembers
  * When member is deleted from the course occurence, 
  * then this code helps to revoke the access from course occurence and related course.
  * @param listAssMemToGrp - list on the Occurence Member object,
  * which will contain the Occurence Member trigger.old records.
  */
 
 
  public static void After_RevokeAccessFromOccMembers(FA_Occurence_Member__c[] listAssMemToGrp)   
   {        
 
          List<FA_Course_Occurence__Share> liRecordToDelete =new List<FA_Course_Occurence__Share>();
          Map<ID,ID> mapMemberCourse =  new Map<ID,ID>();
          set<string> setCourse = new set<string>();
          set<string> setCouOccurence = new set<string>();
          
          
            for(FA_Occurence_Member__c occuMem : listAssMemToGrp)
              {
               
                mapMemberCourse.put(occuMem.FA_Participant_Instructor__c,occuMem.FA_Course_Occurence__c);
              }

     // code to revoke the access from the member based on course occurence.

         for(FA_Course_Occurence__Share couOccShare : [select id,
                                                  ParentId,
                                                  UserOrGroupId,
                                                  RowCause 
                                                  from FA_Course_Occurence__Share 
                                                  where ParentId in:mapMemberCourse.values() 
                                                  and UserOrGroupId in :mapMemberCourse.keySet()
                                                  and RowCause='FA_Member_Access__c'])
                                                  
            {
               if(couOccShare.ParentId == mapMemberCourse.get(couOccShare.UserOrGroupId))
                {
                 liRecordToDelete.add(couOccShare);
                }
            }
            
      // code to delete the list - liRecordToDelete if the list is not empty
   
  try{
           delete liRecordToDelete;
     }
     
  catch(DMLException de)
      {  
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CourOccShare','FA_Trigger_OccurenceMember','After_RevokeAccessFromOccMembers','FATAL',de);
           listAssMemToGrp[0].addError(message);    
      }
         
   }
   
    /*
   * The method 'After_AssocMembersToCourseGroup' helps to associate
     the members to collaborationgroup.
   * when member is added to the course occurence, then he will be added as 
     a member to the groups which are related to that course occurence. 
   * And also helps to associate existing course facilitators
     to course chatter group
  * @param listAssMemToGrp - list of occurence members which contains 
    occurence member trigger.new records.
*/
   
   
   public static void After_AssocMembersToCourseGroup(FA_Occurence_Member__c[] listAssMemToCourseGrp)   
   {
      List <CollaborationGroupMember> AssocMembers = new List< CollaborationGroupMember>();    
      Set <CollaborationGroupMember> setAssocMembers = new Set < CollaborationGroupMember>();
      List<FA_Occurence_Member__c>  liPrivateGroup =new List<FA_Occurence_Member__c>(); 
      List<FA_Occurence_Member__c>  liPrivGroupInst =new List<FA_Occurence_Member__c>();
      List<FA_Occurence_Member__c>  liPrivGroupAllInst =new List<FA_Occurence_Member__c>();  
      Map<ID,ID> mGroupOccs= new Map<ID,ID>();
      Set<string> setCoOccId= new Set<string>(); 
      Map<ID,ID> mCoOccIds = new Map<ID,ID>();
      List<ID> facilId= new List<id>();
      
       FA_Config_Settings__c liCustSetUL2020GrpId =  FA_Config_Settings__c.getValues('FA_UL2020GroupId');
       Set<string> setCourseId= new Set<string>(); 
       
       setCourseId.add(liCustSetUL2020GrpId.FA_Value__c);
       
  
     
     list<CollaborationGroupMember> lstcolmem = [select memberId,CollaborationGroupId 
                                                         from CollaborationGroupMember
                                                         where CollaborationGroupId =:setCourseId];
     set<string> setmemids = new set<string>();
     for(CollaborationGroupMember s:lstcolmem)
         setmemids.add(string.valueOf(s.memberId) + string.valueOf(s.CollaborationGroupId).substring(0, 15));
         
      List <CollaborationGroupMember> liCoAssocFacilMems = new List< CollaborationGroupMember>(); 
      
       
       
        /** code to stop chatter notification mails when participant is added to course chatter group.**/  
          
       Set<string> setUserId = new Set<string>();
       List <User> liUsers = new List<User>();
       
       for(FA_Occurence_Member__c  OccMember : listAssMemToCourseGrp)    
           {
               setUserId.add(OccMember.FA_Participant_Instructor__c);
            } 
       
       for(User tuser : [select Id,UserPreferencesDisableAllFeedsEmail
                                from User 
                                where Id=:setUserId])
            {
               tuser.UserPreferencesDisableAllFeedsEmail = true; 
               liUsers.add(tuser);
             
            }
       try
         {
            if(!liUsers.isEmpty()) Update liUsers;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssMemToCourseGrp[0].addError(message);
         }  
     /** code to stop chatter notification mails when existing facilitator is added to course chatter group.**/ 
       
   
     // code to insert the occurence members into the chatter group based on the course occurence.
     FA_Config_Settings__c liCustSetUL2020 =  FA_Config_Settings__c.getValues('FA_UL2020Programme');    
     
         for(FA_Occurence_Member__c  OccMember : listAssMemToCourseGrp)    
          {      
               if(OccMember.FA_Course_name__c==liCustSetUL2020.FA_Value__c)
                {
                    system.debug('test666' + OccMember.FA_Course_name__c );
                    system.debug('test****' + setmemids);
                    if(!setmemids.contains(OccMember.FA_Participant_Instructor__c + string.valueOf(liCustSetUL2020GrpId.FA_Value__c)))
                    {
                     system.debug('test0000');
                     system.debug('test$$$$$' + OccMember.FA_Participant_Instructor__c + string.valueOf(liCustSetUL2020GrpId.FA_Value__c));
                     
                      CollaborationGroupMember  cMember = new CollaborationGroupMember();        
                      cMember.memberId  = OccMember.FA_Participant_Instructor__c;        
                      cMember.CollaborationGroupId =  liCustSetUL2020GrpId.FA_Value__c;              
                      AssocMembers.add(cMember);
                    }
              }
          }
      // code to insert the course facilitators into the chatter group   
                
              
  
     
        try
        {
            if(!AssocMembers.isEmpty()) insert AssocMembers;
         
        }
        
       
    
          
     catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssMemToCourseGrp[0].addError(message);
         }   
         
         /** code to enable sending chatter notification mails after adding Participant to course chatter group */ 
          
      
        set<string> setMemberIds = new set<string>();
        List <User> liMembers = new List<User>();
  
             
         for(User tmember : [select Id,
                                UserPreferencesDisableAllFeedsEmail 
                                from User 
                                where Id=:setUserId])
                {
                  
                   tmember.UserPreferencesDisableAllFeedsEmail = false;
                   liMembers.add(tmember);
                   
                } 
                
           try
             {
                if(!liMembers.isEmpty()) Update liMembers;
             }
      
           catch(DMLException ex)
             {
               string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
               listAssMemToCourseGrp[0].addError(message);
             } 
    
     }
     
     /*
  * The method 'After_AssocMembersToThemeBasedGroups' helps to associate the members 
    to All Fouracres and FourAcresHelp groups.
  * When member is added to the course occurence then he will be added 
    to AllFourAcres and FourAcresHelp Group. 
  * @param listAssMemToGrp - list of occurence members which contains 
    occurence member trigger.new records.
*/       
   /*  public static void After_AssocMembersToThemeBasedGroups(FA_Occurence_Member__c[] listAssMemToThemeGrp)   
      {  
        List <CollaborationGroupMember> liAssocMems = new List< CollaborationGroupMember>();
            
         FA_Config_Settings__c liCustSetHealth =  FA_Config_Settings__c.getValues('FA_ImprovingHealth');
         FA_Config_Settings__c liCustSetEnvImpacts =  FA_Config_Settings__c.getValues('FA_ReduceEnvImpacts');
         FA_Config_Settings__c liCustSetLivelihoods =  FA_Config_Settings__c.getValues('FA_EnhanceLivelihoods');
        FA_Config_Settings__c liCustSetUL2020 =  FA_Config_Settings__c.getValues('FA_UL2020Programme');
         
         set<string> setMemIds = new set<string>();
         set<string> setGrpIds = new set<string>();
         set<string> setOccMemIds = new set<string>();
         set<string> setCourseId = new set<string>();
        
        
        
        setGrpIds.add(liCustSetHealth.FA_Value__c);
        setGrpIds.add(liCustSetEnvImpacts.FA_Value__c);
        setGrpIds.add(liCustSetLivelihoods.FA_Value__c);
        setCourseId.add(liCustSetUL2020.FA_Value__c);
        
        for(FA_Occurence_Member__c  OccMember : listAssMemToThemeGrp)    
          {
          
               if(OccMember.FA_Course_name__c==liCustSetUL2020.FA_Value__c)
               {
                 system.debug('!!!!!!!!!!');
                 setOccMemIds.add(OccMember.FA_Participant_Instructor__c);
                 system.debug('$$$$$$$$$'+OccMember.FA_Course_name__c);
                 system.debug('&&&&&&&&&'+liCustSetUL2020.FA_Value__c);
               }
           
          }   
          
       
       
     for(CollaborationGroupMember s:[select memberId,CollaborationGroupId 
                                                         from CollaborationGroupMember
                                                        where CollaborationGroupId in:setGrpIds
                                                        and memberId in:setOccMemIds])
                                                        
           {     
                 setMemIds.add(string.valueOf(s.memberId) + string.valueOf(s.CollaborationGroupId).substring(0, 15));
                 
           }
    // code to stop notification mails being sent when occurence member is added to Theme based Groups        
    
       Set<string> setOccMemId = new Set<string>();
       List <User> liOccMems = new List<User>();
        for(FA_Occurence_Member__c  OccMember : listAssMemToThemeGrp)    
              {
                     
                 setOccMemId.add(OccMember.FA_Participant_Instructor__c);
                   
              }
         for(User tOccMem : [select Id,UserPreferencesDisableAllFeedsEmail
                                    from User 
                                    where Id=:setOccMemId])
            {
               
               tOccMem.UserPreferencesDisableAllFeedsEmail = true; 
               liOccMems.add(tOccMem);
            }
       try
         {
            if(!liOccMems.isEmpty()) Update liOccMems;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssocMembersToThemeBasedGroups','FATAL',ex);
           listAssMemToThemeGrp[0].addError(message);
         }   
         
         
         for(FA_Occurence_Member__c  OccMember : listAssMemToThemeGrp)    
          {
              // code to associate members to Improving health and well-being Group.
            if(OccMember.FA_Course_name__c==liCustSetUL2020.FA_Value__c)
               {  
                  if(!setMemIds.contains(OccMember.FA_Participant_Instructor__c + string.valueOf(liCustSetHealth.FA_Value__c))) 
                    {
                  
                      CollaborationGroupMember  cMember = new CollaborationGroupMember();        
                      cMember.memberId  = OccMember.FA_Participant_Instructor__c;        
                      cMember.CollaborationGroupId =  liCustSetHealth.FA_Value__c;              
                      liAssocMems.add(cMember);
                    }
              }  
                // code to associate members to Reducing Environmental Group.
                
                if(!setmemids.contains(OccMember.FA_Participant_Instructor__c + string.valueOf(liCustSetEnvImpacts.FA_Value__c)))
                {
                    if(OccMember.FA_Course_name__c==liCustSetUL2020.FA_Value__c)
                     {
                      CollaborationGroupMember  cMember = new CollaborationGroupMember();        
                      cMember.memberId  = OccMember.FA_Participant_Instructor__c;        
                      cMember.CollaborationGroupId =  liCustSetEnvImpacts.FA_Value__c;              
                      liAssocMems.add(cMember);
                    }
               } 
                // code to associate members to Enahancing Livelihoods Group.
                if(OccMember.FA_Course_name__c==liCustSetUL2020.FA_Value__c)
                {
                    if(!setmemids.contains(OccMember.FA_Participant_Instructor__c + string.valueOf(liCustSetLivelihoods.FA_Value__c)))
                    {
                      CollaborationGroupMember  cMember = new CollaborationGroupMember();        
                      cMember.memberId  = OccMember.FA_Participant_Instructor__c;        
                      cMember.CollaborationGroupId =  liCustSetLivelihoods.FA_Value__c;              
                      liAssocMems.add(cMember);
                    }
              }
          }
         
               
       // insert the list of members if the list is not empty.
    try{   
         if(!liAssocMems.isEmpty()) insert liAssocMems;
       }
       
    catch(DMLException de)
      {  
           string message= FA_ErrorLogHandler.errorMethod('OccMem/ColGrupMem','FA_Trigger_OccurenceMember','After_AssocMembersToThemeBasedGroups','FATAL',de);
           listAssMemToThemeGrp[0].addError(message);    
      }
      
    //code to enable sending chatter mails after Occurence Member is added to All four acres and Four Acres Help Groups 

      set<string> setMemberIds = new set<string>();
      List <User> liMembers = new List<User>();
   
  /*   for(CollaborationGroupMember colMember : [select memberId,CollaborationGroupId 
                                                    from CollaborationGroupMember 
                                                    where memberId=:setOccMemId] )    
         {
            setMemberIds.add(colMember.memberId); 
         }  ************** */
         
   /*  for(User tmember : [select Id,
                            UserPreferencesDisableAllFeedsEmail 
                            from User 
                            where Id=:setOccMemId])
            {
               
               tmember.UserPreferencesDisableAllFeedsEmail = false;
               liMembers.add(tmember);
              
            } 
            
       try
         {
            if(!liMembers.isEmpty()) Update liMembers;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssocMembersToThemeBasedGroups','FATAL',ex);
           listAssMemToThemeGrp[0].addError(message);
         } 
      
} */

 /*
  * The method 'After_AssocTasksToNewMembers' helps to associate the pre-work Tasks to occurence members 
  * When member is added to the course occurence then the list of pre-work tasks will be assigned to the member
  * @param listAssTasksToMem - list of occurence members which contains 
    occurence member trigger.new records.
*/       
     public static void After_AssocTasksToNewMembers(FA_Occurence_Member__c[] listAssTasksToMem)   
      { 
        List < FA_Pre_Work_Task__c > liPreWorkTasks = new List < FA_Pre_Work_Task__c >();   
        Map<ID,ID> mOccIds = new Map<ID,ID>();   
        Set<string> setCoOccId = new Set<string>(); 
        
        for(FA_Occurence_Member__c liOcmem : listAssTasksToMem)
          {       
            setCoOccId.add(liOcmem.FA_Course_Occurence__c);                                                   
          } 
          
          
          
        Map<ID,List<ID>> mTaskIds= new Map<ID,List<ID>>();
        List<ID> taskId = new List<id>();
      
      // code to prepare existing list of Tasks related to the course occurence
      
       for(FA_Pre_Work_Task_Assignment__c tPreTasks : [select id,
                                                         FA_Occurence__c,
                                                         FA_Upload_Mark_Complete__c
                                                         from FA_Pre_Work_Task_Assignment__c
                                                         where FA_Occurence__c in:setCoOccId])
          
        {
               if(mTaskIds.ContainsKey(tPreTasks.FA_Occurence__c))
                    {
                       
                       taskId = mTaskIds.get(tPreTasks.FA_Occurence__c);
                       taskId.add(tPreTasks.id);
                    
                    }
               else
                 {
                       List<string> liTasks =new string[]{tPreTasks.id};
                       mTaskIds.put(tPreTasks.FA_Occurence__c,liTasks);
                 }
                        
       } 
       
       set<string> setTaskids = new set<string>();
       set<string> setmemids = new set<string>();
       Map<ID,date> mDueDate = new Map<ID,date>();
       Map<ID,String> mTaskName= new Map<ID,String>();
       Map<ID,String> mTaskDesc= new Map<ID,String>();
       
           for(FA_Pre_Work_Task_Assignment__c preWorkTasks : [select id,
                                                                     FA_Occurence__c,
                                                                     FA_Task_Name_PWTA__c,
                                                                     FA_Task_Description_PWTA__c,
                                                                     FA_Due_Date__c,
                                                                     FA_Upload_Mark_Complete__c
                                                                     from FA_Pre_Work_Task_Assignment__c
                                                                     where FA_Occurence__c in:mTaskIds.keyset()])
              
             { 
                       
                        setTaskids.add(string.valueOf(preWorkTasks.id));
                        mDueDate.put(preWorkTasks.id,preWorkTasks.FA_Due_Date__c);
                        mTaskName.put(preWorkTasks.id,preWorkTasks.FA_Task_Name_PWTA__c);
                       mTaskDesc.put(preWorkTasks.id,preWorkTasks.FA_Task_Description_PWTA__c);
             }
              
           for(FA_Pre_Work_Task__c t:[select id,
                                             FA_OccMember__c,
                                             FA_Occurence_Task__c 
                                             from FA_Pre_Work_Task__c 
                                             where FA_Occurence_Task__c in:setTaskids])
             {
               
                setmemids.add(string.valueOf(t.FA_Occurence_Task__c + string.valueOf(t.FA_OccMember__c)));
                
             } 
       
        // code to associate the list of tasks to the new occurence member who has been added 
        for(FA_Occurence_Member__c  OccMember : listAssTasksToMem)    
              { 
                if(OccMember.FA_Role__c == 'Participant')
                {
                if(!mTaskIds.isEmpty() && mTaskIds.containsKey(OccMember.FA_Course_Occurence__c))      
                 {
                 
                  system.debug('firsttest');
                  for(Id iTaskId:mTaskIds.get(OccMember.FA_Course_Occurence__c))
                    {
                      system.debug('secondtest');
                        if(!setmemids.contains(iTaskId + string.valueOf(OccMember.id)))
                          {
                             FA_Pre_Work_Task__c  liPreTask = new FA_Pre_Work_Task__c();
                             liPreTask.FA_Occurence_Task__c = iTaskId;
                             liPreTask.FA_OccMember__c = OccMember.id;
                             liPreTask.FA_OccurenceOM__c = OccMember.FA_Course_Occurence__c;
                             liPreTask.FA_Due_Date__c = mDueDate.get(iTaskId);
                             liPreTask.FA_Task_Name__c = mTaskName.get(iTaskId);
                             liPreTask.FA_Task_Description__c = mTaskDesc.get(iTaskId);
                             liPreWorkTasks.add(liPreTask);
                          }
                              
                    } 
                 } 
             }
        }
        
        try
        {
            if(!liPreWorkTasks.isEmpty()) insert liPreWorkTasks;
        }
        
       
    
          
     catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/PreworkTasks','FA_Trigger_OccurenceMember','After_AssocTasksToNewMembers','FATAL',ex);
           listAssTasksToMem[0].addError(message);
         }   
      
      }
      
  /*
      public static void After_DelTasksFroDelMembers(FA_Occurence_Member__c[] listDelTasksFroMem)   
      { 
           List < FA_Pre_Work_Task__c > liPWTaskstobeDeleted = new List < FA_Pre_Work_Task__c >(); 
           set<string> setMemIds = new set<string>();
           set<string> setOccIds = new set<string>();
           Map<string,FA_Pre_Work_Task__c> mPwTasks = new Map<string,FA_Pre_Work_Task__c>();
       
               for(FA_Occurence_Member__c ocMem: listDelTasksFroMem)
                  
                   {
                     setMemIds.add(ocMem.id);
                     setOccIds.add(ocMem.FA_Course_Occurence__c);
                   }
               
              for(FA_Pre_Work_Task__c pt : [select FA_Occurence_Task__c,
                                                   FA_OccMember__c,
                                                   FA_OccurenceOM__c 
                                                   from FA_Pre_Work_Task__c
                                                   where FA_OccurenceOM__c=:setOccIds and
                                                   FA_OccMember__c=:setMemIds])
                  {
                  
                    mPwTasks.put(string.valueOf(pt.FA_OccurenceOM__c)+string.valueOf(pt.FA_OccMember__c),pt);
                  }
                  
              for(FA_Occurence_Member__c ocMem: listDelTasksFroMem)
                  
                  {
                    if(mPwTasks.containskey(string.valueOf(ocMem.FA_Course_Occurence__c)+string.valueOf(ocMem.id)))
                    {
                     
                     liPWTaskstobeDeleted.add(mPwTasks.get(string.valueOf(ocMem.FA_Course_Occurence__c)+string.valueOf(ocMem.id)));
                     
                    }
                  
                  } 
                  
              try{
                  delete liPWTaskstobeDeleted;
                 }
     
              catch(DMLException de)
                  {  
                       string message= FA_ErrorLogHandler.errorMethod('OccMem/CourOccShare','FA_Trigger_OccurenceMember','After_DelTasksFroDelMembers','FATAL',de);
                       listDelTasksFroMem[0].addError(message);    
                  }     
      
      }*/
  
  }