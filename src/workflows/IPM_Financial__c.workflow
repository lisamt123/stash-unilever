<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_IRR_Local_From_Global</fullName>
        <field>IRR_Local__c</field>
        <formula>IRR_Global__c</formula>
        <name>Copy IRR Local From Global</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_IRR_Local_From_Regional</fullName>
        <field>IRR_Local__c</field>
        <formula>IRR_Regional__c</formula>
        <name>Copy IRR Local From Regional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_IRR_Regional_From_Global</fullName>
        <field>IRR_Regional__c</field>
        <formula>IRR_Global__c</formula>
        <name>Copy IRR Regional From Global</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_IRR_Regional_From_Local</fullName>
        <field>IRR_Regional__c</field>
        <formula>IRR_Local__c</formula>
        <name>Copy IRR Regional From Local</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Charter_Copy_BIC</fullName>
        <field>BIC_Charter__c</field>
        <formula>BIC_Global__c</formula>
        <name>Financial Charter Copy BIC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Charter_Copy_CAPEX</fullName>
        <field>CAPEX_Charter__c</field>
        <formula>CAPEX_Global__c</formula>
        <name>Financial Charter Copy CAPEX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Charter_Copy_GM_Y1</fullName>
        <field>GM_Y1_bps_vs_DNDS_Charter__c</field>
        <formula>GM_Y1_bps_vs_DNDS_Global__c</formula>
        <name>Financial Charter Copy GM Y1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Charter_Copy_IRR</fullName>
        <field>IRR_Charter__c</field>
        <formula>IRR_Global__c</formula>
        <name>Financial Charter Copy IRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Charter_Copy_NPV</fullName>
        <field>NPV_Charter__c</field>
        <formula>NPV_Global__c</formula>
        <name>Financial Charter Copy NPV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Charter_Copy_PBO_Y1</fullName>
        <field>PBO_Y1_bps_vs_DNDS_Charter__c</field>
        <formula>PBO_Y1_bps_vs_DNDS_Global__c</formula>
        <name>Financial Charter Copy PBO Y1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Charter_Copy_Payback</fullName>
        <field>Payback_Charter__c</field>
        <formula>Payback_Global__c</formula>
        <name>Financial Charter Copy Payback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Charter_Copy_Volume_Unit</fullName>
        <field>Volume_Unit_Charter__c</field>
        <formula>TEXT(Volume_Unit_Global__c)</formula>
        <name>Financial Charter Copy Volume Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Charter_Copy_Year_3_iTO</fullName>
        <field>Year_3_iTO_Charter__c</field>
        <formula>Year_3_iTO_Global__c</formula>
        <name>Financial Charter Copy Year 3 iTO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Charter_Locked</fullName>
        <field>Charter_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Financial Charter Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Contract_Copy_BIC</fullName>
        <field>BIC_Contract__c</field>
        <formula>BIC_Regional__c</formula>
        <name>Financial Contract Copy BIC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Contract_Copy_CAPEX</fullName>
        <field>CAPEX_Contract__c</field>
        <formula>CAPEX_Regional__c</formula>
        <name>Financial Contract Copy CAPEX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Contract_Copy_GM_Y1</fullName>
        <field>GM_Y1_bps_vs_DNDS_Contract__c</field>
        <formula>GM_Y1_bps_vs_DNDS_Regional__c</formula>
        <name>Financial Contract Copy GM Y1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Contract_Copy_IRR</fullName>
        <field>IRR_Contract__c</field>
        <formula>IRR_Regional__c</formula>
        <name>Financial Contract Copy IRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Contract_Copy_NPV</fullName>
        <field>NPV_Contract__c</field>
        <formula>NPV_Regional__c</formula>
        <name>Financial Contract Copy NPV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Contract_Copy_PBO_Y1</fullName>
        <field>PBO_Y1_bps_vs_DNDS_Contract__c</field>
        <formula>PBO_Y1_bps_vs_DNDS_Regional__c</formula>
        <name>Financial Contract Copy PBO Y1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Contract_Copy_Payback</fullName>
        <field>Payback_Contract__c</field>
        <formula>Payback_Regional__c</formula>
        <name>Financial Contract Copy Payback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Contract_Copy_Volume_Unit</fullName>
        <field>Volume_Unit_Contract__c</field>
        <formula>TEXT(Volume_Unit_Regional__c)</formula>
        <name>Financial Contract Copy Volume Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Contract_Copy_Year_3_iTO</fullName>
        <field>Year_3_iTO_Contract__c</field>
        <formula>Year_3_iTO_Regional__c</formula>
        <name>Financial Contract Copy Year 3 iTO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Contract_Locked</fullName>
        <field>Contract_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Financial Contract Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2L_BIC</fullName>
        <field>BIC_Local__c</field>
        <formula>BIC_Global__c</formula>
        <name>Financial Copy G2L BIC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2L_CAPEX</fullName>
        <field>CAPEX_Local__c</field>
        <formula>CAPEX_Global__c</formula>
        <name>Financial Copy G2L CAPEX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2L_IRR</fullName>
        <field>IRR_Local__c</field>
        <formula>IRR_Global__c</formula>
        <name>Financial Copy G2L IRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2L_NPV</fullName>
        <field>NPV_Local__c</field>
        <formula>NPV_Global__c</formula>
        <name>Financial Copy G2L NPV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2L_Payback</fullName>
        <field>Payback_Local__c</field>
        <formula>Payback_Global__c</formula>
        <name>Financial Copy G2L Payback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2L_Volume_Unit_000_Unit</fullName>
        <field>Volume_Unit_Local__c</field>
        <literalValue>Total &apos;000 Units</literalValue>
        <name>Financial Copy G2L Volume Unit &apos;000 Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2L_Volume_Unit_Tons</fullName>
        <field>Volume_Unit_Local__c</field>
        <literalValue>Total Tons</literalValue>
        <name>Financial Copy G2L Volume Unit Tons</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2R_BIC</fullName>
        <field>BIC_Regional__c</field>
        <formula>BIC_Global__c</formula>
        <name>Financial Copy G2R BIC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2R_CAPEX</fullName>
        <field>CAPEX_Regional__c</field>
        <formula>CAPEX_Global__c</formula>
        <name>Financial Copy G2R CAPEX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2R_IRR</fullName>
        <field>IRR_Regional__c</field>
        <formula>IRR_Global__c</formula>
        <name>Financial Copy G2R IRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2R_NPV</fullName>
        <field>NPV_Regional__c</field>
        <formula>NPV_Global__c</formula>
        <name>Financial Copy G2R NPV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2R_Payback</fullName>
        <field>Payback_Regional__c</field>
        <formula>Payback_Global__c</formula>
        <name>Financial Copy G2R Payback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2R_Volume_Unit_000_Unit</fullName>
        <field>Volume_Unit_Regional__c</field>
        <literalValue>Total &apos;000 Units</literalValue>
        <name>Financial Copy G2R Volume Unit &apos;000 Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_G2R_Volume_Unit_Tons</fullName>
        <field>Volume_Unit_Regional__c</field>
        <literalValue>Total Tons</literalValue>
        <name>Financial Copy G2R Volume Unit Tons</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_L2R_BIC</fullName>
        <field>BIC_Regional__c</field>
        <formula>BIC_Local__c</formula>
        <name>Financial Copy L2R BIC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_L2R_CAPEX</fullName>
        <field>CAPEX_Regional__c</field>
        <formula>CAPEX_Local__c</formula>
        <name>Financial Copy L2R CAPEX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_L2R_IRR</fullName>
        <field>IRR_Regional__c</field>
        <formula>IRR_Local__c</formula>
        <name>Financial Copy L2R IRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_L2R_NPV</fullName>
        <field>NPV_Regional__c</field>
        <formula>NPV_Local__c</formula>
        <name>Financial Copy L2R NPV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_L2R_Payback</fullName>
        <field>Payback_Regional__c</field>
        <formula>Payback_Local__c</formula>
        <name>Financial Copy L2R Payback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_L2R_Volume_Unit_000_Unit</fullName>
        <field>Volume_Unit_Regional__c</field>
        <literalValue>Total &apos;000 Units</literalValue>
        <name>Financial Copy L2R Volume Unit &apos;000 Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_L2R_Volume_Unit_Tons</fullName>
        <field>Volume_Unit_Regional__c</field>
        <literalValue>Total Tons</literalValue>
        <name>Financial Copy L2R Volume Unit Tons</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_R2L_BIC</fullName>
        <field>BIC_Local__c</field>
        <formula>BIC_Regional__c</formula>
        <name>Financial Copy R2L BIC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_R2L_CAPEX</fullName>
        <field>CAPEX_Local__c</field>
        <formula>CAPEX_Regional__c</formula>
        <name>Financial Copy R2L CAPEX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_R2L_IRR</fullName>
        <field>IRR_Local__c</field>
        <formula>IRR_Regional__c</formula>
        <name>Financial Copy R2L IRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_R2L_NPV</fullName>
        <field>NPV_Local__c</field>
        <formula>NPV_Regional__c</formula>
        <name>Financial Copy R2L NPV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_R2L_Payback</fullName>
        <field>Payback_Local__c</field>
        <formula>Payback_Regional__c</formula>
        <name>Financial Copy R2L Payback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_R2L_Volume_Unit_000_Unit</fullName>
        <field>Volume_Unit_Local__c</field>
        <literalValue>Total &apos;000 Units</literalValue>
        <name>Financial Copy R2L Volume Unit &apos;000 Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Copy_R2L_Volume_Unit_Tons</fullName>
        <field>Volume_Unit_Local__c</field>
        <literalValue>Total Tons</literalValue>
        <name>Financial Copy R2L Volume Unit Tons</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MD_Copy_BIC</fullName>
        <field>BIC_MD__c</field>
        <formula>BIC_Local__c</formula>
        <name>Financial MD Copy BIC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MD_Copy_CAPEX</fullName>
        <field>CAPEX_MD__c</field>
        <formula>CAPEX_Local__c</formula>
        <name>Financial MD Copy CAPEX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MD_Copy_GM_Y1</fullName>
        <field>GM_Y1_bps_vs_DNDS_MD__c</field>
        <formula>GM_Y1_bps_vs_DNDS_Local__c</formula>
        <name>Financial MD Copy GM Y1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MD_Copy_IRR</fullName>
        <field>IRR_MD__c</field>
        <formula>IRR_Local__c</formula>
        <name>Financial MD Copy IRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MD_Copy_NPV</fullName>
        <field>NPV_MD__c</field>
        <formula>NPV_Local__c</formula>
        <name>Financial MD Copy NPV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MD_Copy_PBO_Y1</fullName>
        <field>PBO_Y1_bps_vs_DNDS_MD__c</field>
        <formula>PBO_Y1_bps_vs_DNDS_Local__c</formula>
        <name>Financial MD Copy PBO Y1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MD_Copy_Payback</fullName>
        <field>Payback_MD__c</field>
        <formula>Payback_Local__c</formula>
        <name>Financial MD Copy Payback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MD_Copy_Volume_Unit</fullName>
        <field>Volume_Unit_MD__c</field>
        <formula>TEXT(Volume_Unit_Local__c)</formula>
        <name>Financial MD Copy Volume Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MD_Copy_Year_3_iTO</fullName>
        <field>Year_3_iTO_MD__c</field>
        <formula>Year_3_iTO_Local__c</formula>
        <name>Financial MD Copy Year 3 iTO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MD_Locked</fullName>
        <field>MD_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Financial MD Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MR_Copy_BIC</fullName>
        <field>BIC_MR__c</field>
        <formula>BIC_Regional__c</formula>
        <name>Financial MR Copy BIC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MR_Copy_CAPEX</fullName>
        <field>CAPEX_MR__c</field>
        <formula>CAPEX_Regional__c</formula>
        <name>Financial MR Copy CAPEX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MR_Copy_GM_Y1</fullName>
        <field>GM_Y1_bps_vs_DNDS_MR__c</field>
        <formula>GM_Y1_bps_vs_DNDS_Regional__c</formula>
        <name>Financial MR Copy GM Y1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MR_Copy_IRR</fullName>
        <field>IRR_MR__c</field>
        <formula>IRR_Regional__c</formula>
        <name>Financial MR Copy IRR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MR_Copy_NPV</fullName>
        <field>NPV_MR__c</field>
        <formula>NPV_Regional__c</formula>
        <name>Financial MR Copy NPV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MR_Copy_PBO_Y1</fullName>
        <field>PBO_Y1_bps_vs_DNDS_MR__c</field>
        <formula>PBO_Y1_bps_vs_DNDS_Regional__c</formula>
        <name>Financial MR Copy PBO Y1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MR_Copy_Payback</fullName>
        <field>Payback_MR__c</field>
        <formula>Payback_Regional__c</formula>
        <name>Financial MR Copy Payback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MR_Copy_Volume_Unit</fullName>
        <field>Volume_Unit_MR__c</field>
        <formula>TEXT(Volume_Unit_Regional__c)</formula>
        <name>Financial MR Copy Volume Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MR_Copy_Year_3_iTO</fullName>
        <field>Year_3_iTO_MR__c</field>
        <formula>Year_3_iTO_Regional__c</formula>
        <name>Financial MR Copy Year 3 iTO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_MR_Locked</fullName>
        <field>MR_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Financial MR Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Set_Copy_G2L_FALSE</fullName>
        <field>Copy_Global_to_Local__c</field>
        <literalValue>0</literalValue>
        <name>Financial Set Copy G2L FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Set_Copy_G2R_FALSE</fullName>
        <field>Copy_Global_to_Regional__c</field>
        <literalValue>0</literalValue>
        <name>Financial Set Copy G2R FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Set_Copy_L2R_FALSE</fullName>
        <field>Copy_Local_to_Regional__c</field>
        <literalValue>0</literalValue>
        <name>Financial Set Copy L2R FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Set_Copy_R2L_FALSE</fullName>
        <field>Copy_Regional_to_Local__c</field>
        <literalValue>0</literalValue>
        <name>Financial Set Copy R2L FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Set_Misaligned_Date</fullName>
        <field>Misaligned_Date__c</field>
        <formula>TODAY()</formula>
        <name>IPM_Set Misaligned Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IRR_Charter_Copy_Over</fullName>
        <field>IRR_Charter__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), IRR_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),IRR_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),IRR_Local__c,0)))</formula>
        <name>IRR Charter Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IRR_Contract_Copy_Over</fullName>
        <field>IRR_Contract__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), IRR_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),IRR_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),IRR_Local__c,0)))</formula>
        <name>IRR Contract Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IRR_Market_Deployment_Copy_Over</fullName>
        <field>IRR_MD__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), IRR_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),IRR_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),IRR_Local__c,0)))</formula>
        <name>IRR Market Deployment Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IRR_Market_Ready_Copy_Over</fullName>
        <field>IRR_MR__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), IRR_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),IRR_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),IRR_Local__c,0)))</formula>
        <name>IRR Market Ready Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MisalignmentDateTime</fullName>
        <field>MisalignmentDateTime__c</field>
        <formula>now()</formula>
        <name>MisalignmentDateTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Financial IRR Global To Local</fullName>
        <actions>
            <name>Copy_IRR_Local_From_Global</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Global_to_Local__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy Financial IRR Global To Regional</fullName>
        <actions>
            <name>Copy_IRR_Regional_From_Global</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Global_to_Regional__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy Financial IRR Local To Regional</fullName>
        <actions>
            <name>Copy_IRR_Regional_From_Local</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Local_to_Regional__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy Financial IRR Regional To Local</fullName>
        <actions>
            <name>Copy_IRR_Local_From_Regional</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Regional_to_Local__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Charter Approved</fullName>
        <actions>
            <name>Financial_Charter_Copy_BIC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Charter_Copy_CAPEX</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Charter_Copy_GM_Y1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Charter_Copy_IRR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Charter_Copy_NPV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Charter_Copy_PBO_Y1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Charter_Copy_Payback</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Charter_Copy_Volume_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Charter_Copy_Year_3_iTO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Charter_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Charter_Approved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Contract Approved</fullName>
        <actions>
            <name>Financial_Contract_Copy_BIC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Contract_Copy_CAPEX</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Contract_Copy_GM_Y1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Contract_Copy_IRR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Contract_Copy_NPV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Contract_Copy_PBO_Y1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Contract_Copy_Payback</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Contract_Copy_Volume_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Contract_Copy_Year_3_iTO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Contract_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Contract_Approved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy G2L Volume Unit %27000 Unit</fullName>
        <actions>
            <name>Financial_Copy_G2L_Volume_Unit_000_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Global_to_Local__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Financial__c.Volume_Unit_Global__c</field>
            <operation>equals</operation>
            <value>Total &apos;000 Units</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy G2L Volume Unit Tons</fullName>
        <actions>
            <name>Financial_Copy_G2L_Volume_Unit_Tons</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Global_to_Local__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Financial__c.Volume_Unit_Global__c</field>
            <operation>equals</operation>
            <value>Total Tons</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy G2R Volume Unit %27000 Unit</fullName>
        <actions>
            <name>Financial_Copy_G2R_Volume_Unit_000_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Global_to_Regional__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Financial__c.Volume_Unit_Global__c</field>
            <operation>equals</operation>
            <value>Total &apos;000 Units</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy G2R Volume Unit Tons</fullName>
        <actions>
            <name>Financial_Copy_G2R_Volume_Unit_Tons</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Global_to_Regional__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Financial__c.Volume_Unit_Global__c</field>
            <operation>equals</operation>
            <value>Total Tons</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy Global to Local</fullName>
        <actions>
            <name>Financial_Copy_G2L_BIC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_G2L_CAPEX</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_G2L_IRR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_G2L_NPV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_G2L_Payback</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Set_Copy_G2L_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Global_to_Local__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy Global to Regional</fullName>
        <actions>
            <name>Financial_Copy_G2R_BIC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_G2R_CAPEX</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_G2R_IRR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_G2R_NPV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_G2R_Payback</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Set_Copy_G2R_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Global_to_Regional__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy L2R Volume Unit %27000 Unit</fullName>
        <actions>
            <name>Financial_Copy_L2R_Volume_Unit_000_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Local_to_Regional__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Financial__c.Volume_Unit_Local__c</field>
            <operation>equals</operation>
            <value>Total &apos;000 Units</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy L2R Volume Unit Tons</fullName>
        <actions>
            <name>Financial_Copy_L2R_Volume_Unit_Tons</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Local_to_Regional__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Financial__c.Volume_Unit_Local__c</field>
            <operation>equals</operation>
            <value>Total Tons</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy Local to Regional</fullName>
        <actions>
            <name>Financial_Copy_L2R_BIC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_L2R_CAPEX</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_L2R_IRR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_L2R_NPV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_L2R_Payback</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Set_Copy_L2R_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Local_to_Regional__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy R2L Volume Unit %27000 Unit</fullName>
        <actions>
            <name>Financial_Copy_R2L_Volume_Unit_000_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Regional_to_Local__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Financial__c.Volume_Unit_Regional__c</field>
            <operation>equals</operation>
            <value>Total &apos;000 Units</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy R2L Volume Unit Tons</fullName>
        <actions>
            <name>Financial_Copy_R2L_Volume_Unit_Tons</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Regional_to_Local__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Financial__c.Volume_Unit_Regional__c</field>
            <operation>equals</operation>
            <value>Total Tons</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Copy Regional to Local</fullName>
        <actions>
            <name>Financial_Copy_R2L_BIC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_R2L_CAPEX</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_R2L_IRR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_R2L_NPV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Copy_R2L_Payback</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Set_Copy_R2L_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.Copy_Regional_to_Local__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial MD Approved</fullName>
        <actions>
            <name>Financial_MD_Copy_BIC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MD_Copy_CAPEX</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MD_Copy_GM_Y1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MD_Copy_IRR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MD_Copy_NPV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MD_Copy_PBO_Y1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MD_Copy_Payback</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MD_Copy_Volume_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MD_Copy_Year_3_iTO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MD_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.MD_Approved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial MR Approved</fullName>
        <actions>
            <name>Financial_MR_Copy_BIC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MR_Copy_CAPEX</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MR_Copy_GM_Y1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MR_Copy_IRR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MR_Copy_NPV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MR_Copy_PBO_Y1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MR_Copy_Payback</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MR_Copy_Volume_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MR_Copy_Year_3_iTO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_MR_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Financial__c.MR_Approved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Charter Approved</fullName>
        <actions>
            <name>IRR_Charter_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Charter_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Contract Approved</fullName>
        <actions>
            <name>IRR_Contract_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Contract_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Market Deployment Approved</fullName>
        <actions>
            <name>IRR_Market_Deployment_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>MD_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Market Ready Approved</fullName>
        <actions>
            <name>IRR_Market_Ready_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>MR_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM_Calculate Misaligned Date</fullName>
        <actions>
            <name>IPM_Set_Misaligned_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MisalignmentDateTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(AND( Misaligned__c,  ISCHANGED( Misaligned__c )),  true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Misalignment</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Financial__c.Misaligned__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
