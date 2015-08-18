<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AutoResponse_Email_on_Case_Creation</fullName>
        <description>Auto Response Email on Case Creation for India for Case Origin Email</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_AutoResponse_Unilever_IN</template>
    </alerts>
    <alerts>
        <fullName>Auto_Response_Email_on_Case_Creation</fullName>
        <description>Auto Response Email on Case Creation</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_AutoConsumerResponse</template>
    </alerts>
    <alerts>
        <fullName>Auto_Response_Email_on_Case_Creation_for_India_for_Web</fullName>
        <description>Auto Response Email on Case Creation for India for Case Origin Web</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_AutoResponse_Unilever_IN</template>
    </alerts>
    <alerts>
        <fullName>Auto_Response_Email_on_Case_Creation_for_UK_Ireland</fullName>
        <description>Auto Response Email on Case Creation for UK &amp; Ireland for Case Origin Email</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_AutoResponse_Unilever_UK</template>
    </alerts>
    <alerts>
        <fullName>Auto_Response_Email_on_Case_Creation_for_UK_Ireland_for_Web</fullName>
        <description>Auto Response Email on Case Creation for UK &amp; Ireland for Case Origin Web</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_AutoResponse_Unilever_UK</template>
    </alerts>
    <alerts>
        <fullName>CEC_Send_Auto_Response</fullName>
        <description>CEC Send Auto Response</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/cec_Default_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>US027_subjectMerged</fullName>
        <ccEmails>kalpesh.thakur@capgemini.com</ccEmails>
        <description>US027_subjectMerged</description>
        <protected>false</protected>
        <recipients>
            <recipient>kalpesh.thakur@capgemini.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_SubjectMerged</template>
    </alerts>
    <alerts>
        <fullName>close_Case_Survey</fullName>
        <description>close Case Survey</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Close_Case_Survey</template>
    </alerts>
    <alerts>
        <fullName>test</fullName>
        <description>test</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_AutoResponse_Unilever_IN</template>
    </alerts>
    <fieldUpdates>
        <fullName>CEC_Benelux_Market_Field_Update</fullName>
        <description>CEC: Set the Market field to the market value</description>
        <field>Market__c</field>
        <literalValue>Benelux</literalValue>
        <name>CEC Benelux Market Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Case_Origin_to_email</fullName>
        <description>CEC: sets the Case Origin to Email</description>
        <field>Origin</field>
        <literalValue>Email</literalValue>
        <name>CEC Case Origin to email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Copy_Case_Description</fullName>
        <description>CEC : To keep the original comments from customer when a case is created</description>
        <field>Original_Description__c</field>
        <formula>Description</formula>
        <name>CEC Copy Case Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_India_CaseOrigin_Field_Update</fullName>
        <description>Update the CaseOrigin Field to Email</description>
        <field>Origin</field>
        <literalValue>Email</literalValue>
        <name>CEC India CaseOrigin Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_India_Market_Field_Update</fullName>
        <field>Market__c</field>
        <literalValue>India</literalValue>
        <name>CEC India Market Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Nordic_CaseOrigin_Field_Update</fullName>
        <description>Update CaseOrigin to Email</description>
        <field>Origin</field>
        <literalValue>Email</literalValue>
        <name>CEC Nordic CaseOrigin Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Nordic_Market_Field_Update</fullName>
        <field>Market__c</field>
        <literalValue>Nordic</literalValue>
        <name>CEC Nordic Market Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_UK_CaseOrigin_Field_Update</fullName>
        <description>Update CaseOrigin  to Email</description>
        <field>Origin</field>
        <literalValue>Email</literalValue>
        <name>CEC UK CaseOrigin Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_UK_Market_Field_Update</fullName>
        <field>Market__c</field>
        <literalValue>United Kingdom</literalValue>
        <name>CEC UK Market Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Update_Market_on_Case</fullName>
        <description>CEC Update Market on Case</description>
        <field>Market__c</field>
        <literalValue>UK &amp; Ireland</literalValue>
        <name>CEC Update Market on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>India_Market_Update</fullName>
        <field>Market__c</field>
        <literalValue>India</literalValue>
        <name>India_Market_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Market_Update_India</fullName>
        <field>Market__c</field>
        <literalValue>India</literalValue>
        <name>Market Update India</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Market_Update_UK</fullName>
        <field>Market__c</field>
        <literalValue>UK &amp; Ireland</literalValue>
        <name>Market Update_UK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Market_update</fullName>
        <field>Market__c</field>
        <literalValue>India</literalValue>
        <name>Market_update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Assignment_Fields_False</fullName>
        <field>Set_Assignment_Fields__c</field>
        <literalValue>0</literalValue>
        <name>Set Assignment Fields False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TO_Assign_France_Escalation_Queue</fullName>
        <description>Assigns Case to France Escalation Queue</description>
        <field>OwnerId</field>
        <lookupValue>TO_France_Escalation_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>TO Assign France Escalation Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TO_IsEscalated_Update</fullName>
        <description>TO : IsEscalated set to TRUE, if Status is set to Escalated.</description>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>TO - IsEscalated Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Case_Overtime_Level_Green</fullName>
        <field>WorkIt2__Color__c</field>
        <literalValue>Green</literalValue>
        <name>WorkIt! Case Overtime Level: Green</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Case_Overtime_Level_Red</fullName>
        <field>WorkIt2__Color__c</field>
        <literalValue>Red</literalValue>
        <name>WorkIt! Case Overtime Level: Red</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Case_Overtime_Level_Yellow</fullName>
        <field>WorkIt2__Color__c</field>
        <literalValue>Yellow</literalValue>
        <name>WorkIt! Case Overtime Level: Yellow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Case_Allow_Update_to_On</fullName>
        <field>WorkIt2__Allow_Update__c</field>
        <literalValue>1</literalValue>
        <name>WorkIt! Set Case &quot;Allow Update&quot; to On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Closed_with_Package_to_On</fullName>
        <field>WorkIt2__Closed_with_Package__c</field>
        <literalValue>1</literalValue>
        <name>WorkIt! Set &quot;Closed with Package&quot; to On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Don_t_Time_to_Off</fullName>
        <field>WorkIt2__Dont_Time__c</field>
        <literalValue>0</literalValue>
        <name>WorkIt! Set &quot;Don&apos;t Time&quot; to Off</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Don_t_Time_to_On</fullName>
        <field>WorkIt2__Dont_Time__c</field>
        <literalValue>1</literalValue>
        <name>WorkIt! Set &quot;Don&apos;t Time&quot; to On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CEC %3A CaseOrigin Update</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>contains</operation>
            <value>Email UK,Email India,Email Nordic,Email France,Email Benelux,Email DACH,Email Cyprus,Email Czech Republic,Email Greece,Email Hungary,Email Italy,Email Poland,Email Portugal,Email Spain,Email Baltics,Email TO France,Email Sri Lanka</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Country_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>CEC : To update the Case Origin field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Benelux Market Field Update</fullName>
        <actions>
            <name>CEC_Benelux_Market_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Benelux</value>
        </criteriaItems>
        <description>Market Field Update based on Case Origin Field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Case Origin Update - Baltics</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Baltics</value>
        </criteriaItems>
        <description>Case Origin Update to Email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Case Origin Update - Cyprus</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Cyprus</value>
        </criteriaItems>
        <description>Case Origin Update to Email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Case Origin Update - Czech Republic</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Czech Republic</value>
        </criteriaItems>
        <description>Case Origin Update to Email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Case Origin Update - DACH</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email DACH</value>
        </criteriaItems>
        <description>Case Origin Update to Email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Case Origin Update - Hungary</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Hungary</value>
        </criteriaItems>
        <description>Case Origin Update to Email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Case Origin Update - Italy</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Italy</value>
        </criteriaItems>
        <description>Case Origin Update to Email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Case Origin Update - Poland</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Poland</value>
        </criteriaItems>
        <description>Case Origin update to Email</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Case Origin Update - Portugal</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Portugal</value>
        </criteriaItems>
        <description>Case Origin Update to Email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Case Origin Update - Spain</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Spain</value>
        </criteriaItems>
        <description>Case Origin Update to Email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Case Origin Update - Sri Lanka</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Sri Lanka</value>
        </criteriaItems>
        <description>Case Origin Update to Email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Copy Case Description</fullName>
        <actions>
            <name>CEC_Copy_Case_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>To copy the Description of the cases created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CEC France Market Field Update</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email France</value>
        </criteriaItems>
        <description>Market Field Update based on Case Origin Field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC India Market Field Update</fullName>
        <actions>
            <name>CEC_India_CaseOrigin_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEC_India_Market_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email India</value>
        </criteriaItems>
        <description>Market field update based on Case Origin Field
