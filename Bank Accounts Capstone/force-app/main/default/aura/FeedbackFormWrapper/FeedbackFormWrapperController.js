({
    navigateToFeedbackPage : function(component, event, helper) {
        var navService = component.find("navService");
        var pageReference = {
            type: "standard__navItemPage",
            attributes: {
                apiName: "Feedback_Page"
            }
        };
        navService.navigate(pageReference);
    }
})