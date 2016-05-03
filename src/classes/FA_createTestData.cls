/**
*This is the utility class for creating Test data.
*/
@isTest
public class FA_createTestData
{
        /**
        *This method creates and returns a user.
        *It requires UNIQUE Alias as input.
        */
        public static User createUser(String aliasId)
        {
            User ObjUser=new User();
            
            ObjUser.LastName='Test' + aliasId;
            ObjUser.Email=aliasId+'@test.com';
            ObjUser.ProfileId=UserInfo.getProfileId();       
            ObjUser.UserName=aliasId+'@test.com';
            ObjUser.CommunityNickname='Test' + aliasId;
            ObjUser.Alias=aliasId;
            ObjUser.TimeZoneSidKey='America/Los_Angeles';
            ObjUser.LocaleSidKey=UserInfo.getLocale();
            ObjUser.EmailEncodingKey='UTF-8';
            ObjUser.LanguageLocaleKey='en_US';                                  

            insert ObjUser;
            return ObjUser;
        }

        /**
        This method creates and returns a Course.
        It requires a UNIQUE Course Code as Input
        */          
        public static FA_Course__c createCourse(String courseCode)
        {
            FA_Course__c objCourse =new FA_Course__c();
            
            objCourse.FA_status__c='Active';
            objCourse.FA_Course_Code__c= courseCode;
            objCourse.FA_Course_Logo__c='https://unilever--adfs--c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000EB31&oid=00Dc0000001KMA0&lastMod=1366285875000';
            objCourse.FA_Course_Overview__c='testCourse Overview';

            insert objCourse;
            return objCourse;
        }

        /**
        *This method creates and returns a Training Venue.
        *It requires a VENUE NAME as input.
        */
        public static FA_Training_Venue__c createTrainVenue(String venueName)
        {
            FA_Training_Venue__c ObjTrVenue =new FA_Training_Venue__c();
             
            ObjTrVenue.Name=venueName; 
            ObjTrVenue.FA_Image_URL__c=venueName + 'testurl@unilever.com';
            ObjTrVenue.FA_Address_Line_1__c='Whitefield';
            ObjTrVenue.FA_Country__c='India';
            ObjTrVenue.FA_Town_City__c='Bangalore';
            ObjTrVenue.FA_Overview__c='Testing CentresPage';
            ObjTrVenue.FA_Travel_Information__c='Testing Centres_TravelInformation';

             insert ObjTrVenue;
             return ObjTrVenue;
        }

        /**
        This method creates and returns a Training Room.
        It requires a Training Venue ID as input.
        */      
        public static FA_Training_Room__c createTrainRoom(Id trainingVenueId)
        {
            FA_Training_Room__c ObjTRoom=new FA_Training_Room__c();
                
            ObjTRoom.FA_Active__c=true;
            ObjTRoom.FA_Capacity__c=25;
            ObjTRoom.FA_Room_Number__c='12';
            ObjTRoom.FA_Training_Venue__c=trainingVenueId;

            insert ObjTRoom;
            return ObjTRoom;
        }

        /**
        *This method creates and returns Course Occurrence.
        *It requires a COURSE ID, TRAINING ROOM ID, and related TRAINING VENUE ID as inputs.
        */      
        public static FA_Course_Occurence__c createCoOcc(Id courseId, Id trainingRoomId,Id trainingVenueId)
        {
            FA_Course_Occurence__c ObjCoOcc=new FA_Course_Occurence__c();
         
            ObjCoOcc.FA_Course__c=courseId;
            ObjCoOcc.FA_Training_Room__c=trainingRoomId;
            ObjCoOcc.FA_Training_Venue__c=trainingVenueId;
            ObjCoOcc.FA_Initiate_Feedback__c=false;
            ObjCoOcc.FA_Status__c='Active';
            ObjCoOcc.FA_Start_Date_Time__c=system.today();
            ObjCoOcc.FA_End_Date_Time__c=system.today()+1;
            ObjCoOcc.FA_Pre_Work_Start_Date__c=system.today()-7;
            ObjCoOcc.FA_Post_Prog_End_Date__c=system.today()+7;

            insert ObjCoOcc;
            return ObjCoOcc;            
        }

        /**
        *This method creates and returns Occurrence Member.
        *It requires USER ID and COURSE OCCURRENCE ID as inputs.
        */      
        public static FA_Occurence_Member__c createOccMem(Id userId, Id courseOccId)
        {
            FA_Occurence_Member__c ObjOccMember =new FA_Occurence_Member__c();
            
            ObjOccMember.FA_New_Arrival_Date__c = system.today();
            ObjOccMember.FA_New_Arrival_Date_Time__c = String.ValueOf(system.today());
            ObjOccMember.FA_New_Arrival_Time__c = String.ValueOf(system.now().time());
            ObjOccMember.FA_New_Departure_Date__c=system.today();
            ObjOccMember.FA_New_Depart_Date_Time__c=String.ValueOf(system.today());
            ObjOccMember.FA_New_Depart_Time__c = String.ValueOf(system.now().time());
            ObjOccMember.FA_Participant_Instructor__c=userId;
            ObjOccMember.FA_Arrival_Information__c='Airport car transfer';
            ObjOccMember.FA_Course_Occurence__c=courseOccId; 
            ObjOccMember.FA_Departure_Information__c='Airport car transfer';
            ObjOccMember.FA_Participation_Status__c='Invited';
            ObjOccMember.FA_Send_Feedback_Invitation__c=false;
            ObjOccMember.FA_Role__c='Participant';

            insert ObjOccMember;
            return ObjOccMember;
        }

