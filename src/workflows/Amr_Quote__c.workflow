<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Amr_Euro_Saving_Accepted_Quote_Update</fullName>
        <field>Saving_Accepted_Quote_Euro__c</field>
        <formula>Total_Cost__c  -  Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c</formula>
        <name>Amr Euro Saving Accepted Quote Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Saving__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Amr_Percentage_Saving_AcceptedQuote</fullName>
        <field>Percentage_Saving_Accepted_Quote__c</field>
        <formula>Saving__r.Saving_Accepted_Quote_Euro__c / Total_Cost__c</formula>
        <name>Amr_Percentage_Saving_AcceptedQuote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Saving__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Amr_Percentage_Saving_Accepted_Quote</fullName>
        <field>Percentage_Saving_Accepted_Quote__c</field>
        <formula>if(Total_Cost__c  &lt;&gt; 0,Saving__r.Saving_Average_of_Quotes__c *100 / Total_Cost__c,0)</formula>
        <name>Amr_Percentage_Saving_Accepted_Quote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Saving__c</targetObject>
    </fieldUpdates>
</Workflow>
