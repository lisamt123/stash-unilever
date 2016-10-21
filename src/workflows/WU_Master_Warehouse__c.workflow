<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_for_Committed_PalletStorage</fullName>
        <description>Approval for Committed PalletStorage</description>
        <protected>false</protected>
        <recipients>
            <field>WU_WarehouseManager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warehouse_Utilization/Warehouse_Committed_Capacity</template>
    </alerts>
    <alerts>
        <fullName>Approve_Committed_PalletStorage</fullName>
        <description>Approve Committed Warehouse Utilization</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warehouse_Utilization/Warehouse_Committed_Capacity</template>
    </alerts>
    <alerts>
        <fullName>WU_ApprovalNotification</fullName>
        <description>WU ApprovalNotification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warehouse_Utilization/WU_Warehouse_Committed_StoragetoPOC</template>
    </alerts>
    <alerts>
        <fullName>WU_ApprovalRequest</fullName>
        <description>WU ApprovalRequest</description>
        <protected>false</protected>
        <recipients>
            <field>WU_WarehouseManager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warehouse_Utilization/Warehouse_Committed_Capacity</template>
    </alerts>
    <alerts>
        <fullName>WU_Notify_WarehousePOC</fullName>
        <description>Notify WarehousePOC</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warehouse_Utilization/WU_Warehouse_Committed_StoragetoPOC</template>
    </alerts>
    <alerts>
        <fullName>Warehouse_capacity_below_committed_capacity</fullName>
        <description>Warehouse capacity below committed capacity!</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warehouse_Utilization/Capacity_Verification_Required</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved</fullName>
        <field>WU_Approval_Status__c</field>
        <formula>&apos;Approved&apos;</formula>
        <name>Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reject_Committed_PalletStorage</fullName>
        <description>after rejection revert committed pallet storage</description>
        <field>WU_Committed_Max_PalletStorage__c</field>
        <formula>WU_Prior_CommittedPalletStorage__c</formula>
        <name>Reject Committed PalletStorage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected</fullName>
        <field>WU_Approval_Status__c</field>
        <formula>&apos;Rejected&apos;</formula>
        <name>Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revert_Prior_value</fullName>
        <field>WU_Prior_CommittedPalletStorage__c</field>
        <formula>WU_Prior_CommittedPalletStorage__c</formula>
        <name>Revert Prior value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetPriorValueForCommittedPallet</fullName>
        <field>WU_Committed_Max_PalletStorage__c</field>
        <formula>WU_Prior_CommittedPalletStorage__c</formula>
        <name>SetPriorValueForCommittedPallet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted</fullName>
        <field>WU_Approval_Status__c</field>
        <formula>&apos;Submitted&apos;</formula>
        <name>Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WU_Update_Warehouse_Capacity_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Edit_Warehouse_Capacity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WU Update Warehouse Capacity Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WU AutoSubmitApproval</fullName>
        <active>false</active>
        <description>Whenever Max Committed Pallet Storage value will change Auto submit approval notification</description>
        <formula>WU_Committed_Max_PalletStorage__c  &lt;&gt;  WU_Prior_CommittedPalletStorage__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WU Change Warehouse Capacity Record Type</fullName>
        <actions>
            <name>WU_Update_Warehouse_Capacity_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change Record type of Record when record is created.</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WU MaxCommitted PalleStorage</fullName>
        <active>false</active>
        <description>Whenever Max Committed Pallet Storage value will change make flag true</description>
        <formula>IF( PRIORVALUE( WU_Committed_Max_PalletStorage__c )  &lt;&gt; WU_Committed_Max_PalletStorage__c, true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WU_Warehouse Capacity Limit Exceed Notification</fullName>
        <actions>
            <name>Warehouse_capacity_below_committed_capacity</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>whenever Warehouse capacity will exceed 80%: system shall send notification to Warehouse Excellence Operations user.</description>
        <formula>AND(WU_Committed_Max_PalletStorage__c &gt;0,  ISPICKVAL(WU_Building_ContractType__c,&apos;Unilever&apos;),    (WU_Current_Utilization__c  /  WU_Committed_Max_PalletStorage__c)*100 &gt;= 80)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
