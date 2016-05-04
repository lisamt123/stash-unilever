<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BET_Archived</fullName>
        <description>BET Archived Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>marketing@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_Archived</template>
    </alerts>
    <alerts>
        <fullName>BET_Unarchived_Notification</fullName>
        <description>BET Unarchived Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>marketing@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_Unarchived</template>
    </alerts>
    <rules>
        <fullName>BET_Archived</fullName>
        <actions>
            <name>BET_Archived</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Is_Archived__c,ISCHANGED(Is_Archived__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BET_Unarchived</fullName>
        <actions>
            <name>BET_Unarchived_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(Is_Archived__c),ISCHANGED(Is_Archived__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
