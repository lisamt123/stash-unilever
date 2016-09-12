<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Core_CA_ActionDate_Field_Update</fullName>
        <field>Action_Date__c</field>
        <formula>LastModifiedDate</formula>
        <name>Core CA ActionDate Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Core CA ActionDate WF Rule</fullName>
        <actions>
            <name>Core_CA_ActionDate_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>Invoice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>It will update action date to last modify if source system is Invoice.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Core CA ActionDate WF RuleThree</fullName>
        <actions>
            <name>Core_CA_ActionDate_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>Invoice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Return to AP</value>
        </criteriaItems>
        <description>It will update action date to last modify if source system is Invoice.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Core CA ActionDate WF RuleTwo</fullName>
        <actions>
            <name>Core_CA_ActionDate_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>Invoice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Query With Vendor</value>
        </criteriaItems>
        <description>It will update action date to last modify if source system is Invoice.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
