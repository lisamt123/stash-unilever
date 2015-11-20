<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BET_Member_Request_Approved_Notification</fullName>
        <description>BET_Member_Request_Approved_Notification</description>
        <protected>false</protected>
        <recipients>
            <field>UserId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>marketing@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_Member_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>BET_Member_Request_Rejected_Notification</fullName>
        <description>BET_Member_Request_Rejected_Notification</description>
        <protected>false</protected>
        <recipients>
            <field>UserId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>marketing@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_Member_Request_Rejected</template>
    </alerts>
    <alerts>
        <fullName>BET_New_Bet_Member_Request_Notification</fullName>
        <description>BET New Bet Member Request Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Bet_owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>marketing@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_Member_Request_Created</template>
    </alerts>
    <rules>
        <fullName>BET_Member_Request_Approved</fullName>
        <actions>
            <name>BET_Member_Request_Approved_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>IF(ISNEW(), 
AND(ISPICKVAL(Status__c,&apos;Approved&apos;),NOT(Do_Not_Notify_User__c))
,AND(ISPICKVAL(Status__c,&apos;Approved&apos;), ISCHANGED(Status__c), NOT(Do_Not_Notify_User__c))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BET_Member_Request_Created</fullName>
        <actions>
            <name>BET_New_Bet_Member_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BET_Member_Request__c.Do_Not_Notify_Bet__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>BET_Member_Request_Rejected</fullName>
        <actions>
            <name>BET_Member_Request_Rejected_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c , &apos;Rejected&apos;), ISCHANGED(Status__c )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
