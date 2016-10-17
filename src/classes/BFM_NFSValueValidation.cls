public class BFM_NFSValueValidation {

Private static Decimal netValue=0;
Private static Decimal SESICMSBaseValue=0;
	Public static void NFSTotalValueValidation(List<BFM_NFS__c> NFSRecord){
        set<Id> recId=New set<Id>();
		Decimal SESTaxvalue;
		Decimal tolerancValue;
		Decimal toleranceMargin;
		Decimal absoluteConsiderationValue;
       	list<BFM_NFS__c> listNFSTaxUpdate = new  list<BFM_NFS__c>();
		If(BFM_CheckRecursive.firstRun==true){
				BFM_CheckRecursive.firstRun=false;
				for(BFM_NFS__c nfs: NFSRecord){
				recId.add(nfs.id);
				}
			system.debug('recID--->'+recId);	
			list<BFM_NFS__c> NFSRecordList = [SELECT Id,NFS_Definitive__c,Tax_Status__c,ISS_Value__c,ISS_Tax_Amount__c,(select Net_Value__c,Gross_Value_net_tax__c,ICMS_Calculation_Base__c from SESNFSs__r) FROM BFM_NFS__c where id IN:recId];
			system.debug('NFSRecordList---->'+NFSRecordList);
            
            for(BFM_NFS__c nfs: NFSRecordList){
				if(nfs.NFS_Definitive__c==true && nfs.SESNFSs__r.size()>0){
                    system.debug('perform Validation---->');
                    system.debug('Number of attached SES---->'+nfs.SESNFSs__r.size());
						for(integer i=0;i<nfs.SESNFSs__r.size();i++){
                            if(nfs.SESNFSs__r[i].Net_Value__c!=null){
						netValue= netValue+ (nfs.SESNFSs__r[i].Net_Value__c);
                        }
						toleranceMargin = netValue*((BFM_ToleranceMargin__c.getValues('Value').Tolerance_Percentage_Value__c)/100);
						tolerancValue = netValue+toleranceMargin;
						SESTaxvalue=nfs.SESNFSs__r[i].Gross_Value_net_tax__c;
						absoluteConsiderationValue=BFM_AbsoluteConsideration__c.getValues('Value').AbsoluteConsideration_Value__c; 							
						}							
					system.debug('netValue---->'+netValue);
                    system.debug('toleranceMargin----->'+toleranceMargin);
                                     
                                        
					if(nfs.ISS_Value__c >netValue && nfs.ISS_Value__c<=tolerancValue){
                        	system.debug('Passes Tolerance check----->');
                        	system.debug('netValue----->'+netValue);
                        	system.debug('absoluteConsiderationValue----->'+absoluteConsiderationValue);
							if(math.abs(nfs.ISS_Value__c-netValue)<=absoluteConsiderationValue){
                                system.debug('Passes Absolute Considertation check----->');
                                system.debug('SESTaxvalue------>'+SESTaxvalue);
                                system.debug('ISS tax value'+nfs.ISS_Tax_Amount__c);
								if(nfs.ISS_Tax_Amount__c!=null && nfs.ISS_Tax_Amount__c==SESTaxvalue){
                                   system.debug('Passes Tax percentage check----->');
                                    nfs.Tax_Status__c='Tax Validation Ok';
									listNFSTaxUpdate.add(nfs);
                                    if(!Approval.isLocked(nfs.Id)){
							Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
							req.setComments('Submitting Request Tax calculation');
							req.setObjectId(nfs.id);
                            Approval.ProcessResult result = Approval.process(req);
                            System.debug('Submitted for approval successfully: '+result.isSuccess());
                                    }
								}
								else{
									nfs.Tax_Status__c='Tax value Error';
									listNFSTaxUpdate.add(nfs);
									BFM_Error_Log__c newError = new BFM_Error_Log__c();          
                                    newError.Reason__c = 'Tax value is not matching';
                                    newError.BFM_NFS__c = nfs.id;
                                    insert newError;
								}
								
							}
							else{
									nfs.Tax_Status__c='Absolute Consideration value Error';
									listNFSTaxUpdate.add(nfs);
									BFM_Error_Log__c newError = new BFM_Error_Log__c();          
                                    newError.Reason__c = 'Obsolute Consideration value is not matching';
                                    newError.BFM_NFS__c = nfs.id;
                                    insert newError;
							}

						}
						else{
                        	nfs.Tax_Status__c='Tolerance Margin Error';
                        	listNFSTaxUpdate.add(nfs);
							//Initiate approval process	
							if(!Approval.isLocked(nfs.Id)){				
							Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
							req.setComments('Submitting Request for Total Value Validation');
							req.setObjectId(nfs.id);
                            Approval.ProcessResult result = Approval.process(req);
                            System.debug('Submitted for approval successfully: '+result.isSuccess());
                            }
                            BFM_Error_Log__c newError = new BFM_Error_Log__c();          
                            newError.Reason__c = 'Out of Tolerance value';
                            newError.BFM_NFS__c = nfs.id;
                            insert newError;
							
							}
                        if(listNFSTaxUpdate != null){
                        Database.SaveResult[] updateRec = Database.update(listNFSTaxUpdate,false);
                        }
				}                         		
			}
		}
	}
}