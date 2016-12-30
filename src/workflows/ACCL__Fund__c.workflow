<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UL_Fund_Sales_org_update</fullName>
        <field>UL_Sales_Organization__c</field>
        <formula>ACCL__Sales_Org__c</formula>
        <name>Fund Sales org update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UL_Sales org update on Fund</fullName>
        <actions>
            <name>UL_Fund_Sales_org_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ACCL__Fund__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
