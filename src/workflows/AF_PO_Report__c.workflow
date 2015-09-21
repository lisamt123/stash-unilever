<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AF_Intial_POOveride_Adaption</fullName>
        <field>AF_PO_Override_Adapt_Report__c</field>
        <formula>PRIORVALUE( AF_Calculate_Adaptation_Local__c )</formula>
        <name>Intial POOveride Adaption</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_Intial_POOveride_Digital</fullName>
        <field>AF_PO_Override_Digital_Report__c</field>
        <formula>PRIORVALUE(  AF_Calculate_Digital_Local__c  )</formula>
        <name>Intial POOveride Digital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_Intial_POOveride_Traditonal</fullName>
        <field>AF_PO_Override_Trad_Report__c</field>
        <formula>PRIORVALUE( AF_Calculate_Tradition_Local__c )</formula>
        <name>Intial POOveride Traditonal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_PO_Override_Adaption</fullName>
        <field>AF_PO_Override_Adapt_Report__c</field>
        <formula>AF_Calculate_Adaptation_Local__c</formula>
        <name>PO Override Adaption</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_PO_Override_Digital</fullName>
        <field>AF_PO_Override_Digital_Report__c</field>
        <formula>AF_Calculate_Digital_Local__c</formula>
        <name>PO Override Digital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_PO_Override_Traditional</fullName>
        <field>AF_PO_Override_Trad_Report__c</field>
        <formula>AF_Calculate_Tradition_Local__c</formula>
        <name>PO Override Traditional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AF_PO Report_Trad_Override</fullName>
        <actions>
            <name>AF_PO_Override_Traditional</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK(AF_OverridePO_Traditional_LC__c),NOT(ISCHANGED(AF_OverridePO_Traditional_LC__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AF_POReport_Adapt_Override</fullName>
        <actions>
            <name>AF_PO_Override_Adaption</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK( AF_OverridePO_Adaptation_LC__c ),NOT(ISCHANGED( AF_OverridePO_Adaptation_LC__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AF_POReport_Digital_Override</fullName>
        <actions>
            <name>AF_PO_Override_Digital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK( AF_OverridePO_Digital_LC__c ),NOT(ISCHANGED(AF_OverridePO_Digital_LC__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Intial POOveride Adaption</fullName>
        <actions>
            <name>AF_Intial_POOveride_Adaption</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(   AF_OverridePO_Adaptation_LC__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Intial POOveride Digital</fullName>
        <actions>
            <name>AF_Intial_POOveride_Digital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(  AF_OverridePO_Digital_LC__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Intial POOveride Traditonal</fullName>
        <actions>
            <name>AF_Intial_POOveride_Traditonal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( AF_OverridePO_Traditional_LC__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
