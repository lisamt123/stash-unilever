<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GEL_Email_Will_be_sent_to_Process_owner_as_soon_new_Exception_will_get_created</fullName>
        <description>GEL_Email Will be sent to Process owner as soon new Exception will get created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEL_Global_Exception_Log/GEL_Email_to_Process_Owner_after_creating_exception</template>
    </alerts>
    <alerts>
        <fullName>GEL_Sending_an_Email_Alert_to_Exception_Raiser_that_status_is_closed</fullName>
        <description>GEL_Sending an Email Alert to Exception Raiser that status is closed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEL_Global_Exception_Log/GEL_When_exception_is_Closed_Raiser_Notified</template>
    </alerts>
    <alerts>
        <fullName>GEL_Sending_an_Email_Alert_to_Exception_Raiser_to_get_further_details</fullName>
        <description>GEL_Sending an Email Alert to Exception Raiser to get further details</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEL_Global_Exception_Log/GEL_Details_requested_by_Process_Owner</template>
    </alerts>
    <alerts>
        <fullName>GEL_Sending_an_Email_Alert_to_Process_Owner_after_getting_Further_Details</fullName>
        <description>GEL_Sending an Email Alert to Process Owner after getting Further Details</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEL_Global_Exception_Log/GEL_Further_details_are_provided_by_exception_raiser</template>
    </alerts>
    <alerts>
        <fullName>GEL_Sending_an_mail_to_Exception_raiser</fullName>
        <description>GEL_Sending an mail to Exception raiser</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEL_Global_Exception_Log/GEL_AlertTemplate_To_Raiser</template>
    </alerts>
    <alerts>
        <fullName>GEL_Sending_mail_to_both_ETC_BO_and_POC</fullName>
        <description>GEL_Sending mail to both ETC BO and POC</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>PoC__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEL_Global_Exception_Log/GEL_Details_requested_by_Process_Owner</template>
    </alerts>
    <alerts>
        <fullName>GEL_Sending_mail_to_both_ETC_BO_and_POC_when_status_is_closed</fullName>
        <description>GEL_Sending mail to both ETC BO and POC when status is closed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>PoC__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEL_Global_Exception_Log/GEL_When_exception_is_Closed_Raiser_Notified</template>
    </alerts>
    <alerts>
        <fullName>GEL_Sending_mail_to_both_ETC_BO_and_POC_when_status_is_rejected</fullName>
        <description>GEL_Sending mail to both ETC BO and POC when status is rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>PoC__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEL_Global_Exception_Log/GEL_AlertTemplate_To_Raiser</template>
    </alerts>
    <fieldUpdates>
        <fullName>GEL_Update_Legacy_Date</fullName>
        <field>Legacy_Date__c</field>
        <formula>CreatedDate</formula>
        <name>GEL_Update Legacy Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEL_Update_Legacy_Owner</fullName>
        <field>Legacy_Exception_Raiser__c</field>
        <formula>CreatedBy.FirstName  +  CreatedBy.LastName</formula>
        <name>GEL_Update Legacy Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GEL_Email to Process Owner after creating exception</fullName>
        <actions>
            <name>GEL_Email_Will_be_sent_to_Process_owner_as_soon_new_Exception_will_get_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GEL_Global_Exception_Log__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GEL_Email to Process Owner after further details provided</fullName>
        <actions>
            <name>GEL_Sending_an_Email_Alert_to_Process_Owner_after_getting_Further_Details</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Description__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEL_Further Details requested by Process Owner</fullName>
        <actions>
            <name>GEL_Sending_an_Email_Alert_to_Exception_Raiser_to_get_further_details</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c , &apos;PendingClarification&apos;), IF( ETC_BO_Owner__r.Email  =  PoC__c , true, false)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEL_Further Details requested by Process Owner- POC</fullName>
        <actions>
            <name>GEL_Sending_mail_to_both_ETC_BO_and_POC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c , &apos;PendingClarification&apos;), IF( ETC_BO_Owner__r.Email   &lt;&gt;   PoC__c , true, false)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEL_IF status closed - Email to Exception Raiser</fullName>
        <actions>
            <name>GEL_Sending_an_Email_Alert_to_Exception_Raiser_that_status_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c , &apos;Closed&apos;) , IF( ETC_BO_Owner__r.Email  =  PoC__c , true, false) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEL_IF status closed - Email to Exception Raiser - POC</fullName>
        <actions>
            <name>GEL_Sending_mail_to_both_ETC_BO_and_POC_when_status_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c , &apos;Closed&apos;), IF( ETC_BO_Owner__r.Email  &lt;&gt;  PoC__c , true, false)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEL_IF status rejected - Email to Exception Raiser</fullName>
        <actions>
            <name>GEL_Sending_an_mail_to_Exception_raiser</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c , &apos;Rejected&apos;) , IF( ETC_BO_Owner__r.Email  =  PoC__c , true, false) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEL_IF status rejected - Email to Exception Raiser - POC</fullName>
        <actions>
            <name>GEL_Sending_mail_to_both_ETC_BO_and_POC_when_status_is_rejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c , &apos;Rejected&apos;) , IF( ETC_BO_Owner__r.Email  &lt;&gt;  PoC__c , true, false) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEL_To Update Legacy Date and Legacy Exception Raiser</fullName>
        <actions>
            <name>GEL_Update_Legacy_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GEL_Update_Legacy_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
