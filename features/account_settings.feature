Feature: Display account settings when clicked
  As a user,
  So that I can modify my account settings
  I want to see my editable account when the tab is clicked on from the home page

Scenario: User accesses account settings from home page
  Given The user is on the home page
  When They click on Account Settings
  Then They should be redirected to the Account Settings page
