<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UID_UpdateStockedProductMaterialGroupFie</fullName>
        <field>UID_Material_ID_Group__c</field>
        <formula>UID_Material_Id__c</formula>
        <name>UID_UpdateStockedProductMaterialGroupFie</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UID_UpdateStockedProductMaterialGroup</fullName>
        <actions>
            <name>UID_UpdateStockedProductMaterialGroupFie</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>UID_Stocked_Product_Summary__c.UID_Material_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
