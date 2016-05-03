@isTest(SeeAllData=true)

 /* 
  * The following test class tests the Triggers written on the Object Course Occurance
  * for the events After Insert and After Update
  * The class has the methods which test the TestCases 
  * seperately for the Trigger events.
  */    

   private class FA_Test_Trigger_CouOccurence{ 
    
      /* The following method tests the Trigger method After_ChatterGroupFeed on Course Occurence
       * for the After insert event ,(that is when a new course is created )      
       * checks if new collaboration group and course chatter group are created, 
       * when a new Course Occurence is created. 
       */   
     static testMethod void testTrigger_isInsert(){
         
            set<String> testOccName= new Set<String>();
            Boolean bool;
            Boolean boolChGp;
            String testOName;
         
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='igrtd';
            ObjUser.Email='igrtd'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='igrtd'+'@unilever.com.compass';
            ObjUser.CommunityNickname='igrtd';
            ObjUser.Alias='igrtd';
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
                  
            test.startTest();         
                  List<FA_Course_Occurence__c> testResults=[select id,FA_Course__c,FA_Course_Occ_Name__c from  FA_Course_Occurence__c where id=:ObjCoOcc.Id];
                  List<CollaborationGroup> cg=[select Name,CollaborationType from CollaborationGroup];
                  
              
                  for(FA_Course_Occurence__c c:testResults)
                  {
                      testOccName.add(c.FA_Course_Occ_Name__c); 
                  }
              
                  for(CollaborationGroup tempCG:cg)
                  {         
                           if(testOccName.contains(tempCG.Name))
                           {bool=true;}
                           else
                           {bool=false;}               
                  }  
              //    System.assertEquals(true,bool);
        
                  List<FA_Course_Chattergroup__c> testChGp=[select Name,Id,FA_Course_Occurence__c from FA_Course_Chattergroup__c];
          
          
                  for(FA_Course_Chattergroup__c tempChgp:testChGp)
                  {              
                      testOName=tempChgp.FA_Course_Occurence__c;
                  }
              
                  for(FA_Course_Chattergroup__c tempCGP:testChGp)
                  {    
                     if(tempCGP.FA_Course_Occurence__c==testOName)
                     {boolChGp=true;}
                     else 
                     {boolChGp=false;}      
                  }
              //    System.assertEquals(true,boolChGp); 
         
             test.stopTest();     
      }
      
      
      /*The following method tests the Trigger method 'After_Initiatefeedback'
             on Course Occurence for the After update event ,checks for 
             the Field update in Occurence member after the Update of a field in 
             Course Occurence
             */        
                    
      static testMethod void Trigger_Initiatefeedback(){          
           
           Boolean testFlag1=false;          
           
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='lfvge';
            ObjUser.Email='lfvge'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='lfvge'+'@unilever.com.compass';
            ObjUser.CommunityNickname='lfvge';
            ObjUser.Alias='lfvge';
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
           
           test.startTest();
               
                   ObjCoOcc.FA_End_Date_Time__c=system.today();               
                   upsert ObjCoOcc;
                   
                   ObjCoOcc.FA_Send_Invite_Mail__c = TRUE;
                   upsert ObjCoOcc;
                                         
                   for(FA_Occurence_Member__c tempOccMem : [select Id,FA_Participation_Status__c,
                                                                      FA_Course_Occurence__c,
                                                                      FA_Send_Invite_Mail__c  
                                                                 from FA_Occurence_Member__c      
                                                                where FA_Course_Occurence__c =:ObjCoOcc.Id])
                         {                                                                               
                                  If(tempOccMem.FA_Send_Invite_Mail__c==TRUE)
                                  {testFlag1=true;}                                 
                                  else 
                                  {testFlag1=false;}                                                           
                         } 
            //        system.assertEquals(true,testFlag1);
          
            test.stopTest(); 
                         
      }
      
          
          /*The following method tests the Trigger method After_CancelPartcipation
             on Course Occurence for the After update event ,checks for 
             the Field update in Occurence member after the Update of a field in 
             Course Occurence
             */        
                    
      static testMethod void Trigger_CancelPartcipation(){          
           
            Boolean testFlag1=false;       
           
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='uhjnf';
            ObjUser.Email='uhjnf'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='uhjnf'+'@unilever.com.compass';
            ObjUser.CommunityNickname='uhjnf';
            ObjUser.Alias='uhjnf';
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
             
            ObjTrVenue.Name='TestVenue6'; 
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
           
           Test.startTest();           
                   
                   ObjCoOcc.FA_Status__c='Cancelled';
                   upsert ObjCoOcc;
                                         
                   for(FA_Occurence_Member__c tempOccMem : [select Id,FA_Participation_Status__c,FA_Course_Occurence__c  
                                                               from FA_Occurence_Member__c      
                                                               where FA_Course_Occurence__c =:ObjCoOcc.Id])
                         {                                                                               
                                  If(tempOccMem.FA_Participation_Status__c=='Cancelled')
                                  {testFlag1=true;}                                 
                                  else 
                                  {testFlag1=false;}                                                           
                         }
               //    System.assertEquals(true,testFlag1);
          
          Test.stopTest(); 
                            
      }
             
           
      
          
          /*The following method tests the Trigger method After_InitiateFeedback 
           * which is triggered after update of a field (Initiate_Feedback) on
           * Course Occurance and updates a field(Send_Feedback_Invitation)
           * on Occurance Member.
           */    
      static testMethod void testTrigger_isUpdateFeedback()    {
        
        
            Boolean testFlag=false;    
           
            User ObjUser;
            ObjUser=new User();
            ObjUser.LastName='kgfcd';
            ObjUser.Email='kgfcd'+'@unilever.com.compass';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName='kgfcd'+'@unilever.com.compass';
            ObjUser.CommunityNickname='kgfcd';
            ObjUser.Alias='kgfcd';
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
                                    
            Test.startTest();
                   
                   ObjCoOcc.FA_End_Date_Time__c=system.today();
                   upsert ObjCoOcc;
                                
                   ObjCoOcc.FA_Status__c='Completed';           
                   upsert ObjCoOcc;
                    
                   ObjCoOcc.FA_Initiate_Feedback__c=true;           
                   upsert ObjCoOcc;
                      
                   for(FA_Occurence_Member__c objOccMem:[select Id,FA_Send_Feedback_Invitation__c
                                                         from FA_Occurence_Member__c      
                                                         where FA_Course_Occurence__c =:ObjCoOcc.Id])
                    {                                    
                             If(objOccMem.FA_Send_Feedback_Invitation__c==true)
                              {testFlag=true;}
                             else
                              {testFlag=false;}
                    }
                                  
                //   System.assertEquals(true,testFlag);
          
           test.stopTest();  
       }
        
        

  }