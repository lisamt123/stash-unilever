<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AF_AgencyEstimateCurrency</fullName>
        <field>Matrix_Currency_Code__c</field>
        <formula>if( ISBLANK(AF_Ready_For_PO_Entry_Currency__c )|| isnull(AF_Ready_For_PO_Entry_Currency__c), AF_Matrix_Data_Entry_Currency__c ,AF_Ready_For_PO_Entry_Currency__c)</formula>
        <name>AgencyEstimateCurrency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_Update_Agency_Estimate_FY</fullName>
        <field>AF_Fiscal_Year__c</field>
        <formula>AF_Brand_Estimate__r.AF_Fiscal_Year__c</formula>
        <name>Update Agency Estimate FY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_Update_isChangedDatetime</fullName>
        <field>AF_isChangedDateTime__c</field>
        <formula>now()</formula>
        <name>Update isChangedDatetime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Currency_Code_Update</fullName>
        <field>Matrix_Currency_Code__c</field>
        <formula>AF_Matrix_Data_Entry_Currency__c</formula>
        <name>Currency Code Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Matrix_Currency_Code_Ready_For_PO</fullName>
        <field>Matrix_Currency_Code__c</field>
        <formula>if( ISBLANK(AF_Ready_For_PO_Entry_Currency__c )|| isnull(AF_Ready_For_PO_Entry_Currency__c), AF_Matrix_Data_Entry_Currency__c ,AF_Ready_For_PO_Entry_Currency__c)</formula>
        <name>Matrix Currency Code - Ready For PO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Exception</fullName>
        <field>AF_EntityExceptionsTotal__c</field>
        <formula>AF_IsEntityException__c</formula>
        <name>Update Exception</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IsComment</fullName>
        <field>AF_isComment__c</field>
        <literalValue>1</literalValue>
        <name>Update IsComment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_isAddedbyUserType</fullName>
        <field>AF_isChangedbyUserType__c</field>
        <formula>text( $User.UserType )</formula>
        <name>Update isAddedbyUserType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_isChange</fullName>
        <field>AF_isChange__c</field>
        <literalValue>1</literalValue>
        <name>Update isChange</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check FY</fullName>
        <actions>
            <name>AF_Update_Agency_Estimate_FY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AF_Agency_Estimate__c.AF_Fiscal_Year__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Matrix Currency Code</fullName>
        <actions>
            <name>Currency_Code_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AF_Agency_Estimate__c.AF_Status__c</field>
            <operation>notEqual</operation>
            <value>Ready for PO</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Matrix Currency Code - Ready For PO</fullName>
        <actions>
            <name>AF_AgencyEstimateCurrency</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Matrix_Currency_Code_Ready_For_PO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AF_Agency_Estimate__c.AF_Status__c</field>
            <operation>equals</operation>
            <value>Ready for PO</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Agency Estimate</fullName>
        <actions>
            <name>AF_Update_isChangedDatetime</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_IsComment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_isAddedbyUserType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_isChange</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ischanged(AF_Traditional__c), ischanged(AF_Digital__c), ischanged(AF_Adaptation__c), ischanged(AF_PO_Number__c) ) &amp;&amp; AF_Brand_Estimate__r.AF_isFirsttime__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
