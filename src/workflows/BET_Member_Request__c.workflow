<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BET_New_Bet_Member_Request_Notification</fullName>
        <description>BET New Bet Member Request Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Bet_owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>cb4l@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_Member_Request_Created</template>
    </alerts>
    <rules>
        <fullName>BET_Member_Request_Created</fullName>
        <actions>
            <name>BET_New_Bet_Member_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>BET_Member_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
