<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>VPM_UpdateCompanyCodeText</fullName>
        <description>Sets a value in Company Code (Text) taken from the Company Code Name lookup</description>
        <field>VPM_CompanyCodeText__c</field>
        <formula>VPM_CompanyCode__r.Name</formula>
        <name>VPM Update Company Code (Text)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateCountryText</fullName>
        <description>Updates Country (Text) with the value from Country, which is a picklist field</description>
        <field>VPM_CountryText__c</field>
        <formula>TEXT(VPM_Country__c)</formula>
        <name>VPM Update Country (Text)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdatePOSystemText</fullName>
        <description>Populates PO System (Text) with the value from PO System, which is a picklist</description>
        <field>VPM_POSystemText__c</field>
        <formula>TEXT(VPM_POSystem__c)</formula>
        <name>VPM Update PO System (Text)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VPM Update Text Values on Purchasing Org</fullName>
        <actions>
            <name>VPM_UpdateCompanyCodeText</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_UpdateCountryText</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_UpdatePOSystemText</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates text fields based on values in picklists so the values can be searched on in lookup dialogues</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
