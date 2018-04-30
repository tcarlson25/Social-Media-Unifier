Feature: Display custom friends page when clicked
  As a user,
  So that I can keep track of friend's usernames with one single name
  I want to see a page that allows me to create custom friends
  
@omniauth_test @twitter_login_vcr
Scenario: User accesses custom friends page
  Given The user is authenticated
  And The user is signed in with "Twitter"
  When They click on "Custom Friends"
  Then They should be redirected to the "Custom Friends" page
  
Scenario: 
  Given The user is not signed in
  When The user visits the "Custom Friends" page
  Then They should be redirected to the "Sign In" page