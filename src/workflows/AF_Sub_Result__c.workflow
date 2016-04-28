<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AF_SubResult_ClassCode</fullName>
        <field>AF_Class_code__c</field>
        <literalValue>0</literalValue>
        <name>AF_SubResult_ClassCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_Result_Update_Key</fullName>
        <field>AF_Unique_Thresholds__c</field>
        <formula>key__c</formula>
        <name>Sub Result Update Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AF_SubResult_ClassCode</fullName>
        <actions>
            <name>AF_SubResult_ClassCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AF_Sub_Result__c.AF_Class_code__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sub Result Unique</fullName>
        <actions>
            <name>Sub_Result_Update_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
