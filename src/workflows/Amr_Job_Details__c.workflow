<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AMR_CAPNotificationAlert</fullName>
        <description>AMR_CAPNotificationAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>vaibhav.vora@unilever.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_CAPNotification</template>
    </alerts>
    <alerts>
        <fullName>Amr_Agency_NoneSelected</fullName>
        <description>Amr_Agency_NoneSelected</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_Agency_NoneSelected</template>
    </alerts>
    <alerts>
        <fullName>Amr_Agency_RequireAll</fullName>
        <description>Amr_Agency_RequireAll</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_Agency_RequireAll</template>
    </alerts>
    <alerts>
        <fullName>Amr_Agency_RequireMusic</fullName>
        <description>Amr_Agency_RequireMusic</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_Agency_RequireMusic</template>
    </alerts>
    <alerts>
        <fullName>Amr_Agency_RequireTalent</fullName>
        <description>Amr_Agency_RequireTalent</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_Agency_RequireTalent</template>
    </alerts>
    <alerts>
        <fullName>Amr_Agency_TalentAndMusic</fullName>
        <description>Amr_Agency_TalentAndMusic</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_Agency_TalentAndMusic</template>
    </alerts>
    <alerts>
        <fullName>Amr_Agency_TvAndMusic</fullName>
        <description>Amr_Agency_TvAndMusic</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_Agency_TvAndMusic</template>
    </alerts>
    <alerts>
        <fullName>Amr_Agency_TvAndTalent</fullName>
        <description>Amr_Agency_TvAndTalent</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_Agency_TvAndTalent</template>
    </alerts>
    <alerts>
        <fullName>Amr_Agency_TvOrCinema</fullName>
        <description>Amr_Agency_TvOrCinema</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_Agency_TvOrCinema</template>
    </alerts>
    <alerts>
        <fullName>Amr_JobAccepted</fullName>
        <description>Amr_JobAccepted</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Final_Approver_Of_Material_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Job_Accepted_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Finance_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Your_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_RAPAcceptedJob</template>
    </alerts>
    <alerts>
        <fullName>Amr_JobCancellation</fullName>
        <ccEmails>swarup.swarup@gmail.com</ccEmails>
        <description>Amr_JobCancellation</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Final_Approver_Of_Material_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Finance_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Your_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_JobCancellation</template>
    </alerts>
    <alerts>
        <fullName>Amr_JobReAllocation</fullName>
        <description>Amr_JobReAllocation</description>
        <protected>false</protected>
        <recipients>
            <field>JobAllocated_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_RAPAllocatedJob</template>
    </alerts>
    <alerts>
        <fullName>Amr_Threshold</fullName>
        <description>Amr_Threshold</description>
        <protected>false</protected>
        <recipients>
            <field>GBVM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_ThresholdNotification</template>
    </alerts>
    <alerts>
        <fullName>Amr_User_MusicAndTalent</fullName>
        <description>Amr_User_MusicAndTalent</description>
        <protected>false</protected>
        <recipients>
            <field>Final_Approver_Of_Material_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Finance_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Your_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_User_MusicAndTalent</template>
    </alerts>
    <alerts>
        <fullName>Amr_User_NoSelection</fullName>
        <description>Amr_User_NoSelection</description>
        <protected>false</protected>
        <recipients>
            <field>Final_Approver_Of_Material_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Finance_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Your_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_User_NoSelectection</template>
    </alerts>
    <alerts>
        <fullName>Amr_User_RequireAll</fullName>
        <description>Amr_User_RequireAll</description>
        <protected>false</protected>
        <recipients>
            <field>Final_Approver_Of_Material_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Finance_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Your_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_User_RequireAll</template>
    </alerts>
    <alerts>
        <fullName>Amr_User_RequireMusic</fullName>
        <description>Amr_User_RequireMusic</description>
        <protected>false</protected>
        <recipients>
            <field>Final_Approver_Of_Material_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Finance_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Your_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_User_RequireMusic</template>
    </alerts>
    <alerts>
        <fullName>Amr_User_RequireTalent</fullName>
        <description>Amr_User_RequireTalent</description>
        <protected>false</protected>
        <recipients>
            <field>Final_Approver_Of_Material_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Finance_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Your_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_User_RequireTalent</template>
    </alerts>
    <alerts>
        <fullName>Amr_User_TvAndMusic</fullName>
        <description>Amr_User_TvAndMusic</description>
        <protected>false</protected>
        <recipients>
            <field>Final_Approver_Of_Material_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Finance_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Your_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_User_TvAndMusic</template>
    </alerts>
    <alerts>
        <fullName>Amr_User_TvAndTalent</fullName>
        <description>Amr_User_TvAndTalent</description>
        <protected>false</protected>
        <recipients>
            <field>Final_Approver_Of_Material_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Finance_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Your_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_User_TvAndTalent</template>
    </alerts>
    <alerts>
        <fullName>Amr_User_TvOrCinema</fullName>
        <description>Amr_User_TvOrCinema</description>
        <protected>false</protected>
        <recipients>
            <field>Final_Approver_Of_Material_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Finance_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Unilever_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Your_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_User_TvOrCinema</template>
    </alerts>
    <alerts>
        <fullName>test</fullName>
        <description>test</description>
        <protected>false</protected>
        <recipients>
            <field>Agency_Contact_Account_Director_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AdManager/Amr_CAPNotification</template>
    </alerts>
    <rules>
        <fullName>AMR_CAPNotification</fullName>
        <actions>
            <name>AMR_CAPNotificationAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>IF(Is_Submitt__c, True, False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Amr_Agency_NoneSelected</fullName>
        <actions>
            <name>Amr_Agency_NoneSelected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(!NewOriginalMasterTv__c &amp;&amp; !NewOriginalMasterCinema__c &amp;&amp; ISPICKVAL(Require_Music__c, &apos;No&apos;)&amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;No&apos;), TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_Agency_RequireAll</fullName>
        <actions>
            <name>Amr_Agency_RequireAll</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;Yes&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;Yes&apos;)  &amp;&amp; (NewOriginalMasterTv__c || NewOriginalMasterCinema__c), TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_Agency_RequireMusic</fullName>
        <actions>
            <name>Amr_Agency_RequireMusic</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;Yes&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;No&apos;)  &amp;&amp; !NewOriginalMasterTv__c &amp;&amp; !NewOriginalMasterCinema__c, TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_Agency_RequireTalent</fullName>
        <actions>
            <name>Amr_Agency_RequireTalent</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;No&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;Yes&apos;)  &amp;&amp; !NewOriginalMasterTv__c &amp;&amp; !NewOriginalMasterCinema__c, TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_Agency_TalentAndMusic</fullName>
        <actions>
            <name>Amr_Agency_TalentAndMusic</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;Yes&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;Yes&apos;)  &amp;&amp; !NewOriginalMasterTv__c &amp;&amp; !NewOriginalMasterCinema__c, TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_Agency_TvAndMusic</fullName>
        <actions>
            <name>Amr_Agency_TvAndMusic</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;Yes&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;No&apos;)  &amp;&amp; (NewOriginalMasterTv__c || NewOriginalMasterCinema__c), TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_Agency_TvAndTalent</fullName>
        <actions>
            <name>Amr_Agency_TvAndTalent</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;No&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;Yes&apos;)  &amp;&amp; (NewOriginalMasterTv__c || NewOriginalMasterCinema__c), TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_Agency_TvOrCinema</fullName>
        <actions>
            <name>Amr_Agency_TvOrCinema</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if((NewOriginalMasterCinema__c || NewOriginalMasterTv__c) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;No&apos;) &amp;&amp; ISPICKVAL(Require_Music__c , &apos;No&apos;), TRUE, FALSE )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_JobAccepted</fullName>
        <actions>
            <name>Amr_JobAccepted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if( ISCHANGED(Job_Accepted_Email__c) , True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Amr_JobCancell</fullName>
        <actions>
            <name>Amr_JobCancellation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(Job_Cancelled__c, True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Amr_JobReAllocate</fullName>
        <actions>
            <name>Amr_JobReAllocation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISCHANGED(JobAllocated_Email__c) , True, False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Amr_Threshold</fullName>
        <actions>
            <name>Amr_Threshold</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(!ISBLANK(Threshold_Amount__c ) &amp;&amp; !ISBLANK(GBVM_Email__c), TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_User_NoneSelected</fullName>
        <actions>
            <name>Amr_User_NoSelection</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(!NewOriginalMasterTv__c &amp;&amp; !NewOriginalMasterCinema__c &amp;&amp; ISPICKVAL(Require_Music__c, &apos;No&apos;)&amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;No&apos;), TRUE, FALSE)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Amr_User_RequireAll</fullName>
        <actions>
            <name>Amr_User_RequireAll</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;Yes&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;Yes&apos;)  &amp;&amp; (NewOriginalMasterTv__c || NewOriginalMasterCinema__c), TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_User_RequireMusic</fullName>
        <actions>
            <name>Amr_User_RequireMusic</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;Yes&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;No&apos;) &amp;&amp; !NewOriginalMasterTv__c &amp;&amp; !NewOriginalMasterCinema__c, TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_User_RequireTalent</fullName>
        <actions>
            <name>Amr_User_RequireTalent</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;No&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;Yes&apos;)  &amp;&amp; !NewOriginalMasterTv__c &amp;&amp; !NewOriginalMasterCinema__c, TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_User_TalentAndMusic</fullName>
        <actions>
            <name>Amr_User_MusicAndTalent</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;Yes&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;Yes&apos;)  &amp;&amp; !NewOriginalMasterTv__c &amp;&amp; !NewOriginalMasterCinema__c, TRUE, FALSE)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Amr_User_TvAndMusic</fullName>
        <actions>
            <name>Amr_User_TvAndMusic</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;Yes&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;No&apos;)  &amp;&amp; (NewOriginalMasterTv__c || NewOriginalMasterCinema__c), TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_User_TvAndTalent</fullName>
        <actions>
            <name>Amr_User_TvAndTalent</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISPICKVAL(Require_Music__c , &apos;No&apos;) &amp;&amp; ISPICKVAL(Require_Celebrity_Talent__c , &apos;Yes&apos;)  &amp;&amp; (NewOriginalMasterTv__c || NewOriginalMasterCinema__c), TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Amr_User_TvOrCinema</fullName>
        <actions>
            <name>Amr_User_TvOrCinema</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if((NewOriginalMasterCinema__c || NewOriginalMasterTv__c) &amp;&amp;  ISPICKVAL(Require_Celebrity_Talent__c , &apos;No&apos;) &amp;&amp;  ISPICKVAL(Require_Music__c , &apos;No&apos;), TRUE, FALSE )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
