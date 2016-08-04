<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>VPM_UpdateCommodityCountryUnique</fullName>
        <description>VPM.</description>
        <field>VPM_CommodityCountryUnique__c</field>
        <formula>TEXT( VPM_CommodityClass__c) &amp;&quot;-&quot;&amp; 
TEXT( VPM_Country__c)</formula>
        <name>VPM Update Commodity Country Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VPM Commodity Country Unique</fullName>
        <actions>
            <name>VPM_UpdateCommodityCountryUnique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the unique text field with concatenation of Commodity Class and Country to ensure only one approver record per class per country is created</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
