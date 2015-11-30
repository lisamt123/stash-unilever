<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BET_FollowRequestCreatedNotification</fullName>
        <description>BET_FollowRequestCreatedNotification</description>
        <protected>false</protected>
        <recipients>
            <field>Bet_owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>marketing@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Emails/BET_FollowRequestCreated</template>
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
        <criteriaItems>
            <field>BET_Follow_Request__c.Is_Lead_Request__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Runs when follow request is created</description>
        <triggerType>onCreateOnly</triggerType>
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
