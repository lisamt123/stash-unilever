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
        <fullName>Oblix_FUUniqueNameCampaign</fullName>
        <field>Oblix_tec_Unique_Name_c__c</field>
        <formula>Name</formula>
        <name>Oblix_FUUniqueNameCampaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
</Workflow>
