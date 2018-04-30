# README

Things needed to deploy to heroku
  1. heroku
  2. github
  3. create developer application for Twitter, Facebook, Google, and Mastodon.social you will need the app tokens and secrets for these        sites.
  4. NOTE: for twitter the callback url is the url of the heroku app you will make later also add that url to the privacy policy and terms of service URL fields then navigate to permissions and check the get email field.
  

Steps to deploy to heroku
  1. fork from Social-medi-unifier repo https://github.com/tcarlson25/Social-Media-Unifier
  2. create new heroku app
  3. on heroku navigate to deploy and click on deploy with github and sign in with github when prompted.
  4. search for forked repo and click automatic deploy on push to Master branch.
  5. on the bottom of the page click manual deploy Master
  6. on heroku navigate to settings and click on reveal config vars
  7. add the following keys and their values from the developer apps you created.
        FACEBOOK_APP_ID
        FACEBOOK_SECRET
        GOOGLE_CLIENT_ID
        GOOGLE_SECRET
        MASTODON_KEY
        MASTODON_SECRET
        TWITTER_KEY
        TWITTER_SECRET
