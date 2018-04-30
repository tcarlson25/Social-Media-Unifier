# Social Media Unifier

Many people do not like managing many different social media accounts. The goal of this project is to target these individuals and build an interactive web-application that manages social media platforms in a single location.

## Deployment to Heroku

### Setup

#### Services

You will need an account with the following applications. More instructions on signing up can be found on their respective sites if you do not have one already.

* [Heroku](https://signup.heroku.com/) - Hosting platform
	* Select *Ruby* as Primary Development Language
	* Select *Create New App*
	* Enter your desired app name and create the app.
	* Click on Settings and scroll down to *Domains and Certificates*. Next to domain, 		your heroku app's url will be shown. Keep track of this, as it will be needed later.

* [GitHub](https://github.com/join) - Code management

#### Provider Applications

You will need to create a developer application for Twitter, Facebook, Masotdon (Mastodon.social), and Google in order to get their appropriate tokens and secrets.

##### Twitter Setup

* Create a new Twitter application [here](https://apps.twitter.com)
* For **Website**, put your heroku app's url from above
* For **Callback URL**, type in your Heroku app's url with the following appended to the end of your url: '/users/auth/twitter/callback'. For example, if your Heroku app's url is 'https://test-app.herokuapp.com', the url you would enter as a Redirect URI would be 'https://test-app.herokuapp.com/users/auth/twitter/callback' 
* Go to *Settings*, and fill in your Heroku app's url under both *Privacy Policy URL* and *Terms of Service URL*
* Make sure *Read and Write* is checked under Permissions as well as *Request email addresses from users*
* Click on the tab *Keys and Access Tokens*. Here you will find your Twitter API Key and Secret. Keep track of these.

##### Facebook Setup

* Create a new Facebook application [here](https://developers.facebook.com/apps)
* Once the App is created, add the following product
	* **Facebook Login**
		* Fill in *Site URL* with your Heroku app's url under the *Tell Us about Your 			Website*
		* On the left column, click on *Settings* under the new Facebook Login product
		* Under *Valid OAuth Redirect URIs*, type in your Heroku app's url with the 			following appended to the end of your url: '/users/auth/facebook/callback'. For 		example, if your Heroku app's url is 'https://test-app.herokuapp.com', the url 			you would enter as a Redirect URI would be 'https://test-app.herokuapp.com/users/auth/facebook/callback' 
		*  Go to *Settings* --> *Basic*, and get your App ID and App Secret

##### Mastodon Setup

* Create a new Mastodon application [here](https://mastodon.social/settings/applications)
* Use your Heroku app's url as the *Application Website*
* Under *Redirect URI*, remove the given one (if there exists a url already) and add your Heroku app's url with the following appended to the end of your url: '/users/auth/mastodon/callback'. For example, if your Heroku app's url is 'https://test-app.herokuapp.com', the url you would enter as a Redirect URI would be 'https://test-app.herokuapp.com/users/auth/mastodon/callback'
* Make sure all scopes are checked (read, write, follow)
* Once submitted, click on your newly created application to get your Client Key and Secret

##### Google Setup

* Create a new Google application [here](https://console.developers.google.com/apis/dashboard)
* Select *Create Project* and follow through the steps
* Click on *Enable APIs and Services*
* Add/Enable the **Contacts API** and **Google+ API**
* Go to *Credentials* --> *OAuth Consent Screen* and type in and type in a product name
* Go to the *Credentials* --> *Create Credentials* --> *OAuth Client ID*
* Click WebApplication and fill out your application name
* Under Authorized Redirect URIs, type in your Heroku app's url with the following appended to the end of your url: '/users/auth/google_oauth2/callback'. For example, if your Heroku app's url is 'https://test-app.herokuapp.com', the url you would enter as a Redirect URI would be 'https://test-app.herokuapp.com/users/auth/google_oauth2/callback'
* Keep track of your Client ID and Secret

### Deploy

You will first need to fork this project onto your own github repository. Once done, save the git url that links to your forked repo. The URL should be something like this: *https://github.com/[username]/Social-Media-Unifier*

Navigate to Heroku and go to the *Deploy* tab. Next to 'Deployment Method', click on *GitHub*. Once logged in with your GitHub account, type in the name of the forked repo in the box that says *repo-name*.

Navigate to the *Manual Deploy* section of your Heroku application a switch to the master branch. Click *Deploy Branch*.

Once your app has been successfully deployed, navigate to the *Settings* tab of your Heroku application and click on ***Reveal Config Vars***. Add the following KEY-VALUE pairs exactly as follows (caps included). Format is \<Key\> - \<Value\>.

* TWITTER_KEY - *Your Twitter Key from setup*
* TWITTER_SECRET - *Your Twitter Secret from setup*
* FACEBOOK_APP_ID - *Your Facebook App ID from setup*
* FACEBOOK_SECRET - *Your Facebook App Secret from setup*
* MASTODON_KEY - *Your Mastodon Key from setup*
* MASTODON_SECRET - *Your Mastodon Secret from setup*
* GOOGLE_CLIENT_ID - *Your Google Client ID from setup*
* GOOGLE_CLIENT_SECRET - *Your Google Client Secret from setup*

### Migrate Database

On Heroku, go to *Deploy* --> *Deployment Method* --> *Heroku Git*

Follow the steps up until the last section (*Deploy your changes*) to install the Heroku CLI and Clone the Repository. Do NOT deploy your changes. Stop after you have cloned your GitHub repository. Once finished, open up your command prompt/terminal and navigate to the cloned repo.

While in the directory of your cloned repo, type the following command:

```
heroku run rails db:migrate
```

Finally, at the top of the Heroku page, click on ***Open app*** to open up your newly deployed Social Media Unifier!

### Troubleshooting


* Heroku gives an error that something went wrong
	* Occasionally, Twitter's API fails to get a user's feed and causes a Parsing error that will cause the application to fail when trying to load the feed page. To fix this, navigate to *Resources* on Heroku and click on *Heroku Postgres :: Database*. Navigate to Settings and reset the database. Once reset, follow the steps above to migrate the database again.

* Facebook Login does not work
	* This may happen becasue of Facebook's privacy policy that has changed. In order to get full permissions, you must get your application reviewed by Facebook. To do this, go to *App Review* on your Facebook application and follow the instructions to make a submission.

## Built With

* Ruby on Rails
* JavaScript
* AJAX/JQuery
* HTML/CSS
* RSpec, Cucumber

## Authors

* **Tyler Carlson**
* **Jordan Blissett**
* **Christian Tovar**
* **Cesar Ortega**

