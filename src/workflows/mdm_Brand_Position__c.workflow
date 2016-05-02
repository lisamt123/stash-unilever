<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>RestrictDuplicate_Field_Update</fullName>
        <field>DuplicateRestrict__c</field>
        <formula>Category_Code__c &amp; &quot;-&quot; &amp; Brand_Position_Code__c &amp; &quot;-&quot; &amp;  Brand_Code__c &amp; &quot;-&quot; &amp; Country_Code__c &amp; &quot;-&quot; &amp; Market_Code__c</formula>
        <name>RestrictDuplicate Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Brand Position Duplicate Restriction</fullName>
        <actions>
            <name>RestrictDuplicate_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Uses a Field Update to populate the unique &quot;Duplicate Restriction&quot; text field with a combination of Country Code, Brand Code, Brand Position Code,  Small C category Code and Market Code.</description>
        <formula>OR(  ISBLANK( DuplicateRestrict__c ) ,  ISCHANGED( Country_Code__c ),  ISCHANGED( Category_Code__c  ) ,  ISCHANGED(  Brand_Code__c ),  ISCHANGED(  Brand_Position_Code__c ),  ISCHANGED(  Market_Code__c )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
