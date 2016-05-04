<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Key</fullName>
        <field>key__c</field>
        <formula>RecordType.DeveloperName &amp;&quot;|&quot;&amp; AF_Agency__r.Name &amp;&quot;|&quot; &amp; text(AF_Country__c)</formula>
        <name>Update Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Key</fullName>
        <actions>
            <name>Update_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
