Feature: Fetch feed for user
  As a user
  So that I can view all of my posts
  I want to fetch my posts and display them on my feed
  
Background: 
  Given The user is authenticated
  
  
@omniauth_test @omniauth_twitter_test @twitter_login_vcr
Scenario: Display Feed
  And The user is signed in with "Twitter"
  When The user visits the "home" page
  Then The user should see their "Twitter" posts
  
@omniauth_test @omniauth_twitter_test @twitter_login_vcr
Scenario: Display Notifications
  And The user is signed in with "Twitter"
  When The user visits the "Notifications" page
  Then They should be redirected to the "Notifications" page
  
  