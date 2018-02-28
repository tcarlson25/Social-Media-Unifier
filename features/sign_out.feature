Feature: Display login page after logging out
  As a user
  So that I can log out of my account and have the option to log back in
  I want to be redirected to the log in screen after logging out of my account
  
Scenario: User chooses to sign out
  Given The user is on the "home" page
  When They click on "Sign Out"
  Then They should be redirected to the "Sign In" page