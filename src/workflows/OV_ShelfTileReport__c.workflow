<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OV_UpdateReportIcon</fullName>
        <field>Icon__c</field>
        <formula>Text(Shelf_Tile__r.Tile_ICON__c)</formula>
        <name>OV_UpdateReportIcon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Report__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OV_UpdateReportcolour</fullName>
        <description>Updates the colour on the report from the shelf-tile junction</description>
        <field>Colour__c</field>
        <formula>Shelf_Tile__r.Shelf__r.Colour__c</formula>
        <name>OV_UpdateReportcolour</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Report__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>OV_Update_Report_Colour</fullName>
        <actions>
            <name>OV_UpdateReportIcon</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>OV_UpdateReportcolour</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>OV_ShelfTileReport__c.provoke_workflow__c</field>
            <operation>equals</operation>
            <value>go</value>
        </criteriaItems>
        <criteriaItems>
            <field>OV_Shelf_Tile__c.Tile_Colour__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
