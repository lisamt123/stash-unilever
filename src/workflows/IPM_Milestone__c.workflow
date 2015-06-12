<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Milestone_Name</fullName>
        <field>Name</field>
        <formula>LEFT(IPM_Project__r.IPM_Project_Name__c + &apos;-&apos; + IPM_Name__c, 78)</formula>
        <name>Update Milestone Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Rename Milestone Name</fullName>
        <actions>
            <name>Update_Milestone_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
