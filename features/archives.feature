 
Feature: Display archives page when clicked
  As a user,
  So that I can see all my saved/liked posts
  I want to see my saved/liked posts when clicked on from the home page
  
#@omniauth_test @twitter_login_vcr @javascript
#Scenario: User archives a twitter post
#  Given The user is authenticated
#  And The user is signed in with "Twitter"
#  And The user has archived posts
#  When They click on "Archives"
#  Then The archives are not empty
  
#@omniauth_test @twitter_login_vcr @javascript
#Scenario: User should not have archived twitter posts
#  Given The user is authenticated
#  And The user is signed in with "Twitter"
#  When They click on "Archives"
#  Then The archives are empty
  
#@omniauth_test @twitter_login_vcr @javascript
#Scenario: User unarchives a twitter post
#  Given The user is authenticated
#  And The user is signed in with "Twitter"
#  And The user has archived posts
#  When They unarchive a post
#  When They click on "Archives"
#  Then The archives are empty
  
#@omniauth_test @mastodon_login_vcr @javascript
#Scenario: The user should not have any archived mastodon posts
#  Given The user is authenticated
#  And The user is signed in with "Mastodon"
#  When They click on "Archives"
#  Then The archives are empty
  
#@omniauth_test @mastodon_login_vcr @javascript
#Scenario: The user archives a mastodon post
#  Given The user is authenticated
#  And The user is signed in with "Mastodon"
#  And The user has archived posts
#  When They click on "Archives"
#  Then The archives are not empty
  
#@omniauth_test @mastodon_login_vcr @javascript
#Scenario: User unarchives a mastodon post
#  Given The user is authenticated
#  And The user is signed in with "Mastodon"
#  And The user has archived posts
#  When They unarchive a post
#  When They click on "Archives"
#  Then The archives are empty
  
#Scenario: 
#  Given The user is not signed in
#  When The user visits the "Archives" page
#  Then They should be redirected to the "Sign In" page