/********************************************************************
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : This controller is mainly used for search vendor page.
    MetaData     : Properties, Wrapper Calss, Methods
  ********************************************************************/

  public class VPM_SearchVendor{
    // Properties used in VF page to bind UI with Data Model
    public string CountryName{get;set;}
    public list <SelectOption> CountryNameList{get;set;}
    public string Display{get;set;}
    public boolean LaunchScreen{get;set;}
    public string labelText{get;set;}
    public list<mdm_Vendors__c> MDM_Vendor {get;set;}
    public list<OptionWrapper> mdmDetailList {get;set;}
    public list<string> mdmDetailOption{get; set;}
    public string MDMVendor{get;set;}
    public String positions {get; set;}
    public VPM_ECCVendorSearchServiceOutput op = new VPM_ECCVendorSearchServiceOutput();  
    public boolean hideSearchVendor{get;set;}
    public string initialReordType{get;set;}
    public boolean isMaintain2{get;set;}
    public Boolean isRequiredField{get;set;} 
    public boolean renderBackBtn{get;set;}
    public string requestType='Create';
    public list<OptionWrapper> RequestTypeList{get;set;}
     public String sendWebFormLabel {get; set;}
    public boolean sendWebFormScreen{get;set;}
    public boolean showSearchVendor{get;set;}
    public string VPMStatus{get;set;}
    public string screenType{get;set;}
    public list<string> ScreenVisited= new list<string>();
    public string Street1{get; set;}
    public string TaxCode{get;set;}
    public list<string> vendorDetailList{get;set;}
    public string VendorCodeInput{get;set;}
    public string VendorName{get;set;}
    public boolean VendorNotFound{get;set;}
    ApexPages.StandardController vendorReq;
    public string ZIPPostcode{get; set;}
    public VPM_PurchasingRequests__c vendorDetail{get;set;} 
    public VPM_PurchasingRequests__c vendorDetails{get;set;} 
    public string extensionType;
    public string back{get;set;} 
    public string test{get;set;} // Ajay
    public boolean vendornameChange{get;}
    public string searchTerm1{get;set;}
    public Id recId{get;set;}
    // Wrapper Class used to add Name and Value to Radio button on user selection   
    public class OptionWrapper{
    public String DetailOption{get;set;}
    public String UniqueId{get;set;}
    
    }
    
    /******************************************************************** 
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : Apex Constructor for extension class. Load Vendor Details record in "vendorDetail" property.
    Return Type  : Contructor no return type.
    ********************************************************************/
    public VPM_SearchVendor(ApexPages.StandardController controller)
    {
        vendorReq = controller;
        screenType = '';
        positions='Yes';
        isRequiredField=true;
        sendWebFormScreen =false;
        sendWebFormLabel = system.label.VPM_Send_Button;
        recId = controller.getRecord().Id; 
        vendorDetails= (VPM_PurchasingRequests__c)controller.getRecord(); 
        vendorDetail=[SELECT VPM_ECC__c, VPM_ExtensionType__c, VPM_VendorName1__c,VPM_Status__c,VPM_SearchTerm_1__c,VPM_VendorCodeLookup__c, VPM_VendorCodeLookup__r.mdm_ecc__c, VPM_VendorCodeLookup__r.mdm_Code__c, VPM_CompanyCode__c,VPM_CompanyCode__r.VPM_CompanyCode__c, VPM_CompanyCode__r.ECC__c,  VPM_Street1__c, VPM_Country__c, VPM_ZIPPostcode__c, recordTypeId FROM VPM_PurchasingRequests__c WHERE id =: recId];
        Street1=vendorDetail.VPM_Street1__c;
        VendorName =vendorDetail.VPM_VendorName1__c;
        ZIPPostcode = vendorDetail.VPM_ZIPPostcode__c;
        CountryName =vendorDetail.VPM_Country__c;
        searchTerm1 =vendorDetail.VPM_SearchTerm_1__c;
        CountryNameList = getCountries();
        system.debug('@@sendWebFormLabel' + sendWebFormLabel);
        back = ApexPages.currentPage().getParameters().get('back'); // this variable will track if coming from detail page to menu page again
        system.debug('@@back' +back);
        
        LaunchScreen = false;
        //requestType = 'Create';
         requestType = VPM_RecordTypeHelper.getLaunchScreenVariable('',vendorDetail.RecordTypeId);
         initialReordType = requestType;
         VPMStatus = vendorDetail.VPM_Status__c;
          screenType = 'Create';
          system.debug('&&&&&requestType '+requestType);
        if(requestType == 'Create')
        {
           showSearchVendor = false;
          LaunchScreen =true;
          //ScreenVisited.add('Create');
          screenType = 'Create';
        }
        else if(requestType == 'Extend')
        {
           showSearchVendor = false;
          LaunchScreen =true;
          screenType = 'Extend';
          // ScreenVisited.add('Extend');
        }
        else if((requestType == 'Maintain' || requestType == 'Maintain2'))
        {          
          {
           op = FetchVendorDeatilSAPService('');
           showSearchVendor = false;
           LaunchScreen =true;
            screenType = 'Maintain';
            system.debug('###### op '+op);
              if(op <> null) {
               if(op.Blocked || op.Deleted)
                      {
                        requestType='Maintain';
                      }
                      else
                      requestType = 'Maintain2';
                      //ScreenVisited.add('Maintain');
                      }
          }
                //  catch (exception ex){
                 
               //   }
        }
        else
        {
           showSearchVendor = true;
            //ScreenVisited.add('searchVendor');
        }
        setLaunchScreenText();
    }

    /******************************************************************** 
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : Contails logic for searching vendor from "mdm_Vendors__c" object.
    Return Type  : Void
    ********************************************************************/
    public void getVendorDetailList()
    {
      try{
        renderBackBtn = true;
      showSearchVendor  = false;
      hideSearchVendor=true;
      LaunchScreen =false;
      ScreenVisited.add('searchVendor');
      //labelText='Vendor List';
      // Dynamic Query builded for search vendor
      string searchQuery ='SELECT id,VPM_FullDetails__c,mdm_Name1__c,mdm_Street__c ,mdm_City__c,mdm_Country__c,mdm_ecc__c,mdm_Code__c FROM mdm_Vendors__c  WHERE mdm_Name1__c LIKE '+'\'%' + String.escapeSingleQuotes(VendorName) + '%\'' ;
      if(Street1 != '')
          searchQuery+=' AND mdm_Street__c LIKE '+ '\'%' + String.escapeSingleQuotes(Street1) + '%\'';
        if(ZIPPostcode != '')   
              searchQuery+=' AND mdm_Postcode__c LIKE '+ '\'%' + String.escapeSingleQuotes(ZIPPostcode)+ '%\'';
        MDM_Vendor = Database.query(searchQuery);
         mdmDetailList =setmdmDetailOption(MDM_Vendor);
      }
      catch(exception ex){}
    }

    /******************************************************************** 
    Created By   :Vaishali Nagar
    Created Date : 29th July 2016
    Last Modify  : 
    Description  : Invoke when user changes vendor name value
    Return Type  : Void
    ********************************************************************/
    
    public pageReference vendorNameChange(){
    
        searchTerm1 =vendorName.left(10);
        system.debug('@@ searchTerm1' + searchTerm1);
        return null;
    
    }
       public pageReference vendorNameChangetest(){
    
        searchTerm1 =vendorName.left(10);
        system.debug('@@ searchTerm1' + searchTerm1);
        return null;
    
    }

    /******************************************************************** 
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Last Modify  : 15th June 2016
    Description  : Invoke when user select vendor from search List.
    Return Type  : Void
    ********************************************************************/
     public void VendorSelected()
     {
       renderBackBtn = true;
        system.debug('^^^^^^^ '+MDMVendor );
        pageReference pg = null;
     // Condition : When vendor is not listed then blank value is assinged to "MDMVendor"
      system.debug('MDMVendor showSearchVendor '+MDMVendor +' && '+showSearchVendor);
         if(MDMVendor == '' && !sendWebFormScreen)
      {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, System.Label.VPM_Select_Option));
      }
      else if(MDMVendor == 'notlisted')
      {
          system.debug('###initialReordType '+initialReordType);
        if(initialReordType == 'Generic') {
        sendWebFormScreen =true;
        /*pg =  new Pagereference('/apex/VPM_SendWebform?id=' + vendorDetail.id); 
          pg.setRedirect(true); */
            //return pg;
      }
          showSearchVendor  = false;
          hideSearchVendor=false;
          LaunchScreen =sendWebFormScreen == true ?false:true;
          //labelText='T';
          requestType ='Create';
          screenType =requestType ;
          updateVendorDetail(null);
          setLaunchScreenText();
          ScreenVisited.add('vendorList');
           
      }
          // Condition : If not blank "MDMVendor" then it contains vendor Detail record ID
         else if(MDMVendor !='')
          {
              system.debug('###@initialReordType '+initialReordType);
             requestType = VPM_RecordTypeHelper.getLaunchScreenVariable('',vendorDetail.RecordTypeId);
              try{
            list<string> MDMVendorInfo =MDMVendor.split('#',2);     
           // VPM_ECCVendorSearchServiceOutput op = new VPM_ECCVendorSearchServiceOutput();      
            op = FetchVendorDeatilSAPService(MDMVendorInfo[1]);
            showSearchVendor  = false;
            hideSearchVendor=false;
             if(op.vendorFoundResult) 
              {     
                
                if(op.companyCodeMatching)
                {              
                   
                  if(op.Blocked || op.Deleted)
                  {
                    requestType='Maintain';
                  }
                  else{
                    requestType='Maintain2';
                     isMaintain2 =true;
                  }
                   ScreenVisited.add('vendorList');
                LaunchScreen = true;
                 screenType = 'Maintain';
                  system.debug('@@%%OP.Deleted' + screenType); 
                //labelText='Vendor maintain launch screen';
                }
                else 
                {
                //labelText='Vendor extend launch screen';
                LaunchScreen=true;
                requestType ='Extend';
                screenType = 'Extend';
                   
                system.debug('@@WS-ECC'  + op.ECC ); 
               
                if((vendorDetail.VPM_CompanyCode__r.ECC__c).contains(vendorDetail.VPM_VendorCodeLookup__r.mdm_ecc__c)) {                    
                    extensionType = 'Regional';
                }else {
                    extensionType = 'Global';
                }
                    ScreenVisited.add('vendorList');
                }
                system.debug('$$$$$$$$requestType '+requestType);
                setLaunchScreenText();
                LaunchScreen = true;
              }
            else 
            {
            // vendor not found screen or message  
                 //LaunchScreen =true;
                 VendorNotFound =true;
                   ScreenVisited.add('vendorList');
                //labelText='Vendor create launch screen';
            }
            // Update purchasing request record after service call.
                  system.debug('$$$$Before calling update');      
             updateVendorDetail(MDMVendorInfo[0]);
              }
              catch(exception ex)
              {}
            
          }
         else
         {
             system.debug('###!!initialReordType '+initialReordType);
              showSearchVendor  = false;
          hideSearchVendor=false;
             sendWebFormScreen=false;
          LaunchScreen =true;
            isMaintain2 =false;
             ScreenVisited.add('sendWebForm');           
            vendorDetail.VPM_VendorContactDetail__c=vendorDetails.VPM_VendorContactDetail__c;
            vendorDetail.VPM_VendordoesntExistFlag__c=positions;
            update vendorDetail;
              setLaunchScreenText();
         }
          //return pg;
     }
    /******************************************************************** 
    Created By   : Ajay Rawat
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : Invoke when user select request type.
    Return Type  : Void
    ********************************************************************/

    public pageReference processRequestType()
    {
      pageReference pg;
       if(MDMVendor == '')
      {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,System.Label.VPM_Select_Option));
      }
      else if(MDMVendor =='ReviewRequestBrief')
      {
          pg =  new Pagereference('/apex/VPM_RequestBrief?id=' + vendorDetail.id); 
          pg.setRedirect(true);
      }
      else if(MDMVendor =='EditBankDetails' || MDMVendor =='EnterBankDetails') {
         //string QueryString ='&PartnerBankType ='+op.PartnerBankType+'&BankControlKey='+op.BankControlKey+'&BankCountryKey='+op.BankCountryKey+'&BankKey='+op.BankKey+'&BankName='+op.BankName+'&BankAccountNumber='+op.BankAccountNumber+'&AccountHolderName='+op.AccountHolderName+'&SwiftKey='+op.SwiftKey+'&RefSpecBankDetails='+op.RefSpecBankDetails+'&IBAN='+op.IBAN+'&CollectionAuthorization='+op.CollectionAuthorization;
         //system.debug('QueryString'+QueryString);
          string QueryString = '';
          pg =  new Pagereference('/apex/VPM_BankDetailsScreen?id=' + vendorDetail.id + QueryString); 
          system.debug('pg' + pg);
          pg.setRedirect(true);     
      }
      else if(MDMVendor =='EditGeneralVendorDetails' || MDMVendor =='EnterGeneralVendorDet') {
          pg =  new Pagereference('/apex/VPM_GeneralVendorDetails?id=' + vendorDetail.id); 
          pg.setRedirect(true);   
      }
      else if(MDMVendor =='RequestVendorBlock' || MDMVendor =='RequestVendorBlock/Delete' || MDMVendor =='RequestVendorUnBlock/Delete') {
         // pg =  new Pagereference('/apex/VPM_BlockDeleteUnBlockUnDelet?id=' + vendorDetail.id + '&maintainScreen=' + requestType); 
         pg =  new Pagereference('/apex/VPM_BlockDeleteUnBlockUnDelet');
          pg.setRedirect(true);
           pg.getParameters().put('id',vendorDetail.id);
          pg.getParameters().put('maintainScreen',requestType);
      }
      else if(MDMVendor =='EditPaymentTerms' || MDMVendor =='EnterPaymentTerms') {
          string queryString = '&PaymentTerms=' + op.PaymentTerms;
          system.debug('@@ queryString' + queryString);
          pg =  new Pagereference('/apex/VPM_PaymentTerms?id=' + vendorDetail.id +queryString); 
          pg.setRedirect(true);  
      }
      else if(MDMVendor =='VendorMatch')
      {
          showSearchVendor  = true;
          hideSearchVendor=false;
          LaunchScreen =false;
          renderBackBtn = true;
          //screenType = '';
          ScreenVisited.add('VendorMatch');
      }     
      else if(MDMVendor =='EditFinanciallySensitiveFlds' || MDMVendor =='EnterFinanciallySensiFlds') {
          //string queryString = '&ReconciliationAccount=' + op.ReconciliationAccount + '&PaymentMethod=' + op.PaymentMethod + '&GRbasedIV=' +op.GRbasedIV +'&PaymentBlock=' + op.PaymentBlock + '&AlternativePayee=' + op.AlternativePayee;
          //system.debug('@@ queryString' + queryString);
          string QueryString = '';
          pg =  new Pagereference('/apex/VPM_FinanciallySensitive?id=' + vendorDetail.id + queryString); 
          pg.setRedirect(true);   
      }
      else if(MDMVendor =='EditRegionalSpecificFlds' || MDMVendor =='EnterRegionalSpecificFlds') {
          if(vendorDetail.VPM_CompanyCode__r.ECC__c == 'Cordillera') {
               pg =  new Pagereference('/apex/VPM_CordilleraRegionSpecific?id=' + vendorDetail.id); 
          }else if(vendorDetail.VPM_CompanyCode__r.ECC__c == 'Fusion') {
              pg =  new Pagereference('/apex/VPM_FusionRegionSpecific?id=' + vendorDetail.id); 
          }else if(vendorDetail.VPM_CompanyCode__r.ECC__c == 'Sirius') {
              pg =  new Pagereference('/apex/VPM_SiriusRegionSpecific?id=' + vendorDetail.id); 
          }else if(vendorDetail.VPM_CompanyCode__r.ECC__c == 'U2K2') {
              pg =  new Pagereference('/apex/VPM_U2K2RegoinalSpecifics?id=' + vendorDetail.id); 
          }        
          pg.setRedirect(true);  
      }     
      else if(MDMVendor =='SendResendWebform') {
        
          pg =  new Pagereference('/apex/VPM_SendWebform?id=' + vendorDetail.id); 
          pg.setRedirect(true);   
        
      } 
      else if(MDMVendor =='SubmitVendorRequestApproval') {
         if(requestType =='Maintain' || requestType =='Extend' || requestType =='Maintain2') {
         
              if(vendorDetail.VPM_CompanyCode__r.ECC__c == 'Cordillera') {
                  pg =  new Pagereference('/apex/VPM_CordilleraGoldenData?id=' + vendorDetail.id); 
              }else if(vendorDetail.VPM_CompanyCode__r.ECC__c == 'Fusion') {
                  pg =  new Pagereference('/apex/VPM_FusionGoldenData?id=' + vendorDetail.id); 
              }else if(vendorDetail.VPM_CompanyCode__r.ECC__c == 'Sirius') {
                  pg =  new Pagereference('/apex/VPM_SiriusGoldenData?id=' + vendorDetail.id); 
              }else if(vendorDetail.VPM_CompanyCode__r.ECC__c == 'U2K2') {
                  pg =  new Pagereference('/apex/VPM_U2K2GoldenData?id=' + vendorDetail.id); 
              }   
          }else if(requestType =='Create') {
              pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + vendorDetail.id); 
          }        
          pg.setRedirect(true);   
      }
      else if(MDMVendor =='ExitForm') {
          pg =  new Pagereference('/' + vendorDetail.id); 
          pg.setRedirect(true);   
      }
      return pg;
    }

      /******************************************************************** 
    Created By   : Ajay Rawat
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : Invoke when user select request type.
    Return Type  : Void
    ********************************************************************/
    public void updateVendorDetail(id vendorCodeLookup)
    {
    system.debug('$$$Update Called ');
      vendorDetail.VPM_VendorCodeLookup__c = vendorCodeLookup;
       vendorDetail.VPM_VendorName1__c = VendorName;
       vendorDetail.VPM_Street1__c = Street1;
       vendorDetail.VPM_SearchTerm_1__c =searchTerm1;
       vendorDetail.VPM_SearchTerm_1__c = searchTerm1;
       vendorDetail.VPM_ZIPPostcode__c = ZIPPostcode;
       vendorDetail.VPM_Country__c = CountryName;
       system.debug('^^^^^^^ '+MDMVendor );
       //if(MDMVendor != 'notlisted')
       vendorDetail.RecordTypeId = VPM_RecordTypeHelper.getRecordTypeNameById(requestType);
       vendorDetail.VPM_ECC__c = vendorDetail.VPM_CompanyCode__r.ECC__c;
       vendorDetail.VPM_ExtensionType__c = extensionType;
       system.debug('@@vendorDetail' + vendorDetail); 
        
       //vendorReq.save();
       update vendorDetail;
    }
    
    public pageReference saveMethod(){
    
    PageReference pg = null;
    vendorDetail.VPM_VendorName1__c = VendorName;
    vendorDetail.VPM_SearchTerm_1__c = searchTerm1;
    update vendorDetail;
    
     pg =  new Pagereference('/'+recId);  
            pg.setRedirect(true);
    
    return pg;
    
    }

     /******************************************************************** 
   
    Created By   : Ajay Rawat
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : Get details of selected vendor from SAP.
    Return Type  : VPM_FetchVendorsDetails.OutputVariables
    ********************************************************************/
    public VPM_ECCVendorSearchServiceOutput FetchVendorDeatilSAPService(string MDMVendorCodeInput)
    {
        //VPM_CompanyCode__c ComapyCode =[SELECT VPM_CompanyCode__c, ECC__c FROM VPM_CompanyCode__c WHERE id =: vendorDetail.VPM_CompanyCode__c LIMIT 1];
        //mdm_Vendors__c mdmVendor =[SELECT id,mdm_Code__c FROM mdm_Vendors__c  WHERE id =: vendorDetail.VPM_VendorCodeLookup__c ];
        VPM_FetchVendorsDetails.InputVariables ip = new VPM_FetchVendorsDetails.InputVariables();
        List<VPM_FetchVendorsDetails.InputVariables> ipList = new List<VPM_FetchVendorsDetails.InputVariables>();
        List<VPM_ECCVendorSearchServiceOutput> opList = new List<VPM_ECCVendorSearchServiceOutput>();
        if(string.isNotBlank(MDMVendorCodeInput)){
          ip.vendorCodeInput = MDMVendorCodeInput;
      }else {
          ip.vendorCodeInput = vendorDetail.VPM_VendorCodeLookup__r.mdm_Code__c;
      }
      ip.ecc = vendorDetail.VPM_CompanyCode__r.ECC__c;
      ip.compnayCode = vendorDetail.VPM_CompanyCode__r.VPM_CompanyCode__c;
      ipList.add(ip);
      opList = VPM_FetchVendorsDetails.getVendorDetails(ipList);
      return opList[0];
    }

    /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : This method assing value to wrapper class for displaying purpose.
    Return Type  : List of Wrapper Class
    ********************************************************************/
    public list<OptionWrapper> setmdmDetailOption(list<mdm_Vendors__c> mdmDeatilList) 
    {
      List<OptionWrapper> options = new List<OptionWrapper>(); 
      string mdmDisplayName;
      for(mdm_Vendors__c MDMDetail : mdmDeatilList)
        {
        OptionWrapper option = new OptionWrapper();
        option.DetailOption =MDMDetail.VPM_FullDetails__c;
        option.UniqueId = MDMDetail.id+'#'+MDMDetail.mdm_Code__c;
        options.add(option); 
        }
      OptionWrapper option = new OptionWrapper();
      option.DetailOption =System.label.VPM_MyVendorisnotlisted ;
      option.UniqueId = 'notlisted';
      options.add(option);
      return options;

    }  
    /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 15th June 2016
    Last Modify  : 16th June 2016
    Description  : This method assing value to launch screen radio btn.
    Return Type  : List of Wrapper Class
    ********************************************************************/
    public void setLaunchScreenText() 
    {
     system.debug('@@@@22222222requestType '+requestType);
      String OptionWrapperJSON ='[{"DetailOption":"Review Request Brief","UniqueId":"ReviewRequestBrief"},';
     if(requestType =='Maintain' || requestType =='Extend')
       {
      OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditBankDetails+'","UniqueId":"EditBankDetails"},';
       //OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditBankDetails+'","UniqueId":"EditBankDetails"},';
      OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_General_Vendor_Details+'","UniqueId":"EditGeneralVendorDetails"},';
      if(requestType =='Maintain')
      OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_RequestVendortoBlock_Delete+'","UniqueId":"RequestVendorBlock/Delete"},';
      OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditPaymentTerms + '","UniqueId":"EditPaymentTerms"},';
      OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_VendorMatch + '","UniqueId":"VendorMatch"},';
      OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditFinanciallySensitiveFields + '","UniqueId":"EditFinanciallySensitiveFlds"},';  
      OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditRegionalSpecificFields + '","UniqueId":"EditRegionalSpecificFlds"},';
     }
      
       //Maintain 1
       else if(requestType =='Maintain2')
       {
        OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_VendorMatch + '","UniqueId":"VendorMatch"},';
      OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_RequestVendortoUnblock_Undelete + '","UniqueId":"RequestVendorUnBlock/Delete"},';
      isMaintain2 = true;
      }
   else  
       {
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterBankDetails + '","UniqueId":"EnterBankDetails"},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterPaymentTerms + '","UniqueId":"EnterPaymentTerms"},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterGeneralVendorDetails + '","UniqueId":"EnterGeneralVendorDet"},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterFinanciallySensitiveFields + '","UniqueId":"EnterFinanciallySensiFlds"},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterRegionalSpecificFields + '","UniqueId":"EnterRegionalSpecificFlds"},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_Send_ResendWebformRequest + '","UniqueId":"SendResendWebform"},';
      }


       // Common for all
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_SubmitVendorRequestforApproval + '","UniqueId":"SubmitVendorRequestApproval"},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_Exitthisform + '","UniqueId":"ExitForm"}]';
      RequestTypeList = (List<OptionWrapper>) System.JSON.deserialize(OptionWrapperJSON, List<OptionWrapper>.class);
      MDMVendor ='';
    }

    /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 21th June 2016
    Last Modify  : 16th June 2016
    Description  : Back button functinality.
    Return Type  : Void.
    ********************************************************************/
     public void backBtnAction()
     {
      try{
          string currentScreen = ScreenVisited[ScreenVisited.size() -1];
      
      if(currentScreen == 'searchVendor')
      {      
        showSearchVendor = true;
        LaunchScreen= false;
        hideSearchVendor =false;
           sendWebFormScreen =false;
        ScreenVisited.remove(ScreenVisited.size() -1);
       }
       else if(currentScreen == 'vendorList')
      {      
        showSearchVendor = false;
        LaunchScreen= false;
        hideSearchVendor =true;
           sendWebFormScreen =false;
        ScreenVisited.remove(ScreenVisited.size() -1);
         MDMVendor='';
          VendorNotFound =false;
          isMaintain2 =false;

      }
      else if(currentScreen == 'requestType')
      {
        showSearchVendor = false;
        LaunchScreen= true;
        hideSearchVendor =false;
           sendWebFormScreen =false;
         ScreenVisited.remove(ScreenVisited.size() -1);
      }
         else if(currentScreen == 'VendorMatch')//sendWebForm
      {
        showSearchVendor = false;
        LaunchScreen= true;
        hideSearchVendor =false;
          sendWebFormScreen =false;
          MDMVendor='';
         ScreenVisited.remove(ScreenVisited.size() -1);
      }
          else if(currentScreen == 'sendWebForm')
      {
        showSearchVendor = false;
        LaunchScreen= false;
        hideSearchVendor =false;
          sendWebFormScreen =true;
         ScreenVisited.remove(ScreenVisited.size() -1);
      }
      
      if(ScreenVisited.size() == 0)
         renderBackBtn = false;
      }
      catch(exception ex){
        renderBackBtn = false;
      }
    
     }
 
     public List<SelectOption> getCountries()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
     VPM_PurchasingRequests__c.VPM_Country__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }
          /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 30th June 2016
    Last Modify  : 30th June 2016
    Description  : Check email mandatory or not send web form.
    Return Type  : Void.
    ********************************************************************/
          public void  newMethod() 
          {
        IF( positions == 'Yes')
        {
            isRequiredField = true;
            sendWebFormLabel = system.label.VPM_Send_Button;
        }else {
            isRequiredField = false;
            sendWebFormLabel = system.label.VPM_Next;
        } 
        system.debug('@@sendWebFormLabel' + sendWebFormLabel);      
    }
   
  }