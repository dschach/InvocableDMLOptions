/**
 * Invocable class to add DML Options to any record
 *
 * @author David Schach
 * @since  2022
 */
global with sharing class InvocableDMLOptions {
	/**
	 * Invocable method to add DMLOptions to a list of SObjects
	 *
	 * @param requestList Wrapper for DMLOptions specified in Flow
	 * @return            `List<DMLOptionResult>` Wrapper for SObject to use in next Flow steps
	 */
	@InvocableMethod(label='Set DML Options' description='Add DML Options when inserting or updating a record.' category='DML')
	global static List<DMLOptionResult> execute(List<DMLOptionRequest> requestList) {
		Database.DMLOptions dmo = new Database.dmlOptions();
		DMLOptionRequest dmr = requestList[0];

		// Allow Field Truncation
		if (dmr.allowFieldTruncation != null) {
			if (dmr.allowFieldTruncation) {
				dmo.AllowFieldTruncation = true;
			} else if (!dmr.allowFieldTruncation) {
				dmo.AllowFieldTruncation = false;
			}
		}

		// Assignment Rule
		if (dmr.useAssignmentRule != null) {
			if (dmr.useAssignmentRule) {
				if (String.isNotBlank(dmr.assignmentRuleID)) {
					dmo.AssignmentRuleHeader.AssignmentRuleId = dmr.assignmentRuleID;
				} else {
					dmo.AssignmentRuleHeader.UseDefaultRule = true;
				}
			}
		}

		// Duplicate Rules
		if (dmr.allowSave != null) {
			dmo.DuplicateRuleHeader.AllowSave = dmr.allowSave;
			if (dmr.runAsCurrentUser != null) {
				dmo.DuplicateRuleHeader.RunAsCurrentUser = dmr.runAsCurrentUser;
			}
		}

		// Email Header
		if (dmr.triggerAutoResponseEmail != null && dmr.triggerAutoResponseEmail) {
			dmo.EmailHeader.TriggerAutoResponseEmail = true;
		}
		if (dmr.triggerOtherEmail != null && dmr.triggerOtherEmail) {
			dmo.EmailHeader.TriggerOtherEmail = true;
		}
		if (dmr.triggerUserEmail != null && dmr.triggerUserEmail) {
			dmo.EmailHeader.TriggerUserEmail = true;
		}

		// LocaleOptions
		if (String.isNotBlank(dmr.localeOptions)) {
			dmo.LocaleOptions = dmr.localeOptions;
		}

		// All or None - defaults to false
		if (dmr.optAllOrNone) {
			dmo.OptAllOrNone = true;
		} else {
			dmo.OptAllOrNone = false;
		}

		//Wrap the DMLOptionResult object in a List container
		//(an extra step added to allow this interface to also support bulkification)
		List<DMLOptionResult> responseWrappers = new List<DMLOptionResult>();
		for (DMLOptionRequest r : requestList) {
			(r.inputRecord).setOptions(dmo);
			DMLOptionResult dmor = new DMLOptionResult();
			dmor.outputSObject = r.inputRecord;
			responseWrappers.add(dmor);
		}
		return responseWrappers;
	}

	/**
	 * Wrapper for desired DMLOption options and an SObject
	 */
	global class DMLOptionRequest {
		/**
		 * Constructor with some default values
		 */
		global DMLOptionRequest() {
			this.optAllOrNone = false;
			this.allowFieldTruncation = false;
			this.localeOptions = UserInfo.getLocale();
		}

		@InvocableVariable(label='Records for Input' description='yourDescription' required=true)
		global SObject inputRecord;

		@InvocableVariable(label='Use Assignment Rule (Leads and Contacts only)' description='For Leads and Cases, should an assignment rule be used?' required=false)
		global Boolean useAssignmentRule;

		@InvocableVariable(
			label='Assignment Rule Id (blank for default) - Leads and Contacts only'
			description='The Id of the assignment rule to use. If Use Assignment Rule is true, leaving this blank will use the default assignment rule.'
			required=false
		)
		global Id assignmentRuleID;

		@InvocableVariable(
			label='Bypass Duplicate Rules'
			description='For a duplicate rule, when the Alert option is enabled, bypass alerts and save duplicate records by setting this property to true. Prevent duplicate records from being saved by setting this property to false.'
			required=false
		)
		global Boolean allowSave;

		@InvocableVariable(
			label='Use Current User Record Visibility if using Duplicate Rules'
			description='If specified as true, duplicate rules run for the current user, which ensures users can’t view duplicate records that aren’t available to them.'
			required=false
		)
		global Boolean runAsCurrentUser;

		/* @InvocableVariable(label='LABEL' description='myDescription' required=false)
		 global Boolean useEmailHeader; */

		@InvocableVariable(
			label='Trigger Auto-Response Email for Leads and Cases'
			description='Indicates whether to trigger auto-response rules (true) or not (false), for leads and cases.'
			required=false
		)
		global Boolean triggerAutoResponseEmail;

		@InvocableVariable(
			label='Trigger Contact Email'
			description='Indicates whether to trigger email outside the organization (true) or not (false). Example: This email can be automatically triggered by creating, editing, or deleting a contact for a case.'
			required=false
		)
		global Boolean triggerOtherEmail;

		@InvocableVariable(
			label='Trigger User Email'
			description='This email can be automatically triggered by a number of events; resetting a password, creating a new user, or creating or modifying a task.'
			required=false
		)
		global Boolean triggerUserEmail;

		@InvocableVariable(
			label='Allow Field Truncation'
			description='Specifies the truncation behavior of large strings. If you specify a value for a string and that value is too large, the value is truncated.'
			required=false
		)
		global Boolean allowFieldTruncation;

		@InvocableVariable(label='Returned Labels Language' description='Specifies the language of any labels that are returned by Apex.' required=false)
		global String localeOptions;

		@InvocableVariable(
			label='Fail if any records fail. (False to allow partial saves)'
			description='If optAllOrNone is set to true, all changes are rolled back if any record causes errors. The default for this property is false and successfully processed records are committed while records with errors aren\'t.'
			required=false
		)
		global Boolean optAllOrNone;
	}

	/**
	 * Return wrapper for SObject to use in next Flow steps
	 */
	global class DMLOptionResult {
		@InvocableVariable(label='Output Record' description='Record returned with DMLOptions' required=true)
		global SObject outputSObject;
	}
}