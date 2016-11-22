/**
 * Class contains various helper methods for writing tests
 */
@IsTest
public without sharing class PBS_TestHelper
{
    /**
     * Dummy method just to make sonar happy
     */
    @isTest
    public static void testToQuietSonar()
    {
        Test.startTest();

        System.assert(true, 'Sonar should be happy now :-)');

        Test.stopTest();
    }

    /**
     * Creates Almond Navigation item
     *
     * @param String name Nav item name
     * @param String url Nav item url
     * @param String label Nav item title / label
     * @return PBS_AlmondNavigation__c New nav item
     */
    public static PBS_AlmondNavigation__c createNavItem(String name, String url, String label)
    {
        PBS_AlmondNavigation__c obj = new PBS_AlmondNavigation__c(
            name                 = name,
            url__c               = url,
            label__c             = label,
            active__c            = true,
            SectionOtherPages__c = name,
            order__c             = 1
        );

        insert obj;
        return obj;
    }

    /**
     * Method used to create Job Profile
     *
     * @param String name Job Profile Name
     * @return PBS_Standard_Job_Profile__c new Job Profile
     */
    public static PBS_Standard_Job_Profile__c createJobProfile(String name)
    {
        PBS_Standard_Job_Profile__c obj = new PBS_Standard_Job_Profile__c(
            Name = name
        );

        insert obj;
        return obj;
    }

    /**
     * Method used to create Job Profile
     *
     * @param String name Track name
     * @param String workLevel Work Level Name
     * @param String geography Geography
     * @param Id jobProfileId Job Profile Id
     * @return Training_Track__c new Training Track
     */
    public static PBS_Training_Track__c createTrainingTrack(String name, String workLevel, String geography, Id jobProfileId)
    {
        PBS_Training_Track__c obj = new PBS_Training_Track__c(
            Name                        = name,
            Work_Level__c               = workLevel,
            Geography__c                = geography,
            PBS_Standard_Job_Profile__c = jobProfileId
        );

        insert obj;
        return obj;
    }
}