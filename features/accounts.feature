Feature: Display social media accounts page when clicked
  As a user,
  So that I can have access of specific social media accounts
  I want to sign in and out of individual social media platforms

@omniauth_test
Scenario: User accesses accounts page
  Given The user is signed in and using "Google"
  Given The user is on the "home" page
  When They click on "Accounts"
  Then They should be redirected to the "Accounts" page
  
Scenario: 
  Given The user is not signed in
  When The user visits the "Accounts" page
  Then They should be redirected to the "Sign In" page
  
  @omniauth_test @omniauth_twitter_test @twitter_login_vcr
Scenario: User signs into twitter
  Given The user is signed in and using "Google"
  When The user signs in to "Twitter"
  Then They should be redirected to the "home" page
  
@omniauth_test @omniauth_facebook_test @facebook_login_vcr
Scenario: The user signs into facebook
  Given The user is signed in and using "Google"
  When The user signs in to "Facebook" 
  Then They should be redirected to the "home" page
  
@omniauth_test @omniauth_twitter_test @twitter_login_vcr
Scenario: The user signs out of twitter
  Given The user is signed in and using "Twitter"
  When The user signs out of "Twitter"
  Then They should be redirected to the "home" page
  
@omniauth_test @omniauth_facebook_test @facebook_login_vcr
Scenario: The user signs out of facebook
  Given The user is signed in and using "Facebook"
  When The user signs out of "Facebook"
  Then They should be redirected to the "home" page