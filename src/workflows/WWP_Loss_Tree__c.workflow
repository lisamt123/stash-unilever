<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WWP_notify_Supplier_User</fullName>
        <description>WWP notify Supplier User</description>
        <protected>false</protected>
        <recipients>
            <field>Last_modified_planner_email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WinWithPlanning/WWP_Supplier_Notification_Temp</template>
    </alerts>
    <fieldUpdates>
        <fullName>WWP_LossType_DC_FU</fullName>
        <field>Loss_Type__c</field>
        <literalValue>Dispatch Compliance</literalValue>
        <name>WWP LossType DC FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_LossType_OR_FU</fullName>
        <field>Loss_Type__c</field>
        <literalValue>Output Reliability</literalValue>
        <name>WWP_LossType_OR_FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Loss_Type_DC_FU</fullName>
        <field>Loss_Type__c</field>
        <literalValue>Dispatch Compliance</literalValue>
        <name>WWP Loss Type DC FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Loss_Type_MRP_FU</fullName>
        <field>Loss_Type__c</field>
        <literalValue>MRP Compliance</literalValue>
        <name>WWP Loss Type MRP FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Loss_Type_MRP_FU1</fullName>
        <field>Loss_Type__c</field>
        <literalValue>MRP Compliance</literalValue>
        <name>WWP Loss Type MRP FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Loss_Type_OR_FU</fullName>
        <field>Loss_Type__c</field>
        <literalValue>Output Reliability</literalValue>
        <name>WWP Loss Type OR FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Loss_Update_in_SFDC_False_FU</fullName>
        <field>Loss_Updated_in_Salesforce__c</field>
        <literalValue>0</literalValue>
        <name>WWP_Loss Update in SFDC False FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Loss_Update_in_SFDC_True_FU</fullName>
        <field>Loss_Updated_in_Salesforce__c</field>
        <literalValue>1</literalValue>
        <name>WWP Loss Update in SFDC True FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Lossupdate_in_sfdc_true</fullName>
        <field>Loss_Updated_in_Salesforce__c</field>
        <literalValue>1</literalValue>
        <name>WWP_Lossupdate_in_sfdc_true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_lossupdate_true_after_12_days</fullName>
        <field>Loss_Updated_in_Salesforce__c</field>
        <literalValue>1</literalValue>
        <name>WWP lossupdate true after 12 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>primary_key_update</fullName>
        <field>SF_Primary_Key__c</field>
        <formula>SF_key__c</formula>
        <name>primary key update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_last_modified_planner_email</fullName>
        <field>Last_modified_planner_email__c</field>
        <formula>$User.Email</formula>
        <name>update last modified planner email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>wwp_otif_supplier_field_update</fullName>
        <field>OTIF_supplier_update__c</field>
        <literalValue>1</literalValue>
        <name>wwp otif supplier field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update SF Primary Key</fullName>
        <actions>
            <name>primary_key_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WWP Loss Type MRP WF</fullName>
        <actions>
            <name>WWP_Loss_Type_MRP_FU1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 3) OR ( 2 AND 4)</booleanFilter>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Receipt__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Receipt__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Receipt__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Receipt__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WWP Send notification to supplier</fullName>
        <actions>
            <name>WWP_notify_Supplier_User</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>IF((ISPICKVAL( Loss_Type__c ,&apos;Supplier OTIF&apos;))&amp;&amp;  NOT( ISPICKVAL( PRIORVALUE( Loss_Name__c ) , &apos;&apos;))&amp;&amp;NOT( ISPICKVAL( PRIORVALUE(  Loss_Sub_Family__c ) , &apos;&apos;))&amp;&amp;NOT( ISPICKVAL( PRIORVALUE(  Loss_Description__c ) , &apos;&apos;)   ) ,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WWP Validation for Supplier OTIF records</fullName>
        <actions>
            <name>wwp_otif_supplier_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Sub_Family__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Description__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Type__c</field>
            <operation>equals</operation>
            <value>Supplier OTIF</value>
        </criteriaItems>
        <description>Validation for Supplier OTIF records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WWP Validation for Supplier OTIF records before two weeks</fullName>
        <actions>
            <name>WWP_Loss_Update_in_SFDC_False_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Validation for Supplier OTIF records before two weeks</description>
        <formula>ISPICKVAL(Loss_Type__c,&apos;Supplier OTIF&apos; )&amp;&amp;( CreatedDate+6 &gt; NOW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WWP update Loss updated in sfdc for OTIF</fullName>
        <active>false</active>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Level1_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Leve2_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Level3_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WWP_Loss_Update_in_SFDC_True_FU</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>WWP_Loss_Tree__c.CreatedDate</offsetFromField>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WWP_Loss Update in SCDG True WF</fullName>
        <actions>
            <name>WWP_Loss_Update_in_SFDC_True_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Sub_Family__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Description__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Type__c</field>
            <operation>notEqual</operation>
            <value>Supplier OTIF</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WWP_Loss Update in SFDC False WF</fullName>
        <actions>
            <name>WWP_Loss_Update_in_SFDC_False_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Sub_Family__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Description__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WWP_LossType_DC_WF</fullName>
        <actions>
            <name>WWP_LossType_DC_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 AND 5)  OR (2 AND 6)) AND ((3 OR 7) AND (4 OR 8))</booleanFilter>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Dispatch__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Dispatch__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Production__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Production__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Dispatch__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Dispatch__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Production__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Production__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WWP_LossType_OR_WF</fullName>
        <actions>
            <name>WWP_LossType_OR_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 AND 5)  OR (2 AND 6)) AND ((3 OR 7) AND (4 OR 8))</booleanFilter>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Production__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Production__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Dispatch__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Dispatch__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Production__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Production__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Dispatch__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Dispatch__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WWP_populate Lasmodified planner email</fullName>
        <actions>
            <name>update_last_modified_planner_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Sub_Family__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Description__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Last_modified_planner_email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>lossupdate for OTIF true</fullName>
        <actions>
            <name>WWP_Lossupdate_in_sfdc_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( Loss_Type__c , &apos;Supplier OTIF&apos;)&amp;&amp; ( CreatedDate+6 &lt; NOW() ) &amp;&amp;  NOT(ISBLANK( TEXT( Loss_Name__c ) ))&amp;&amp;  NOT(ISBLANK( TEXT(  Loss_Sub_Family__c ) ))&amp;&amp; NOT(ISBLANK( TEXT(  Loss_Description__c ) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
