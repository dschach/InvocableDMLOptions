/**
 * Invocable class to add DML Options to any record
 *
 * @author David Schach
 * @since  2022
 */
global with sharing class InvocableDMLOptions {
	@InvocableMethod
	global static List<DMLOptionResult> execute(List<DMLOptionRequest> requestList) {
		Database.DMLOptions dmo = new Database.dmlOptions();

		//Wrap the DMLOptionResult object in a List container
		//(an extra step added to allow this interface to also support bulkification)
		List<DMLOptionResult> responseWrapper = new List<DMLOptionResult>();
		for (DMLOptionRequest r : requestList) {
		}
		return responseWrapper;
	}

	global class DMLOptionRequest {
		@InvocableVariable(label='Records for Input' description='yourDescription' required=true)
		global SObject inputRecord;

		@InvocableVariable(label='Use Assignment Rule' description='For Leads and Cases, should an assignment rule be used?' required=false)
		global Boolean useAssignmentRule;

		@InvocableVariable(label='LABEL' description='If Use Assignment Rule is true, leaving this blank will use the default assignment rule' required=false)
		global Id assignmentRuleID;

		@InvocableVariable(label='LABEL' description='myDescription' required=false)
		global Boolean useDuplicateRuleHeader;

		@InvocableVariable(label='LABEL' description='myDescription' required=false)
		global Boolean allowSave;

		@InvocableVariable(label='LABEL' description='myDescription' required=false)
		global Boolean runAsCurrentUser;

		@InvocableVariable(label='LABEL' description='myDescription' required=false)
		global Boolean useEmailHeader;

		@InvocableVariable(label='LABEL' description='myDescription' required=false)
		global Boolean triggerAutoResponseEmail;

		@InvocableVariable(label='LABEL' description='myDescription' required=false)
		global Boolean triggerOtherEmail;

		@InvocableVariable(label='LABEL' description='myDescription' required=false)
		global Boolean triggerUserEmail;

		@InvocableVariable(label='LABEL' description='myDescription' required=false)
		global Boolean allowFieldTruncation;

		@InvocableVariable(label='LABEL' description='myDescription' required=false)
		global String localeOptions;

		@InvocableVariable(label='LABEL' description='myDescription' required=false)
		global Boolean optAllOrNone;
	}

	global class DMLOptionResult {
		@InvocableVariable(label='Output Record' description='yourDescription' required=true)
		global SObject outputMembers;
	}
}