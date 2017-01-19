<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BEN_Category_detail_rejected</fullName>
        <description>BEN Categorydetailrejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BEN_Email_Templates/BEN_Record_Rejection_email1</template>
    </alerts>
    <alerts>
        <fullName>BEN_EMAIL_ALERT_TO_Editor_Deletion_REJECTED</fullName>
        <description>BEN EMAIL ALERT TO Editor - Deletion REJECTED</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BEN_Email_Templates/BEN_GPLDelete_Rejected</template>
    </alerts>
    <alerts>
        <fullName>BEN_Record_has_been_deleted</fullName>
        <description>BEN Record has been deleted</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BEN_Email_Templates/BEN_Record_deleted</template>
    </alerts>
    <alerts>
        <fullName>BEN_SendEmailToRecordCreatorApproved</fullName>
        <description>BEN SendEmailToRecordCreatorApproved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BEN_Email_Templates/BEN_RecordApprovedEmail</template>
    </alerts>
    <alerts>
        <fullName>BEN_Send_Email_to_GPL</fullName>
        <description>BEN Send Email to GPL</description>
        <protected>false</protected>
        <recipients>
            <recipient>BEN_GPL_User</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BEN_Email_Templates/BEN_Submitted_for_approval_GPL</template>
    </alerts>
    <alerts>
        <fullName>BEN_Send_Email_to_GPL_for_Delete</fullName>
        <description>BEN Send_Email_to_GPL for Delete</description>
        <protected>false</protected>
        <recipients>
            <recipient>BEN_GPL_User</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BEN_Email_Templates/BEN_GPL_approval_for_deletion</template>
    </alerts>
    <rules>
        <fullName>BEN Category Detail Created</fullName>
        <actions>
            <name>BEN_In_Approval_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BEN_Mark_for_Deletion_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BEN_Record_Type_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BEN_Status_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BEN_Category_Details__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>To update new category detail record when cloned</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>BEN Category detail submission</fullName>
        <actions>
            <name>BEN_Submitted_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>to calculate the date of submission</description>
        <formula>AND(ISCHANGED( pkl_Status__c ), ISPICKVAL( pkl_Status__c , &apos;Submitted&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
