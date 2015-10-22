<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Asset_Install_Date</fullName>
        <description>Updating asset install date</description>
        <field>OOH_First_Install_Date__c</field>
        <formula>OOH_LastMoveDate__c</formula>
        <name>Update Asset Install Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Asset Install Date</fullName>
        <actions>
            <name>Update_Asset_Install_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>used to update asset install date if it is blank. Install date is updated with last move date</description>
        <formula>AND( ISBLANK( OOH_LastMoveDate__c ), false,  IF(OR(ISBLANK( OOH_First_Install_Date__c ),ISNULL( OOH_First_Install_Date__c )), true, false ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
