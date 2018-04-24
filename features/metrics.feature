Feature: Display metrics page when clicked
  As a user
  So that I can see who I am interacting with the most
  I want to view the metrics page when clicked on from the home page

@omniauth_test @twitter_login_vcr
Scenario: User accesses the metrics page
  Given The user is signed in and using "Twitter"
  #Given The user is on the "home" page
  When They click on "Metrics"
  Then They should be redirected to the "Account Metrics" page
  
Scenario: 
  Given The user is not signed in
  When The user visits the "Metrics" page
  Then They should be redirected to the "Sign In" page