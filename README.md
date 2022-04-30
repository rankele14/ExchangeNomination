# README

## Introduction

The application is a Nomination Form Submission Site. The users can choose their respective university, fill out their contact information, and answer questions for each student that the admin sets. The Admin is able to add other admins to review forms, export information to a CSV format, set deadlines for the form, view all information, add universities, add users, set limits, and clear information. 


## Requirements

This code has been run and tested on:

- Ruby - 3.0.2p107
- Rails - 6.1.4.1
- Ruby Gems - Listed in `Gemfile`
- PostgreSQL - 13.3
- Nodejs - v16.9.1
- Yarn - 1.22.11
- Docker (Latest Container)


## External Deps

- Docker - Download latest version at https://www.docker.com/products/docker-desktop
- Heroku CLI - Download latest version at https://devcenter.heroku.com/articles/heroku-cli
- Git - Downloat latest version at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
- GitHub Desktop (Not needed, but HELPFUL) at https://desktop.github.com/

## Installation

Download this code repository by using git:

`git clone https://github.com/rankele14/ExchangeNomination.git`

## Tests

An RSpec test suite is available and can be ran using:

`rspec spec/`

You can run all the test cases by running. This will run both the unit and integration tests.
`rspec .`

## Execute Code

Run the following code in Powershell if using windows or the terminal using Linux/Mac

`docker run --rm -it --volume "$(pwd):/rails_app" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 dmartinez05/ruby_rails_postgresql:latest`

`cd rails_app`

Install the app

`bundle install`

`rails db:create`

`rails db:migrate`


Run the app
`rails server --binding=0.0.0.0`


The application can be seen using a browser and navigating to http://localhost:3000/


## Environmental Variables/Files

Google OAuth2 support requires two keys to function as intended: Client ID and Client Secret

Create a new file called application.yml in the /config folder and add the following lines:

  `GOOGLE_OAUTH_CLIENT_ID: 'YOUR_GOOGLE_OAUTH_CLIENT_ID_HERE'`

  `GOOGLE_OAUTH_CLIENT_SECRET: 'YOUR_GOOGLE_OAUTH_CLIENT_SECRET_HERE'`


## Deployment

Setup a Heroku account: https://signup.heroku.com/

From the heroku dashboard select `New` -> `Create New Pipline`

Name the pipeline, and link the respective git repo to the pipline

Our application does not need any extra options, so select `Enable Review Apps` right away

Click `New app` under review apps, and link your test branch from your repo

Under staging app, select `Create new app` and link your main branch from your repo

--------

To add enviornment variables to enable google oauth2 functionality, head over to the settings tab on the pipeline dashboard

Scroll down until `Reveal config vars`

Add both your client id and your secret id, with fields `GOOGLE_OAUTH_CLIENT_ID` and `GOOGLE_OAUTH_CLIENT_SECRET` respectively

Now once your pipeline has built the apps, select `Open app` to open the app

With the staging app, if you would like to move the app to production, click the two up and down arrows and select `Move to production`

And now your application is setup and in production mode!

## CI/CD

CI/CD has been implemented in the GitHub Actions in the repo here -> https://github.com/rankele14/ExchangeNomination/actions

## Support

Admins and Users looking for support should first look at their respective help pages.
