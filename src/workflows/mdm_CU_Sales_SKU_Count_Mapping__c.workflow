<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DeDupKey_Field_Update</fullName>
        <field>DeDupKey__c</field>
        <formula>Quarter_Name__c &amp; &quot;-&quot; &amp; Country__c  &amp; &quot;-&quot; &amp;  CU_Code__r.Name &amp; &quot;-&quot;  &amp;  Sector_Code__c  &amp; &quot;-&quot;  &amp;  Subsector_Code__c</formula>
        <name>DeDupKey Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CU Sales SKU Restrict Duplicate</fullName>
        <actions>
            <name>DeDupKey_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(   ISBLANK(DeDupKey__c) ,          ISCHANGED( Quarter_Name__c ),       ISCHANGED( Country__c ),          ISCHANGED( CU_Code__c  ),       ISCHANGED( Sector_Code__c ),       ISCHANGED( Subsector_Code__c )         )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
