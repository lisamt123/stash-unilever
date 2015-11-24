/**
   * This class is used to create chatter groups.
   * When new course occurence is created, 
   * the course chatter group and collaborationgroup will be created for that course occurence
   * And helps to update the participation status to cancelled for the occurence members 
     which are related to cancelled course occurences.
   * When Initiate feedback is True for the course occurence then this method
     will update the Send Feedback Invitation status to True for occurence members 
     which are related to that course occurence. 
   * When course occurence is created then it will share the access 
     for that course occurence record to existing course facilitators.
   */ 
   
   public class FA_Trigger_CourseOccurence {

/**
  * create chatter groups. 
  * The method 'After_ChatterGroupFeed' creates new collaboration group 
    and course chatter group,when new course occurence is created.
  *@ param listChaGrpFeed - list of course occurence object which contains
     the course occurence trigger.new records.
  */

   public static void After_ChatterGroupFeed(FA_Course_Occurence__c[] listChaGrpFeed)
   {
      List <FA_Course_Chattergroup__c> ChatterGroup = new List<FA_Course_Chattergroup__c>();
      List <CollaborationGroup> CollGroup = new List <CollaborationGroup>(); 
      Map<String,ID> mCoOccId = new Map<String,ID>();        
      Set<id> setCorChat =new set<id>(); 
                  
      for(FA_Course_Chattergroup__c co :[Select id,FA_Course_Occurence__c from FA_Course_Chattergroup__c])           
       {              
            setCorChat.add(co.FA_Course_Occurence__c);           
       }  
       
  /** 
    * Map mCoOccId is map between collaboration Group name and Course Occurence id.
    * Set setCorChat contains the course occurences which are existing in course chattergroup
    */
            
      for(FA_Course_Occurence__c CO : listChaGrpFeed)        
       {           
            if(! setCorChat.contains(CO.ID))            
              {             
                   CollaborationGroup cgroup = new CollaborationGroup();             
                   cgroup.name = CO.FA_Course_Occ_Name__c;                          
                   cgroup.CollaborationType  = 'Private';             
                   CollGroup.add(cgroup);                          
                   mCoOccId.put(cgroup.name,CO.id);            
              }        
       }               
   Insert CollGroup;          
   
    // code to create Course Chatter group when new course occurence is created.
    
     for(CollaborationGroup cGroup : CollGroup)        
       {              
           FA_Course_Chattergroup__c cChatter = new FA_Course_Chattergroup__c();              
           cChatter.FA_Group_ID__c = cGroup.id;              
           cChatter.FA_Chatter_Group_Name__c = cGroup.name;              
           cChatter.FA_Course_Occurence__c=mCoOccId.get(cGroup.name);              
           ChatterGroup.add(cChatter);                                     
       }  
    // insert the list of course chatter group if it is not empty.
   try{ 
         if(!ChatterGroup.isEmpty())  Insert ChatterGroup;
      }
      
   catch(DMLException de) 
          {
            
                  string message = FA_ErrorLogHandler.errorMethod('CouOcc/CollGroup','FA_Trigger_CourseOccurence','After_ChatterGroupFeed','FATAL',de);
                  listChaGrpFeed[0].addError(message);
          }


  }
  
  
  /**
     The method 'After_UpdateSendInvitataionMail' helps to update the 
     Send Invite checkbox to Truefor the occurence members
     which are related to send Invitation mail in the course occurences.
   * @param lstNewOcc - list on coures occurence object which contains trigger.new records
   * @param lstOldOcc - list on coures occurence object which contains trigger.old records
  
   */
  
  /* public static void After_UpdateSendInvitataionMail(List<FA_Course_Occurence__c> lstNewOcc,
                                              List<FA_Course_Occurence__c> lstOldOcc)
  
   {
    List<FA_Occurence_Member__c> liMembertoUpdate=new List<FA_Occurence_Member__c>();  
       set<id> setOccID = new set<id>();          

         //To fetch the occurance record whose Invitation mail  has been initiated    

       for(Integer iCount=0;iCount<lstOldOcc.size();iCount++ )           
        {                    
          If(lstNewOcc[iCount].FA_Send_Invite_Mail__c!= lstOldOcc[iCount].FA_Initiate_Feedback__c 
              && lstNewOcc[iCount].FA_Send_Invite_Mail__c== TRUE)                      
            {           
                       setOccID.add(lstNewOcc[iCount].id);      
            }  
        }                           
  
  List<FA_Occurence_Member__c> OccMems =  [ select Id,
                                                           FA_Send_Invite_Mail__c
                                                    from FA_Occurence_Member__c                                                                              
                                                    where FA_Course_Occurence__c =:setOccID];
  
        //To fetch the Occurance Member record
      
        For(FA_Occurence_Member__c tempOccMem : OccMems)        

                        {       
                               For(FA_Occurence_Member__c objOccMem: OccMems)     
                                  {                       
                                      objOccMem.FA_Send_Invite_Mail__c= TRUE;      
                                      liMembertoUpdate.add(objOccMem);         
                                  }             
                        }
          try
                {
                    if(!liMembertoUpdate.isEmpty()) update liMembertoUpdate;     
                }
              catch(DMLException de) 
                {
            
                  string message = FA_ErrorLogHandler.errorMethod('CouOcc/CollGroup','FA_Trigger_CourseOccurence','After_CancelPartcipation','FATAL',de);
                  lstNewOcc[0].addError(message);                  
                }
   
   } */
  
  
  
  
 /** 
   * The method 'After_CancelPartcipation' helps to update the 
     participation status to cancelled for the occurence members
     which are related to cancelled course occurences.
   * @param lstNewOcc - list on coures occurence object which contains trigger.new records
   * @param lstOldOcc - list on coures occurence object which contains trigger.old records
   */
  
  public static void After_CancelPartcipation(List<FA_Course_Occurence__c> lstNewOcc,
                                              List<FA_Course_Occurence__c> lstOldOcc)
   {
      
      List<FA_Occurence_Member__c> liMembertoUpdate=new List<FA_Occurence_Member__c>();
   
    set<id> setOccID = new set<id>();  
      
           //To fetch the occurence record whose status has been changed to Cancelled
           for(Integer iCount=0;iCount<lstNewOcc.size();iCount++ )
             {    
                  If(lstNewOcc[iCount].FA_Status__c!= lstOldOcc[iCount].FA_Status__c 
                     && lstNewOcc[iCount].FA_Status__c == 'Cancelled')
                       {       
                           setOccID.add(lstNewOcc[iCount].id);
                       }
              } 
              
              //To fetch the Occurance Member record   
           For(FA_Occurence_Member__c[] tempOccMem : [ select Id,
                                                              FA_Participation_Status__c 
                                                       from FA_Occurence_Member__c      
                                                       where FA_Course_Occurence__c =:setOccID])
            
                 
                  { 
                     For(FA_Occurence_Member__c objOccMem: tempOccMem)
                        {
                         objOccMem.FA_Participation_Status__c='Cancelled';
                         liMembertoUpdate.add(objOccMem);
                        }
                  } 
          
             
             try
                {
                    if(!liMembertoUpdate.isEmpty()) update liMembertoUpdate;     
                }
              catch(DMLException de) 
                {
            
                  string message = FA_ErrorLogHandler.errorMethod('CouOcc/CollGroup','FA_Trigger_CourseOccurence','After_CancelPartcipation','FATAL',de);
                  lstNewOcc[0].addError(message);                  
                }
                                       
   }
/**
  * The method 'After_Initiatefeedback' helps to update the 
    Send Feedback Invitation status to True for occurence members 
  * When Initiate feedback is True for the course occurence then this method
    will update the Send Feedback Invitation status to True for occurence members 
    which are related to that course occurence. 
  * @param lstNewOcc - list on coures occurence object which contains trigger.new records
  * @param lstOldOcc - list on coures occurence object which contains trigger.old records
  */
   
   
   public static void After_Initiatefeedback(List<FA_Course_Occurence__c> lstNewOcc,List<FA_Course_Occurence__c> lstOldOcc)  
   {     
       List<FA_Occurence_Member__c> liMembertoUpdate=new List<FA_Occurence_Member__c>();  
       set<id> setOccID = new set<id>();          

         //To fetch the occurance record whose Feedback has been initiated    

       for(Integer iCount=0;iCount<lstOldOcc.size();iCount++ )           
        {                    
          If(lstNewOcc[iCount].FA_Initiate_Feedback__c!= lstOldOcc[iCount].FA_Initiate_Feedback__c 
              && lstNewOcc[iCount].FA_Initiate_Feedback__c == TRUE)                      
            {           
                       setOccID.add(lstNewOcc[iCount].id);      
            }  
        }                           
  
  
  
        //To fetch the Occurance Member record
      
        For(FA_Occurence_Member__c[] tempOccMem : [ select Id,
                                                           FA_Send_Feedback_Invitation__c  
                                                    from FA_Occurence_Member__c                                                                              
                                                    where FA_Course_Occurence__c =:setOccID])        

                        {       
                               For(FA_Occurence_Member__c objOccMem: tempOccMem)     
                                  {                       
                                      objOccMem.FA_Send_Feedback_Invitation__c= TRUE;      
                                      liMembertoUpdate.add(objOccMem);         
                                  }             
                        }            
                              
    try
    {                          
         if(!liMembertoUpdate.isEmpty())  update liMembertoUpdate; 
    }
    
   catch(DMLException de) 
          {
            
                  string message = FA_ErrorLogHandler.errorMethod('CouOcc/CollGroup','FA_Trigger_CourseOccurence','After_Initiatefeedback','FATAL',de);
                  lstNewOcc[0].addError(message);
                
          }    
}
/**
  * The method 'After_AccessToFacilitators' helps to share access to 
    course facilitators 
  * When course occurence is created then this method will share the access 
    for that course occurence record to existing course facilitators.
  * @param liAccToFacilitators - list on course occurence object, 
    which contains the course occurence trigger.new records
  */

 public static void After_AccessToFacilitators(FA_Course_Occurence__c[] liAccToFacilitators)
 {
   List<FA_Course_Occurence__Share> liCourOccShares  = new List<FA_Course_Occurence__Share>();
   List<FA_Course__Share> liCourShares  = new List<FA_Course__Share>();
   set<string> setCourIds = new set<string>();
   Map<ID,ID> mcouOccIds = new Map<ID,ID>();
   
       for(FA_Course_Occurence__c  tcoFacil: liAccToFacilitators)
           {
             mcouOccIds.put(tcoFacil.id,tcoFacil.FA_Course__c);
           }
   
           List<ID> facilId= new List<id>();
           Map<ID,List<ID>> mCoFacilIds= new Map<ID,List<ID>>();
           
            for(FA_Course_Facilitator__c tCourFacil : [select id,
                                                                 FA_Course__c,
                                                                 FA_Facilitator__c,
                                                                 FA_Role__c 
                                                                 from FA_Course_Facilitator__c
                                                                 where FA_Course__c in:mcouOccIds.values()])
                  
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
               
              for(FA_Course_Occurence__c  tCouFacil: liAccToFacilitators)
               {
                if(!mCoFacilIds.isEmpty() && mCoFacilIds.containsKey(mcouOccIds.get(tCouFacil.id)))
                 {
                 for(Id iFacilId:mCoFacilIds.get(mcouOccIds.get(tCouFacil.id)))
                   {
                      FA_Course_Occurence__Share facilOccShare = new FA_Course_Occurence__Share();
                      facilOccShare.ParentId = tCouFacil.id;
                      facilOccShare.UserOrGroupId = iFacilId;
                      facilOccShare.AccessLevel = 'Edit';
                      facilOccShare.RowCause = Schema.FA_Course_Occurence__Share.RowCause.FA_Facilitator_Access__c;
                      liCourOccShares.add(facilOccShare);
                   }
                 }
               }
               
               try
                {
                  if (!liCourOccShares.isEmpty()) insert liCourOccShares;  
                }
                
                catch(DMLException de)
                  {
                    string message = FA_ErrorLogHandler.errorMethod('CouOcc/CouFacil','FA_Trigger_CourseOccurence','After_AccessToFacilitators','FATAL',de);
                    liAccToFacilitators[0].addError(message);
                  }
                    
 
 }
}