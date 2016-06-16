<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CEC_Send_SA_Courier_Email</fullName>
        <ccEmails>masood.ansari@capgemini.com</ccEmails>
        <description>CEC Send SA Courier Email</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>CEC_Emails_South_Africa/CEC_SA_Courier_Email</template>
    </alerts>
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
</Workflow>
