/*
  Class Name: Core_CA_IBaseAppicationServices
  Author : Mindtree
  Date: 1 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Interface used for Core_CA_BaseApplicationServices class
*/
public interface Core_CA_IBaseAppicationServices{
    Core_CA_BaseApplicationWrapper invokeService(Core_CA_ApplicationWrapper appWrapperObj);
}