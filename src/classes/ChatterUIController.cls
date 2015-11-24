/*
Copyright (c) 2011, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

*/
/**
 * Controller for the custom Chatter app
 */
public with sharing class ChatterUIController {
    public Datetime dt{get;set;}
    public FA_FBQuestionSet__c qs { get; set; }    
    public PageReference init() {
        // If nav element is not configured, redirect user to config page.
        if (NavigationElement__c.getAll().isEmpty()) {
            return Page.ChatterConfig;
        }
        
        return null;
    }
    
    /**
     * Returns whether the user is accessing the app on iOS or Android through Phonegap
     */
    public Boolean getUsingMobile() {
        return ControllerUtil.isUsingIosPhonegap() || ControllerUtil.isUsingAndroidPhonegap();
    }
     public String getUserObjectPrefix() {
        return Schema.SObjectType.User.getKeyPrefix();
    }

    /**
     * Returns the three letter object prefix for the object, for which Chatter feeds need to be retrieved.
     */
    public String getFeedObjectPrefix() {
        return Schema.SObjectType.Account.getKeyPrefix();
        String feedObjApiName = CustomChatterConfig.getFeedObjectApiName();
        
        Schema.SObjectType feedObjType = null;
        if (feedObjApiName != null) {
            feedObjType = Schema.getGlobalDescribe().get(feedObjApiName);
        }
        if (feedObjType == null) {
            return Schema.SObjectType.Account.getKeyPrefix();
        }
        else {
            return feedObjType.getDescribe().getKeyPrefix();
        }
    }

    //// PEOPLE

    /**
     * Returns the three letter object prefix for the User object, used to retrieve Following / Follower User feed items only
     */
    
   

    /**
     * Updates the specified User fields for the current User
     * @param updatedFields - Stringified JSON with key value pairs representing the fields and values to update.
     *      Valid fields for update are Title, Phone, MobilePhone, CompanyName, and AboutMe
     * @return String representing a JSON status object, where the status property will be "success" or "error"
     */
    @RemoteAction
    public static String updateUserInfo(String updatedFields) {
        return ChatterUIPeopleService.updateUserInfo(UserInfo.getUserId(), updatedFields);
    }

    //// GROUPS

    /**
     * Remove a user from a group. This method should be used instead of
     * ChatterUI.Service.leaveGroup only when you do not have the membership Id.
     * @param groupId - the Id of the group to remove the user from
     * @param userId - the Id of the user to remove
     * @return a String containing any errors that occured
     */
    @RemoteAction
    public static String removeUserFromGroup(String groupId, String userId) {

        try {
            ChatterUIGroupService.removeUserFromGroup(groupId, userId);
        } catch(DMLException de) {
            return getStringifiedError(de);
        }

        return '{}';
    }

    /**
     * Create a group
     * @param name - the name of the group
     * @param description - the description of the group
     * @param userId - the user creating the group
     * @param isPublic - Boolean for public groups
     * @return String - the created group
     */
    @RemoteAction
    public static String createGroup(String name, String description, String userId, Boolean isPublic) {
        CollaborationGroup collabGroup;

        try {
            collabGroup = ChatterUIGroupService.createGroup(name, description, userId, isPublic);
        } catch(DMLException de) {
            return getStringifiedError(de);
        }

        return JSON.serialize(collabGroup);
    }

    /**
     * Edit a group
     * @param groupId - the Id of the group to edit
     * @param name - the name of the group
     * @param description - the description of the group
     * @param isPublic - indicate if this is a public group
     * @return String - the updated group
     */
    @RemoteAction
    public static String editGroup(String groupId, String name, String description, Boolean isPublic) {
        CollaborationGroup collabGroup;

        try {
            collabGroup = ChatterUIGroupService.editGroup(groupId, name, description, isPublic);
        } catch(DMLException de) {
            return getStringifiedError(de);
        }

        return JSON.serialize(collabGroup);
    }

    /**
     * Searches for groups whose name contains searchText. Search Text must
     * contain at least 2 characters for results to be returned.
     * @param searchText - the name of the group to search for
     * @param pageNumber - The page number to return.
     * @return String - the page of group results that match targetName
     */
    @RemoteAction
    public static ChatterUIGroupService.GroupPage searchGroupsByName(String searchText) {
        return ChatterUIGroupService.searchGroupsByName(searchText, 1);
    }

    /**
     * get all groups for which a user is a member
     * @param memberId - id of the user
     * @param pageNumber - The page number to return.
     * @return GroupPage object - the page of group results that match targetName
     */
    @RemoteAction
    public static ChatterUIGroupService.GroupPage getGroupsForUser(String memberId) {
        return ChatterUIGroupService.getGroupsForUser(memberId);
    }

    /**
     * Searches for users whose name contains searchText. Search Text must
     * contain at least 2 characters for results to be returned.
     * @param searchText - the name of the user to search for
     * @return GroupPage object - JSON object of user results that match searchText
     */
    @RemoteAction
    public static List<User> searchUsersByName(String searchText) {
        return ChatterUIPeopleService.searchUsersByName(searchText);
    }

    /**
     * Get pending join requests
     * @param groupId - the Id of the group to retrieve pending requests for
     * @return  List<ChatterUIGroupService.GroupRequest> - the list of pending group requests
     */
    @RemoteAction
    public static List<ChatterUIGroupService.GroupRequest> getPendingGroupRequests(String groupId) {
        return ChatterUIGroupService.getPendingGroupRequests(groupId);
    }

    /**
     * Request to join a private group
     * @param groupId - id of the group
     * @return String - String representing the CollaborationGroupMemberRequest
     */
    @RemoteAction
    public static String requestToJoinPrivateGroup(String groupId) {
        CollaborationGroupMemberRequest groupRequest;
        try {
            groupRequest = ChatterUIGroupService.createGroupMemberRequest(groupId, UserInfo.getUserId());
        } catch(DMLException de) {
            return getStringifiedError(de);
        }
        return JSON.serialize(groupRequest);
    }

    /**
     * Approve a request to join a group
     * @param requestId - the GroupMemberRequest Id to approve
     * @return String - String representing the GroupMemberRequest
     */
    @RemoteAction
    public static String approveGroupMemberRequest(String requestId) {
        CollaborationGroupMemberRequest groupRequest;
        try {
            groupRequest = ChatterUIGroupService.approveGroupMemberRequest(requestId);
        } catch(DMLException de) {
            return getStringifiedError(de);
        }
        return JSON.serialize(groupRequest);
    }

    /**
     * Deny a request to join a group
     * @param requestId - the GroupMemberRequest Id to deny
     * @throws DMLException
     * @return String - String representing the GroupMemberRequest
     */
    @RemoteAction
    public static String denyGroupMemberRequest(String requestId) {
        CollaborationGroupMemberRequest groupRequest;
        try {
            groupRequest = ChatterUIGroupService.denyGroupMemberRequest(requestId);
        } catch(DMLException de) {
            return getStringifiedError(de);
        }
        return JSON.serialize(groupRequest);
    }

    //// FILE UPLOAD

    /**
     * Upload file using the specified blob value
     * @param base64BlobValue - String of the encoded base 64 string with the file contents
     * @return Map containing the results of the upload with the following keys: fileId, status, message
     */
    @RemoteAction
    public static Map<String, String> uploadAttachment(String base64BlobValue) {
        return ChatterUIFileUpload.uploadAttachment(base64BlobValue, null);
    }

    //// UTILITIES


    /**
     * @param Exception
     * @return String representing a JSON status error object, where the status property will "error"
     *      and statusDesc will contain the error message
     */
    public static String getStringifiedError(Exception e) {
        return getStringifiedStatus('error', e.getMessage());
    }

    /**
     * @param status - "success" or "error"
     * @param statusDesc - the description of the error message if any
     * @return String representing a JSON status object
     */
    public static String getStringifiedStatus(String status, String statusDesc) {
        Map<String, String> result = new Map<String, String> {
            'status' => status,
            'statusDesc' => statusDesc
        };
        return JSON.serialize(result);
    }


    
    
    //Start of the Code added for Chatter Pages cutomization
       
      Map<String,FA_Config_Settings__c> ConfigSetting=FA_Config_Settings__c.getAll();
      
      Public ID getAllFourAcreGroupID()
          {            
            return ConfigSetting.get('FA_AllFourAcres').FA_Value__c;
          }
      Public ID getFourAcreHelpGroupID()
        {      
            return ConfigSetting.get('FA_HelpGroup').FA_Value__c;
        }
      
    
          
    /*End of the code added for Chatter Page Customization
    ********************************************************************************************************/
    
    /*
       Start of the Code added for Preference Page Logic
       This page will help the participant to view and Update the Preferences for the Respective Registered 
       Courses for the User.
    */
       //variable Declaration 
       
       public List<string> checkOptions { get; set; }         
       public ID selectedCourseOccID {get; set;}
       public wrapPreferences wrapObj {get; set;}
      
        
        //wrapper class for Preference page
        public class wrapPreferences{
            
            public string dateArrival{get;set;}            
            public string dateDepart{get;set;}             
            public string timeArrival{get;set;}            
            public string timeDepart{get;set;} 
            
            public String arrivalTimeHrs {get; set;}
            public String departureTimeHrs {get; set;}                    
            public String arrivalTimeMins {get; set;}
            public String departureTimeMins {get; set;}              
            public String arrivalTimeAMPM {get; set;}
            public String departureTimeAMPM {get; set;} 
                                      
            public FA_Occurence_Member__c tempOcc {get; set;}
            public FA_UserPreference__c tempUserPref {get; set;}
           // public User tempUser {get; set;}           
            
         }
         
       /*
          This Method returns the list of Arrival Information 
          Picklist value by making a Describe Call
          
       */
       
       public List<SelectOption> getCheckInItems()
        {
          // System.debug('----->>>>'+wrapObj.dateArrival);          
          List<SelectOption> options = new List<SelectOption>();
                
           Schema.DescribeFieldResult fieldResult =FA_Occurence_Member__c.FA_Arrival_Information__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry f : ple)
           {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
           return options;
        }
        /*
          This Method returns the list of Departure Information 
          Picklist value by making a Describe Call
          
       */
       
       public List<SelectOption> getCheckOutItems()
        {
          List<SelectOption> options = new List<SelectOption>();
                
           Schema.DescribeFieldResult fieldResult =FA_Occurence_Member__c.FA_Departure_Information__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry f : ple)
           {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
           return options;
        }
        
        /*
          This Method returns the list of Dietary Preferences Information 
          Picklist value by making a Describe Call
          
       */
       
       public List<SelectOption> getDietItems()
        {
          List<SelectOption> options = new List<SelectOption>();
                
           Schema.DescribeFieldResult fieldResult =FA_UserPreference__c.FA_DietaryPreference__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry f : ple)
           {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
           return options;
        }
        /*
          This Action Method returns Course details selected by the USer
          and initialze the FA_PrefDetail page.         
          
       */
          
       public PageReference initPref() {
        
            selectedCourseOccID=ApexPages.currentPage().getParameters().get('id'); 
            wrapObj  = new  wrapPreferences();
           
            FetchPrefDetail(wrapObj);
        
            return null;
          }
          
       public List<SelectOption>  getCoursesForPref(){
        
       List<SelectOption>  listOfCourseOptions = new List<SelectOption>();
     
       FA_Course_Occurence__c[] listOfCOcc = [Select Id,
                                                     FA_Course_Occ_Name__c,
                                                     FA_Start_Date_Time__c,
                                                     FA_End_Date_Time__c
                                                     from FA_Course_Occurence__c                                                     
                                                     where FA_End_Date_Time__c >=:Date.Today()];
        
                                                     
        FA_Occurence_Member__c[] listOfOccMem =  [Select Id,
                                                         FA_Course_Occurence__r.FA_Course_Occ_Name__c,
                                                         FA_Course_Occurence__c 
                                                  from FA_Occurence_Member__c 
                                                  where FA_Participant_Instructor__r.Id=:UserInfo.getUserId() 
                                                  and FA_Course_Occurence__c in :listOfCOcc 
                                                  ];     
        
        
        for(FA_Occurence_Member__c ocMem:listOfOccMem){      
                 listOfCourseOptions.add(new SelectOption(ocMem.FA_Course_Occurence__c,ocMem.FA_Course_Occurence__r.FA_Course_Occ_Name__c));
                 } 
            
       return listOfCourseOptions;     
      }
      
       /*
          This private method is the crux of the functionality to get all the data related
          to the joined objects and assign it to the wrapper class.    
          
       */
       public FA_Course_Occurence__c selectedCourseOccurence {get; set;}
       public  void FetchPrefDetail(wrapPreferences tWrapPref){
         checkOptions =new List<string>();
         
               Integer OffsetarrivalBeforeUpdate; 
               Integer OffsetdepartureBeforeUpdate;            
                        
                     List<FA_Occurence_Member__c> listOccMemForPref=[Select   Id,
                                                                              FA_Course_Occurence__c, 
                                                                              FA_Course_Occurence__r.FA_Course__r.Name,                                                                    
                                                                              FA_Arrival_Information__c,
                                                                              FA_Departure_Information__c,                                                                              
                                                                              FA_Departure_Date_Time__c,                                                                              
                                                                              FA_Other_Accomodation_Needs__c,
                                                                              FA_Other_Travel_Arrangements__c,
                                                                              FA_New_Arrival_Date_Time__c,
                                                                              FA_New_Arrival_Time__c,
                                                                              FA_New_Depart_Date_Time__c,
                                                                              FA_New_Depart_Time__c           
                                                                      from FA_Occurence_Member__c 
                                                                      where FA_Participant_Instructor__r.Id=:UserInfo.getUserId()
                                                                      and FA_Course_Occurence__c=:selectedCourseOccID];
                                                                                                                 
                      selectedCourseOccurence = [select Name,FA_Course_Occ_Name__c from FA_Course_Occurence__c where id=:selectedCourseOccID];
                      
             //To display existing arrival date and time in logistics page 
               
              if(listOccMemForPref[0].FA_New_Arrival_Date_Time__c!=null){
                    tWrapPref.dateArrival=String.ValueOf(listOccMemForPref[0].FA_New_Arrival_Date_Time__c);
               }
                
                
                if(listOccMemForPref[0].FA_New_Arrival_Time__c!=null){
                    tWrapPref.arrivalTimeHrs =String.ValueOf(listOccMemForPref[0].FA_New_Arrival_Time__c).substringBefore(':');
                 }
              
              if(listOccMemForPref[0].FA_New_Arrival_Time__c!=null){
                    tWrapPref.arrivalTimeMins=String.ValueOf(listOccMemForPref[0].FA_New_Arrival_Time__c).substringAfter(':').substringBefore(' ');
                    tWrapPref.arrivalTimeAMPM = String.ValueOf(listOccMemForPref[0].FA_New_Arrival_Time__c).substringAfter(' ');
                 }
                 
             //To display existing departure date and time in logistics page
               
              if(listOccMemForPref[0].FA_New_Depart_Date_Time__c!=null){
                    tWrapPref.dateDepart=String.ValueOf(listOccMemForPref[0].FA_New_Depart_Date_Time__c);
               }
                
                
              if(listOccMemForPref[0].FA_New_Depart_Time__c!=null){
                    tWrapPref.departureTimeHrs =String.ValueOf(listOccMemForPref[0].FA_New_Depart_Time__c).substringBefore(':');
                    tWrapPref.departureTimeMins =String.ValueOf(listOccMemForPref[0].FA_New_Depart_Time__c).substringAfter(':').substringBefore(' ');
                    tWrapPref.departureTimeAMPM = String.ValueOf(listOccMemForPref[0].FA_New_Depart_Time__c).substringAfter(' ');
                 }
              
             
                 
                  if(!listOccMemForPref.isEmpty())
                         {                  
                      List<FA_UserPreference__c> listUserPref=[Select Id,
                                                                      FA_DietaryPreference__c,
                                                                      FA_Other_dietary_requirements__c,
                                                                      FA_User__c,
                                                                      FA_Secretary_Name__c,
                                                                      FA_Secretary_PhoneNumber__c,
                                                                      FA_Company_code__c,
                                                                      FA_Cost_Centre_nr__c,                                                                      
                                                                      FA_Personal__c,
                                                                      FA_Prior_Career__c,
                                                                      FA_Role__c,
                                                                      FA_Unilever_Career__c,
                                                                      FA_Education__c,
                                                                      FA_Arrival_Flight_Number__c,
                                                                      FA_Departure_Flight_Number__c,
                                                                      FA_Arrival_Terminal__c,
                                                                      FA_Departure_Terminal__c,
                                                                      FA_Arrival_Carrier__c,
                                                                      FA_Departure_Carrier__c,
                                                                      FA_Occurence_Member__c,
                                                                      FA_Terms__c
                                                              from FA_UserPreference__c
                                                              where FA_User__c=:UserInfo.getUserId()
                                                              and FA_Occurence_Member__c=:listOccMemForPref[0].ID];
                
                          
                      if(listUserPref.isEmpty())
                         {
                              FA_UserPreference__c userPrefNew=new FA_UserPreference__c();
                                  userPrefNew.FA_User__c=UserInfo.getUserId();                      
                                  userPrefNew.FA_Occurence_Member__c=listOccMemForPref[0].ID;
                           
                             
                              tWrapPref.tempUserPref= userPrefNew;
                              //initializing the Dietary Preferences Option
                              checkOptions =new List<string>();
                          
                         }
                      else
                        { 
                            tWrapPref.tempUserPref= listUserPref[0];
                            //initializing the Dietary Preferences Option
                            if(listUserPref[0].FA_DietaryPreference__c!=NULL)
                              checkOptions =listUserPref[0].FA_DietaryPreference__c.split(';');
                            else
                              checkOptions=new List<string>(); 

                             
                        }
                             tWrapPref.tempOcc=listOccMemForPref[0];
                             
           }              
       }  
       
       /*
         This action function will help to update the Preferences details
         against the User seleceted Course.which include update to associated
         occurance Member record and User Preference record respectively.
      */
      
      
      public List<SelectOption> gethourTimeValues() {
      
      List<SelectOption> options = new List<SelectOption>();
     
      for (Integer i =0; i <13 ; i++) {
      
      string temp;
      
       if(i<10)
            temp='0' + String.valueOf(i);
            
       else
          temp=String.valueOf(i);
      
      options.add(new SelectOption(temp,temp));
      }

     return options;
      }
      
       public List<SelectOption> getminuteTimeValues() {
      List<SelectOption> options = new List<SelectOption>();
      
      for (Integer j = 0; j <60 ; j+=5) {
      
      string mins;
      
       if(j<10)
            mins='0' + String.valueOf(j);
            
       else
          mins=String.valueOf(j);
          
      options.add(new SelectOption(mins,mins));
      
      }      
      return options;
      }
     
      public PageReference updatePrefDetail() {
              
            
              String strDietPref='';   
                      
              for(String selOption: checkOptions)
                   {
                    strDietPref=strDietPref + selOption + ';';                   
                   }
                   
              //Assigning Dietary preferences value to the SObject    
             wrapObj.tempUserPref.FA_DietaryPreference__c=strDietPref; 
                   
               //date conversion from string to date 
                  
                 if(wrapObj.dateArrival!=Null && wrapObj.dateArrival.length()>1){
                 system.debug('test000444' + wrapObj.dateArrival);
                 wrapObj.tempOcc.FA_New_Arrival_Date_Time__c=wrapObj.dateArrival;
                 system.debug('test111' + wrapObj.tempOcc.FA_New_Arrival_Date_Time__c );
                 }  
                
               
                            
                 if(wrapObj.dateDepart!=Null && wrapObj.dateDepart.length()>1) {
                 system.debug('test000999' + wrapObj.dateDepart);
                 wrapObj.tempOcc.FA_New_Depart_Date_Time__c=wrapObj.dateDepart;
                 }    
                      
         
              if(wrapObj.dateArrival!=Null) 
              {
               if(wrapObj.dateArrival.length()>1 && wrapObj.arrivalTimeHrs!='Hrs' && wrapObj.arrivalTimeMins!='Minutes'){
                       
                       String myTimeArrival = string.ValueOf(wrapObj.arrivalTimeHrs)+':'+string.ValueOf(wrapObj.arrivalTimeMins)+' '+string.ValueOf(wrapObj.arrivalTimeAMPM);
                       wrapObj.tempOcc.FA_New_Arrival_Time__c=string.Valueof(myTimeArrival); 
                       
               }
          }
              if(wrapObj.dateDepart!=Null)
              {   
              if(wrapObj.dateDepart.length()>1 && wrapObj.departureTimeHrs!='Hrs' && wrapObj.departureTimeMins!='Minutes'){  
                             
                       String myTimeDeparture = string.ValueOf(wrapObj.departureTimeHrs)+':'+string.ValueOf(wrapObj.departureTimeMins)+' '+string.ValueOf(wrapObj.departureTimeAMPM);
                       wrapObj.tempOcc.FA_New_Depart_Time__c=string.Valueof(myTimeDeparture);
                  
               }
              } 
               
       
               
        if (wrapObj.tempUserPref.FA_Company_code__c == null)
        {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Select the Charge back information tab and enter a value for Company code!');
        ApexPages.addMessage(msg);
        
        }
        
        else if (wrapObj.tempUserPref.FA_Cost_Centre_nr__c == null)
        {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Select the Charge back information tab and enter a value for Cost centre nr!');
        ApexPages.addMessage(msg);
        
        }
               
        else if (wrapObj.tempUserPref.FA_terms__c == false)
             {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please accept the Terms by clicking the checkbox and submit the details!');
                    ApexPages.addMessage(msg);
             } 
        else if(wrapObj.dateDepart!=Null && wrapObj.dateDepart.length()>1 && (wrapObj.departureTimeHrs=='Hrs'|| wrapObj.departureTimeMins=='Minutes')){
                       
                     
                             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the departure time in Hrs, Mins and AM/PM');
                             ApexPages.addMessage(msg);
                        
                       }  
                     
        else if(wrapObj.dateArrival!=Null && wrapObj.dateArrival.length()>1 && (wrapObj.arrivalTimeHrs=='Hrs' || wrapObj.arrivalTimeMins=='Minutes')){
                      
                             
                                 ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the arrival time in Hrs, Mins and AM/PM');
                                 ApexPages.addMessage(msg);
                              }        
                         
                   
      
        else    {
                       
                      upsert wrapObj.tempOcc;
                      upsert wrapObj.tempUserPref;                      
                      ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Your details have been submitted Successfully. Thank you.!');
                      ApexPages.addMessage(msg); 
                       
                       
                     
               }
             return null;  
        } 
        
        public PageReference detailsOk() {
              
                      PageReference pref = new PageReference('/apex/Programme');    
                      pref.setRedirect(false); 
                      return pref;              
              }
              
       /*
         This action function will help this User to retun to the Course seletion page
         for Preferences
      */ 
       public PageReference backPref() {
                 return new PageReference('/apex/Programme');
               } 
         
    /* End of the code for the Pref Detail Page
    ****************************************************************************************************/
    
    /*
       Start of the Code added for Course Detail visualforce Page
       This page will show full detail about a Particular Programme.
    */
      
       public Class PrgrammeDetail
         {
           public FA_Course_Occurence__c CoOcc{get;set;}
           public List<Attachment> CoPreAttachment{get;set;}
           public List<Attachment> CoPostAttachment{get;set;}
           public List<Attachment> CoMaterialAttachment{get;set;} 
           public List<Note> CoPreNotes{get; set;}
           public List<Note> CoPostNotes{get; set;}
           public List<Note> CoMaterialNotes{get; set;}
           public DateTime startDate{get;set;}
           public DateTime endDate{get;set;}      
         }        
         
       Public PrgrammeDetail objProDetail{get;set;}
       Public String ProgramId{get; set;}
       Public Attachment attach {get; set;}        
          
       /*public PageReference getcallMethodtoAttachMime()
       {
       String para=Apexpages.currentPage().getParameters().get('down');
       PageReference downloadPage=new PageReference('/servlet/servlet.FileDownload?file=' +para);
       downloadPage.getHeaders().put('content-disposition', 'attachment; filename=mypdf.pdf');
       return downloadPage;
       
       //Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=mypdf.pdf');
       //return null;
       }   
        */
          
       public PageReference showCourseDetail()
        {  
           //Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=mypdf.pdf');
                                      
           objProDetail=new PrgrammeDetail();
           ProgramId='';
           ProgramId=ApexPages.currentPage().getParameters().get('id');
           
           if(ProgramId!=null)
              {
                List<Attachment> prenotes=new List<Attachment>();
                List<Attachment> postnotes=new List<Attachment>();
                List<Attachment> coMaterialnotes=new List<Attachment>();
                List<Note> prenotesOnly=new List<Note>();
                List<Note> postnotesOnly=new List<Note>();
                List<Note> comaterialnotesOnly=new List<Note>();
                
                FA_Course_Occurence__c co=[select  Id,
                            FA_Training_Room__c,
                            FA_Training_Room__r.FA_Image_URL__c,
                            FA_Training_Room__r.FA_Room_Number__c,
                            FA_Training_Room__r.FA_Capacity__c,
                            FA_Training_Room__r.FA_Network_Connectivity__c,
                            FA_Training_Room__r.FA_VC_Facilities__c,
                            FA_Training_Venue__r.FA_Image_URL__c,
                            FA_Course__c,
                            FA_Start_Date_Time__c,
                            FA_End_Date_Time__c,
                            FA_Training_Venue__r.Name,
                            FA_Training_Room__r.Name,
                            FA_Course__r.Name,
                            FA_Course__r.FA_Course_Logo__c,
                            FA_Course__r.FA_Course_Overview__c 
                            from FA_Course_Occurence__c where Id=:ProgramId];
                
                    if(co==null)
                        co=new FA_Course_Occurence__c();
                
                string courseId=co.FA_Course__c;              
               
                //Below lines of code for deleting the Attachments added on the Course Level after conversion of Notes to Attachments              
                datetime myDate = datetime.now();
                
                FA_Course__c coForDeletingAttachments=[select c.Id, (Select Id,Name,BodyLength,CreatedDate from Attachments where CreatedDate < :datetime.now()) from FA_Course__c  c where c.Id=:courseId];                
                
                List<Attachment> deleteAttaches=new List<Attachment>();         
                deleteAttaches=coForDeletingAttachments.Attachments;
                
                for(Attachment a:deleteAttaches)
                    {                    
                    if(a.CreatedDate.addminutes(5)< myDate)
                        {                       
                        delete a;
                        }                                 
                    }
                //FA_Course__c course=[select c.Id, (SELECT Attachment_type__c, Name FROM Course_Attachments__r)from FA_Course__c c where c.Id=:courseId];
                //FA_Course__c course=[select c.Id, (Select Id,Name,BodyLength from Attachments) from FA_Course__c  c where c.Id=:courseId];
                //notes=course.Attachments;                
               
                Course_Attachment__c[] coursePreAttachments=[select id,Attachment_type__c,name ,Course__c,FA_Download_Available_From__c,(Select Id,Name,BodyLength from Attachments),(Select Id,Title,Body from Notes) from Course_Attachment__c where Course__c=:courseId and Attachment_type__c='Pre-work' and FA_Download_Available_From__c <=:Date.Today()]; 
                
                if(coursePreAttachments.size()>0){
                
                    Integer i=coursePreAttachments.size();
                    
                    while (i > 0) {               
                        prenotes.addAll(coursePreAttachments[i-1].Attachments);
                        prenotesOnly.addAll(coursePreAttachments[i-1].Notes);                
                        i--;
                    }                
                }                 
                 
                Course_Attachment__c[] coursePostAttachments=[select id,Attachment_type__c,name ,Course__c,FA_Download_Available_From__c,(Select Id,Name,BodyLength from Attachments),(Select Id,Title,Body from Notes) from Course_Attachment__c where Course__c=:courseId and Attachment_type__c='Post-work' and FA_Download_Available_From__c<=:Date.Today()];
                if(coursePostAttachments.size()>0){                             
                   
                    Integer j=coursePostAttachments.size();
                                    
                    while (j > 0) {                
                        postnotes.addAll(coursePostAttachments[j-1].Attachments);
                        postnotesOnly.addAll(coursePostAttachments[j-1].Notes);                
                        j--;             
                    }
                }
                Course_Attachment__c[] coMaterialAttaches=[select id,Attachment_type__c,name ,Course__c,FA_Download_Available_From__c,(Select Id,Name,BodyLength from Attachments),(Select Id,Title,Body from Notes) from Course_Attachment__c where Course__c=:courseId and Attachment_type__c='Course-Material' and FA_Download_Available_From__c<=:Date.Today()];
                if(coMaterialAttaches.size()>0){
                  
                    Integer k=coMaterialAttaches.size();
                                    
                    while (k > 0) {
                        
                        coMaterialnotes.addAll(coMaterialAttaches[k-1].Attachments);
                        comaterialnotesOnly.addAll(coMaterialAttaches[k-1].Notes);
                        
                        k--;       
                    }
                }
                
                objProDetail.startDate=DateTime.valueOf(co.FA_Start_Date_Time__c.format('yyyy-MM-dd HH:mm:ss',String.ValueOf(UserInfo.getTimeZone())));
                objProDetail.endDate=DateTime.valueOf(co.FA_End_Date_Time__c.format('yyyy-MM-dd HH:mm:ss',String.ValueOf(UserInfo.getTimeZone())));
                
                //Below code written to convert all the Notes into Attachments so they can be displayed and downloaded                
                /*if(prenotesOnly.size()>0)
                {  
                    for(Note n: prenotesOnly){
                    
                        Blob txtBlob = Blob.valueOf(n.Body); //Convert it to a blob
                    
                        attach = new Attachment(); //Make an attachment
                        String noteName = n.Title;
                        attach.Name = noteName;  
                        attach.Body = txtBlob;
                        attach.ContentType= 'application/msword'; //Signal what the file's MIME type is
                        attach.ParentID = courseId;                                                                                                               
                        insert attach;              
                        prenotes.add(attach);
                  }
                }
                
                if(postnotesOnly.size()>0)
                {
                    for(Note n: postnotesOnly){
                    
                        Blob txtBlob = Blob.valueOf(n.Body); //Convert it to a blob
                    
                        attach = new Attachment(); //Make an attachment
                        String noteName = n.Title;
                        attach.Name = noteName;  
                        attach.Body = txtBlob;
                        attach.ContentType= 'application/msword'; //Signal what the file's MIME type is
                        attach.ParentID = courseId;                                                                      
                        insert attach;
                        postnotes.add(attach);                        
                    }
                }
                
                if(comaterialnotesOnly.size()>0)
                {
                    for(Note n: comaterialnotesOnly){
                    
                        Blob txtBlob = Blob.valueOf(n.Body); //Convert it to a blob
                    
                        attach = new Attachment(); //Make an attachment
                        String noteName = n.Title;
                        attach.Name = noteName;  
                        attach.Body = txtBlob;
                        attach.ContentType= 'application/msword'; //Signal what the file's MIME type is
                        attach.ParentID = courseId;                                                                     
                        insert attach;
                        coMaterialnotes.add(attach);                        
                    }
                }
                */
                
                objProDetail.CoOcc=co;
                objProDetail.CoPreAttachment=prenotes;                
                ObjProDetail.CoPostAttachment=postnotes;
                ObjProDetail.CoMaterialAttachment=coMaterialnotes;                
              }                   
            return null;    
         }          
            
    /*
        End of the code for the Couse Detail Page
    ****************************************************************************************************/
    
    /*
     Start of the code for Pre-work tasks page
    */
    
    Public Class wrapPreTasks{
    
    public FA_Pre_Work_Task__c preWorkTask {get; set;}
    public List<Attachment> preWorkTaskAssignmentAttaches {get; set;} 
    public Integer serialNumber{get; set;} 
    
   }
    public string PrivateHubURL{get;set;}
   
    
    public List<wrapPreTasks> wrapInstanceOfPreTasks;
    
    public List<wrapPreTasks> getfetchPreWorkTasks(){
    
            wrapInstanceOfPreTasks=new List<wrapPreTasks>();
            
            List<FA_Pre_Work_Task__c> preWorkTasks = new List<FA_Pre_Work_Task__c>();
            Id OccMemId=ApexPages.currentPage().getParameters().get('id');
            
            preWorkTasks=[select id,name,FA_OccMember__c,FA_Occurence_Task__c,FA_Task_Name__c,FA_Mark_Completed__c,FA_Due_Date__c,FA_Task_Description__c from FA_Pre_Work_Task__c where FA_OccMember__c=:OccMemId];
            
            String ChatGrpURL = ConfigSetting.get('Fa_CourseGroup').FA_value__c; 
            
            for(FA_Member_ChatterGroup__c privGroupId : [select id, FA_Occurence_Member__c,FA_Group_ID__c from FA_Member_ChatterGroup__c where FA_Occurence_Member__c=:OccMemId])
             {
               PrivateHubURL= ChatGrpURL + privGroupId.FA_Group_ID__c;
             
             }
             
             
           
            for(FA_Pre_Work_Task__c t:preWorkTasks){  
              
                List<FA_Pre_Work_Task_Assignment__c> preWokTaskAsmnts=[select id,name,(SELECT Id,Name FROM Attachments) from FA_Pre_Work_Task_Assignment__c where id=:t.FA_Occurence_Task__c];
                wrapPreTasks tempWrapPreTasks=new wrapPreTasks();       
                tempWrapPreTasks.preWorkTask=t;
                
                if(preWokTaskAsmnts.size()>0){
                    tempWrapPreTasks.preWorkTaskAssignmentAttaches=preWokTaskAsmnts[0].Attachments;
                }
                
                wrapInstanceOfPreTasks.add(tempWrapPreTasks);
            }
            
            
            for(Integer i=0;i<wrapInstanceOfPreTasks.size();i++){
            
                wrapInstanceOfPreTasks[i].serialNumber=i+1;
            }
                        
            return wrapInstanceOfPreTasks;        
    }
    
    
    public Pagereference saveTheTasks(){
    
        List<FA_Pre_Work_Task__c> preWorkTasksUpdated=new List<FA_Pre_Work_Task__c>();
        
            for(wrapPreTasks p:wrapInstanceOfPreTasks){
            
                if(p.preWorkTask.FA_Mark_Completed__c==true){            
                
                    preWorkTasksUpdated.add(p.preWorkTask);         
                }
            }
              
        update preWorkTasksUpdated;
        
        PageReference afterSavingTasks= new PageReference('/apex/Programme');
        afterSavingTasks.setRedirect(false);
         
        return afterSavingTasks;
    }
    
    /* end of the code for pre-work tasks page */
 
       
    
    /*
       Start of the Code added for Programme visualforce Page
       this page will show all the required course detail registerd by the Participant.
    */
     
     
      Public class ParticipantProgram {
        
          public FA_Occurence_Member__c OccMem{get;set;}
          public string CollgrpURL{get;set;}
          public string CollgrpName{get;set;}
          public string PrivateChatterGrpURL{get;set;}
          public string PrivateChatterGrpName{get;set;}         
          
        }
        
        //To fetch the Upcoming programme associated with the User
                 
      Public List<ParticipantProgram> getUserRegisProgramme() {
        
        Map<id,FA_Course_ChatterGroup__c> mapOccChatterGroup=new Map<id,FA_Course_ChatterGroup__c>(); 
        Map<id,FA_Member_ChatterGroup__c> mapMemChatterGroup=new Map<id,FA_Member_ChatterGroup__c>();

        String CollGroupURL=ConfigSetting.get('Fa_CourseGroup').FA_value__c;  
        list<ParticipantProgram> liParProgram =new list<ParticipantProgram>();
        for(FA_Occurence_Member__c tOccMem: [select id,                       
                                                    name,
                                                    FA_Course_Occurence__c,
                                                    FA_Course_Occurence__r.FA_Course_Name__c,
                                                    FA_Course_Occurence__r.FA_Start_Date_Time__c,
                                                    FA_Course_Occurence__r.FA_End_Date_Time__c,
                                                    FA_Course_Occurence__r.FA_Course__r.FA_Course_Logo__c,
                                                    FA_Course_Occurence__r.FA_Course__r.FA_Course_Overview__c, 
                                                    FA_Course_Occurence__r.FA_Training_Venue__r.Name,
                                                    FA_Course_Occurence__r.FA_Training_Room__r.Name                     
                                             from FA_Occurence_Member__c
                                             where  FA_Participant_Instructor__c=:UserInfo.getUserID()
                                             and FA_Course_Occurence__r.FA_End_Date_Time__c >= :Date.Today()
                                             ]){
                     ParticipantProgram pp=new ParticipantProgram();                     
                         pp.OccMem=tOccMem;
                         if(!mapOccChatterGroup.containsKey(tOccMem.FA_Course_Occurence__c))
                             mapOccChatterGroup.put(tOccMem.FA_Course_Occurence__c,null);
   

                          liParProgram.add(pp);    
                   }
                
                
                for(FA_Member_ChatterGroup__c tMemChGrp:[select  id,
                                                             FA_Chatter_Group_Name__c,
                                                             FA_Course_Occurence__c,
                                                             FA_Group_ID__c,
                                                             FA_Occurence_Member__c 
                                                        from FA_Member_ChatterGroup__c 
                                                        where FA_Course_Occurence__c in :mapOccChatterGroup.keySet()
                                                        and FA_Occurence_Member__r.FA_Participant_Instructor__c=:UserInfo.getUserID()]){
                  
                         mapMemChatterGroup.put(tMemChGrp.FA_Course_Occurence__c,tMemChGrp);

                  } 
                
                for(FA_Course_ChatterGroup__c CourseChatter:[select id,
                                                                 FA_Course_Occurence__c,
                                                                 FA_Group_ID__c,
                                                                 FA_Chatter_Group_Name__c
                                                            from FA_Course_ChatterGroup__c
                                                            where  FA_Course_Occurence__c in :mapOccChatterGroup.keySet()
                                                          ]){
                         mapOccChatterGroup.put(CourseChatter.FA_Course_Occurence__c,CourseChatter );                                     
                 }
                
               for(ParticipantProgram record:liParProgram){
                    
                       if(mapOccChatterGroup.get(record.OccMem.FA_Course_Occurence__c)!=null){
                           
                            record.CollgrpURL=CollGroupURL + mapOccChatterGroup.get(record.OccMem.FA_Course_Occurence__c).FA_Group_ID__c;
                            record.CollgrpName=mapOccChatterGroup.get(record.OccMem.FA_Course_Occurence__c).FA_Chatter_Group_Name__c;
                        }
                       
                       if(mapMemChatterGroup.get(record.OccMem.FA_Course_Occurence__c)!=null){
                           
                            record.PrivateChatterGrpURL=CollGroupURL + mapMemChatterGroup.get(record.OccMem.FA_Course_Occurence__c).FA_Group_ID__c;
                            record.PrivateChatterGrpName=mapMemChatterGroup.get(record.OccMem.FA_Course_Occurence__c).FA_Chatter_Group_Name__c;
                       }
                       
                   }
                return liParProgram;
        }
        
        //To fetch the completed programme associated with the User
        Public List<ParticipantProgram> getUserCompProgramme() {
        
         list<ParticipantProgram> liParProgram =new list<ParticipantProgram>();
         Map<id,FA_Course_ChatterGroup__c> mapOccChatterGroup=new Map<id,FA_Course_ChatterGroup__c>();
         Map<id,FA_Member_ChatterGroup__c> mapMemChatterGroup=new Map<id,FA_Member_ChatterGroup__c>();
         String CollGroupURL=ConfigSetting.get('Fa_CourseGroup').FA_value__c; 
         for(FA_Occurence_Member__c tOccMem: [select id,                       
                                                    name,
                                                    FA_Course_Occurence__c,
                                                    FA_Course_Occurence__r.FA_Course__c,
                                                    FA_Course_Occurence__r.FA_Course_Name__c,
                                                    FA_Course_Occurence__r.FA_Start_Date_Time__c,
                                                    FA_Course_Occurence__r.FA_End_Date_Time__c,
                                                    FA_Course_Occurence__r.FA_Course__r.FA_Course_Logo__c,
                                                    FA_Course_Occurence__r.FA_Course__r.FA_Course_Overview__c, 
                                                    FA_Course_Occurence__r.FA_Training_Venue__r.Name,
                                                    FA_Course_Occurence__r.FA_Training_Room__r.Name                     
                                             from FA_Occurence_Member__c
                                             where  FA_Participant_Instructor__c=:UserInfo.getUserID()
                                             and  FA_Course_Occurence__r.FA_End_Date_Time__c <= :datetime.now() 
                                             ]){
                     ParticipantProgram pp=new ParticipantProgram();                     
                         pp.OccMem=tOccMem;
                         if(!mapOccChatterGroup.containsKey(tOccMem.FA_Course_Occurence__c))
                             mapOccChatterGroup.put(tOccMem.FA_Course_Occurence__c,null);
               
                            liParProgram.add(pp);    
                     
                   }
                 
               for(FA_Course_ChatterGroup__c CourseChatter:[select id,
                                                                   FA_Course_Occurence__c,
                                                                   FA_Group_ID__c,
                                                                   FA_Chatter_Group_Name__c
                                                              from FA_Course_ChatterGroup__c
                                                             where FA_Course_Occurence__c in :mapOccChatterGroup.keySet()]){

                    mapOccChatterGroup.put(CourseChatter.FA_Course_Occurence__c,CourseChatter);                                     
                 } 

               for(FA_Member_ChatterGroup__c tMemChGrp:[select  id,
                                                                FA_Chatter_Group_Name__c,
                                                                FA_Course_Occurence__c,
                                                                FA_Group_ID__c,
                                                                FA_Occurence_Member__c 
                                                           from FA_Member_ChatterGroup__c 
                                                          where FA_Course_Occurence__c in :mapOccChatterGroup.keySet()
                                                            and FA_Occurence_Member__r.FA_Participant_Instructor__c=:UserInfo.getUserID()]){
                  
                     mapMemChatterGroup.put(tMemChGrp.FA_Course_Occurence__c,tMemChGrp);

                  } 
               
               for(ParticipantProgram record:liParProgram){
                     
                       if(mapOccChatterGroup.get(record.OccMem.FA_Course_Occurence__c)!=null){

                            record.CollgrpURL=CollGroupURL + mapOccChatterGroup.get(record.OccMem.FA_Course_Occurence__c).FA_Group_ID__c;
                            record.CollgrpName=mapOccChatterGroup.get(record.OccMem.FA_Course_Occurence__c).FA_Chatter_Group_Name__c;
                       }
                       if(mapMemChatterGroup.get(record.OccMem.FA_Course_Occurence__c)!=null){
                           
                            record.PrivateChatterGrpURL=CollGroupURL + mapMemChatterGroup.get(record.OccMem.FA_Course_Occurence__c).FA_Group_ID__c;
                            record.PrivateChatterGrpName=mapMemChatterGroup.get(record.OccMem.FA_Course_Occurence__c).FA_Chatter_Group_Name__c;
                       }

                    }                                            
                return liParProgram;
        }
    
    /*
        End of the code for the Programme Page
    *****************************************************************************************************************/
    
    //Start of the Code added for Centre Component 
    Public string getHostURL(){
       return 'https://' + ApexPages.currentPage().getHeaders().get('Host');
    }
    
    Public List<FA_Training_Venue__c> getCentres() {
       
           List<FA_Training_Venue__c> objTrainVenue=new  List<FA_Training_Venue__c>();
           objTrainVenue =   [select  id,
                                     name,
                                     FA_Image_URL__c,
                                     FA_Overview__c,
                                     FA_Travel_Information__c,
                                     FA_Address_Line_1__c,
                                     FA_Address_Line_2__c,
                                     FA_Town_City__c,
                                     FA_Country__c,
                                     FA_Postcode__c                                                                       
                               from FA_Training_Venue__c order by name desc];
           return objTrainVenue;
        }
    
    //End of the code for the Centre Component
          
        
     //Start of the Code added for Calender Component 
    
    @RemoteAction
    
            public static list<calendarEvent> getEvents(id calendarId, string queryStart, string queryEnd)
            {
                
                string Detail_Data_Fields =', id, name ';
                
                list<calendarEvent> events = new list<calendarEvent>();
                
                datetime startDate = datetime.newInstance(0);  
                datetime endDate = datetime.newInstance(0); 
                                
                startDate = datetime.now();
                endDate = startDate.addMinutes(4000);
                            
                 
               
                //SOQL query to get the all the Course Occurance schedule Releated to the Participant    
                          
                 FA_Occurence_Member__c[] queryEvents =[select id,
                                                              name,
                                                              FA_Course_Occurence__c,
                                                              FA_Course_Occurence__r.FA_Start_Date_Time__c,
                                                              FA_Course_Occurence__r.FA_End_Date_Time__c,
                                                              FA_Course_Occurence__r.FA_Pre_Work_Start_Date__c,
                                                              FA_Course_Occurence__r.FA_Post_Prog_End_Date__c,
                                                              FA_Course_Occurence__r.FA_Course__r.Name 
                                                         from FA_Occurence_Member__c 
                                                         where FA_Participant_Instructor__c =:UserInfo.getUserId()
                                                      ];
                               
                               
                for(FA_Occurence_Member__c e : queryEvents){
                
                  integer intEventDays=e.FA_Course_Occurence__r.FA_Start_Date_Time__c.date().daysBetween(e.FA_Course_Occurence__r.FA_End_Date_Time__c.date());
                   
                   for(integer i=0;i<=intEventDays;i++){
                       
                            calendarEvent thisEvent = new calendarEvent();
                            thisEvent.id = e.id;
                            thisEvent.title = e.FA_Course_Occurence__r.FA_Course__r.Name ;
                            thisEvent.allDay = false;
                            thisEvent.url='/apex/Course_Detail?id=' +e.FA_Course_Occurence__c + '&retURL=/apex/FA_Calendar';
                            thisEvent.color = '#C38EC7';
                            
                            
                            double startDateTime = (dateTime.valueOf(e.FA_Course_Occurence__r.FA_Start_Date_Time__c.addDays(i)).getTime()/1000);
                            double endDateTime   =(dateTime.valueOf(e.FA_Course_Occurence__r.FA_Start_Date_Time__c.addDays(i).addHours(1)).getTime()/1000); //(dateTime.valueOf(e.FA_Course_Occurence__r.FA_End_Date_Time__c.addDays(i)).getTime()/1000);
                                                    
                                              
                            thisEvent.start =startDateTime;
                            //thisEvent.Eventend=endDateTime;         
                            thisEvent.detailData = new map<string,string>();
                            for(string data :Detail_Data_Fields.split(','))
                            {
                                   //  thisEvent.detailData.put(data.trim(), string.valueOf(e.get(data.trim())));  
                                  // thisEvent.detailData.put('Course Link','<a href="www.google.com">Link Course</a>');  
                            }
                             if(i==0){  
                             
                                 if(e.FA_Course_Occurence__r.FA_Pre_Work_Start_Date__c!=null){
                                   
                                      calendarEvent preWorkEvent = new calendarEvent();
                                        preWorkEvent.id = e.id + 'pre';
                                        preWorkEvent.title ='Pre Work Deadline for ' + e.FA_Course_Occurence__r.FA_Course__r.Name ;
                                        preWorkEvent.allDay = false;
                                        preWorkEvent.color = '#4863A0';
                                        
                                        preWorkEvent.start=DateTime.newInstanceGmt(e.FA_Course_Occurence__r.FA_Pre_Work_Start_Date__c,Datetime.now().Time()).getTime()/1000; 
                                        events.add(preWorkEvent);
                                    }
                                if(e.FA_Course_Occurence__r.FA_Post_Prog_End_Date__c!=null){
                                   
                                      calendarEvent postWorkEvent = new calendarEvent();
                                        postWorkEvent.id = e.id + 'post';
                                        postWorkEvent.title ='Post Work Deadline for ' + e.FA_Course_Occurence__r.FA_Course__r.Name ;
                                        postWorkEvent.allDay = false;
                                        postWorkEvent.color = '#4863A0';
                                        postWorkEvent.start = DateTime.newInstanceGmt(e.FA_Course_Occurence__r.FA_Post_Prog_End_Date__c,Datetime.now().Time()).getTime()/1000; 
                               
                                     events.add(postWorkEvent);
                                   }   
                                    
                                }
                            events.add(thisEvent);
                       }
                }
                
                return events;
            }
           
            public class calendarEvent
            {
                public string id{get;set;}
                public string title{get;set;}
                string color{get;set;}
                boolean allDay{get;set;}
                double start{get;set;}
                double Eventend{get;set;}
                string url{get;set;}
                map<string,string> detailData{get;set;}
                boolean editable{get;set;}
            }
            
     /*
        End of the code added for MyCalender Component
    *********************************************************************************************/       
    
    /*
       Start of the Code added for Feedback visualforce Page
       this page will capture the feedback from the user based on Programme selected by the USer.
    */
    public String selectedOne { get; set;}
    public List<String> listOfCourses { get; set; }
    public List<FA_Occurence_Member__c> liOccForFeed {get; set;}
    public Id userid {get; set;}
    public String listSizeZero {get; set;}
    
    public class QuestionWrapper
      {
        public string Questiontype{get;set;}
        public List<FA_Feedback_Questionnaire__c>  objFbQutn{get;set;}
      } 
    
     
    public List<QuestionWrapper> listQuestion {get;set;}
    public List<SelectOption> courseListOptions {get; set;}
    public List<FA_Course_Occurence__c> courseListOptionsUpdated {get; set;}
  

    public PageReference initFeedback() {
           customSet();
           Courses();
        return null;
     }
  
    public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Not at All','Not at All'));
            options.add(new SelectOption('Partially','Partially'));
            options.add(new SelectOption('Mostly','Mostly'));
            options.add(new SelectOption('Entirely','Entirely'));
            options.add(new SelectOption('Exceeded','Exceeded'));           
            return options;
     }  
    
    public void Courses(){
              courseListOptions= new List<SelectOption>();
              courseListOptionsUpdated =new List<FA_Course_Occurence__c>();
              
              userid=UserInfo.getUserId();
              FA_Occurence_Member__c[] liOccMem  =  [Select   FA_Course_Occurence__c, 
                                                              FA_Course_Occurence__r.FA_Course__r.Name,
                                                              FA_Participant_Instructor__r.FirstName  , 
                                                              FA_Participant_Instructor__r.Profile.Name 
                                                      from FA_Occurence_Member__c 
                                                      where FA_Participant_Instructor__r.Id=:UserInfo.getUserId() 
                                                      and FA_Course_Occurence__r.FA_Initiate_Feedback__c =true];
        
              set<Id> setCourOccId =new Set<id>();


              for(FA_Occurence_Member__c tempOccMem: liOccMem)
                {
                  setCourOccId.add(tempOccMem.FA_Course_Occurence__c);
                }

              set<Id> setCourAttendId =new Set<id>();
              
              for(FA_Feedback__c objFeedback:[select id,FA_Course_Occurence__c from FA_Feedback__c where FA_Course_Occurence__c in :setCourOccId])
                    {
                      setCourAttendId.add(objFeedback.FA_Course_Occurence__c);
                    }

              liOccForFeed=new List<FA_Occurence_Member__c>();
              for(FA_Occurence_Member__c tempOccMem: liOccMem)
              {
              if(!setCourAttendId.contains(tempOccMem.FA_Course_Occurence__c))
                    {
                       liOccForFeed.add(tempOccMem);

                    }
              }
                        
             for(FA_Occurence_Member__c optionItems : liOccForFeed)  
            {  
                
                courseListOptions.add(new SelectOption(optionItems.FA_Course_Occurence__c, optionItems.FA_Course_Occurence__r.FA_Course__r.Name)) ;  
                courseListOptionsUpdated.add([select id,
                                                     FA_Course__r.FA_Course_Logo__c ,
                                                     FA_Course_Name__c ,
                                                     FA_Course__r.FA_Course_Overview__c,
                                                     FA_Start_Date_Time__c,
                                                     FA_End_Date_Time__c,
                                                     FA_Training_Venue__r.Name,
                                                     FA_Training_Room__r.Name                                                      
                                                     from FA_Course_Occurence__c where id=:optionItems.FA_Course_Occurence__c]);
            } 
            
            listSizeZero = 'There are no programmes for which feedback has to be given !';             
        }  
        
    public void customSet(){    

           
    Map<string,QuestionWrapper> mapQuestionStatus= new Map<string,QuestionWrapper>();
    for(FA_FBQuestionSet__c target : [Select FA_Question__c,
                                             FA_QuestionType__c,
                                             FA_Rating__c 
                                      from FA_FBQuestionSet__c
                                     // where FA_QuestionType__c='Pre-Work and Preparation sub Object'  
                                      Order by FA_QuestionOrder__c ]){
       
            FA_Feedback_Questionnaire__c objFeedQues=new FA_Feedback_Questionnaire__c();
        
            objFeedQues.FA_Question__c=target.FA_Question__c;
            objFeedQues.FA_QuestionType__c=target.FA_QuestionType__c;
            objFeedQues.FA_Rating__c=target.FA_Rating__c;
           // objFeedQues.FA_RatingList__c=cs.Rating.split(',');
            //objFeedQues.FA_Feedback__c='a0Pc00000033BBV';
        
        if(mapQuestionStatus.containskey(objFeedQues.FA_QuestionType__c))
          {
            mapQuestionStatus.get(objFeedQues.FA_QuestionType__c).objFbQutn.add(objFeedQues);
          }
        else
          {
            QuestionWrapper tQR=new QuestionWrapper();
            tQR.Questiontype =objFeedQues.FA_QuestionType__c;
            
            tQR.objFbQutn=new List<FA_Feedback_Questionnaire__c>();
            tQR.objFbQutn.add(objFeedQues);
            mapQuestionStatus.put(objFeedQues.FA_QuestionType__c,tQR);
            
          }
          
    }       
        listQuestion =mapQuestionStatus.values(); 
       
    }
    
    public PageReference Save()
    { 
    
      FA_Feedback__c feedbackObj=new FA_Feedback__c();
      
      selectedOne='';      
      selectedOne=ApexPages.currentPage().getParameters().get('id');
      //Id strid=selectedOne;    
      feedbackObj.FA_Course_Occurence__c=selectedOne;
      feedbackObj.FA_Participant__c=userid;
      insert feedbackObj;
      
               
      List<FA_Feedback_Questionnaire__c> liFeedQuestion =new List<FA_Feedback_Questionnaire__c>();
      
      for(QuestionWrapper tQuWrap:listQuestion )
         {
            
            liFeedQuestion.addAll(tQuWrap.objFbQutn);
         }
      for(FA_Feedback_Questionnaire__c newFeed:liFeedQuestion)
      {
      newFeed.FA_Feedback__c=feedbackObj.id; 
       }  
      upsert liFeedQuestion;
      
      
      PageReference updatedPage= new PageReference('/apex/Feedback');
      updatedPage.setRedirect(false);
     
      return updatedPage;
   }
        
     /*
        End of the code for the Programme Page
    *********************************************************************************************/
    
    /*
    Start of the code for Application Switcher
    *********************************************************************************************/
    
    
   /*
    public String selectedApp { get; set;}
    public List<SelectOption> appsListOptions {get; set;}
    
    public PageReference initAppSwitch()
    {
    id profileIdOfCurrentUser=UserInfo.getProfileId();
    appsListOptions= new List<SelectOption>();
    
        if(profileIdOfCurrentUser=='00eE0000000tj05')
        {
             
            appsListOptions.add(new SelectOption('Unilever Four Acres','Unilever Four Acres'));
            appsListOptions.add(new SelectOption('Unilever Chatter only','Unilever Chatter only'));
            appsListOptions.add(new SelectOption('Ratings and Reviews','Ratings and Reviews'));
            appsListOptions.add(new SelectOption('Communication Planner','Communication Planner'));     
        }
        if(profileIdOfCurrentUser=='')
        {
        
        }
                
    return null;
    
    }
   
    
    public PageReference switchSave()
    {
        if(selectedApp=='Unilever Four Acres')
        {      
        return new PageReference('/home/home.jsp');    
        }
       
    else 
    return null;
    }
   
    End of the code for Application Switcher
    *********************************************************************************************/
    
    
    
   
    
}