ex: Case Origin : Email India then Update Market : India</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC Nordic Market Field Update</fullName>
        <actions>
            <name>CEC_Nordic_CaseOrigin_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEC_Nordic_Market_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Nordic</value>
        </criteriaItems>
        <description>Market Field Update based on Case Origin Field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC UK Market Field Update</fullName>
        <actions>
            <name>CEC_UK_CaseOrigin_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEC_UK_Market_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email UK</value>
        </criteriaItems>
        <description>Market Field Update based on Case Origin Field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC_Email_AutoResponse</fullName>
        <actions>
            <name>CEC_Send_Auto_Response</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Assignment_Fields_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Set_Assignment_Fields__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>CEC: Send auto response email to consumer</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC_India_AutoResponse</fullName>
        <actions>
            <name>test</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>India_Market_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.BillingCountry</field>
            <operation>equals</operation>
            <value>India</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CEC_India_Email_AutoResponse</fullName>
        <actions>
            <name>AutoResponse_Email_on_Case_Creation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Market__c</field>
            <operation>equals</operation>
            <value>India</value>
        </criteriaItems>
        <description>Auto Response Email on Case Creation for India for Case Origin Email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CEC_India_Email_AutoResponse2</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.BillingCountry</field>
            <operation>equals</operation>
            <value>India</value>
        </criteriaItems>
        <description>Auto Response Email on Case Creation for India for Case Origin Email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CEC_India_Web_AutoResponse</fullName>
        <actions>
            <name>Auto_Response_Email_on_Case_Creation_for_India_for_Web</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Market__c</field>
            <operation>equals</operation>
            <value>India</value>
        </criteriaItems>
        <description>Auto Response Email on Case Creation for India for Case Origin Web</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CEC_UK_and_Ireland_Email_AutoResponse</fullName>
        <actions>
            <name>Auto_Response_Email_on_Case_Creation_for_UK_Ireland</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Market__c</field>
            <operation>equals</operation>
            <value>UK &amp; Ireland</value>
        </criteriaItems>
        <description>Auto Response Email on Case Creation for UK &amp; Ireland for Case Origin Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CEC_UK_and_Ireland_Web_AutoResponse</fullName>
        <actions>
            <name>Auto_Response_Email_on_Case_Creation_for_UK_Ireland_for_Web</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Market__c</field>
            <operation>equals</operation>
            <value>UK &amp; Ireland</value>
        </criteriaItems>
        <description>Auto Response Email on Case Creation for UK &amp; Ireland for Case Origin Web</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Origin Update - Greece</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email Greece</value>
        </criteriaItems>
        <description>Case Origin Update to Email</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Close Case Survey</fullName>
        <actions>
            <name>close_Case_Survey</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>notEqual</operation>
            <value>Duplicate</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TO - IsEscalated Update</fullName>
        <actions>
            <name>TO_IsEscalated_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <description>TO : IsEscalated set to TRUE, If the status is set to Escalated.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TO France Escalation Rule</fullName>
        <actions>
            <name>TO_Assign_France_Escalation_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsEscalated</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Market_Tag__c</field>
            <operation>equals</operation>
            <value>George</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Market_Mapping_Country__c</field>
            <operation>equals</operation>
            <value>France</value>
        </criteriaItems>
        <description>Rule to assign case to france escalation  queue</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TO France Market Field Update</fullName>
        <actions>
            <name>CEC_Case_Origin_to_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email TO France</value>
        </criteriaItems>
        <description>TO: Market Field Update based on Case Origin Field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WorkIt2__WorkIt%21 Case Close</fullName>
        <actions>
            <name>WorkIt2__WorkIt_Set_Closed_with_Package_to_On</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WorkIt2__WorkIt_Set_Don_t_Time_to_On</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Makes WorkIt! stop timing a case when it&apos;s closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WorkIt2__WorkIt%21 Case Open</fullName>
        <actions>
            <name>WorkIt2__WorkIt_Set_Don_t_Time_to_Off</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Makes WorkIt! start timing a case when it&apos;s opened.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
