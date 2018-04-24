Feature: Sign in to google
  As a user
  So that I can view my social media feed
  I want to log into google
  
@omniauth_test @omniauth_google_test
Scenario: Click Sign in to Google
  Given The user is not signed in
  Given The user is on the "Sign In" page
  When The user clicks Sign in to "Google" 
  Then They should be redirected to the "home" page
  
Scenario: 
  Given The user is not signed in
  When The user visits the "home" page
  Then They should be redirected to the "Sign In" page