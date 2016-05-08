<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Parent_SOW_to_Campaign_Sync_Required</fullName>
        <description>set the parent SOW sync_status to &quot;Campaign Sync Required&quot;</description>
        <field>Sync_Status__c</field>
        <literalValue>Campaign Sync Required</literalValue>
        <name>Set Parent SOW to Campaign Sync Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Financial_Year__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_To_Sync_Status_To_Sync_Required</fullName>
        <description>on edit of a campaign, set the sync status fields to &quot;Sync Required&quot;</description>
        <field>Sync_Status__c</field>
        <literalValue>Sync Required</literalValue>
        <name>Set To Sync Status To Sync Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Oblix Set Rollover Sync Status</fullName>
        <actions>
            <name>Set_Parent_SOW_to_Campaign_Sync_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_To_Sync_Status_To_Sync_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>set the status on individual campaigns to &quot;Sync Required&quot;  - 
Condition - parent SOW has sync status &quot;Sync Complete&quot;</description>
        <formula>TEXT(Financial_Year__r.Sync_Status__c) == &apos;Sync Complete&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
