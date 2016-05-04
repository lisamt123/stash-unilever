<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FAU_Request_Travel_Details</fullName>
        <description>FAU Request Travel Details</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_Participant_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_Request_Travel_Details</template>
    </alerts>
    <fieldUpdates>
        <fullName>FAU_Fill_ModPartPA_Email</fullName>
        <field>FAU_Participant_PA_s_Email__c</field>
        <formula>FAU_Participant__r.FAU_Personal_Assistant_s_Email__c</formula>
        <name>FAU_Fill_ModPartPA_Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Fill_ModPart_Email</fullName>
        <field>FAU_Participant_s_Email__c</field>
        <formula>FAU_Participant__r.FAU_User__r.Email</formula>
        <name>FAU_Fill_ModPart_Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Request_Travel_Details_1</fullName>
        <description>FAU Request Travel Details</description>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Request Travel Details 1&quot;</formula>
        <name>FAU Request Travel Details 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Participant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Request_Travel_Details_2</fullName>
        <description>FAU Request Travel Details 2</description>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Request Travel Details 2&quot;</formula>
        <name>FAU Request Travel Details 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Participant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Request_Travel_Details_3</fullName>
        <description>FAU Request Travel Details 3</description>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Request Travel Details&quot;</formula>
        <name>FAU Request Travel Details 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Participant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Set_Module_Part_to_Campus</fullName>
        <field>RecordTypeId</field>
        <lookupValue>FAU_Campus</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FAU Set Module Part to Campus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Set_Module_Part_to_Off_Campus</fullName>
        <field>RecordTypeId</field>
        <lookupValue>FAU_Off_Campus</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FAU Set Module Part to Off Campus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FAU Fill Module Part Emails</fullName>
        <actions>
            <name>FAU_Fill_ModPartPA_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAU_Fill_ModPart_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FIELD UPDATES: FAU Fill Module Partcipant Emails</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAU Is Campus Module Participant</fullName>
        <actions>
            <name>FAU_Set_Module_Part_to_Campus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>FAU_Module_Participant__c.FAU_Program_Location__c</field>
            <operation>equals</operation>
            <value>Singapore</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Module_Participant__c.FAU_Program_Location__c</field>
            <operation>equals</operation>
            <value>London</value>
        </criteriaItems>
        <description>FIELD UPDATE: Update Module Participant to Campus</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAU Is Off Campus Module Participant</fullName>
        <actions>
            <name>FAU_Set_Module_Part_to_Off_Campus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>FAU_Module_Participant__c.FAU_Program_Location__c</field>
            <operation>notEqual</operation>
            <value>Singapore</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Module_Participant__c.FAU_Program_Location__c</field>
            <operation>notEqual</operation>
            <value>London</value>
        </criteriaItems>
        <description>FIELD UPDATE: Update Module Participant to Off Campus</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAU PA Request Travel Details</fullName>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Module_Participant__c.FAU_Module_Complete_Flag__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Module_Participant__c.FAU_Participant_s_Invite_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Is_deferred_To_PA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>EMAIL: Send Reminders to fill Module Travel and Accommodation Details</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Request_Travel_Details</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Request_Travel_Details_3</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Module_Participant__c.FAU_Module_Start_Date__c</offsetFromField>
            <timeLength>-35</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Request_Travel_Details</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Request_Travel_Details_2</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Module_Participant__c.FAU_Module_Start_Date__c</offsetFromField>
            <timeLength>-14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Request_Travel_Details</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Request_Travel_Details_1</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Module_Participant__c.FAU_Module_Start_Date__c</offsetFromField>
            <timeLength>-63</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FAU Request Travel Details</fullName>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Module_Participant__c.FAU_Module_Complete_Flag__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Module_Participant__c.FAU_Participant_s_Invite_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Is_deferred_To_PA__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>EMAIL: Send Reminders to fill Module Travel and Accommodation Details</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Request_Travel_Details</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Request_Travel_Details_2</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Module_Participant__c.FAU_Workflow_Start_Date__c</offsetFromField>
            <timeLength>-35</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Request_Travel_Details</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Request_Travel_Details_3</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Module_Participant__c.FAU_Workflow_Start_Date__c</offsetFromField>
            <timeLength>-14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Request_Travel_Details</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Request_Travel_Details_1</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Module_Participant__c.FAU_Workflow_Start_Date__c</offsetFromField>
            <timeLength>-63</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
