Feature: Display direct messages page when clicked
  As a user,
  So that I can communicate directly with all platforms in one location
  I want to see my direct messages when clicked on from the home page
  
@omniauth_test
Scenario: User accesses direct messages page
  Given The user is signed in
  Given The user is on the "home" page
  When They click on "Messages"
  Then They should be redirected to the "Direct Messages" page