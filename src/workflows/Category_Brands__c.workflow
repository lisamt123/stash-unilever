<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WP_Update_Category_Brand_Name</fullName>
        <field>Name</field>
        <formula>Category__r.Name &amp; &quot; - &quot; &amp;  Brand__r.Name</formula>
        <name>WP Update Category Brand Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WP Category Brand Name</fullName>
        <actions>
            <name>WP_Update_Category_Brand_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
