Feature: Display account settings when clicked
  As a user,
  So that I can modify my account settings
  I want to see my editable account when the tab is clicked on from the home page

@omniauth_test
Scenario: User accesses account settings from home page
  Given The user is signed in
  Given The user is on the "home" page
  When They click on "Settings"
  Then They should be redirected to the "Account Settings" page
  
Scenario: 
  Given The user is not signed in
  When The user visits the "Account Settings" page
  Then They should be redirected to the "Sign In" page
    And They should see an error saying "Log in"