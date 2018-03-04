Feature: Sign in to twitter
  As a user
  So that I can view my social media feed
  I want to log into twitter
  
@omniauth_test
Scenario: Click Sign in to Twitter
  Given The user is on the "Sign In" page
  When The user clicks Sign in to Twitter 
  Then The user should be populated
