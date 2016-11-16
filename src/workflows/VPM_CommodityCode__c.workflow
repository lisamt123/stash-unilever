<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
