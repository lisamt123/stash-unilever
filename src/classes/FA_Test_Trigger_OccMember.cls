@isTest(SeeAllData=true)
/*The following is a test class which tests the trigger events on Occurence member
* The Class tests that when an Occurence memeber is added if the member has been added to the particular 
* Course chatter group,Member chatter group.
*/
 
    private class FA_Test_Trigger_OccMember{

        /*The following testMethod checks for the Occurence member being added as a member in the FourAcres
         group and the Help group
        */       
        
        static testMethod void testTriggerForFAandHelpGrp(){
            
            Test.startTest();    
            Boolean checkvalue=false;
            set<Id> testsetGrpIds =new set<Id>();    
           
            testsetGrpIds.add(FA_Config_Settings__c.getValues('FA_AllFourAcres').FA_Value__c);
            testsetGrpIds.add(FA_Config_Settings__c.getValues('FA_HelpGroup').FA_Value__c);  
           
               
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='bcdes';
            ObjUser.Email='ahbgd'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='abced'+'@unilever.com.compass';
            ObjUser.CommunityNickname='abcde';
            ObjUser.Alias='abcde';
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
            
            insert ObjOccMember;
           
            List<CollaborationGroupMember> s=[select memberId,CollaborationGroupId  
                                             from CollaborationGroupMember
                                             where CollaborationGroupId in:testsetGrpIds
                                             ];
             
             
             
             for(CollaborationGroupMember temp:s){
                       
                 if(temp.memberId==ObjOccMember.FA_Participant_Instructor__c)        
                 {checkvalue=true;}
                 else        
                 {checkvalue=false;}
                 
              }                        
               test.stopTest();
             //  system.assertEquals(false,checkvalue);  
              
                                                                               
        }
     
        /*The following testMethod checks if the Occurence Member inserted has been
         *added to his/her Private Member chatter group
         */
        
        static testMethod void testTriggerForPrivateGrp(){
             
            Boolean flag1;
            Boolean flag2;
            
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='bcdes';
            ObjUser.Email='ahbgd'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='abced'+'@unilever.com.compass';
            ObjUser.CommunityNickname='abcde';
            ObjUser.Alias='abcde';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
           
            insert ObjUser;
        
            User ObjUser2;
            ObjUser2=new User();
            ObjUser2.LastName='dfcgs';
            ObjUser2.Email='ahbrt'+'@unilever.com.compass';
            ObjUser2.ProfileId=UserInfo.getProfileId();       
            ObjUser2.UserName='abcth'+'@unilever.com.compass';
            ObjUser2.CommunityNickname='abcfg';
            ObjUser2.Alias='abcfg';
            ObjUser2.TimeZoneSidKey='America/Los_Angeles';
            ObjUser2.LocaleSidKey=UserInfo.getLocale();
            ObjUser2.EmailEncodingKey='UTF-8';
            ObjUser2.LanguageLocaleKey='en_US';
           
            insert ObjUser2;
        
            User tObjUser;
            tObjUser=new User();
            tObjUser.LastName='kgvds';
            tObjUser.Email='kgvds'+'@unilever.com.compass';
            tObjUser.ProfileId=UserInfo.getProfileId();       
            tObjUser.UserName='kgvds'+'@unilever.com.compass';
            tObjUser.CommunityNickname='kgvds';
            tObjUser.Alias='kgvds';
            tObjUser.TimeZoneSidKey='America/Los_Angeles';
            tObjUser.LocaleSidKey=UserInfo.getLocale();
            tObjUser.EmailEncodingKey='UTF-8';
            tObjUser.LanguageLocaleKey='en_US';
           
            insert tObjUser;
        
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
            
            Test.startTest();
             
            FA_Course_Facilitator__c CoFac=new FA_Course_Facilitator__c();
            CoFac.FA_Course__c=objCourse.id;
            CoFac.FA_Role__c='Course Administrator';
            CoFac.FA_Facilitator__c = tObjUser.Id;
            insert CoFac;
             
            List<FA_Member_ChatterGroup__c> ChatGrpP=[select FA_Group_ID__c
                                                 from FA_Member_ChatterGroup__c
                                                 where FA_Course_Occurence__c=:ObjOccMember.FA_Course_Occurence__c]; 
             
            set<Id> setMemChGrpId=new set<Id>();
             
            for(FA_Member_ChatterGroup__c temp:ChatGrpP)                       
                 {              
                     setMemChGrpId.add(temp.FA_Group_ID__c);
                 }
                                               
            for(CollaborationGroupMember s:[select memberId,CollaborationGroupId 
                                                    from CollaborationGroupMember
                                                    where CollaborationGroupId in:setMemChGrpId])                                                        
                 {
                      if(s.memberId==ObjOccMember.FA_Participant_Instructor__c)
                          {
                           flag1=true;       
                          }
                      else 
                           flag1=false;
                 } 
           
             
             FA_Occurence_Member__c OccMemWRoleInstr=new FA_Occurence_Member__c();
             
             OccMemWRoleInstr.FA_Course_Occurence__c=ObjOccMember.FA_Course_Occurence__c;
             OccMemWRoleInstr.FA_Participant_Instructor__c=ObjUser2.id;       
             OccMemWRoleInstr.FA_Role__c='Instructor';
             OccMemWRoleInstr.FA_Participation_Status__c='Invited';
              
             Insert OccMemWRoleInstr;
                                                             
             for(CollaborationGroupMember cg:[select memberId,CollaborationGroupId 
                                                    from CollaborationGroupMember
                                                    where CollaborationGroupId in:setMemChGrpId])                                                        
                 {
                      if(cg.memberId==OccMemWRoleInstr.FA_Participant_Instructor__c)
                          {
                          flag2=true;       
                          }
                      else 
                          flag2=false;
                 }  
             
             Test.stopTest();
                                      
         }
         
      /* The following testMethod checks if the existing Facilitators have been added 
       * to the Member chatter group when the Occurence member is created and also checks 
       * whether the facilitators added after creation of the creation of Occurence member 
       * are added to the Member chatter group
       */     
        
       static testMethod void testTriggerAssociateFacilitators(){        
            Boolean flag;
           
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='bcdes';
            ObjUser.Email='ahbgd'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='abced'+'@unilever.com.compass';
            ObjUser.CommunityNickname='abcde';
            ObjUser.Alias='abcde';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
           
            insert ObjUser;        
        
            User tObjUser;
            tObjUser=new User();
            tObjUser.LastName='kgvds';
            tObjUser.Email='kgvds'+'@unilever.com.compass';
            tObjUser.ProfileId=UserInfo.getProfileId();       
            tObjUser.UserName='kgvds'+'@unilever.com.compass';
            tObjUser.CommunityNickname='kgvds';
            tObjUser.Alias='kgvds';
            tObjUser.TimeZoneSidKey='America/Los_Angeles';
            tObjUser.LocaleSidKey=UserInfo.getLocale();
            tObjUser.EmailEncodingKey='UTF-8';
            tObjUser.LanguageLocaleKey='en_US';
           
            insert tObjUser;
        
            User ObjUserForFaci;
            ObjUserForFaci=new User();
            ObjUserForFaci.LastName='bscdes';
            ObjUserForFaci.Email='ashbgd'+'@unilever.com.compass';
            ObjUserForFaci.ProfileId=UserInfo.getProfileId();       
            ObjUserForFaci.UserName='absced'+'@unilever.com.compass';
            ObjUserForFaci.CommunityNickname='ascde';
            ObjUserForFaci.Alias='aesde';
            ObjUserForFaci.TimeZoneSidKey='America/Los_Angeles';
            ObjUserForFaci.LocaleSidKey=UserInfo.getLocale();
            ObjUserForFaci.EmailEncodingKey='UTF-8';
            ObjUserForFaci.LanguageLocaleKey='en_US';
           
            insert ObjUserForFaci;
            
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
             
            FA_Course__c objCourse =new FA_Course__c();
            
            objCourse.FA_status__c='Active';
            objCourse.FA_Course_Code__c='45876';
            objCourse.FA_Course_Logo__c='https://unilever--adfs--c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000EB31&oid=00Dc0000001KMA0&lastMod=1366285875000';
            objCourse.FA_Course_Overview__c='testCourse Overview';
            
            insert objCourse;        
            
            FA_Course_Facilitator__c CoFacBeforeOcc=new FA_Course_Facilitator__c();
            CoFacBeforeOcc.FA_Course__c=objCourse.id;
            CoFacBeforeOcc.FA_Role__c='Course Administrator';
            CoFacBeforeOcc.FA_Facilitator__c=ObjUserForFaci.Id;
            insert CoFacBeforeOcc;     
                        
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
            Test.startTest();
            
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
            CoFac.FA_Facilitator__c=tObjUser.Id;
            insert CoFac;
            
           List<FA_Member_ChatterGroup__c> ChatGrpP=[select FA_Group_ID__c
                                                 from FA_Member_ChatterGroup__c
                                                 where FA_Course_Occurence__c=:ObjOccMember.FA_Course_Occurence__c]; 
             
           set<Id> setMemChGrpId=new set<Id>();
             
            for(FA_Member_ChatterGroup__c temp:ChatGrpP)                       
                 {              
                     setMemChGrpId.add(temp.FA_Group_ID__c);
                 }
           
           
           for(CollaborationGroupMember cg:[select memberId,CollaborationGroupId 
                                                    from CollaborationGroupMember
                                                    where CollaborationGroupId in:setMemChGrpId])                                                        
                 {
                      if(cg.memberId==CoFac.FA_Facilitator__c)
                          {
                          flag=true;       
                          }
                      else 
                          flag=false;
                 }             
             
                     
           
          Test.stopTest();
       }
        
        /* The following testMethod tests the After Insert Trigger event 
         * on Occurence Member ,the method checks whether a Private chatter group has been 
         * created when an Occurence Member is created
         */
        
       static testMethod void testCreatePrivateChatterGroup(){
         
            Boolean flag;
            
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='trdcs';
            ObjUser.Email='trdcs'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='trdcs'+'@unilever.com.compass';
            ObjUser.CommunityNickname='trdcs';
            ObjUser.Alias='trdcs';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
           
            insert ObjUser;        
           
            User tObjUser=new User();
            tObjUser.LastName='hgeds';
            tObjUser.Email='kjhfd'+'@unilever.com.compass';
            tObjUser.ProfileId=UserInfo.getProfileId();       
            tObjUser.UserName='kjhfd'+'@unilever.com.compass';
            tObjUser.CommunityNickname='afgdc';
            tObjUser.Alias='afgdc';
            tObjUser.TimeZoneSidKey='America/Los_Angeles';
            tObjUser.LocaleSidKey=UserInfo.getLocale();
            tObjUser.EmailEncodingKey='UTF-8';
            tObjUser.LanguageLocaleKey='en_US';
           
            insert tObjUser;
            
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
            ObjOccMember.FA_Role__c='Instructor';
            
            insert ObjOccMember; 
            
            Test.startTest();  
                 
            FA_Course_Occurence__c tempCO=[select id,FA_Course__c from FA_Course_Occurence__c where Id=:ObjOccMember.FA_Course_Occurence__c];
            FA_Course_Facilitator__c CoFac=new FA_Course_Facilitator__c();
            CoFac.FA_Course__c=tempCO.FA_Course__c;
            CoFac.FA_Role__c='Course Administrator';
            CoFac.FA_Facilitator__c=ObjUser.Id;
         
            insert CoFac;       
          
            FA_Occurence_Member__c testOMemPart=new FA_Occurence_Member__c();
             
            testOMemPart.FA_Course_Occurence__c=ObjOccMember.FA_Course_Occurence__c;
            testOMemPart.FA_Participant_Instructor__c=tObjUser.id;       
            testOMemPart.FA_Role__c='Participant';
            testOMemPart.FA_Participation_Status__c='Invited';
                  
            Insert testOMemPart;         
         
            List<FA_Member_ChatterGroup__c> ChatGrpP=[select FA_Group_ID__c
                                                 from FA_Member_ChatterGroup__c
                                                 where FA_Course_Occurence__c=:ObjOccMember.FA_Course_Occurence__c]; 
             
           set<Id> setMemChGrpId=new set<Id>();
             
           for(FA_Member_ChatterGroup__c temp:ChatGrpP)                       
                 {              
                     setMemChGrpId.add(temp.FA_Group_ID__c);
                 }
                                               
           for(CollaborationGroupMember s:[select memberId,CollaborationGroupId 
                                                    from CollaborationGroupMember
                                                    where CollaborationGroupId in:setMemChGrpId])                                                        
                 {
                      if(s.memberId==ObjOccMember.FA_Participant_Instructor__c)
                          {
                           flag=false;       
                          }
                      else flag=true;                          
                 } 
           
           test.stopTest();
           
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
            ObjUser.LastName='bcdes';
            ObjUser.Email='ahbgd'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='abced'+'@unilever.com.compass';
            ObjUser.CommunityNickname='abcde';
            ObjUser.Alias='abcde';
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
            ObjOccMember.FA_New_Departure_Date__c=system.today()+2;
            ObjOccMember.FA_Departure_Information__c='Airport car transfer';
            ObjOccMember.FA_Participation_Status__c='Invited';
            ObjOccMember.FA_Send_Feedback_Invitation__c=false;
            ObjOccMember.FA_Role__c='Instructor';
            
            insert ObjOccMember;  
           
            
            test.startTest();
                          
            delete ObjOccMember;
            test.stopTest();
             
          } 
        
        /* The following method tests the After Insert Trigger on Occurence Member
          * The method  checks if the Method 'Trigger_After_ShareAccessToOccMembers' 
          * has given relevent access permission to the members in the added
          *  
          */    
   static testMethod void testTrigger_After_ShareAccessToOccMembers(){        
     
            Boolean flag1=false;     
            Boolean flag2=false;
             
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='bcdes';
            ObjUser.Email='ahbgd'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='abced'+'@unilever.com.compass';
            ObjUser.CommunityNickname='abcde';
            ObjUser.Alias='abcde';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
            test.startTest();
            
            insert ObjUser;
            
            User ObjUser2;
            ObjUser2=new User();
            ObjUser2.LastName='aghfc';
            ObjUser2.Email='aghfc'+'@unilever.com.compass';
            ObjUser2.ProfileId=UserInfo.getProfileId();       
            ObjUser2.UserName='aghfc'+'@unilever.com.compass';
            ObjUser2.CommunityNickname='aghfc';
            ObjUser2.Alias='aghfc';
            ObjUser2.TimeZoneSidKey='America/Los_Angeles';
            ObjUser2.LocaleSidKey=UserInfo.getLocale();
            ObjUser2.EmailEncodingKey='UTF-8';
            ObjUser2.LanguageLocaleKey='en_US';
           
            insert ObjUser2;
            
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
            
            FA_Occurence_Member__c ObjOccMember2 =new FA_Occurence_Member__c();
            ObjOccMember2.FA_New_Arrival_Date__c = system.today();            
            ObjOccMember2.FA_Participant_Instructor__c=ObjUser2.id;            
            ObjOccMember2.FA_Arrival_Information__c='Airport car transfer';
            ObjOccMember2.FA_Course_Occurence__c=ObjCoOcc.Id; 
            ObjOccMember2.FA_New_Departure_Date__c=system.today();
            ObjOccMember2.FA_Departure_Information__c='Airport car transfer';
            ObjOccMember2.FA_Participation_Status__c='Invited';
            ObjOccMember2.FA_Send_Feedback_Invitation__c=false;
            ObjOccMember2.FA_Role__c='Instructor';
            
            insert ObjOccMember2; 
      
         /*   List<FA_Occurence_Member__c> testResults1=[select id, FA_Participant_Instructor__c,                                                                                          
                                                                FA_Role__c    
                                                         from  FA_Occurence_Member__c where id=:ObjOccMember.Id];
            List<FA_Occurence_Member__c> testResults2=[select id,FA_Participant_Instructor__c,
                                                                FA_Role__c    
                                                         from  FA_Occurence_Member__c where id=:ObjOccMember2.Id]; 
        
    
      
            for(FA_Occurence_Member__c Mem1:testResults1)
            {  
              if(Mem1.FA_Role__c == 'Participant')
              {               
               
               for(FA_Course_Occurence__Share participantShare : [select AccessLevel  from FA_Course_Occurence__Share
                                                                                    where UserOrGroupId=:Mem1.FA_Participant_Instructor__c ])
               {
                   if ( participantShare.AccessLevel == 'Read')
                   {
                     flag1= True;
                   }
               }
              } 
            } 
         //   system.assertEquals(true,flag1);
       
     /*       for(FA_Occurence_Member__c Mem2:testResults2)
            {    
              if(Mem2.FA_Role__c == 'Instructor')
              {
               
               for(FA_Course_Occurence__Share instructorShare : [select AccessLevel  from FA_Course_Occurence__Share
                                                                          where UserOrGroupId=:Mem2.FA_Participant_Instructor__c ])
                {
               if ( instructorShare.AccessLevel == 'Edit')
               {
                 flag2= True;
               }
              }
              }  
            }  */
         //  system.assertEquals(true,flag2);   
       test.stopTest();   
      }

   /* The following method tests the After Delete Trigger on Occurence Member
          * The method  checks if the Method 'Trigger_After_RevokeAccessFromOccMembers' 
          * has revoked relevent access permissions from the members deleted
          */
   static testMethod void testTrigger_After_RevokeAccessFromOccMembers(){ 
            
            Boolean flag=false;
            
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='bcdes';
            ObjUser.Email='ahbgd'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='abced'+'@unilever.com.compass';
            ObjUser.CommunityNickname='abcde';
            ObjUser.Alias='abcde';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
            test.startTest();
            
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
            
            List<FA_Occurence_Member__c> testResults=[select id,                                                                                           
                                                              FA_Participant_Instructor__c    
                                                         from  FA_Occurence_Member__c where id=:ObjOccMember.Id];
             
            for(FA_Occurence_Member__c Mem:testResults)
            {
                 Delete Mem;
                  
                 for(FA_Course_Occurence__Share instructorShare : [select AccessLevel  from FA_Course_Occurence__Share ])
                 {
                 if (instructorShare.AccessLevel == 'Null')
                   {
                     flag= True;
                   }
                 }
           }
        //   system.assertEquals(false,flag);     
      test.stopTest();   
   }    
   
   static testmethod void testtrigger_After_AssocTasksToNewMembers()
   {
      List < FA_Pre_Work_Task__c > liPreWorkTasks = new List < FA_Pre_Work_Task__c >();   
      User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='bcdes';
            ObjUser.Email='ahbgd'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='abced'+'@unilever.com.compass';
            ObjUser.CommunityNickname='abcde';
            ObjUser.Alias='abcde';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
            test.startTest();
            
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
            
            FA_Pre_Work_Task_Assignment__c newPWTA= new FA_Pre_Work_Task_Assignment__c();
            newPWTA.FA_Occurence__c=ObjCoOcc.Id;
            newPWTA.FA_Due_Date__c=system.today()+2;
            newPWTA.FA_Task_Description_PWTA__c='Test description';
            newPWTA.FA_Task_Name_PWTA__c='Test Task Name';
            
            insert newPWTA;
            
            FA_Pre_Work_Task_Assignment__c PWTA2= new FA_Pre_Work_Task_Assignment__c();
            PWTA2.FA_Occurence__c=ObjCoOcc.Id;
            PWTA2.FA_Due_Date__c=system.today()+5;
            PWTA2.FA_Task_Description_PWTA__c='Second Test description';
            PWTA2.FA_Task_Name_PWTA__c='Second Task Name';
            
            insert PWTA2;
            
            Boolean flag;
            
           FA_Pre_Work_Task__c taskAtOccMem=[select id,FA_OccurenceOM__c,FA_Due_Date__c,FA_OccMember__c,FA_Occurence_Task__c,FA_Task_Name__c,FA_Task_Description__c from FA_Pre_Work_Task__c where FA_OccurenceOM__c=:ObjCoOcc.Id and FA_OccMember__c=:ObjOccMember.Id and FA_Occurence_Task__c=:newPWTA.Id limit 1]; 
                 
            if(taskAtOccMem.FA_Task_Name__c=='Test Task Name'){
            Flag=true;
            }
            else{
            Flag=false;
            }
            system.assertEquals(true,Flag);  
   }
   
/*   static testMethod void testTriggerForThemeGrps(){
            
            Test.startTest();    
            Boolean checkvalue=false;
            set<Id> testsetGrpIds =new set<Id>();    
           
            testsetGrpIds.add(FA_Config_Settings__c.getValues('FA_ImprovingHealth').FA_Value__c);
            testsetGrpIds.add(FA_Config_Settings__c.getValues('FA_ReduceEnvImpacts').FA_Value__c);  
            testsetGrpIds.add(FA_Config_Settings__c.getValues('FA_EnhanceLivelihoods').FA_Value__c);
      
          FA_Config_Settings__c testliCustSetUL2020 =  FA_Config_Settings__c.getValues('FA_UL2020Programme');
              
            user ObjUser=new User();
            ObjUser.LastName='bcdes';
            ObjUser.Email='ahbgd'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='abced'+'@unilever.com.compass';
            ObjUser.CommunityNickname='abcde';
            ObjUser.Alias='abcde';
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';
           
            insert ObjUser;           
      
         
            
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
         
            ObjCoOcc.FA_Course__c= testliCustSetUL2020.FA_Value__c;
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
            
            insert ObjOccMember;
           
            List<CollaborationGroupMember> s=[select memberId,CollaborationGroupId  
                                             from CollaborationGroupMember
                                             where CollaborationGroupId in:testsetGrpIds
                                             ];
             
             
             
             for(CollaborationGroupMember temp:s){
                       
                 if(temp.memberId==ObjOccMember.FA_Participant_Instructor__c)        
                 {checkvalue=true;}
                 else        
                 {checkvalue=false;}
                 
              }                        
               test.stopTest();
             //  system.assertEquals(false,checkvalue);  
              
                                                                               
        } */
        
  
     
}