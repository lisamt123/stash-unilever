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
        <formula>$Setup.Oblix_Job_Orchestration__c.Job_Is_Running__c == false 
&amp;&amp; 
<<<<<<< HEAD
((TEXT(Financial_Year__r.Sync_Status__c) == &apos;Sync Completed&apos; || TEXT(Financial_Year__r.Sync_Status__c)== &apos;Campaign Sync Required&apos;) 
&amp;&amp; Financial_Year__r.Initial_Approval_Complete__c == true &amp;&amp; (TEXT(Sync_Status__c) == &apos;Sync Completed&apos; || ISBLANK(TEXT(Sync_Status__c)))
&amp;&amp; PRIORVALUE(Sync_Status__c) &lt;&gt; &apos;Sync In Progress&apos;)</formula>
=======
(
(TEXT(Financial_Year__r.Sync_Status__c) == &apos;Sync Completed&apos; 
|| TEXT(Financial_Year__r.Sync_Status__c)== &apos;Campaign Sync Required&apos;) 
&amp;&amp; Financial_Year__r.Initial_Approval_Complete__c == true &amp;&amp; (TEXT(Sync_Status__c) == &apos;Sync Completed&apos; || ISBLANK(TEXT(Sync_Status__c)))
&amp;&amp; PRIORVALUE(Sync_Status__c) &lt;&gt; &apos;Sync In Progress&apos; &amp;&amp; Name_Suffix__c &lt;&gt; &apos;Finalised&apos;)</formula>
>>>>>>> develop
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
