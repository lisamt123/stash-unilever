<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BET_Request_Approved_Email_Notification</fullName>
        <description>BET Request Approved Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Team_Member__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Emails/BET_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>BET_Request_Denied_Email_Notification</fullName>
        <description>BET Request Denied Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Team_Member__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Emails/BET_Request_Denied</template>
    </alerts>
    <fieldUpdates>
        <fullName>BET_Request_Denied_Set_Delete_Date</fullName>
        <field>Scheduled_Delete_Date__c</field>
        <formula>TODAY() + 3</formula>
        <name>BET Request Denied Set Delete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BET Request Approved</fullName>
        <actions>
            <name>BET_Request_Approved_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>uw_BET_Team_Member__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BET Request Denied</fullName>
        <actions>
            <name>BET_Request_Denied_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>BET_Request_Denied_Set_Delete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>uw_BET_Team_Member__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Denied</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
