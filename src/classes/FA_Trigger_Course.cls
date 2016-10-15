/** 
  * This class is used to add course owner as course facilitator.
  * When new course is created,  
  * the owner of the course will be added as a course facilitator.
  */  
public class FA_Trigger_Course { 

/**
  * The  method 'After_AddingOwnerAsFacilitator' helps to add 
  * course owner as Course Facilitator.
  * When new course is created,  
  * the owner of the course will be added as a course facilitator.
  * @param listCouFacilitator - is the list which contains 
  * Course object trigger.new records.
  */
  
  public static void After_AddingOwnerAsFacilitator(FA_Course__c[] listCouFacilitator)   
   {
   
                List<FA_Course_Facilitator__c> liCouAdminFacilitator = new List<FA_Course_Facilitator__c>();
                Map<string,string> mUserProfile = new Map<string,string>(); 
                Set<string> setProfiles = new Set<string>();
  /*
   * Map 'mUserProfile' is used to fetch the profile name from the User entity.
   */
              for(FA_Course__c course : listCouFacilitator)        
               {
               
                 setProfiles.add(course.OwnerId);
                 
               }

  
              for(User userprofname :  [Select id,
                                                 profile.name
                                                 from User where id =:setProfiles])           
                   {              
                        mUserProfile.put(string.valueOf(userprofname.id),string.valueOf(userprofname.profile.name).substringAfter('-'));
                        
                   }     
                  
   /** 
     * code to add the course owner as course facilitator.
     */
      
              for(FA_Course__c course : listCouFacilitator)        
               {           
                        if(mUserProfile.containsKey(string.valueOf(course.OwnerId)))   
                        {      
                           FA_Course_Facilitator__c couFacilitator = new FA_Course_Facilitator__c();             
                           couFacilitator.FA_Course__c = course.id; 
                           couFacilitator.FA_Facilitator__c = course.OwnerId;                        
                           couFacilitator.FA_Role__c  = mUserProfile.get(string.valueOf(course.OwnerId));             
                           liCouAdminFacilitator.add(couFacilitator);                          
                         }           
                              
               }
   /**
     * code to insert the list 'licouAdminFacilitator' if the list is not empty.
     */   try
           {            
                if (!liCouAdminFacilitator.isEmpty())  Insert liCouAdminFacilitator;  
           } 
           
        catch(DMLException de) 
          {
            
                  string message= FA_ErrorLogHandler.errorMethod('Course','FA_Trigger_Course','After_AddingOwnerAsFacilitator','FATAL',de);
                  listCouFacilitator[0].addError(message);


         }
  
  
      }
   }