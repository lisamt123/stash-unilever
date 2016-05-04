<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BC_updateBrandNameUnique</fullName>
        <field>Brand_Name_unique__c</field>
        <formula>Name</formula>
        <name>BC_updateBrandNameUnique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BC_updateBrandNameUnique</fullName>
        <actions>
            <name>BC_updateBrandNameUnique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Brand_Centre_New__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
