<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UL_UpdateOrderDateFrom</fullName>
        <field>UL_Order_Date_From__c</field>
        <formula>ACSFUL001__Date_From__c</formula>
        <name>UL_UpdateOrderDateFrom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_UpdateOrderDateThru</fullName>
        <field>UL_Order_Date_Thru__c</field>
        <formula>ACSFUL001__Date_Thru__c</formula>
        <name>UL_UpdateOrderDateThru</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_Update_Lift_on_Tactic</fullName>
        <field>ACSFUL001__Lift__c</field>
        <formula>ACSFUL001__Promotion__r.UL_Lift__c</formula>
        <name>Update Lift% on Tactic</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UL_UpdateOrderDates</fullName>
        <actions>
            <name>UL_UpdateOrderDateFrom</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UL_UpdateOrderDateThru</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ACSFUL001__Tactic__c.ACSFUL001__Date_From__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This Workflow is used to update Order From and Order Thru dates on Tactic</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UL_Update_Tatics_Lift%25</fullName>
        <actions>
            <name>UL_Update_Lift_on_Tactic</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(!ISNULL(ACSFUL001__Promotion__r.UL_Lift__c ), true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
