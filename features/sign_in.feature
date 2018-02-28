Feature: Sign in to twitter
  As a user
  So that I can view my social media feed
  I want to log into twitter

Scenario: Click Sign in to Twitter
  Given The user is on the "Sign In" page
  When The user clicks Sign in to Twitter 
  Then They should be redirected to the "Feed" page
