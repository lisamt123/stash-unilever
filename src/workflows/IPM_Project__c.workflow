<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IPM_Project_Archival_Email_Alert</fullName>
        <description>IPM Project Archival Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/IPM_Project_Archival_Mail_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>IPM_Archive_Project</fullName>
        <description>Archive Project arter 4 Months</description>
        <field>Is_Archieved__c</field>
        <literalValue>1</literalValue>
        <name>IPM Archive Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IPM_Project_Name</fullName>
        <field>Name</field>
        <formula>IPM_Project_Name__c</formula>
        <name>Update IPM Project Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IPM Project Archival On Inactive</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project__c.Is_Archieved__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Project__c.IPM_Last_Modified_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Archive a Project if Inactive for More than 4 Weeks. Based on Last Modified Date REQ00378</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_Archive_Project</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IPM_Project__c.LastModifiedDate</offsetFromField>
            <timeLength>28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_Project_Archival_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IPM_Project__c.LastModifiedDate</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>IPM Project Name Updation</fullName>
        <actions>
            <name>Update_IPM_Project_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Project__c.IPM_Project_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>To update IPM Project Name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
