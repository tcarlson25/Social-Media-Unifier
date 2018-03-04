Feature: Display custom friends page when clicked
  As a user,
  So that I can keep track of friend's usernames with one single name
  I want to see a page that allows me to create custom friends
  
@omniauth_test
Scenario: User accesses custom friends page
  Given The user is signed in
  Given The user is on the "home" page
  When They click on "Custom Friends"
  Then They should be redirected to the "Custom Friends" page