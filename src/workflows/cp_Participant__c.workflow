<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Participants</fullName>
        <description>Notify Participants</description>
        <protected>false</protected>
        <recipients>
            <field>Participant_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Emails/Notify_Market_Owners_of_Planned_Event</template>
    </alerts>
    <alerts>
        <fullName>Send_date_change_email_to_Planner_Owner</fullName>
        <description>Send date change email to Planner Owner</description>
        <protected>false</protected>
        <recipients>
            <field>Participant_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Emails/Notify_Planner_Owners_of_Date_Changes</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Re_approval_email_needed_to_False</fullName>
        <field>ReApprovalEmailNeeded__c</field>
        <literalValue>0</literalValue>
        <name>Set Re-approval email needed to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Send an email to Market Owners</fullName>
        <actions>
            <name>Notify_Participants</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends an email to Market Owner participants who may/are affected by an event</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send date change email to Market Owners</fullName>
        <actions>
            <name>Send_date_change_email_to_Planner_Owner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Re_approval_email_needed_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>cp_Participant__c.ReApprovalEmailNeeded__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
