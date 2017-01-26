<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_notification_email</fullName>
        <description>Send notification email</description>
        <protected>false</protected>
        <recipients>
            <recipient>bherudek@salesforce.com.sfcttafdev</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Bus_Solution</template>
    </alerts>
    <rules>
        <fullName>New Bus Solution Created</fullName>
        <actions>
            <name>Send_notification_email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Business_Solution__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
