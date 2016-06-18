<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CEC_Send_SA_Courier_Email</fullName>
        <ccEmails>masood.ansari@capgemini.com</ccEmails>
        <description>CEC Send SA Courier Email</description>
        <protected>false</protected>
        <senderAddress>maansari@capgemini.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CEC_Emails_South_Africa/CEC_SA_Courier_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>CEC_Case_Status_New</fullName>
        <description>CEC - Update the Case Status to &apos;New&apos;</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>CEC_Case Status New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Retrieval_Request_Record_Type_Change</fullName>
        <description>CEC Retrieval Request Record Type Change is used to change the record type is retrieval status is changed from New.</description>
        <field>RecordTypeId</field>
        <lookupValue>Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CEC Retrieval Request Record Type Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Set_Case_Status_New_RetrievalRequest</fullName>
        <description>CEC Set Case Status New is used to set the case status to &apos;New&apos; if Retrieval status = ‘Resolved’, ’Clothing Delivered’ .</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>CEC Set Case Status New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Update_Courier_Email_Sent</fullName>
        <description>CEC Update Courier Email Sent is used to set the field Courier Email Sent checkbox to true</description>
        <field>Courier_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>CEC Update Courier Email Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CEC Change Retrieval Request Page Layout</fullName>
        <actions>
            <name>CEC_Retrieval_Request_Record_Type_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CEC_Retrieval_Request__c.Retrieval_Status__c</field>
            <operation>notEqual</operation>
            <value>New</value>
        </criteriaItems>
        <description>CEC Change Retrieval Request Page Layout is used to change the page layout to Retrieval Request layout(read Only).</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC South Africa Send Courier Email</fullName>
        <actions>
            <name>CEC_Send_SA_Courier_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CEC_Update_Courier_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Country_Name__c</field>
            <operation>equals</operation>
            <value>South Africa</value>
        </criteriaItems>
        <criteriaItems>
            <field>CEC_Retrieval_Request__c.Retrieval_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Update Case Status</fullName>
        <actions>
            <name>CEC_Set_Case_Status_New_RetrievalRequest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CEC_Retrieval_Request__c.Retrieval_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled,Clothing Delivered,Resolved</value>
        </criteriaItems>
        <description>CEC Update Case Status is used to update the Case status to &apos;New&apos; if retrieval request status is ‘Resolved’ or ’Clothing Delivered’ .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
