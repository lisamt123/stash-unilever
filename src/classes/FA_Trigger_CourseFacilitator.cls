/** 
  * This class is used to add course facilitators to All FourAcres group,
  * FourAcres Help group,course chatter group and member chatter groups
  * when course facilitator is created.
  */
  public class FA_Trigger_CourseFacilitator { 

/**
  * The Method 'After_AssociateFacilitatorsToGroup' helps to add 
  * course facilitators to chatter groups when course facilitator is created.
  * It helps to associate the course facilitators,
  * to All FourAcres and FourAcres Help groups based on the course occurence.
  * @param listAssFacilToGrp is the list on the course facilitator object,
  * which will contain the course facilitator trigger.new records.
*/ 
  public static void After_AssociateFacilitatorsToGroup(FA_Course_Facilitator__c[] listAssFacilToGrp)   
   {
        List <CollaborationGroupMember> liAssocMems = new List< CollaborationGroupMember>();    
        FA_Config_Settings__c liCustSetAllFAcres= FA_Config_Settings__c.getValues('FA_AllFourAcres');
        FA_Config_Settings__c liCustSettingFAHelp = FA_Config_Settings__c.getValues('FA_HelpGroup');
        set<string> setmemids = new set<string>();
        set<string> setGrpIds = new set<string>();
        set<string> setCoFacilIds = new set<string>();
       
    
      
/**
  * Set setGrpIds contains the CollaborationGroup ID's of AllFouracres Group
  * and Fouracres Help Group
  * Set setCoFacilIds contains the trigger.new faciltator ids
  */
       
        setGrpIds.add(liCustSetAllFAcres.FA_Value__c);
        setGrpIds.add(liCustSettingFAHelp.FA_Value__c);
        
        for(FA_Course_Facilitator__c  coFacil : listAssFacilToGrp)    
          {
             setCoFacilIds.add(coFacil.FA_Facilitator__c);
             
           } 
           
/**
   Set setMemIds contains the combination of member id and CollaborationGroupId.
   Used substring function to convert 18-digit CollaborationGroupId into 15-digit Id.
  */       
       
     for(CollaborationGroupMember s:[select memberId,CollaborationGroupId 
                                                         from CollaborationGroupMember
                                                        where CollaborationGroupId in:setGrpIds
                                                        and memberId in:setCoFacilIds])
                                                        
           {     
                 setMemIds.add(string.valueOf(s.memberId) + string.valueOf(s.CollaborationGroupId).substring(0, 15));
                 
           }
           
    /** code to stop notification mails being sent when Course facilitator is added to All four acres and Four Acres Help Groups  */
           
       Set<string> setFacilId = new Set<string>();
       List <User> liUserIds = new List<User>();
        for(FA_Course_Facilitator__c  coFacils : listAssFacilToGrp)    
              {
                     
                 setFacilId.add(coFacils.FA_Facilitator__c);
                   
              }
         for(User tUser : [select Id,UserPreferencesDisableAllFeedsEmail
                                  from User 
                                  where Id=:setFacilId])
            {
               
               tUser.UserPreferencesDisableAllFeedsEmail = true; 
               liUserIds.add(tUser);
            }
       try
         {
            if(!liUserIds.isEmpty()) Update liUserIds;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssFacilToGrp[0].addError(message);
         }   
        
/**
  * code to associate course facilitator to AllFouracres Group
   and Fouracres Help Group when new course facilitator is created.
  */
       
    for(FA_Course_Facilitator__c  courFacilitator : listAssFacilToGrp)    
          {
             if(!setmemids.contains(courFacilitator.FA_Facilitator__c + string.valueOf(liCustSetAllFAcres.FA_Value__c)))
               {
               
                  CollaborationGroupMember  cMember = new CollaborationGroupMember();        
                  cMember.memberId  = courFacilitator.FA_Facilitator__c;        
                  cMember.CollaborationGroupId =  liCustSetAllFAcres.FA_Value__c;              
                  liAssocMems.add(cMember);
                  
                }
                
                if(!setmemids.contains(courFacilitator.FA_Facilitator__c + string.valueOf(liCustSettingFAHelp.FA_Value__c)))
               {
                  CollaborationGroupMember  cMember = new CollaborationGroupMember();        
                  cMember.memberId  = courFacilitator.FA_Facilitator__c;        
                  cMember.CollaborationGroupId =  liCustSettingFAHelp.FA_Value__c;              
                  liAssocMems.add(cMember);
                  
                }
          }
          
  /**
    * code to insert the liAssocMems if the list is not empty
    */ 
    
    try
         {
             if(!liAssocMems.isEmpty())
             insert liAssocMems;
         }
     
    catch(DMLException de) 
          {
             string message= FA_ErrorLogHandler.errorMethod('CourseFacilitator','FA_Trigger_CourseFacilitator','After_AssociateFacilitatorsToGroup','FATAL',de);
             listAssFacilToGrp[0].addError(message);
               
         }
     
     /** code to enable sending chatter mails after Course facilitator is added to All four acres and Four Acres Help Groups */
           
       Set<string> setMemberIds = new Set<string>();
       List <User> liUsers = new List<User>();
       
       for(CollaborationGroupMember colMember : [select memberId,CollaborationGroupId 
                                                    from CollaborationGroupMember 
                                                    where memberId=:setFacilId] )    
         {
            setMemberIds.add(colMember.memberId); 
         }
      
       for(User tUsers : [select Id,UserPreferencesDisableAllFeedsEmail
                                  from User 
                                  where Id=:setMemberIds])
            {
               
               tUsers.UserPreferencesDisableAllFeedsEmail = false; 
               liUsers.add(tUsers);
            }
       try
         {
            if(!liUsers.isEmpty()) Update liUsers;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssFacilToGrp[0].addError(message);
         }     
    
  }
 
/**
  * The Method 'After_AssocFacilitatorsToGroup' helps to add 
  * course facilitators to chatter groups when course facilitator is created.
  * It helps to associate the course facilitators,
  * to Course chatter group and member chatter groups based on the course.
  * @param listAssFacilToGrp is the list on the course facilitator object,
  * which will contain the course facilitator trigger.new records.
*/  
   public static void After_AssocFacilitatorsToGroup(FA_Course_Facilitator__c[] listAssFacilToGrp)   
   {
    List <CollaborationGroupMember> liCoAssocFacilMems = new List< CollaborationGroupMember>();    
     Map<ID,ID> mCourFacilIds = new Map<ID,ID>();
     set<string> setGrupIds = new set<string>();
     // Map<ID,ID> mCourGroupIds = new Map<ID,ID>();
      //Map<ID,ID> mMemChGrpIds = new Map<ID,ID>();
      set<string> setMemIds = new set<string>();
      
      for(FA_Course_Facilitator__c  coFacil : listAssFacilToGrp)    
          {
             
             mCourFacilIds.put(coFacil.FA_Course__c,coFacil.FA_Facilitator__c);
           }
           
           set<string> setMemGrpIds = new set<string>();
           set<string> setFacilIds = new set<string>();
           
       List<ID> liChatGrpId = new List<id>(); 
        Map<ID,List<ID>> mCourGroupIds = new Map<ID,List<ID>>();    
      for(FA_Course_ChatterGroup__c c : [select id,FA_Chatter_Group_Name__c,FA_Course_Occurence__c,FA_Group_ID__c,
                                                                           FA_Course_Occurence__r.FA_Course__c
                                                                           from FA_Course_ChatterGroup__c
                                                                           where FA_Course_Occurence__r.FA_Course__c in:mCourFacilIds.keyset()])
            {
               setMemGrpIds.add(string.valueOf(c.FA_Group_ID__c));
               
               if(mCourGroupIds.containsKey(c.FA_Course_Occurence__r.FA_Course__c))
               {
                 liChatGrpId=mCourGroupIds.get(c.FA_Course_Occurence__r.FA_Course__c);
                 liChatGrpId.add(c.FA_Group_ID__c);
               }
               else
                {
                   List<string> liGrpId = new string[]{c.FA_Group_ID__c};
                   mCourGroupIds.put(c.FA_Course_Occurence__r.FA_Course__c,liGrpId);
                }
             }
       
            
        
        List<ID> liMemGrpId = new List<id>();    
        Map<ID,List<ID>> mMemChGrpIds = new Map<ID,List<ID>>();
       for(FA_Member_ChatterGroup__c m:[select FA_Group_ID__c,
                                                FA_Course_Occurence__r.FA_Course__c
                                                          from FA_Member_ChatterGroup__c 
                                                          where FA_Course_Occurence__r.FA_Course__c in :mCourFacilIds.keyset()])
                                                          
             {
              setMemGrpIds.add(string.valueOf(m.FA_Group_ID__c));
             // mMemChGrpIds.put(m.FA_Course_Occurence__r.FA_Course__c,m.FA_Group_ID__c);
              
              if(mMemChGrpIds.containsKey(m.FA_Course_Occurence__r.FA_Course__c))
               {
                 liMemGrpId=mMemChGrpIds.get(m.FA_Course_Occurence__r.FA_Course__c);
                 liMemGrpId.add(m.FA_Group_ID__c);
               }
               else
                {
                   List<string> liGrpId = new string[]{m.FA_Group_ID__c};
                   mMemChGrpIds.put(m.FA_Course_Occurence__r.FA_Course__c,liGrpId);
                }
             }
       
       
            
     for(CollaborationGroupMember s:[select memberId,CollaborationGroupId 
                                                         from CollaborationGroupMember
                                                        where CollaborationGroupId in:setMemGrpIds
                                                        and memberId in:mCourFacilIds.values()])
                                                        
           {     
                 setMemIds.add(string.valueOf(s.memberId) + string.valueOf(s.CollaborationGroupId));
                 
           }
         List<ID> facilId= new List<id>();
         Map<ID,List<ID>> mCoFacilIds= new Map<ID,List<ID>>();
        
    /* preparing course facilitators for each course where as there can be 
       more than one facilitator for each course 
     */
            
       for(FA_Course_Facilitator__c tCourFacil : listAssFacilToGrp)
          
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
/** code to avoid multiple mails being sent when course facilitator is added to chatter groups 
          
  **/   
  
     Set<string> setMemberIds = new Set<string>();
     List <User> liUsers = new List<User>();  
       
      for(FA_Course_Facilitator__c  coFacil : listAssFacilToGrp)
       {
         for(string iFacilId:mCoFacilIds.get(coFacil.FA_Course__c))
            {
              setMemberIds.add(coFacil.FA_Facilitator__c);
            }
        }
        
      for(User tUsers : [select Id,UserPreferencesDisableAllFeedsEmail
                                  from User 
                                  where Id=:setMemberIds])
            {
               
               tUsers.UserPreferencesDisableAllFeedsEmail = true; 
               liUsers.add(tUsers);
            }
       try
         {
            if(!liUsers.isEmpty()) Update liUsers;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssFacilToGrp[0].addError(message);
         }     
        
        
        
     List <CollaborationGroupMember> liAssFacilMemChats = new List< CollaborationGroupMember>();      
      
    // code to associate the facilitator as member to course and member chatter groups 

      for(FA_Course_Facilitator__c  coFacil : listAssFacilToGrp)
       {
       
        if(!mCoFacilIds.isEmpty() && mCoFacilIds.containsKey(coFacil.FA_Course__c))
         {
          if(!mCourGroupIds.isEmpty() && mCourGroupIds.ContainsKey(coFacil.FA_Course__c))
          {
           for(string iFacilId:mCoFacilIds.get(coFacil.FA_Course__c))
            {
              for(string cGrpIds:mCourGroupIds.get(coFacil.FA_Course__c))
              {
               if(!setmemids.contains(iFacilId + cGrpIds)) 
                 {
                
                      CollaborationGroupMember  colFacil = new CollaborationGroupMember();
                      colFacil.memberId  = iFacilId;
                      colFacil.CollaborationGroupId = cGrpIds;
                      liCoAssocFacilMems.add(colFacil);
                 }
             }
           }
          }
        }
     if(!mCoFacilIds.isEmpty() && mCoFacilIds.containsKey(coFacil.FA_Course__c))
      {
       if(!mMemChGrpIds.isEmpty() && mMemChGrpIds.ContainsKey(coFacil.FA_Course__c))
         {
          for(string iFacilId:mCoFacilIds.get(coFacil.FA_Course__c))
          {
            for(string IGrpId:mMemChGrpIds.get(coFacil.FA_Course__c))
              {
                if(!setmemids.contains(iFacilId + IGrpId)) 
                  {
                  
                      CollaborationGroupMember  cFacilMem = new CollaborationGroupMember();
                      cFacilMem.memberId  = iFacilId;
                      cFacilMem.CollaborationGroupId = IGrpId; 
                      liAssFacilMemChats.add(cFacilMem);
                   }
                }
             }
          } 
        }  
     }
   
   
    
       
  
    
    // insert the lists if they are not empty.
    try
    {   
        if(!liCoAssocFacilMems.isEmpty())   insert liCoAssocFacilMems; 
        if(!liAssFacilMemChats.isEmpty()) insert liAssFacilMemChats;
    }
    
    catch(DMLException de) 
          {
            
                string message= FA_ErrorLogHandler.errorMethod('CourseFacilitator','FA_Trigger_CourseFacilitator','After_AssocFacilitatorsToGroup','FATAL',de);
                listAssFacilToGrp[0].addError(message);

         }
    
    /** code to enable sending chatter mails after Course facilitator is added to Chatter Groups */
           
       Set<string> setFacilMemIds = new Set<string>();
       List <User> liUser = new List<User>();
       
       for(CollaborationGroupMember colMember : [select memberId,CollaborationGroupId 
                                                    from CollaborationGroupMember 
                                                    where memberId=:setMemberIds] )    
         {
            setFacilMemIds.add(colMember.memberId); 
         }
      
       for(User tUsers : [select Id,UserPreferencesDisableAllFeedsEmail
                                  from User 
                                  where Id=:setFacilMemIds])
            {
               
               tUsers.UserPreferencesDisableAllFeedsEmail = false; 
               liUser.add(tUsers);
            }
       try
         {
            if(!liUser.isEmpty()) Update liUser;
         }
  
       catch(DMLException ex)
         {
           string message= FA_ErrorLogHandler.errorMethod('OccMem/CouFacil','FA_Trigger_OccurenceMember','After_AssociateMembersToGroup','FATAL',ex);
           listAssFacilToGrp[0].addError(message);
         }     
    
}


/*
  * The  method 'After_DeleteFacilitatorsFromGroup' helps to delete the facilitators
    from course chatter and member chatter groups related to the course occurence.
  * when facilitator is deleted from the course then he will be deleted from
    the groups which are related to that particular course.
  * @param lidelFacilFroGrp- list on course facilitator object which contains 
    course facilitator trigger.old records.
  */    
    
   
    public static void After_DeleteFacilitatorsFromGroup(FA_Course_Facilitator__c[] lidelFacilFroGrp)   
    {
      List <CollaborationGroupMember> liColmembers = new List< CollaborationGroupMember>();    
      set<string> setGrupIds = new set<string>();
      Map<ID,ID> mCourFacilIds = new Map<ID,ID>();
      
      for(FA_Course_Facilitator__c liCoFacil : lidelFacilFroGrp)
          {
             mCourFacilIds.put(liCoFacil.FA_Course__c,liCoFacil.FA_Facilitator__c);
             
          }
          
       Map<ID,List<string>> mCourGroupIds = new Map<ID,List<string>>();
       List<ID> liChGroupId = new List<id>(); 
          
      for(FA_Course_ChatterGroup__c c : [select id,FA_Chatter_Group_Name__c,
                                                              FA_Course_Occurence__c,
                                                              FA_Group_ID__c,
                                                              FA_Course_Occurence__r.FA_Course__c
                                                                from FA_Course_ChatterGroup__c
                                                                 where FA_Course_Occurence__r.FA_Course__c in: mCourFacilIds.keyset()])
            {
              setGrupIds.add(c.FA_Group_ID__c);
             
              
              if(mCourGroupIds.containsKey(c.FA_Course_Occurence__r.FA_Course__c))
               {
                 liChGroupId=mCourGroupIds.get(c.FA_Course_Occurence__r.FA_Course__c);
                 liChGroupId.add(c.FA_Group_ID__c);
               }
               else
                {
                   List<string> liGrpId = new string[]{c.FA_Group_ID__c};
                   mCourGroupIds.put(c.FA_Course_Occurence__r.FA_Course__c,liGrpId);
                }

              
            }
            
      Map<ID,List<string>> mMemGroupIds= new Map<ID,List<string>>();
       List<ID> liGroupId = new List<id>();  
           
       for(FA_Member_ChatterGroup__c m :[select id,
                                               FA_Chatter_Group_Name__c,
                                               FA_Course_Occurence__c,
                                               FA_Group_ID__c,
                                               FA_Occurence_Member__c,
                                               FA_Course_Occurence__r.FA_Course__c
                                               from FA_Member_ChatterGroup__c
                                               where FA_Course_Occurence__r.FA_Course__c in: mCourFacilIds.keyset()
                                               and FA_Group_ID__c != null])
           
            {
               setGrupIds.add(m.FA_Group_ID__c);
             
               
             if(mMemGroupIds.containsKey(m.FA_Course_Occurence__r.FA_Course__c))
               {
                 liGroupId=mMemGroupIds.get(m.FA_Course_Occurence__r.FA_Course__c);
                 liGroupId.add(m.FA_Group_ID__c);
               }
               else
                {
                   List<string> liGrpId = new string[]{m.FA_Group_ID__c};
                   mMemGroupIds.put(m.FA_Course_Occurence__r.FA_Course__c,liGrpId);
                   
                }
            }
      
            Map<string,CollaborationGroupMember> mGroupmems = new Map<string,CollaborationGroupMember>();
              for(CollaborationGroupMember s:[select CollaborationGroupId,memberId 
                                                                        from CollaborationGroupMember
                                                                        where CollaborationGroupId in:setGrupIds
                                                                        and memberId in:mCourFacilIds.values()])

                {
               
                    mGroupmems.put(string.valueOf(s.memberId) + string.valueOf(s.CollaborationGroupId),s);               
                   
                }
                
             for(FA_Course_Facilitator__c tCoFacil:lidelFacilFroGrp)
                 {
                   if(!mCourGroupIds.isEmpty()&& mCourGroupIds.containskey(tCoFacil.FA_Course__c)) 
                    {
                      
                     for(string iGrupId: mCourGroupIds.get(tCoFacil.FA_Course__c))
                      {  
                           if(mGroupmems.containsKey(string.valueOf(tCoFacil.FA_Facilitator__c) + iGrupId))
                                   {
                                     liColmembers.add(mGroupmems.get(string.valueOf(tCoFacil.FA_Facilitator__c) + iGrupId));
                                   }
                       }
                    }
                     if(!mMemGroupIds.isEmpty()&& mMemGroupIds.containskey(tCoFacil.FA_Course__c)) 
                      {   
                        for(string iGrpId: mMemGroupIds.get(tCoFacil.FA_Course__c))
                          {
                             if(mGroupmems.containsKey(string.valueOf(tCoFacil.FA_Facilitator__c) + iGrpId))
                                   {
                                     liColmembers.add(mGroupmems.get(string.valueOf(tCoFacil.FA_Facilitator__c) + iGrpId));
                                     
                           }
                      } 
                      
                }
           try{      
                   if(!liColmembers.isEmpty()) delete liColmembers;
                }
                
            catch(DMLException de) 
                  {
                    
                        string message= FA_ErrorLogHandler.errorMethod('CourseFacilitator','FA_Trigger_CourseFacilitator','After_DeleteFacilitatorsFromGroup','FATAL',de);
                        lidelFacilFroGrp[0].addError(message);
                  }
   } 
 }
 
  /**
      * Share access to course facilitators.
      * The method 'After_AccessToFacilitators' helps to share access
      * on course and related course occurence to course facilitators.
      * When course facilitator is created for the course, 
      * the below code is used to share access to facilitator, 
      * based on the course and related course occurences.
      * @param listAccFacilitators - list on the course facilitator object,
      * which will contain the course facilitator trigger.new records.
    */
   public static void After_AccessToFacilitators(FA_Course_Facilitator__c[] listAccFacilitators)
   {
      List<FA_Course_Occurence__Share> liCourOccShares  = new List<FA_Course_Occurence__Share>();
      List<FA_Course__Share> liCourShares  = new List<FA_Course__Share>();
      set<string> setCourIds = new set<string>();
      
         
      for(FA_Course_Facilitator__c tCofac : listAccFacilitators)
         {setCourIds.add(tCofac.FA_Course__c);}
         
/**
  * Set 'setCourIds' - to store the course ids when course facilitator is created.
  * Map 'mapcourse' contains the course ids and related course occurence ids
 */
      
      Map<ID,FA_Course__c> mapCourse= new Map<ID,FA_Course__c>([select id,
                                                                       (select id from FA_Course_Occurance__r)                                                                   
                                                                from FA_Course__c 
                                                                where id=:setCourIds]); 
         
     
     // code to share access on Course to course facilitators.
    
    
         for(FA_Course_Facilitator__c coFacil : listAccFacilitators)
            {
                 
                  
                  FA_Course__Share facilShare = new FA_Course__Share();
                  facilShare.ParentId = mapCourse.get(coFacil.FA_Course__c).id;
                  facilShare.UserOrGroupId = coFacil.FA_Facilitator__c;
                  facilShare.AccessLevel = 'Edit';
                  facilShare.RowCause = Schema.FA_Course__Share.RowCause.FA_Facilitator_Access__c;
                  liCourShares.add(facilShare);                
                 
     
   // code to share access on related Course occurences to course facilitators.
      
                 
              for(FA_Course_Occurence__c tCouOcc: mapCourse.get(coFacil.FA_Course__c).FA_Course_Occurance__r)
                  {
                      FA_Course_Occurence__Share facilOccShare = new FA_Course_Occurence__Share();
                      facilOccShare.ParentId = tCouOcc.id;
                      facilOccShare.UserOrGroupId = coFacil.FA_Facilitator__c;
                      facilOccShare.AccessLevel = 'Edit';
                      facilOccShare.RowCause = Schema.FA_Course_Occurence__Share.RowCause.FA_Facilitator_Access__c;
                      liCourOccShares.add(facilOccShare);
                  }
            
                  
            }
            
    /**
      * code to insert the licourShares and licourOccShares lists,
      * if the lists are not empty
      */        
   
    try{ 
           if (!liCourOccShares.isEmpty()) insert liCourOccShares; 
           if (!liCourShares.isEmpty())    insert liCourShares; 
       }
       
     catch(DMLException de) 
          {
            
                string message= FA_ErrorLogHandler.errorMethod('CourseFacilitator','FA_Trigger_CourseFacilitator','After_AccessToFacilitators','FATAL',de);
                listAccFacilitators[0].addError(message);
          }

       
    } 
    
  /**
  * Revoke access from Course Facilitators.
  * The Method 'After_RevokeAccessFromCoFacilitators' helps to revoke the access from CourseFacilitators
  * When facilitator is deleted from the course, 
  * then this code helps to revoke the access from facilitator for that course.
  * @param listRevokeFroFacil - list on the Course Facilitator object,
  * which will contain the Occurence Member trigger.old records.
  */
 
 
  public static void After_RevokeAccessFromCoFacilitators(FA_Course_Facilitator__c[] listRevokeFroFacil)   
   {          
       List<FA_Course_Occurence__Share> liRecordToDelete =new List<FA_Course_Occurence__Share>();
         List<FA_Course__Share> liCoRecordToDelete =new List<FA_Course__Share>();
         Map<ID,ID> mapMemberCourse =  new Map<ID,ID>();
         Map<string,ID> mapMemberCoOcc =  new Map<string,ID>();
         Map<String,ID> mapCouFacilIds = new Map<String,ID>();
         set<string> setCourIds = new set<string>();
         set<string> setFacilIds = new set<string>();
         set<string> setCouFacilIds = new set<string>();
         set<string> setCouOccurence = new set<string>();
          
          
            for(FA_Course_Facilitator__c courFacil: listRevokeFroFacil)
              {
               setCourIds.add(courFacil.FA_Course__c); 
               setFacilIds.add(courFacil.FA_Facilitator__c); 
               mapCouFacilIds.put(courFacil.FA_Facilitator__c,courFacil.FA_Course__c);
               setCouFacilIds.add(string.valueOf(courFacil.FA_Facilitator__c) + string.valueOf(courFacil.FA_Course__c));
               
              }
       
       // code to revoke the access from the facilitator for the course.    
              
             for(FA_Course__Share couShare : [select id,
                                                      ParentId,
                                                      UserOrGroupId,
                                                      RowCause 
                                                      from FA_Course__Share 
                                                      where ParentId in:mapCouFacilIds.values() 
                                                      and UserOrGroupId in :mapCouFacilIds.keySet()
                                                      and RowCause='FA_Facilitator_Access__c'])
                {
                   if(couShare.ParentId == mapCouFacilIds.get(couShare.UserOrGroupId))
                    {
                     liCoRecordToDelete.add(couShare);
                    }
                } 
                
        // code to revoke the access from the facilitator for the related course occurence.    
              
            for(FA_Course_Occurence__c tCoOcc : [select id 
                                                          from FA_Course_Occurence__c
                                                          where FA_Course__c=:setCourIds])
                                                          
                 {
                    setCouOccurence.add(tCoOcc.id);
                 }
                 
             for(FA_Course_Occurence__Share couOccShare : [select id,
                                                                   ParentId,
                                                                   UserOrGroupId,
                                                                   RowCause
                                                                   from FA_Course_Occurence__Share
                                                                   where ParentId =:setCouOccurence
                                                                   and UserOrGroupId=:setFacilIds
                                                                   and RowCause='FA_Facilitator_Access__c'])
                 {
                 
                       liRecordToDelete.add(couOccShare);
                 
                 }
              
       
                
        
                
          // code to delete the list - liRecordToDelete if the list is not empty
          
       try{
               if(!liRecordToDelete.isEmpty()) delete liRecordToDelete;
               if(!liCoRecordToDelete.isEmpty()) delete liCoRecordToDelete;
          }
          
       catch(DMLException de) 
              {
                
                    string message= FA_ErrorLogHandler.errorMethod('CourseFacilitator','FA_Trigger_CourseFacilitator','After_RevokeAccessFromCoFacilitators','FATAL',de);
                    listRevokeFroFacil[0].addError(message);
              }
          
 }



 }