<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Brand_Experience_Tag</fullName>
        <field>Brand_Experience_Tag__c</field>
        <formula>Name &amp;&quot;,&quot;&amp; uw_Brand__r.Name &amp;&quot;,&quot;&amp; TEXT(Product_Category_Sub_Division__c)</formula>
        <name>Populate Brand Experience Tag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
