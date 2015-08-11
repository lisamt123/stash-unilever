<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BET_FollowRequestApprovedNotification</fullName>
        <description>BET_FollowRequestApprovedNotification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>cb4l@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_FollowRequestApproved</template>
    </alerts>
    <alerts>
        <fullName>BET_FollowRequestCreatedNotification</fullName>
        <description>BET_FollowRequestCreatedNotification</description>
        <protected>false</protected>
        <recipients>
            <field>Bet_owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>cb4l@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_FollowRequestCreated</template>
    </alerts>
    <alerts>
        <fullName>BET_FollowRequestRejectedNotification</fullName>
        <description>BET_FollowRequestRejectedNotification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>cb4l@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_FollowRequestRejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>BET_Set_Status_To_Approved</fullName>
        <description>Sets status of a follow request to Approved</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>BET Set Status To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>BET_FollowRequestApproved</fullName>
        <actions>
            <name>BET_FollowRequestApprovedNotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Runs when lead  follow request is approved</description>
        <formula>AND(
PRIORVALUE(Status__c) &lt;&gt; &apos;Approved&apos;, 
ISPICKVAL(Status__c, &apos;Approved&apos;),
Is_Lead_Request__c
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BET_FollowRequestCreated</fullName>
        <actions>
            <name>BET_FollowRequestCreatedNotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BET_Follow_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Runs when follow request is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>BET_FollowRequestRejected</fullName>
        <actions>
            <name>BET_FollowRequestRejectedNotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Runs when follow request is rejected</description>
        <formula>AND(
PRIORVALUE(Status__c) &lt;&gt; &apos;Rejected&apos;, 
ISPICKVAL(Status__c, &apos;Rejected&apos;),
Is_Lead_Request__c
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BET_FollowRequestWaitForAutoApprove</fullName>
        <active>true</active>
        <criteriaItems>
            <field>BET_Follow_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Workflow responsible for autoapprove of follow request after certain time period (72 hours)</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BET_Set_Status_To_Approved</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>BET_Follow_Request__c.CreatedDate</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
