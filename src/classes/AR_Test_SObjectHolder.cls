@isTest 
public with sharing class AR_Test_SObjectHolder {
	static testmethod void Test_SObjectHolder()
	{
		Account Account1 = new Account(
			Name = 'TestAccount'
		);
		Attachment testAtt = new Attachment();
		testAtt.Name = 'one_test';
		List<Attachment> TestList = new List<Attachment>();
		TestList.add(testAtt);
		
		AR_SObjectHolder testHolder = new AR_SObjectHolder();
		testHolder.setPrefilled(true);
		testHolder.getPrefilled();
		
		
		AR_SObjectHolder testHolder2 = new AR_SObjectHolder(Account1);
		testHolder2.setFiles(TestList);
		testHolder2.fillmap();
		testHolder2.getFiles();
		testHolder2.SetFiletoInsert('one');
		testHolder2.setAllFilesParentIds();
		testHolder2.SetAllBodystoNull();
		testHolder2.getFilesCount();
		testHolder2.getId();
		testHolder2.remove();
		testHolder2.getIsDeleted();
		testHolder2.getFilesasList();
		
	}
}