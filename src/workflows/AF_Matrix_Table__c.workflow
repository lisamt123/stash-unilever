<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Matrix_Table_Country_Currency</fullName>
        <field>AF_Matrix_country_Currency__c</field>
        <formula>text(AF_Matrix_Country__c) &amp; &quot;-&quot; &amp; text(AF_Matrix_Currency_Code__c)</formula>
        <name>Update Matrix Table Country - Currency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Ready_For_PO_Country_Currency</fullName>
        <field>AF_Ready_For_PO_Country_Currency__c</field>
        <formula>text( AF_Ready_For_PO_Country__c ) &amp; &quot;-&quot; &amp; text( AF_Ready_For_PO_Currency_Code__c )</formula>
        <name>Update Ready For PO  Country - Currency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AF_MatrixTable_Currency_Check</fullName>
        <actions>
            <name>Update_Matrix_Table_Country_Currency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED( AF_Matrix_Country__c ) &amp;&amp; ISCHANGED( AF_Matrix_Currency_Code__c )) || isnew()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AF_Ready_For_Po_Currency_Check</fullName>
        <actions>
            <name>Update_Ready_For_PO_Country_Currency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED( AF_Ready_For_PO_Country__c ) &amp;&amp; ISCHANGED( AF_Ready_For_PO_Currency_Code__c )) || isnew()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
