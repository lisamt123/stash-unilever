<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FA_Alert_For_Admin</fullName>
        <description>Alert for Admin</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FA_Email_Template/FA_Alert_for_Admin_Mail</template>
    </alerts>
    <alerts>
        <fullName>FA_Course_Cancellation_Mail</fullName>
        <description>Course Cancellation Mail</description>
        <protected>false</protected>
        <recipients>
            <field>FA_Participant_Instructor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>michaela.stewart@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>FA_Email_Template/FA_Course_Cancellation_Mail</template>
    </alerts>
    <alerts>
        <fullName>FA_Course_Feedback_Mail</fullName>
        <description>Course Feedback Mail</description>
        <protected>false</protected>
        <recipients>
            <field>FA_Participant_Instructor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>michaela.stewart@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>FA_Email_Template/FA_Feedback_Invitation_Mail</template>
    </alerts>
    <alerts>
        <fullName>FA_Course_Invitation_Mail</fullName>
        <description>Course Invitation Mail</description>
        <protected>false</protected>
        <recipients>
            <field>FA_Participant_Instructor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>michaela.stewart@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>FA_Email_Template/FA_Course_Invitation_Mail</template>
    </alerts>
    <fieldUpdates>
        <fullName>FA_Feedback_Update</fullName>
        <description>Once Mail has been sent, the Send Feedback Invitation checkbox need to be Unchecked</description>
        <field>FA_Send_Feedback_Invitation__c</field>
        <literalValue>0</literalValue>
        <name>FA Feedback Checkbox Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FA_OccMem_External_ID</fullName>
        <field>FA_External_ID__c</field>
        <formula>FA_Course_Occurence__c + FA_Participant_Instructor__c</formula>
        <name>FA OccMem External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FA Email Invitation</fullName>
        <actions>
            <name>FA_Course_Invitation_Mail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FA_Course_Occurence__c.FA_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>FA_Course_Occurence__c.FA_Send_Invite_Mail__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>FA_Occurence_Member__c.FA_Role__c</field>
            <operation>equals</operation>
            <value>Participant</value>
        </criteriaItems>
        <description>This alert will sent out the invite mail to the participant once he get added to the Course</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FA Feedback Mail</fullName>
        <actions>
            <name>FA_Course_Feedback_Mail</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>FA_Feedback_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FA_Occurence_Member__c.FA_Send_Feedback_Invitation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>FA_Occurence_Member__c.FA_Participation_Status__c</field>
            <operation>equals</operation>
            <value>Attended</value>
        </criteriaItems>
        <criteriaItems>
            <field>FA_Occurence_Member__c.FA_Role__c</field>
            <operation>equals</operation>
            <value>Participant</value>
        </criteriaItems>
        <description>This Workflow will send the feedback mail to all the attended participants to give feedback on the training attended.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FA Update External ID</fullName>
        <actions>
            <name>FA_OccMem_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow will update the external Id field on the Occurrence Member record</description>
        <formula>ISNEW() || ISCHANGED( FA_Participant_Instructor__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FA_AlertforAdmin</fullName>
        <actions>
            <name>FA_Alert_For_Admin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow triggers an email to Course occurrence Admin when participant has updated his/her programme logistics.</description>
        <formula>LastModifiedById =  FA_Participant_Instructor__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FA_Cancellation Mail</fullName>
        <actions>
            <name>FA_Course_Cancellation_Mail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FA_Occurence_Member__c.FA_Participation_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
