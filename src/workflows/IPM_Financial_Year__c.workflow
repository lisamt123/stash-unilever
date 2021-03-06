<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AP_Charter_Copy_Over</fullName>
        <field>AP_of_TO_Charter__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), AP_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),AP_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),AP_of_TO_Local__c,0)))</formula>
        <name>A&amp;P Charter Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AP_Contract_Copy_Over</fullName>
        <field>AP_of_TO_Contract__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), AP_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),AP_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),AP_of_TO_Local__c,0)))</formula>
        <name>A&amp;P Contract Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AP_MD_Copy_Over</fullName>
        <field>AP_of_TO_MD__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), AP_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),AP_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),AP_of_TO_Local__c,0)))</formula>
        <name>A&amp;P MD Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AP_MR_Copy_Over</fullName>
        <field>AP_of_TO_MR__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), AP_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),AP_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),AP_of_TO_Local__c,0)))</formula>
        <name>A&amp;P MR Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_ValueMarketShare_GlobalToRegional</fullName>
        <field>Value_Market_Share_Regional__c</field>
        <formula>Value_Market_Share_Global__c</formula>
        <name>Copy ValueMarketShare GlobalToRegional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_ValueMarketShare_Global_To_Local</fullName>
        <field>Value_Market_Share_Local__c</field>
        <formula>Value_Market_Share_Global__c</formula>
        <name>Copy ValueMarketShare Global To Local</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_ValueMarketShare_Local_To_Global</fullName>
        <field>Value_Market_Share_Global__c</field>
        <formula>Value_Market_Share_Local__c</formula>
        <name>Copy ValueMarketShare Local To Global</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_ValueMarketShare_Local_To_Regional</fullName>
        <field>Value_Market_Share_Regional__c</field>
        <formula>Value_Market_Share_Local__c</formula>
        <name>Copy ValueMarketShare Local To Regional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_ValueMarketShare_Regional_To_Local</fullName>
        <field>Value_Market_Share_Local__c</field>
        <formula>Value_Market_Share_Regional__c</formula>
        <name>Copy ValueMarketShare Regional To Local</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Copy_AP</fullName>
        <field>AP_of_TO_Charter__c</field>
        <formula>AP_of_TO_Global__c</formula>
        <name>FY Charter Copy A&amp;P %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Copy_Advertising_Promotions</fullName>
        <field>Advertising_Promotions_Charter__c</field>
        <formula>Advertising_Promotions_Global__c</formula>
        <name>FY Charter Copy Advertising &amp; Promotions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Copy_GM</fullName>
        <field>GM_of_TO_Charter__c</field>
        <formula>GM_of_TO_Global__c</formula>
        <name>FY Charter Copy GM %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Copy_Gross_Profit</fullName>
        <field>Gross_Profit_Charter__c</field>
        <formula>Gross_Profit_Global__c</formula>
        <name>FY Charter Copy Gross Profit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Copy_PBO</fullName>
        <field>PBO_of_TO_Charter__c</field>
        <formula>PBO_of_TO_Global__c</formula>
        <name>FY Charter Copy PBO %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Copy_Profit_Before_Overheads</fullName>
        <field>Profit_Before_Overheads_Charter__c</field>
        <formula>Profit_Before_Overheads_Global__c</formula>
        <name>FY Charter Copy Profit Before Overheads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Copy_Turnover</fullName>
        <field>Turnover_Charter__c</field>
        <formula>Turnover_Global__c</formula>
        <name>FY Charter Copy Turnover</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Copy_Value_Market_Share</fullName>
        <field>Value_Market_Share_Charter__c</field>
        <formula>Value_Market_Share_Global__c</formula>
        <name>FY Charter Copy Value Market Share</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Copy_Volume</fullName>
        <field>Volume_Charter__c</field>
        <formula>Volume_Global__c</formula>
        <name>FY Charter Copy Volume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Copy_Volume_Tons</fullName>
        <field>Volume_Tons_Charter__c</field>
        <formula>Volume_Global__c</formula>
        <name>FY Charter Copy Volume Tons</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Charter_Locked</fullName>
        <field>Charter_Locked__c</field>
        <literalValue>1</literalValue>
        <name>FY Charter Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Copy_AP</fullName>
        <field>AP_of_TO_Contract__c</field>
        <formula>AP_of_TO_Regional__c</formula>
        <name>FY Contract Copy A&amp;P %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Copy_Advertising_Promotions</fullName>
        <field>Advertising_Promotions_Contract__c</field>
        <formula>Advertising_Promotions_Regional__c</formula>
        <name>FY Contract Copy Advertising Promotions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Copy_GM</fullName>
        <field>GM_of_TO_Contract__c</field>
        <formula>GM_of_TO_Regional__c</formula>
        <name>FY Contract Copy GM %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Copy_Gross_Profit</fullName>
        <field>Gross_Profit_Contract__c</field>
        <formula>Gross_Profit_Regional__c</formula>
        <name>FY Contract Copy Gross Profit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Copy_PBO</fullName>
        <field>PBO_of_TO_Contract__c</field>
        <formula>PBO_of_TO_Regional__c</formula>
        <name>FY Contract Copy PBO %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Copy_Profit_Before_Overheads</fullName>
        <field>Profit_Before_Overheads_Contract__c</field>
        <formula>Profit_Before_Overheads_Regional__c</formula>
        <name>FY Contract Copy Profit Before Overheads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Copy_Turnover</fullName>
        <field>Turnover_Contract__c</field>
        <formula>Turnover_Regional__c</formula>
        <name>FY Contract Copy Turnover</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Copy_Value_Market_Share</fullName>
        <field>Value_Market_Share_Contract__c</field>
        <formula>Value_Market_Share_Regional__c</formula>
        <name>FY Contract Copy Value Market Share</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Copy_Volume</fullName>
        <field>Volume_Contract__c</field>
        <formula>Volume_Regional__c</formula>
        <name>FY Contract Copy Volume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Copy_Volume_Tons</fullName>
        <field>Volume_Tons_Contract__c</field>
        <formula>Volume_Regional__c</formula>
        <name>FY Contract Copy Volume Tons</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Contract_Locked</fullName>
        <field>Contract_Locked__c</field>
        <literalValue>1</literalValue>
        <name>FY Contract Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2L_Advertising_Promotions</fullName>
        <field>Advertising_Promotions_Local__c</field>
        <formula>Advertising_Promotions_Global__c</formula>
        <name>FY Copy G2L Advertising &amp; Promotions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2L_Gross_Profit</fullName>
        <field>Gross_Profit_Local__c</field>
        <formula>Gross_Profit_Global__c</formula>
        <name>FY Copy G2L Gross Profit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2L_Profit_Before_Overheads</fullName>
        <field>Profit_Before_Overheads_Local__c</field>
        <formula>Profit_Before_Overheads_Global__c</formula>
        <name>FY Copy G2L Profit Before Overheads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2L_Turnover</fullName>
        <field>Turnover_Local__c</field>
        <formula>Turnover_Global__c</formula>
        <name>FY Copy G2L Turnover</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2L_Value_Market_Share</fullName>
        <field>Value_Market_Share_Local__c</field>
        <formula>Value_Market_Share_Global__c</formula>
        <name>FY Copy G2L Value Market Share</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2L_Volume</fullName>
        <field>Volume_Local__c</field>
        <formula>Volume_Global__c</formula>
        <name>FY Copy G2L Volume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2R_Advertising_Promotions</fullName>
        <field>Advertising_Promotions_Regional__c</field>
        <formula>Advertising_Promotions_Global__c</formula>
        <name>FY Copy G2R Advertising &amp; Promotions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2R_Gross_Profit</fullName>
        <field>Gross_Profit_Regional__c</field>
        <formula>Gross_Profit_Global__c</formula>
        <name>FY Copy G2R Gross Profit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2R_Profit_Before_Overheads</fullName>
        <field>Profit_Before_Overheads_Regional__c</field>
        <formula>Profit_Before_Overheads_Global__c</formula>
        <name>FY Copy G2R Profit Before Overheads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2R_Turnover</fullName>
        <field>Turnover_Regional__c</field>
        <formula>Turnover_Global__c</formula>
        <name>FY Copy G2R Turnover</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2R_Value_Market_Share</fullName>
        <field>Value_Market_Share_Regional__c</field>
        <formula>Value_Market_Share_Global__c</formula>
        <name>FY Copy G2R Value Market Share</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_G2R_Volume</fullName>
        <field>Volume_Regional__c</field>
        <formula>Volume_Global__c</formula>
        <name>FY Copy G2R Volume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_L2R_Advertising_Promotions</fullName>
        <field>Advertising_Promotions_Regional__c</field>
        <formula>Advertising_Promotions_Local__c</formula>
        <name>FY Copy L2R Advertising &amp; Promotions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_L2R_Gross_Profit</fullName>
        <field>Gross_Profit_Regional__c</field>
        <formula>Gross_Profit_Local__c</formula>
        <name>FY Copy L2R Gross Profit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_L2R_Profit_Before_Overheads</fullName>
        <field>Profit_Before_Overheads_Regional__c</field>
        <formula>Profit_Before_Overheads_Local__c</formula>
        <name>FY Copy L2R Profit Before Overheads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_L2R_Turnover</fullName>
        <field>Turnover_Regional__c</field>
        <formula>Turnover_Local__c</formula>
        <name>FY Copy L2R Turnover</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_L2R_Value_Market_Share</fullName>
        <field>Value_Market_Share_Regional__c</field>
        <formula>Value_Market_Share_Local__c</formula>
        <name>FY Copy L2R Value Market Share</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_L2R_Volume</fullName>
        <field>Volume_Regional__c</field>
        <formula>Volume_Local__c</formula>
        <name>FY Copy L2R Volume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_R2L_Advertising_Promotions</fullName>
        <field>Advertising_Promotions_Local__c</field>
        <formula>Advertising_Promotions_Regional__c</formula>
        <name>FY Copy R2L Advertising &amp; Promotions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_R2L_Gross_Profit</fullName>
        <field>Gross_Profit_Local__c</field>
        <formula>Gross_Profit_Regional__c</formula>
        <name>FY Copy R2L Gross Profit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_R2L_Profit_Before_Overheads</fullName>
        <field>Profit_Before_Overheads_Local__c</field>
        <formula>Profit_Before_Overheads_Regional__c</formula>
        <name>FY Copy R2L Profit Before Overheads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_R2L_Turnover</fullName>
        <field>Turnover_Local__c</field>
        <formula>Turnover_Regional__c</formula>
        <name>FY Copy R2L Turnover</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_R2L_Value_Market_Share</fullName>
        <field>Value_Market_Share_Local__c</field>
        <formula>Value_Market_Share_Regional__c</formula>
        <name>FY Copy R2L Value Market Share</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_R2L_Volume</fullName>
        <field>Volume_Local__c</field>
        <formula>Volume_Regional__c</formula>
        <name>FY Copy R2L Volume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Copy_AP</fullName>
        <field>AP_of_TO_MD__c</field>
        <formula>AP_of_TO_Local__c</formula>
        <name>FY MD Copy A&amp;P %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Copy_Advertising_Promotions</fullName>
        <field>Advertising_Promotions_MD__c</field>
        <formula>Advertising_Promotions_Local__c</formula>
        <name>FY MD Copy Advertising Promotions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Copy_GM</fullName>
        <field>GM_of_TO_MD__c</field>
        <formula>GM_of_TO_Local__c</formula>
        <name>FY MD Copy GM %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Copy_Gross_Profit</fullName>
        <field>Gross_Profit_MD__c</field>
        <formula>Gross_Profit_Local__c</formula>
        <name>FY MD Copy Gross Profit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Copy_PBO</fullName>
        <field>PBO_of_TO_MD__c</field>
        <formula>PBO_of_TO_Local__c</formula>
        <name>FY MD Copy PBO %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Copy_Profit_Before_Overheads</fullName>
        <field>Profit_Before_Overheads_MD__c</field>
        <formula>Profit_Before_Overheads_Local__c</formula>
        <name>FY MD Copy Profit Before Overheads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Copy_Turnover</fullName>
        <field>Turnover_MD__c</field>
        <formula>Turnover_Local__c</formula>
        <name>FY MD Copy Turnover</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Copy_Value_Market_Share</fullName>
        <field>Value_Market_Share_MD__c</field>
        <formula>Value_Market_Share_Local__c</formula>
        <name>FY MD Copy Value Market Share</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Copy_Volume</fullName>
        <field>Volume_MD__c</field>
        <formula>Volume_Local__c</formula>
        <name>FY MD Copy Volume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Copy_Volume_Tons</fullName>
        <field>Volume_Tons_MD__c</field>
        <formula>Volume_Tons_Local__c</formula>
        <name>FY MD Copy Volume Tons</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MD_Locked</fullName>
        <field>MD_Locked__c</field>
        <literalValue>1</literalValue>
        <name>FY MD Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Copy_AP</fullName>
        <field>AP_of_TO_MR__c</field>
        <formula>AP_of_TO_Regional__c</formula>
        <name>FY MR Copy A&amp;P %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Copy_Advertising_Promotions</fullName>
        <field>Advertising_Promotions_MR__c</field>
        <formula>Advertising_Promotions_Regional__c</formula>
        <name>FY MR Copy Advertising Promotions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Copy_GM</fullName>
        <field>GM_of_TO_MR__c</field>
        <formula>GM_of_TO_Regional__c</formula>
        <name>FY MR Copy GM %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Copy_Gross_Profit</fullName>
        <field>Gross_Profit_MR__c</field>
        <formula>Gross_Profit_Regional__c</formula>
        <name>FY MR Copy Gross Profit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Copy_PBO</fullName>
        <field>PBO_of_TO_MR__c</field>
        <formula>PBO_of_TO_Regional__c</formula>
        <name>FY MR Copy PBO %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Copy_Profit_Before_Overheads</fullName>
        <field>Profit_Before_Overheads_MR__c</field>
        <formula>Profit_Before_Overheads_Regional__c</formula>
        <name>FY MR Copy Profit Before Overheads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Copy_Turnover</fullName>
        <field>Turnover_MR__c</field>
        <formula>Turnover_Regional__c</formula>
        <name>FY MR Copy Turnover</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Copy_Value_Market_Share</fullName>
        <field>Value_Market_Share_MR__c</field>
        <formula>Value_Market_Share_Regional__c</formula>
        <name>FY MR Copy Value Market Share</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Copy_Volume</fullName>
        <field>Volume_MR__c</field>
        <formula>Volume_Regional__c</formula>
        <name>FY MR Copy Volume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Copy_Volume_Tons</fullName>
        <field>Volume_Tons_MR__c</field>
        <formula>Volume_Tons_Regional__c</formula>
        <name>FY MR Copy Volume Tons</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_MR_Locked</fullName>
        <field>MR_Locked__c</field>
        <literalValue>1</literalValue>
        <name>FY MR Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Set_Copy_G2L_FALSE</fullName>
        <field>Copy_Global_to_Local__c</field>
        <literalValue>0</literalValue>
        <name>FY Set Copy G2L FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Set_Copy_G2R_FALSE</fullName>
        <field>Copy_Global_to_Regional__c</field>
        <literalValue>0</literalValue>
        <name>FY Set Copy G2R FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Set_Copy_L2R_FALSE</fullName>
        <field>Copy_Local_to_Regional__c</field>
        <literalValue>0</literalValue>
        <name>FY Set Copy L2R FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Set_Copy_R2L_FALSE</fullName>
        <field>Copy_Regional_to_Local__c</field>
        <literalValue>0</literalValue>
        <name>FY Set Copy R2L FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GM_CharterCopy_Over</fullName>
        <field>GM_of_TO_Charter__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), GM_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),GM_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),GM_of_TO_Local__c,0)))</formula>
        <name>GM CharterCopy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GM_Contract_Copy_Over</fullName>
        <field>GM_of_TO_Contract__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), GM_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),GM_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),GM_of_TO_Local__c,0)))</formula>
        <name>GM Contract Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GM_MD_Copy_Over</fullName>
        <field>GM_of_TO_MD__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), GM_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),GM_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),GM_of_TO_Local__c,0)))</formula>
        <name>GM MD Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GM_MR_Copy_Over</fullName>
        <field>GM_of_TO_MR__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), GM_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),GM_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),GM_of_TO_Local__c,0)))</formula>
        <name>GM MR Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PBO_Charter_Copy_Over</fullName>
        <field>PBO_of_TO_Charter__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), PBO_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),PBO_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),PBO_of_TO_Local__c,0)))</formula>
        <name>PBO Charter Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PBO_Contract_Copy_Over</fullName>
        <field>PBO_of_TO_Contract__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), PBO_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),PBO_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),PBO_of_TO_Local__c,0)))</formula>
        <name>PBO Contract Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PBO_MD_Copy_Over</fullName>
        <field>PBO_of_TO_MD__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), PBO_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),PBO_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),PBO_of_TO_Local__c,0)))</formula>
        <name>PBO MD Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PBO_MR_Copy_Over</fullName>
        <field>PBO_of_TO_MR__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), PBO_of_TO_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),PBO_of_TO_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),PBO_of_TO_Local__c,0)))</formula>
        <name>PBO MR Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Value_Market_Share_Charter_Copy_Over</fullName>
        <field>Value_Market_Share_Charter__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), Value_Market_Share_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),Value_Market_Share_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),Value_Market_Share_Local__c,0)))</formula>
        <name>Value Market Share Charter Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Value_Market_Share_Contract_Copy_Over</fullName>
        <field>Value_Market_Share_Contract__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), Value_Market_Share_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),Value_Market_Share_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),Value_Market_Share_Local__c,0)))</formula>
        <name>Value Market Share Contract Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Value_Market_Share_MD_Copy_Over</fullName>
        <field>Value_Market_Share_MR__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), Value_Market_Share_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),Value_Market_Share_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),Value_Market_Share_Local__c,0)))</formula>
        <name>Value Market Share MD Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Value_Market_Share_MR_Copy_Over</fullName>
        <field>Value_Market_Share_MR__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), Value_Market_Share_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),Value_Market_Share_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),Value_Market_Share_Local__c,0)))</formula>
        <name>Value Market Share MR Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Volume_Tons_Regional</fullName>
        <field>Volume_Tons_Regional__c</field>
        <formula>Volume_Tons_Global__c</formula>
        <name>Volume Tons Regional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy ValueMarketShare Global To Local</fullName>
        <actions>
            <name>Copy_ValueMarketShare_Global_To_Local</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Global_to_Local__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy ValueMarketShare Global To Regional</fullName>
        <actions>
            <name>Copy_ValueMarketShare_GlobalToRegional</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Global_to_Regional__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy ValueMarketShare Local To Global</fullName>
        <actions>
            <name>Copy_ValueMarketShare_Local_To_Global</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Local_to_Global__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy ValueMarketShare Local To Regional</fullName>
        <actions>
            <name>Copy_ValueMarketShare_Local_To_Regional</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Local_to_Regional__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy ValueMarketShare Regional To Local</fullName>
        <actions>
            <name>Copy_ValueMarketShare_Regional_To_Local</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Regional_to_Local__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Year Charter Approved</fullName>
        <actions>
            <name>AP_Charter_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GM_CharterCopy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PBO_Charter_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Value_Market_Share_Charter_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Charter_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Year Contract Approved</fullName>
        <actions>
            <name>AP_Contract_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GM_Contract_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PBO_Contract_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Value_Market_Share_Contract_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Contract_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Year MD Approved</fullName>
        <actions>
            <name>AP_MD_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GM_MD_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PBO_MD_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Value_Market_Share_MD_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>MD_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Year MR Approved</fullName>
        <actions>
            <name>AP_MR_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GM_MR_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PBO_MR_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Value_Market_Share_MR_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>MR_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
