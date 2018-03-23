Feature: Display social media accounts page when clicked
  As a user,
  So that I can have access of specific social media accounts
  I want to sign in and out of individual social media platforms

@omniauth_test
Scenario: User accesses accounts page
  Given The user is signed in
  Given The user is on the "home" page
  When They click on "Accounts"
  Then They should be redirected to the "Accounts" page
  
Scenario: 
  Given The user is not signed in
  When The user visits the "Accounts" page
  Then They should be redirected to the "Sign In" page
  And They should see an error saying "Log in"