        /**
        *This method creates and returns Course Facilitator.
        *It requires USER ID and COURSE ID as inputs.
        */      
        public static FA_Course_Facilitator__c createCoFac(Id userId, Id courseId)
        {
            FA_Course_Facilitator__c CoFac=new FA_Course_Facilitator__c();
            
            CoFac.FA_Course__c=courseId;
            CoFac.FA_Role__c='Course Administrator';
            CoFac.FA_Facilitator__c=userId;

            insert CoFac;
            return CoFac;
        }
        /**
         * This method creates and returns Course Attachments
         * It requires COURSE ID and ATTACHMENT TYPE as inputs.
         */
        public static Course_Attachment__c createCoAtt(Id courseId, String attachType)
        {
            Course_Attachment__c coAttach = new Course_Attachment__c();
            coAttach.Attachment_type__c=attachType;
            coAttach.Course__c=courseId;
            coAttach.FA_Download_Available_From__c=system.today()-1;
                        
            insert coAttach;
            
            Attachment att = new Attachment();
            att.ParentId = coAttach.Id;
            att.Name='Test' + attachType;
            att.Body=Blob.valueOf('Test');
            att.ContentType='text/plain';
            
            insert att;
            
            return coAttach;
        }
        /**
         * This method creates and returns Course Chatter Group.
         *It requires GROUP NAME, COURSE OCCURRENCE ID and CUSTOM SETTINGS NAME VALUE as inputs.
         */
        public static FA_Course_ChatterGroup__c createCoChatGrp(String grpName,Id courseOccId,String grpId)
        {
            FA_Course_ChatterGroup__c coChatGrp=new FA_Course_ChatterGroup__c();
            coChatGrp.FA_Chatter_Group_Name__c=grpName;
            coChatGrp.FA_Course_Occurence__c=courseOccId;
            coChatGrp.FA_Group_ID__c=grpId;
        
            insert coChatGrp;
            return coChatGrp;
        }
        /**
         * This method creates and returns Pre-Work Task Assignment.
         * It requires COURSE OCCURRENCE ID as input.
         */
        public static FA_Pre_Work_Task_Assignment__c createPWTAssig(Id courseOccId)
        {
            FA_Pre_Work_Task_Assignment__c pWTAssig= new FA_Pre_Work_Task_Assignment__c();
            pWTAssig.FA_Occurence__c=courseOccId;
            pWTAssig.FA_Due_Date__c=system.today()+1;
            pWTAssig.FA_Task_Description_PWTA__c='Test description';
            pWTAssig.FA_Task_Name_PWTA__c='Test Task Name';
            
            insert pWTAssig;
            return pWTAssig;
        }
        
        /**
         * Helper method to create a navigation Element.
         */
        public static NavigationElement__c createSideNavEle(String navName, Integer dispOrder, String profAccess)
        {
            NavigationElement__c newSideNavEle = new NavigationElement__c
            (
                Name = navName,
                PageName__c = navName,
                Url__c = '/apex/' + navName,
                Disabled__c = false,
                DisplayOrder__c = dispOrder,
                PageFilterUrl__c ='Chatter',
                Profile_Access__c = profAccess,
                Type__c  = 'sidebar'
            );
            try
                {Database.insert(newSideNavEle);}
            catch(DMLException ex)
                {ApexPages.addMessages(ex);}
    
            return newSideNavEle;
        }
    
        /**
         * Helper method to assign "Four_Acres_Participant_User" Permission Set to a User.
         */
        public static void setPS(Id UserId)
        {
            Id psId = [select id from PermissionSet where name = 'Four_Acres_Participant_User' LIMIT 1].id;
            list <PermissionSetAssignment> permSet = new list <PermissionSetAssignment>();
            permSet.add( new PermissionSetAssignment(AssigneeId = UserId,PermissionSetId = psID ) );
    
            try
                {Database.insert(permSet);}
            catch(DMLException ex)
                {ApexPages.addMessages(ex);}
        }
    
        /**
         * Helper method to create a navigation Element.
         */
        public static list<NavigationElement__c> createTopNavEle()
        {
            List<NavigationElement__c> elements = new List<NavigationElement__c>();
    
            /**  Config for default top navigation elements. **/
            
            NavigationElement__c navElement = new NavigationElement__c(
                Name = 'test',
                PageName__c = 'test',
                Type__c = NavigationManager.TOP_NAV_TYPE,
                Profile_Access__c ='FA - Facility Manager',
                Url__c = '/home/home.jsp',
                DisplayOrder__c = 1,
                Sprite_XY_Hover__c = '-31px -39px',
                Sprite_XY_Pressed__c = '-31px -39px',
                Sprite_XY_Resting__c = '1px -39px'
            );
            insert navElement ;   
            
            elements.add(navElement);
            
            NavigationElement__c navElement1 = new NavigationElement__c(
            Name = 'TestChatter',
            PageName__c = 'TestChatter',
            Type__c = NavigationManager.TOP_NAV_TYPE,
            Url__c = 'Chatter#page=feeds',
            Profile_Access__c ='FA - Facility Manager',
            DisplayOrder__c = 2,
            Sprite_XY_Hover__c = '-32px -76px',
            Sprite_XY_Pressed__c = '-32px -76px',
            Sprite_XY_Resting__c = 'left -76px'
            );
            insert navElement1 ;
            
            elements.add(navElement1);
            
            return elements ;        
         }        
}