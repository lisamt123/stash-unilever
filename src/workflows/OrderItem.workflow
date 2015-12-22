<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UID_UpdateOrderProductMateriaGroupField</fullName>
        <field>UID_Material_ID_Group__c</field>
        <formula>UID_Material_ID__c</formula>
        <name>UID_UpdateOrderProductMateriaGroupField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UID_UpdateSalesFlag</fullName>
        <field>UID_Sales_Flag__c</field>
        <formula>If(Order.RecordType.Name == &apos;Primary Sales&apos;,0,1)</formula>
        <name>UID_UpdateSalesFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UID_UpdateOrderProductMateriaGroup</fullName>
        <actions>
            <name>UID_UpdateOrderProductMateriaGroupField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OrderItem.UID_Material_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

