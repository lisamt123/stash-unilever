<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_WFCheckbox_on_Warehouse_Detail</fullName>
        <field>WFUpdateCheckbox__c</field>
        <literalValue>1</literalValue>
        <name>Update WFCheckbox on Warehouse Detail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WU_UpdateRefDate</fullName>
        <field>WU_Uncheck_Current_Month__c</field>
        <formula>DATE( YEAR( TODAY()), MONTH ( TODAY()) + 1, 1 )</formula>
        <name>WU_UpdateRefDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WU_UpdateTextCurrentMonth</fullName>
        <field>WU_CurrentMonth__c</field>
        <formula>IF( Is_In_Current_Month__c , &apos;Yes&apos;, &apos;No&apos;)</formula>
        <name>WU UpdateTextCurrentMonth</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WU_UpdateUtilizationTypeOnMaster</fullName>
        <field>WU_Current_Month_Utilization_Type__c</field>
        <formula>TEXT(WU_Utilization_Type__c)</formula>
        <name>WU UpdateUtilizationTypeOnMaster</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Master_Warehouse__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>WU SetCurrentMonth</fullName>
        <actions>
            <name>WU_UpdateTextCurrentMonth</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Text field used in rollup summary.</description>
        <formula>OR(ISCHANGED( Is_In_Current_Month__c ),ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WU Udpdate Warehouse Capacity Detail Committed Pallet Storage</fullName>
        <active>false</active>
        <criteriaItems>
            <field>WU_Warehouse_Capacity_Detail__c.Is_In_Current_Month__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>WU_Warehouse_Capacity_Detail__c.WU_Utilization_Start_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>WF will update that chk box at start of every month using next update date field, If future month records created, all those records will fall in time based  WF criteria</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_WFCheckbox_on_Warehouse_Detail</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>WU_Warehouse_Capacity_Detail__c.Next_Update_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WU UpdateCurrentMonthUtilizationType</fullName>
        <actions>
            <name>WU_UpdateUtilizationTypeOnMaster</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WU_Warehouse_Capacity_Detail__c.Is_In_Current_Month__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update current month utilization type on Master</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
