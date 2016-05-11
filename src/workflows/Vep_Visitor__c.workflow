<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>VEP_Send_Approved_Email_to_Visitor_Alert</fullName>
        <description>VEP_Send Approved Email to Visitor Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VEP_Templates/VEP_Send_Approved_Email_to_Visitor</template>
    </alerts>
    <alerts>
        <fullName>VEP_Send_Email_to_Factory_manager_Alert</fullName>
        <description>VEP_Send Email to Factory Manager Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Factory_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VEP_Templates/VEP_Send_Email_to_Factory_Manager_Template</template>
    </alerts>
    <alerts>
        <fullName>VEP_Send_Email_to_Lodging_Desk_Alert</fullName>
        <description>VEP_Send Email to Lodging Desk Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Lodging_Desk_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VEP_Templates/VEP_Send_Email_to_Lodging_Desk</template>
    </alerts>
    <alerts>
        <fullName>VEP_Send_Email_to_Pickup_Desk_EA</fullName>
        <description>VEP_Send_Email_to_Pickup Desk EA</description>
        <protected>false</protected>
        <recipients>
            <field>Pickup_Desk_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VEP_Templates/VEP_Send_Pickup_Email_to_Factory_Pickup_Desk</template>
    </alerts>
    <alerts>
        <fullName>VEP_Send_Email_to_Travel_Desk_Alert</fullName>
        <description>VEP_Send Email to Travel Desk Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Travel_Desk_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VEP_Templates/VEP_Send_Email_to_Travel_Desk</template>
    </alerts>
    <alerts>
        <fullName>VEP_Send_Email_to_Visitor_about_Lodging_Status_EA</fullName>
        <description>VEP Send Email to Visitor about Lodging Status EA</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VEP_Templates/VEP_Send_Email_to_Visitor_about_Lodging_Status</template>
    </alerts>
    <alerts>
        <fullName>VEP_Send_Email_to_Visitor_about_Travel_Status_EA</fullName>
        <description>VEP_Send_Email_to_Visitor_about_Travel_Status EA</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VEP_Templates/VEP_Send_Email_to_Visitor_about_Travel_Status</template>
    </alerts>
    <alerts>
        <fullName>VEP_Send_Email_to_Wisitor_on_Behalf_Alert</fullName>
        <description>VEP_Send Email to Wisitor on Behalf_Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VEP_Templates/VEP_Pass_Email_to_Visitor_on_Behalf</template>
    </alerts>
    <alerts>
        <fullName>VEP_Send_Rejected_Email_to_visitor_Alert</fullName>
        <description>VEP_Send Rejected Email to visitor Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VEP_Templates/VEP_Send_Rejected_Email_to_Visitor</template>
    </alerts>
    <fieldUpdates>
        <fullName>VEP_Changeto_Readonly_Layout</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Request_Readonly</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>VEP_Changeto_Readonly Layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VEP_UpdateEndTime</fullName>
        <field>Visitor_Exit_Date__c</field>
        <formula>NOW()</formula>
        <name>VEP_UpdateEndTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VEP_UpdateEntryTimeField</fullName>
        <field>Visitor_Entry_Date__c</field>
        <formula>NOW()</formula>
        <name>VEP_UpdateEntryTimeField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VEP_Update_Status_to_Visit_Complete</fullName>
        <field>Status__c</field>
        <literalValue>Visit Complete</literalValue>
        <name>VEP Update Status to Visit Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VEP_Update_Status_to_Visit_in_Progress</fullName>
        <field>Status__c</field>
        <literalValue>Visit In Progress</literalValue>
        <name>VEP Update Status to Visit in Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VEP_Visitor_status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>VEP_Visitor status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VEP_Visitor_status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>VEP_Visitor status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VEP Send Email to Visitor about Lodging Status WF</fullName>
        <actions>
            <name>VEP_Send_Email_to_Visitor_about_Lodging_Status_EA</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Vep_Visitor__c.Lodging_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Lodging_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VEP Send Email to Visitor about Travel Status WF</fullName>
        <actions>
            <name>VEP_Send_Email_to_Visitor_about_Travel_Status_EA</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Vep_Visitor__c.Travel_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Travel_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VEP Update Status to Visit Complete WF</fullName>
        <actions>
            <name>VEP_UpdateEndTime</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VEP_Update_Status_to_Visit_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Vep_Visitor__c.Visit_Ended__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.In_Visit__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VEP Update Status to Visit in Progress WF</fullName>
        <actions>
            <name>VEP_UpdateEntryTimeField</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VEP_Update_Status_to_Visit_in_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Vep_Visitor__c.In_Visit__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Visit_Ended__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VEP_Send Email to Lodging Desk WF</fullName>
        <actions>
            <name>VEP_Send_Email_to_Lodging_Desk_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR (4 AND 5))</booleanFilter>
        <criteriaItems>
            <field>Vep_Visitor__c.Lodging__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Lodging_Desk_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Request on Behalf</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Visit</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VEP_Send Email to Pickup Desk WF</fullName>
        <actions>
            <name>VEP_Send_Email_to_Pickup_Desk_EA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR (4 AND 5))</booleanFilter>
        <criteriaItems>
            <field>Vep_Visitor__c.Pickup__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Pickup_Desk_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Request on Behalf</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Visit</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VEP_Send Email to Travel Desk WF</fullName>
        <actions>
            <name>VEP_Send_Email_to_Travel_Desk_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR (4 AND 5))</booleanFilter>
        <criteriaItems>
            <field>Vep_Visitor__c.Travel__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Travel_Desk_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Request on Behalf</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Visit</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VEP_Send Email to Visitor on Behalf Of</fullName>
        <actions>
            <name>VEP_Send_Email_to_Wisitor_on_Behalf_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Vep_Visitor__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Request on Behalf</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vep_Visitor__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Visit</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
