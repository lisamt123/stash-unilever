<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Amr_Percentage_Saving_Average_of_Quote</fullName>
        <field>Percentage_Saving_Average_of_Quote__c</field>
        <formula>Euro_Saving_Average_of_Quotes__c*100/Average_Total_Opening_Quotes__c</formula>
        <name>Amr_Percentage_Saving_Average_of_Quote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Production_Type_Tv_Update</fullName>
        <field>Production_Type_Tv__c</field>
        <formula>&quot;Tv&quot;</formula>
        <name>Production Type Tv Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Job_Details__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Production_Type_Tv_Update</fullName>
        <field>Production_Type_Tv__c</field>
        <name>Production Type Tv Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
