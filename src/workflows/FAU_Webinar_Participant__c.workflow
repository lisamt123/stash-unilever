<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FAU_Bio_Fill_Invitation</fullName>
        <description>FAU Bio Fill Invitation</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_Participants_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_Fill_Biography_Invitation</template>
    </alerts>
    <fieldUpdates>
        <fullName>FAU_Fill_Participant_Email</fullName>
        <field>FAU_Participants_Email__c</field>
        <formula>FAU_Participant__r.FAU_User__r.Email</formula>
        <name>FAU Fill Participant Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Participant_s_PA_Email</fullName>
        <field>FAU_Participant_PA_s_Email__c</field>
        <formula>FAU_Participant__r.FAU_Personal_Assistant_s_Email__c</formula>
        <name>FAU Participant&apos;s PA Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Webinar_DT_on_Partcipant</fullName>
        <field>FAU_Webinar_Date_Time__c</field>
        <formula>FAU_Start_Time__c</formula>
        <name>FAU Update Webinar Date/Time on Part</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Participant__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>FAU Fill Webinear Part Emails FU</fullName>
        <actions>
            <name>FAU_Fill_Participant_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAU_Participant_s_PA_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FIELD UPDATES:  Fill Webinear Participant Correspondence Emails</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
