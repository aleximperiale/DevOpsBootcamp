public with sharing class OnboardingController {

    @AuraEnabled(cacheable=true)
    public static ResponseWrapper getOnboardingSummary(String recordId) {

        // Initialize the response object that will be returned to the LWC
        ResponseWrapper response = new ResponseWrapper();

        // Set status and data object to the response object
        response.status = 'success';
        response.data = null;

        return response;
    }

    public class ResponseWrapper {
        @AuraEnabled public String status;
        @AuraEnabled public String errorMessage;
        @AuraEnabled public OnboardingData data;
    }

    public class OnboardingData {
        @AuraEnabled public String name;
        @AuraEnabled public Date startDate;
        @AuraEnabled public Date endDate;
        @AuraEnabled public String status;
        @AuraEnabled public String aheadBehind;
        @AuraEnabled public Decimal weekNo;
        @AuraEnabled public Decimal achieved;
        @AuraEnabled public Decimal target;
        @AuraEnabled public Decimal totalOnboarding;
    }
}