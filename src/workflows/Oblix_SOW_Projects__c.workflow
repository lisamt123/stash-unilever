<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Oblix_FUPercentOfFee</fullName>
        <field>Percentage_of_Fee_for_this_FY__c</field>
        <formula>CASE( Project_Stage__c , &quot;&quot;, 0, &quot;Briefing&quot;, 0.1, &quot;Strategy &amp; Planning&quot;, 0.3,&quot;Creative Ideation&quot;, 0.6, &quot;Creative Execution&quot;, 0.85, &quot;Production&quot;, 1,0.1)</formula>
        <name>Oblix_FUPercentOfFee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
&amp;&amp; $Setup.Oblix_Check_For_Manual_Edit_Of_Campaign__c.Manual_Edit_Check__c = true &amp;&amp;
(
(TEXT(Financial_Year__r.Sync_Status__c) == &apos;Sync Completed&apos; 
|| TEXT(Financial_Year__r.Sync_Status__c)== &apos;Campaign Sync Required&apos;) 
&amp;&amp; Financial_Year__r.Initial_Approval_Complete__c == true &amp;&amp; (TEXT(Sync_Status__c) == &apos;Sync Completed&apos; || ISBLANK(TEXT(Sync_Status__c)))
&amp;&amp; PRIORVALUE(Sync_Status__c) &lt;&gt; &apos;Sync In Progress&apos; &amp;&amp; Name_Suffix__c &lt;&gt; &apos;Finalised&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Oblix_WF01PercentOfFee</fullName>
        <actions>
            <name>Oblix_FUPercentOfFee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED( Project_Stage__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Oblix_WF02_UpdateNameUniqueCampaign</fullName>
        <active>false</active>
        <description>Used to Update Unique Field with Id of record, to avoid having duplicate records with the same name</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
