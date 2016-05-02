<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IPM_Check_Company_Card_Name_Unique</fullName>
        <field>IPM_Unique_Company_Card_Name__c</field>
        <formula>Name</formula>
        <name>Check Company Card Name Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IPM_Check_Unique_name</fullName>
        <actions>
            <name>IPM_Check_Company_Card_Name_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
