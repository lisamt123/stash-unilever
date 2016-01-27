<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CAP_Email_after_PWO_is_Accepted</fullName>
        <description>CAP Email after PWO is Accepted</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPM_group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWO_Accepted</template>
    </alerts>
    <alerts>
        <fullName>CAP_Email_after_PWO_is_Retuned</fullName>
        <description>CAP Email after PWO is Retuned</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULFT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPM_group</recipient>
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
        <template>CPA_Email_Template/CPA_PWO_Return</template>
    </alerts>
    <alerts>
        <fullName>CAP_Email_after_PWO_is_cancelled</fullName>
        <description>CAP Email after PWO is cancelled</description>
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
        <template>CPA_Email_Template/CPA_PWO_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWO_Accepted_Email_Alert</fullName>
        <description>CPA PWO Accepted Email Alert</description>
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
        <template>CPA_Email_Template/CPA_PWO_Accepted</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWO_Cancelled_Email_Alert</fullName>
        <description>CPA PWO Cancelled Email Alert</description>
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
        <template>CPA_Email_Template/CPA_PWO_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWO_Delivered_Email_Alert</fullName>
        <description>CPA PWO Delivered Email Alert</description>
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
        <template>CPA_Email_Template/CPA_PWO_Delivered</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWO_Resubmitted_Email_Alert</fullName>
        <description>CPA PWO Resubmitted Email Alert</description>
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
        <template>CPA_Email_Template/CPA_PWO_Resubmitted</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWO_Returned_Email_Alert</fullName>
        <description>CPA PWO Returned Email Alert</description>
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
        <template>CPA_Email_Template/CPA_PWO_Accepted</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWO_Sent_for_Signature_Email_Alert</fullName>
        <description>CPA PWO Sent for Signature Email Alert</description>
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
        <template>CPA_Email_Template/CPA_PWO_Sent_For_Signature</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWO_Signed_Email_Alert</fullName>
        <description>CPA PWO Signed Email Alert</description>
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
        <template>CPA_Email_Template/CPA_PWO_Signed</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWO_Submitted_Email_Alert</fullName>
        <description>CPA PWO Submitted Email Alert</description>
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
        <template>CPA_Email_Template/CPA_PWO_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CPA_Pwo_Submit_Alert_to_ULPM_and_SMT</fullName>
        <description>CPA Pwo Submit Alert to ULPM and SMT</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>CAP_PWO_Returned</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Returned</literalValue>
        <name>CAP PWO Returned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_PWO_Withhold</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>CAP  PWO Withhold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_Pwo_Cancelled</fullName>
        <field>dat_Cancelled_Date__c</field>
        <formula>Today()</formula>
        <name>CAP  Pwo Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Accepted_Date_Update</fullName>
        <field>dat_Accepted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWO Accepted Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Accepted_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CPA_PWO_Signed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPA PWO Accepted Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Cancelled_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CPA_PWO_Cancel</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPA PWO Cancelled Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Cancelled_date_update</fullName>
        <field>dat_Cancelled_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWO Cancelled date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Delivered_Date_Update</fullName>
        <field>dat_Delivered_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWO Delivered Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Delivered_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CPA_PWO_Delivered</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPA PWO Delivered Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Other_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CPA_PWO_Other</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPA PWO Other Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Owner_Update_to_SMT</fullName>
        <field>OwnerId</field>
        <lookupValue>CPA_SMT</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPA PWO Owner Update to SMT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Owner_Update_to_VDM</fullName>
        <field>OwnerId</field>
        <lookupValue>CAP_VDM_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPA PWO Owner Update to VDM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Resubmitted_Date_Update</fullName>
        <field>dat_Resubmitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWO Resubmitted Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Returned_date_update</fullName>
        <field>dat_Returned_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWO Returned date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Sataus_SentforTermination</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Sent For Termination</literalValue>
        <name>CPA PWO Sataus SentforTermination</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Sent_for_Signature_Date_Update</fullName>
        <field>dat_Sent_for_Signature_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWO Sent for Signature Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Signed_date_update</fullName>
        <field>dat_Signed_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWO Signed date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Status_Accepted</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>CPA PWO Status Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Status_Accepted_Date</fullName>
        <field>dat_Accepted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWO Status Accepted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Status_Rejected_date</fullName>
        <field>dat_Returned_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWO Status Rejected date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Status_Submitted</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>CPA PWO Status Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Status_Submitted_Date</fullName>
        <field>dat_Submitted_Date__c</field>
        <formula>Today()</formula>
        <name>CPA PWO Status Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Status_Terminated_c</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Terminated</literalValue>
        <name>CPA PWO Status Terminated__c</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_Submitted_Date_Update</fullName>
        <field>dat_Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWO Submitted Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_isSentforTermination</fullName>
        <field>chk_isSentForTermination__c</field>
        <literalValue>0</literalValue>
        <name>CPA PWO isSentforTermination</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWO_isTerminated</fullName>
        <field>chk_isTerminated__c</field>
        <literalValue>0</literalValue>
        <name>CPA PWO isTerminated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
    <fieldUpdates>
        <fullName>Update_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>CPA_SMT</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CPA PWO Accepted</fullName>
        <actions>
            <name>CPA_PWO_Accepted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWO_Accepted_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWO_Accepted_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Cancelled</fullName>
        <actions>
            <name>CPA_PWO_Cancelled_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWO_Cancelled_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWO_Cancelled_date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Cloned%2FCreated</fullName>
        <actions>
            <name>CPA_Status_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.pkl_Status__c</field>
            <operation>notEqual</operation>
            <value>Saved</value>
        </criteriaItems>
        <description>When PWO is cloned/Created,STATUS is set to Saved.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Delivered</fullName>
        <actions>
            <name>CPA_PWO_Delivered_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWO_Delivered_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWO_Delivered_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Delivered</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Resubmitted</fullName>
        <actions>
            <name>CPA_PWO_Resubmitted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWO_Resubmitted_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Resubmitted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Returned</fullName>
        <actions>
            <name>CPA_PWO_Returned_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWO_Other_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWO_Returned_date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Returned</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Sent for Signature</fullName>
        <actions>
            <name>CPA_PWO_Sent_for_Signature_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWO_Sent_for_Signature_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Sent for Signature</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Sent for Termination</fullName>
        <actions>
            <name>CPA_PWO_Sataus_SentforTermination</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWO_isSentforTermination</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.chk_isSentForTermination__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Signed</fullName>
        <actions>
            <name>CPA_PWO_Signed_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWO_Accepted_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWO_Signed_date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Signed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Submitted</fullName>
        <actions>
            <name>CPA_PWO_Submitted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWO_Submitted_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Termination</fullName>
        <actions>
            <name>CPA_PWO_Status_Terminated_c</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWO_isTerminated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWO__c.chk_isTerminated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
