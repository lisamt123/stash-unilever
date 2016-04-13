<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CEC_Cheque_Sent_Update</fullName>
        <description>CEC: To set &apos;Cheque Sent&apos; to &apos;N&apos; whenever &apos;Cheque Voided&apos; field is updated to &apos;Y&apos;</description>
        <field>Cheque_Sent__c</field>
        <literalValue>0</literalValue>
        <name>CEC : Cheque Sent Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Fulfilment_Not_Submitted</fullName>
        <description>CEC: Check the isSubmitted value to True to indicate and Fulfilment is  not in submitted stage for approval process</description>
        <field>isSubmitted__c</field>
        <literalValue>0</literalValue>
        <name>CEC Fulfilment Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Fulfilment_Submitted</fullName>
        <description>CEC: Check the isSubmitted value to True to indicate and Fulfilment is in submitted stage for approval process</description>
        <field>isSubmitted__c</field>
        <literalValue>1</literalValue>
        <name>CEC Fulfilment Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Market_Update</fullName>
        <field>Market__c</field>
        <formula>Case_Market__c</formula>
        <name>Market Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QualityApproved</fullName>
        <field>isApproved__c</field>
        <literalValue>1</literalValue>
        <name>QualityApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>isApprovedAutoUpdate</fullName>
        <field>isApproved__c</field>
        <literalValue>1</literalValue>
        <name>isApprovedAutoUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CEC %3A Cheque Sent Update</fullName>
        <actions>
            <name>CEC_Cheque_Sent_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>cec_Fulfilment__c.Cheque_Voided__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>CEC: This rule will set &apos;Cheque Sent&apos; to &apos;N&apos; whenever &apos;Cheque Voided&apos; field is updated to &apos;Y&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Market Update</fullName>
        <actions>
            <name>Market_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>CEC_Rejected_correspondence</fullName>
        <assignedToType>owner</assignedToType>
        <description>Your consumer correspondence has been rejected by the Quality Check team and needs further amendments before being sent.

Please follow the link to the record and amend as requested. 

Thank you.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Rejected correspondence</subject>
    </tasks>
</Workflow>
