<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BET_TLDChangedNotification</fullName>
        <description>BET_TLDChangedNotification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>cb4l@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_TLD_Changed</template>
    </alerts>
    <rules>
        <fullName>BET_TLD_Changed</fullName>
        <actions>
            <name>BET_TLDChangedNotification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Runs when Target Launch Data has been changed</description>
        <formula>AND(NOT(ISNEW()),ISCHANGED(Launch_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
