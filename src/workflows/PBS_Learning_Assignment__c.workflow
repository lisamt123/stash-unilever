<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Course_Name</fullName>
        <field>Learning_Name__c</field>
        <formula>Learning__r.Name</formula>
        <name>Course Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SuMo Spotlight Course</fullName>
        <actions>
            <name>Course_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Adds Name of Course to Text Field</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
