<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CPA_LOI_Accepted_Email_Alert</fullName>
        <description>CPA LOI Accepted Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_Accepted</template>
    </alerts>
    <alerts>
        <fullName>CPA_LOI_Record_ReSubmitted</fullName>
        <description>CPA LOI Record ReSubmitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_Resubmitted</template>
    </alerts>
    <alerts>
        <fullName>CPA_LOI_Record_Signed</fullName>
        <description>CPA LOI Record Signed</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_Signed</template>
    </alerts>
    <alerts>
        <fullName>CPA_LOI_Record_Submitted</fullName>
        <description>CPA LOI Record Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CPA_LOI_Record_send_for_Signature</fullName>
        <description>CPA LOI Record send for Signature</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_Sent_For_Signature</template>
    </alerts>
    <alerts>
        <fullName>CPA_LOI_Returned_Email_Update</fullName>
        <description>CPA LOI Returned Email Update</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_Returned</template>
    </alerts>
    <alerts>
        <fullName>CPA_LOI_cancelled_Email_Alert</fullName>
        <description>CPA LOI cancelled Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_is_cancelled</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Comment_Requested_for_LOI</fullName>
        <field>pkl_Approval_Comment_Check__c</field>
        <literalValue>Requested</literalValue>
        <name>Approval Comment Requested for LOI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Comment_Required_for_LOI</fullName>
        <field>pkl_Approval_Comment_Check__c</field>
        <literalValue>Required</literalValue>
        <name>Approval Comment Required for LOI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Accepted</fullName>
        <field>dat_Accepted_Date__c</field>
        <formula>Today()</formula>
        <name>CPA LOI Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Accepted_Recordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LOI_Other</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPA LOI Accepted Recordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Accepted_Statsu</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>CPA LOI Accepted Statsu</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Accepted_date</fullName>
        <field>dat_Accepted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA LOI Accepted date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Accepted_date_update</fullName>
        <field>dat_Accepted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA LOI Accepted date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Approval_Submitted_at_ULPM</fullName>
        <field>OwnerId</field>
        <lookupValue>CPA_SMT</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPA LOI Approval Submitted at ULPM</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Cancelled_Date</fullName>
        <field>dat_Cancelled_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA LOI Cancelled Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Cancelled_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LOI_Cancel</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPA LOI Cancelled Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Owner_Chage</fullName>
        <field>OwnerId</field>
        <lookupValue>CAP_VDM_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPA LOI Owner Chage</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Owner_Update_to_SMT</fullName>
        <field>OwnerId</field>
        <lookupValue>CPA_SMT</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPA LOI Owner Update to SMT</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Owner_Update_to_VDM</fullName>
        <field>OwnerId</field>
        <lookupValue>CAP_VDM_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPA LOI Owner Update to VDM</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_RE_Submitted_Date_update</fullName>
        <field>dat_Resubmitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA LOI RE-Submitted Date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Returned</fullName>
        <field>dat_Returned_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA LOI Returned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Returned_Date_Update</fullName>
        <field>dat_Returned_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA LOI Returned Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Returned_Status</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Returned</literalValue>
        <name>CPA LOI Returned Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Sent_for_Signature_Date_update</fullName>
        <field>dat_Sent_for_Signature_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA LOI Sent for Signature Date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Signed_Date_Update</fullName>
        <field>dat_Signed_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA LOI Signed Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Submitted_Date</fullName>
        <field>dat_Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA LOI Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Submitted_Date_Update</fullName>
        <field>dat_Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA LOI Submitted Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_LOI_Submitted_recordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LOI_Submitted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPA LOI Submitted recordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Status_Saved</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Saved</literalValue>
        <name>CPA Status Saved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Approval Comment Flag for LOI</fullName>
        <actions>
            <name>Approval_Comment_Requested_for_LOI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_LOI__c.pkl_Approval_Comment_Check__c</field>
            <operation>equals</operation>
            <value>Required</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI Accepted</fullName>
        <actions>
            <name>CPA_LOI_Accepted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_LOI_Accepted_Recordtype</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_LOI_Accepted_date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_LOI__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI Cancelled</fullName>
        <actions>
            <name>CPA_LOI_cancelled_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_LOI_Cancelled_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_LOI_Cancelled_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_LOI__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI Cloned%2FCreated</fullName>
        <actions>
            <name>CPA_Status_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_LOI__c.pkl_Status__c</field>
            <operation>notEqual</operation>
            <value>Saved</value>
        </criteriaItems>
        <description>When LOI is cloned/Created,STATUS is set to Saved.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI RE-Submitted</fullName>
        <actions>
            <name>CPA_LOI_Record_ReSubmitted</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_LOI_RE_Submitted_Date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_LOI__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Resubmitted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI Returned</fullName>
        <actions>
            <name>CPA_LOI_Returned_Email_Update</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_LOI_Accepted_Recordtype</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_LOI_Returned_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_LOI__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Returned</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI Send for Signature</fullName>
        <actions>
            <name>CPA_LOI_Record_send_for_Signature</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_LOI_Sent_for_Signature_Date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_LOI__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Sent for Signature</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI Signed</fullName>
        <actions>
            <name>CPA_LOI_Record_Signed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_LOI_Cancelled_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_LOI_Signed_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_LOI__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Signed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI Submitted</fullName>
        <actions>
            <name>CPA_LOI_Record_Submitted</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_LOI_Submitted_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_LOI__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
