<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Rollout_Span_Regional</fullName>
        <field>IPM_Rollout_Span__c</field>
        <literalValue>Regional</literalValue>
        <name>Rollout Span_Regional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rollout_Span_Local</fullName>
        <field>IPM_Rollout_Span__c</field>
        <literalValue>Local</literalValue>
        <name>Update Rollout Span Local</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Span_on_Local_rollout_Regional_O</fullName>
        <field>IPM_Rollout_Span__c</field>
        <literalValue>Local</literalValue>
        <name>Update Span on Local rollout- Regional O</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>To define Rollout Original Span Local</fullName>
        <actions>
            <name>Update_Span_on_Local_rollout_Regional_O</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will be used to update Rollout Span based on Record type</description>
        <formula>AND(RecordType.DeveloperName == &apos;Local_Rollouts&apos;, Regional_Project__r.IPM_CompanyCardText__c == &apos;Regional Company Card&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>To define Rollout Span</fullName>
        <actions>
            <name>Rollout_Span_Regional</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will be used to update Rollout Span based on Record type</description>
        <formula>AND(RecordType.DeveloperName == &apos;Regional_Rollout&apos;,IPM_Project__r.IPM_CompanyCardText__c = &apos;Global Company Card&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>To define Rollout Span Local</fullName>
        <actions>
            <name>Update_Rollout_Span_Local</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will be used to update Rollout Span based on Record type</description>
        <formula>AND(RecordType.DeveloperName == &apos;Local_Rollouts&apos;, Regional_Project__r.IPM_CompanyCardText__c == &apos;Global Company Card&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
