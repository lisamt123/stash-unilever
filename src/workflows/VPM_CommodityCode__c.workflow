<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>VPM_CommodityClassRecordTypeName</fullName>
        <description>Writes the record type name as text in to the Commodity Class field</description>
        <field>VPM_CommodityClass__c</field>
        <formula>RecordType.Name</formula>
        <name>VPM Commodity Class Record Type Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VPM Populate Commodity Class</fullName>
        <actions>
            <name>VPM_CommodityClassRecordTypeName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populates the Commodity Class field from the name of the record type</description>
        <formula>ISNEW()
||
AND(
NOT(ISNEW()),
ISCHANGED( RecordTypeId )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
