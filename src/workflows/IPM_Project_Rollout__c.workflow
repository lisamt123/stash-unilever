<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IPM_Notify_Finance_Leader_the_TLD_changed_on_Rollout_Plan</fullName>
        <description>IPM Notify Finance Leader the TLD changed on Rollout Plan</description>
        <protected>false</protected>
        <recipients>
            <field>Finance_Member__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Workflow_Emails/IPM_Notify_Finance_Leader_about_TLD_is_changed_in_Rollout_Project</template>
    </alerts>
    <alerts>
        <fullName>IPM_Notify_Project_Leader_for_FL_TLD_confirmation_on_Regional_Project</fullName>
        <description>IPM Notify Project Leader for FL TLD confirmation on Regional Project</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Regional_PL__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Workflow_Emails/IPM_Notify_Project_Leader_about_FL_confirm_TLD_change</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_GFL_for_TLD_change_in_MCO_Country_Plan</fullName>
        <description>Notification to GFL for TLD change in MCO/Country Plan</description>
        <protected>false</protected>
        <recipients>
            <field>Global_Regional_Finance_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Emails/IPM_Notify_Finance_Leader_about_TLD_is_changed_in_Rollout_Project</template>
    </alerts>
    <fieldUpdates>
        <fullName>Global_Regional_Finance_Leader_Update</fullName>
        <description>Global Regional Finance Leader Update</description>
        <field>Global_Regional_Finance_Leader_Email__c</field>
        <formula>IF( ISPICKVAL(IPM_Project__r.IPM_Project_Type__c, &apos;Original&apos;) &amp;&amp;ISPICKVAL(IPM_Project__r.IPM_Phase__c, &apos;Ideas&apos;) &amp;&amp; ( !ISBLANK(IPM_Project__r.IPM_Finance_Member__c ) ) ,  IPM_Project__r.IPM_Finance_Member__r.Email ,  
IF(ISPICKVAL(Regional_Project__r.IPM_Project_Type__c, &apos;Original&apos;) &amp;&amp; ISPICKVAL(Regional_Project__r.IPM_Phase__c, &apos;Ideas&apos;) &amp;&amp; ( ISBLANK(Regional_Project__r.IPM_Finance_Member__c )), Regional_Project__r.IPM_Finance_Member__r.Email, &apos;&apos;))</formula>
        <name>Global Regional Finance Leader Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Target_Launch_Date_Update</fullName>
        <field>Previous_Target_Launch_Date__c</field>
        <formula>PRIORVALUE( Target_Launch_Date__c )</formula>
        <name>Previous Target Launch Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rollout_Span_Regional</fullName>
        <field>IPM_Rollout_Span__c</field>
        <literalValue>Regional</literalValue>
        <name>Rollout Span_Regional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FL_Confirm_button</fullName>
        <field>MisAligned_Confirmed_By_Finance_Leader__c</field>
        <literalValue>0</literalValue>
        <name>Update FL Confirm button</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rollout_Span_Local</fullName>
        <field>IPM_Rollout_Span__c</field>
        <literalValue>Local</literalValue>
        <name>Update Rollout Span Local</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Span_on_Local_rollout_Regional_O</fullName>
        <field>IPM_Rollout_Span__c</field>
        <literalValue>Local</literalValue>
        <name>Update Span on Local rollout- Regional O</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Global Regional Finance Leader Update on Rollout</fullName>
        <actions>
            <name>Global_Regional_Finance_Leader_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Global Regional Finance Leader Update on Rollout</description>
        <formula>OR(ISCHANGED( Previous_Target_Launch_Date__c ),  ISBLANK(Global_Regional_Finance_Leader_Email__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPM Previous Target Launch Date Update on Rollout</fullName>
        <actions>
            <name>Previous_Target_Launch_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>IPM Previous Target Launch Date Update on Rollout</description>
        <formula>ISCHANGED( Target_Launch_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification to GFL for TLD change in MCO%2FCountry Plan</fullName>
        <actions>
            <name>Notification_to_GFL_for_TLD_change_in_MCO_Country_Plan</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notification to Global Finance Leader for TLD change in MCO/Country Plan</description>
        <formula>IF( ISPICKVAL(IPM_Project__r.IPM_Project_Type__c, &apos;Original&apos;) &amp;&amp;ISPICKVAL(IPM_Project__r.IPM_Phase__c, &apos;Ideas&apos;) &amp;&amp; ( !ISBLANK(IPM_Project__r.IPM_Finance_Member__c ) &amp;&amp; ISCHANGED(Previous_Target_Launch_Date__c) ) ,  true ,  
IF(ISPICKVAL(Regional_Project__r.IPM_Project_Type__c, &apos;Original&apos;) &amp;&amp; ISPICKVAL(Regional_Project__r.IPM_Phase__c, &apos;Ideas&apos;) &amp;&amp; ( !ISBLANK(Regional_Project__r.IPM_Finance_Member__c )), true, false))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification to RFL for TLD change in MCO%2FCountry Plan</fullName>
        <actions>
            <name>IPM_Notify_Finance_Leader_the_TLD_changed_on_Rollout_Plan</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notification to RFL for TLD change in MCO/Country Plan</description>
        <formula>AND(ISPICKVAL(Regional_Project__r.IPM_Project_Type__c, &apos;Rollout&apos;),
Regional_Project_Span__c = &apos;Regional&apos;,
OR(ISPICKVAL(Regional_Project__r.IPM_Phase__c, &apos;Feasibility&apos;),
ISPICKVAL(Regional_Project__r.IPM_Phase__c, &apos;Capability&apos;),
ISPICKVAL(Regional_Project__r.IPM_Phase__c, &apos;Market Ready&apos;),
ISPICKVAL(Regional_Project__r.IPM_Phase__c, &apos;Market Deployment&apos;),
ISPICKVAL(Regional_Project__r.IPM_Phase__c, &apos;PLE&apos;)),
 !ISBLANK(Finance_Member__c),  ISCHANGED(Previous_Target_Launch_Date__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PM Send Email to Project Leader Once FL ackldge TLD change on Regional Project</fullName>
        <actions>
            <name>IPM_Notify_Project_Leader_for_FL_TLD_confirmation_on_Regional_Project</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Email to Project Leader Once Finance Leader acknowledge TLD change on Financial page on Regional Project</description>
        <formula>AND(ISCHANGED( MisAligned_Confirmed_By_Finance_Leader__c), MisAligned_Confirmed_By_Finance_Leader__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>To define Rollout Original Span Local</fullName>
        <actions>
            <name>Update_Span_on_Local_rollout_Regional_O</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will be used to update Rollout Span based on Record type</description>
        <formula>AND(RecordType.DeveloperName == &apos;Local_Rollouts&apos;, Regional_Project__r.IPM_CompanyCardText__c == &apos;Regional Company Card&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>To define Rollout Span</fullName>
        <actions>
            <name>Rollout_Span_Regional</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will be used to update Rollout Span based on Record type</description>
        <formula>AND(RecordType.DeveloperName == &apos;Regional_Rollout&apos;,IPM_Project__r.IPM_CompanyCardText__c = &apos;Global Company Card&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>To define Rollout Span Local</fullName>
        <actions>
            <name>Update_Rollout_Span_Local</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will be used to update Rollout Span based on Record type</description>
        <formula>AND(RecordType.DeveloperName == &apos;Local_Rollouts&apos;, Regional_Project__r.IPM_CompanyCardText__c == &apos;Global Company Card&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Finance Leader Confirm button</fullName>
        <actions>
            <name>Update_FL_Confirm_button</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Finance Leader Confirm button</description>
        <formula>AND(!ISBLANK(Local_Project_Target_Launch_Date__c), ISCHANGED( Target_Launch_Date__c ), (Target_Launch_Date__c != Local_Project_Target_Launch_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
