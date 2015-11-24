/**********************************************************************
 Name:  cec_EmailMessageHandler()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  for Issue                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
   1.0 -   Aalokkumar       19/09/2014       INITIAL DEVELOPMENT         Email Message
****************************************************************************/


public class cec_EmailMessageHandler{

 public void forbeforeInsert(List<EmailMessage> emList){
system.debug('~~~~~Entering cec_EmailMessageHandler: '+ ' emList '+emList);

  
   cec_EmailMessageHelper ocec_EmailMessageHelper = new cec_EmailMessageHelper();
    ocec_EmailMessageHelper.emailMessage(emList);

system.debug('~~~~~Exiting  cec_EmailMessageHandler: ');    
    
  }      


}