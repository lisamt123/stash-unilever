<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_P_Document_Name</fullName>
        <field>Name</field>
        <formula>LEFT(IPM_Project__r.Name + &apos;-&apos; + TEXT(IPM_GateDocuments__c), 78)</formula>
        <name>Update P Document Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Rename Project Document</fullName>
        <actions>
            <name>Update_P_Document_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
