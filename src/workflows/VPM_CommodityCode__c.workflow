<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>VPM_PopulateCommodityUnique</fullName>
        <field>VPM_CommodityRegionUnique__c</field>
        <formula>VPM_CommodityCode__c &amp;&quot;_&quot;&amp; TEXT(VPM_Region__c )</formula>
        <name>Populate Commodity Region</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VPM Commodity Region Unique</fullName>
        <actions>
            <name>VPM_PopulateCommodityUnique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populates the unique field storing Commodity Name and Region</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
