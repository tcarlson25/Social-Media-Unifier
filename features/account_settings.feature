Feature: Display account settings when clicked
  As a user,
  So that I can modify my account settings
  I want to see my editable account when the tab is clicked on from the home page

Scenario: User accesses account settings from home page
  Given The user is on the "home" page
  When They click on "Settings"
  Then They should be redirected to the "Account Settings" page
    And They should see an option for "Social Media Accounts"
    And They should see an option for "Custom Friends"

Scenario: User accesses the metrics page
  Given The user is on the "home" page
  When They click on "Metrics"
  Then They should be redirected to the "Account Metrics" page
  
Scenario: User chooses to sign out
  Given The user is on the "home" page
  When They click on "Sign Out"
  Then They should be redirected to the "Login" page