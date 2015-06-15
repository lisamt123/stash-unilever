@isTest
public class IPM_ChannelImageController_Test{

public static  IPM_ChannelImageController ipm_channelImageController;

/*public static testMethod void getMyFileTest(){

 Test.startTest();
 ipm_channelImageController=new IPM_ChannelImageController();
 ipm_channelImageController.getmyFile();
 Test.stopTest();

}*/


public static testMethod void saveDocTestException(){

 Test.startTest();
 ipm_channelImageController=new IPM_ChannelImageController();
 ipm_channelImageController.Savedoc();
 Test.stopTest();

}

public static testMethod void saveDocTest(){

 Test.startTest();
 //PageReference pRef = new PageReference('/apex/IPM_ChannelImageController?id='+project.Id);
 //Test.setCurrentPage(pRef);
 ipm_channelImageController=new IPM_ChannelImageController();
 ipm_channelImageController.getmyFile();
 //System.debug('myfile name='+ipm_channelImageController.myfile.name);
 ipm_channelImageController.Savedoc();
 Test.stopTest();

}
}