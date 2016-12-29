/**
 * Contoller for the forum home page
 *
 * @author  Krzysztof Wasniowski <k.wasniowski@polsource.com>
 */
public with sharing class PC_ForumController_CC
{
    /**
     * Method returns Plancraft group details
     *
     * @return PC_Group__c Plancraft group object if available
     */
     
    Public String groupId {get;set;} 
    
    public PC_ForumController_CC(){
        
        PC_Group__c PBS=getPBSForumGroupId();
        if(PBS!=null){
            collaGroupId(PBS.Id);
        }
        
    
    }
    
         
    public PC_Group__c getPlancraftGroup() {
        List<PC_Group__c> result = [
            SELECT
                Id, Title__c, Name, Background_Location__c, Chatter_Group_ID__c,
                Data_Categories__c, Image_ID__c, Order__c, Parent_Page__c, Published__c, Summary__c
            FROM
                PC_Group__c
            WHERE
                Published__c = true
            AND
                Order__c = 0
            ORDER BY
                Name ASC
            LIMIT 1
        ];

        return result.isEmpty() ? null : result.get(0);
    }

    /**
     * Method returns list of groups grouped in groups of 6 elements
     *
     * @return List<PC_Group__c> List of published PC Groups
     */
    public List<List<PC_Group__c>> getGroupList() {
        List<List<PC_Group__c>> result = new List<List<PC_Group__c>>();

        List<PC_Group__c> data = [
            SELECT
                Id, Title__c, Name, Background_Location__c, Chatter_Group_ID__c,
                Data_Categories__c, Image_ID__c, Order__c, Parent_Page__c, Published__c, Summary__c
            FROM
                PC_Group__c
            WHERE
                Published__c = true
            AND
                Order__c > 0
            ORDER BY
                Order__c, Name
        ];

        if (!data.isEmpty()) {
            List<PC_Group__c> page = new List<PC_Group__c>();
            for (Integer i = 0, len = data.size(); i < len; i++) {
                page.add(data.get(i));
                if ((i != 0 && Math.mod(i + 1, 6) == 0) || i + 1 == len) {
                    result.add(page);
                    page = new List<PC_Group__c>();
                }
            }
        }

        return result;
    }
    
     /**
     * Method returns Plancraft group details
     *
     * @return PC_Group__c Plancraft group object if available
     */
    public PC_Group__c getPBSForumGroupId() {
        
        List<PC_Group__c> result = [
            SELECT
                Id, Title__c, Name, Background_Location__c, Chatter_Group_ID__c,
                Data_Categories__c, Image_ID__c, Order__c, Parent_Page__c, Published__c, Summary__c
            FROM
                PC_Group__c
            WHERE
                Published__c = true
            AND
                Order__c = 5
            ORDER BY
                Name ASC
            LIMIT 1
        ];
        
        return result.isEmpty() ? null : result.get(0);
    }
     /**
     * Method returns Plancraft group details
     *
     * @return PC_Group__c Plancraft group object if available
     */
    public PC_Group__c getDPForumGroupId() {
        List<PC_Group__c> result = [
            SELECT
                Id, Title__c, Name, Background_Location__c, Chatter_Group_ID__c,
                Data_Categories__c, Image_ID__c, Order__c, Parent_Page__c, Published__c, Summary__c
            FROM
                PC_Group__c
            WHERE
                Published__c = true
            AND
                Order__c = 1
            ORDER BY
                Name ASC
            LIMIT 1
        ];

        return result.isEmpty() ? null : result.get(0);
    }
     /**
     * Method returns Plancraft group details
     *
     * @return PC_Group__c Plancraft group object if available
     */
    public PC_Group__c getSPForumGroupId() {
        List<PC_Group__c> result = [
            SELECT
                Id, Title__c, Name, Background_Location__c, Chatter_Group_ID__c,
                Data_Categories__c, Image_ID__c, Order__c, Parent_Page__c, Published__c, Summary__c
            FROM
                PC_Group__c
            WHERE
                Published__c = true
            AND
                Order__c = 2
            ORDER BY
                Name ASC
            LIMIT 1
        ];

        return result.isEmpty() ? null : result.get(0);
    }
     /**
     * Method returns Plancraft group details
     *
     * @return PC_Group__c Plancraft group object if available
     */
    public PC_Group__c getDisPForumGroupId() {
        List<PC_Group__c> result = [
            SELECT
                Id, Title__c, Name, Background_Location__c, Chatter_Group_ID__c,
                Data_Categories__c, Image_ID__c, Order__c, Parent_Page__c, Published__c, Summary__c
            FROM
                PC_Group__c
            WHERE
                Published__c = true
            AND
                Order__c = 3
            ORDER BY
                Name ASC
            LIMIT 1
        ];

        return result.isEmpty() ? null : result.get(0);
    }
     /**
     * Method returns Plancraft group details
     *
     * @return PC_Group__c Plancraft group object if available
     */
    public PC_Group__c getMPForumGroupId() {
        List<PC_Group__c> result = [
            SELECT
                Id, Title__c, Name, Background_Location__c, Chatter_Group_ID__c,
                Data_Categories__c, Image_ID__c, Order__c, Parent_Page__c, Published__c, Summary__c
            FROM
                PC_Group__c
            WHERE
                Published__c = true
            AND
                Order__c = 4
            ORDER BY
                Name ASC
            LIMIT 1
        ];

        return result.isEmpty() ? null : result.get(0);
    }
     /**
     * Method returns Plancraft group details
     *
     * @return PC_Group__c Plancraft group object if available
     */
    public PC_Group__c getIPForumGroupId() {
        List<PC_Group__c> result = [
            SELECT
                Id, Title__c, Name, Background_Location__c, Chatter_Group_ID__c,
                Data_Categories__c, Image_ID__c, Order__c, Parent_Page__c, Published__c, Summary__c
            FROM
                PC_Group__c
            WHERE
                Published__c = true
            AND
                Order__c = 6
            ORDER BY
                Name ASC
            LIMIT 1
        ];

        return result.isEmpty() ? null : result.get(0);
    }
    
    public void refreshGroupId(){
        //system.debug('GroupId--->>'+apexpages.currentpage().getparameters().get('groupId'));
        String grpId = apexpages.currentpage().getparameters().get('groupId');
        collaGroupId(grpId);
           
    } 
    
    private void collaGroupId(String grpId){
        // query for PC_Group
        List<PC_Group__c> pcList = [SELECT Chatter_Group_ID__c,Data_Categories__c FROM PC_Group__c WHERE Id = :grpId AND Published__c = true Limit 1 ];
        if(pcList!= null){
            if(pcList.get(0).Chatter_Group_ID__c != null) {
                List<CollaborationGroup> groupList = [
                    SELECT
                        AnnouncementId, CanHaveGuests, CollaborationType, CreatedById, CreatedDate, Description, FullPhotoUrl, GroupEmail, HasPrivateFieldsAccess, Id, InformationBody, InformationTitle, IsArchived, IsAutoArchiveDisabled, LastModifiedById, LastModifiedDate, MemberCount, Name, NetworkId, OwnerId, SmallPhotoUrl
                    FROM
                        CollaborationGroup
                    WHERE
                        id = :pcList.get(0).Chatter_Group_ID__c
                    LIMIT 1
                ];
    
                if (!groupList.isEmpty()) {
                    groupId= groupList.get(0).Id;
                }
            }
        }
    
    }
    
}