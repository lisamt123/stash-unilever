<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Approved_by_GVP</fullName>
        <field>SOW_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved by GVP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Locked_for_Approval_By_GVP</fullName>
        <field>SOW_Status__c</field>
        <literalValue>Locked</literalValue>
        <name>Locked for Approval By GVP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OblixFU_UniqueName</fullName>
        <field>Oblix_tec_Unique_Name__c</field>
        <formula>Name</formula>
        <name>OblixFU_UniqueName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OblixReturned_By_GVP</fullName>
        <field>SOW_Status__c</field>
        <literalValue>Returned</literalValue>
        <name>Returned By GVP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Returned_By_GVP</fullName>
        <field>SOW_Status__c</field>
        <literalValue>Returned</literalValue>
        <name>Returned By GVP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Oblix_WF02_UpdateNameUnique</fullName>
        <actions>
            <name>OblixFU_UniqueName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WF used to update technical field name for having unicity</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
