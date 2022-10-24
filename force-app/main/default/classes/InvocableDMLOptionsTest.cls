/**
 * Tests for InvocableDMLOptions
 *
 * @author David Schach
 * @since  2022
 */
@IsTest
private class InvocableDMLOptionsTest {
	@isTest
	private static void testNewLeadTrue() {
		Id ruleId = null;
		List<AssignmentRule> rules = [SELECT Id, Active, Name, SobjectType FROM AssignmentRule WHERE SobjectType = 'Lead' AND active = TRUE];
		if (!rules.isEmpty()) {
			ruleId = rules[0].Id;
		} else {
			ruleId = null;
		}

		Lead l = new Lead(LastName = 'Smith', Company = 'Whovians');
		InvocableDMLOptions.DMLOptionRequest dmor = new InvocableDMLOptions.DMLOptionRequest();
		dmor.allowFieldTruncation = true;
		dmor.useAssignmentRule = true;
		dmor.assignmentRuleID = ruleId;
		dmor.allowSave = true;
		dmor.runAsCurrentUser = true;
		dmor.triggerUserEmail = true;
		dmor.triggerOtherEmail = true;
		dmor.triggerAutoResponseEmail = true;
		dmor.localeOptions = 'en_US';
		dmor.optAllOrNone = true;
		dmor.inputRecord = l;
		List<InvocableDMLOptions.DMLOptionRequest> dmlorList = new List<InvocableDMLOptions.DMLOptionRequest>{ dmor }; //NOPMD
		List<InvocableDMLOptions.DMLOptionResult> results = InvocableDMLOptions.execute(dmlorList); //NOPMD
	}

	@isTest
	private static void testNewLeadFalse() {
		Lead l = new Lead(LastName = 'Smith', Company = 'Whovians');
		InvocableDMLOptions.DMLOptionRequest dmor = new InvocableDMLOptions.DMLOptionRequest();
		dmor.allowFieldTruncation = false;
		dmor.useAssignmentRule = false;
		dmor.assignmentRuleID = null;
		dmor.allowSave = false;
		dmor.runAsCurrentUser = false;
		dmor.triggerUserEmail = false;
		dmor.triggerOtherEmail = false;
		dmor.triggerAutoResponseEmail = false;
		dmor.localeOptions = null;
		dmor.optAllOrNone = false;
		dmor.inputRecord = l;
		List<InvocableDMLOptions.DMLOptionRequest> dmlorList = new List<InvocableDMLOptions.DMLOptionRequest>{ dmor }; //NOPMD
		List<InvocableDMLOptions.DMLOptionResult> results = InvocableDMLOptions.execute(dmlorList); //NOPMD
	}
}