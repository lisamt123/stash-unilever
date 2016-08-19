<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_request_email_template_to_approver_for_Final_Approval</fullName>
        <description>&quot;Approval request email template&quot; to approver for Final Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>FS_System_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/NAFS_Operator_Account_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>FS_Account_Validation_Reject_From_Admin_Group</fullName>
        <description>Account Validation Reject From Admin Group</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Account_Validation_Reject_From_Admin_Group</template>
    </alerts>
    <alerts>
        <fullName>FS_Account_Validation_Reject_From_Manager</fullName>
        <description>FS Account Validation Reject From Manager</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Account_Validation_Reject_From_Manager</template>
    </alerts>
    <fieldUpdates>
        <fullName>FS_UpdateAccountStatus</fullName>
        <description>Update Account Status</description>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Update Account Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
