<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CI_R2R_Update_Budget_Line_Field</fullName>
        <field>Budget_Line__c</field>
        <formula>CI_R2R_Innovation__r.Count_for_Budget__c  + 1</formula>
        <name>CI_R2R Update Budget Line Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CI_R2R Budget Line</fullName>
        <actions>
            <name>CI_R2R_Update_Budget_Line_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
