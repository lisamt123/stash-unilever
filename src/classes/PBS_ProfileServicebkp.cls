/**
 * Profile service - provides methods related to setting up user profile
 * @author Krzysztof Wasniowski <k.wasniowski@polsource.com>
 */
public with sharing class PBS_ProfileServicebkp
{
    /**
     * Method reads picklist definition of the given object and field and provides result as a list of strings
     *
     * @param String ObjectName         Name of the stanard or custom object
     * @param String PicklistFieldName  Name of the custom or standard picklist field
     * @param String AddEmptyOption     If true then an empty item will be added to result list
     * @return List<String>             List of picklist values
     */
    public static List<String> getPicklistOptions(String ObjectName, String PicklistFieldName, boolean AddEmptyOption) {
        List<String> result            = new List<String>();
        List<Schema.PicklistEntry> ple = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(PicklistFieldName).getDescribe().getPickListValues();

        for (Schema.PicklistEntry f : ple) {
            result.add(f.getValue());
        }

        if (AddEmptyOption) {
            result.add('');
        }

        return result;
    }

    /**
     * Returns current user profile object or dummy object if profile is not defined yet
     *
     * @return PBS_Profile__c Profile object
     */
    public static PBS_Profile__c getCurrentUserProfile()
    {
        List<PBS_Profile__c> profileList = [
            SELECT
                Id, Name, User_Role__c, User_Role__r.Name, User__c, User__r.Name, Work_Level__c, Geography__c, Buddy__c
            FROM
                PBS_Profile__c
            WHERE
                User__r.Id = :UserInfo.getUserId()
            LIMIT 1
        ];

        return profileList.isEmpty() ? new PBS_Profile__c(
            User_Role__c  = [SELECT Id FROM PBS_Standard_Job_Profile__c WHERE Name = 'Guest' LIMIT 1].Id,
            Work_Level__c = 'Guest',
            Geography__c  = 'Guest',
            User__c       = UserInfo.getUserId()
        ) : profileList.get(0);
    }

    /**
     * Method checks if sharing / assignment should be updated based on old and new values of a user profile
     *
     * @param PBS_Profile__c currentObject Profile object after changes
     * @param PBS_Profile__c oldObject Profile object before changes
     * @return Boolean True if sharing needs to be updated
     */
    public static boolean isUpdateRequired(PBS_Profile__c currentObject, PBS_Profile__c oldObject) {
        if (oldObject.Work_Level__c != currentObject.Work_Level__c) {
            return true;
        } else if (oldObject.Geography__c != currentObject.Geography__c) {
            return true;
        } else if (oldObject.User_Role__c != currentObject.User_Role__c) {
            return true;
        } else if (oldObject.user__c != currentObject.user__c) {
            return true;
        }
        return false;
    }

    /**
     * Method checks if sharing / assignment should be updated based on old and new values of a training track
     *
     * @param Training_Track__c currentObject Training track object after changes
     * @param Training_Track__c oldObject Training track object before changes
     * @return Boolean True if sharing needs to be updated
     */
    public static boolean isUpdateRequired(Almond__Training_Track__c currentObject, Almond__Training_Track__c oldObject) {
        if (oldObject.Work_Level__c != currentObject.Work_Level__c) {
            return true;
        } else if (oldObject.Geography__c != currentObject.Geography__c) {
            return true;
        } else if (oldObject.PBS_Standard_Job_Profile__c != currentObject.PBS_Standard_Job_Profile__c) {
            return true;
        }
        return false;
    }


    /**
     * Class contains methods that needs to be executed with admin privileges to update sharing for users that do not have access
     * to sharing management on the objects
     */
    public without sharing class PBS_ProfileWithoutSharing {
        /**
         * Method creates and remove sharings based on provided lists
         *
         * @param List<Training_Track__Share> toAdd List of sharings to add
         * @param List<Training_Track__Share> toRemove List of sharings to remove
         * @return void
         */
        public void updateSharing(List<Almond__Training_Track__Share> toAdd, List<Almond__Training_Track__Share> toRemove) {
            Savepoint sp = null;
            try {
                sp = Database.setSavepoint();

                if (toAdd != null && !toAdd.isEmpty()) {
                    insert toAdd;
                }
                if (toRemove != null && !toRemove.isEmpty()) {
                    delete toRemove;
                }
            } catch (Exception e) {
                if (sp != null) {
                    Database.rollback(sp);
                }
                throw e;
            }
        }

        /**
         * Method finds all sharings for a given user profile configuration
         *
         * @param PBS_Profile__c profileObject Profile object to look for existing sharings
         * @return List<Training_Track__Share> List of sharings matching given profile
         */
        public List<Almond__Training_Track__Share> getExistingSharingForProfile(PBS_Profile__c profileObject) {
            // find sharings for specific set of data
            return [
                SELECT
                    Id
                FROM
                    Almond__Training_Track__Share
                WHERE
                    UserOrGroupId = :profileObject.user__c
                AND
                    RowCause = 'Manual'
                AND
                    ParentId IN (
                        SELECT
                            Id
                        FROM
                            Almond__Training_Track__c
                        WHERE
                            Work_Level__c = :profileObject.Work_Level__c
                        AND
                            Geography__c  = :profileObject.Geography__c
                        AND
                            PBS_Standard_Job_Profile__c  = :profileObject.User_Role__c
                    )
            ];
        }

        /**
         * Method returns list of all sharings that should be created for given profile object
         *
         * @param PBS_Profile__c profileObject Profile object to look for sharings that has to be created
         * @return List<Training_Track__Share> List of sharings to create
         */
        public List<Almond__Training_Track__Share> getNewSharingForProfile(PBS_Profile__c profileObject) {
            // find profile for specific set of data
            List<Almond__Training_Track__c> trackList = [
                SELECT
                    Id
                FROM
                    Almond__Training_Track__c
                WHERE
                    Work_Level__c = :profileObject.Work_Level__c
                AND
                    Geography__c  = :profileObject.Geography__c
                AND
                    PBS_Standard_Job_Profile__c = :profileObject.User_Role__c
                AND
                    // do not add user to track if he is already there
                    Id NOT IN (SELECT ParentId FROM Almond__Training_Track__Share WHERE UserOrGroupId = :profileObject.user__c)
            ];

            List<Almond__Training_Track__Share> result = new List<Almond__Training_Track__Share>();

            if (!trackList.isEmpty()) {
                for(Almond__Training_Track__c tc : trackList) {
                    result.add(new Almond__Training_Track__Share(
                            AccessLevel   = 'Read',
                            ParentId      = tc.Id,
                            UserOrGroupId = profileObject.user__c
                        )
                    );
                }
            }

            return result;
        }

        /**
         * Method finds all sharings for a given Training Track
         *
         * @param Training_Track__c trainingTrackObject Training Track object to look for existing sharings
         * @return List<Training_Track__Share> List of sharings matching given profile
         */
        public List<Almond__Training_Track__Share> getExistingSharingForTrainingTrack(Almond__Training_Track__c trainingTrackObject) {
            // find sharings for specific set of data
            return [
                SELECT
                    Id
                FROM
                    Almond__Training_Track__Share
                WHERE
                    ParentId = :trainingTrackObject.Id
                AND
                    RowCause = 'Manual'
                AND
                    UserOrGroupId IN (
                        SELECT
                            User__c
                        FROM
                            PBS_Profile__c
                        WHERE
                            Work_Level__c = :trainingTrackObject.Work_Level__c
                        AND
                            Geography__c  = :trainingTrackObject.Geography__c
                        AND
                            User_Role__c  = :trainingTrackObject.PBS_Standard_Job_Profile__c
                    )
            ];
        }

        /**
         * Method returns list of all sharings that should be created for given profile object
         *
         * @param Training_Track__c trainingTrackObject Training track object to look for sharings that has to be created
         * @return List<Training_Track__Share> List of sharings to create
         */
        public List<Almond__Training_Track__Share> getNewSharingForTrainingTrack(Almond__Training_Track__c trainingTrackObject) {
            // find profile for specific set of data
            List<PBS_Profile__c> profileList = [
                SELECT
                    Id, User__c
                FROM
                    PBS_Profile__c
                WHERE
                    Work_Level__c = :trainingTrackObject.Work_Level__c
                AND
                    Geography__c  = :trainingTrackObject.Geography__c
                AND
                    User_Role__c  = :trainingTrackObject.PBS_Standard_Job_Profile__c
                AND
                    // do not add user to track if he is already there
                    User__c NOT IN (SELECT UserOrGroupId FROM Almond__Training_Track__Share WHERE ParentId = :trainingTrackObject.Id)
            ];

            List<Almond__Training_Track__Share> result = new List<Almond__Training_Track__Share>();

            if (!profileList.isEmpty()) {
                for(PBS_Profile__c profile : profileList) {
                    result.add(new Almond__Training_Track__Share(
                            AccessLevel   = 'Read',
                            ParentId      = trainingTrackObject.Id,
                            UserOrGroupId = profile.user__c
                        )
                    );
                }
            }

            return result;
        }
    }
}