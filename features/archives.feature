Feature: Display archives page when clicked
  As a user,
  So that I can see all my saved/liked posts
  I want to see my saved/liked posts when clicked on from the home page
  
@omniauth_test
Scenario: User accesses archived page
  Given The user is signed in
  Given The user is on the "home" page
  When They click on "Archives"
  Then They should be redirected to the "Archives" page
  
Scenario: 
  Given The user is not signed in
  When The user visits the "Archives" page
  Then They should be redirected to the "Sign In" page
    And They should see an error saying "Log in with Twitter to use this application"