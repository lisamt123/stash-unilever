@isTest(SeeAllData=true)


/**
  * The following class tests the Trigger On CourseFacilitator Object for the following,
  * When a CourseFacilitator is created it triggers an After Insert Trigger
  * on CourseFacilitator which adds the CourseFacilitator to the Chatter Groups
  * All FourAcres and FourAcres Help.
  */
  
global class FA_Test_Trigger_CouFacilitator{
      
    
       /** The following method is used to test whether course facilitators are added to All FourAcres 
         * and FourAcres Help groups based on the course occurence,
         * when course facilitator is created 
         */
       
      static testMethod void TestAssociateFacilitatorsToGroup (){
         
            Test.startTest();
            
            Boolean flag;
       
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='bfght';
            ObjUser.Email='bfght'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='bfght'+'@unilever.com.compass';
            ObjUser.CommunityNickname='bfght';
            ObjUser.Alias='bfght';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
           
            insert ObjUser;
            
            User tObjUser;
            tObjUser=new User();
            tObjUser.LastName='jytfc';
            tObjUser.Email='jytfc'+'@unilever.com.compass';
            tObjUser.ProfileId=UserInfo.getProfileId();       
            tObjUser.UserName='jytfc'+'@unilever.com.compass';
            tObjUser.CommunityNickname='jytfc';
            tObjUser.Alias='jytfc';
            tObjUser.TimeZoneSidKey='America/Los_Angeles';
            tObjUser.LocaleSidKey=UserInfo.getLocale();
            tObjUser.EmailEncodingKey='UTF-8';
            tObjUser.LanguageLocaleKey='en_US';
           
            insert tObjUser;
        
            FA_Course__c objCourse =new FA_Course__c();
            
            objCourse.Name = 'TestCourse';
            objCourse.FA_status__c='Active';
            objCourse.FA_Course_Code__c='45875';
            objCourse.FA_Course_Logo__c='https://unilever--adfs--c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000EB31&oid=00Dc0000001KMA0&lastMod=1366285875000';
            objCourse.FA_Course_Overview__c='testCourse Overview';
            
            insert objCourse;
            
            FA_Training_Venue__c ObjTrVenue =new FA_Training_Venue__c();
             
            ObjTrVenue.Name='TestVenue1'; 
            ObjTrVenue.FA_Image_URL__c='testurl@unilever.com';
            ObjTrVenue.FA_Address_Line_1__c='Whitefield';
            ObjTrVenue.FA_Country__c='India';
            ObjTrVenue.FA_Town_City__c='Bangalore';
            ObjTrVenue.FA_Overview__c='Testing CentresPage';
            ObjTrVenue.FA_Travel_Information__c='Testing Centres_TravelInformation';
             
             insert ObjTrVenue;
             
            FA_Training_Room__c ObjTRoom=new FA_Training_Room__c();
                
            ObjTRoom.FA_Active__c=true;
            ObjTRoom.FA_Capacity__c=25;
            ObjTRoom.FA_Room_Number__c='10';
            ObjTRoom.FA_Training_Venue__c=ObjTrVenue.Id;
             
            insert ObjTRoom;  
           
            FA_Course_Occurence__c ObjCoOcc=new FA_Course_Occurence__c();
         
            ObjCoOcc.FA_Course__c=objCourse.id;
            ObjCoOcc.FA_Training_Room__c=ObjTRoom.Id;
            ObjCoOcc.FA_Training_Venue__c=ObjTRoom.FA_Training_Venue__c;
            ObjCoOcc.FA_Initiate_Feedback__c=false;
            ObjCoOcc.FA_Status__c='Active';
            ObjCoOcc.FA_Start_Date_Time__c=system.today();
            ObjCoOcc.FA_End_Date_Time__c=system.today()+1;
            ObjCoOcc.FA_Pre_Work_Start_Date__c=system.today()-7;
            ObjCoOcc.FA_Post_Prog_End_Date__c=system.today()+7;
            
            insert ObjCoOcc;
            
            FA_Occurence_Member__c ObjOccMember =new FA_Occurence_Member__c();
            ObjOccMember.FA_New_Arrival_Date__c = system.today();            
            ObjOccMember.FA_Participant_Instructor__c=ObjUser.id;            
            ObjOccMember.FA_Arrival_Information__c='Airport car transfer';
            ObjOccMember.FA_Course_Occurence__c=ObjCoOcc.Id; 
            ObjOccMember.FA_New_Departure_Date__c=system.today();
            ObjOccMember.FA_Departure_Information__c='Airport car transfer';
            ObjOccMember.FA_Participation_Status__c='Invited';
            ObjOccMember.FA_Send_Feedback_Invitation__c=false;
            ObjOccMember.FA_Role__c='Participant';
            
            insert ObjOccMember; 
            
            FA_Course_Facilitator__c CoFac=new FA_Course_Facilitator__c();
            CoFac.FA_Course__c=objCourse.id;
            CoFac.FA_Role__c='Facility Manager';
            CoFac.FA_Facilitator__c=tObjUser.Id;
            
            insert CoFac;
             
           set<Id> testGrpIds =new set<Id>();    
   
           testGrpIds.add(FA_Config_Settings__c.getValues('FA_AllFourAcres').FA_Value__c);
           testGrpIds.add(FA_Config_Settings__c.getValues('FA_HelpGroup').FA_Value__c);  
         
           List<CollaborationGroupMember> s=[select memberId,CollaborationGroupId  
                                             from CollaborationGroupMember
                                             where CollaborationGroupId in:testGrpIds];
                                     
             for(CollaborationGroupMember tempCGM:s)
             {
                     if(tempCGM.memberId==CoFac.FA_Facilitator__c) {flag=true;}
                     else{flag=false;}
             }
       
        test.stopTest();   
       // system.assertEquals(false,flag);     
  }                       
  
   /**  
     * The method 'After_AccessToFacilitators' tests the Trigger On CourseFacilitator Object for the following, 
     * When a CourseFacilitator is created it triggers an After Insert Trigger  
     * on CourseFacilitator which shares the access on course and related course occurences 
     * to the CourseFacilitator.
     */
  static testMethod void After_AccessToFacilitators()
  {
      
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='ahbgf';
            ObjUser.Email='ahbgf'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='ahbgf'+'@unilever.com.compass';
            ObjUser.CommunityNickname='ahbgf';
            ObjUser.Alias='ahbgf';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
           
            insert ObjUser;
            
            User ObjUser2;
            ObjUser2=new User();
            ObjUser2.LastName='dfcjh';
            ObjUser2.Email='dfcjh'+'@unilever.com.compass';
            ObjUser2.ProfileId=UserInfo.getProfileId();       
            ObjUser2.UserName='dfcjh'+'@unilever.com.compass';
            ObjUser2.CommunityNickname='dfcjh';
            ObjUser2.Alias='dfcjh';
            ObjUser2.TimeZoneSidKey='America/Los_Angeles';
            ObjUser2.LocaleSidKey=UserInfo.getLocale();
            ObjUser2.EmailEncodingKey='UTF-8';
            ObjUser2.LanguageLocaleKey='en_US';
           
            insert ObjUser2;
        
            FA_Course__c objCourse =new FA_Course__c();
            
            objCourse.FA_status__c='Active';
            objCourse.FA_Course_Code__c='45973';
            objCourse.FA_Course_Logo__c='https://unilever--adfs--c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000EB31&oid=00Dc0000001KMA0&lastMod=1366285875000';
            objCourse.FA_Course_Overview__c='testCourse Overview';
            
            insert objCourse;
            
             FA_Training_Venue__c ObjTrVenue =new FA_Training_Venue__c();
             
             ObjTrVenue.Name='TestVenue'; 
             ObjTrVenue.FA_Image_URL__c='testurl@unilever.com';
             ObjTrVenue.FA_Address_Line_1__c='Whitefield';
             ObjTrVenue.FA_Country__c='India';
             ObjTrVenue.FA_Town_City__c='Bangalore';
             ObjTrVenue.FA_Overview__c='Testing CentresPage';
             ObjTrVenue.FA_Travel_Information__c='Testing Centres_TravelInformation';
             
             insert ObjTrVenue;
             
             FA_Training_Room__c ObjTRoom=new FA_Training_Room__c();
                
             ObjTRoom.FA_Active__c=true;
             ObjTRoom.FA_Capacity__c=25;
             ObjTRoom.FA_Room_Number__c='12';
             ObjTRoom.FA_Training_Venue__c=ObjTrVenue.Id;
             
             insert ObjTRoom;  
           
             FA_Course_Occurence__c ObjCoOcc=new FA_Course_Occurence__c();
         
             ObjCoOcc.FA_Course__c=objCourse.id;
             ObjCoOcc.FA_Training_Room__c=ObjTRoom.Id;
             ObjCoOcc.FA_Training_Venue__c=ObjTRoom.FA_Training_Venue__c;
             ObjCoOcc.FA_Initiate_Feedback__c=false;
             ObjCoOcc.FA_Status__c='Active';
             ObjCoOcc.FA_Start_Date_Time__c=system.today();
             ObjCoOcc.FA_End_Date_Time__c=system.today()+1;
             ObjCoOcc.FA_Pre_Work_Start_Date__c=system.today()-7;
             ObjCoOcc.FA_Post_Prog_End_Date__c=system.today()+7;
             
            insert ObjCoOcc;
            
            test.startTest();
             
             FA_Occurence_Member__c ObjOccMember =new FA_Occurence_Member__c();
             ObjOccMember.FA_New_Arrival_Date__c = system.today();            
             ObjOccMember.FA_Participant_Instructor__c=ObjUser.id;            
             ObjOccMember.FA_Arrival_Information__c='Airport car transfer';
             ObjOccMember.FA_Course_Occurence__c=ObjCoOcc.Id; 
             ObjOccMember.FA_New_Departure_Date__c=system.today()+1;
             ObjOccMember.FA_Departure_Information__c='Airport car transfer';
             ObjOccMember.FA_Participation_Status__c='Invited';
             ObjOccMember.FA_Send_Feedback_Invitation__c=false;
             ObjOccMember.FA_Role__c='Participant';
           
             insert ObjOccMember; 
            
             FA_Course_Facilitator__c CoFac=new FA_Course_Facilitator__c();
             CoFac.FA_Course__c=objCourse.id;
             CoFac.FA_Role__c='Course Administrator';
             CoFac.FA_Facilitator__c=ObjUser.Id;
             insert CoFac;
             
       
       
            list<FA_Course_Facilitator__c> listCoFac = new list<FA_Course_Facilitator__c>();
          for(FA_Course_Facilitator__c test1 : listCoFac)
          {
               FA_Course_Facilitator__c tCoFac1 = new FA_Course_Facilitator__c();
               tCoFac1.FA_Course__c = objCourse.id;
               tCoFac1.FA_Role__c = 'Facility Manager';
               tCoFac1.FA_Facilitator__c = ObjUser2.id;
               listCoFac.add(tCoFac1);
          }
             insert listCoFac;
     
            List<FA_Course_Facilitator__c> testResults=[select id,
                                                             FA_Role__c    
                                                           from  FA_Course_Facilitator__c 
                                                           where FA_Course__c=:ObjCoOcc.FA_Course__c
                                                           and FA_Facilitator__c=:ObjUser2.id];
                                                  

            Boolean flag1=false;     
            Boolean flag2=false; 
        
            for(FA_Course_Facilitator__c tFacil1:testResults)
            {  
              for(FA_Course__Share tcFacilShare : [select AccessLevel  
                                                             from FA_Course__Share 
                                                             where parentId=:ObjCoOcc.FA_Course__c
                                                             and UserOrGroupId=:tFacil1.FA_Facilitator__c])
               {
                if (tcFacilShare.AccessLevel == 'Edit')
                   {
                     flag1= True;
                   }
               }
           
            for(FA_Course_Occurence__Share tcoFacilShare : [select AccessLevel  
                                                             from FA_Course_Occurence__Share 
                                                             where parentId=:ObjCoOcc.id
                                                             and UserOrGroupId=:tFacil1.FA_Facilitator__c])
               {
                if (tcoFacilShare.AccessLevel == 'Edit')
                   {
                     flag2= True;
                   }
               }
                      
            } 
            
            test.stopTest();
        
      system.assertEquals(false,flag1);
      system.assertEquals(false,flag2);
  }
  

   /**  
     * The method 'testTrigger_After_RevokeAccessFromCoFacilitators' tests the Trigger On CourseFacilitator Object for the following, 
     * When a CourseFacilitator is deleted it triggers an After delete Trigger  
     * on CourseFacilitator which revoke the access on course and related course occurences 
     * from the CourseFacilitator.
     */
   static testMethod void testTrigger_After_RevokeAccessFromCoFacilitators()
      { 
       
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='qaser';
            ObjUser.Email='qaser'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='qaser'+'@unilever.com.compass';
            ObjUser.CommunityNickname='qaser';
            ObjUser.Alias='qaser';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
           
            insert ObjUser;
        
            FA_Course__c objCourse =new FA_Course__c();
            
            objCourse.FA_status__c='Active';
            objCourse.FA_Course_Code__c='45870';
            objCourse.FA_Course_Logo__c='https://unilever--adfs--c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000EB31&oid=00Dc0000001KMA0&lastMod=1366285875000';
            objCourse.FA_Course_Overview__c='testCourse Overview';
            
            insert objCourse;
            
            FA_Training_Venue__c ObjTrVenue =new FA_Training_Venue__c();
             
            ObjTrVenue.Name='TestVenue'; 
            ObjTrVenue.FA_Image_URL__c='testurl@unilever.com';
            ObjTrVenue.FA_Address_Line_1__c='Whitefield';
            ObjTrVenue.FA_Country__c='India';
            ObjTrVenue.FA_Town_City__c='Bangalore';
            ObjTrVenue.FA_Overview__c='Testing CentresPage';
            ObjTrVenue.FA_Travel_Information__c='Testing Centres_TravelInformation';
             
             insert ObjTrVenue;
             
            FA_Training_Room__c ObjTRoom=new FA_Training_Room__c();
                
            ObjTRoom.FA_Active__c=true;
            ObjTRoom.FA_Capacity__c=25;
            ObjTRoom.FA_Room_Number__c='12';
            ObjTRoom.FA_Training_Venue__c=ObjTrVenue.Id;
             
            insert ObjTRoom;  
           
            FA_Course_Occurence__c ObjCoOcc=new FA_Course_Occurence__c();
         
            ObjCoOcc.FA_Course__c=objCourse.id;
            ObjCoOcc.FA_Training_Room__c=ObjTRoom.Id;
            ObjCoOcc.FA_Training_Venue__c=ObjTRoom.FA_Training_Venue__c;
            ObjCoOcc.FA_Initiate_Feedback__c=false;
            ObjCoOcc.FA_Status__c='Active';
            ObjCoOcc.FA_Start_Date_Time__c=system.today();
            ObjCoOcc.FA_End_Date_Time__c=system.today()+1;
            ObjCoOcc.FA_Pre_Work_Start_Date__c=system.today()-7;
            ObjCoOcc.FA_Post_Prog_End_Date__c=system.today()+7;
            
            insert ObjCoOcc;
            
            FA_Occurence_Member__c ObjOccMember =new FA_Occurence_Member__c();
            ObjOccMember.FA_New_Arrival_Date__c = system.today();            
            ObjOccMember.FA_Participant_Instructor__c=ObjUser.id;            
            ObjOccMember.FA_Arrival_Information__c='Airport car transfer';
            ObjOccMember.FA_Course_Occurence__c=ObjCoOcc.Id; 
            ObjOccMember.FA_New_Departure_Date__c=system.today();
            ObjOccMember.FA_Departure_Information__c='Airport car transfer';
            ObjOccMember.FA_Participation_Status__c='Invited';
            ObjOccMember.FA_Send_Feedback_Invitation__c=false;
            ObjOccMember.FA_Role__c='Participant';
            
            insert ObjOccMember; 
            
             FA_Course_Facilitator__c CoFac=new FA_Course_Facilitator__c();
             CoFac.FA_Course__c=objCourse.id;
             CoFac.FA_Role__c='Facility Manager';
             CoFac.FA_Facilitator__c=ObjUser.Id;
             insert CoFac;
      
             test.startTest();
 
             Boolean flag1;
             Boolean flag2; 
       
             delete CoFac;                                            
      
        

           for( FA_Course_Occurence__Share tFacilShare1 :[select ParentId,Id from FA_Course_Occurence__Share])
         
                                                                               
               {            
                  if (tFacilShare1.ParentId==ObjCoOcc.Id )         
                             {           
                               flag1= True;  
                             } 
                  else{ flag1=false;
                  }
               }    
               
            for( FA_Course__Share tFacilShare2 : [select ParentId,Id from FA_Course__Share])
                                                               
                                                                  
               {            
                  if (tFacilShare2.ParentId== ObjCoOcc.FA_Course__c)         
                             {           
                               flag2= True;  
                             } 
                             else
                             {
                               flag2=false;
                             }
   }                      
          test.stopTest(); 
          system.assertEquals(true,flag2);
 }
     
  /** The following method is used to test whether course facilitators are added to course chatter groups
    * based on the course occurence,when course facilitator is created 
    */
    
            
   static testMethod void TestAssocFacilitatorsToCourseGroup(){
      
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='fdghc';
            ObjUser.Email='fdghc'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='fdghc'+'@unilever.com.compass';
            ObjUser.CommunityNickname='fdghc';
            ObjUser.Alias='fdghc';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
           
            insert ObjUser;
        
            FA_Course__c objCourse =new FA_Course__c();
            
            objCourse.FA_status__c='Active';
            objCourse.FA_Course_Code__c='45899';
            objCourse.FA_Course_Logo__c='https://unilever--adfs--c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000EB31&oid=00Dc0000001KMA0&lastMod=1366285875000';
            objCourse.FA_Course_Overview__c='testCourse Overview';
            
            insert objCourse;
            
            FA_Training_Venue__c ObjTrVenue =new FA_Training_Venue__c();
             
            ObjTrVenue.Name='TestVenue3'; 
            ObjTrVenue.FA_Image_URL__c='testurl@unilever.com';
            ObjTrVenue.FA_Address_Line_1__c='Whitefield';
            ObjTrVenue.FA_Country__c='India';
            ObjTrVenue.FA_Town_City__c='Bangalore';
            ObjTrVenue.FA_Overview__c='Testing CentresPage';
            ObjTrVenue.FA_Travel_Information__c='Testing Centres_TravelInformation';
             
             insert ObjTrVenue;
             
            FA_Training_Room__c ObjTRoom=new FA_Training_Room__c();
                
            ObjTRoom.FA_Active__c=true;
            ObjTRoom.FA_Capacity__c=25;
            ObjTRoom.FA_Room_Number__c='11';
            ObjTRoom.FA_Training_Venue__c=ObjTrVenue.Id;
             
            insert ObjTRoom;  
           
            FA_Course_Occurence__c ObjCoOcc=new FA_Course_Occurence__c();
         
            ObjCoOcc.FA_Course__c=objCourse.id;
            ObjCoOcc.FA_Training_Room__c=ObjTRoom.Id;
            ObjCoOcc.FA_Training_Venue__c=ObjTRoom.FA_Training_Venue__c;
            ObjCoOcc.FA_Initiate_Feedback__c=false;
            ObjCoOcc.FA_Status__c='Active';
            ObjCoOcc.FA_Start_Date_Time__c=system.today();
            ObjCoOcc.FA_End_Date_Time__c=system.today()+1;
            ObjCoOcc.FA_Pre_Work_Start_Date__c=system.today()-7;
            ObjCoOcc.FA_Post_Prog_End_Date__c=system.today()+7;
            
            insert ObjCoOcc;
            
            FA_Occurence_Member__c ObjOccMember =new FA_Occurence_Member__c();
            ObjOccMember.FA_New_Arrival_Date__c = system.today();            
            ObjOccMember.FA_Participant_Instructor__c=ObjUser.id;            
            ObjOccMember.FA_Arrival_Information__c='Airport car transfer';
            ObjOccMember.FA_Course_Occurence__c=ObjCoOcc.Id; 
            ObjOccMember.FA_New_Departure_Date__c=system.today();
            ObjOccMember.FA_Departure_Information__c='Airport car transfer';
            ObjOccMember.FA_Participation_Status__c='Invited';
            ObjOccMember.FA_Send_Feedback_Invitation__c=false;
            ObjOccMember.FA_Role__c='Participant';
            
            insert ObjOccMember; 
            
            FA_Course_Facilitator__c CoFac=new FA_Course_Facilitator__c();
            CoFac.FA_Course__c=objCourse.id;
            CoFac.FA_Role__c='Facility Manager';
            CoFac.FA_Facilitator__c=ObjUser.Id;
            
            insert CoFac;
    
            test.startTest();  
      
         FA_Course_ChatterGroup__c cChGrp=[select id,
                                             FA_Chatter_Group_Name__c,
                                             FA_Course_Occurence__c,
                                             FA_Group_ID__c,
                                             FA_Course_Occurence__r.FA_Course__c
                                             from FA_Course_ChatterGroup__c
                                             where FA_Course_Occurence__r.FA_Course__c=:CoFac.FA_Course__c];
     
         set<Id> setCoChGrpId=new set<Id>();
         Boolean flag;
         setCoChGrpId.add(cChGrp.FA_Group_ID__c);    
                                       
         for(CollaborationGroupMember s:[select memberId,CollaborationGroupId 
                                                             from CollaborationGroupMember
                                                            where CollaborationGroupId in:setCoChGrpId
                                                            and memberId !=: UserInfo.getUserId()
                                                            ])
              {
                  if(s.memberId != CoFac.FA_Facilitator__c)
                  {
                   flag=true;       
                  }
              
                  else flag=false;
              }  
      test.stopTest();     
                                                  
       system.assertEquals(false,flag);
    
   }
     
     static testMethod void TestAssocFacilitatorsToMemberGroup(){
           
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='hjgfc';
            ObjUser.Email='hjgfc'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='hjgfc'+'@unilever.com.compass';
            ObjUser.CommunityNickname='hjgfc';
            ObjUser.Alias='hjgfc';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
           
            insert ObjUser;
        
            FA_Course__c objCourse =new FA_Course__c();
            
            objCourse.FA_status__c='Active';
            objCourse.FA_Course_Code__c='45807';
            objCourse.FA_Course_Logo__c='https://unilever--adfs--c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000EB31&oid=00Dc0000001KMA0&lastMod=1366285875000';
            objCourse.FA_Course_Overview__c='testCourse Overview';
            
            insert objCourse;
            
            FA_Training_Venue__c ObjTrVenue =new FA_Training_Venue__c();
             
            ObjTrVenue.Name='TestVenue'; 
            ObjTrVenue.FA_Image_URL__c='testurl@unilever.com';
            ObjTrVenue.FA_Address_Line_1__c='Whitefield';
            ObjTrVenue.FA_Country__c='India';
            ObjTrVenue.FA_Town_City__c='Bangalore';
            ObjTrVenue.FA_Overview__c='Testing CentresPage';
            ObjTrVenue.FA_Travel_Information__c='Testing Centres_TravelInformation';
             
             insert ObjTrVenue;
             
            FA_Training_Room__c ObjTRoom=new FA_Training_Room__c();
                
            ObjTRoom.FA_Active__c=true;
            ObjTRoom.FA_Capacity__c=25;
            ObjTRoom.FA_Room_Number__c='12';
            ObjTRoom.FA_Training_Venue__c=ObjTrVenue.Id;
             
            insert ObjTRoom;  
           
            FA_Course_Occurence__c ObjCoOcc=new FA_Course_Occurence__c();
         
            ObjCoOcc.FA_Course__c=objCourse.id;
            ObjCoOcc.FA_Training_Room__c=ObjTRoom.Id;
            ObjCoOcc.FA_Training_Venue__c=ObjTRoom.FA_Training_Venue__c;
            ObjCoOcc.FA_Initiate_Feedback__c=false;
            ObjCoOcc.FA_Status__c='Active';
            ObjCoOcc.FA_Start_Date_Time__c=system.today();
            ObjCoOcc.FA_End_Date_Time__c=system.today()+1;
            ObjCoOcc.FA_Pre_Work_Start_Date__c=system.today()-7;
            ObjCoOcc.FA_Post_Prog_End_Date__c=system.today()+7;
            
            insert ObjCoOcc;
            
            FA_Occurence_Member__c ObjOccMember =new FA_Occurence_Member__c();
            ObjOccMember.FA_New_Arrival_Date__c = system.today();            
            ObjOccMember.FA_Participant_Instructor__c=ObjUser.id;            
            ObjOccMember.FA_Arrival_Information__c='Airport car transfer';
            ObjOccMember.FA_Course_Occurence__c=ObjCoOcc.Id; 
            ObjOccMember.FA_New_Departure_Date__c=system.today();
            ObjOccMember.FA_Departure_Information__c='Airport car transfer';
            ObjOccMember.FA_Participation_Status__c='Invited';
            ObjOccMember.FA_Send_Feedback_Invitation__c=false;
            ObjOccMember.FA_Role__c='Participant';
            
            insert ObjOccMember; 
            
            FA_Course_Facilitator__c CoFac=new FA_Course_Facilitator__c();
            CoFac.FA_Course__c=objCourse.id;
            CoFac.FA_Role__c='Facility Manager';
            CoFac.FA_Facilitator__c=ObjUser.Id;
             
            insert CoFac;
    
     test.startTest();
   
     
         FA_Member_ChatterGroup__c memChGp=[select FA_Group_ID__c,
                                             FA_Course_Occurence__r.FA_Course__c
                                             from FA_Member_ChatterGroup__c 
                                             where FA_Course_Occurence__r.FA_Course__c=:ObjCoOcc.FA_Course__c];
           set<Id> setCoChGrpId=new set<Id>();
            
            Boolean flag;
            
        setCoChGrpId.add(memChGp.FA_Group_ID__c);  
                                        
     for(CollaborationGroupMember s:[select memberId,
                                     CollaborationGroupId 
                                     from CollaborationGroupMember
                                     where CollaborationGroupId in:setCoChGrpId
                                     and memberId !=: UserInfo.getUserId()]){
          if(s.memberId==CoFac.FA_Facilitator__c){
           flag=true;       
          }
          else flag=false;
   
    
   }
            test.stopTest();
            
            system.assertEquals(true,flag);
 }
     
     /**
          * The following method tests the After Delete Trigger on Course Occurence
          * The method  checks if the Method 'After_DeleteMembersFromGroup' 
          * has deleted the members from all the groups related to the Course Occurence.
          * when a member is deleted from the Course occurence 
          */     
           
       static testMethod void testTriggerForDelete(){
             
             Boolean checkflag;
       
         
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='bfgjp';
            ObjUser.Email='bfgjp'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='bfgjp'+'@unilever.com.compass';
            ObjUser.CommunityNickname='bfgjp';
            ObjUser.Alias='bfgjp';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
           
            insert ObjUser;
        
            FA_Course__c objCourse =new FA_Course__c();
            
            objCourse.FA_status__c='Active';
            objCourse.FA_Course_Code__c='45873';
            objCourse.FA_Course_Logo__c='https://unilever--adfs--c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000EB31&oid=00Dc0000001KMA0&lastMod=1366285875000';
            objCourse.FA_Course_Overview__c='testCourse Overview';
            
            insert objCourse;
            
            FA_Training_Venue__c ObjTrVenue =new FA_Training_Venue__c();
             
            ObjTrVenue.Name='TestVenue'; 
            ObjTrVenue.FA_Image_URL__c='testurl@unilever.com';
            ObjTrVenue.FA_Address_Line_1__c='Whitefield';
            ObjTrVenue.FA_Country__c='India';
            ObjTrVenue.FA_Town_City__c='Bangalore';
            ObjTrVenue.FA_Overview__c='Testing CentresPage';
            ObjTrVenue.FA_Travel_Information__c='Testing Centres_TravelInformation';
             
             insert ObjTrVenue;
             
            FA_Training_Room__c ObjTRoom=new FA_Training_Room__c();
                
            ObjTRoom.FA_Active__c=true;
            ObjTRoom.FA_Capacity__c=25;
            ObjTRoom.FA_Room_Number__c='12';
            ObjTRoom.FA_Training_Venue__c=ObjTrVenue.Id;
             
            insert ObjTRoom;  
           
            FA_Course_Occurence__c ObjCoOcc=new FA_Course_Occurence__c();
         
            ObjCoOcc.FA_Course__c=objCourse.id;
            ObjCoOcc.FA_Training_Room__c=ObjTRoom.Id;
            ObjCoOcc.FA_Training_Venue__c=ObjTRoom.FA_Training_Venue__c;
            ObjCoOcc.FA_Initiate_Feedback__c=false;
            ObjCoOcc.FA_Status__c='Active';
            ObjCoOcc.FA_Start_Date_Time__c=system.today();
            ObjCoOcc.FA_End_Date_Time__c=system.today()+1;
            ObjCoOcc.FA_Pre_Work_Start_Date__c=system.today()-7;
            ObjCoOcc.FA_Post_Prog_End_Date__c=system.today()+7;
            
            insert ObjCoOcc;
            
            FA_Occurence_Member__c ObjOccMember =new FA_Occurence_Member__c();
            ObjOccMember.FA_New_Arrival_Date__c = system.today();            
            ObjOccMember.FA_Participant_Instructor__c=ObjUser.id;            
            ObjOccMember.FA_Arrival_Information__c='Airport car transfer';
            ObjOccMember.FA_Course_Occurence__c=ObjCoOcc.Id; 
            ObjOccMember.FA_New_Departure_Date__c=system.today();
            ObjOccMember.FA_Departure_Information__c='Airport car transfer';
            ObjOccMember.FA_Participation_Status__c='Invited';
            ObjOccMember.FA_Send_Feedback_Invitation__c=false;
            ObjOccMember.FA_Role__c='Participant';
            
            insert ObjOccMember; 
            
            FA_Course_Facilitator__c CoFac=new FA_Course_Facilitator__c();
            CoFac.FA_Course__c=objCourse.id;
            CoFac.FA_Role__c='Course Administrator';
            CoFac.FA_Facilitator__c=ObjUser.Id;
            insert CoFac;
           
            test.startTest();
            
              delete CoFac;
              
            test.stopTest();
                 
       }    
         
 }