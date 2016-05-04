<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CEC_Update_GTIN_Last_4</fullName>
        <description>CEC Update the GTIN Code Last 4 field with the last 4 characters of GTIN (EAN/UPC) Code</description>
        <field>GTIN_Code_Last_4__c</field>
        <formula>RIGHT( TRIM( GTIN_EAN_UPC_Code__c ) , 4)</formula>
        <name>CEC Update GTIN Last 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CEC Capture Last 4 chars of GTIN</fullName>
        <actions>
            <name>CEC_Update_GTIN_Last_4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CEC capture the last 4 characters of the GTIN/UPC code on the record</description>
        <formula>GTIN_EAN_UPC_Code__c &lt;&gt; &quot;&quot;  &amp;&amp;  ( ISNEW()  ||  ISCHANGED( GTIN_EAN_UPC_Code__c ) ||  ISBLANK(GTIN_Code_Last_4__c)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
