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
    <fieldUpdates>
        <fullName>BEN_Field_Update_SecondStep</fullName>
        <description>BEN fieldupdate to secondstep</description>
        <field>Approval_Status__c</field>
        <literalValue>In Second Step</literalValue>
        <name>BEN Field Update SecondStep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_In_Approval_False</fullName>
        <field>In_Approval__c</field>
        <literalValue>0</literalValue>
        <name>BEN In Approval False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_Mark_for_Deletion_False</fullName>
        <field>bln_Mark_for_Deletion__c</field>
        <literalValue>0</literalValue>
        <name>BEN Mark for Deletion False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_Record_Type_Approved</fullName>
        <description>Record type changed to BEN Category Details Approved</description>
        <field>RecordTypeId</field>
        <lookupValue>BEN_Category_Details_Approved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>BEN Record Type Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_Record_Type_Deleted</fullName>
        <description>BEN Record Type Deleted</description>
        <field>RecordTypeId</field>
        <lookupValue>BEN_Category_Details_Deleted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>BEN Record Type Deleted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_Record_Type_Rejected</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BEN_Category_Details_Rejected</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>BEN Record Type Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_Record_Type_Saved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BEN_Category_Details</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>BEN Record Type Saved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_Record_Type_Submitted</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BEN_Category_Details_Submitted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>BEN Record Type Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_Status_Deleted</fullName>
        <description>Update category detail status to Deleted</description>
        <field>pkl_Status__c</field>
        <literalValue>Deleted</literalValue>
        <name>BEN_Status_Deleted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_Status_Saved</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Saved</literalValue>
        <name>BEN Status Saved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_Submitted_date</fullName>
        <field>dt_Date_of_Submission__c</field>
        <formula>TODAY()</formula>
        <name>BEN Submitted date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_Update_Status_to_Deleted</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Deleted</literalValue>
        <name>BEN Update Status to Deleted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_status_Approved</fullName>
        <description>status changed to approved</description>
        <field>pkl_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>BEN status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BEN_status_Rejected</fullName>
        <description>BEN status Rejected</description>
        <field>pkl_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>BEN status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
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
