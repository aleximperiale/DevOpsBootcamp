@isTest
public with sharing class EmployeeTriggerHandlerTest {

    /*
        Runs before each test in this class, generates test data.
    */
    @testSetup
    private static void testSetup(){
        
        // Onboardings
        List<Onboarding__c> onboardings = new List<Onboarding__c>{
            new Onboarding__c(Name = 'Technical Consultant - First 90 Days', Type__c = 'Role'),
            new Onboarding__c(Name = 'Solution Consultant - First 90 Days', Type__c = 'Role')
        };
        insert onboardings;

        // Onboarding Activities
        insert new List<Onboarding_Activity__c> {
            new Onboarding_Activity__c(Onboarding__c = onboardings[0].Id, Name = 'Culture & Benefits', Type__c = 'Session', Expected_Duration__c = 240),
            new Onboarding_Activity__c(Onboarding__c = onboardings[0].Id, Name = 'App Customization Specialist', Type__c = 'Superbadge', Expected_Duration__c = 360, Trailhead_Points__c = 4500),
            new Onboarding_Activity__c(Onboarding__c = onboardings[1].Id, Name = 'Culture & Benefits', Type__c = 'Session', Expected_Duration__c = 240)
        };

    }

    @isTest
    private static void testInsertContacts() {

        // Get onboardings, we need IDs
        List<Onboarding__c> onboardings = [SELECT Id, Name FROM Onboarding__c];

        Test.startTest();

        // Insert some contacts
        List<Contact> contacts = new List<Contact>{
            new Contact(FirstName = 'Cliff', LastName = 'Gallagher', Onboarding__c = onboardings[0].Id),
            new Contact(FirstName = 'Alejandro', LastName = 'McQuirter', Onboarding__c = null),
            new Contact(FirstName = 'Farooq', LastName = 'Moreno', Onboarding__c = onboardings[1].Id)
        };

        insert contacts;

        Test.stopTest();

        // Verify results -- select contacts with their activity assignments
        // Sort by name so order is the same as above
        Map<Id, Contact> contactMap = new Map<Id, Contact>([
            SELECT Id, FirstName, LastName,
            (SELECT Id, Onboarding_Activity__r.Onboarding__c FROM Activity_Assignments__r)
            FROM Contact
        ]);

        // Check for expected number of assignments for each contact
        System.assertEquals(2, contactMap.get(contacts[0].Id).Activity_Assignments__r.size());
        System.assertEquals(0, contactMap.get(contacts[1].Id).Activity_Assignments__r.size());
        System.assertEquals(1, contactMap.get(contacts[2].Id).Activity_Assignments__r.size());

    }

    @isTest
    private static void testInsertContactsEmpty() {

        Test.startTest();

        // Insert some contacts with no onboardings
        List<Contact> contacts = new List<Contact>{
            new Contact(FirstName = 'Cliff', LastName = 'Gallagher', Onboarding__c = null),
            new Contact(FirstName = 'Alejandro', LastName = 'McQuirter', Onboarding__c = null),
            new Contact(FirstName = 'Farooq', LastName = 'Moreno', Onboarding__c = null)
        };

        insert contacts;

        Test.stopTest();

        // Verify results -- select contacts with their activity assignments -- no assignments expected
        System.assertEquals(0, [SELECT Id FROM Activity_Assignment__c].size());

    }

}