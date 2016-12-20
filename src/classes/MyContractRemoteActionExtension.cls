global  class MyContractRemoteActionExtension {
	 global  MyContractRemoteActionExtension(ApexPages.StandardController ctr){

    }

    @RemoteAction
    global static Map<String,String> readCustomLabelsById(String txId, List<String> labelIds) {
        return readCustomLabelsByIdInternal(labelIds);
    }
    
    private static Map<String, String> readCustomLabelsByIdInternal(List<String> labelIdentifiers) {
    Map<String, String> result = new Map<String, String>();
    
    Component.Apex.OutputText output = new Component.Apex.OutputText();
    for (String labelIdentifier : labelIdentifiers) {
        output.expressions.value = '{!$Label.' + labelIdentifier + '}';
        result.put(labelIdentifier, String.valueof(output.value));            
    }
    
    return result;
}

}