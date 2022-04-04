@isTest
public class TriggerHandlerTest 
{

    //Runs before each test in this class, generates test data.
    @testSetup
    private static void testSetup(){
        
        // Onboardings
        List<Onboarding__c> onboardings = new List<Onboarding__c>{
            new Onboarding__c(Name = 'Technical Consultant - First 90 Days', Type__c = 'Role')
        };
        insert onboardings;
    }
    
    //Method to test OA validation
    @isTest
    private static void testValidation()
    {
        try
        {
            List<Onboarding__c> onboardings = [SELECT Id, Name FROM Onboarding__c];
            Onboarding_Activity__c badOnboardingActivity = new Onboarding_Activity__c();
            badOnboardingActivity.Name = 'Test Bad';
            badOnboardingActivity.Onboarding__c = onboardings[0].Id;
            badOnboardingActivity.Type__c = 'Module';
            
            insert badOnboardingActivity;
        }
        catch(Exception ex)
        {
            Boolean expectedExceptionThrown =  ex.getMessage().contains(' is a Trailhead Module and requires Points > 0');
			System.AssertEquals(expectedExceptionThrown, true);
        }
    }
}