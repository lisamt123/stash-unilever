@isTest(SeeAllData=true)
public class FA_Test_PWTreminderMailBatchClass
{

    public static User ObjUser;
    public static void createPWTdata()
    {
            
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
            newPWTA.FA_Due_Date__c=system.today()+1;
            newPWTA.FA_Task_Description_PWTA__c='Test description';
            newPWTA.FA_Task_Name_PWTA__c='Test Task Name';

            insert newPWTA;

            List<FA_Pre_Work_Task__c> taskAtOccMem=[select id,FA_OccurenceOM__c,FA_Due_Date__c,FA_OccMember__c,FA_Occurence_Task__c,FA_Task_Name__c,FA_Task_Description__c from FA_Pre_Work_Task__c where FA_OccurenceOM__c=:ObjCoOcc.Id and FA_OccMember__c=:ObjOccMember.Id and FA_Occurence_Task__c=:newPWTA.Id and FA_Mark_Completed__c = false];
    }
    static testMethod void testPWTbatch()
    {
        createPWTdata();
        Test.StartTest();
        FA_PWTreminderMailBatchClass bCls = new FA_PWTreminderMailBatchClass();
        bCls.query += ' LIMIT 10';
        ID batchprocessid = Database.executeBatch(bCls);
        Test.StopTest();
        system.debug('%%%%%USER ID: ' +ObjUser.id );
        System.AssertEquals(
               database.countquery('SELECT COUNT() FROM FA_Pre_Work_Task__c WHERE FA_OccMember__r.FA_Participant_Instructor__c = \'' + ObjUser.id + '\''),
               1);
    }
    

}