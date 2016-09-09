<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_to_account_plan_owner_for_Approval</fullName>
        <description>Email alert to account plan owner for approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Account_Plan_Approved</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_account_plan_owner_for_rejection</fullName>
        <description>Email alert to account plan owner for rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_account_Plan_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>FS_Account_Plan_Name_Update</fullName>
        <description>Update Account Plan Name to Business Account Plan Name</description>
        <field>Name</field>
        <formula>FS_Account_Business_Plan_Name__c</formula>
        <name>FS Account Plan Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_InitialStatusUpdate</fullName>
        <field>FS_Status__c</field>
        <literalValue>Approval Requested</literalValue>
        <name>Initial Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateAccountPlanStatus</fullName>
        <description>It is used to update account plan status with Planning</description>
        <field>FS_Status__c</field>
        <literalValue>Planning</literalValue>
        <name>Update Account Plan status when rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateAccountPlanStatusApproved</fullName>
        <description>It is used to update status of account plan with Approved</description>
        <field>FS_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Account Plan status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateApprovedCheckbox</fullName>
        <description>It is used to update Approved checkbox on account plan</description>
        <field>FS_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update Approved Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateStatus</fullName>
        <description>It is updating Status to Active</description>
        <field>FS_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FS Update Account Plan Name</fullName>
        <actions>
            <name>FS_Account_Plan_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FS_Account_Plan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
