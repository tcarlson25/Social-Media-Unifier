Feature: Display metrics page when clicked
  As a user
  So that I can see who I am interacting with the most
  I want to view the metrics page when clicked on from the home page

Scenario: User accesses the metrics page
  Given The user is on the "home" page
  When They click on "Metrics"
  Then They should be redirected to the "Account Metrics" page