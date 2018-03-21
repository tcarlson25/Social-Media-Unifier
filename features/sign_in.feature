Feature: Sign in to twitter
  As a user
  So that I can view my social media feed
  I want to log into twitter
  
@omniauth_test
Scenario: Click Sign in to Twitter
  Given The user is on the "Sign In" page
  When The user clicks Sign in to Twitter 
  Then The user should be populated
  
Scenario: Click Sign in to Facebook
  Given The user is on the "Sign In" page
  When The user clicks Sign in to Facebook
  Then the user should be populated
  
Scenario: 
  Given The user is not signed in
  When The user visits the "home" page
  Then They should be redirected to the "Sign In" page
    And They should see an error saying "Log in with Twitter to use this application"