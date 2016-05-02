<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>key_update</fullName>
        <field>key__c</field>
        <formula>AF_Brand_Estimate__r.Name &amp;&quot;|&quot;&amp; Brand_Name__r.Name &amp;&quot;|&quot;&amp;  AF_Country__r.Name &amp;&quot;|&quot;&amp; Name</formula>
        <name>key update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>update key</fullName>
        <actions>
            <name>key_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
